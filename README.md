# Ryazhenkabestcfw Tuner

**EN:** Ultrahand `.packages/` toolset for Nintendo Switch (Atmosphere CFW). Multitool for overclocking, system settings, homebrew installation. Russian-localized fork of Ultra Tuner (redraz/UltraNX) adapted to the Ryazha ecosystem (Ryazhahand-Overlay, RCU, libryazhahand). Includes ppkantorski Memory Kit v1.0.2. License: MIT.

---

## Что это

`.packages/`-пакет для Ryazhahand-Overlay (Tesla совместимый), который даёт UI для:
- Разгона CPU/GPU/RAM (через KIP-патчи + RCU sysmodule).
- Управления частотами / напряжениями / DRAM.
- System settings: GPU scheduling, USB 3.0, charge speed, video bitrate.
- Установка/обновление overlay'ев и хоумбрю.
- Patch-менеджмент: Memory Kit (1.85MB / stripped / +40MB mesosphere), AOTAG temp sensor, 8GB RAM.
- Бэкапы OC-настроек.

## Состав

```
.packages/Ryazhenkabestcfw Tuner/
├── package.ini              -- главное меню (Ряженка / Другое)
├── boot_package.ini         -- автоматические патчи при загрузке
├── exit_package.ini         -- очистка при выходе
├── config.ini               -- runtime config (создаётся пакетом)
├── LICENSE
└── Data/
    ├── AtmosPatches/        -- старая система Atmosphere-патчей
    ├── Fans/                -- кривые охлаждения
    ├── MemoryKit/           -- ppkantorski Memory Kit v1.0.2
    ├── Presets/             -- пресеты CPU/GPU/RAM/DRAM
    ├── Tuner/               -- основные tuner-меню
    └── Updater/             -- Downloads.ini, Software.ini, RyazhaModules.ini
```

## Установка

1. Скачать `.zip` релиз → распаковать в корень SD-карты.
2. Pаспаковка положит `.packages/Ryazhenkabestcfw Tuner/` в `switch/.packages/` (Ultrahand convention).
3. Открыть Ryazhahand-Overlay (Tesla hotkey) → пакет «Ряженка» появится в списке.

**Требования:**
- Atmosphere CFW (актуальная).
- [Ryazhahand-Overlay](https://github.com/Dimasick-git/Ryazhahand-Overlay) или совместимый Ultrahand-форк.
- [nx-ovlloader](https://github.com/Dimasick-git/nx-ovlloader).
- KIP: рекомендуется RCU (`Dimasick-git/RCU`) для актуального loader.kip.

## Цветовые сигналы

Пакет использует встроенную систему `info_text_color` из libryazhahand:
- 🟢 `healthy_ram` (#00FF00) — безопасные операции (download official релизов).
- 🟡 `neutral_ram` (#FFAA00) — внимание (Memory Kit, изменение mesosphere).
- 🔴 `warning_text` (#FF7777) — опасные (8GB RAM, +40MB патч, exosphere swap).

## Memory Kit интеграция

Под пунктом «Memory Kit» (Mariko-only) запускается ppkantorski Memory Kit v1.0.2 — выбор mesosphere варианта (1.85MB / stripped / +40MB) с поддержкой AMS 1.9 / 1.10 / 1.11.

## Версии

- **v11.0** (актуальная) — миграция на Dimasick-git аккаунт, Memory Kit v1.0.2, цветовые warnings, новые overlay URLs.
- v10.6 — последняя версия до миграции аккаунта.

## Лицензия

MIT. См. `.packages/Ryazhenkabestcfw Tuner/LICENSE`. Историческое происхождение — Ultra Tuner (redraz/UltraNX) → Ryazhenkabestcfw Tuner (Dimasick-git).

Atrtibutions: redraz (Ultra Tuner upstream), ppkantorski (Memory Kit + Ultrahand framework), Soul & Lightos, Dimasick-git.
