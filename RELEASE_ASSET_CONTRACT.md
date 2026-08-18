# Контракт автообновляемых релизов Ryazha

## Цель

Каждый компонент каталога должен предоставлять один основной установочный файл с постоянным именем. Тюнер загружает его по адресу:

```text
https://github.com/Dimasick-git/<репозиторий>/releases/latest/download/<asset>
```

GitHub автоматически перенаправляет такую ссылку к последнему опубликованному релизу. Поэтому после публикации следующей версии тюнер скачает новый пакет без изменения `package.ini`.

## Обязательные правила для каждого репозитория

| Правило | Требование |
|---|---|
| Версия не изменилась | Workflow обновляет основной asset текущего release; тег не создаётся. |
| Версия изменилась | Workflow создаёт новый тег `vX.Y.Z`, новый release и один основной asset. |
| Asset | В каждом release находится один установочный asset с постоянным именем из таблицы ниже. |
| Замена asset | Новый файл сначала загружается как временный, затем старый asset удаляется и временный получает основное имя. |
| Ошибка загрузки | Старый release asset не удаляется. |
| Структура ZIP | ZIP готов для распаковки в корень SD; внешние папки версий не допускаются. |
| Checksums | SHA-256 пишется в release notes или CI-артефакт, но не добавляется отдельным asset в release. |

## Постоянные asset-имена

| Репозиторий | Основной asset | Формат | Состояние |
|---|---|---|---|
| `ovlSysmodules` | `ovlSysmodules.zip` | SD-root ZIP | workflow подготовлен локально, ожидает публикации |
| `Ryazhahand-Overlay` | `sdout.zip` | SD-root ZIP | уже стабильный |
| `Ryazha-Status-Monitor` | `Ryazha-Status-Monitor.zip` | SD-root ZIP | требуется стандартизация |
| `RyazhaAI` | `ryazha-ai.nro` | NRO | уже стабильный |
| `RyazhaTune` | `RyazhTune.zip` | SD-root ZIP | уже стабильный |
| `SwitchWave` | `SwitchWave.zip` | SD-root ZIP | workflow подготовлен локально, ожидает публикации |
| `EdiZon` | `ovlEdiZon.ovl` | OVL | уже стабильный |
| `PPSSPP` | `PPSSPP.zip` | SD-root ZIP | уже стабильный |
| `Mission-Control` | `MissionControl.zip` | SD-root ZIP | workflow подготовлен локально, ожидает публикации |
| `AIO-Switch-Updater` | `Ryazhenka_AIO.zip` | SD-root ZIP | уже стабильный |
| `ReverseNX-RT` | `ReverseNX-RT.zip` | SD-root ZIP | workflow подготовлен локально, ожидает публикации |
| `Fizeau` | `Fizeau.zip` | SD-root ZIP | уже стабильный |
| `FPSLocker` | `FPSLocker.ovl` | OVL | уже стабильный |

## Связь с тюнером

В тюнере не будут указываться теги, номера версий или commit hash в URL. В `include/core.ini`, `include/overlays.ini` и `include/apps.ini` используются только `releases/latest/download/` и имена из этой таблицы.

Такой контракт избавляет каталог от ручных обновлений ссылок и от ZIP-дубликатов в релизах. Если проект меняет имя asset, его workflow нужно сначала привести к таблице, а затем публиковать следующий release.
