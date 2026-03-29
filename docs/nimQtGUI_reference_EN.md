# nimQtGUI — Complete Library Reference

> **Version:** Qt6Gui · **Compiler:** `nim cpp --passC:"-std=c++20"`  
> **Dependencies:** `nimQtUtils` (base types), `nimQtFFI` (constants/enums)

---

## Table of Contents

1. [Setup and Compilation](#setup-and-compilation)
2. [Opaque Types](#opaque-types)
3. [Type Aliases](#type-aliases)
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
18. [Gradients](#gradients)
19. [QTransform](#qtransform)
20. [QMatrix4x4](#qmatrix4x4)
21. [Vectors and Quaternions](#vectors-and-quaternions)
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
37. [Types from nimQtUtils](#types-from-nimqtutils)

---

## Setup and Compilation

### Compiler flags (MSYS2/Windows)

```nim
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

### Universal compilation (pkg-config)

```bash
nim cpp --passC:"-std=c++20" \
  --passC:"$(pkg-config --cflags Qt6Gui)" \
  --passL:"$(pkg-config --libs Qt6Gui)" \
  app.nim
```

### Imports

```nim
import nimQtUtils
import nimQtFFI
import nimQtGUI
```

---

## Opaque Types

All Qt6Gui types are represented as opaque objects imported via `importcpp`.

| Nim Type | C++ Class | Header |
|----------|-----------|--------|
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

## Type Aliases

Convenient short aliases for pointers:

| Alias | Full Type |
|-------|-----------|
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

Rendering quality hints for `QPainter`.

| Value | Description |
|-------|-------------|
| `Antialiasing = 0x01` | Anti-alias edges of primitives |
| `TextAntialiasing = 0x02` | Anti-alias text glyphs |
| `SmoothPixmapTransform = 0x04` | Use smooth pixmap transformation |
| `VerticalSubpixelPositioning = 0x08` | Vertical subpixel glyph positioning |
| `LosslessImageRendering = 0x40` | Lossless image rendering |
| `NonCosmeticBrushPatterns = 0x80` | Non-cosmetic brush patterns |

### QPainterCompositionMode

Porter-Duff and extended composition modes.

| Value | Description |
|-------|-------------|
| `CompositionMode_SourceOver = 0` | Source over destination (default) |
| `CompositionMode_DestinationOver = 1` | Destination over source |
| `CompositionMode_Clear = 2` | Clear destination |
| `CompositionMode_Source = 3` | Copy source only |
| `CompositionMode_Destination = 4` | Keep destination only |
| `CompositionMode_SourceIn = 5` | Source inside destination |
| `CompositionMode_DestinationIn = 6` | Destination inside source |
| `CompositionMode_SourceOut = 7` | Source outside destination |
| `CompositionMode_DestinationOut = 8` | Destination outside source |
| `CompositionMode_SourceAtop = 9` | Source atop destination |
| `CompositionMode_DestinationAtop = 10` | Destination atop source |
| `CompositionMode_Xor = 11` | XOR |
| `CompositionMode_Plus = 12` | Addition |
| `CompositionMode_Multiply = 13` | Multiply |
| `CompositionMode_Screen = 14` | Screen |
| `CompositionMode_Overlay = 15` | Overlay |
| `CompositionMode_Darken = 16` | Darken |
| `CompositionMode_Lighten = 17` | Lighten |
| `CompositionMode_ColorDodge = 18` | Color dodge |
| `CompositionMode_ColorBurn = 19` | Color burn |
| `CompositionMode_HardLight = 20` | Hard light |
| `CompositionMode_SoftLight = 21` | Soft light |
| `CompositionMode_Difference = 22` | Difference |
| `CompositionMode_Exclusion = 23` | Exclusion |

### QFontStyleHint

| Value | Description |
|-------|-------------|
| `AnyStyle = 0` | Any style |
| `SansSerif = 2` | Sans-serif (Helvetica) |
| `Serif = 1` | Serif (Times) |
| `Monospace = 7` | Monospaced (Courier) |
| `Cursive = 5` | Cursive |
| `Fantasy = 6` | Decorative/Fantasy |
| `Decorative = 3` | Decorative (deprecated) |
| `System = 9` | System default |

### QFontStyleStrategy

| Value | Description |
|-------|-------------|
| `PreferDefault = 0x0001` | Use default style strategy |
| `PreferBitmap = 0x0002` | Prefer bitmap fonts |
| `PreferDevice = 0x0004` | Prefer device fonts |
| `PreferOutline = 0x0008` | Prefer outline fonts |
| `ForceOutline = 0x0010` | Force outline fonts |
| `PreferMatch = 0x0020` | Prefer exact match |
| `PreferQuality = 0x0040` | Prefer quality |
| `PreferAntialias = 0x0080` | Prefer antialiased rendering |
| `NoAntialias = 0x0100` | No antialiasing |
| `NoSubpixelAntialias = 0x0800` | No subpixel antialiasing |
| `PreferNoShaping = 0x1000` | Disable text shaping |
| `NoFontMerging = 0x8000` | Disable font merging |

### QPaletteColorRole

| Value | Description |
|-------|-------------|
| `WindowText = 0` | Foreground color for windows |
| `Button = 1` | General button background |
| `Light = 2` | Lighter than button |
| `Midlight = 3` | Between button and light |
| `Dark = 4` | Darker than button |
| `Mid = 5` | Between dark and button |
| `Text = 6` | Foreground for items |
| `BrightText = 7` | Text contrasting with dark |
| `ButtonText = 8` | Foreground for buttons |
| `Base = 9` | Background for text inputs |
| `Window = 10` | General window background |
| `Shadow = 11` | Very dark shadow |
| `Highlight = 12` | Selected item background |
| `HighlightedText = 13` | Selected item foreground |
| `Link = 14` | Unvisited hyperlink |
| `LinkVisited = 15` | Visited hyperlink |
| `AlternateBase = 16` | Alternating row background |
| `NoRole = 17` | No specific role |
| `ToolTipBase = 18` | Tooltip background |
| `ToolTipText = 19` | Tooltip foreground |
| `PlaceholderText = 20` | Placeholder text |

### QPaletteColorGroup

| Value | Description |
|-------|-------------|
| `Disabled = 0` | Disabled widget |
| `Active = 1` | Active (focused) widget |
| `Inactive = 2` | Inactive widget |
| `Normal = 1` | Alias for Active |

### QWindowState

| Value | Description |
|-------|-------------|
| `WindowNoState = 0x00000000` | Normal window state |
| `WindowMinimized = 0x00000001` | Minimized |
| `WindowMaximized = 0x00000002` | Maximized |
| `WindowFullScreen = 0x00000004` | Full-screen |
| `WindowActive = 0x00000008` | Active/focused window |

### QPageSizeId

| Value | Format |
|-------|--------|
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

| Value | Description |
|-------|-------------|
| `Portrait = 0` | Portrait orientation |
| `Landscape = 1` | Landscape orientation |

### QSurfaceFormatProfile

| Value | Description |
|-------|-------------|
| `NoProfile = 0` | No OpenGL profile |
| `CoreProfile = 1` | Core Profile |
| `CompatibilityProfile = 2` | Compatibility Profile |

### QSurfaceFormatOption

| Value | Description |
|-------|-------------|
| `StereoBuffers = 0x0001` | Stereo buffers |
| `DebugContext = 0x0002` | Debug context |
| `DeprecatedFunctions = 0x0004` | Deprecated OpenGL functions |
| `ResetNotification = 0x0008` | Reset notification |
| `ProtectedContent = 0x0010` | Protected content |

---

## QGuiApplication

The main GUI application singleton. The internal singleton is managed through a static variable `_nim_gui_app`.

### Creation and access

```nim
proc newGuiApp*(): GuiApp
```
Creates the single `QGuiApplication` instance. Call only once.

```nim
proc guiAppInstance*(): GuiApp
```
Returns the existing instance (or `nil`).

### Application lifecycle

```nim
proc exec*(a: GuiApp): cint
```
Starts the event loop. Blocks until `quit()` is called.

```nim
proc quit*(a: GuiApp)
```
Exits the event loop.

```nim
proc guiProcessEvents*()
```
Processes all pending events without blocking.

### Application metadata

```nim
proc setAppName*(a: GuiApp, s: QString)
proc setOrgName*(a: GuiApp, s: QString)
proc setAppVersion*(a: GuiApp, s: QString)
proc setAppDisplayName*(a: GuiApp, s: QString)
```

### Appearance

```nim
proc setWindowIcon*(a: GuiApp, icon: QIcon)
proc setStyleSheet*(a: GuiApp, css: QString)
proc setPalette*(a: GuiApp, pal: QPalette)
```

### Screens and clipboard

```nim
proc guiClipboard*(): Clip
proc guiPrimaryScreen*(): Scr
proc guiScreens*(): seq[Scr]
```

### HiDPI policy

```nim
proc guiHighDpiScaleFactorPolicy*(policy: cint)
```
Sets the rounding policy for HiDPI scale factors.

### Example

```nim
let app = newGuiApp()
# ... create windows ...
let code = app.exec()
```

---

## QScreen

Describes a physical display screen.

```nim
proc screenName*(s: Scr): string
```
Screen name (e.g. `"HDMI-1"`).

```nim
proc screenGeometry*(s: Scr): NimRect
```
Full screen geometry `(x, y, w, h)`.

```nim
proc screenAvailableGeometry*(s: Scr): NimRect
```
Available geometry (excludes taskbars, docks, etc.).

```nim
proc screenLogicalDpi*(s: Scr): tuple[x, y: float64]
proc screenPhysicalDpi*(s: Scr): tuple[x, y: float64]
```
Logical and physical DPI along X/Y axes.

```nim
proc screenDevicePixelRatio*(s: Scr): float64
```
Device pixel ratio (1.0, 1.5, 2.0...).

```nim
proc screenRefreshRate*(s: Scr): float64
```
Refresh rate in Hz.

```nim
proc screenDepth*(s: Scr): int
```
Color depth in bits.

```nim
proc screenOrientation*(s: Scr): cint
```
Current screen orientation.

---

## QColor

Color representation. Stored by value.

### Constructors

```nim
proc newColor*(r, g, b: int, a: int = 255): QColor
```
RGB(A) color, components 0–255.

```nim
proc newColorF*(r, g, b: float64, a: float64 = 1.0): QColor
```
RGB(A) with floating-point components 0.0–1.0.

```nim
proc newColorHsv*(h, s, v: int, a: int = 255): QColor
```
HSV color. Hue 0–359, saturation/value 0–255.

```nim
proc newColorHsl*(h, s, l: int, a: int = 255): QColor
```
HSL color.

```nim
proc newColorCmyk*(c, m, y, k: int, a: int = 255): QColor
```
CMYK color.

```nim
proc newColorHex*(hex: string): QColor
```
Color from hex string `"#RRGGBB"` or `"#AARRGGBB"`.

### Component getters

```nim
proc colorR*(c: QColor): int     # Red 0–255
proc colorG*(c: QColor): int     # Green 0–255
proc colorB*(c: QColor): int     # Blue 0–255
proc colorA*(c: QColor): int     # Alpha 0–255
proc colorRF*(c: QColor): float64  # Red 0.0–1.0
proc colorGF*(c: QColor): float64
proc colorBF*(c: QColor): float64
proc colorAF*(c: QColor): float64
proc colorHsvH*(c: QColor): int    # HSV hue
proc colorHsvS*(c: QColor): int    # HSV saturation
proc colorHsvV*(c: QColor): int    # HSV value
```

### Transformations and utilities

```nim
proc colorLighter*(c: QColor, factor: int = 150): QColor
```
Returns a lighter color. `factor > 100` lightens.

```nim
proc colorDarker*(c: QColor, factor: int = 200): QColor
```
Returns a darker color.

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
Linearly interpolates between two colors. `t=0.0` → `c1`, `t=1.0` → `c2`.

### Example

```nim
let red   = newColor(255, 0, 0)
let semi  = colorSetAlpha(red, 128)
let mixed = colorInterpolate(red, newColor(0, 0, 255), 0.5)
echo colorToHexStr(mixed)  # "#7f007f"
```

---

## QFont

Font description. Stored by value.

### Constructors

```nim
proc newFont*(): QFont
proc newFont*(family: string, pointSize: int = -1, weight: int = -1, italic: bool = false): QFont
```

### Reading properties

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

### Setting properties (via pointer)

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

### Serialization

```nim
proc fontToString*(f: QFont): string
proc fontFromString*(s: string): QFont
```

### Example

```nim
var f = newFont("Arial", 14)
setFontBold(addr f, true)
setFontItalic(addr f, true)
```

---

## QFontMetrics / QFontMetricsF

Font metrics (integer and floating-point variants).

### QFontMetrics

```nim
proc newFontMetrics*(f: QFont): QFontMetrics
```

```nim
proc fmHeight*(fm: QFontMetrics): int          # Total line height
proc fmAscent*(fm: QFontMetrics): int          # Distance from baseline to top
proc fmDescent*(fm: QFontMetrics): int         # Distance from baseline to bottom
proc fmLeading*(fm: QFontMetrics): int         # Space between lines
proc fmLineSpacing*(fm: QFontMetrics): int     # ascent + descent + leading
proc fmAverageCharWidth*(fm: QFontMetrics): int
proc fmMaxWidth*(fm: QFontMetrics): int        # Maximum character width
proc fmXHeight*(fm: QFontMetrics): int         # Height of lowercase 'x'
proc fmCapHeight*(fm: QFontMetrics): int       # Height of uppercase letters
```

```nim
proc fmHorizontalAdvance*(fm: QFontMetrics, text: string): int
```
Width of a string in pixels.

```nim
proc fmBoundingRect*(fm: QFontMetrics, text: string): NimRect
```
Bounding rectangle of a string.

```nim
proc fmElidedText*(fm: QFontMetrics, text: string, mode: cint, width: int): string
```
Elided text with ellipsis. `mode`: 0=Left, 1=Right, 2=Middle, 3=None.

### QFontMetricsF (floating-point)

```nim
proc newFontMetricsF*(f: QFont): QFontMetricsF
proc fmfHorizontalAdvance*(fm: QFontMetricsF, text: string): float64
proc fmfHeight*(fm: QFontMetricsF): float64
```

---

## QFontDatabase

Access to the system font database.

```nim
proc fontFamiliesList*(): seq[string]
```
List of all available font families.

```nim
proc fontStyles*(family: string): seq[string]
```
Available styles for a family.

```nim
proc fontPointSizes*(family, style: string): seq[int]
```
Available point sizes.

```nim
proc fontAddFile*(path: string): int
```
Loads a font from a file. Returns ID (or -1 on error).

```nim
proc fontAddFromData*(data: string): int
```
Loads a font from in-memory data.

```nim
proc fontRemove*(id: int)
```
Removes a loaded font by ID.

```nim
proc fontIsSmoothlyScalable*(family, style: string): bool
proc fontIsFixedPitch*(family, style: string): bool
```

```nim
proc fontSystemDefault*(): QFont   # General-purpose system font
proc fontSystemFixed*(): QFont     # System monospace font
```

---

## QPixmap

Image optimized for display on screen.

> **Note:** `Pxm = ptr QPixmap` — memory management is the developer's responsibility.

### Creation

```nim
proc newPixmap*(w, h: int): Pxm
proc loadPixmap*(path: string): Pxm
```

### Properties

```nim
proc pixmapWidth*(p: Pxm): int
proc pixmapHeight*(p: Pxm): int
proc pixmapIsNull*(p: Pxm): bool
proc pixmapDepth*(p: Pxm): int
proc pixmapDevicePixelRatio*(p: Pxm): float64
proc setPixmapDevicePixelRatio*(p: Pxm, ratio: float64)
```

### Transformations

```nim
proc pixmapScaled*(p: Pxm, w, h: int, aspectMode: cint = 1, transformMode: cint = 0): Pxm
proc pixmapScaledToWidth*(p: Pxm, w: int, transformMode: cint = 0): Pxm
proc pixmapScaledToHeight*(p: Pxm, h: int, transformMode: cint = 0): Pxm
proc pixmapCopy*(p: Pxm, x, y, w, h: int): Pxm
proc pixmapTransformed*(p: Pxm, t: QTransform, mode: cint = 0): Pxm
```

`aspectMode`: 0=IgnoreAspectRatio, 1=KeepAspectRatio, 2=KeepAspectRatioByExpanding  
`transformMode`: 0=FastTransformation, 1=SmoothTransformation

### Fill and save

```nim
proc pixmapFill*(p: Pxm, c: QColor)
proc pixmapFillTransparent*(p: Pxm)
proc pixmapSave*(p: Pxm, path: string, format: string = "", quality: int = -1): bool
```

### Conversion

```nim
proc pixmapToImage*(p: Pxm): QImage
proc pixmapFromImage*(img: QImage): Pxm
```

---

## QImage

In-memory image with direct pixel access.

### Creation

```nim
proc newImage*(w, h: int, fmt: QtImageFormat = Format_ARGB32): QImage
proc loadImage*(path: string): QImage
```

### Properties

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

### Pixel access

```nim
proc imagePixel*(img: QImage, x, y: int): uint32
proc imageSetPixel*(img: var QImage, x, y: int, color: uint32)
proc imagePixelColor*(img: QImage, x, y: int): QColor
proc imageSetPixelColor*(img: var QImage, x, y: int, c: QColor)
proc imageFill*(img: var QImage, c: QColor)
proc imageFillValue*(img: var QImage, v: uint32)
proc imageBits*(img: QImage): pointer      # Direct buffer access
```

### Image processing

```nim
proc imageScaled*(img: QImage, w, h: int, aspectMode: cint = 1, transformMode: cint = 0): QImage
proc imageConvertTo*(img: QImage, fmt: QtImageFormat): QImage
proc imageMirrored*(img: QImage, horizontal: bool = false, vertical: bool = true): QImage
```

### Saving and conversion

```nim
proc imageSave*(img: QImage, path: string, format: string = "", quality: int = -1): bool
proc imageToPixmap*(img: QImage): Pxm
```

---

## QImageReader / QImageWriter

Reading and writing images with extended control.

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

### Supported formats

```nim
proc imageFormatsForReading*(): seq[string]
proc imageFormatsForWriting*(): seq[string]
```

---

## QIcon

Icon with theme and scaling support.

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

Mouse cursor.

```nim
proc newCursor*(shape: QtCursorShape = ArrowCursor): QCursor
proc newCursorFromPixmap*(p: Pxm, hotX: int = -1, hotY: int = -1): QCursor
proc cursorShape*(c: QCursor): cint
proc cursorPos*(): NimPoint
proc setCursorPos*(x, y: int)
```

`QtCursorShape` values are defined in `nimQtFFI` (e.g. `ArrowCursor`, `CrossCursor`, `WaitCursor`, etc.).

---

## QPen

Pen for drawing lines and outlines.

### Construction

```nim
proc newPen*(): QPen
proc newPen*(c: QColor, width: float64 = 1.0, style: QtPenStyle = SolidLine): QPen
proc newPenStyle*(style: QtPenStyle): QPen
```

### Properties

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

> **Cosmetic pen** — width does not scale with transform (always 1 pixel on screen).

---

## QBrush

Brush for filling shapes.

### Construction

```nim
proc newBrush*(): QBrush
proc newBrush*(c: QColor, style: QtBrushStyle = SolidPattern): QBrush
proc newBrushFromPixmap*(p: Pxm): QBrush
proc newBrushFromLinearGradient*(g: QLinearGradient): QBrush
proc newBrushFromRadialGradient*(g: QRadialGradient): QBrush
proc newBrushFromConicalGradient*(g: QConicalGradient): QBrush
```

### Properties

```nim
proc setBrushColor*(b: var QBrush, c: QColor)
proc setBrushStyle*(b: var QBrush, s: QtBrushStyle)
proc setBrushTexture*(b: var QBrush, p: Pxm)
proc brushColor*(b: QBrush): QColor
proc brushIsOpaque*(b: QBrush): bool
```

---

## Gradients

### QLinearGradient — linear gradient

```nim
proc newLinearGradient*(x1, y1, x2, y2: float64): QLinearGradient
proc linearGradientAddStop*(g: var QLinearGradient, pos: float64, c: QColor)
proc linearGradientSetSpread*(g: var QLinearGradient, spread: cint)
```

`spread`: 0=PadSpread, 1=RepeatSpread, 2=ReflectSpread

### QRadialGradient — radial gradient

```nim
proc newRadialGradient*(cx, cy, radius: float64): QRadialGradient
proc radialGradientAddStop*(g: var QRadialGradient, pos: float64, c: QColor)
```

### QConicalGradient — conical gradient

```nim
proc newConicalGradient*(cx, cy, angle: float64): QConicalGradient
proc conicalGradientAddStop*(g: var QConicalGradient, pos: float64, c: QColor)
```

### Example

```nim
var grad = newLinearGradient(0, 0, 100, 0)
linearGradientAddStop(grad, 0.0, newColor(255, 0, 0))
linearGradientAddStop(grad, 1.0, newColor(0, 0, 255))
let brush = newBrushFromLinearGradient(grad)
```

---

## QTransform

2D affine transformation matrix (3×3).

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

4×4 matrix for 3D transformations.

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

## Vectors and Quaternions

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

The primary 2D drawing class.

### Creation

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

### Rendering settings

```nim
proc setRenderHint*(p: Pntr, hint: QPainterRenderHint, on: bool = true)
proc setRenderHints*(p: Pntr, hints: cint, on: bool = true)
proc setCompositionMode*(p: Pntr, mode: QPainterCompositionMode)
proc setOpacity*(p: Pntr, opacity: float64)
proc opacity*(p: Pntr): float64
```

### Drawing tools

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

### Clipping

```nim
proc setClipRect*(p: Pntr, x, y, w, h: int, op: cint = 0)
proc setClipRectF*(p: Pntr, x, y, w, h: float64, op: cint = 0)
proc setClipRegion*(p: Pntr, region: QRegion, op: cint = 0)
proc setClipPath*(p: Pntr, path: QPainterPath, op: cint = 0)
proc setClipping*(p: Pntr, enable: bool)
```

`op` (ClipOperation): 0=ReplaceClip, 1=IntersectClip, 2=UniteClip

### Transformations

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

### Drawing primitives

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

> **Arc/Pie angles** are specified in **1/16 of a degree** (16 = 1°, 5760 = full circle).

### Path drawing

```nim
proc drawPath*(p: Pntr, path: QPainterPath)
proc fillPath*(p: Pntr, path: QPainterPath, brush: QBrush)
proc strokePath*(p: Pntr, path: QPainterPath, pen: QPen)
```

### Text drawing

```nim
proc drawText*(p: Pntr, x, y: int, text: string)
proc drawTextF*(p: Pntr, x, y: float64, text: string)
proc drawTextRect*(p: Pntr, x, y, w, h: int, flags: cint, text: string)
proc drawTextRectF*(p: Pntr, x, y, w, h: float64, flags: cint, text: string)
proc drawStaticText*(p: Pntr, x, y: int, text: string)
```

`flags` (Qt::AlignmentFlag | Qt::TextFlag): e.g. `0x0001=AlignLeft`, `0x0002=AlignRight`, `0x0004=AlignHCenter`, `0x0020=AlignTop`, `0x0040=AlignBottom`, `0x0080=AlignVCenter`, `0x0100=TextWordWrap`.

### Image/Pixmap drawing

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

### Example: drawing on a pixmap

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

Compound path composed of lines, arcs, and Bézier curves.

### Creation

```nim
proc newPainterPath*(): QPainterPath
proc newPainterPathAt*(x, y: float64): QPainterPath
```

### Building the path

```nim
proc ppMoveTo*(path: var QPainterPath, x, y: float64)
proc ppLineTo*(path: var QPainterPath, x, y: float64)
proc ppArcTo*(path: var QPainterPath, x, y, w, h, startAngle, sweepLength: float64)
proc ppCubicTo*(path: var QPainterPath, c1x, c1y, c2x, c2y, ex, ey: float64)
proc ppQuadTo*(path: var QPainterPath, cx, cy, ex, ey: float64)
proc ppCloseSubpath*(path: var QPainterPath)
```

### Adding shapes

```nim
proc ppAddRect*(path: var QPainterPath, x, y, w, h: float64)
proc ppAddEllipse*(path: var QPainterPath, x, y, w, h: float64)
proc ppAddRoundedRect*(path: var QPainterPath, x, y, w, h, xr, yr: float64)
proc ppAddText*(path: var QPainterPath, x, y: float64, font: QFont, text: string)
proc ppAddPath*(path: var QPainterPath, other: QPainterPath)
```

### Boolean operations

```nim
proc ppUnited*(a, b: QPainterPath): QPainterPath
proc ppIntersected*(a, b: QPainterPath): QPainterPath
proc ppSubtracted*(a, b: QPainterPath): QPainterPath
```

### Queries

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

A region on screen (collection of rectangles).

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

Key press/release event.

```nim
proc keyEventKey*(e: ptr QKeyEvent): int
```
Key code (`Qt::Key`, from `nimQtFFI`).

```nim
proc keyEventText*(e: ptr QKeyEvent): string
proc keyEventModifiers*(e: ptr QKeyEvent): cint
proc keyEventIsAutoRepeat*(e: ptr QKeyEvent): bool
proc keyEventCount*(e: ptr QKeyEvent): int
proc keyEventNativeScanCode*(e: ptr QKeyEvent): uint32
proc keyEventNativeVirtualKey*(e: ptr QKeyEvent): uint32
proc keyEventNativeModifiers*(e: ptr QKeyEvent): uint32
```

Modifiers (`Qt::KeyboardModifier`): `0x02000000=Ctrl`, `0x04000000=Shift`, `0x08000000=Alt`, `0x10000000=Meta`.

---

## QMouseEvent

Mouse event.

```nim
proc mouseEventPos*(e: ptr QMouseEvent): NimPoint          # Integer coordinates
proc mouseEventPosF*(e: ptr QMouseEvent): NimPointF        # Float coordinates
proc mouseEventGlobalPos*(e: ptr QMouseEvent): NimPoint    # Global (screen) coordinates
proc mouseEventButton*(e: ptr QMouseEvent): cint           # Button (1=Left, 2=Right, 4=Mid)
proc mouseEventButtons*(e: ptr QMouseEvent): cint          # All pressed buttons
proc mouseEventModifiers*(e: ptr QMouseEvent): cint
proc mouseEventSource*(e: ptr QMouseEvent): cint           # 0=Mouse, 1=TouchScreen, 2=Pen
```

---

## QWheelEvent

Mouse wheel event.

```nim
proc wheelEventPos*(e: ptr QWheelEvent): NimPoint
proc wheelEventAngleDelta*(e: ptr QWheelEvent): NimPoint
```
`angleDelta.y` = vertical movement in 1/8 degree (standard step = 120).

```nim
proc wheelEventPixelDelta*(e: ptr QWheelEvent): NimPoint   # For trackpads
proc wheelEventButtons*(e: ptr QWheelEvent): cint
proc wheelEventModifiers*(e: ptr QWheelEvent): cint
proc wheelEventPhase*(e: ptr QWheelEvent): cint            # 0=NoScrollPhase, 1=Begin, 2=Update, 4=End
proc wheelEventInverted*(e: ptr QWheelEvent): bool         # Natural scrolling direction
```

---

## QClipboard

System clipboard.

```nim
proc guiClipboard*(): Clip   # Retrieve from QGuiApplication
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

MIME data for clipboard and drag-and-drop.

```nim
proc newMimeData*(): MimeD
```

### Checking for data

```nim
proc mimeHasText*(d: MimeD): bool
proc mimeHasHtml*(d: MimeD): bool
proc mimeHasImage*(d: MimeD): bool
proc mimeHasUrls*(d: MimeD): bool
proc mimeHasFormat*(d: MimeD, fmt: string): bool
```

### Getting data

```nim
proc mimeText*(d: MimeD): string
proc mimeHtml*(d: MimeD): string
proc mimeFormats*(d: MimeD): seq[string]
proc mimeData*(d: MimeD, fmt: string): string
proc mimeUrls*(d: MimeD): seq[string]
```

### Setting data

```nim
proc mimeSetText*(d: MimeD, text: string)
proc mimeSetHtml*(d: MimeD, html: string)
proc mimeSetImage*(d: MimeD, img: QImage)
proc mimeSetData*(d: MimeD, fmt: string, data: string)
```

---

## QPalette

Color palette for widgets.

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

OpenGL surface format.

```nim
proc newSurfaceFormat*(): QSurfaceFormat
proc sfSetVersion*(f: var QSurfaceFormat, major, minor: int)
proc sfSetProfile*(f: var QSurfaceFormat, profile: QSurfaceFormatProfile)
proc sfSetDepthBufferSize*(f: var QSurfaceFormat, size: int)
proc sfSetStencilBufferSize*(f: var QSurfaceFormat, size: int)
proc sfSetSamples*(f: var QSurfaceFormat, samples: int)    # Multisampling
proc sfSetSwapInterval*(f: var QSurfaceFormat, interval: int)  # 0=no vsync, 1=vsync
proc sfSetOption*(f: var QSurfaceFormat, opt: QSurfaceFormatOption)
proc sfMajorVersion*(f: QSurfaceFormat): int
proc sfMinorVersion*(f: QSurfaceFormat): int
proc sfSetDefaultFormat*(fmt: QSurfaceFormat)
```

### OpenGL 4.1 Core setup example

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

Native OS window.

### Creation and visibility

```nim
proc newQWindow*(parent: Win = nil): Win
proc windowShow*(w: Win)
proc windowHide*(w: Win)
proc windowClose*(w: Win)
proc windowRaise*(w: Win)
proc windowLower*(w: Win)
proc windowActivate*(w: Win)
```

### Title and geometry

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

### State

```nim
proc windowSetState*(w: Win, state: QWindowState)
proc windowState*(w: Win): cint
proc windowSetOpacity*(w: Win, opacity: float64)
proc windowOpacity*(w: Win): float64
proc windowIsVisible*(w: Win): bool
proc windowIsActive*(w: Win): bool
proc windowIsExposed*(w: Win): bool
```

### Appearance

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

Opening URLs and files in external applications.

```nim
proc openUrl*(url: string): bool
```
Opens a URL in the default browser. Returns `false` on failure.

```nim
proc openFile*(path: string): bool
```
Opens a file with its associated application.

### Example

```nim
discard openUrl("https://www.qt.io")
discard openFile("/home/user/document.pdf")
```

---

## QMovie

Animated image playback (GIF, WebP, etc.).

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
proc movieSetSpeed*(m: Mov, speed: int)    # 100 = normal speed
proc movieSpeed*(m: Mov): int
proc movieSetScaledSize*(m: Mov, w, h: int)
proc movieJumpToFrame*(m: Mov, frame: int): bool
```

### Frame-changed callback

```nim
type CBMovie* = proc(frameNumber: cint, ud: pointer) {.cdecl.}

proc movieOnFrameChanged*(m: Mov, cb: CBMovie, ud: pointer)
```

### Example

```nim
let movie = newMovie("animation.gif")
movieOnFrameChanged(movie, proc(fn: cint, ud: pointer) {.cdecl.} =
  echo "Frame: ", fn
, nil)
movieStart(movie)
```

---

## QPageSize / QPageLayout

Page settings for printing.

### QPageSize

```nim
proc newPageSizeById*(id: QPageSizeId): QPageSize
proc newPageSizeCustom*(widthMM, heightMM: float64): QPageSize
proc pageSizeName*(ps: QPageSize): string
proc pageSizeRectMM*(ps: QPageSize): NimRectF     # Rectangle in mm
proc pageSizeSizeMM*(ps: QPageSize): NimSizeF     # Size in mm
```

### QPageLayout

```nim
proc newPageLayout*(ps: QPageSize, orientation: QPageLayoutOrientation,
                   leftMM, topMM, rightMM, bottomMM: float64): QPageLayout
proc pageLayoutPaintRect*(pl: QPageLayout): NimRectF   # Paint area in mm
proc pageLayoutFullRect*(pl: QPageLayout): NimRectF    # Full page area in mm
proc pageLayoutIsValid*(pl: QPageLayout): bool
```

### Example

```nim
let ps = newPageSizeById(A4)
let layout = newPageLayout(ps, Portrait, 20.0, 20.0, 20.0, 20.0)
echo pageLayoutPaintRect(layout)  # (x: 20, y: 20, w: 170, h: 257)
```

---

## QColorSpace

Color space for images.

```nim
proc newColorSpaceSRGB*(): QColorSpace
proc newColorSpaceDisplayP3*(): QColorSpace
proc colorSpaceIsValid*(cs: QColorSpace): bool
proc colorSpaceDescription*(cs: QColorSpace): string
```

---

## Types from nimQtUtils

Helper Nim types used throughout the library:

| Type | Definition | Description |
|------|------------|-------------|
| `NimPoint` | `tuple[x, y: int]` | Integer 2D point |
| `NimPointF` | `tuple[x, y: float64]` | Floating-point 2D point |
| `NimRect` | `tuple[x, y, w, h: int]` | Integer rectangle |
| `NimRectF` | `tuple[x, y, w, h: float64]` | Float rectangle |
| `NimSize` | `tuple[w, h: int]` | Integer size |
| `NimSizeF` | `tuple[w, h: float64]` | Float size |
| `NimColor` | `tuple[r, g, b, a: uint8]` | RGBA color |
| `QString` | C++ QString | Qt string (from nimQtFFI) |
| `QColor` | C++ QColor | Qt color (value type) |
| `QtImageFormat` | enum | QImage pixel formats |
| `QtPenStyle` | enum | Pen line styles |
| `QtPenCapStyle` | enum | Pen cap styles |
| `QtPenJoinStyle` | enum | Pen join styles |
| `QtBrushStyle` | enum | Brush fill styles |
| `QtCursorShape` | enum | Cursor shapes |

---

## Full Application Example

```nim
import nimQtUtils, nimQtFFI, nimQtGUI

let app = newGuiApp()
let scr  = guiPrimaryScreen()
let geo  = screenGeometry(scr)
echo "Screen: ", geo.w, "×", geo.h

# Create a pixmap and draw on it
let pxm = newPixmap(400, 300)
pixmapFill(pxm, newColor(240, 240, 240))

let p = newPainterOnPixmap(pxm)
setRenderHint(p, Antialiasing)

# Title text
var font = newFont("Arial", 18)
setFontBold(addr font, true)
setFont(p, font)
setPenColor(p, newColor(20, 20, 20))
drawText(p, 20, 40, "Hello Qt6 from Nim!")

# Circle with radial gradient
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

*Reference generated from `nimQtGUI.nim` source — a Qt6Gui wrapper for Nim (C++20).*
