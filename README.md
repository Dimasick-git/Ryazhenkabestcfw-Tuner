# Ryazhenkabestcfw Tuner

## Версия 11.0.0

**Ryazhenkabestcfw Tuner v11.0.0** возвращает структуру и визуальный стиль опубликованного v10.6: вкладки **«Ряженка»** и **«Другое»**, компактные заголовки, отступы, подменю «Обновления» и «ПО и утилиты». Это мультитул для системных настроек, overlays и homebrew, а не новый абстрактный каталог.[1]

> **Тюнинг перенесён в Ryazha-clk с версии 3.0.0. Лимит зарядного тока настраивается только в его overlay.**

## Что сохранено из v10.6

| Раздел | Состояние v11.0.0 |
|---|---|
| Оболочка «Ряженка» / «Другое» | Восстановлена в стиле v10.6 |
| Обновление самого тюнера | Сохранено через GitHub Releases |
| ПО и утилиты | Сохранены разделы «Скачать», «Удалить» и «Модули Ряженка» |
| Системные настройки | Сохранены GPU Scheduler, USB 3.0, авто-перезагрузка, FPS и битрейт видеозахвата |
| Геймпады и эмуляторы | Сохранен отдельный раздел с Mission-Control и PPSSPP |
| Status Monitor presets | Удалены по решению автора |
| Лимит зарядного тока | Удалён из тюнера; перенесён в Ryazha-clk |

## Память и патчи

Старый локальный набор Atmosphère-патчей удалён. Вместо него встроен официальный **Memory Kit 1.0.2** от ppkantorski. Он содержит Memory Hack и настройку heap для Ultrahand; в меню есть отдельная команда обновления его ZIP из последнего официального release.[2]

Для совместимых Mariko с физической памятью 8 ГБ добавлен отдельный переключатель **«Принудительные 8 ГБ RAM»**. Его payload взят из тега `23-R5` Ultra Tuner; включение сохраняет текущий `/payload.bin` в `/config/Ryazhenka/8GB/` и заменяет основной payload, `atmosphere/reboot_payload.bin` и `bootloader/update.bin`.[3]

> Не включайте 8 ГБ-патч на обычной консоли с 4 ГБ RAM: это может вызвать загрузочную петлю. Пункт ограничен Mariko и не включается автоматически.

## Проекты Ряженка

Раздел **«ПО и утилиты → Модули Ряженка»** использует постоянные ссылки `releases/latest/download/<asset>`. После публикации следующего release соответствующий пункт получает новый package без изменения тюнера.

| Категория | Компоненты |
|---|---|
| Overlays и система | Ryazhahand Overlay, ovlSysmodules, Ryazha Status Monitor, EdiZon, FPSLocker, Fizeau, ReverseNX-RT, Ryazha-clk, RyazhaTune |
| Приложения | RyazhaAI, SwitchWave, Ryazhenka AIO Updater |
| Геймпады и эмуляторы | Mission-Control, PPSSPP |

Нерабочие или лишние старые источники Tesla Menu, Mod Alchemist и FTP-сервера удалены из меню загрузок. Не добавляются прежнее OC-ядро, CPU/GPU/RAM-профили, OC-пресеты, кривые вентиляторов, OC-loader.kip, старый автодетектор RAM и Status Monitor presets.

## Установка

Распакуйте release ZIP в корень SD-карты. Затем откройте Ryazhahand-Overlay и выберите `Ryazhenkabestcfw Tuner` во вкладке Packages.

```text
switch/.packages/
├── Ryazhenkabestcfw Tuner/
│   ├── package.ini
│   ├── Data/RyazhaClk/package.ini
│   ├── Data/System/Ultra/payload 8GB.bin
│   └── Data/Updater/
└── Memory Kit/
```

## References

[1]: https://github.com/Dimasick-git/Ryazhenkabestcfw-Tuner/releases/tag/v10.6 "Ryazhenkabestcfw Tuner v10.6 — GitHub Release"
[2]: https://github.com/ppkantorski/Memory-Kit/releases/tag/v1.0.2 "Memory Kit v1.0.2 — GitHub Release"
[3]: https://github.com/Ultra-NX/Ultra-Tuner/releases/tag/23-R5 "Ultra Tuner 23|R5 — GitHub Release"
