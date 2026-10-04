.text
.global _start
_start:
 stp x16, x17, [sp, #-16]!
 ldr x16, [x18, #664]
 cbz x16, store_handle
 ldr w16, [x16, #480]
 mov w17, #0x5624
 movk w17, #0x2154, lsl #16
 cmp w16, w17
 b.eq done
store_handle:
 str w1, [x0, #272]
done:
 ldp x16, x17, [sp], #16
 nop
