# nimQtGUI — Полный справочник библиотеки

> **Версия:** Qt6Gui · **Компилятор:** `nim cpp --passC:"-std=c++20"`  
> **Зависимости:** `nimQtUtils` (базовые типы), `nimQtFFI` (константы/enums)

---

## Содержание

1. [Установка и компиляция](#установка-и-компиляция)
2. [Opaque-типы](#opaque-типы)
3. [Псевдонимы типов](#псевдонимы-типов)
4. [Enums](#enums)
5. [QGuiApplication](#qguiapplication)
6. [QScreen](#qscreen)
7. [QColor](#qcolor)
8. [QFont](#qfont)
9. [QFontMetrics / QFontMetricsF](#qfontmetrics--qfontmetricsf)
10. [QFontDatabase](#qfontdatabase)
11. [QPixmap](#qpixmap)
12. [QImage](#qimage)
13. [QImageReader / QImageWriter](#qimagereader--qimagewriter)
14. [QIcon](#qicon)
15. [QCursor](#qcursor)
16. [QPen](#qpen)
17. [QBrush](#qbrush)
18. [Градиенты](#градиенты)
19. [QTransform](#qtransform)
20. [QMatrix4x4](#qmatrix4x4)
21. [Векторы и кватернионы](#векторы-и-кватернионы)
22. [QPainter](#qpainter)
23. [QPainterPath](#qpainterpath)
24. [QRegion](#qregion)
25. [QKeyEvent](#qkeyevent)
26. [QMouseEvent](#qmouseevent)
27. [QWheelEvent](#qwheelevent)
28. [QClipboard](#qclipboard)
29. [QMimeData](#qmimedata)
30. [QPalette](#qpalette)
31. [QSurfaceFormat](#qsurfaceformat)
32. [QWindow](#qwindow)
33. [QDesktopServices](#qdesktopservices)
34. [QMovie](#qmovie)
35. [QPageSize / QPageLayout](#qpagesize--qpagelayout)
36. [QColorSpace](#qcolorspace)
37. [Типы из nimQtUtils](#типы-из-nimqtutils)

---

## Установка и компиляция

### Флаги компилятора (MSYS2/Windows)

```nim
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

### Универсальная компиляция (pkg-config)

```bash
nim cpp --passC:"-std=c++20" \
  --passC:"$(pkg-config --cflags Qt6Gui)" \
  --passL:"$(pkg-config --libs Qt6Gui)" \
  app.nim
```

### Импорт

```nim
import nimQtUtils
import nimQtFFI
import nimQtGUI
```

---

## Opaque-типы

Все типы Qt6Gui представлены как непрозрачные объекты, импортируемые через `importcpp`.

| Тип Nim | C++ класс | Заголовок |
|---------|-----------|-----------|
| `QGuiApplication` | `QGuiApplication` | `<QGuiApplication>` |
| `QScreen` | `QScreen` | `<QScreen>` |
| `QWindow` | `QWindow` | `<QWindow>` |
| `QPainter` | `QPainter` | `<QPainter>` |
| `QPainterPath` | `QPainterPath` | `<QPainterPath>` |
| `QPen` | `QPen` | `<QPen>` |
| `QBrush` | `QBrush` | `<QBrush>` |
| `QFont` | `QFont` | `<QFont>` |
| `QFontMetrics` | `QFontMetrics` | `<QFontMetrics>` |
| `QFontMetricsF` | `QFontMetricsF` | `<QFontMetricsF>` |
| `QFontInfo` | `QFontInfo` | `<QFontInfo>` |
| `QImage` | `QImage` | `<QImage>` |
| `QPixmap` | `QPixmap` | `<QPixmap>` |
| `QBitmap` | `QBitmap` | `<QBitmap>` |
| `QPicture` | `QPicture` | `<QPicture>` |
| `QIcon` | `QIcon` | `<QIcon>` |
| `QCursor` | `QCursor` | `<QCursor>` |
| `QDrag` | `QDrag` | `<QDrag>` |
| `QTransform` | `QTransform` | `<QTransform>` |
| `QMatrix4x4` | `QMatrix4x4` | `<QMatrix4x4>` |
| `QVector2D` | `QVector2D` | `<QVector2D>` |
| `QVector3D` | `QVector3D` | `<QVector3D>` |
| `QVector4D` | `QVector4D` | `<QVector4D>` |
| `QQuaternion` | `QQuaternion` | `<QQuaternion>` |
| `QKeyEvent` | `QKeyEvent` | `<QKeyEvent>` |
| `QMouseEvent` | `QMouseEvent` | `<QMouseEvent>` |
| `QWheelEvent` | `QWheelEvent` | `<QWheelEvent>` |
| `QResizeEvent` | `QResizeEvent` | `<QResizeEvent>` |
| `QPaintEvent` | `QPaintEvent` | `<QPaintEvent>` |
| `QClipboard` | `QClipboard` | `<QClipboard>` |
| `QMimeData` | `QMimeData` | `<QMimeData>` |
| `QPalette` | `QPalette` | `<QPalette>` |
| `QStyleHints` | `QStyleHints` | `<QStyleHints>` |
| `QSurface` | `QSurface` | `<QSurface>` |
| `QSurfaceFormat` | `QSurfaceFormat` | `<QSurfaceFormat>` |
| `QBackingStore` | `QBackingStore` | `<QBackingStore>` |
| `QLinearGradient` | `QLinearGradient` | `<QLinearGradient>` |
| `QRadialGradient` | `QRadialGradient` | `<QRadialGradient>` |
| `QConicalGradient` | `QConicalGradient` | `<QConicalGradient>` |
| `QRegion` | `QRegion` | `<QRegion>` |
| `QPolygon` | `QPolygon` | `<QPolygon>` |
| `QPolygonF` | `QPolygonF` | `<QPolygonF>` |
| `QTextOption` | `QTextOption` | `<QTextOption>` |
| `QStaticText` | `QStaticText` | `<QStaticText>` |
| `QPageSize` | `QPageSize` | `<QPageSize>` |
| `QPageLayout` | `QPageLayout` | `<QPageLayout>` |
| `QColorSpace` | `QColorSpace` | `<QColorSpace>` |
| `QImageReader` | `QImageReader` | `<QImageReader>` |
| `QImageWriter` | `QImageWriter` | `<QImageWriter>` |
| `QMovie` | `QMovie` | `<QMovie>` |
| `QRawFont` | `QRawFont` | `<QRawFont>` |
| `QGlyphRun` | `QGlyphRun` | `<QGlyphRun>` |

---

## Псевдонимы типов

Удобные короткие псевдонимы для указателей:

| Псевдоним | Полный тип |
|-----------|-----------|
| `GuiApp` | `ptr QGuiApplication` |
| `Scr` | `ptr QScreen` |
| `Win` | `ptr QWindow` |
| `Pntr` | `ptr QPainter` |
| `Fnt` | `ptr QFont` |
| `Img` | `ptr QImage` |
| `Pxm` | `ptr QPixmap` |
| `Ico` | `ptr QIcon` |
| `Pal` | `ptr QPalette` |
| `MimeD` | `ptr QMimeData` |
| `Clip` | `ptr QClipboard` |
| `Mov` | `ptr QMovie` |

---

## Enums

### QPainterRenderHint

Подсказки рендеринга для `QPainter`.

| Значение | Описание |
|----------|----------|
| `Antialiasing = 0x01` | Сглаживание фигур |
| `TextAntialiasing = 0x02` | Сглаживание текста |
| `SmoothPixmapTransform = 0x04` | Плавные трансформации пикселмапов |
| `VerticalSubpixelPositioning = 0x08` | Субпиксельное позиционирование по вертикали |
| `LosslessImageRendering = 0x40` | Рендеринг без потерь |
| `NonCosmeticBrushPatterns = 0x80` | Некосметические паттерны кисти |

### QPainterCompositionMode

Режимы композиции (Porter-Duff + расширения).

| Значение | Описание |
|----------|----------|
| `CompositionMode_SourceOver = 0` | Источник поверх (по умолчанию) |
| `CompositionMode_DestinationOver = 1` | Назначение поверх |
| `CompositionMode_Clear = 2` | Очистить |
| `CompositionMode_Source = 3` | Только источник |
| `CompositionMode_Destination = 4` | Только назначение |
| `CompositionMode_SourceIn = 5` | Источник внутри |
| `CompositionMode_DestinationIn = 6` | Назначение внутри |
| `CompositionMode_SourceOut = 7` | Источник снаружи |
| `CompositionMode_DestinationOut = 8` | Назначение снаружи |
| `CompositionMode_SourceAtop = 9` | Источник наверх |
| `CompositionMode_DestinationAtop = 10` | Назначение наверх |
| `CompositionMode_Xor = 11` | Исключающее ИЛИ |
| `CompositionMode_Plus = 12` | Сложение |
| `CompositionMode_Multiply = 13` | Умножение |
| `CompositionMode_Screen = 14` | Экран |
| `CompositionMode_Overlay = 15` | Наложение |
| `CompositionMode_Darken = 16` | Затемнение |
| `CompositionMode_Lighten = 17` | Осветление |
| `CompositionMode_ColorDodge = 18` | Осветление цвета |
| `CompositionMode_ColorBurn = 19` | Затемнение цвета |
| `CompositionMode_HardLight = 20` | Жёсткий свет |
| `CompositionMode_SoftLight = 21` | Мягкий свет |
| `CompositionMode_Difference = 22` | Разница |
| `CompositionMode_Exclusion = 23` | Исключение |

### QFontStyleHint

| Значение | Описание |
|----------|----------|
| `AnyStyle = 0` | Любой стиль |
| `SansSerif = 2` | Шрифт без засечек (Helvetica) |
| `Serif = 1` | Шрифт с засечками (Times) |
| `Monospace = 7` | Моноширинный (Courier) |
| `Cursive = 5` | Курсивный |
| `Fantasy = 6` | Декоративный |
| `Decorative = 3` | Декоративный (устарело) |
| `System = 9` | Системный |

### QFontStyleStrategy

| Значение | Описание |
|----------|----------|
| `PreferDefault = 0x0001` | Предпочесть шрифт по умолчанию |
| `PreferBitmap = 0x0002` | Предпочесть растровый |
| `PreferDevice = 0x0004` | Предпочесть шрифт устройства |
| `PreferOutline = 0x0008` | Предпочесть контурный |
| `ForceOutline = 0x0010` | Принудительно контурный |
| `PreferMatch = 0x0020` | Предпочесть точное совпадение |
| `PreferQuality = 0x0040` | Предпочесть качество |
| `PreferAntialias = 0x0080` | Предпочесть сглаживание |
| `NoAntialias = 0x0100` | Без сглаживания |
| `NoSubpixelAntialias = 0x0800` | Без субпиксельного сглаживания |
| `PreferNoShaping = 0x1000` | Без формирования текста |
| `NoFontMerging = 0x8000` | Без слияния шрифтов |

### QPaletteColorRole

| Значение | Описание |
|----------|----------|
| `WindowText = 0` | Текст окна |
| `Button = 1` | Кнопка |
| `Light = 2` | Светлый элемент |
| `Midlight = 3` | Полусветлый элемент |
| `Dark = 4` | Тёмный элемент |
| `Mid = 5` | Средний элемент |
| `Text = 6` | Текст |
| `BrightText = 7` | Яркий текст |
| `ButtonText = 8` | Текст кнопки |
| `Base = 9` | Базовый фон |
| `Window = 10` | Фон окна |
| `Shadow = 11` | Тень |
| `Highlight = 12` | Выделение |
| `HighlightedText = 13` | Текст выделения |
| `Link = 14` | Ссылка |
| `LinkVisited = 15` | Посещённая ссылка |
| `AlternateBase = 16` | Альтернативный фон |
| `NoRole = 17` | Без роли |
| `ToolTipBase = 18` | Фон подсказки |
| `ToolTipText = 19` | Текст подсказки |
| `PlaceholderText = 20` | Текст-заполнитель |

### QPaletteColorGroup

| Значение | Описание |
|----------|----------|
| `Disabled = 0` | Отключённый виджет |
| `Active = 1` | Активный виджет |
| `Inactive = 2` | Неактивный виджет |
| `Normal = 1` | Псевдоним Active |

### QWindowState

| Значение | Описание |
|----------|----------|
| `WindowNoState = 0x00000000` | Нормальное состояние |
| `WindowMinimized = 0x00000001` | Свёрнуто |
| `WindowMaximized = 0x00000002` | Развёрнуто |
| `WindowFullScreen = 0x00000004` | Полноэкранный режим |
| `WindowActive = 0x00000008` | Активное окно |

### QPageSizeId

| Значение | Формат |
|----------|--------|
| `A0 = 5` | A0 |
| `A1 = 6` | A1 |
| `A2 = 7` | A2 |
| `A3 = 8` | A3 |
| `A4 = 0` | A4 |
| `A5 = 11` | A5 |
| `A6 = 74` | A6 |
| `A7 = 75` | A7 |
| `Letter = 2` | US Letter |
| `Legal = 3` | US Legal |
| `Executive = 4` | Executive |
| `B5 = 37` | ISO B5 |

### QPageLayoutOrientation

| Значение | Описание |
|----------|----------|
| `Portrait = 0` | Книжная ориентация |
| `Landscape = 1` | Альбомная ориентация |

### QSurfaceFormatProfile

| Значение | Описание |
|----------|----------|
| `NoProfile = 0` | Без профиля |
| `CoreProfile = 1` | Core Profile OpenGL |
| `CompatibilityProfile = 2` | Compatibility Profile OpenGL |

### QSurfaceFormatOption

| Значение | Описание |
|----------|----------|
| `StereoBuffers = 0x0001` | Стерео-буферы |
| `DebugContext = 0x0002` | Отладочный контекст |
| `DeprecatedFunctions = 0x0004` | Устаревшие функции |
| `ResetNotification = 0x0008` | Уведомление о сбросе |
| `ProtectedContent = 0x0010` | Защищённый контент |

---

## QGuiApplication

Синглтон основного приложения с GUI. Внутренний синглтон управляется через статическую переменную `_nim_gui_app`.

### Создание и доступ

```nim
proc newGuiApp*(): GuiApp
```
Создаёт единственный экземпляр `QGuiApplication`. Вызывать только один раз.

```nim
proc guiAppInstance*(): GuiApp
```
Возвращает существующий экземпляр (или `nil`).

### Управление приложением

```nim
proc exec*(a: GuiApp): cint
```
Запускает цикл обработки событий. Блокирует до вызова `quit()`.

```nim
proc quit*(a: GuiApp)
```
Завершает цикл событий.

```nim
proc guiProcessEvents*()
```
Обрабатывает все ожидающие события без блокировки.

### Метаданные приложения

```nim
proc setAppName*(a: GuiApp, s: QString)
proc setOrgName*(a: GuiApp, s: QString)
proc setAppVersion*(a: GuiApp, s: QString)
proc setAppDisplayName*(a: GuiApp, s: QString)
```

### Внешний вид

```nim
proc setWindowIcon*(a: GuiApp, icon: QIcon)
proc setStyleSheet*(a: GuiApp, css: QString)
proc setPalette*(a: GuiApp, pal: QPalette)
```

### Экраны и буфер обмена

```nim
proc guiClipboard*(): Clip
proc guiPrimaryScreen*(): Scr
proc guiScreens*(): seq[Scr]
```

### DPI политика

```nim
proc guiHighDpiScaleFactorPolicy*(policy: cint)
```
Устанавливает политику округления для HiDPI масштабирования.

### Пример

```nim
let app = newGuiApp()
# ... создание окон ...
let code = app.exec()
```

---

## QScreen

Описание физического экрана.

```nim
proc screenName*(s: Scr): string
```
Имя экрана (например, `"HDMI-1"`).

```nim
proc screenGeometry*(s: Scr): NimRect
```
Полная геометрия экрана `(x, y, w, h)`.

```nim
proc screenAvailableGeometry*(s: Scr): NimRect
```
Доступная геометрия (без панелей задач и т.п.).

```nim
proc screenLogicalDpi*(s: Scr): tuple[x, y: float64]
proc screenPhysicalDpi*(s: Scr): tuple[x, y: float64]
```
Логическое и физическое DPI по осям X/Y.

```nim
proc screenDevicePixelRatio*(s: Scr): float64
```
Коэффициент масштабирования устройства (1.0, 1.5, 2.0...).

```nim
proc screenRefreshRate*(s: Scr): float64
```
Частота обновления в Гц.

```nim
proc screenDepth*(s: Scr): int
```
Глубина цвета в битах.

```nim
proc screenOrientation*(s: Scr): cint
```
Текущая ориентация экрана.

---

## QColor

Представление цвета. Хранится по значению.

### Конструкторы

```nim
proc newColor*(r, g, b: int, a: int = 255): QColor
```
RGB(A) цвет, компоненты 0–255.

```nim
proc newColorF*(r, g, b: float64, a: float64 = 1.0): QColor
```
RGB(A) с вещественными компонентами 0.0–1.0.

```nim
proc newColorHsv*(h, s, v: int, a: int = 255): QColor
```
Цвет в пространстве HSV. Оттенок 0–359, насыщенность/яркость 0–255.

```nim
proc newColorHsl*(h, s, l: int, a: int = 255): QColor
```
Цвет в пространстве HSL.

```nim
proc newColorCmyk*(c, m, y, k: int, a: int = 255): QColor
```
Цвет в пространстве CMYK.

```nim
proc newColorHex*(hex: string): QColor
```
Цвет из строки формата `"#RRGGBB"` или `"#AARRGGBB"`.

### Получение компонент

```nim
proc colorR*(c: QColor): int    # Красный 0–255
proc colorG*(c: QColor): int    # Зелёный 0–255
proc colorB*(c: QColor): int    # Синий 0–255
proc colorA*(c: QColor): int    # Альфа 0–255
proc colorRF*(c: QColor): float64  # Красный 0.0–1.0
proc colorGF*(c: QColor): float64
proc colorBF*(c: QColor): float64
proc colorAF*(c: QColor): float64
proc colorHsvH*(c: QColor): int    # Оттенок HSV
proc colorHsvS*(c: QColor): int    # Насыщенность HSV
proc colorHsvV*(c: QColor): int    # Яркость HSV
```

### Преобразования и утилиты

```nim
proc colorLighter*(c: QColor, factor: int = 150): QColor
```
Возвращает осветлённый цвет. `factor > 100` — осветление.

```nim
proc colorDarker*(c: QColor, factor: int = 200): QColor
```
Возвращает затемнённый цвет.

```nim
proc colorToHexStr*(c: QColor): string        # "#rrggbb"
proc colorToHexArgbStr*(c: QColor): string    # "#aarrggbb"
proc colorIsValid*(c: QColor): bool
proc colorToRgba*(c: QColor): NimColor        # → (r, g, b, a: uint8)
proc colorFromRgba*(nc: NimColor): QColor
proc colorSetAlpha*(c: QColor, a: int): QColor
```

```nim
proc colorInterpolate*(c1, c2: QColor, t: float64): QColor
```
Линейная интерполяция между двумя цветами. `t=0.0` → `c1`, `t=1.0` → `c2`.

### Пример

```nim
let red   = newColor(255, 0, 0)
let semi  = colorSetAlpha(red, 128)
let mixed = colorInterpolate(red, newColor(0, 0, 255), 0.5)
echo colorToHexStr(mixed)  # "#7f007f"
```

---

## QFont

Описание шрифта. Хранится по значению.

### Конструкторы

```nim
proc newFont*(): QFont
proc newFont*(family: string, pointSize: int = -1, weight: int = -1, italic: bool = false): QFont
```

### Чтение свойств

```nim
proc fontFamily*(f: QFont): string
proc fontFamilies*(f: QFont): seq[string]
proc fontPointSize*(f: QFont): int
proc fontPixelSize*(f: QFont): int
proc fontWeight*(f: QFont): int
proc fontBold*(f: QFont): bool
proc fontItalic*(f: QFont): bool
proc fontUnderline*(f: QFont): bool
proc fontStrikeOut*(f: QFont): bool
proc fontKerning*(f: QFont): bool
proc fontFixedPitch*(f: QFont): bool
proc fontLetterSpacing*(f: QFont): float64
proc fontWordSpacing*(f: QFont): float64
```

### Установка свойств (через указатель)

```nim
proc setFontFamily*(f: ptr QFont, family: string)
proc setFontFamilies*(f: ptr QFont, families: openArray[string])
proc setFontPointSize*(f: ptr QFont, ps: int)
proc setFontPixelSize*(f: ptr QFont, px: int)
proc setFontPointSizeF*(f: ptr QFont, ps: float64)
proc setFontBold*(f: ptr QFont, b: bool)
proc setFontItalic*(f: ptr QFont, b: bool)
proc setFontUnderline*(f: ptr QFont, b: bool)
proc setFontStrikeOut*(f: ptr QFont, b: bool)
proc setFontWeight*(f: ptr QFont, w: cint)
proc setFontLetterSpacing*(f: ptr QFont, stype: cint, spacing: float64)
proc setFontWordSpacing*(f: ptr QFont, spacing: float64)
proc setFontStyleHint*(f: ptr QFont, hint: QFontStyleHint)
proc setFontStyleStrategy*(f: ptr QFont, strat: QFontStyleStrategy)
proc setFontKerning*(f: ptr QFont, b: bool)
proc setFontFixedPitch*(f: ptr QFont, b: bool)
```

### Сериализация

```nim
proc fontToString*(f: QFont): string
proc fontFromString*(s: string): QFont
```

### Пример

```nim
var f = newFont("Arial", 14)
setFontBold(addr f, true)
setFontItalic(addr f, true)
```

---

## QFontMetrics / QFontMetricsF

Метрики шрифта (целочисленные и вещественные).

### QFontMetrics

```nim
proc newFontMetrics*(f: QFont): QFontMetrics
```

```nim
proc fmHeight*(fm: QFontMetrics): int          # Высота строки
proc fmAscent*(fm: QFontMetrics): int          # Выносной элемент над базовой линией
proc fmDescent*(fm: QFontMetrics): int         # Выносной элемент под базовой линией
proc fmLeading*(fm: QFontMetrics): int         # Межстрочный интервал
proc fmLineSpacing*(fm: QFontMetrics): int     # ascent + descent + leading
proc fmAverageCharWidth*(fm: QFontMetrics): int
proc fmMaxWidth*(fm: QFontMetrics): int        # Максимальная ширина символа
proc fmXHeight*(fm: QFontMetrics): int         # Высота строчной 'x'
proc fmCapHeight*(fm: QFontMetrics): int       # Высота заглавной буквы
```

```nim
proc fmHorizontalAdvance*(fm: QFontMetrics, text: string): int
```
Ширина строки в пикселях.

```nim
proc fmBoundingRect*(fm: QFontMetrics, text: string): NimRect
```
Ограничивающий прямоугольник строки.

```nim
proc fmElidedText*(fm: QFontMetrics, text: string, mode: cint, width: int): string
```
Усечённый текст с многоточием. `mode`: 0=Left, 1=Right, 2=Middle, 3=None.

### QFontMetricsF (вещественные)

```nim
proc newFontMetricsF*(f: QFont): QFontMetricsF
proc fmfHorizontalAdvance*(fm: QFontMetricsF, text: string): float64
proc fmfHeight*(fm: QFontMetricsF): float64
```

---

## QFontDatabase

Работа с базой данных шрифтов системы.

```nim
proc fontFamiliesList*(): seq[string]
```
Список всех доступных семейств шрифтов.

```nim
proc fontStyles*(family: string): seq[string]
```
Стили для конкретного семейства.

```nim
proc fontPointSizes*(family, style: string): seq[int]
```
Доступные кегли.

```nim
proc fontAddFile*(path: string): int
```
Загружает шрифт из файла. Возвращает ID (или -1 при ошибке).

```nim
proc fontAddFromData*(data: string): int
```
Загружает шрифт из данных в памяти.

```nim
proc fontRemove*(id: int)
```
Удаляет загруженный шрифт по ID.

```nim
proc fontIsSmoothlyScalable*(family, style: string): bool
proc fontIsFixedPitch*(family, style: string): bool
```

```nim
proc fontSystemDefault*(): QFont   # Системный шрифт общего назначения
proc fontSystemFixed*(): QFont     # Системный моноширинный шрифт
```

---

## QPixmap

Изображение, оптимизированное для отображения на экране.

> **Примечание:** `Pxm = ptr QPixmap` — управление памятью на ответственности разработчика.

### Создание

```nim
proc newPixmap*(w, h: int): Pxm
proc loadPixmap*(path: string): Pxm
```

### Свойства

```nim
proc pixmapWidth*(p: Pxm): int
proc pixmapHeight*(p: Pxm): int
proc pixmapIsNull*(p: Pxm): bool
proc pixmapDepth*(p: Pxm): int
proc pixmapDevicePixelRatio*(p: Pxm): float64
proc setPixmapDevicePixelRatio*(p: Pxm, ratio: float64)
```

### Трансформации

```nim
proc pixmapScaled*(p: Pxm, w, h: int, aspectMode: cint = 1, transformMode: cint = 0): Pxm
proc pixmapScaledToWidth*(p: Pxm, w: int, transformMode: cint = 0): Pxm
proc pixmapScaledToHeight*(p: Pxm, h: int, transformMode: cint = 0): Pxm
proc pixmapCopy*(p: Pxm, x, y, w, h: int): Pxm
proc pixmapTransformed*(p: Pxm, t: QTransform, mode: cint = 0): Pxm
```

`aspectMode`: 0=IgnoreAspectRatio, 1=KeepAspectRatio, 2=KeepAspectRatioByExpanding  
`transformMode`: 0=FastTransformation, 1=SmoothTransformation

### Заливка и сохранение

```nim
proc pixmapFill*(p: Pxm, c: QColor)
proc pixmapFillTransparent*(p: Pxm)
proc pixmapSave*(p: Pxm, path: string, format: string = "", quality: int = -1): bool
```

### Конвертация

```nim
proc pixmapToImage*(p: Pxm): QImage
proc pixmapFromImage*(img: QImage): Pxm
```

---

## QImage

Изображение в памяти с прямым доступом к пикселям.

### Создание

```nim
proc newImage*(w, h: int, fmt: QtImageFormat = Format_ARGB32): QImage
proc loadImage*(path: string): QImage
```

### Свойства

```nim
proc imageWidth*(img: QImage): int
proc imageHeight*(img: QImage): int
proc imageDepth*(img: QImage): int
proc imageIsNull*(img: QImage): bool
proc imageBytesPerLine*(img: QImage): int
proc imageSizeInBytes*(img: QImage): int64
proc imageFormat*(img: QImage): cint
proc imageColorCount*(img: QImage): int
proc imageDevicePixelRatio*(img: QImage): float64
proc setImageDevicePixelRatio*(img: var QImage, ratio: float64)
```

### Доступ к пикселям

```nim
proc imagePixel*(img: QImage, x, y: int): uint32
proc imageSetPixel*(img: var QImage, x, y: int, color: uint32)
proc imagePixelColor*(img: QImage, x, y: int): QColor
proc imageSetPixelColor*(img: var QImage, x, y: int, c: QColor)
proc imageFill*(img: var QImage, c: QColor)
proc imageFillValue*(img: var QImage, v: uint32)
proc imageBits*(img: QImage): pointer      # Прямой доступ к буферу
```

### Обработка изображений

```nim
proc imageScaled*(img: QImage, w, h: int, aspectMode: cint = 1, transformMode: cint = 0): QImage
proc imageConvertTo*(img: QImage, fmt: QtImageFormat): QImage
proc imageMirrored*(img: QImage, horizontal: bool = false, vertical: bool = true): QImage
```

### Сохранение и конвертация

```nim
proc imageSave*(img: QImage, path: string, format: string = "", quality: int = -1): bool
proc imageToPixmap*(img: QImage): Pxm
```

---

## QImageReader / QImageWriter

Чтение и запись изображений с расширенным контролем.

### QImageReader

```nim
proc newImageReader*(path: string): ptr QImageReader
proc imageReaderRead*(r: ptr QImageReader): QImage
proc imageReaderCanRead*(r: ptr QImageReader): bool
proc imageReaderFormat*(r: ptr QImageReader): string
proc imageReaderSize*(r: ptr QImageReader): NimSize
proc imageReaderErrorString*(r: ptr QImageReader): string
```

### QImageWriter

```nim
proc newImageWriter*(path: string): ptr QImageWriter
proc imageWriterWrite*(w: ptr QImageWriter, img: QImage): bool
proc imageWriterSetQuality*(w: ptr QImageWriter, q: int)
proc imageWriterSetFormat*(w: ptr QImageWriter, fmt: string)
proc imageWriterErrorString*(w: ptr QImageWriter): string
```

### Форматы

```nim
proc imageFormatsForReading*(): seq[string]
proc imageFormatsForWriting*(): seq[string]
```

---

## QIcon

Иконка с поддержкой тем и масштабирования.

```nim
proc newIcon*(): QIcon
proc loadIcon*(path: string): QIcon
proc iconFromPixmap*(p: Pxm): QIcon
proc iconFromTheme*(name: string): QIcon
proc iconHasThemeIcon*(name: string): bool
proc iconIsNull*(ico: QIcon): bool
```

```nim
proc iconAddFile*(ico: ptr QIcon, path: string, w: int = 0, h: int = 0)
proc iconAddPixmap*(ico: ptr QIcon, p: Pxm)
proc iconPixmap*(ico: QIcon, w, h: int): Pxm
```

```nim
proc iconSetThemeName*(name: string)
proc iconThemeName*(): string
```

---

## QCursor

Курсор мыши.

```nim
proc newCursor*(shape: QtCursorShape = ArrowCursor): QCursor
proc newCursorFromPixmap*(p: Pxm, hotX: int = -1, hotY: int = -1): QCursor
proc cursorShape*(c: QCursor): cint
proc cursorPos*(): NimPoint
proc setCursorPos*(x, y: int)
```

Значения `QtCursorShape` определены в `nimQtFFI` (например, `ArrowCursor`, `CrossCursor`, `WaitCursor` и т.д.).

---

## QPen

Перо для рисования линий и контуров.

### Создание

```nim
proc newPen*(): QPen
proc newPen*(c: QColor, width: float64 = 1.0, style: QtPenStyle = SolidLine): QPen
proc newPenStyle*(style: QtPenStyle): QPen
```

### Свойства

```nim
proc setPenColor*(p: var QPen, c: QColor)
proc setPenWidth*(p: var QPen, w: float64)
proc setPenStyle*(p: var QPen, s: QtPenStyle)
proc setPenCapStyle*(p: var QPen, s: QtPenCapStyle)
proc setPenJoinStyle*(p: var QPen, s: QtPenJoinStyle)
proc setPenMiterLimit*(p: var QPen, limit: float64)
proc setPenCosmetic*(p: var QPen, cosmetic: bool)
proc setPenDashPattern*(p: var QPen, pattern: openArray[float64])
proc setPenDashOffset*(p: var QPen, offset: float64)
```

```nim
proc penColor*(p: QPen): QColor
proc penWidthF*(p: QPen): float64
proc penWidth*(p: QPen): int
proc penIsCosmetic*(p: QPen): bool
```

> **Косметическое перо** — ширина не зависит от масштаба (всегда 1 пиксель на экране).

---

## QBrush

Кисть для заливки фигур.

### Создание

```nim
proc newBrush*(): QBrush
proc newBrush*(c: QColor, style: QtBrushStyle = SolidPattern): QBrush
proc newBrushFromPixmap*(p: Pxm): QBrush
proc newBrushFromLinearGradient*(g: QLinearGradient): QBrush
proc newBrushFromRadialGradient*(g: QRadialGradient): QBrush
proc newBrushFromConicalGradient*(g: QConicalGradient): QBrush
```

### Свойства

```nim
proc setBrushColor*(b: var QBrush, c: QColor)
proc setBrushStyle*(b: var QBrush, s: QtBrushStyle)
proc setBrushTexture*(b: var QBrush, p: Pxm)
proc brushColor*(b: QBrush): QColor
proc brushIsOpaque*(b: QBrush): bool
```

---

## Градиенты

### QLinearGradient — линейный градиент

```nim
proc newLinearGradient*(x1, y1, x2, y2: float64): QLinearGradient
proc linearGradientAddStop*(g: var QLinearGradient, pos: float64, c: QColor)
proc linearGradientSetSpread*(g: var QLinearGradient, spread: cint)
```

`spread`: 0=PadSpread, 1=RepeatSpread, 2=ReflectSpread

### QRadialGradient — радиальный градиент

```nim
proc newRadialGradient*(cx, cy, radius: float64): QRadialGradient
proc radialGradientAddStop*(g: var QRadialGradient, pos: float64, c: QColor)
```

### QConicalGradient — конический градиент

```nim
proc newConicalGradient*(cx, cy, angle: float64): QConicalGradient
proc conicalGradientAddStop*(g: var QConicalGradient, pos: float64, c: QColor)
```

### Пример

```nim
var grad = newLinearGradient(0, 0, 100, 0)
linearGradientAddStop(grad, 0.0, newColor(255, 0, 0))
linearGradientAddStop(grad, 1.0, newColor(0, 0, 255))
let brush = newBrushFromLinearGradient(grad)
```

---

## QTransform

Двумерная матрица аффинных преобразований (3×3).

```nim
proc newTransform*(): QTransform
proc transformTranslate*(t: var QTransform, dx, dy: float64)
proc transformScale*(t: var QTransform, sx, sy: float64)
proc transformRotate*(t: var QTransform, angle: float64)
proc transformShear*(t: var QTransform, sh, sv: float64)
proc transformReset*(t: var QTransform)
```

```nim
proc transformInverted*(t: QTransform): tuple[ok: bool, inv: QTransform]
proc transformIsIdentity*(t: QTransform): bool
proc transformMapPoint*(t: QTransform, x, y: float64): NimPointF
proc transformMapRect*(t: QTransform, r: NimRect): NimRectF
proc transformMultiply*(a, b: QTransform): QTransform
```

---

## QMatrix4x4

Матрица 4×4 для 3D преобразований.

```nim
proc newMatrix4x4*(): QMatrix4x4
proc m4Translate*(m: var QMatrix4x4, x, y, z: float64)
proc m4Scale*(m: var QMatrix4x4, x, y, z: float64)
proc m4Rotate*(m: var QMatrix4x4, angle: float64, x, y, z: float64)
proc m4LookAt*(m: var QMatrix4x4, eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ: float64)
proc m4Perspective*(m: var QMatrix4x4, fov, aspect, near, far: float64)
proc m4Ortho*(m: var QMatrix4x4, left, right, bottom, top, near, far: float64)
proc m4SetToIdentity*(m: var QMatrix4x4)
proc m4IsIdentity*(m: QMatrix4x4): bool
proc m4Inverted*(m: QMatrix4x4): tuple[ok: bool, inv: QMatrix4x4]
proc m4Transposed*(m: QMatrix4x4): QMatrix4x4
proc m4Multiply*(a, b: QMatrix4x4): QMatrix4x4
proc m4MapVector*(m: QMatrix4x4, x, y, z: float64): tuple[x, y, z: float64]
```

---

## Векторы и кватернионы

### QVector2D

```nim
proc newVec2*(x, y: float64): QVector2D
proc vec2X*(v: QVector2D): float64
proc vec2Y*(v: QVector2D): float64
proc vec2Length*(v: QVector2D): float64
proc vec2Normalized*(v: QVector2D): QVector2D
proc vec2Dot*(a, b: QVector2D): float64
```

### QVector3D

```nim
proc newVec3*(x, y, z: float64): QVector3D
proc vec3X*(v: QVector3D): float64
proc vec3Y*(v: QVector3D): float64
proc vec3Z*(v: QVector3D): float64
proc vec3Length*(v: QVector3D): float64
proc vec3Normalized*(v: QVector3D): QVector3D
proc vec3Dot*(a, b: QVector3D): float64
proc vec3Cross*(a, b: QVector3D): QVector3D
proc vec3Add*(a, b: QVector3D): QVector3D
proc vec3Sub*(a, b: QVector3D): QVector3D
proc vec3Scale*(v: QVector3D, s: float64): QVector3D
```

### QVector4D

```nim
proc newVec4*(x, y, z, w: float64): QVector4D
proc vec4X*(v: QVector4D): float64
proc vec4Y*(v: QVector4D): float64
proc vec4Z*(v: QVector4D): float64
proc vec4W*(v: QVector4D): float64
```

### QQuaternion

```nim
proc newQuaternion*(scalar, x, y, z: float64): QQuaternion
proc quaternionFromAxisAngle*(x, y, z, angle: float64): QQuaternion
proc quaternionFromEulerAngles*(pitch, yaw, roll: float64): QQuaternion
proc quaternionNormalized*(q: QQuaternion): QQuaternion
proc quaternionLength*(q: QQuaternion): float64
proc quaternionInverted*(q: QQuaternion): QQuaternion
proc quaternionMultiply*(a, b: QQuaternion): QQuaternion
proc quaternionRotateVector*(q: QQuaternion, x, y, z: float64): tuple[x, y, z: float64]
proc quaternionToMatrix*(q: QQuaternion): QMatrix4x4
proc quaternionGetAxisAngle*(q: QQuaternion): tuple[x, y, z, angle: float64]
```

---

## QPainter

Основной класс для 2D-рисования.

### Создание

```nim
proc newPainter*(): Pntr
proc newPainterOnPixmap*(p: Pxm): Pntr
proc newPainterOnImage*(img: ptr QImage): Pntr
```

```nim
proc painterBegin*(p: Pntr, dev: Pxm): bool
proc painterEnd*(p: Pntr): bool
proc painterIsActive*(p: Pntr): bool
```

### Настройки рендеринга

```nim
proc setRenderHint*(p: Pntr, hint: QPainterRenderHint, on: bool = true)
proc setRenderHints*(p: Pntr, hints: cint, on: bool = true)
proc setCompositionMode*(p: Pntr, mode: QPainterCompositionMode)
proc setOpacity*(p: Pntr, opacity: float64)
proc opacity*(p: Pntr): float64
```

### Инструменты рисования

```nim
proc setPen*(p: Pntr, pen: QPen)
proc setPenColor*(p: Pntr, c: QColor)
proc setPenStyle*(p: Pntr, style: QtPenStyle)
proc setNoPen*(p: Pntr)
proc setBrush*(p: Pntr, brush: QBrush)
proc setBrushColor*(p: Pntr, c: QColor)
proc setNoBrush*(p: Pntr)
proc setFont*(p: Pntr, font: QFont)
proc setBackground*(p: Pntr, brush: QBrush)
proc setBackgroundMode*(p: Pntr, mode: cint)
```

### Отсечение (clipping)

```nim
proc setClipRect*(p: Pntr, x, y, w, h: int, op: cint = 0)
proc setClipRectF*(p: Pntr, x, y, w, h: float64, op: cint = 0)
proc setClipRegion*(p: Pntr, region: QRegion, op: cint = 0)
proc setClipPath*(p: Pntr, path: QPainterPath, op: cint = 0)
proc setClipping*(p: Pntr, enable: bool)
```

`op` (ClipOperation): 0=ReplaceClip, 1=IntersectClip, 2=UniteClip

### Трансформации

```nim
proc setTransform*(p: Pntr, t: QTransform, combine: bool = false)
proc setWorldTransform*(p: Pntr, t: QTransform, combine: bool = false)
proc setWorldMatrixEnabled*(p: Pntr, enable: bool)
proc painterTranslate*(p: Pntr, dx, dy: float64)
proc painterScale*(p: Pntr, sx, sy: float64)
proc painterRotate*(p: Pntr, angle: float64)
proc painterShear*(p: Pntr, sh, sv: float64)
proc painterSave*(p: Pntr)
proc painterRestore*(p: Pntr)
```

### Рисование примитивов

```nim
proc drawLine*(p: Pntr, x1, y1, x2, y2: int)
proc drawLineF*(p: Pntr, x1, y1, x2, y2: float64)
proc drawRect*(p: Pntr, x, y, w, h: int)
proc drawRectF*(p: Pntr, x, y, w, h: float64)
proc fillRect*(p: Pntr, x, y, w, h: int, c: QColor)
proc fillRectF*(p: Pntr, x, y, w, h: float64, c: QColor)
proc fillRectBrush*(p: Pntr, x, y, w, h: int, brush: QBrush)
proc drawEllipse*(p: Pntr, x, y, w, h: int)
proc drawEllipseF*(p: Pntr, cx, cy, rx, ry: float64)
proc drawArc*(p: Pntr, x, y, w, h, startAngle, spanAngle: int)
proc drawPie*(p: Pntr, x, y, w, h, startAngle, spanAngle: int)
proc drawChord*(p: Pntr, x, y, w, h, startAngle, spanAngle: int)
proc drawRoundedRect*(p: Pntr, x, y, w, h: int, xRadius, yRadius: float64)
proc drawRoundedRectF*(p: Pntr, x, y, w, h, xRadius, yRadius: float64)
proc drawPoint*(p: Pntr, x, y: int)
proc drawPointF*(p: Pntr, x, y: float64)
proc drawPolygon*(p: Pntr, points: openArray[NimPoint])
proc drawPolygonF*(p: Pntr, points: openArray[NimPointF])
proc drawPolyline*(p: Pntr, points: openArray[NimPoint])
proc eraseRect*(p: Pntr, x, y, w, h: int)
```

> **Углы** дуг/секторов задаются в **1/16 градуса** (16 = 1°, 5760 = 360°).

### Рисование путей

```nim
proc drawPath*(p: Pntr, path: QPainterPath)
proc fillPath*(p: Pntr, path: QPainterPath, brush: QBrush)
proc strokePath*(p: Pntr, path: QPainterPath, pen: QPen)
```

### Рисование текста

```nim
proc drawText*(p: Pntr, x, y: int, text: string)
proc drawTextF*(p: Pntr, x, y: float64, text: string)
proc drawTextRect*(p: Pntr, x, y, w, h: int, flags: cint, text: string)
proc drawTextRectF*(p: Pntr, x, y, w, h: float64, flags: cint, text: string)
proc drawStaticText*(p: Pntr, x, y: int, text: string)
```

`flags` (Qt::AlignmentFlag | Qt::TextFlag): например `0x0001=AlignLeft`, `0x0002=AlignRight`, `0x0004=AlignHCenter`, `0x0020=AlignTop`, `0x0040=AlignBottom`, `0x0080=AlignVCenter`, `0x0100=TextWordWrap`.

### Рисование изображений

```nim
proc drawImage*(p: Pntr, x, y: int, img: QImage)
proc drawImageF*(p: Pntr, x, y: float64, img: QImage)
proc drawImageScaled*(p: Pntr, x, y, w, h: int, img: QImage)
proc drawImageSection*(p: Pntr, targetX, targetY, targetW, targetH: int,
                       img: QImage, srcX, srcY, srcW, srcH: int)
proc drawPixmap*(p: Pntr, x, y: int, pxm: Pxm)
proc drawPixmapF*(p: Pntr, x, y: float64, pxm: Pxm)
proc drawPixmapScaled*(p: Pntr, x, y, w, h: int, pxm: Pxm)
proc drawPixmapSection*(p: Pntr, tx, ty, tw, th: int, pxm: Pxm, sx, sy, sw, sh: int)
proc drawTiledPixmap*(p: Pntr, x, y, w, h: int, pxm: Pxm)
```

### Viewport

```nim
proc painterViewport*(p: Pntr): NimRect
proc setViewport*(p: Pntr, x, y, w, h: int)
proc setWindow*(p: Pntr, x, y, w, h: int)
```

### Пример: рисование на пикселмапе

```nim
let pxm = newPixmap(200, 200)
pixmapFill(pxm, newColor(255, 255, 255))
let painter = newPainterOnPixmap(pxm)
setRenderHint(painter, Antialiasing)
setPen(painter, newPen(newColor(255, 0, 0), 2.0))
drawRect(painter, 10, 10, 180, 180)
discard painterEnd(painter)
```

---

## QPainterPath

Составной путь из линий, дуг, кривых Безье.

### Создание

```nim
proc newPainterPath*(): QPainterPath
proc newPainterPathAt*(x, y: float64): QPainterPath
```

### Построение пути

```nim
proc ppMoveTo*(path: var QPainterPath, x, y: float64)
proc ppLineTo*(path: var QPainterPath, x, y: float64)
proc ppArcTo*(path: var QPainterPath, x, y, w, h, startAngle, sweepLength: float64)
proc ppCubicTo*(path: var QPainterPath, c1x, c1y, c2x, c2y, ex, ey: float64)
proc ppQuadTo*(path: var QPainterPath, cx, cy, ex, ey: float64)
proc ppCloseSubpath*(path: var QPainterPath)
```

### Добавление фигур

```nim
proc ppAddRect*(path: var QPainterPath, x, y, w, h: float64)
proc ppAddEllipse*(path: var QPainterPath, x, y, w, h: float64)
proc ppAddRoundedRect*(path: var QPainterPath, x, y, w, h, xr, yr: float64)
proc ppAddText*(path: var QPainterPath, x, y: float64, font: QFont, text: string)
proc ppAddPath*(path: var QPainterPath, other: QPainterPath)
```

### Булевы операции

```nim
proc ppUnited*(a, b: QPainterPath): QPainterPath
proc ppIntersected*(a, b: QPainterPath): QPainterPath
proc ppSubtracted*(a, b: QPainterPath): QPainterPath
```

### Запросы

```nim
proc ppContainsPoint*(path: QPainterPath, x, y: float64): bool
proc ppContainsRect*(path: QPainterPath, x, y, w, h: float64): bool
proc ppBoundingRect*(path: QPainterPath): NimRectF
proc ppIsEmpty*(path: QPainterPath): bool
proc ppElementCount*(path: QPainterPath): int
proc ppSimplified*(path: QPainterPath): QPainterPath
proc ppToFillPolygons*(path: QPainterPath, t: QTransform): seq[QPolygonF]
```

---

## QRegion

Область на экране (набор прямоугольников).

```nim
proc newRegion*(): QRegion
proc newRegionRect*(x, y, w, h: int): QRegion
proc regionUnited*(a, b: QRegion): QRegion
proc regionIntersected*(a, b: QRegion): QRegion
proc regionSubtracted*(a, b: QRegion): QRegion
proc regionXored*(a, b: QRegion): QRegion
proc regionIsEmpty*(r: QRegion): bool
proc regionContainsPoint*(r: QRegion, x, y: int): bool
proc regionBoundingRect*(r: QRegion): NimRect
proc regionTranslate*(r: var QRegion, dx, dy: int)
```

---

## QKeyEvent

Событие нажатия/отпускания клавиши.

```nim
proc keyEventKey*(e: ptr QKeyEvent): int
```
Код клавиши (`Qt::Key`, из `nimQtFFI`).

```nim
proc keyEventText*(e: ptr QKeyEvent): string
proc keyEventModifiers*(e: ptr QKeyEvent): cint
proc keyEventIsAutoRepeat*(e: ptr QKeyEvent): bool
proc keyEventCount*(e: ptr QKeyEvent): int
proc keyEventNativeScanCode*(e: ptr QKeyEvent): uint32
proc keyEventNativeVirtualKey*(e: ptr QKeyEvent): uint32
proc keyEventNativeModifiers*(e: ptr QKeyEvent): uint32
```

Модификаторы (`Qt::KeyboardModifier`): `0x02000000=Ctrl`, `0x04000000=Shift`, `0x08000000=Alt`, `0x10000000=Meta`.

---

## QMouseEvent

Событие мыши.

```nim
proc mouseEventPos*(e: ptr QMouseEvent): NimPoint          # Целочисленные координаты
proc mouseEventPosF*(e: ptr QMouseEvent): NimPointF        # Вещественные координаты
proc mouseEventGlobalPos*(e: ptr QMouseEvent): NimPoint    # Глобальные координаты
proc mouseEventButton*(e: ptr QMouseEvent): cint           # Кнопка (1=Left, 2=Right, 4=Mid)
proc mouseEventButtons*(e: ptr QMouseEvent): cint          # Все нажатые кнопки
proc mouseEventModifiers*(e: ptr QMouseEvent): cint
proc mouseEventSource*(e: ptr QMouseEvent): cint           # 0=Mouse, 1=TouchScreen, 2=Pen
```

---

## QWheelEvent

Событие колеса мыши.

```nim
proc wheelEventPos*(e: ptr QWheelEvent): NimPoint
proc wheelEventAngleDelta*(e: ptr QWheelEvent): NimPoint
```
`angleDelta.y` = вертикальное движение в 1/8 градуса (стандартный шаг = 120).

```nim
proc wheelEventPixelDelta*(e: ptr QWheelEvent): NimPoint   # Для трекпада
proc wheelEventButtons*(e: ptr QWheelEvent): cint
proc wheelEventModifiers*(e: ptr QWheelEvent): cint
proc wheelEventPhase*(e: ptr QWheelEvent): cint            # 0=NoScrollPhase, 1=Begin, 2=Update, 4=End
proc wheelEventInverted*(e: ptr QWheelEvent): bool         # Инверсия направления прокрутки
```

---

## QClipboard

Буфер обмена системы.

```nim
proc guiClipboard*(): Clip   # Получить из QGuiApplication
```

```nim
proc clipboardText*(c: Clip, mode: cint = 0): string
proc clipboardSetText*(c: Clip, text: string, mode: cint = 0)
proc clipboardPixmap*(c: Clip, mode: cint = 0): Pxm
proc clipboardSetPixmap*(c: Clip, p: Pxm, mode: cint = 0)
proc clipboardImage*(c: Clip, mode: cint = 0): QImage
proc clipboardSetImage*(c: Clip, img: QImage, mode: cint = 0)
proc clipboardMimeData*(c: Clip, mode: cint = 0): MimeD
proc clipboardSetMimeData*(c: Clip, d: MimeD, mode: cint = 0)
proc clipboardClear*(c: Clip, mode: cint = 0)
proc clipboardSupportsSelection*(c: Clip): bool
```

`mode`: 0=Clipboard, 1=Selection (X11), 2=FindBuffer (macOS).

---

## QMimeData

MIME-данные для буфера обмена и drag-and-drop.

```nim
proc newMimeData*(): MimeD
```

### Проверка наличия данных

```nim
proc mimeHasText*(d: MimeD): bool
proc mimeHasHtml*(d: MimeD): bool
proc mimeHasImage*(d: MimeD): bool
proc mimeHasUrls*(d: MimeD): bool
proc mimeHasFormat*(d: MimeD, fmt: string): bool
```

### Получение данных

```nim
proc mimeText*(d: MimeD): string
proc mimeHtml*(d: MimeD): string
proc mimeFormats*(d: MimeD): seq[string]
proc mimeData*(d: MimeD, fmt: string): string
proc mimeUrls*(d: MimeD): seq[string]
```

### Установка данных

```nim
proc mimeSetText*(d: MimeD, text: string)
proc mimeSetHtml*(d: MimeD, html: string)
proc mimeSetImage*(d: MimeD, img: QImage)
proc mimeSetData*(d: MimeD, fmt: string, data: string)
```

---

## QPalette

Набор цветов для виджетов.

```nim
proc newPalette*(): QPalette
proc paletteColor*(pal: QPalette, group: QPaletteColorGroup, role: QPaletteColorRole): QColor
proc paletteColorActive*(pal: QPalette, role: QPaletteColorRole): QColor
proc paletteSetColor*(pal: var QPalette, group: QPaletteColorGroup, role: QPaletteColorRole, color: QColor)
proc paletteSetColorAll*(pal: var QPalette, role: QPaletteColorRole, color: QColor)
proc paletteIsEqual*(a, b: QPalette, group: QPaletteColorGroup): bool
```

---

## QSurfaceFormat

Формат поверхности OpenGL.

```nim
proc newSurfaceFormat*(): QSurfaceFormat
proc sfSetVersion*(f: var QSurfaceFormat, major, minor: int)
proc sfSetProfile*(f: var QSurfaceFormat, profile: QSurfaceFormatProfile)
proc sfSetDepthBufferSize*(f: var QSurfaceFormat, size: int)
proc sfSetStencilBufferSize*(f: var QSurfaceFormat, size: int)
proc sfSetSamples*(f: var QSurfaceFormat, samples: int)    # Мультисэмплинг
proc sfSetSwapInterval*(f: var QSurfaceFormat, interval: int)  # 0=без vsync, 1=vsync
proc sfSetOption*(f: var QSurfaceFormat, opt: QSurfaceFormatOption)
proc sfMajorVersion*(f: QSurfaceFormat): int
proc sfMinorVersion*(f: QSurfaceFormat): int
proc sfSetDefaultFormat*(fmt: QSurfaceFormat)
```

### Пример настройки OpenGL 4.1 Core

```nim
var fmt = newSurfaceFormat()
sfSetVersion(fmt, 4, 1)
sfSetProfile(fmt, CoreProfile)
sfSetDepthBufferSize(fmt, 24)
sfSetSamples(fmt, 4)
sfSetDefaultFormat(fmt)
```

---

## QWindow

Нативное окно операционной системы.

### Создание и видимость

```nim
proc newQWindow*(parent: Win = nil): Win
proc windowShow*(w: Win)
proc windowHide*(w: Win)
proc windowClose*(w: Win)
proc windowRaise*(w: Win)
proc windowLower*(w: Win)
proc windowActivate*(w: Win)
```

### Заголовок и геометрия

```nim
proc windowSetTitle*(w: Win, title: string)
proc windowTitle*(w: Win): string
proc windowSetGeometry*(w: Win, x, y, width, height: int)
proc windowGeometry*(w: Win): NimRect
proc windowSetWidth*(w: Win, width: int)
proc windowSetHeight*(w: Win, height: int)
proc windowWidth*(w: Win): int
proc windowHeight*(w: Win): int
proc windowSetMinimumSize*(w: Win, width, height: int)
proc windowSetMaximumSize*(w: Win, width, height: int)
```

### Состояние

```nim
proc windowSetState*(w: Win, state: QWindowState)
proc windowState*(w: Win): cint
proc windowSetOpacity*(w: Win, opacity: float64)
proc windowOpacity*(w: Win): float64
proc windowIsVisible*(w: Win): bool
proc windowIsActive*(w: Win): bool
proc windowIsExposed*(w: Win): bool
```

### Внешний вид

```nim
proc windowSetCursor*(w: Win, cursor: QCursor)
proc windowUnsetCursor*(w: Win)
proc windowSetIcon*(w: Win, icon: QIcon)
proc windowSetFormat*(w: Win, fmt: QSurfaceFormat)
proc windowFormat*(w: Win): QSurfaceFormat
proc windowScreen*(w: Win): Scr
```

---

## QDesktopServices

Открытие URL и файлов во внешних приложениях.

```nim
proc openUrl*(url: string): bool
```
Открывает URL в браузере по умолчанию. Возвращает `false` при ошибке.

```nim
proc openFile*(path: string): bool
```
Открывает файл в ассоциированном приложении.

### Пример

```nim
discard openUrl("https://www.qt.io")
discard openFile("/home/user/document.pdf")
```

---

## QMovie

Воспроизведение анимированных изображений (GIF, WebP и др.).

```nim
proc newMovie*(path: string): Mov
proc movieStart*(m: Mov)
proc movieStop*(m: Mov)
proc moviePause*(m: Mov)
proc movieResume*(m: Mov)
proc movieIsValid*(m: Mov): bool
proc movieCurrentPixmap*(m: Mov): Pxm
proc movieCurrentImage*(m: Mov): QImage
proc movieFrameCount*(m: Mov): int
proc movieCurrentFrameNumber*(m: Mov): int
proc movieSetSpeed*(m: Mov, speed: int)    # 100 = нормальная скорость
proc movieSpeed*(m: Mov): int
proc movieSetScaledSize*(m: Mov, w, h: int)
proc movieJumpToFrame*(m: Mov, frame: int): bool
```

### Колбэк на смену кадра

```nim
type CBMovie* = proc(frameNumber: cint, ud: pointer) {.cdecl.}

proc movieOnFrameChanged*(m: Mov, cb: CBMovie, ud: pointer)
```

### Пример

```nim
let movie = newMovie("animation.gif")
movieOnFrameChanged(movie, proc(fn: cint, ud: pointer) {.cdecl.} =
  echo "Кадр: ", fn
, nil)
movieStart(movie)
```

---

## QPageSize / QPageLayout

Настройки страницы для печати.

### QPageSize

```nim
proc newPageSizeById*(id: QPageSizeId): QPageSize
proc newPageSizeCustom*(widthMM, heightMM: float64): QPageSize
proc pageSizeName*(ps: QPageSize): string
proc pageSizeRectMM*(ps: QPageSize): NimRectF     # Прямоугольник в мм
proc pageSizeSizeMM*(ps: QPageSize): NimSizeF     # Размер в мм
```

### QPageLayout

```nim
proc newPageLayout*(ps: QPageSize, orientation: QPageLayoutOrientation,
                   leftMM, topMM, rightMM, bottomMM: float64): QPageLayout
proc pageLayoutPaintRect*(pl: QPageLayout): NimRectF   # Область печати в мм
proc pageLayoutFullRect*(pl: QPageLayout): NimRectF    # Полная область в мм
proc pageLayoutIsValid*(pl: QPageLayout): bool
```

### Пример

```nim
let ps = newPageSizeById(A4)
let layout = newPageLayout(ps, Portrait, 20.0, 20.0, 20.0, 20.0)
echo pageLayoutPaintRect(layout)  # (x: 20, y: 20, w: 170, h: 257)
```

---

## QColorSpace

Цветовое пространство изображения.

```nim
proc newColorSpaceSRGB*(): QColorSpace
proc newColorSpaceDisplayP3*(): QColorSpace
proc colorSpaceIsValid*(cs: QColorSpace): bool
proc colorSpaceDescription*(cs: QColorSpace): string
```

---

## Типы из nimQtUtils

Вспомогательные Nim-типы, используемые по всей библиотеке:

| Тип | Определение | Описание |
|-----|-------------|----------|
| `NimPoint` | `tuple[x, y: int]` | Целочисленная точка |
| `NimPointF` | `tuple[x, y: float64]` | Вещественная точка |
| `NimRect` | `tuple[x, y, w, h: int]` | Целочисленный прямоугольник |
| `NimRectF` | `tuple[x, y, w, h: float64]` | Вещественный прямоугольник |
| `NimSize` | `tuple[w, h: int]` | Целочисленный размер |
| `NimSizeF` | `tuple[w, h: float64]` | Вещественный размер |
| `NimColor` | `tuple[r, g, b, a: uint8]` | Цвет RGBA |
| `QString` | C++ QString | Qt-строка (из nimQtFFI) |
| `QColor` | C++ QColor | Qt-цвет (value type) |
| `QtImageFormat` | enum | Форматы пикселей QImage |
| `QtPenStyle` | enum | Стили пера |
| `QtPenCapStyle` | enum | Стили торцов линий |
| `QtPenJoinStyle` | enum | Стили соединения линий |
| `QtBrushStyle` | enum | Стили кисти |
| `QtCursorShape` | enum | Формы курсора |

---

## Полный пример приложения

```nim
import nimQtUtils, nimQtFFI, nimQtGUI

let app = newGuiApp()
let scr  = guiPrimaryScreen()
let geo  = screenGeometry(scr)
echo "Экран: ", geo.w, "×", geo.h

# Создать пикселмап и нарисовать на нём
let pxm = newPixmap(400, 300)
pixmapFill(pxm, newColor(240, 240, 240))

let p = newPainterOnPixmap(pxm)
setRenderHint(p, Antialiasing)

# Заголовок
var font = newFont("Arial", 18)
setFontBold(addr font, true)
setFont(p, font)
setPenColor(p, newColor(20, 20, 20))
drawText(p, 20, 40, "Привет, Qt6 из Nim!")

# Кружок с градиентом
var grad = newRadialGradient(200.0, 150.0, 80.0)
radialGradientAddStop(grad, 0.0, newColor(255, 100, 100))
radialGradientAddStop(grad, 1.0, newColor(100, 0, 200))
setBrush(p, newBrushFromRadialGradient(grad))
setNoPen(p)
drawEllipse(p, 120, 70, 160, 160)

discard painterEnd(p)
discard pixmapSave(pxm, "output.png")

discard app.exec()
```

---

*Справочник сгенерирован по исходному коду `nimQtGUI.nim` — обёртке Qt6Gui для Nim (C++20).*
