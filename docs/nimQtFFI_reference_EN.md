# nimQtFFI — Complete Library Reference

> **Module version:** `nimQtFFI.nim`
> **Qt compatibility:** Qt 6.2 – Qt 6.11
> **Requirements:** Nim + C++ backend (`nim cpp`), C++17 minimum (C++20 recommended)
> **Dependencies:** none — lowest-level module in the Qt6 wrapper stack

---

## Table of Contents

1. [Overview](#1-overview)
2. [Compilation & Setup](#2-compilation--setup)
3. [Qt6 Library Path Constants](#3-qt6-library-path-constants)
4. [Platform Constants](#4-platform-constants)
5. [Opaque Pointers (C-compatible Types)](#5-opaque-pointers-c-compatible-types)
6. [Callback Types](#6-callback-types)
7. [Qt Namespace Enumerations](#7-qt-namespace-enumerations)
8. [Runtime Qt Version](#8-runtime-qt-version)
9. [Math Helpers](#9-math-helpers)
10. [System Information (QSysInfo)](#10-system-information-qsysinfo)
11. [Standard OS Paths (QStandardPaths)](#11-standard-os-paths-qstandardpaths)
12. [Environment Variables](#12-environment-variables)
13. [File System](#13-file-system)
14. [Dynamic Library Loading](#14-dynamic-library-loading)
15. [Logging & Debugging](#15-logging--debugging)
16. [Version Parsing (QVersionNumber)](#16-version-parsing-qversionnumber)
17. [Compile-time Constants](#17-compile-time-constants)
18. [Quick-Reference Table](#18-quick-reference-table)

---

## 1. Overview

`nimQtFFI.nim` is the foundational low-level Nim interface to Qt6. It does not provide high-level widget wrappers; instead it offers:

- **Qt6 dynamic library names** ready to use with `{.importc.}` / `dynlib`.
- **Opaque C pointers** to key Qt objects for use in FFI declarations.
- **Callback types** for connecting Nim procedures to Qt signals.
- **Complete Qt namespace enums** — sized to match C++ `int`.
- **Runtime functions** for Qt version, system info, OS paths, file system, logging, and math.

This module has no dependencies on any other module in the project.

---

## 2. Compilation & Setup

### Linux / macOS (pkg-config — recommended)

```nim
{.passC: gorge("pkg-config --cflags Qt6Core Qt6Gui Qt6Widgets").}
{.passL: gorge("pkg-config --libs Qt6Core Qt6Gui Qt6Widgets").}
```

Command line:

```bash
nim cpp --passC:"-std=c++20" \
  --passC:"$(pkg-config --cflags Qt6Core)" \
  --passL:"$(pkg-config --libs Qt6Core)" \
  app.nim
```

### Windows (MSYS2 UCRT64)

Paths are embedded in the module via `{.passC.}` / `{.passL.}`:

```
-IC:/msys64/ucrt64/include
-IC:/msys64/ucrt64/include/qt6
-IC:/msys64/ucrt64/include/qt6/QtWidgets
-IC:/msys64/ucrt64/include/qt6/QtGui
-IC:/msys64/ucrt64/include/qt6/QtCore
-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB
-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core
```

> On Linux/macOS replace the hardcoded `{.passC.}` directives with `pkg-config` calls.

---

## 3. Qt6 Library Path Constants

All library names are composed automatically as:

```
name = QtLibPrefix & "Qt6<Module>" & QtLibSuffix
```

| Constant | Qt Module | Description |
|---|---|---|
| `libQt6Core` | QtCore | QObject, QCoreApplication, QThread, QTimer, QFile, … |
| `libQt6Gui` | QtGui | QFont, QPixmap, QPainter, QColor, QIcon, … |
| `libQt6Widgets` | QtWidgets | QApplication, QWidget, QPushButton, QDialog, … |
| `libQt6Network` | QtNetwork | QTcpSocket, QNetworkAccessManager, … |
| `libQt6Sql` | QtSql | QSqlDatabase, QSqlQuery, … |
| `libQt6Xml` | QtXml | QXmlStreamReader/Writer, QDomDocument, … |
| `libQt6Concurrent` | QtConcurrent | QtConcurrent::run, … |
| `libQt6DBus` | QtDBus | D-Bus IPC (Linux) |
| `libQt6OpenGL` | QtOpenGL | QOpenGLContext, QOpenGLFunctions, … |
| `libQt6OpenGLWidgets` | QtOpenGLWidgets | QOpenGLWidget |
| `libQt6Svg` | QtSvg | QSvgRenderer |
| `libQt6SvgWidgets` | QtSvgWidgets | QSvgWidget |
| `libQt6PrintSupport` | QtPrintSupport | QPrinter, QPrintDialog, … |
| `libQt6Pdf` | QtPdf | PDF rendering (Qt 6.4+) |
| `libQt6PdfWidgets` | QtPdfWidgets | PDF widget (Qt 6.4+) |
| `libQt6WebEngineCore` | QtWebEngineCore | Web engine, Chromium core |
| `libQt6WebEngineWidgets` | QtWebEngineWidgets | Web widgets |
| `libQt6WebEngineQuick` | QtWebEngineQuick | Quick web engine (QML) |
| `libQt6WebSockets` | QtWebSockets | WebSocket |
| `libQt6WebChannel` | QtWebChannel | WebChannel |
| `libQt6Positioning` | QtPositioning | Geo-positioning |
| `libQt6Quick` | QtQuick | Qt Quick (QML) |
| `libQt6Multimedia` | QtMultimedia | Multimedia (Qt 6.2+) |
| `libQt6Charts` | QtCharts | Charts (Qt 6.2+) |
| `libQt6DataVisualization` | QtDataVisualization | 3D data visualization (Qt 6.2+) |
| `libQt6HttpServer` | QtHttpServer | HTTP server (Qt 6.4+) |
| `libQt6Graphs` | QtGraphs | Graphs (Qt 6.6+, replaces DataVisualization) |
| `libQt6Location` | QtLocation | Maps (Qt 6.5+) |
| `libQt6Bluetooth` | QtBluetooth | Bluetooth |
| `libQt6SerialPort` | QtSerialPort | Serial port |
| `libQt6SerialBus` | QtSerialBus | CAN, LIN |
| `libQt6StateMachine` | QtStateMachine | State machines |
| `libQt6Scxml` | QtScxml | SCXML |

**Usage example:**

```nim
proc createApp(argc: ptr cint, argv: ptr cstring): QCoreAppPtr
  {.importcpp: "new QCoreApplication(@)", dynlib: libQt6Core.}
```

---

## 4. Platform Constants

### Library name helpers

| Constant | Windows | macOS | Linux |
|---|---|---|---|
| `QtLibPrefix` | `""` | `"lib"` | `"lib"` |
| `QtLibSuffix` | `".dll"` | `".dylib"` | `".so.6"` |

### Platform flags (compile-time)

| Constant | Type | Value |
|---|---|---|
| `QtPlatformWindows` | `bool` | `true` on Windows only |
| `QtPlatformLinux` | `bool` | `true` on Linux only |
| `QtPlatformMacos` | `bool` | `true` on macOS only |

**Example:**

```nim
when QtPlatformWindows:
  echo "Running on Windows"
```

---

## 5. Opaque Pointers (C-compatible Types)

Opaque pointer types for Qt objects, used in FFI function signatures.

| Type | Description |
|---|---|
| `QCoreAppPtr` | Pointer to `QCoreApplication` |
| `QObjectPtr` | Pointer to `QObject` (base for all Qt objects) |
| `QStringPtr` | Pointer to a heap-allocated `QString` |
| `QByteArrayPtr` | Pointer to `QByteArray` |
| `QVariantPtr` | Pointer to `QVariant` (Qt value type) |

All types are defined as `pointer`. They provide no type safety but are required for C++ interop.

---

## 6. Callback Types

Procedural types for connecting Nim functions to Qt signals. All use `{.cdecl.}` calling convention.

| Type | Signature | Typical use |
|---|---|---|
| `CB` | `proc(ud: pointer)` | `clicked()`, `timeout()` — no params |
| `CBStr` | `proc(text: cstring, ud: pointer)` | `textChanged`, `fileSelected` |
| `CBInt` | `proc(value: cint, ud: pointer)` | `currentIndexChanged`, `valueChanged(int)` |
| `CBBool` | `proc(checked: cint, ud: pointer)` | `toggled`, `stateChanged` (1=true, 0=false) |
| `CBIdx` | `proc(row, col: cint, ud: pointer)` | `currentCellChanged`, `itemClicked(row,col)` |
| `CBDouble` | `proc(value: cdouble, ud: pointer)` | `valueChanged(double)` |
| `CBStrStr` | `proc(key, value: cstring, ud: pointer)` | Key-value pair signals |
| `CBIntStr` | `proc(index: cint, text: cstring, ud: pointer)` | Mixed signals (index + text) |

**Example:**

```nim
proc onClicked(ud: pointer) {.cdecl.} =
  echo "Button clicked"

var cb: CB = onClicked
```

> `ud` — user data, passed through C++ unchanged.

---

## 7. Qt Namespace Enumerations

All enums are declared with `{.size: sizeof(cint).}` to match C++ `int` layout.

### QtOrientation

Direction for sliders, splitters, table headers.

| Value | Number | Description |
|---|---|---|
| `Horizontal` | `0x1` | Horizontal direction |
| `Vertical` | `0x2` | Vertical direction |

### QtAlignment

Text and widget alignment flags.

| Value | Number | Description |
|---|---|---|
| `AlignLeft` | `0x0001` | Left edge |
| `AlignRight` | `0x0002` | Right edge |
| `AlignHCenter` | `0x0004` | Horizontally centered |
| `AlignJustify` | `0x0008` | Justified |
| `AlignTop` | `0x0020` | Top edge |
| `AlignBottom` | `0x0040` | Bottom edge |
| `AlignVCenter` | `0x0080` | Vertically centered |
| `AlignBaseline` | `0x0100` | Text baseline |
| `AlignCenter` | `0x0084` | Both centered (HCenter \| VCenter) |

### QtWindowType

Window type and decoration flags.

| Value | Number | Description |
|---|---|---|
| `WF_Widget` | `0x00000000` | Embedded child widget |
| `WF_Window` | `0x00000001` | Independent top-level window |
| `WF_Dialog` | `0x00000003` | Dialog window |
| `WF_Sheet` | `0x00000005` | Attached sheet (macOS) |
| `WF_Popup` | `0x00000009` | Pop-up window |
| `WF_Tool` | `0x00000011` | Tool window |
| `WF_SplashScreen` | `0x0000000D` | Splash screen |
| `WF_Desktop` | `0x00000041` | Desktop |
| `WF_SubWindow` | `0x00000080` | Sub-window (QMdiSubWindow) |
| `WF_ForeignWindow` | `0x00000101` | External app window |
| `WF_CoverWindow` | `0x00000201` | Cover window (mobile OS) |
| `WF_FramelessWindowHint` | `0x00000800` | No window frame |
| `WF_CustomizeWindowHint` | `0x02000000` | Custom decoration set |
| `WF_WindowTitleHint` | `0x00001000` | Show title bar |
| `WF_WindowSystemMenuHint` | `0x00002000` | System menu |
| `WF_WindowMinimizeButtonHint` | `0x00004000` | Minimize button |
| `WF_WindowMaximizeButtonHint` | `0x00008000` | Maximize button |
| `WF_WindowCloseButtonHint` | `0x08000000` | Close button |
| `WF_WindowContextHelpButtonHint` | `0x00010000` | Help button (Windows only) |
| `WF_MacWindowToolBarButtonHint` | `0x10000000` | Toolbar button (macOS) |
| `WF_WindowStaysOnTopHint` | `0x00040000` | Always on top |
| `WF_WindowStaysOnBottomHint` | `0x04000000` | Always below others |
| `WF_WindowTransparentForInput` | `0x00080000` | Does not receive mouse events |
| `WF_WindowOverridesSystemGestures` | `0x00100000` | Intercepts system gestures |

### QtKeyboardModifier

Keyboard modifier flags.

| Value | Number | Description |
|---|---|---|
| `NoModifier` | `0x00000000` | No modifier |
| `ShiftModifier` | `0x02000000` | Shift |
| `ControlModifier` | `0x04000000` | Ctrl (Cmd on macOS) |
| `AltModifier` | `0x08000000` | Alt |
| `MetaModifier` | `0x10000000` | Meta (Win on Windows, Ctrl on macOS) |
| `KeypadModifier` | `0x20000000` | Numeric keypad |
| `GroupSwitchModifier` | `0x40000000` | GroupSwitch (Linux X11) |

### QtMouseButton

Mouse buttons.

| Value | Number | Description |
|---|---|---|
| `NoButton` | `0x00000000` | No button |
| `LeftButton` | `0x00000001` | Left button |
| `RightButton` | `0x00000002` | Right button |
| `MiddleButton` | `0x00000004` | Middle button (wheel) |
| `BackButton` | `0x00000008` | Back (side button) |
| `ForwardButton` | `0x00000010` | Forward (side button) |
| `TaskButton` | `0x00000020` | Task button |
| `ExtraButton4` | `0x00000040` | Extra button 4 |
| `ExtraButton5` | `0x00000080` | Extra button 5 |

### QtSortOrder

| Value | Number | Description |
|---|---|---|
| `AscendingOrder` | `0` | Ascending (A→Z, 0→9) |
| `DescendingOrder` | `1` | Descending (Z→A, 9→0) |

### QtCheckState

| Value | Number | Description |
|---|---|---|
| `Unchecked` | `0` | Not checked |
| `PartiallyChecked` | `1` | Partially checked (tristate) |
| `Checked` | `2` | Checked |

### QtItemFlag

Model item flags (QAbstractItemModel).

| Value | Number | Description |
|---|---|---|
| `ItemIsSelectable` | `1` | Can be selected |
| `ItemIsEditable` | `2` | Can be edited |
| `ItemIsDragEnabled` | `4` | Can be dragged |
| `ItemIsDropEnabled` | `8` | Can receive drops |
| `ItemIsUserCheckable` | `16` | Has a checkbox |
| `ItemIsEnabled` | `32` | Is enabled |
| `ItemIsAutoTristate` | `64` | Auto tristate checkbox |
| `ItemNeverHasChildren` | `128` | Cannot have children |
| `ItemIsUserTristate` | `256` | User-controlled tristate |

### QtDockWidgetArea

| Value | Number | Description |
|---|---|---|
| `NoDockWidgetArea` | `0x00` | No docking area |
| `LeftDockWidgetArea` | `0x01` | Left panel |
| `RightDockWidgetArea` | `0x02` | Right panel |
| `TopDockWidgetArea` | `0x04` | Top panel |
| `BottomDockWidgetArea` | `0x08` | Bottom panel |
| `AllDockWidgetAreas` | `0x0f` | All sides |

### QtScrollBarPolicy

| Value | Number | Description |
|---|---|---|
| `ScrollBarAsNeeded` | `0` | Show only when needed |
| `ScrollBarAlwaysOff` | `1` | Always hidden |
| `ScrollBarAlwaysOn` | `2` | Always visible |

### QtFocusPolicy

| Value | Number | Description |
|---|---|---|
| `NoFocus` | `0` | Does not accept focus |
| `TabFocus` | `0x1` | Tab key only |
| `ClickFocus` | `0x2` | Mouse click only |
| `StrongFocus` | `0x11` | Tab and click (recommended) |
| `WheelFocus` | `0x13` | StrongFocus + mouse wheel |

### QtCursorShape

| Value | Number | Description |
|---|---|---|
| `ArrowCursor` | `0` | Standard arrow |
| `UpArrowCursor` | `1` | Arrow pointing up |
| `CrossCursor` | `2` | Crosshair |
| `WaitCursor` | `3` | Hourglass / spinner |
| `IBeamCursor` | `4` | Text cursor |
| `SizeVerCursor` | `5` | Vertical resize |
| `SizeHorCursor` | `6` | Horizontal resize |
| `SizeBDiagCursor` | `7` | Diagonal resize ↗↙ |
| `SizeFDiagCursor` | `8` | Diagonal resize ↖↘ |
| `SizeAllCursor` | `9` | Move (all directions) |
| `BlankCursor` | `10` | Invisible cursor |
| `SplitVCursor` | `11` | Vertical splitter |
| `SplitHCursor` | `12` | Horizontal splitter |
| `PointingHandCursor` | `13` | Pointing hand (links) |
| `ForbiddenCursor` | `14` | Forbidden / no-drop |
| `WhatsThisCursor` | `15` | What's this? |
| `BusyCursor` | `16` | Busy |
| `OpenHandCursor` | `17` | Open hand |
| `ClosedHandCursor` | `18` | Closed hand (grab) |
| `DragCopyCursor` | `19` | Copy while dragging |
| `DragMoveCursor` | `20` | Move while dragging |
| `DragLinkCursor` | `21` | Create link while dragging |

### QtTextFormat

| Value | Number | Description |
|---|---|---|
| `PlainText` | `0` | Plain text |
| `RichText` | `1` | HTML markup |
| `AutoText` | `2` | Qt auto-detects |
| `MarkdownText` | `3` | Markdown (Qt 5.14+) |

### QtConnectionType

| Value | Number | Description |
|---|---|---|
| `AutoConnection` | `0` | Auto-selected (recommended) |
| `DirectConnection` | `1` | Direct call (same thread) |
| `QueuedConnection` | `2` | Event queue (cross-thread safe) |
| `BlockingQueuedConnection` | `3` | Blocking queued (waits for completion) |
| `UniqueConnection` | `0x80` | Single connection only |
| `SingleShotConnection` | `0x100` | One-shot connection (Qt 6.0+) |

### QtSizePolicyPolicy

| Value | Number | Description |
|---|---|---|
| `SPFixed` | `0` | Fixed size |
| `SPMinimum` | `0x1` | Minimum, no smaller than sizeHint |
| `SPMaximum` | `0x4` | Maximum, no larger than sizeHint |
| `SPPreferred` | `0x8` | Preferred size |
| `SPExpanding` | `0x38` | Can grow |
| `SPMinimumExpanding` | `0x31` | Minimum + can grow |
| `SPIgnored` | `0x38` | Ignore sizeHint |

### QtLayoutDirection

| Value | Number | Description |
|---|---|---|
| `LeftToRight` | `0` | Left-to-right (LTR) |
| `RightToLeft` | `1` | Right-to-left (RTL: Arabic, Hebrew) |
| `LayoutDirectionAuto` | `2` | Auto-detect from locale |

### QtBrushStyle

| Value | Number | Description |
|---|---|---|
| `NoBrush` | `0` | No fill |
| `SolidPattern` | `1` | Solid fill |
| `Dense1Pattern`–`Dense7Pattern` | `2`–`8` | Dense to sparse hatching |
| `HorPattern` | `9` | Horizontal lines |
| `VerPattern` | `10` | Vertical lines |
| `CrossPattern` | `11` | Grid |
| `BDiagPattern` | `12` | Diagonal ↗ |
| `FDiagPattern` | `13` | Diagonal ↘ |
| `DiagCrossPattern` | `14` | Diagonal grid |
| `LinearGradientPattern` | `15` | Linear gradient |
| `RadialGradientPattern` | `16` | Radial gradient |
| `ConicalGradientPattern` | `17` | Conical gradient |
| `TexturePattern` | `24` | Texture (image) |

### QtPenStyle

| Value | Number | Description |
|---|---|---|
| `NoPen` | `0` | No line |
| `SolidLine` | `1` | Solid |
| `DashLine` | `2` | Dashed (–  –  –) |
| `DotLine` | `3` | Dotted (·  ·  ·) |
| `DashDotLine` | `4` | Dash-dot (– · –) |
| `DashDotDotLine` | `5` | Dash-dot-dot |
| `CustomDashLine` | `6` | Custom pattern |

### QtPenCapStyle

| Value | Number | Description |
|---|---|---|
| `FlatCap` | `0x00` | Flat end |
| `SquareCap` | `0x10` | Square end (extends beyond endpoint) |
| `RoundCap` | `0x20` | Round end |

### QtPenJoinStyle

| Value | Number | Description |
|---|---|---|
| `MiterJoin` | `0x00` | Sharp miter join |
| `BevelJoin` | `0x40` | Beveled join |
| `RoundJoin` | `0x80` | Rounded join |
| `SvgMiterJoin` | `0x100` | SVG-compatible miter |

### QtFillRule

| Value | Number | Description |
|---|---|---|
| `OddEvenFill` | `0` | Odd-even (alternating) rule |
| `WindingFill` | `1` | Non-zero winding rule |

### QtGlobalColor

| Value | Number | Color |
|---|---|---|
| `color_black` | `2` | Black (#000000) |
| `color_white` | `3` | White (#ffffff) |
| `color_darkGray` | `4` | Dark gray (#808080) |
| `color_gray` | `5` | Gray (#a0a0a4) |
| `color_lightGray` | `6` | Light gray (#c0c0c0) |
| `color_red` | `7` | Red (#ff0000) |
| `color_green` | `8` | Green (#00ff00) |
| `color_blue` | `9` | Blue (#0000ff) |
| `color_cyan` | `10` | Cyan (#00ffff) |
| `color_magenta` | `11` | Magenta (#ff00ff) |
| `color_yellow` | `12` | Yellow (#ffff00) |
| `color_darkRed` | `13` | Dark red (#800000) |
| `color_darkGreen` | `14` | Dark green (#008000) |
| `color_darkBlue` | `15` | Dark blue (#000080) |
| `color_darkCyan` | `16` | Dark cyan (#008080) |
| `color_darkMagenta` | `17` | Dark magenta (#800080) |
| `color_darkYellow` | `18` | Dark yellow (#808000) |
| `color_transparent` | `19` | Transparent |

### QtItemDataRole

| Value | Number | Description |
|---|---|---|
| `DisplayRole` | `0` | Display text |
| `DecorationRole` | `1` | Icon |
| `EditRole` | `2` | Value for editing |
| `ToolTipRole` | `3` | Tooltip text |
| `StatusTipRole` | `4` | Status bar text |
| `WhatsThisRole` | `5` | What's This text |
| `FontRole` | `6` | Font |
| `TextAlignmentRole` | `7` | Text alignment |
| `BackgroundRole` | `8` | Background color |
| `ForegroundRole` | `9` | Foreground color |
| `CheckStateRole` | `10` | Checkbox state |
| `AccessibleTextRole` | `11` | Accessible text |
| `AccessibleDescriptionRole` | `12` | Accessible description |
| `SizeHintRole` | `13` | Size hint |
| `InitialSortOrderRole` | `14` | Initial sort order |
| `UserRole` | `256` | First user-defined role |

### QtToolButtonStyle

| Value | Number | Description |
|---|---|---|
| `ToolButtonIconOnly` | `0` | Icon only |
| `ToolButtonTextOnly` | `1` | Text only |
| `ToolButtonTextBesideIcon` | `2` | Text beside icon |
| `ToolButtonTextUnderIcon` | `3` | Text under icon |
| `ToolButtonFollowStyle` | `4` | Follow application style |

### QtArrowType

| Value | Number | Description |
|---|---|---|
| `NoArrow` | `0` | No arrow |
| `UpArrow` | `1` | Up |
| `DownArrow` | `2` | Down |
| `LeftArrow` | `3` | Left |
| `RightArrow` | `4` | Right |

### QtFrameShape / QtFrameShadow

**QtFrameShape:**

| Value | Number | Description |
|---|---|---|
| `NoFrame` | `0` | No frame |
| `Box` | `0x0001` | Box frame |
| `Panel` | `0x0002` | Panel frame |
| `WinPanel` | `0x0003` | Windows-style panel |
| `HLine` | `0x0004` | Horizontal line |
| `VLine` | `0x0005` | Vertical line |
| `StyledPanel` | `0x0006` | Style-drawn panel |

**QtFrameShadow:**

| Value | Number | Description |
|---|---|---|
| `Plain` | `0x0010` | No shadow |
| `Raised` | `0x0020` | Raised appearance |
| `Sunken` | `0x0030` | Sunken appearance |

### QtAspectRatioMode

| Value | Number | Description |
|---|---|---|
| `IgnoreAspectRatio` | `0` | Ignore aspect ratio |
| `KeepAspectRatio` | `1` | Keep ratio (fit inside) |
| `KeepAspectRatioByExpanding` | `2` | Keep ratio (fill outside) |

### QtTransformationMode

| Value | Number | Description |
|---|---|---|
| `FastTransformation` | `0` | Fast (no anti-aliasing) |
| `SmoothTransformation` | `1` | Smooth (slower) |

### QtImageFormat

| Value | Number | Description |
|---|---|---|
| `Format_Invalid` | `0` | Invalid format |
| `Format_Mono` | `1` | 1 bit per pixel |
| `Format_Indexed8` | `3` | 8-bit indexed |
| `Format_RGB32` | `4` | 32-bit (0xffRRGGBB) |
| `Format_ARGB32` | `5` | 32-bit with alpha |
| `Format_ARGB32_Premultiplied` | `6` | 32-bit premultiplied |
| `Format_RGB16` | `7` | 16-bit (5-6-5) |
| `Format_RGB888` | `13` | 24-bit (8-8-8) |
| `Format_RGBA8888` | `17` | 32-bit RGBA |
| `Format_Alpha8` | `23` | 8-bit alpha only |
| `Format_Grayscale8` | `24` | 8-bit grayscale |
| `Format_Grayscale16` | `28` | 16-bit grayscale |
| `Format_RGBX16FPx4` | `30` | float16×4 (Qt 6.2+) |
| `Format_RGBA32FPx4` | `34` | float32×4 (Qt 6.2+) |
| `Format_CMYK8888` | `36` | 32-bit CMYK (Qt 6.8+) |

### QtFontWeight

| Value | Number | Description |
|---|---|---|
| `Thin` | `100` | Thin |
| `ExtraLight` | `200` | Extra light |
| `Light` | `300` | Light |
| `Normal` | `400` | Normal / Regular |
| `Medium` | `500` | Medium |
| `DemiBold` | `600` | Demi-bold |
| `Bold` | `700` | Bold |
| `ExtraBold` | `800` | Extra bold |
| `Black` | `900` | Black |

### QtDateFormat

| Value | Number | Description |
|---|---|---|
| `TextDate` | `0` | Qt text format (locale-dependent) |
| `ISODate` | `1` | ISO 8601: `yyyy-MM-dd` |
| `RFC2822Date` | `8` | RFC 2822 (email format) |
| `ISODateWithMs` | `9` | ISO 8601 with milliseconds |

### QtScrollHint

| Value | Number | Description |
|---|---|---|
| `EnsureVisible` | `0` | Item is visible |
| `PositionAtTop` | `1` | Item at top of viewport |
| `PositionAtBottom` | `2` | Item at bottom of viewport |
| `PositionAtCenter` | `3` | Item at center of viewport |

### QtMatchFlag

| Value | Number | Description |
|---|---|---|
| `MatchExactly` | `0` | Exact string match |
| `MatchContains` | `1` | Substring match |
| `MatchStartsWith` | `2` | Starts with |
| `MatchEndsWith` | `3` | Ends with |
| `MatchRegularExpression` | `4` | Regular expression |
| `MatchWildcard` | `5` | Wildcard (* and ?) |
| `MatchCaseSensitive` | `16` | Case-sensitive |
| `MatchRecursive` | `32` | Recursive search |

### QtFindChildOption

| Value | Number | Description |
|---|---|---|
| `FindDirectChildrenOnly` | `0` | Direct children only |
| `FindChildrenRecursively` | `1` | Recursive (default) |

### QStandardButton

| Value | Number | Description |
|---|---|---|
| `StdBtnNone` | `0x00000000` | No button |
| `StdBtnOk` | `0x00000400` | OK |
| `StdBtnSave` | `0x00000800` | Save |
| `StdBtnSaveAll` | `0x00001000` | Save All |
| `StdBtnOpen` | `0x00002000` | Open |
| `StdBtnYes` | `0x00004000` | Yes |
| `StdBtnYesToAll` | `0x00008000` | Yes to All |
| `StdBtnNo` | `0x00010000` | No |
| `StdBtnNoToAll` | `0x00020000` | No to All |
| `StdBtnAbort` | `0x00040000` | Abort |
| `StdBtnRetry` | `0x00080000` | Retry |
| `StdBtnIgnore` | `0x00100000` | Ignore |
| `StdBtnClose` | `0x00200000` | Close |
| `StdBtnCancel` | `0x00400000` | Cancel |
| `StdBtnDiscard` | `0x00800000` | Discard |
| `StdBtnHelp` | `0x01000000` | Help |
| `StdBtnApply` | `0x02000000` | Apply |
| `StdBtnReset` | `0x04000000` | Reset |
| `StdBtnRestoreDefaults` | `0x08000000` | Restore Defaults |

### QDialogButtonRole

| Value | Number | Description |
|---|---|---|
| `InvalidRole` | `-1` | Invalid role |
| `AcceptRole` | `0` | Accept (OK/Yes/Save) |
| `RejectRole` | `1` | Reject (Cancel/No) |
| `DestructiveRole` | `2` | Destructive (Discard) |
| `ActionRole` | `3` | Arbitrary action |
| `HelpRole` | `4` | Help |
| `YesRole` | `5` | Yes |
| `NoRole` | `6` | No |
| `ResetRole` | `7` | Reset settings |
| `ApplyRole` | `8` | Apply (without closing) |

### QtTextInteractionFlag

| Value | Number | Description |
|---|---|---|
| `NoTextInteraction` | `0` | No interaction |
| `TextSelectableByMouse` | `1` | Mouse selection |
| `TextSelectableByKeyboard` | `2` | Keyboard selection |
| `LinksAccessibleByMouse` | `4` | Links via mouse |
| `LinksAccessibleByKeyboard` | `8` | Links via keyboard |
| `TextEditable` | `16` | Editable |
| `TextEditorInteraction` | `19` | Editor mode |
| `BrowserTextInteraction` | `13` | Browser mode |

### QtDropAction

| Value | Number | Description |
|---|---|---|
| `CopyAction` | `0x1` | Copy on drop |
| `MoveAction` | `0x2` | Move on drop |
| `LinkAction` | `0x4` | Create link on drop |
| `IgnoreAction` | `0x0` | Ignore drop |
| `TargetMoveAction` | `0x8002` | Move (target widget decides) |

### QtKey

| Value | Code | Description |
|---|---|---|
| `Key_Escape` | `0x01000000` | Escape |
| `Key_Tab` | `0x01000001` | Tab |
| `Key_Backspace` | `0x01000003` | Backspace |
| `Key_Return` | `0x01000004` | Enter (main keyboard) |
| `Key_Enter` | `0x01000005` | Enter (numeric keypad) |
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
| `Key_Meta` | `0x01000022` | Meta / Win |
| `Key_Alt` | `0x01000023` | Alt |
| `Key_F1`–`Key_F12` | `0x01000030`–`0x0100003b` | Function keys |
| `Key_Space` | `0x20` | Space |
| `Key_A`–`Key_Z` | `0x41`–`0x5A` | Latin letters |
| `Key_0`–`Key_9` | `0x30`–`0x39` | Digits |

### QStandardPathLocation

| Value | Number | Description |
|---|---|---|
| `DesktopLocation` | `0` | User's desktop |
| `DocumentsLocation` | `1` | User's documents |
| `FontsLocation` | `2` | System fonts |
| `ApplicationsLocation` | `3` | Applications folder |
| `MusicLocation` | `4` | Music |
| `MoviesLocation` | `5` | Movies / Videos |
| `PicturesLocation` | `6` | Pictures |
| `TempLocation` | `7` | Temporary files |
| `HomeLocation` | `8` | Home directory |
| `AppLocalDataLocation` | `9` | Local app data |
| `CacheLocation` | `10` | App cache |
| `GenericDataLocation` | `11` | Generic data (not app-specific) |
| `RuntimeLocation` | `12` | Runtime files (PID, sockets) |
| `ConfigLocation` | `13` | App configuration |
| `DownloadLocation` | `14` | Downloads |
| `GenericCacheLocation` | `15` | Generic cache |
| `GenericConfigLocation` | `16` | Generic config |
| `AppConfigLocation` | `17` | App-specific config |
| `PublicShareLocation` | `18` | Public share folder |
| `TemplatesLocation` | `19` | Templates |
| `StateLocation` | `20` | App state (Qt 5.14+) |
| `GenericStateLocation` | `21` | Generic state (Qt 5.14+) |

---

## 8. Runtime Qt Version

| Function | Signature | Description |
|---|---|---|
| `qtVersionStr` | `(): string` | Version string, e.g. `"6.7.2"` |
| `qtVersionMajor` | `(): int` | Major version (always 6 for Qt6) |
| `qtVersionMinor` | `(): int` | Minor version |
| `qtVersionPatch` | `(): int` | Patch version |
| `qtVersionCheck` | `(major, minor, patch: int): bool` | Is version >= given? |

```nim
echo qtVersionStr()                     # "6.7.2"
if qtVersionCheck(6, 5, 0):
  echo "Qt 6.5+ — QPermission API available"
```

---

## 9. Math Helpers

Thin wrappers over Qt math from `<QtMath>`.

| Function | Signature | Description |
|---|---|---|
| `qFuzzyCompare` | `(a, b: float64): bool` | Floating-point equality with tolerance |
| `qFuzzyCompareF` | `(a, b: float32): bool` | Same for float32 |
| `qFuzzyIsNull` | `(a: float64): bool` | Is value close to zero? |
| `qRound` | `(a: float64): int` | Round to nearest integer |
| `qRound64` | `(a: float64): int64` | Round to int64 |
| `qAbs` | `(a: int): int` | Absolute value (integer) |
| `qAbsF` | `(a: float64): float64` | Absolute value (float) |
| `qMax` | `(a, b: int): int` | Maximum of two integers |
| `qMin` | `(a, b: int): int` | Minimum of two integers |
| `qMaxF` | `(a, b: float64): float64` | Maximum of two floats |
| `qMinF` | `(a, b: float64): float64` | Minimum of two floats |
| `qBound` | `(lo, v, hi: int): int` | Clamp integer to [lo, hi] |
| `qBoundF` | `(lo, v, hi: float64): float64` | Clamp float to [lo, hi] |
| `qDegreesToRadians` | `(degrees: float64): float64` | Degrees to radians |
| `qRadiansToDegrees` | `(radians: float64): float64` | Radians to degrees |
| `qNextPowerOfTwo` | `(n: uint32): uint32` | Next power of two >= n |

```nim
let angle   = qDegreesToRadians(45.0)    # 0.7853...
let clamped = qBound(0, 150, 100)        # 100
let safe    = qFuzzyCompare(0.1+0.2, 0.3) # true
```

---

## 10. System Information (QSysInfo)

### Individual functions

| Function | Description | Example return |
|---|---|---|
| `sysProductName()` | Full OS name | `"Windows 11 Version 23H2"` |
| `sysProductType()` | OS type | `"windows"`, `"ubuntu"`, `"macos"` |
| `sysProductVersion()` | OS version | `"11"`, `"22.04"`, `"14.0"` |
| `sysCpuArch()` | Current CPU arch | `"x86_64"`, `"arm64"` |
| `sysBuildCpuArch()` | Qt build CPU arch | `"x86_64"` |
| `sysKernelType()` | Kernel type | `"winnt"`, `"linux"`, `"darwin"` |
| `sysKernelVersion()` | Kernel version | `"10.0.22621"` |
| `sysMachineHostName()` | Host name | `"my-pc"` |
| `sysMachineUniqueId()` | Machine UUID | UUID string |
| `sysBootUniqueId()` | Current boot ID | Changes on each boot |

### `SysInfo` type and `getSysInfo()`

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

## 11. Standard OS Paths (QStandardPaths)

| Function | Signature | Description |
|---|---|---|
| `standardPath` | `(loc): string` | Single writable path |
| `standardPaths` | `(loc): seq[string]` | All paths (including system) |
| `standardPathsFind` | `(loc, filename): string` | Find file in paths |
| `displayName` | `(loc): string` | Human-readable name |

```nim
let docs = standardPath(DocumentsLocation)
# Linux: "/home/user/Documents"
# Windows: "C:/Users/user/Documents"

let cfg = standardPathsFind(ConfigLocation, "myapp/settings.ini")
```

---

## 12. Environment Variables

| Function | Signature | Description |
|---|---|---|
| `envValue` | `(key, default=""): string` | Get variable value |
| `envContains` | `(key): bool` | Variable exists? |
| `envKeys` | `(): seq[string]` | All variable names |

```nim
let home = envValue("HOME")
let port = envValue("PORT", "8080")
if envContains("DEBUG_MODE"): enableDebug()
```

---

## 13. File System

Fast helpers built on `QDir`, `QFile`, `QFileInfo` — no Nim object allocation.

| Function | Signature | Description |
|---|---|---|
| `dirExists` | `(path): bool` | Directory exists? |
| `fileExists` | `(path): bool` | File exists? |
| `mkPath` | `(path): bool` | Create all directories (mkdir -p) |
| `fileSize` | `(path): int64` | File size in bytes (-1 if missing) |
| `fileSuffix` | `(path): string` | Extension without dot (`"gz"`) |
| `fileCompleteSuffix` | `(path): string` | Full extension (`"tar.gz"`) |
| `fileBaseName` | `(path): string` | Name without extension (`"doc"`) |
| `fileCompleteBaseName` | `(path): string` | Full base name (`"doc.tar"`) |
| `fileName` | `(path): string` | Filename with extension |
| `dirName` | `(path): string` | Parent directory |
| `absPath` | `(path): string` | Absolute path (resolves `..` and `.`) |
| `canonicalPath` | `(path): string` | Canonical path (resolves symlinks) |
| `isAbsPath` | `(path): bool` | Is path absolute? |
| `joinPath` | `(parts: varargs): string` | Join path segments |
| `pathSeparator` | `(): char` | Path separator (`/` or `\`) |
| `cleanPath` | `(path): string` | Normalize path (remove `//`, `..`) |

```nim
let p = joinPath(standardPath(HomeLocation), "documents", "report.pdf")
if fileExists(p):
  echo "Size: ", fileSize(p), " bytes"
  echo "Extension: ", fileSuffix(p)  # "pdf"
```

---

## 14. Dynamic Library Loading

### `qtLibIsLoaded(libName: string): bool`

Attempt to load a dynamic library and check success.

```nim
if qtLibIsLoaded(libQt6WebEngineCore):
  enableBrowserTab()
else:
  echo "WebEngine not installed"
```

### `qtLibVersion(libName: string): string`

Returns the full file path of the loaded library.

```nim
echo qtLibVersion(libQt6Core)  # "/usr/lib/libQt6Core.so.6"
```

**Typical pattern for optional modules:**

```nim
const hasWebEngine = qtLibIsLoaded(libQt6WebEngineCore)
when hasWebEngine:
  enableWebView()
```

---

## 15. Logging & Debugging

Qt message system wrappers. Output is routed to Qt Creator, journald, console, etc.

| Function | Level | Description |
|---|---|---|
| `qDebug(msg)` | Debug | Debug message |
| `qInfo(msg)` | Info | Informational message |
| `qWarning(msg)` | Warning | Warning |
| `qCritical(msg)` | Critical | Critical error |
| `qFatalMsg(msg)` | Fatal | Fatal error + process exit |
| `qSetMessagePattern(pattern)` | — | Set message output format |
| `qSetLoggingRule(rule)` | — | Filter logging categories |
| `qSuppressMessages()` | — | Suppress all Qt output |
| `qRestoreMessages()` | — | Restore default message handler |

**Pattern variables:** `%{appname}`, `%{category}`, `%{file}`, `%{function}`, `%{line}`, `%{message}`, `%{pid}`, `%{threadid}`, `%{time}`, `%{type}`

```nim
qSetMessagePattern("%{time yyyy-MM-dd HH:mm:ss} [%{type}] %{message}")
qSetLoggingRule("*.debug=false\napp.network=true")

qDebug("Application started")
qWarning("Config not found, using defaults")

# Unit test pattern:
qSuppressMessages()
runTests()
qRestoreMessages()
```

---

## 16. Version Parsing (QVersionNumber)

### `parseVersion(versionStr: string): tuple[major, minor, patch: int]`

```nim
let v = parseVersion("6.7.2")
echo v.major, ".", v.minor, ".", v.patch  # 6.7.2
```

### `compareVersions(a, b: string): int`

Returns `-1`, `0`, or `1`.

```nim
if compareVersions(qtVersionStr(), "6.5.0") >= 0:
  echo "Qt 6.5+ supported"
```

---

## 17. Compile-time Constants

| Constant | Type | Description |
|---|---|---|
| `QtMinCppStandard` | `int = 17` | Minimum C++ standard for Qt6 |
| `QtRecommendedCppStandard` | `int = 20` | Recommended C++ standard |
| `QtPlatformWindows` | `bool` | `true` on Windows |
| `QtPlatformLinux` | `bool` | `true` on Linux |
| `QtPlatformMacos` | `bool` | `true` on macOS |

```nim
when QtPlatformLinux:
  let libPath = "/usr/lib/x86_64-linux-gnu"
elif QtPlatformWindows:
  let libPath = "C:/Windows/System32"
```

---

## 18. Quick-Reference Table

| What you need | Symbol | Section |
|---|---|---|
| dll/so library name | `libQt6Core`, `libQt6Widgets`, … | §3 |
| Callback for button | `CB` | §6 |
| Callback with text | `CBStr` | §6 |
| Alignment | `QtAlignment` | §7 |
| Window type | `QtWindowType` | §7 |
| Key codes | `QtKey` | §7 |
| Image formats | `QtImageFormat` | §7 |
| Qt version | `qtVersionStr`, `qtVersionCheck` | §8 |
| Float comparison | `qFuzzyCompare` | §9 |
| Clamp value | `qBound`, `qBoundF` | §9 |
| OS name | `sysProductName`, `getSysInfo` | §10 |
| Documents folder | `standardPath(DocumentsLocation)` | §11 |
| Home directory | `standardPath(HomeLocation)` | §11 |
| Environment variable | `envValue` | §12 |
| File exists | `fileExists`, `dirExists` | §13 |
| File extension | `fileSuffix`, `fileCompleteSuffix` | §13 |
| Normalize path | `cleanPath`, `absPath` | §13 |
| Optional Qt module | `qtLibIsLoaded` | §14 |
| Logging | `qDebug`, `qWarning`, `qCritical` | §15 |
| Version comparison | `compareVersions` | §16 |
| Platform (compile-time) | `QtPlatformLinux`, … | §17 |

---

*Reference generated from `nimQtFFI.nim` source. Compatibility: Qt 6.2 – Qt 6.11.*
