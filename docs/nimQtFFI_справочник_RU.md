# nimQtFFI — Полный справочник библиотеки

> **Версия модуля:** `nimQtFFI.nim`
> **Совместимость Qt:** Qt 6.2 – Qt 6.11
> **Требуется:** Nim + C++ бэкенд (`nim cpp`), C++17 минимум (рекомендуется C++20)
> **Зависимости:** нет — самый нижний уровень системы обёрток Qt6

---

## Содержание

1. [Обзор](#1-обзор)
2. [Компиляция и настройка](#2-компиляция-и-настройка)
3. [Константы путей к библиотекам Qt6](#3-константы-путей-к-библиотекам-qt6)
4. [Платформенные константы](#4-платформенные-константы)
5. [Opaque-указатели (C-совместимые типы)](#5-opaque-указатели-c-совместимые-типы)
6. [Callback-типы](#6-callback-типы)
7. [Перечисления Qt (enums)](#7-перечисления-qt-enums)
8. [Runtime: версия Qt](#8-runtime-версия-qt)
9. [Математические хелперы](#9-математические-хелперы)
10. [Системная информация (QSysInfo)](#10-системная-информация-qsysinfo)
11. [Стандартные пути ОС (QStandardPaths)](#11-стандартные-пути-ос-qstandardpaths)
12. [Переменные окружения](#12-переменные-окружения)
13. [Файловая система](#13-файловая-система)
14. [Загрузка динамических библиотек](#14-загрузка-динамических-библиотек)
15. [Логирование и отладка](#15-логирование-и-отладка)
16. [Версионирование (QVersionNumber)](#16-версионирование-qversionnumber)
17. [Compile-time константы](#17-compile-time-константы)
18. [Таблица быстрого поиска](#18-таблица-быстрого-поиска)

---

## 1. Обзор

`nimQtFFI.nim` — фундаментальный модуль низкоуровневого Nim-интерфейса к Qt6.
Он не содержит высокоуровневых обёрток виджетов, а предоставляет:

- **Имена динамических библиотек Qt6** для `{.importc.}` / `dynlib`.
- **Opaque C-указатели** на ключевые Qt-объекты (для использования в FFI).
- **Callback-типы** для подключения Nim-процедур к Qt-сигналам.
- **Полный набор Qt namespace enum** — выровненные по размеру с C++ `int`.
- **Runtime-функции** для версии Qt, системной информации, путей ОС, файловой системы, логирования и математики.

Модуль является самым нижним уровнем и не зависит от других модулей проекта.

---

## 2. Компиляция и настройка

### Linux / macOS (через pkg-config — рекомендуется)

```nim
{.passC: gorge("pkg-config --cflags Qt6Core Qt6Gui Qt6Widgets").}
{.passL: gorge("pkg-config --libs Qt6Core Qt6Gui Qt6Widgets").}
```

Командная строка:

```bash
nim cpp --passC:"-std=c++20" \
  --passC:"$(pkg-config --cflags Qt6Core)" \
  --passL:"$(pkg-config --libs Qt6Core)" \
  app.nim
```

### Windows (MSYS2 UCRT64)

Пути, встроенные в модуль (задаются директивами `{.passC.}` / `{.passL.}`):

```
-IC:/msys64/ucrt64/include
-IC:/msys64/ucrt64/include/qt6
-IC:/msys64/ucrt64/include/qt6/QtWidgets
-IC:/msys64/ucrt64/include/qt6/QtGui
-IC:/msys64/ucrt64/include/qt6/QtCore
-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB
-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core
```

> При использовании на Linux/macOS замените `{.passC.}` на вызовы `pkg-config`.

---

## 3. Константы путей к библиотекам Qt6

Все имена библиотек формируются автоматически из:

```
имя = QtLibPrefix & "Qt6<Модуль>" & QtLibSuffix
```

| Константа | Модуль Qt | Описание |
|---|---|---|
| `libQt6Core` | QtCore | QObject, QCoreApplication, QThread, QTimer, QFile, … |
| `libQt6Gui` | QtGui | QFont, QPixmap, QPainter, QColor, QIcon, … |
| `libQt6Widgets` | QtWidgets | QApplication, QWidget, QPushButton, QDialog, … |
| `libQt6Network` | QtNetwork | QTcpSocket, QNetworkAccessManager, … |
| `libQt6Sql` | QtSql | QSqlDatabase, QSqlQuery, … |
| `libQt6Xml` | QtXml | QXmlStreamReader/Writer, QDomDocument, … |
| `libQt6Concurrent` | QtConcurrent | QtConcurrent::run, … |
| `libQt6DBus` | QtDBus | Межпроцессное взаимодействие D-Bus (Linux) |
| `libQt6OpenGL` | QtOpenGL | QOpenGLContext, QOpenGLFunctions, … |
| `libQt6OpenGLWidgets` | QtOpenGLWidgets | QOpenGLWidget |
| `libQt6Svg` | QtSvg | QSvgRenderer |
| `libQt6SvgWidgets` | QtSvgWidgets | QSvgWidget |
| `libQt6PrintSupport` | QtPrintSupport | QPrinter, QPrintDialog, … |
| `libQt6Pdf` | QtPdf | PDF-рендеринг (Qt 6.4+) |
| `libQt6PdfWidgets` | QtPdfWidgets | PDF-виджет (Qt 6.4+) |
| `libQt6WebEngineCore` | QtWebEngineCore | Веб-движок, ядро Chromium |
| `libQt6WebEngineWidgets` | QtWebEngineWidgets | Веб-виджеты |
| `libQt6WebEngineQuick` | QtWebEngineQuick | Быстрый веб-движок (QML) |
| `libQt6WebSockets` | QtWebSockets | WebSocket |
| `libQt6WebChannel` | QtWebChannel | WebChannel |
| `libQt6Positioning` | QtPositioning | Геопозиционирование |
| `libQt6Quick` | QtQuick | Qt Quick (QML) |
| `libQt6Multimedia` | QtMultimedia | Мультимедиа (Qt 6.2+) |
| `libQt6Charts` | QtCharts | Графики (Qt 6.2+) |
| `libQt6DataVisualization` | QtDataVisualization | 3D-визуализация данных (Qt 6.2+) |
| `libQt6HttpServer` | QtHttpServer | HTTP-сервер (Qt 6.4+) |
| `libQt6Graphs` | QtGraphs | Графы (Qt 6.6+, замена DataVisualization) |
| `libQt6Location` | QtLocation | Карты (Qt 6.5+) |
| `libQt6Bluetooth` | QtBluetooth | Bluetooth |
| `libQt6SerialPort` | QtSerialPort | Последовательный порт |
| `libQt6SerialBus` | QtSerialBus | CAN, LIN (SerialBus) |
| `libQt6StateMachine` | QtStateMachine | Конечные автоматы |
| `libQt6Scxml` | QtScxml | SCXML |

**Пример использования:**

```nim
proc createApp(argc: ptr cint, argv: ptr cstring): QCoreAppPtr
  {.importcpp: "new QCoreApplication(@)", dynlib: libQt6Core.}
```

---

## 4. Платформенные константы

### Вспомогательные константы имён библиотек

| Константа | Windows | macOS | Linux |
|---|---|---|---|
| `QtLibPrefix` | `""` | `"lib"` | `"lib"` |
| `QtLibSuffix` | `".dll"` | `".dylib"` | `".so.6"` |

### Платформенные флаги (compile-time)

| Константа | Тип | Значение |
|---|---|---|
| `QtPlatformWindows` | `bool` | `true` только на Windows |
| `QtPlatformLinux` | `bool` | `true` только на Linux |
| `QtPlatformMacos` | `bool` | `true` только на macOS |

**Пример:**

```nim
when QtPlatformWindows:
  echo "Запуск на Windows"
```

---

## 5. Opaque-указатели (C-совместимые типы)

Непрозрачные указатели на Qt-объекты. Используются в сигнатурах FFI-функций.

| Тип | Описание |
|---|---|
| `QCoreAppPtr` | Указатель на `QCoreApplication` |
| `QObjectPtr` | Указатель на `QObject` (базовый для всех Qt-объектов) |
| `QStringPtr` | Указатель на `QString` (строка, хранится на куче) |
| `QByteArrayPtr` | Указатель на `QByteArray` |
| `QVariantPtr` | Указатель на `QVariant` (тип-значение Qt) |

Все типы определены как `pointer`. Они не предоставляют типовой безопасности, но необходимы для взаимодействия с C++.

---

## 6. Callback-типы

Процедурные типы для подключения Nim-функций к Qt-сигналам. Все имеют соглашение о вызове `{.cdecl.}`.

| Тип | Сигнатура | Типичное использование |
|---|---|---|
| `CB` | `proc(ud: pointer)` | `clicked()`, `timeout()` — без параметров |
| `CBStr` | `proc(text: cstring, ud: pointer)` | `textChanged`, `fileSelected` |
| `CBInt` | `proc(value: cint, ud: pointer)` | `currentIndexChanged`, `valueChanged(int)` |
| `CBBool` | `proc(checked: cint, ud: pointer)` | `toggled`, `stateChanged` (1=true, 0=false) |
| `CBIdx` | `proc(row, col: cint, ud: pointer)` | `currentCellChanged`, `itemClicked(row, col)` |
| `CBDouble` | `proc(value: cdouble, ud: pointer)` | `valueChanged(double)` |
| `CBStrStr` | `proc(key, value: cstring, ud: pointer)` | Сигналы с парой ключ-значение |
| `CBIntStr` | `proc(index: cint, text: cstring, ud: pointer)` | Смешанные сигналы (индекс + текст) |

**Пример:**

```nim
proc onClicked(ud: pointer) {.cdecl.} =
  echo "Кнопка нажата"

var cb: CB = onClicked
```

> `ud` — пользовательские данные (user data), передаются неизменными через C++.

---

## 7. Перечисления Qt (enums)

Все перечисления объявлены с `{.size: sizeof(cint).}` для совместимости с C++ `int`.

### QtOrientation

Направление (для слайдеров, сплиттеров, заголовков таблиц).

| Значение | Число | Описание |
|---|---|---|
| `Horizontal` | `0x1` | Горизонтальное направление |
| `Vertical` | `0x2` | Вертикальное направление |

### QtAlignment

Флаги выравнивания текста и виджетов.

| Значение | Число | Описание |
|---|---|---|
| `AlignLeft` | `0x0001` | По левому краю |
| `AlignRight` | `0x0002` | По правому краю |
| `AlignHCenter` | `0x0004` | По центру горизонтально |
| `AlignJustify` | `0x0008` | По ширине (justify) |
| `AlignTop` | `0x0020` | По верхнему краю |
| `AlignBottom` | `0x0040` | По нижнему краю |
| `AlignVCenter` | `0x0080` | По центру вертикально |
| `AlignBaseline` | `0x0100` | По базовой линии текста |
| `AlignCenter` | `0x0084` | Полное центрирование (HCenter \| VCenter) |

### QtWindowType

Типы и флаги оформления окна.

| Значение | Число | Описание |
|---|---|---|
| `WF_Widget` | `0x00000000` | Встроенный виджет (дочерний) |
| `WF_Window` | `0x00000001` | Независимое окно верхнего уровня |
| `WF_Dialog` | `0x00000003` | Диалоговое окно |
| `WF_Sheet` | `0x00000005` | Прикреплённый лист (macOS) |
| `WF_Popup` | `0x00000009` | Всплывающее окно |
| `WF_Tool` | `0x00000011` | Вспомогательная панель инструментов |
| `WF_SplashScreen` | `0x0000000D` | Заставка |
| `WF_Desktop` | `0x00000041` | Рабочий стол |
| `WF_SubWindow` | `0x00000080` | Подокно (QMdiSubWindow) |
| `WF_ForeignWindow` | `0x00000101` | Внешнее окно другого приложения |
| `WF_CoverWindow` | `0x00000201` | Обложка (мобильные ОС) |
| `WF_FramelessWindowHint` | `0x00000800` | Без рамки окна |
| `WF_CustomizeWindowHint` | `0x02000000` | Кастомный набор декораций |
| `WF_WindowTitleHint` | `0x00001000` | Показать заголовок |
| `WF_WindowSystemMenuHint` | `0x00002000` | Системное меню |
| `WF_WindowMinimizeButtonHint` | `0x00004000` | Кнопка «Свернуть» |
| `WF_WindowMaximizeButtonHint` | `0x00008000` | Кнопка «Развернуть» |
| `WF_WindowCloseButtonHint` | `0x08000000` | Кнопка «Закрыть» |
| `WF_WindowContextHelpButtonHint` | `0x00010000` | Кнопка «?» (только Windows) |
| `WF_MacWindowToolBarButtonHint` | `0x10000000` | Кнопка тулбара (macOS) |
| `WF_WindowStaysOnTopHint` | `0x00040000` | Всегда поверх других окон |
| `WF_WindowStaysOnBottomHint` | `0x04000000` | Всегда под другими окнами |
| `WF_WindowTransparentForInput` | `0x00080000` | Не получает события мыши |
| `WF_WindowOverridesSystemGestures` | `0x00100000` | Перехватывает системные жесты |

### QtKeyboardModifier

Флаги клавиш-модификаторов.

| Значение | Число | Описание |
|---|---|---|
| `NoModifier` | `0x00000000` | Нет модификатора |
| `ShiftModifier` | `0x02000000` | Shift |
| `ControlModifier` | `0x04000000` | Ctrl (Cmd на macOS) |
| `AltModifier` | `0x08000000` | Alt |
| `MetaModifier` | `0x10000000` | Meta (Win на Windows, Ctrl на macOS) |
| `KeypadModifier` | `0x20000000` | Цифровая клавиатура |
| `GroupSwitchModifier` | `0x40000000` | GroupSwitch (Linux X11) |

### QtMouseButton

Кнопки мыши.

| Значение | Число | Описание |
|---|---|---|
| `NoButton` | `0x00000000` | Нет кнопки |
| `LeftButton` | `0x00000001` | Левая кнопка |
| `RightButton` | `0x00000002` | Правая кнопка |
| `MiddleButton` | `0x00000004` | Средняя (колёсико) |
| `BackButton` | `0x00000008` | «Назад» (боковая) |
| `ForwardButton` | `0x00000010` | «Вперёд» (боковая) |
| `TaskButton` | `0x00000020` | «Задача» |
| `ExtraButton4` | `0x00000040` | Дополнительная 4 |
| `ExtraButton5` | `0x00000080` | Дополнительная 5 |

### QtSortOrder

| Значение | Число | Описание |
|---|---|---|
| `AscendingOrder` | `0` | По возрастанию (A→Z, 0→9) |
| `DescendingOrder` | `1` | По убыванию (Z→A, 9→0) |

### QtCheckState

| Значение | Число | Описание |
|---|---|---|
| `Unchecked` | `0` | Снят |
| `PartiallyChecked` | `1` | Частично (tristate) |
| `Checked` | `2` | Установлен |

### QtItemFlag

Флаги элемента модели (QAbstractItemModel).

| Значение | Число | Описание |
|---|---|---|
| `ItemIsSelectable` | `1` | Можно выделить |
| `ItemIsEditable` | `2` | Можно редактировать |
| `ItemIsDragEnabled` | `4` | Можно перетащить (drag) |
| `ItemIsDropEnabled` | `8` | На элемент можно бросить (drop) |
| `ItemIsUserCheckable` | `16` | Имеет checkbox |
| `ItemIsEnabled` | `32` | Доступен для взаимодействия |
| `ItemIsAutoTristate` | `64` | Автоматический tristate |
| `ItemNeverHasChildren` | `128` | Не может иметь дочерних |
| `ItemIsUserTristate` | `256` | Пользователь управляет tristate |

### QtDockWidgetArea

| Значение | Число | Описание |
|---|---|---|
| `NoDockWidgetArea` | `0x00` | Нет области |
| `LeftDockWidgetArea` | `0x01` | Левая панель |
| `RightDockWidgetArea` | `0x02` | Правая панель |
| `TopDockWidgetArea` | `0x04` | Верхняя панель |
| `BottomDockWidgetArea` | `0x08` | Нижняя панель |
| `AllDockWidgetAreas` | `0x0f` | Все стороны |

### QtScrollBarPolicy

| Значение | Число | Описание |
|---|---|---|
| `ScrollBarAsNeeded` | `0` | Показывать только при необходимости |
| `ScrollBarAlwaysOff` | `1` | Всегда скрывать |
| `ScrollBarAlwaysOn` | `2` | Всегда показывать |

### QtFocusPolicy

| Значение | Число | Описание |
|---|---|---|
| `NoFocus` | `0` | Не получает фокус |
| `TabFocus` | `0x1` | Только по Tab |
| `ClickFocus` | `0x2` | Только по клику |
| `StrongFocus` | `0x11` | По Tab и клику (рекомендуется) |
| `WheelFocus` | `0x13` | StrongFocus + колёсико мыши |

### QtCursorShape

| Значение | Число | Описание |
|---|---|---|
| `ArrowCursor` | `0` | Обычная стрелка |
| `UpArrowCursor` | `1` | Стрелка вверх |
| `CrossCursor` | `2` | Перекрестие |
| `WaitCursor` | `3` | Ожидание (часы) |
| `IBeamCursor` | `4` | Текстовый курсор |
| `SizeVerCursor` | `5` | Изменение размера вертикально |
| `SizeHorCursor` | `6` | Изменение размера горизонтально |
| `SizeBDiagCursor` | `7` | Изменение размера ↗↙ |
| `SizeFDiagCursor` | `8` | Изменение размера ↖↘ |
| `SizeAllCursor` | `9` | Перемещение (все стороны) |
| `BlankCursor` | `10` | Невидимый курсор |
| `SplitVCursor` | `11` | Разделитель вертикальный |
| `SplitHCursor` | `12` | Разделитель горизонтальный |
| `PointingHandCursor` | `13` | Указательный палец (ссылки) |
| `ForbiddenCursor` | `14` | Запрещено |
| `WhatsThisCursor` | `15` | «Что это?» |
| `BusyCursor` | `16` | Занято |
| `OpenHandCursor` | `17` | Открытая ладонь |
| `ClosedHandCursor` | `18` | Закрытая ладонь (захват) |
| `DragCopyCursor` | `19` | Копирование при перетаскивании |
| `DragMoveCursor` | `20` | Перемещение при перетаскивании |
| `DragLinkCursor` | `21` | Создание ссылки при перетаскивании |

### QtTextFormat

| Значение | Число | Описание |
|---|---|---|
| `PlainText` | `0` | Чистый текст |
| `RichText` | `1` | HTML-разметка |
| `AutoText` | `2` | Qt определяет автоматически |
| `MarkdownText` | `3` | Markdown (Qt 5.14+) |

### QtConnectionType

| Значение | Число | Описание |
|---|---|---|
| `AutoConnection` | `0` | Qt выбирает автоматически (рекомендуется) |
| `DirectConnection` | `1` | Прямой вызов (в том же потоке) |
| `QueuedConnection` | `2` | Через очередь событий (безопасно между потоками) |
| `BlockingQueuedConnection` | `3` | Блокирующий межпоточный |
| `UniqueConnection` | `0x80` | Только одно соединение |
| `SingleShotConnection` | `0x100` | Одноразовое соединение (Qt 6.0+) |

### QtSizePolicyPolicy

| Значение | Число | Описание |
|---|---|---|
| `SPFixed` | `0` | Фиксированный размер |
| `SPMinimum` | `0x1` | Минимальный, не меньше sizeHint |
| `SPMaximum` | `0x4` | Максимальный, не больше sizeHint |
| `SPPreferred` | `0x8` | Предпочтительный |
| `SPExpanding` | `0x38` | Растягивается |
| `SPMinimumExpanding` | `0x31` | Минимум + растяжка |
| `SPIgnored` | `0x38` | Игнорировать sizeHint |

### QtLayoutDirection

| Значение | Число | Описание |
|---|---|---|
| `LeftToRight` | `0` | Слева направо (LTR) |
| `RightToLeft` | `1` | Справа налево (RTL: арабский, иврит) |
| `LayoutDirectionAuto` | `2` | Автоматически по локали |

### QtBrushStyle

| Значение | Число | Описание |
|---|---|---|
| `NoBrush` | `0` | Без заливки |
| `SolidPattern` | `1` | Сплошная заливка |
| `Dense1Pattern`–`Dense7Pattern` | `2`–`8` | Штриховка (плотная → редкая) |
| `HorPattern` | `9` | Горизонтальные линии |
| `VerPattern` | `10` | Вертикальные линии |
| `CrossPattern` | `11` | Решётка |
| `BDiagPattern` | `12` | Диагональ ↗ |
| `FDiagPattern` | `13` | Диагональ ↘ |
| `DiagCrossPattern` | `14` | Диагональная решётка |
| `LinearGradientPattern` | `15` | Линейный градиент |
| `RadialGradientPattern` | `16` | Радиальный градиент |
| `ConicalGradientPattern` | `17` | Конический градиент |
| `TexturePattern` | `24` | Текстура (изображение) |

### QtPenStyle

| Значение | Число | Описание |
|---|---|---|
| `NoPen` | `0` | Без линии |
| `SolidLine` | `1` | Сплошная |
| `DashLine` | `2` | Пунктирная (–  –  –) |
| `DotLine` | `3` | Точечная (·  ·  ·) |
| `DashDotLine` | `4` | Штрихпунктирная |
| `DashDotDotLine` | `5` | Двойная штрихпунктирная |
| `CustomDashLine` | `6` | Пользовательская |

### QtPenCapStyle

| Значение | Число | Описание |
|---|---|---|
| `FlatCap` | `0x00` | Обрезанный конец |
| `SquareCap` | `0x10` | Квадратный (выступает) |
| `RoundCap` | `0x20` | Круглый |

### QtPenJoinStyle

| Значение | Число | Описание |
|---|---|---|
| `MiterJoin` | `0x00` | Острый угол (стык) |
| `BevelJoin` | `0x40` | Скошенный |
| `RoundJoin` | `0x80` | Скруглённый |
| `SvgMiterJoin` | `0x100` | SVG-совместимый острый |

### QtFillRule

| Значение | Число | Описание |
|---|---|---|
| `OddEvenFill` | `0` | Чётность (odd-even) |
| `WindingFill` | `1` | Ненулевой обход (winding) |

### QtGlobalColor

| Значение | Число | Цвет |
|---|---|---|
| `color_black` | `2` | Чёрный (#000000) |
| `color_white` | `3` | Белый (#ffffff) |
| `color_darkGray` | `4` | Тёмно-серый (#808080) |
| `color_gray` | `5` | Серый (#a0a0a4) |
| `color_lightGray` | `6` | Светло-серый (#c0c0c0) |
| `color_red` | `7` | Красный (#ff0000) |
| `color_green` | `8` | Зелёный (#00ff00) |
| `color_blue` | `9` | Синий (#0000ff) |
| `color_cyan` | `10` | Голубой (#00ffff) |
| `color_magenta` | `11` | Пурпурный (#ff00ff) |
| `color_yellow` | `12` | Жёлтый (#ffff00) |
| `color_darkRed` | `13` | Тёмно-красный (#800000) |
| `color_darkGreen` | `14` | Тёмно-зелёный (#008000) |
| `color_darkBlue` | `15` | Тёмно-синий (#000080) |
| `color_darkCyan` | `16` | Тёмно-голубой (#008080) |
| `color_darkMagenta` | `17` | Тёмно-пурпурный (#800080) |
| `color_darkYellow` | `18` | Тёмно-жёлтый (#808000) |
| `color_transparent` | `19` | Прозрачный |

### QtItemDataRole

| Значение | Число | Описание |
|---|---|---|
| `DisplayRole` | `0` | Текст для отображения |
| `DecorationRole` | `1` | Иконка |
| `EditRole` | `2` | Значение для редактирования |
| `ToolTipRole` | `3` | Всплывающая подсказка |
| `StatusTipRole` | `4` | Строка в статусной строке |
| `WhatsThisRole` | `5` | Текст «Что это?» |
| `FontRole` | `6` | Шрифт |
| `TextAlignmentRole` | `7` | Выравнивание текста |
| `BackgroundRole` | `8` | Цвет фона |
| `ForegroundRole` | `9` | Цвет переднего плана |
| `CheckStateRole` | `10` | Состояние флажка |
| `AccessibleTextRole` | `11` | Текст для accessibility |
| `AccessibleDescriptionRole` | `12` | Описание для accessibility |
| `SizeHintRole` | `13` | Рекомендуемый размер |
| `InitialSortOrderRole` | `14` | Начальный порядок сортировки |
| `UserRole` | `256` | Начало пользовательских ролей |

### QtToolButtonStyle

| Значение | Число | Описание |
|---|---|---|
| `ToolButtonIconOnly` | `0` | Только иконка |
| `ToolButtonTextOnly` | `1` | Только текст |
| `ToolButtonTextBesideIcon` | `2` | Текст рядом с иконкой |
| `ToolButtonTextUnderIcon` | `3` | Текст под иконкой |
| `ToolButtonFollowStyle` | `4` | По стилю приложения |

### QtArrowType

| Значение | Число | Описание |
|---|---|---|
| `NoArrow` | `0` | Без стрелки |
| `UpArrow` | `1` | Вверх |
| `DownArrow` | `2` | Вниз |
| `LeftArrow` | `3` | Влево |
| `RightArrow` | `4` | Вправо |

### QtFrameShape / QtFrameShadow

**QtFrameShape:**

| Значение | Число | Описание |
|---|---|---|
| `NoFrame` | `0` | Без рамки |
| `Box` | `0x0001` | Прямоугольная рамка |
| `Panel` | `0x0002` | Панельная рамка |
| `WinPanel` | `0x0003` | Рамка в стиле Windows |
| `HLine` | `0x0004` | Горизонтальная линия |
| `VLine` | `0x0005` | Вертикальная линия |
| `StyledPanel` | `0x0006` | Рамка стиля |

**QtFrameShadow:**

| Значение | Число | Описание |
|---|---|---|
| `Plain` | `0x0010` | Без тени |
| `Raised` | `0x0020` | Выпуклый вид |
| `Sunken` | `0x0030` | Вдавленный вид |

### QtAspectRatioMode

| Значение | Число | Описание |
|---|---|---|
| `IgnoreAspectRatio` | `0` | Игнорировать пропорции |
| `KeepAspectRatio` | `1` | Сохранить (вписать) |
| `KeepAspectRatioByExpanding` | `2` | Сохранить (заполнить) |

### QtTransformationMode

| Значение | Число | Описание |
|---|---|---|
| `FastTransformation` | `0` | Быстрое, без сглаживания |
| `SmoothTransformation` | `1` | Сглаженное (медленнее) |

### QtImageFormat

| Значение | Число | Описание |
|---|---|---|
| `Format_Invalid` | `0` | Недопустимый формат |
| `Format_Mono` | `1` | 1 бит/пиксель |
| `Format_Indexed8` | `3` | 8 бит (индексированный) |
| `Format_RGB32` | `4` | 32 бит (0xffRRGGBB) |
| `Format_ARGB32` | `5` | 32 бит с альфа-каналом |
| `Format_ARGB32_Premultiplied` | `6` | 32 бит premultiplied |
| `Format_RGB16` | `7` | 16 бит (5-6-5) |
| `Format_RGB888` | `13` | 24 бит (8-8-8) |
| `Format_RGBA8888` | `17` | 32 бит RGBA |
| `Format_Alpha8` | `23` | 8 бит только альфа |
| `Format_Grayscale8` | `24` | 8 бит оттенки серого |
| `Format_Grayscale16` | `28` | 16 бит оттенки серого |
| `Format_RGBX16FPx4` | `30` | float16×4 (Qt 6.2+) |
| `Format_RGBA32FPx4` | `34` | float32×4 (Qt 6.2+) |
| `Format_CMYK8888` | `36` | 32 бит CMYK (Qt 6.8+) |

### QtFontWeight

| Значение | Число | Описание |
|---|---|---|
| `Thin` | `100` | Очень тонкий |
| `ExtraLight` | `200` | Сверхлёгкий |
| `Light` | `300` | Лёгкий |
| `Normal` | `400` | Обычный (Regular) |
| `Medium` | `500` | Средний |
| `DemiBold` | `600` | Полужирный |
| `Bold` | `700` | Жирный |
| `ExtraBold` | `800` | Очень жирный |
| `Black` | `900` | Сверхжирный |

### QtDateFormat

| Значение | Число | Описание |
|---|---|---|
| `TextDate` | `0` | Текстовый Qt (зависит от локали) |
| `ISODate` | `1` | ISO 8601: `yyyy-MM-dd` |
| `RFC2822Date` | `8` | RFC 2822 (email) |
| `ISODateWithMs` | `9` | ISO 8601 с миллисекундами |

### QtScrollHint

| Значение | Число | Описание |
|---|---|---|
| `EnsureVisible` | `0` | Элемент виден |
| `PositionAtTop` | `1` | В начале viewport |
| `PositionAtBottom` | `2` | В конце viewport |
| `PositionAtCenter` | `3` | По центру viewport |

### QtMatchFlag

| Значение | Число | Описание |
|---|---|---|
| `MatchExactly` | `0` | Точное совпадение |
| `MatchContains` | `1` | Подстрока |
| `MatchStartsWith` | `2` | Начало строки |
| `MatchEndsWith` | `3` | Конец строки |
| `MatchRegularExpression` | `4` | Регулярное выражение |
| `MatchWildcard` | `5` | Шаблон (* и ?) |
| `MatchCaseSensitive` | `16` | Учитывать регистр |
| `MatchRecursive` | `32` | Рекурсивный поиск |

### QtFindChildOption

| Значение | Число | Описание |
|---|---|---|
| `FindDirectChildrenOnly` | `0` | Только прямые потомки |
| `FindChildrenRecursively` | `1` | Рекурсивный поиск (по умолчанию) |

### QStandardButton

| Значение | Число | Описание |
|---|---|---|
| `StdBtnNone` | `0x00000000` | Нет кнопки |
| `StdBtnOk` | `0x00000400` | OK |
| `StdBtnSave` | `0x00000800` | Сохранить |
| `StdBtnSaveAll` | `0x00001000` | Сохранить всё |
| `StdBtnOpen` | `0x00002000` | Открыть |
| `StdBtnYes` | `0x00004000` | Да |
| `StdBtnYesToAll` | `0x00008000` | Да для всех |
| `StdBtnNo` | `0x00010000` | Нет |
| `StdBtnNoToAll` | `0x00020000` | Нет для всех |
| `StdBtnAbort` | `0x00040000` | Прервать |
| `StdBtnRetry` | `0x00080000` | Повторить |
| `StdBtnIgnore` | `0x00100000` | Игнорировать |
| `StdBtnClose` | `0x00200000` | Закрыть |
| `StdBtnCancel` | `0x00400000` | Отмена |
| `StdBtnDiscard` | `0x00800000` | Не сохранять |
| `StdBtnHelp` | `0x01000000` | Справка |
| `StdBtnApply` | `0x02000000` | Применить |
| `StdBtnReset` | `0x04000000` | Сбросить |
| `StdBtnRestoreDefaults` | `0x08000000` | Восстановить по умолчанию |

### QDialogButtonRole

| Значение | Число | Описание |
|---|---|---|
| `InvalidRole` | `-1` | Недопустимая роль |
| `AcceptRole` | `0` | Принять (OK/Yes/Save) |
| `RejectRole` | `1` | Отклонить (Cancel/No) |
| `DestructiveRole` | `2` | Разрушительное действие (Discard) |
| `ActionRole` | `3` | Произвольное действие |
| `HelpRole` | `4` | Справка |
| `YesRole` | `5` | Да |
| `NoRole` | `6` | Нет |
| `ResetRole` | `7` | Сброс настроек |
| `ApplyRole` | `8` | Применить (без закрытия) |

### QtTextInteractionFlag

| Значение | Число | Описание |
|---|---|---|
| `NoTextInteraction` | `0` | Недоступен |
| `TextSelectableByMouse` | `1` | Выделение мышью |
| `TextSelectableByKeyboard` | `2` | Выделение клавиатурой |
| `LinksAccessibleByMouse` | `4` | Ссылки — мышью |
| `LinksAccessibleByKeyboard` | `8` | Ссылки — клавиатурой |
| `TextEditable` | `16` | Редактируемый |
| `TextEditorInteraction` | `19` | Режим редактора |
| `BrowserTextInteraction` | `13` | Режим браузера |

### QtDropAction

| Значение | Число | Описание |
|---|---|---|
| `CopyAction` | `0x1` | Копирование |
| `MoveAction` | `0x2` | Перемещение |
| `LinkAction` | `0x4` | Создание ссылки |
| `IgnoreAction` | `0x0` | Игнорировать |
| `TargetMoveAction` | `0x8002` | Перемещение (целевой виджет) |

### QtKey

| Значение | Код | Описание |
|---|---|---|
| `Key_Escape` | `0x01000000` | Esc |
| `Key_Tab` | `0x01000001` | Tab |
| `Key_Backspace` | `0x01000003` | Backspace |
| `Key_Return` | `0x01000004` | Enter (основной) |
| `Key_Enter` | `0x01000005` | Enter (цифровой блок) |
| `Key_Delete` | `0x01000007` | Delete |
| `Key_Home` | `0x01000010` | Home |
| `Key_End` | `0x01000011` | End |
| `Key_Left` | `0x01000012` | ← |
| `Key_Up` | `0x01000013` | ↑ |
| `Key_Right` | `0x01000014` | → |
| `Key_Down` | `0x01000015` | ↓ |
| `Key_PageUp` | `0x01000016` | Page Up |
| `Key_PageDown` | `0x01000017` | Page Down |
| `Key_Shift` | `0x01000020` | Shift |
| `Key_Control` | `0x01000021` | Ctrl |
| `Key_Meta` | `0x01000022` | Meta/Win |
| `Key_Alt` | `0x01000023` | Alt |
| `Key_F1`–`Key_F12` | `0x01000030`–`0x0100003b` | Функциональные клавиши |
| `Key_Space` | `0x20` | Пробел |
| `Key_A`–`Key_Z` | `0x41`–`0x5A` | Буквы латиницы |
| `Key_0`–`Key_9` | `0x30`–`0x39` | Цифры |

### QStandardPathLocation

| Значение | Число | Описание |
|---|---|---|
| `DesktopLocation` | `0` | Рабочий стол |
| `DocumentsLocation` | `1` | Документы |
| `FontsLocation` | `2` | Системные шрифты |
| `ApplicationsLocation` | `3` | Папка приложений |
| `MusicLocation` | `4` | Музыка |
| `MoviesLocation` | `5` | Видео |
| `PicturesLocation` | `6` | Изображения |
| `TempLocation` | `7` | Временные файлы |
| `HomeLocation` | `8` | Домашний каталог |
| `AppLocalDataLocation` | `9` | Локальные данные приложения |
| `CacheLocation` | `10` | Кэш приложения |
| `GenericDataLocation` | `11` | Общие данные |
| `RuntimeLocation` | `12` | Runtime-файлы |
| `ConfigLocation` | `13` | Конфигурация приложения |
| `DownloadLocation` | `14` | Загрузки |
| `GenericCacheLocation` | `15` | Общий кэш |
| `GenericConfigLocation` | `16` | Общая конфигурация |
| `AppConfigLocation` | `17` | Конфигурация только этого приложения |
| `PublicShareLocation` | `18` | Публичная папка |
| `TemplatesLocation` | `19` | Шаблоны |
| `StateLocation` | `20` | Состояние приложения (Qt 5.14+) |
| `GenericStateLocation` | `21` | Общее состояние (Qt 5.14+) |

---

## 8. Runtime: версия Qt

| Функция | Сигнатура | Описание |
|---|---|---|
| `qtVersionStr` | `(): string` | Строка версии, напр. `"6.7.2"` |
| `qtVersionMajor` | `(): int` | Мажорная версия (всегда 6 для Qt6) |
| `qtVersionMinor` | `(): int` | Минорная версия |
| `qtVersionPatch` | `(): int` | Патч-версия |
| `qtVersionCheck` | `(major, minor, patch: int): bool` | Версия >= заданной? |

```nim
echo qtVersionStr()                     # "6.7.2"
if qtVersionCheck(6, 5, 0):
  echo "Qt 6.5+ — доступно QPermission API"
```

---

## 9. Математические хелперы

| Функция | Сигнатура | Описание |
|---|---|---|
| `qFuzzyCompare` | `(a, b: float64): bool` | Сравнение с учётом погрешности |
| `qFuzzyCompareF` | `(a, b: float32): bool` | То же для float32 |
| `qFuzzyIsNull` | `(a: float64): bool` | Близко к нулю? |
| `qRound` | `(a: float64): int` | Округление |
| `qRound64` | `(a: float64): int64` | Округление до int64 |
| `qAbs` | `(a: int): int` | Абсолютное значение целого |
| `qAbsF` | `(a: float64): float64` | Абсолютное значение вещественного |
| `qMax` | `(a, b: int): int` | Максимум целых |
| `qMin` | `(a, b: int): int` | Минимум целых |
| `qMaxF` | `(a, b: float64): float64` | Максимум вещественных |
| `qMinF` | `(a, b: float64): float64` | Минимум вещественных |
| `qBound` | `(lo, v, hi: int): int` | Ограничить целое диапазоном |
| `qBoundF` | `(lo, v, hi: float64): float64` | Ограничить вещественное диапазоном |
| `qDegreesToRadians` | `(degrees: float64): float64` | Градусы → радианы |
| `qRadiansToDegrees` | `(radians: float64): float64` | Радианы → градусы |
| `qNextPowerOfTwo` | `(n: uint32): uint32` | Следующая степень двойки |

```nim
let angle   = qDegreesToRadians(45.0)  # 0.7853...
let clamped = qBound(0, 150, 100)      # 100
let safe    = qFuzzyCompare(0.1 + 0.2, 0.3)  # true
```

---

## 10. Системная информация (QSysInfo)

### Отдельные функции

| Функция | Описание | Пример |
|---|---|---|
| `sysProductName()` | Полное название ОС | `"Windows 11 Version 23H2"` |
| `sysProductType()` | Тип ОС | `"windows"`, `"ubuntu"`, `"macos"` |
| `sysProductVersion()` | Версия ОС | `"11"`, `"22.04"`, `"14.0"` |
| `sysCpuArch()` | Архитектура CPU | `"x86_64"`, `"arm64"` |
| `sysBuildCpuArch()` | Архитектура сборки Qt | `"x86_64"` |
| `sysKernelType()` | Тип ядра | `"winnt"`, `"linux"`, `"darwin"` |
| `sysKernelVersion()` | Версия ядра | `"10.0.22621"` |
| `sysMachineHostName()` | Имя хоста | `"my-pc"` |
| `sysMachineUniqueId()` | UUID машины | UUID-строка |
| `sysBootUniqueId()` | ID текущей загрузки | Меняется при каждой загрузке |

### Тип `SysInfo` и функция `getSysInfo()`

```nim
type SysInfo* = object
  productName*, productType*, productVersion*: string
  cpuArch*, kernelType*, kernelVersion*: string
  hostName*, qtVersion*: string

let info = getSysInfo()
echo info.productName   # "Ubuntu 22.04.3 LTS"
echo info.qtVersion     # "6.7.2"
```

---

## 11. Стандартные пути ОС (QStandardPaths)

| Функция | Сигнатура | Описание |
|---|---|---|
| `standardPath` | `(loc): string` | Один записываемый путь |
| `standardPaths` | `(loc): seq[string]` | Все пути (включая системные) |
| `standardPathsFind` | `(loc, filename): string` | Найти файл в путях |
| `displayName` | `(loc): string` | Человекочитаемое название |

```nim
let docs = standardPath(DocumentsLocation)
# Linux: "/home/user/Documents"
# Windows: "C:/Users/user/Documents"

let cfg = standardPathsFind(ConfigLocation, "myapp/settings.ini")
```

---

## 12. Переменные окружения

| Функция | Сигнатура | Описание |
|---|---|---|
| `envValue` | `(key, default=""): string` | Получить значение |
| `envContains` | `(key): bool` | Существует ли переменная |
| `envKeys` | `(): seq[string]` | Все имена переменных |

```nim
let home = envValue("HOME")
let port = envValue("PORT", "8080")
if envContains("DEBUG_MODE"): enableDebug()
```

---

## 13. Файловая система

| Функция | Сигнатура | Описание |
|---|---|---|
| `dirExists` | `(path): bool` | Существует ли директория |
| `fileExists` | `(path): bool` | Существует ли файл |
| `mkPath` | `(path): bool` | Создать все директории (mkdir -p) |
| `fileSize` | `(path): int64` | Размер в байтах (-1 если нет) |
| `fileSuffix` | `(path): string` | Расширение без точки (`"gz"`) |
| `fileCompleteSuffix` | `(path): string` | Полное расширение (`"tar.gz"`) |
| `fileBaseName` | `(path): string` | Имя без расширения (`"doc"`) |
| `fileCompleteBaseName` | `(path): string` | Полное базовое имя (`"doc.tar"`) |
| `fileName` | `(path): string` | Имя файла с расширением |
| `dirName` | `(path): string` | Директория файла |
| `absPath` | `(path): string` | Абсолютный путь |
| `canonicalPath` | `(path): string` | Канонический путь (разрешает симлинки) |
| `isAbsPath` | `(path): bool` | Является ли путь абсолютным |
| `joinPath` | `(parts: varargs): string` | Объединить части пути |
| `pathSeparator` | `(): char` | Разделитель путей (`/` или `\`) |
| `cleanPath` | `(path): string` | Нормализовать путь |

```nim
let p = joinPath(standardPath(HomeLocation), "documents", "report.pdf")
if fileExists(p):
  echo "Размер: ", fileSize(p), " байт"
  echo "Расширение: ", fileSuffix(p)  # "pdf"
```

---

## 14. Загрузка динамических библиотек

### `qtLibIsLoaded(libName: string): bool`

```nim
if qtLibIsLoaded(libQt6WebEngineCore):
  enableBrowserTab()
```

### `qtLibVersion(libName: string): string`

Возвращает полный путь к файлу загруженной библиотеки.

```nim
echo qtLibVersion(libQt6Core)  # "/usr/lib/libQt6Core.so.6"
```

---

## 15. Логирование и отладка

| Функция | Уровень | Описание |
|---|---|---|
| `qDebug(msg)` | Debug | Отладочное сообщение |
| `qInfo(msg)` | Info | Информационное |
| `qWarning(msg)` | Warning | Предупреждение |
| `qCritical(msg)` | Critical | Критическая ошибка |
| `qFatalMsg(msg)` | Fatal | Фатальная ошибка + завершение процесса |
| `qSetMessagePattern(pattern)` | — | Формат вывода сообщений |
| `qSetLoggingRule(rule)` | — | Фильтрация категорий логов |
| `qSuppressMessages()` | — | Подавить весь вывод Qt |
| `qRestoreMessages()` | — | Восстановить стандартный обработчик |

```nim
qSetMessagePattern("%{time yyyy-MM-dd HH:mm:ss} [%{type}] %{message}")
qSetLoggingRule("*.debug=false\napp.network=true")

qDebug("Приложение запущено")
qWarning("Не удалось загрузить конфиг, используются значения по умолчанию")
```

---

## 16. Версионирование (QVersionNumber)

### `parseVersion(versionStr: string): tuple[major, minor, patch: int]`

```nim
let v = parseVersion("6.7.2")
echo v.major, ".", v.minor, ".", v.patch  # 6.7.2
```

### `compareVersions(a, b: string): int`

Возвращает `-1`, `0` или `1`.

```nim
if compareVersions(qtVersionStr(), "6.5.0") >= 0:
  echo "Поддерживается Qt 6.5+"
```

---

## 17. Compile-time константы

| Константа | Тип | Описание |
|---|---|---|
| `QtMinCppStandard` | `int = 17` | Минимальный стандарт C++ для Qt6 |
| `QtRecommendedCppStandard` | `int = 20` | Рекомендуемый стандарт C++ |
| `QtPlatformWindows` | `bool` | `true` на Windows |
| `QtPlatformLinux` | `bool` | `true` на Linux |
| `QtPlatformMacos` | `bool` | `true` на macOS |

```nim
when QtPlatformLinux:
  let libPath = "/usr/lib/x86_64-linux-gnu"
elif QtPlatformWindows:
  let libPath = "C:/Windows/System32"
```

---

## 18. Таблица быстрого поиска

| Что нужно | Символ | Раздел |
|---|---|---|
| Имя dll/so библиотеки Qt | `libQt6Core`, `libQt6Widgets`, … | §3 |
| Callback для кнопки | `CB` | §6 |
| Callback с текстом | `CBStr` | §6 |
| Выравнивание | `QtAlignment` | §7 |
| Тип окна | `QtWindowType` | §7 |
| Клавиши | `QtKey` | §7 |
| Форматы изображений | `QtImageFormat` | §7 |
| Версия Qt | `qtVersionStr`, `qtVersionCheck` | §8 |
| Сравнение float | `qFuzzyCompare` | §9 |
| Ограничение значения | `qBound`, `qBoundF` | §9 |
| Название ОС | `sysProductName`, `getSysInfo` | §10 |
| Папка документов | `standardPath(DocumentsLocation)` | §11 |
| Переменная окружения | `envValue` | §12 |
| Существование файла | `fileExists`, `dirExists` | §13 |
| Расширение файла | `fileSuffix`, `fileCompleteSuffix` | §13 |
| Нормализация пути | `cleanPath`, `absPath` | §13 |
| Опциональный модуль Qt | `qtLibIsLoaded` | §14 |
| Логирование | `qDebug`, `qWarning`, `qCritical` | §15 |
| Сравнение версий | `compareVersions` | §16 |
| Платформа (compile-time) | `QtPlatformLinux`, … | §17 |

---

*Справочник сгенерирован по исходному коду `nimQtFFI.nim`. Совместимость: Qt 6.2 – Qt 6.11.*
