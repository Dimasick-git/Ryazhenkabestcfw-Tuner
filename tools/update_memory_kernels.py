"""Import the pinned Ultra R7 kernels, preserving Ryazhenka's legacy TLS ABI.

Usage: python tools/update_memory_kernels.py <Ultra Tuner/Data/Updater>
The two upstream hashes are mandatory; this is not a generic kernel patcher.
"""
from pathlib import Path
import hashlib
import struct
import sys

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / '.packages/Ryazhenkabestcfw Tuner/Data/Atmo-Patch/data'
UPSTREAM = {
    '1.85MB': '09d29111d0018bb6197f3a61e21d87b8c63c9daeb28d556011ed8206f5a5af58',
    '40MB': 'f3aebaf087cc1a97038c18725ebae62a64731f253e46e87d4e84c87eaa6cff23',
}

def branch(origin, target):
    delta = target - origin
    assert delta % 4 == 0 and -(1 << 27) <= delta < (1 << 27)
    return struct.pack('<I', 0x14000000 | ((delta // 4) & 0x3ffffff))

def unique(data, signature):
    assert data.count(signature) == 1
    return data.index(signature)

def patch(data):
    result = bytearray(data)
    # Scheduler tail: only omit the TLS +0x108 write, as in our source kernel.
    cpu = unique(data, bytes.fromhex('414e41f9000006cb208400f9c0035fd6')) + 8
    # CreateThread: preserve SDK handles, skip only creators with libnx ThreadVars.
    handle = unique(data, bytes.fromhex('404d41f9e10240b9011001b9')) + 8
    metadata = struct.unpack_from('<I', data, 8)[0]
    text_end = metadata + 0x14 + struct.unpack_from('<i', data, metadata + 0x1c)[0]
    assert text_end == 0x88000
    cave = text_end - 0x100
    guard = bytearray((ROOT / 'tools/legacy_tls_guard.bin').read_bytes())
    assert len(guard) == 44 and data[cave:cave + len(guard)] == bytes(len(guard))
    guard[-4:] = branch(cave + len(guard) - 4, handle + 4)
    result[cpu:cpu+4] = bytes.fromhex('1f2003d5')
    result[handle:handle+4] = branch(handle, cave)
    result[cave:cave+len(guard)] = guard
    # The main-thread initialization must remain intact.
    assert result[0x24db8:0x24dbc] == data[0x24db8:0x24dbc] == bytes.fromhex('011001b9')
    return bytes(result), cpu, handle

def verify(data, cpu, handle):
    from unicorn import Uc, UC_ARCH_ARM64, UC_MODE_ARM
    from unicorn.arm64_const import UC_ARM64_REG_X0, UC_ARM64_REG_X1, UC_ARM64_REG_X16, UC_ARM64_REG_X17, UC_ARM64_REG_X18, UC_ARM64_REG_SP
    for magic, has_tls in [(0, True), (0x21545624, True), (0x12345678, True), (0, False)]:
        uc = Uc(UC_ARCH_ARM64, UC_MODE_ARM)
        uc.mem_map(0x100000, 0xB0000)
        uc.mem_write(0x100000, data)
        uc.mem_map(0x300000, 0x10000)
        child, creator, tls, stack = 0x301000, 0x302000, 0x303000, 0x30f000
        uc.mem_write(creator + 664, struct.pack('<Q', tls if has_tls else 0))
        uc.mem_write(tls + 480, struct.pack('<I', magic))
        uc.mem_write(child + 272, struct.pack('<I', 0xdeadbeef))
        for reg, value in [(UC_ARM64_REG_X0, child), (UC_ARM64_REG_X1, 0x1234), (UC_ARM64_REG_X18, creator), (UC_ARM64_REG_SP, stack), (UC_ARM64_REG_X16, 0x1111), (UC_ARM64_REG_X17, 0x2222)]:
            uc.reg_write(reg, value)
        uc.emu_start(0x100000 + handle, 0x100000 + handle + 4, count=32)
        expected = 0xdeadbeef if magic == 0x21545624 and has_tls else 0x1234
        assert struct.unpack('<I', uc.mem_read(child + 272, 4))[0] == expected
        assert uc.reg_read(UC_ARM64_REG_X16) == 0x1111 and uc.reg_read(UC_ARM64_REG_X17) == 0x2222
        assert uc.reg_read(UC_ARM64_REG_SP) == stack
        uc.mem_write(child + 264, struct.pack('<Q', 0xabcdef))
        uc.emu_start(0x100000 + cpu, 0x100000 + cpu + 4, count=1)
        assert struct.unpack('<Q', uc.mem_read(child + 264, 8))[0] == 0xabcdef

if __name__ == '__main__':
    if sys.argv[1] == '--verify':
        for mode in UPSTREAM:
            data = (OUTPUT / f'mesosphere_{mode}_1.12.bin').read_bytes()
            handle = unique(data, bytes.fromhex('404d41f9e10240b9')) + 8
            cpu = unique(data, bytes.fromhex('414e41f9000006cb1f2003d5c0035fd6')) + 8
            assert data[handle:handle+4] == branch(handle, 0x87f00)
            verify(data, cpu, handle)
            print(mode, 'ARM64 compatibility checks passed')
        sys.exit(0)
    source = Path(sys.argv[1])
    for mode, expected in UPSTREAM.items():
        data = (source / f'mesosphere {mode}.bin').read_bytes()
        assert hashlib.sha256(data).hexdigest() == expected
        updated, cpu, handle = patch(data)
        verify(updated, cpu, handle)
        destination = OUTPUT / f'mesosphere_{mode}_1.12.bin'
        destination.write_bytes(updated)
        print(destination.name, hashlib.sha256(updated).hexdigest(), '5 ARM64 checks passed')
