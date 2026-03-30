## nimQtGui.nim — Полная обёртка Qt6Gui для Nim (nim cpp --passC:"-std=c++20")
##
## Включает:
##   QGuiApplication, QScreen, QWindow,
##   QPainter, QPen, QBrush, QColor,
##   QFont, QFontMetrics, QFontDatabase,
##   QImage, QPixmap, QBitmap, QPicture,
##   QIcon, QIconEngine,
##   QCursor, QDrag,
##   QTransform, QMatrix4x4, QVector2D, QVector3D, QVector4D, QQuaternion,
##   QKeyEvent, QMouseEvent, QWheelEvent, QResizeEvent, QPaintEvent,
##   QTabletEvent, QTouchEvent, QInputMethodEvent,
##   QClipboard, QMimeData,
##   QPalette, QStyleHints,
##   QOpenGLContext (forward),
##   QSurface, QSurfaceFormat,
##   QBackingStore,
##   QAccessible,
##   QRawFont, QGlyphRun,
##   QTextDocument (forward),
##   QLinearGradient, QRadialGradient, QConicalGradient,
##   QRegion, QPainterPath,
##   QPolygon, QPolygonF
##
## Импортирует: nimQtUtils (базовые типы), nimQtFFI (константы/enums)
##
## Компиляция:
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Gui)" \
##     --passL:"$(pkg-config --libs Qt6Gui)" \
##     app.nim

when defined(windows):
  {.passC: "-IC:/msys64/ucrt64/include".}
  {.passC: "-IC:/msys64/ucrt64/include/QtWidgets".}
  {.passC: "-IC:/msys64/ucrt64/include/QtGui".}
  {.passC: "-IC:/msys64/ucrt64/include/QtCore".}
  {.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
  {.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
# На Linux пути передаются снаружи через pkg-config


import nimQtUtils
import nimQtFFI

{.emit: """
#include <QGuiApplication>
#include <QScreen>
#include <QWindow>
#include <QPainter>
#include <QPainterPath>
#include <QPen>
#include <QBrush>
#include <QColor>
#include <QFont>
#include <QFontMetrics>
#include <QFontMetricsF>
#include <QFontDatabase>
#include <QFontInfo>
#include <QImage>
#include <QPixmap>
#include <QBitmap>
#include <QPicture>
#include <QIcon>
#include <QCursor>
#include <QDrag>
#include <QTransform>
#include <QMatrix4x4>
#include <QVector2D>
#include <QVector3D>
#include <QVector4D>
#include <QQuaternion>
#include <QKeyEvent>
#include <QMouseEvent>
#include <QWheelEvent>
#include <QResizeEvent>
#include <QPaintEvent>
#include <QInputEvent>
#include <QTabletEvent>
#include <QClipboard>
#include <QMimeData>
#include <QPalette>
#include <QStyleHints>
#include <QSurface>
#include <QSurfaceFormat>
#include <QBackingStore>
#include <QLinearGradient>
#include <QRadialGradient>
#include <QConicalGradient>
#include <QRegion>
#include <QPolygon>
#include <QPolygonF>
#include <QTextOption>
#include <QTextLayout>
#include <QStaticText>
#include <QAccessible>
#include <QRawFont>
#include <QGlyphRun>
#include <QPageSize>
#include <QPageLayout>
#include <QColorSpace>
#include <QColorTransform>
#include <QImageReader>
#include <QImageWriter>
#include <QMovie>
#include <QDesktopServices>
#include <functional>
#include <cstring>

// Синглтон QGuiApplication
static int   _nim_gui_argc = 0;
static char* _nim_gui_argv[] = {nullptr};
static QGuiApplication* _nim_gui_app = nullptr;
""".}

# ── Opaque типы Qt6Gui ────────────────────────────────────────────────────────
type
  QGuiApplication*  {.importcpp: "QGuiApplication",  header: "<QGuiApplication>".}  = object
  QScreen*          {.importcpp: "QScreen",           header: "<QScreen>".}          = object
  QWindow*          {.importcpp: "QWindow",           header: "<QWindow>".}          = object
  QPainter*         {.importcpp: "QPainter",          header: "<QPainter>".}         = object
  QPainterPath*     {.importcpp: "QPainterPath",      header: "<QPainterPath>".}     = object
  QPen*             {.importcpp: "QPen",              header: "<QPen>".}             = object
  QBrush*           {.importcpp: "QBrush",            header: "<QBrush>".}           = object
  QFont*            {.importcpp: "QFont",             header: "<QFont>".}            = object
  QFontMetrics*     {.importcpp: "QFontMetrics",      header: "<QFontMetrics>".}     = object
  QFontMetricsF*    {.importcpp: "QFontMetricsF",     header: "<QFontMetricsF>".}    = object
  QFontInfo*        {.importcpp: "QFontInfo",         header: "<QFontInfo>".}        = object
  QImage*           {.importcpp: "QImage",            header: "<QImage>".}           = object
  QPixmap*          {.importcpp: "QPixmap",           header: "<QPixmap>".}          = object
  QBitmap*          {.importcpp: "QBitmap",           header: "<QBitmap>".}          = object
  QPicture*         {.importcpp: "QPicture",          header: "<QPicture>".}         = object
  QIcon*            {.importcpp: "QIcon",             header: "<QIcon>".}            = object
  QCursor*          {.importcpp: "QCursor",           header: "<QCursor>".}          = object
  QDrag*            {.importcpp: "QDrag",             header: "<QDrag>".}            = object
  QTransform*       {.importcpp: "QTransform",        header: "<QTransform>".}       = object
  QMatrix4x4*       {.importcpp: "QMatrix4x4",        header: "<QMatrix4x4>".}       = object
  QVector2D*        {.importcpp: "QVector2D",         header: "<QVector2D>".}        = object
  QVector3D*        {.importcpp: "QVector3D",         header: "<QVector3D>".}        = object
  QVector4D*        {.importcpp: "QVector4D",         header: "<QVector4D>".}        = object
  QQuaternion*      {.importcpp: "QQuaternion",       header: "<QQuaternion>".}      = object
  QKeyEvent*        {.importcpp: "QKeyEvent",         header: "<QKeyEvent>".}        = object
  QMouseEvent*      {.importcpp: "QMouseEvent",       header: "<QMouseEvent>".}      = object
  QWheelEvent*      {.importcpp: "QWheelEvent",       header: "<QWheelEvent>".}      = object
  QResizeEvent*     {.importcpp: "QResizeEvent",      header: "<QResizeEvent>".}     = object
  QPaintEvent*      {.importcpp: "QPaintEvent",       header: "<QPaintEvent>".}      = object
  QClipboard*       {.importcpp: "QClipboard",        header: "<QClipboard>".}       = object
  QMimeData*        {.importcpp: "QMimeData",         header: "<QMimeData>".}        = object
  QPalette*         {.importcpp: "QPalette",          header: "<QPalette>".}         = object
  QStyleHints*      {.importcpp: "QStyleHints",       header: "<QStyleHints>".}      = object
  QSurface*         {.importcpp: "QSurface",          header: "<QSurface>".}         = object
  QSurfaceFormat*   {.importcpp: "QSurfaceFormat",    header: "<QSurfaceFormat>".}   = object
  QBackingStore*    {.importcpp: "QBackingStore",     header: "<QBackingStore>".}    = object
  QLinearGradient*  {.importcpp: "QLinearGradient",   header: "<QLinearGradient>".}  = object
  QRadialGradient*  {.importcpp: "QRadialGradient",   header: "<QRadialGradient>".}  = object
  QConicalGradient* {.importcpp: "QConicalGradient",  header: "<QConicalGradient>".} = object
  QRegion*          {.importcpp: "QRegion",           header: "<QRegion>".}          = object
  QPolygon*         {.importcpp: "QPolygon",          header: "<QPolygon>".}         = object
  QPolygonF*        {.importcpp: "QPolygonF",         header: "<QPolygonF>".}        = object
  QTextOption*      {.importcpp: "QTextOption",       header: "<QTextOption>".}      = object
  QStaticText*      {.importcpp: "QStaticText",       header: "<QStaticText>".}      = object
  QPageSize*        {.importcpp: "QPageSize",         header: "<QPageSize>".}        = object
  QPageLayout*      {.importcpp: "QPageLayout",       header: "<QPageLayout>".}      = object
  QColorSpace*      {.importcpp: "QColorSpace",       header: "<QColorSpace>".}      = object
  QImageReader*     {.importcpp: "QImageReader",      header: "<QImageReader>".}     = object
  QImageWriter*     {.importcpp: "QImageWriter",      header: "<QImageWriter>".}     = object
  QMovie*           {.importcpp: "QMovie",            header: "<QMovie>".}           = object
  QRawFont*         {.importcpp: "QRawFont",          header: "<QRawFont>".}         = object
  QGlyphRun*        {.importcpp: "QGlyphRun",         header: "<QGlyphRun>".}        = object

# Удобные псевдонимы
type
  GuiApp*   = ptr QGuiApplication
  Scr*      = ptr QScreen
  Win*      = ptr QWindow
  Pntr*     = ptr QPainter
  Fnt*      = ptr QFont
  Img*      = ptr QImage
  Pxm*      = ptr QPixmap
  Ico*      = ptr QIcon
  Pal*      = ptr QPalette
  MimeD*    = ptr QMimeData
  Clip*     = ptr QClipboard
  Mov*      = ptr QMovie

# ── Дополнительные enums для Qt6Gui ──────────────────────────────────────────
type
  QPainterRenderHint* {.size: sizeof(cint).} = enum
    Antialiasing            = 0x01
    TextAntialiasing        = 0x02
    SmoothPixmapTransform   = 0x04
    VerticalSubpixelPositioning = 0x08
    LosslessImageRendering  = 0x40
    NonCosmeticBrushPatterns= 0x80

  QPainterCompositionMode* {.size: sizeof(cint).} = enum
    CompositionMode_SourceOver      = 0
    CompositionMode_DestinationOver = 1
    CompositionMode_Clear           = 2
    CompositionMode_Source          = 3
    CompositionMode_Destination     = 4
    CompositionMode_SourceIn        = 5
    CompositionMode_DestinationIn   = 6
    CompositionMode_SourceOut       = 7
    CompositionMode_DestinationOut  = 8
    CompositionMode_SourceAtop      = 9
    CompositionMode_DestinationAtop = 10
    CompositionMode_Xor             = 11
    CompositionMode_Plus            = 12
    CompositionMode_Multiply        = 13
    CompositionMode_Screen          = 14
    CompositionMode_Overlay         = 15
    CompositionMode_Darken          = 16
    CompositionMode_Lighten         = 17
    CompositionMode_ColorDodge      = 18
    CompositionMode_ColorBurn       = 19
    CompositionMode_HardLight       = 20
    CompositionMode_SoftLight       = 21
    CompositionMode_Difference      = 22
    CompositionMode_Exclusion       = 23

  QFontStyleHint* {.size: sizeof(cint).} = enum
    AnyStyle    = 0
    SansSerif   = 2
    Serif       = 1
    Monospace   = 7
    Cursive     = 5
    Fantasy     = 6
    Decorative  = 3
    System      = 9
    Helvetica   = 2
    Times       = 1
    Courier     = 7

  QFontStyleStrategy* {.size: sizeof(cint).} = enum
    PreferDefault    = 0x0001
    PreferBitmap     = 0x0002
    PreferDevice     = 0x0004
    PreferOutline    = 0x0008
    ForceOutline     = 0x0010
    PreferMatch      = 0x0020
    PreferQuality    = 0x0040
    PreferAntialias  = 0x0080
    NoAntialias      = 0x0100
    NoSubpixelAntialias = 0x0800
    PreferNoShaping  = 0x1000
    NoFontMerging    = 0x8000

  QPaletteColorRole* {.size: sizeof(cint).} = enum
    WindowText       = 0
    Button           = 1
    Light            = 2
    Midlight         = 3
    Dark             = 4
    Mid              = 5
    Text             = 6
    BrightText       = 7
    ButtonText       = 8
    Base             = 9
    Window           = 10
    Shadow           = 11
    Highlight        = 12
    HighlightedText  = 13
    Link             = 14
    LinkVisited      = 15
    AlternateBase    = 16
    NoRole           = 17
    ToolTipBase      = 18
    ToolTipText      = 19
    PlaceholderText  = 20

  QPaletteColorGroup* {.size: sizeof(cint).} = enum
    Disabled  = 0
    Active    = 1
    Inactive  = 2
    Normal    = 1

  QImageFormatIO* {.size: sizeof(cint).} = enum
    ## Соответствует Qt::ImageConversionFlag
    ColorOnly         = 0x00
    MonoOnly          = 0x02
    DiffuseDither     = 0x00
    OrderedDither     = 0x10
    ThresholdDither   = 0x20
    ThresholdAlphaDither = 0x00
    OrderedAlphaDither   = 0x04
    DiffuseAlphaDither   = 0x08
    AutoColor         = 0x04

  QPageSizeId* {.size: sizeof(cint).} = enum
    A4        = 0
    A3        = 8
    A5        = 11
    Letter    = 2
    Legal     = 3
    Executive = 4
    B5        = 37
    A0        = 5
    A1        = 6
    A2        = 7
    A6        = 74
    A7        = 75

  QPageLayoutOrientation* {.size: sizeof(cint).} = enum
    Portrait  = 0
    Landscape = 1

  QPageLayoutMode* {.size: sizeof(cint).} = enum
    StandardMode = 0
    FullPageMode = 1

  QWindowState* {.size: sizeof(cint).} = enum
    WindowNoState    = 0x00000000
    WindowMinimized  = 0x00000001
    WindowMaximized  = 0x00000002
    WindowFullScreen = 0x00000004
    WindowActive     = 0x00000008

  QSurfaceFormatProfile* {.size: sizeof(cint).} = enum
    NoProfile            = 0
    CoreProfile          = 1
    CompatibilityProfile = 2

  QSurfaceFormatOption* {.size: sizeof(cint).} = enum
    StereoBuffers       = 0x0001
    DebugContext        = 0x0002
    DeprecatedFunctions = 0x0004
    ResetNotification   = 0x0008
    ProtectedContent    = 0x0010

# ── QGuiApplication ──────────────────────────────────────────────────────────

proc newGuiApp*(): GuiApp =
  {.emit: "_nim_gui_app = new QGuiApplication(_nim_gui_argc, _nim_gui_argv); `result` = _nim_gui_app;".}

proc guiAppInstance*(): GuiApp =
  {.emit: "`result` = static_cast<QGuiApplication*>(QGuiApplication::instance());".}

proc exec*(a: GuiApp): cint {.importcpp: "#->exec()".}
proc quit*(a: GuiApp)       {.importcpp: "#->quit()".}
proc setAppName*(a: GuiApp, s: QString)    {.importcpp: "#->setApplicationName(#)".}
proc setOrgName*(a: GuiApp, s: QString)    {.importcpp: "#->setOrganizationName(#)".}
proc setAppVersion*(a: GuiApp, s: QString) {.importcpp: "#->setApplicationVersion(#)".}
proc setAppDisplayName*(a: GuiApp, s: QString) {.importcpp: "#->setApplicationDisplayName(#)".}
proc setWindowIcon*(a: GuiApp, icon: QIcon) {.importcpp: "#->setWindowIcon(#)".}
proc setStyleSheet*(a: GuiApp, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setPalette*(a: GuiApp, pal: QPalette) {.importcpp: "#->setPalette(#)".}

proc guiClipboard*(): Clip =
  {.emit: "`result` = QGuiApplication::clipboard();".}

proc guiPrimaryScreen*(): Scr =
  {.emit: "`result` = QGuiApplication::primaryScreen();".}

proc guiScreens*(): seq[Scr] =
  var n: cint
  {.emit: "QList<QScreen*> _slist = QGuiApplication::screens(); `n` = _slist.size();".}
  result = newSeq[Scr](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint
    {.emit: "`result`[`idx`] = _slist.at(`idx`);".}

proc guiHighDpiScaleFactorPolicy*(policy: cint) =
  {.emit: "QGuiApplication::setHighDpiScaleFactorRoundingPolicy((Qt::HighDpiScaleFactorRoundingPolicy)`policy`);".}

proc guiProcessEvents*() =
  {.emit: "QGuiApplication::processEvents();".}

# ── QScreen ──────────────────────────────────────────────────────────────────

proc screenName*(s: Scr): string =
  var p: cstring
  {.emit: "static QByteArray _bsn; _bsn = `s`->name().toUtf8(); `p` = _bsn.constData();".}
  result = $p

proc screenGeometry*(s: Scr): NimRect =
  var x, y, w, h: cint
  {.emit: "QRect _sg = `s`->geometry(); `x`=_sg.x(); `y`=_sg.y(); `w`=_sg.width(); `h`=_sg.height();".}
  result = (x: x.int, y: y.int, w: w.int, h: h.int)

proc screenAvailableGeometry*(s: Scr): NimRect =
  var x, y, w, h: cint
  {.emit: "QRect _sag = `s`->availableGeometry(); `x`=_sag.x(); `y`=_sag.y(); `w`=_sag.width(); `h`=_sag.height();".}
  result = (x: x.int, y: y.int, w: w.int, h: h.int)

proc screenLogicalDpi*(s: Scr): tuple[x, y: float64] =
  var xd, yd: cdouble
  {.emit: "`xd` = `s`->logicalDotsPerInchX(); `yd` = `s`->logicalDotsPerInchY();".}
  result = (x: xd.float64, y: yd.float64)

proc screenPhysicalDpi*(s: Scr): tuple[x, y: float64] =
  var xd, yd: cdouble
  {.emit: "`xd` = `s`->physicalDotsPerInchX(); `yd` = `s`->physicalDotsPerInchY();".}
  result = (x: xd.float64, y: yd.float64)

proc screenDevicePixelRatio*(s: Scr): float64 =
  var v: cdouble
  {.emit: "`v` = `s`->devicePixelRatio();".}
  result = v.float64

proc screenRefreshRate*(s: Scr): float64 =
  var v: cdouble
  {.emit: "`v` = `s`->refreshRate();".}
  result = v.float64

proc screenDepth*(s: Scr): int =
  var v: cint
  {.emit: "`v` = `s`->depth();".}
  result = v.int

proc screenOrientation*(s: Scr): cint =
  var v: cint
  {.emit: "`v` = (int)`s`->orientation();".}
  result = v

# ── QColor ───────────────────────────────────────────────────────────────────

proc newColor*(r, g, b: int, a: int = 255): QColor =
  let ri=r.cint; let gi=g.cint; let bi=b.cint; let ai=a.cint
  {.emit: "`result` = QColor(`ri`, `gi`, `bi`, `ai`);".}

proc newColorF*(r, g, b: float64, a: float64 = 1.0): QColor =
  {.emit: "`result` = QColor::fromRgbF(`r`, `g`, `b`, `a`);".}

proc newColorHsv*(h, s, v: int, a: int = 255): QColor =
  let hi=h.cint; let si=s.cint; let vi=v.cint; let ai=a.cint
  {.emit: "`result` = QColor::fromHsv(`hi`, `si`, `vi`, `ai`);".}

proc newColorHsl*(h, s, l: int, a: int = 255): QColor =
  let hi=h.cint; let si=s.cint; let li=l.cint; let ai=a.cint
  {.emit: "`result` = QColor::fromHsl(`hi`, `si`, `li`, `ai`);".}

proc newColorCmyk*(c, m, y, k: int, a: int = 255): QColor =
  let ci=c.cint; let mi=m.cint; let yi=y.cint; let ki=k.cint; let ai=a.cint
  {.emit: "`result` = QColor::fromCmyk(`ci`, `mi`, `yi`, `ki`, `ai`);".}

proc newColorHex*(hex: string): QColor =
  let cs = hex.cstring
  {.emit: "`result` = QColor(QString::fromUtf8(`cs`));".}

proc colorR*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.red();".}
  result=v.int
proc colorG*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.green();".}
  result=v.int
proc colorB*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.blue();".}
  result=v.int
proc colorA*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.alpha();".}
  result=v.int

proc colorRF*(c: QColor): float64 =
  var v:cdouble
  {.emit:"`v`=`c`.redF();".}
  result=v.float64
proc colorGF*(c: QColor): float64 =
  var v:cdouble
  {.emit:"`v`=`c`.greenF();".}
  result=v.float64
proc colorBF*(c: QColor): float64 =
  var v:cdouble
  {.emit:"`v`=`c`.blueF();".}
  result=v.float64
proc colorAF*(c: QColor): float64 =
  var v:cdouble
  {.emit:"`v`=`c`.alphaF();".}
  result=v.float64

proc colorHsvH*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.hsvHue();".}
  result=v.int
proc colorHsvS*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.hsvSaturation();".}
  result=v.int
proc colorHsvV*(c: QColor): int =
  var v:cint
  {.emit:"`v`=`c`.value();".}
  result=v.int

proc colorLighter*(c: QColor, factor: int = 150): QColor =
  let fi=factor.cint
  {.emit:"`result`=`c`.lighter(`fi`);".}

proc colorDarker*(c: QColor, factor: int = 200): QColor =
  let fi=factor.cint
  {.emit:"`result`=`c`.darker(`fi`);".}

proc colorToHexStr*(c: QColor): string =
  var p: cstring
  {.emit:"static QByteArray _bch; _bch=`c`.name().toUtf8(); `p`=_bch.constData();".}
  result = $p

proc colorToHexArgbStr*(c: QColor): string =
  var p: cstring
  {.emit:"static QByteArray _bca; _bca=`c`.name(QColor::HexArgb).toUtf8(); `p`=_bca.constData();".}
  result = $p

proc colorIsValid*(c: QColor): bool =
  var r:cint
  {.emit:"`r`=`c`.isValid()?1:0;".}
  result=r==1

proc colorToRgba*(c: QColor): NimColor =
  result = (r: colorR(c).uint8, g: colorG(c).uint8,
            b: colorB(c).uint8, a: colorA(c).uint8)

proc colorFromRgba*(nc: NimColor): QColor =
  newColor(nc.r.int, nc.g.int, nc.b.int, nc.a.int)

proc colorSetAlpha*(c: QColor, a: int): QColor =
  let ai=a.cint
  {.emit:"`result`=`c`; `result`.setAlpha(`ai`);".}

proc colorInterpolate*(c1, c2: QColor, t: float64): QColor =
  ## Линейная интерполяция между двумя цветами
  let r = (colorR(c1).float64 * (1.0 - t) + colorR(c2).float64 * t).int
  let g = (colorG(c1).float64 * (1.0 - t) + colorG(c2).float64 * t).int
  let b = (colorB(c1).float64 * (1.0 - t) + colorB(c2).float64 * t).int
  let a = (colorA(c1).float64 * (1.0 - t) + colorA(c2).float64 * t).int
  newColor(r, g, b, a)

# ── QFont ─────────────────────────────────────────────────────────────────────

proc newFont*(): QFont =
  {.emit: "`result` = QFont();".}

proc newFont*(family: string, pointSize: int = -1, weight: int = -1, italic: bool = false): QFont =
  let cs = family.cstring
  let ps = pointSize.cint
  let wt = weight.cint
  let it = italic.cint
  {.emit: "`result` = QFont(QString::fromUtf8(`cs`), `ps`, `wt`, (bool)`it`);".}

proc fontFamily*(f: QFont): string =
  var p: cstring
  {.emit:"static QByteArray _bff; _bff=`f`.family().toUtf8(); `p`=_bff.constData();".}
  result = $p

proc fontFamilies*(f: QFont): seq[string] =
  var n: cint
  {.emit:"QStringList _ffl=`f`.families(); `n`=_ffl.size();".}
  result = newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p: cstring
    {.emit:"static QByteArray _bffi; _bffi=_ffl.at(`idx`).toUtf8(); `p`=_bffi.constData();".}
    result[i] = $p

proc setFontFamily*(f: ptr QFont, family: string) =
  let cs=family.cstring
  {.emit:"`f`->setFamily(QString::fromUtf8(`cs`));".}

proc setFontFamilies*(f: ptr QFont, families: openArray[string]) =
  var joined = ""
  for i, s in families:
    if i > 0: joined.add('\0')
    joined.add(s)
  let data = joined.cstring; let n = families.len.cint
  {.emit:"""
    QStringList _sl;
    const char* _p = `data`;
    for(int i=0;i<`n`;i++){_sl<<QString::fromUtf8(_p);_p+=strlen(_p)+1;}
    `f`->setFamilies(_sl);
  """.}

proc fontPointSize*(f: QFont): int =
  var v:cint
  {.emit:"`v`=`f`.pointSize();".}
  result=v.int
proc fontPixelSize*(f: QFont): int =
  var v:cint
  {.emit:"`v`=`f`.pixelSize();".}
  result=v.int
proc fontWeight*(f: QFont): int =
  var v:cint
  {.emit:"`v`=`f`.weight();".}
  result=v.int
proc fontBold*(f: QFont): bool =
  var v:cint
  {.emit:"`v`=`f`.bold()?1:0;".}
  result=v==1
proc fontItalic*(f: QFont): bool =
  var v:cint
  {.emit:"`v`=`f`.italic()?1:0;".}
  result=v==1
proc fontUnderline*(f: QFont): bool =
  var v:cint
  {.emit:"`v`=`f`.underline()?1:0;".}
  result=v==1
proc fontStrikeOut*(f: QFont): bool =
  var v:cint
  {.emit:"`v`=`f`.strikeOut()?1:0;".}
  result=v==1
proc fontKerning*(f: QFont): bool =
  var v:cint
  {.emit:"`v`=`f`.kerning()?1:0;".}
  result=v==1
proc fontFixedPitch*(f: QFont): bool =
  var v:cint
  {.emit:"`v`=`f`.fixedPitch()?1:0;".}
  result=v==1
proc fontLetterSpacing*(f: QFont): float64 =
  var v:cdouble
  {.emit:"`v`=`f`.letterSpacing();".}
  result=v.float64
proc fontWordSpacing*(f: QFont): float64 =
  var v:cdouble
  {.emit:"`v`=`f`.wordSpacing();".}
  result=v.float64

proc setFontPointSize*(f: ptr QFont, ps: int) =
  let v=ps.cint
  {.emit:"`f`->setPointSize(`v`);".}
proc setFontPixelSize*(f: ptr QFont, px: int) =
  let v=px.cint
  {.emit:"`f`->setPixelSize(`v`);".}
proc setFontPointSizeF*(f: ptr QFont, ps: float64) =
  {.emit:"`f`->setPointSizeF(`ps`);".}
proc setFontBold*(f: ptr QFont, b: bool) =
  let bv=b.cint
  {.emit:"`f`->setBold((bool)`bv`);".}
proc setFontItalic*(f: ptr QFont, b: bool) =
  let bv=b.cint
  {.emit:"`f`->setItalic((bool)`bv`);".}
proc setFontUnderline*(f: ptr QFont, b: bool) =
  let bv=b.cint
  {.emit:"`f`->setUnderline((bool)`bv`);".}
proc setFontStrikeOut*(f: ptr QFont, b: bool) =
  let bv=b.cint
  {.emit:"`f`->setStrikeOut((bool)`bv`);".}
proc setFontWeight*(f: ptr QFont, w: cint) {.importcpp: "#->setWeight(#)".}
proc setFontLetterSpacing*(f: ptr QFont, stype: cint, spacing: float64) =
  {.emit:"`f`->setLetterSpacing((QFont::SpacingType)`stype`, `spacing`);".}
proc setFontWordSpacing*(f: ptr QFont, spacing: float64) =
  {.emit:"`f`->setWordSpacing(`spacing`);".}
proc setFontStyleHint*(f: ptr QFont, hint: QFontStyleHint) =
  let h=hint.cint
  {.emit:"`f`->setStyleHint((QFont::StyleHint)`h`);".}
proc setFontStyleStrategy*(f: ptr QFont, strat: QFontStyleStrategy) =
  let s=strat.cint
  {.emit:"`f`->setStyleStrategy((QFont::StyleStrategy)`s`);".}
proc setFontKerning*(f: ptr QFont, b: bool) =
  let bv=b.cint
  {.emit:"`f`->setKerning((bool)`bv`);".}
proc setFontFixedPitch*(f: ptr QFont, b: bool) =
  let bv=b.cint
  {.emit:"`f`->setFixedPitch((bool)`bv`);".}

proc fontToString*(f: QFont): string =
  var p: cstring
  {.emit:"static QByteArray _bfts; _bfts=`f`.toString().toUtf8(); `p`=_bfts.constData();".}
  result = $p

proc fontFromString*(s: string): QFont =
  let cs=s.cstring
  {.emit:"`result`=QFont(); `result`.fromString(QString::fromUtf8(`cs`));".}

# ── QFontMetrics / QFontMetricsF ─────────────────────────────────────────────

proc newFontMetrics*(f: QFont): QFontMetrics =
  {.emit:"`result` = QFontMetrics(`f`);".}

proc fmHeight*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.height();".}
  result=v.int
proc fmAscent*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.ascent();".}
  result=v.int
proc fmDescent*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.descent();".}
  result=v.int
proc fmLeading*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.leading();".}
  result=v.int
proc fmLineSpacing*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.lineSpacing();".}
  result=v.int
proc fmAverageCharWidth*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.averageCharWidth();".}
  result=v.int
proc fmMaxWidth*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.maxWidth();".}
  result=v.int
proc fmXHeight*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.xHeight();".}
  result=v.int
proc fmCapHeight*(fm: QFontMetrics): int =
  var v:cint
  {.emit:"`v`=`fm`.capHeight();".}
  result=v.int

proc fmHorizontalAdvance*(fm: QFontMetrics, text: string): int =
  let cs=text.cstring; var v:cint
  {.emit:"`v`=`fm`.horizontalAdvance(QString::fromUtf8(`cs`));".}
  result=v.int

proc fmBoundingRect*(fm: QFontMetrics, text: string): NimRect =
  let cs=text.cstring; var x,y,w,h: cint
  {.emit:"QRect _r=`fm`.boundingRect(QString::fromUtf8(`cs`)); `x`=_r.x();`y`=_r.y();`w`=_r.width();`h`=_r.height();".}
  result=(x:x.int,y:y.int,w:w.int,h:h.int)

proc fmElidedText*(fm: QFontMetrics, text: string, mode: cint, width: int): string =
  let cs=text.cstring; let wi=width.cint; var p:cstring
  {.emit:"static QByteArray _bfme; _bfme=`fm`.elidedText(QString::fromUtf8(`cs`),(Qt::TextElideMode)`mode`,`wi`).toUtf8(); `p`=_bfme.constData();".}
  result = $p

proc newFontMetricsF*(f: QFont): QFontMetricsF =
  {.emit:"`result` = QFontMetricsF(`f`);".}

proc fmfHorizontalAdvance*(fm: QFontMetricsF, text: string): float64 =
  let cs=text.cstring; var v:cdouble
  {.emit:"`v`=`fm`.horizontalAdvance(QString::fromUtf8(`cs`));".}
  result=v.float64

proc fmfHeight*(fm: QFontMetricsF): float64 =
  var v:cdouble
  {.emit:"`v`=`fm`.height();".}
  result=v.float64

# ── QFontDatabase ─────────────────────────────────────────────────────────────

proc fontFamiliesList*(): seq[string] =
  var n: cint
  {.emit:"QStringList _fdl=QFontDatabase::families(); `n`=_fdl.size();".}
  result = newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p:cstring
    {.emit:"static QByteArray _bfd; _bfd=_fdl.at(`idx`).toUtf8(); `p`=_bfd.constData();".}
    result[i]=$p

proc fontStyles*(family: string): seq[string] =
  let cs=family.cstring; var n:cint
  {.emit:"QStringList _fsl=QFontDatabase::styles(QString::fromUtf8(`cs`)); `n`=_fsl.size();".}
  result = newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p:cstring
    {.emit:"static QByteArray _bfst; _bfst=_fsl.at(`idx`).toUtf8(); `p`=_bfst.constData();".}
    result[i]=$p

proc fontPointSizes*(family, style: string): seq[int] =
  let cf=family.cstring; let cs=style.cstring; var n:cint
  {.emit:"QList<int> _fps=QFontDatabase::pointSizes(QString::fromUtf8(`cf`),QString::fromUtf8(`cs`)); `n`=_fps.size();".}
  result = newSeq[int](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var v:cint
    {.emit:"`v`=_fps.at(`idx`);".}
    result[i]=v.int

proc fontAddFile*(path: string): int =
  let cs=path.cstring; var v:cint
  {.emit:"`v`=QFontDatabase::addApplicationFont(QString::fromUtf8(`cs`));".}
  result=v.int

proc fontAddFromData*(data: string): int =
  let cs=data.cstring; let n=data.len.cint; var v:cint
  {.emit:"`v`=QFontDatabase::addApplicationFontFromData(QByteArray(`cs`,`n`));".}
  result=v.int

proc fontRemove*(id: int) =
  let vi=id.cint
  {.emit:"QFontDatabase::removeApplicationFont(`vi`);".}

proc fontIsSmoothlyScalable*(family, style: string): bool =
  let cf=family.cstring; let cs=style.cstring; var r:cint
  {.emit:"`r`=QFontDatabase::isSmoothlyScalable(QString::fromUtf8(`cf`),QString::fromUtf8(`cs`))?1:0;".}
  result=r==1

proc fontIsFixedPitch*(family, style: string): bool =
  let cf=family.cstring; let cs=style.cstring; var r:cint
  {.emit:"`r`=QFontDatabase::isFixedPitch(QString::fromUtf8(`cf`),QString::fromUtf8(`cs`))?1:0;".}
  result=r==1

proc fontSystemDefault*(): QFont =
  {.emit:"`result`=QFontDatabase::systemFont(QFontDatabase::GeneralFont);".}

proc fontSystemFixed*(): QFont =
  {.emit:"`result`=QFontDatabase::systemFont(QFontDatabase::FixedFont);".}

# ── QPixmap ───────────────────────────────────────────────────────────────────

proc newPixmap*(w, h: int): Pxm =
  let wi=w.cint; let hi=h.cint
  {.emit:"`result` = new QPixmap(`wi`, `hi`);".}

proc loadPixmap*(path: string): Pxm =
  let cs=path.cstring
  {.emit:"`result` = new QPixmap(QString::fromUtf8(`cs`));".}

proc pixmapWidth*(p: Pxm): int =
  var v:cint
  {.emit:"`v`=`p`->width();".}
  result=v.int
proc pixmapHeight*(p: Pxm): int =
  var v:cint
  {.emit:"`v`=`p`->height();".}
  result=v.int
proc pixmapIsNull*(p: Pxm): bool =
  var v:cint
  {.emit:"`v`=`p`->isNull()?1:0;".}
  result=v==1
proc pixmapDepth*(p: Pxm): int =
  var v:cint
  {.emit:"`v`=`p`->depth();".}
  result=v.int

proc pixmapScaled*(p: Pxm, w, h: int, aspectMode: cint = 1, transformMode: cint = 0): Pxm =
  let wi=w.cint; let hi=h.cint
  {.emit:"`result` = new QPixmap(`p`->scaled(`wi`, `hi`, (Qt::AspectRatioMode)`aspectMode`, (Qt::TransformationMode)`transformMode`));".}

proc pixmapScaledToWidth*(p: Pxm, w: int, transformMode: cint = 0): Pxm =
  let wi=w.cint
  {.emit:"`result` = new QPixmap(`p`->scaledToWidth(`wi`, (Qt::TransformationMode)`transformMode`));".}

proc pixmapScaledToHeight*(p: Pxm, h: int, transformMode: cint = 0): Pxm =
  let hi=h.cint
  {.emit:"`result` = new QPixmap(`p`->scaledToHeight(`hi`, (Qt::TransformationMode)`transformMode`));".}

proc pixmapSave*(p: Pxm, path: string, format: string = "", quality: int = -1): bool =
  let cp=path.cstring; let cf=format.cstring; let qi=quality.cint; var r:cint
  {.emit:"`r`=`p`->save(QString::fromUtf8(`cp`), `cf`[0]?`cf`:nullptr, `qi`)?1:0;".}
  result=r==1

proc pixmapFill*(p: Pxm, c: QColor) {.importcpp: "#->fill(#)".}

proc pixmapFillTransparent*(p: Pxm) =
  {.emit:"`p`->fill(Qt::transparent);".}

proc pixmapCopy*(p: Pxm, x, y, w, h: int): Pxm =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`result` = new QPixmap(`p`->copy(`xi`,`yi`,`wi`,`hi`));".}

proc pixmapToImage*(p: Pxm): QImage =
  {.emit:"`result` = `p`->toImage();".}

proc pixmapFromImage*(img: QImage): Pxm =
  {.emit:"`result` = new QPixmap(QPixmap::fromImage(`img`));".}

proc pixmapDevicePixelRatio*(p: Pxm): float64 =
  var v:cdouble
  {.emit:"`v`=`p`->devicePixelRatio();".}
  result=v.float64

proc setPixmapDevicePixelRatio*(p: Pxm, ratio: float64) =
  {.emit:"`p`->setDevicePixelRatio(`ratio`);".}

proc pixmapTransformed*(p: Pxm, t: QTransform, mode: cint = 0): Pxm =
  {.emit:"`result` = new QPixmap(`p`->transformed(`t`, (Qt::TransformationMode)`mode`));".}

# ── QImage ────────────────────────────────────────────────────────────────────

proc newImage*(w, h: int, fmt: QtImageFormat = Format_ARGB32): QImage =
  let wi=w.cint; let hi=h.cint; let fi=fmt.cint
  {.emit:"`result` = QImage(`wi`, `hi`, (QImage::Format)`fi`);".}

proc loadImage*(path: string): QImage =
  let cs=path.cstring
  {.emit:"`result` = QImage(QString::fromUtf8(`cs`));".}

proc imageWidth*(img: QImage): int =
  var v:cint
  {.emit:"`v`=`img`.width();".}
  result=v.int
proc imageHeight*(img: QImage): int =
  var v:cint
  {.emit:"`v`=`img`.height();".}
  result=v.int
proc imageDepth*(img: QImage): int =
  var v:cint
  {.emit:"`v`=`img`.depth();".}
  result=v.int
proc imageIsNull*(img: QImage): bool =
  var v:cint
  {.emit:"`v`=`img`.isNull()?1:0;".}
  result=v==1
proc imageBytesPerLine*(img: QImage): int =
  var v:cint
  {.emit:"`v`=`img`.bytesPerLine();".}
  result=v.int
proc imageSizeInBytes*(img: QImage): int64 =
  var v:clonglong
  {.emit:"`v`=`img`.sizeInBytes();".}
  result=v.int64

proc imagePixel*(img: QImage, x, y: int): uint32 =
  let xi=x.cint; let yi=y.cint; var v:cuint
  {.emit:"`v`=`img`.pixel(`xi`,`yi`);".}
  result=v.uint32

proc imageSetPixel*(img: var QImage, x, y: int, color: uint32) =
  let xi=x.cint; let yi=y.cint; let cv=color.cuint
  {.emit:"`img`.setPixel(`xi`,`yi`,`cv`);".}

proc imagePixelColor*(img: QImage, x, y: int): QColor =
  let xi=x.cint; let yi=y.cint
  {.emit:"`result` = `img`.pixelColor(`xi`,`yi`);".}

proc imageSetPixelColor*(img: var QImage, x, y: int, c: QColor) =
  let xi=x.cint; let yi=y.cint
  {.emit:"`img`.setPixelColor(`xi`,`yi`,`c`);".}

proc imageFill*(img: var QImage, c: QColor) =
  {.emit:"`img`.fill(`c`);".}

proc imageFillValue*(img: var QImage, v: uint32) =
  let cv=v.cuint
  {.emit:"`img`.fill(`cv`);".}

proc imageSave*(img: QImage, path: string, format: string = "", quality: int = -1): bool =
  let cp=path.cstring; let cf=format.cstring; let qi=quality.cint; var r:cint
  {.emit:"`r`=`img`.save(QString::fromUtf8(`cp`), `cf`[0]?`cf`:nullptr, `qi`)?1:0;".}
  result=r==1

proc imageScaled*(img: QImage, w, h: int, aspectMode: cint = 1, transformMode: cint = 0): QImage =
  let wi=w.cint; let hi=h.cint
  {.emit:"`result`=`img`.scaled(`wi`,`hi`,(Qt::AspectRatioMode)`aspectMode`,(Qt::TransformationMode)`transformMode`);".}

proc imageConvertTo*(img: QImage, fmt: QtImageFormat): QImage =
  let fi=fmt.cint
  {.emit:"`result`=`img`.convertToFormat((QImage::Format)`fi`);".}

proc imageMirrored*(img: QImage, horizontal: bool = false, vertical: bool = true): QImage =
  let hb=horizontal.cint; let vb=vertical.cint
  {.emit:"`result`=`img`.mirrored((bool)`hb`,(bool)`vb`);".}

proc imageDevicePixelRatio*(img: QImage): float64 =
  var v:cdouble
  {.emit:"`v`=`img`.devicePixelRatio();".}
  result=v.float64

proc setImageDevicePixelRatio*(img: var QImage, ratio: float64) =
  {.emit:"`img`.setDevicePixelRatio(`ratio`);".}

proc imageToPixmap*(img: QImage): Pxm =
  {.emit:"`result` = new QPixmap(QPixmap::fromImage(`img`));".}

proc imageFormat*(img: QImage): cint =
  var v:cint
  {.emit:"`v`=(int)`img`.format();".}
  result=v

proc imageColorCount*(img: QImage): int =
  var v:cint
  {.emit:"`v`=`img`.colorCount();".}
  result=v.int

proc imageBits*(img: QImage): pointer =
  var p: pointer
  {.emit:"`p` = (void*)`img`.bits();".}
  result = p

# ── QImageReader / QImageWriter ───────────────────────────────────────────────

proc newImageReader*(path: string): ptr QImageReader =
  let cs=path.cstring
  {.emit:"`result` = new QImageReader(QString::fromUtf8(`cs`));".}

proc imageReaderRead*(r: ptr QImageReader): QImage =
  {.emit:"`result` = `r`->read();".}

proc imageReaderCanRead*(r: ptr QImageReader): bool =
  var v:cint
  {.emit:"`v`=`r`->canRead()?1:0;".}
  result=v==1

proc imageReaderFormat*(r: ptr QImageReader): string =
  var p:cstring
  {.emit:"static QByteArray _birf; _birf=`r`->format(); `p`=_birf.constData();".}
  result = $p

proc imageReaderSize*(r: ptr QImageReader): NimSize =
  var w,h:cint
  {.emit:"QSize _s=`r`->size(); `w`=_s.width(); `h`=_s.height();".}
  result=(w:w.int, h:h.int)

proc imageReaderErrorString*(r: ptr QImageReader): string =
  var p:cstring
  {.emit:"static QByteArray _bire; _bire=`r`->errorString().toUtf8(); `p`=_bire.constData();".}
  result = $p

proc newImageWriter*(path: string): ptr QImageWriter =
  let cs=path.cstring
  {.emit:"`result` = new QImageWriter(QString::fromUtf8(`cs`));".}

proc imageWriterWrite*(w: ptr QImageWriter, img: QImage): bool =
  var r:cint
  {.emit:"`r`=`w`->write(`img`)?1:0;".}
  result=r==1

proc imageWriterSetQuality*(w: ptr QImageWriter, q: int) =
  let qi=q.cint
  {.emit:"`w`->setQuality(`qi`);".}

proc imageWriterSetFormat*(w: ptr QImageWriter, fmt: string) =
  let cs=fmt.cstring
  {.emit:"`w`->setFormat(QByteArray(`cs`));".}

proc imageWriterErrorString*(w: ptr QImageWriter): string =
  var p:cstring
  {.emit:"static QByteArray _biwe; _biwe=`w`->errorString().toUtf8(); `p`=_biwe.constData();".}
  result = $p

proc imageFormatsForReading*(): seq[string] =
  var n:cint
  {.emit:"QList<QByteArray> _ifr=QImageReader::supportedImageFormats(); `n`=_ifr.size();".}
  result=newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p:cstring
    {.emit:"static QByteArray _bifrv; _bifrv=_ifr.at(`idx`); `p`=_bifrv.constData();".}
    result[i]=$p

proc imageFormatsForWriting*(): seq[string] =
  var n:cint
  {.emit:"QList<QByteArray> _ifw=QImageWriter::supportedImageFormats(); `n`=_ifw.size();".}
  result=newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p:cstring
    {.emit:"static QByteArray _bifwv; _bifwv=_ifw.at(`idx`); `p`=_bifwv.constData();".}
    result[i]=$p

# ── QIcon ─────────────────────────────────────────────────────────────────────

proc newIcon*(): QIcon =
  {.emit:"`result` = QIcon();".}

proc loadIcon*(path: string): QIcon =
  let cs=path.cstring
  {.emit:"`result` = QIcon(QString::fromUtf8(`cs`));".}

proc iconFromPixmap*(p: Pxm): QIcon =
  {.emit:"`result` = QIcon(*`p`);".}

proc iconFromTheme*(name: string): QIcon =
  let cs=name.cstring
  {.emit:"`result` = QIcon::fromTheme(QString::fromUtf8(`cs`));".}

proc iconHasThemeIcon*(name: string): bool =
  let cs=name.cstring; var r:cint
  {.emit:"`r`=QIcon::hasThemeIcon(QString::fromUtf8(`cs`))?1:0;".}
  result=r==1

proc iconIsNull*(ico: QIcon): bool =
  var v:cint
  {.emit:"`v`=`ico`.isNull()?1:0;".}
  result=v==1

proc iconAddFile*(ico: ptr QIcon, path: string, w: int = 0, h: int = 0) =
  let cs=path.cstring; let wi=w.cint; let hi=h.cint
  {.emit:"`ico`->addFile(QString::fromUtf8(`cs`), QSize(`wi`,`hi`));".}

proc iconAddPixmap*(ico: ptr QIcon, p: Pxm) =
  {.emit:"`ico`->addPixmap(*`p`);".}

proc iconPixmap*(ico: QIcon, w, h: int): Pxm =
  let wi=w.cint; let hi=h.cint
  {.emit:"`result` = new QPixmap(`ico`.pixmap(QSize(`wi`,`hi`)));".}

proc iconSetThemeName*(name: string) =
  let cs=name.cstring
  {.emit:"QIcon::setThemeName(QString::fromUtf8(`cs`));".}

proc iconThemeName*(): string =
  var p:cstring
  {.emit:"static QByteArray _bitn; _bitn=QIcon::themeName().toUtf8(); `p`=_bitn.constData();".}
  result = $p

# ── QCursor ───────────────────────────────────────────────────────────────────

proc newCursor*(shape: QtCursorShape = ArrowCursor): QCursor =
  let si=shape.cint
  {.emit:"`result` = QCursor((Qt::CursorShape)`si`);".}

proc newCursorFromPixmap*(p: Pxm, hotX: int = -1, hotY: int = -1): QCursor =
  let hx=hotX.cint; let hy=hotY.cint
  {.emit:"`result` = QCursor(*`p`, `hx`, `hy`);".}

proc cursorShape*(c: QCursor): cint =
  var v:cint
  {.emit:"`v`=(int)`c`.shape();".}
  result=v

proc cursorPos*(): NimPoint =
  var x,y:cint
  {.emit:"QPoint _cp=QCursor::pos(); `x`=_cp.x(); `y`=_cp.y();".}
  result=(x:x.int, y:y.int)

proc setCursorPos*(x, y: int) =
  let xi=x.cint; let yi=y.cint
  {.emit:"QCursor::setPos(`xi`, `yi`);".}

# ── QPen ──────────────────────────────────────────────────────────────────────

proc newPen*(): QPen =
  {.emit:"`result` = QPen();".}

proc newPen*(c: QColor, width: float64 = 1.0, style: QtPenStyle = SolidLine): QPen =
  let si=style.cint
  {.emit:"`result` = QPen(`c`, `width`, (Qt::PenStyle)`si`);".}

proc newPenStyle*(style: QtPenStyle): QPen =
  let si=style.cint
  {.emit:"`result` = QPen((Qt::PenStyle)`si`);".}

proc setPenColor*(p: var QPen, c: QColor) {.importcpp: "#.setColor(#)".}
proc setPenWidth*(p: var QPen, w: float64) {.importcpp: "#.setWidthF(#)".}
proc setPenStyle*(p: var QPen, s: QtPenStyle) =
  let si=s.cint
  {.emit:"`p`.setStyle((Qt::PenStyle)`si`);".}
proc setPenCapStyle*(p: var QPen, s: QtPenCapStyle) =
  let si=s.cint
  {.emit:"`p`.setCapStyle((Qt::PenCapStyle)`si`);".}
proc setPenJoinStyle*(p: var QPen, s: QtPenJoinStyle) =
  let si=s.cint
  {.emit:"`p`.setJoinStyle((Qt::PenJoinStyle)`si`);".}
proc setPenMiterLimit*(p: var QPen, limit: float64) {.importcpp: "#.setMiterLimit(#)".}
proc setPenCosmetic*(p: var QPen, cosmetic: bool) =
  let bv=cosmetic.cint
  {.emit:"`p`.setCosmetic((bool)`bv`);".}
proc setPenDashPattern*(p: var QPen, pattern: openArray[float64]) =
  var n=pattern.len.cint
  {.emit:"QList<qreal> _dp;".}
  for v in pattern:
    {.emit:"_dp.append(`v`);".}
  {.emit:"`p`.setDashPattern(_dp);".}
proc setPenDashOffset*(p: var QPen, offset: float64) {.importcpp: "#.setDashOffset(#)".}

proc penColor*(p: QPen): QColor {.importcpp: "#.color()".}
proc penWidthF*(p: QPen): float64 {.importcpp: "#.widthF()".}
proc penWidth*(p: QPen): int =
  var v:cint
  {.emit:"`v`=`p`.width();".}
  result=v.int
proc penIsCosmetic*(p: QPen): bool =
  var v:cint
  {.emit:"`v`=`p`.isCosmetic()?1:0;".}
  result=v==1

# ── QBrush ────────────────────────────────────────────────────────────────────

proc newBrush*(): QBrush =
  {.emit:"`result` = QBrush();".}

proc newBrush*(c: QColor, style: QtBrushStyle = SolidPattern): QBrush =
  let si=style.cint
  {.emit:"`result` = QBrush(`c`, (Qt::BrushStyle)`si`);".}

proc newBrushFromPixmap*(p: Pxm): QBrush =
  {.emit:"`result` = QBrush(*`p`);".}

proc newBrushFromLinearGradient*(g: QLinearGradient): QBrush =
  {.emit:"`result` = QBrush(`g`);".}

proc newBrushFromRadialGradient*(g: QRadialGradient): QBrush =
  {.emit:"`result` = QBrush(`g`);".}

proc newBrushFromConicalGradient*(g: QConicalGradient): QBrush =
  {.emit:"`result` = QBrush(`g`);".}

proc setBrushColor*(b: var QBrush, c: QColor) {.importcpp: "#.setColor(#)".}
proc setBrushStyle*(b: var QBrush, s: QtBrushStyle) =
  let si=s.cint
  {.emit:"`b`.setStyle((Qt::BrushStyle)`si`);".}
proc setBrushTexture*(b: var QBrush, p: Pxm) =
  {.emit:"`b`.setTexture(*`p`);".}

proc brushColor*(b: QBrush): QColor {.importcpp: "#.color()".}
proc brushIsOpaque*(b: QBrush): bool =
  var v:cint
  {.emit:"`v`=`b`.isOpaque()?1:0;".}
  result=v==1

# ── QLinearGradient / QRadialGradient / QConicalGradient ──────────────────────

proc newLinearGradient*(x1, y1, x2, y2: float64): QLinearGradient =
  {.emit:"`result` = QLinearGradient(`x1`,`y1`,`x2`,`y2`);".}

proc linearGradientAddStop*(g: var QLinearGradient, pos: float64, c: QColor) =
  {.emit:"`g`.setColorAt(`pos`, `c`);".}

proc linearGradientSetSpread*(g: var QLinearGradient, spread: cint) =
  {.emit:"`g`.setSpread((QGradient::Spread)`spread`);".}

proc newRadialGradient*(cx, cy, radius: float64): QRadialGradient =
  {.emit:"`result` = QRadialGradient(`cx`,`cy`,`radius`);".}

proc radialGradientAddStop*(g: var QRadialGradient, pos: float64, c: QColor) =
  {.emit:"`g`.setColorAt(`pos`, `c`);".}

proc newConicalGradient*(cx, cy, angle: float64): QConicalGradient =
  {.emit:"`result` = QConicalGradient(`cx`,`cy`,`angle`);".}

proc conicalGradientAddStop*(g: var QConicalGradient, pos: float64, c: QColor) =
  {.emit:"`g`.setColorAt(`pos`, `c`);".}

# ── QTransform ────────────────────────────────────────────────────────────────

proc newTransform*(): QTransform =
  {.emit:"`result` = QTransform();".}

proc transformTranslate*(t: var QTransform, dx, dy: float64) =
  {.emit:"`t`.translate(`dx`,`dy`);".}

proc transformScale*(t: var QTransform, sx, sy: float64) =
  {.emit:"`t`.scale(`sx`,`sy`);".}

proc transformRotate*(t: var QTransform, angle: float64) =
  {.emit:"`t`.rotate(`angle`);".}

proc transformShear*(t: var QTransform, sh, sv: float64) =
  {.emit:"`t`.shear(`sh`,`sv`);".}

proc transformReset*(t: var QTransform) =
  {.emit:"`t`.reset();".}

proc transformInverted*(t: QTransform): tuple[ok: bool, inv: QTransform] =
  var ok:cint
  {.emit:"bool _tok; `result`.Field1 = `t`.inverted(&_tok); `ok` = _tok?1:0;".}
  result.ok=ok==1

proc transformIsIdentity*(t: QTransform): bool =
  var v:cint
  {.emit:"`v`=`t`.isIdentity()?1:0;".}
  result=v==1

proc transformMapPoint*(t: QTransform, x, y: float64): NimPointF =
  var rx,ry: cdouble
  {.emit:"QPointF _tp=`t`.map(QPointF(`x`,`y`)); `rx`=_tp.x(); `ry`=_tp.y();".}
  result=(x:rx.float64, y:ry.float64)

proc transformMapRect*(t: QTransform, r: NimRect): NimRectF =
  let xi=r.x.cdouble; let yi=r.y.cdouble; let wi=r.w.cdouble; let hi=r.h.cdouble
  var rx,ry,rw,rh: cdouble
  {.emit:"QRectF _tr=`t`.mapRect(QRectF(`xi`,`yi`,`wi`,`hi`)); `rx`=_tr.x();`ry`=_tr.y();`rw`=_tr.width();`rh`=_tr.height();".}
  result=(x:rx.float64, y:ry.float64, w:rw.float64, h:rh.float64)

proc transformMultiply*(a, b: QTransform): QTransform =
  {.emit:"`result` = `a` * `b`;".}

# ── QMatrix4x4 ────────────────────────────────────────────────────────────────

proc newMatrix4x4*(): QMatrix4x4 =
  {.emit:"`result` = QMatrix4x4();".}

proc m4Translate*(m: var QMatrix4x4, x, y, z: float64) =
  {.emit:"`m`.translate(`x`,`y`,`z`);".}

proc m4Scale*(m: var QMatrix4x4, x, y, z: float64) =
  {.emit:"`m`.scale(`x`,`y`,`z`);".}

proc m4Rotate*(m: var QMatrix4x4, angle: float64, x, y, z: float64) =
  {.emit:"`m`.rotate(`angle`,`x`,`y`,`z`);".}

proc m4LookAt*(m: var QMatrix4x4, eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ: float64) =
  {.emit:"`m`.lookAt(QVector3D(`eyeX`,`eyeY`,`eyeZ`),QVector3D(`centerX`,`centerY`,`centerZ`),QVector3D(`upX`,`upY`,`upZ`));".}

proc m4Perspective*(m: var QMatrix4x4, fov, aspect, near, far: float64) =
  {.emit:"`m`.perspective(`fov`,`aspect`,`near`,`far`);".}

proc m4Ortho*(m: var QMatrix4x4, left, right, bottom, top, near, far: float64) =
  {.emit:"`m`.ortho(`left`,`right`,`bottom`,`top`,`near`,`far`);".}

proc m4SetToIdentity*(m: var QMatrix4x4) {.importcpp: "#.setToIdentity()".}
proc m4IsIdentity*(m: QMatrix4x4): bool =
  var v:cint
  {.emit:"`v`=`m`.isIdentity()?1:0;".}
  result=v==1
proc m4Inverted*(m: QMatrix4x4): tuple[ok: bool, inv: QMatrix4x4] =
  var ok:cint
  {.emit:"bool _mi; `result`.Field1 = `m`.inverted(&_mi); `ok` = _mi?1:0;".}
  result.ok=ok==1
proc m4Transposed*(m: QMatrix4x4): QMatrix4x4 =
  {.emit:"`result` = `m`.transposed();".}
proc m4Multiply*(a, b: QMatrix4x4): QMatrix4x4 =
  {.emit:"`result` = `a` * `b`;".}
proc m4MapVector*(m: QMatrix4x4, x, y, z: float64): tuple[x,y,z: float64] =
  var rx,ry,rz: cdouble
  {.emit:"QVector3D _mv=`m`.map(QVector3D(`x`,`y`,`z`)); `rx`=_mv.x();`ry`=_mv.y();`rz`=_mv.z();".}
  result=(x:rx.float64, y:ry.float64, z:rz.float64)

# ── QVector2D / QVector3D / QVector4D ────────────────────────────────────────

proc newVec2*(x, y: float64): QVector2D =
  {.emit:"`result` = QVector2D(`x`,`y`);".}
proc vec2X*(v: QVector2D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.x();".}
  result=r.float64
proc vec2Y*(v: QVector2D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.y();".}
  result=r.float64
proc vec2Length*(v: QVector2D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.length();".}
  result=r.float64
proc vec2Normalized*(v: QVector2D): QVector2D =
  {.emit:"`result`=`v`.normalized();".}
proc vec2Dot*(a, b: QVector2D): float64 =
  var r:cdouble
  {.emit:"`r`=QVector2D::dotProduct(`a`,`b`);".}
  result=r.float64

proc newVec3*(x, y, z: float64): QVector3D =
  {.emit:"`result` = QVector3D(`x`,`y`,`z`);".}
proc vec3X*(v: QVector3D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.x();".}
  result=r.float64
proc vec3Y*(v: QVector3D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.y();".}
  result=r.float64
proc vec3Z*(v: QVector3D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.z();".}
  result=r.float64
proc vec3Length*(v: QVector3D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.length();".}
  result=r.float64
proc vec3Normalized*(v: QVector3D): QVector3D =
  {.emit:"`result`=`v`.normalized();".}
proc vec3Dot*(a, b: QVector3D): float64 =
  var r:cdouble
  {.emit:"`r`=QVector3D::dotProduct(`a`,`b`);".}
  result=r.float64
proc vec3Cross*(a, b: QVector3D): QVector3D =
  {.emit:"`result`=QVector3D::crossProduct(`a`,`b`);".}
proc vec3Add*(a, b: QVector3D): QVector3D = {.emit:"`result`=`a`+`b`;".}
proc vec3Sub*(a, b: QVector3D): QVector3D = {.emit:"`result`=`a`-`b`;".}
proc vec3Scale*(v: QVector3D, s: float64): QVector3D = {.emit:"`result`=`v`*`s`;".}

proc newVec4*(x, y, z, w: float64): QVector4D =
  {.emit:"`result` = QVector4D(`x`,`y`,`z`,`w`);".}
proc vec4X*(v: QVector4D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.x();".}
  result=r.float64
proc vec4Y*(v: QVector4D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.y();".}
  result=r.float64
proc vec4Z*(v: QVector4D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.z();".}
  result=r.float64
proc vec4W*(v: QVector4D): float64 =
  var r:cdouble
  {.emit:"`r`=`v`.w();".}
  result=r.float64

# ── QQuaternion ───────────────────────────────────────────────────────────────

proc newQuaternion*(scalar, x, y, z: float64): QQuaternion =
  {.emit:"`result` = QQuaternion(`scalar`,`x`,`y`,`z`);".}

proc quaternionFromAxisAngle*(x, y, z, angle: float64): QQuaternion =
  {.emit:"`result` = QQuaternion::fromAxisAndAngle(QVector3D(`x`,`y`,`z`),`angle`);".}

proc quaternionFromEulerAngles*(pitch, yaw, roll: float64): QQuaternion =
  {.emit:"`result` = QQuaternion::fromEulerAngles(`pitch`,`yaw`,`roll`);".}

proc quaternionNormalized*(q: QQuaternion): QQuaternion =
  {.emit:"`result`=`q`.normalized();".}

proc quaternionLength*(q: QQuaternion): float64 =
  var r:cdouble
  {.emit:"`r`=`q`.length();".}
  result=r.float64

proc quaternionInverted*(q: QQuaternion): QQuaternion =
  {.emit:"`result`=`q`.inverted();".}

proc quaternionMultiply*(a, b: QQuaternion): QQuaternion =
  {.emit:"`result`=`a`*`b`;".}

proc quaternionRotateVector*(q: QQuaternion, x, y, z: float64): tuple[x,y,z: float64] =
  var rx,ry,rz: cdouble
  {.emit:"QVector3D _qrv=`q`.rotatedVector(QVector3D(`x`,`y`,`z`)); `rx`=_qrv.x();`ry`=_qrv.y();`rz`=_qrv.z();".}
  result=(x:rx.float64, y:ry.float64, z:rz.float64)

proc quaternionToMatrix*(q: QQuaternion): QMatrix4x4 =
  {.emit:"`result`=`q`.toRotationMatrix();".}

proc quaternionGetAxisAngle*(q: QQuaternion): tuple[x,y,z,angle: float64] =
  var x,y,z,a: cdouble
  {.emit:"QVector3D _qax; float _qa; `q`.getAxisAndAngle(&_qax,&_qa); `x`=_qax.x();`y`=_qax.y();`z`=_qax.z();`a`=_qa;".}
  result=(x:x.float64, y:y.float64, z:z.float64, angle:a.float64)

# ── QPainter ──────────────────────────────────────────────────────────────────

proc newPainter*(): Pntr {.importcpp: "new QPainter()".}
proc newPainterOnPixmap*(p: Pxm): Pntr {.importcpp: "new QPainter(#)".}
proc newPainterOnImage*(img: ptr QImage): Pntr {.importcpp: "new QPainter(#)".}

proc painterBegin*(p: Pntr, dev: Pxm): bool =
  var r:cint
  {.emit:"`r`=`p`->begin(`dev`)?1:0;".}
  result=r==1

proc painterEnd*(p: Pntr): bool =
  var r:cint
  {.emit:"`r`=`p`->end()?1:0;".}
  result=r==1

proc setRenderHint*(p: Pntr, hint: QPainterRenderHint, on: bool = true) =
  let hi=hint.cint; let bv=on.cint
  {.emit:"`p`->setRenderHint((QPainter::RenderHint)`hi`, (bool)`bv`);".}

proc setRenderHints*(p: Pntr, hints: cint, on: bool = true) =
  let bv=on.cint
  {.emit:"`p`->setRenderHints((QPainter::RenderHints)`hints`, (bool)`bv`);".}

proc setCompositionMode*(p: Pntr, mode: QPainterCompositionMode) =
  let mi=mode.cint
  {.emit:"`p`->setCompositionMode((QPainter::CompositionMode)`mi`);".}

proc setOpacity*(p: Pntr, opacity: float64) {.importcpp: "#->setOpacity(#)".}
proc opacity*(p: Pntr): float64 {.importcpp: "#->opacity()".}

proc setPen*(p: Pntr, pen: QPen) {.importcpp: "#->setPen(#)".}
proc setPenColor*(p: Pntr, c: QColor) {.importcpp: "#->setPen(#)".}
proc setPenStyle*(p: Pntr, style: QtPenStyle) =
  let si=style.cint
  {.emit:"`p`->setPen((Qt::PenStyle)`si`);".}
proc setNoPen*(p: Pntr) =
  {.emit:"`p`->setPen(Qt::NoPen);".}

proc setBrush*(p: Pntr, brush: QBrush) {.importcpp: "#->setBrush(#)".}
proc setBrushColor*(p: Pntr, c: QColor) {.importcpp: "#->setBrush(#)".}
proc setNoBrush*(p: Pntr) =
  {.emit:"`p`->setBrush(Qt::NoBrush);".}

proc setFont*(p: Pntr, font: QFont) {.importcpp: "#->setFont(#)".}

proc setBackground*(p: Pntr, brush: QBrush) {.importcpp: "#->setBackground(#)".}
proc setBackgroundMode*(p: Pntr, mode: cint) =
  {.emit:"`p`->setBackgroundMode((Qt::BGMode)`mode`);".}

proc setClipRect*(p: Pntr, x, y, w, h: int, op: cint = 0) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->setClipRect(QRect(`xi`,`yi`,`wi`,`hi`),(Qt::ClipOperation)`op`);".}

proc setClipRectF*(p: Pntr, x, y, w, h: float64, op: cint = 0) =
  {.emit:"`p`->setClipRect(QRectF(`x`,`y`,`w`,`h`),(Qt::ClipOperation)`op`);".}

proc setClipRegion*(p: Pntr, region: QRegion, op: cint = 0) =
  {.emit:"`p`->setClipRegion(`region`,(Qt::ClipOperation)`op`);".}

proc setClipPath*(p: Pntr, path: QPainterPath, op: cint = 0) =
  {.emit:"`p`->setClipPath(`path`,(Qt::ClipOperation)`op`);".}

proc setClipping*(p: Pntr, enable: bool) =
  let bv=enable.cint
  {.emit:"`p`->setClipping((bool)`bv`);".}

proc setTransform*(p: Pntr, t: QTransform, combine: bool = false) =
  let bv=combine.cint
  {.emit:"`p`->setTransform(`t`,(bool)`bv`);".}

proc setWorldTransform*(p: Pntr, t: QTransform, combine: bool = false) =
  let bv=combine.cint
  {.emit:"`p`->setWorldTransform(`t`,(bool)`bv`);".}

proc setWorldMatrixEnabled*(p: Pntr, enable: bool) =
  let bv=enable.cint
  {.emit:"`p`->setWorldMatrixEnabled((bool)`bv`);".}

proc painterTranslate*(p: Pntr, dx, dy: float64) =
  {.emit:"`p`->translate(`dx`,`dy`);".}

proc painterScale*(p: Pntr, sx, sy: float64) =
  {.emit:"`p`->scale(`sx`,`sy`);".}

proc painterRotate*(p: Pntr, angle: float64) =
  {.emit:"`p`->rotate(`angle`);".}

proc painterShear*(p: Pntr, sh, sv: float64) =
  {.emit:"`p`->shear(`sh`,`sv`);".}

proc painterSave*(p: Pntr) {.importcpp: "#->save()".}
proc painterRestore*(p: Pntr) {.importcpp: "#->restore()".}

proc drawLine*(p: Pntr, x1, y1, x2, y2: int) =
  let a=x1.cint; let b=y1.cint; let c=x2.cint; let d=y2.cint
  {.emit:"`p`->drawLine(`a`,`b`,`c`,`d`);".}

proc drawLineF*(p: Pntr, x1, y1, x2, y2: float64) =
  {.emit:"`p`->drawLine(QPointF(`x1`,`y1`),QPointF(`x2`,`y2`));".}

proc drawRect*(p: Pntr, x, y, w, h: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->drawRect(`xi`,`yi`,`wi`,`hi`);".}

proc drawRectF*(p: Pntr, x, y, w, h: float64) =
  {.emit:"`p`->drawRect(QRectF(`x`,`y`,`w`,`h`));".}

proc fillRect*(p: Pntr, x, y, w, h: int, c: QColor) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->fillRect(`xi`,`yi`,`wi`,`hi`,`c`);".}

proc fillRectF*(p: Pntr, x, y, w, h: float64, c: QColor) =
  {.emit:"`p`->fillRect(QRectF(`x`,`y`,`w`,`h`),`c`);".}

proc fillRectBrush*(p: Pntr, x, y, w, h: int, brush: QBrush) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->fillRect(QRect(`xi`,`yi`,`wi`,`hi`),`brush`);".}

proc drawEllipse*(p: Pntr, x, y, w, h: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->drawEllipse(`xi`,`yi`,`wi`,`hi`);".}

proc drawEllipseF*(p: Pntr, cx, cy, rx, ry: float64) =
  {.emit:"`p`->drawEllipse(QPointF(`cx`,`cy`),`rx`,`ry`);".}

proc drawArc*(p: Pntr, x, y, w, h, startAngle, spanAngle: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  let sa=startAngle.cint; let span=spanAngle.cint
  {.emit:"`p`->drawArc(`xi`,`yi`,`wi`,`hi`,`sa`,`span`);".}

proc drawPie*(p: Pntr, x, y, w, h, startAngle, spanAngle: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  let sa=startAngle.cint; let span=spanAngle.cint
  {.emit:"`p`->drawPie(`xi`,`yi`,`wi`,`hi`,`sa`,`span`);".}

proc drawChord*(p: Pntr, x, y, w, h, startAngle, spanAngle: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  let sa=startAngle.cint; let span=spanAngle.cint
  {.emit:"`p`->drawChord(`xi`,`yi`,`wi`,`hi`,`sa`,`span`);".}

proc drawRoundedRect*(p: Pntr, x, y, w, h: int, xRadius, yRadius: float64) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->drawRoundedRect(QRect(`xi`,`yi`,`wi`,`hi`),`xRadius`,`yRadius`);".}

proc drawRoundedRectF*(p: Pntr, x, y, w, h, xRadius, yRadius: float64) =
  {.emit:"`p`->drawRoundedRect(QRectF(`x`,`y`,`w`,`h`),`xRadius`,`yRadius`);".}

proc drawPoint*(p: Pntr, x, y: int) =
  let xi=x.cint; let yi=y.cint
  {.emit:"`p`->drawPoint(`xi`,`yi`);".}

proc drawPointF*(p: Pntr, x, y: float64) =
  {.emit:"`p`->drawPoint(QPointF(`x`,`y`));".}

proc drawPolygon*(p: Pntr, points: openArray[NimPoint]) =
  var n=points.len.cint
  {.emit:"QPolygon _poly;".}
  for pt in points:
    let xi=pt.x.cint; let yi=pt.y.cint
    {.emit:"_poly.append(QPoint(`xi`,`yi`));".}
  {.emit:"`p`->drawPolygon(_poly);".}

proc drawPolygonF*(p: Pntr, points: openArray[NimPointF]) =
  var n=points.len.cint
  {.emit:"QPolygonF _polyf;".}
  for pt in points:
    {.emit:"_polyf.append(QPointF(`pt.x`,`pt.y`));".}
  {.emit:"`p`->drawPolygon(_polyf);".}

proc drawPolyline*(p: Pntr, points: openArray[NimPoint]) =
  {.emit:"QPolygon _pline;".}
  for pt in points:
    let xi=pt.x.cint; let yi=pt.y.cint
    {.emit:"_pline.append(QPoint(`xi`,`yi`));".}
  {.emit:"`p`->drawPolyline(_pline);".}

proc drawPath*(p: Pntr, path: QPainterPath) {.importcpp: "#->drawPath(#)".}
proc fillPath*(p: Pntr, path: QPainterPath, brush: QBrush) {.importcpp: "#->fillPath(#,#)".}
proc strokePath*(p: Pntr, path: QPainterPath, pen: QPen) {.importcpp: "#->strokePath(#,#)".}

proc drawText*(p: Pntr, x, y: int, text: string) =
  let xi=x.cint; let yi=y.cint; let cs=text.cstring
  {.emit:"`p`->drawText(`xi`,`yi`,QString::fromUtf8(`cs`));".}

proc drawTextF*(p: Pntr, x, y: float64, text: string) =
  let cs=text.cstring
  {.emit:"`p`->drawText(QPointF(`x`,`y`),QString::fromUtf8(`cs`));".}

proc drawTextRect*(p: Pntr, x, y, w, h: int, flags: cint, text: string) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint; let cs=text.cstring
  {.emit:"`p`->drawText(QRect(`xi`,`yi`,`wi`,`hi`),`flags`,QString::fromUtf8(`cs`));".}

proc drawTextRectF*(p: Pntr, x, y, w, h: float64, flags: cint, text: string) =
  let cs=text.cstring
  {.emit:"`p`->drawText(QRectF(`x`,`y`,`w`,`h`),`flags`,QString::fromUtf8(`cs`));".}

proc drawStaticText*(p: Pntr, x, y: int, text: string) =
  let xi=x.cint; let yi=y.cint; let cs=text.cstring
  {.emit:"`p`->drawStaticText(`xi`,`yi`,QStaticText(QString::fromUtf8(`cs`)));".}

proc drawImage*(p: Pntr, x, y: int, img: QImage) =
  let xi=x.cint; let yi=y.cint
  {.emit:"`p`->drawImage(`xi`,`yi`,`img`);".}

proc drawImageF*(p: Pntr, x, y: float64, img: QImage) =
  {.emit:"`p`->drawImage(QPointF(`x`,`y`),`img`);".}

proc drawImageScaled*(p: Pntr, x, y, w, h: int, img: QImage) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->drawImage(QRect(`xi`,`yi`,`wi`,`hi`),`img`);".}

proc drawImageSection*(p: Pntr, targetX, targetY, targetW, targetH: int,
                       img: QImage, srcX, srcY, srcW, srcH: int) =
  let tx=targetX.cint; let ty=targetY.cint; let tw=targetW.cint; let th=targetH.cint
  let sx=srcX.cint; let sy=srcY.cint; let sw=srcW.cint; let sh=srcH.cint
  {.emit:"`p`->drawImage(QRect(`tx`,`ty`,`tw`,`th`),`img`,QRect(`sx`,`sy`,`sw`,`sh`));".}

proc drawPixmap*(p: Pntr, x, y: int, pxm: Pxm) =
  let xi=x.cint; let yi=y.cint
  {.emit:"`p`->drawPixmap(`xi`,`yi`,*`pxm`);".}

proc drawPixmapF*(p: Pntr, x, y: float64, pxm: Pxm) =
  {.emit:"`p`->drawPixmap(QPointF(`x`,`y`),*`pxm`);".}

proc drawPixmapScaled*(p: Pntr, x, y, w, h: int, pxm: Pxm) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->drawPixmap(QRect(`xi`,`yi`,`wi`,`hi`),*`pxm`);".}

proc drawPixmapSection*(p: Pntr, tx, ty, tw, th: int, pxm: Pxm, sx, sy, sw, sh: int) =
  let txi=tx.cint; let tyi=ty.cint; let twi=tw.cint; let thi=th.cint
  let sxi=sx.cint; let syi=sy.cint; let swi=sw.cint; let shi=sh.cint
  {.emit:"`p`->drawPixmap(QRect(`txi`,`tyi`,`twi`,`thi`),*`pxm`,QRect(`sxi`,`syi`,`swi`,`shi`));".}

proc drawTiledPixmap*(p: Pntr, x, y, w, h: int, pxm: Pxm) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->drawTiledPixmap(QRect(`xi`,`yi`,`wi`,`hi`),*`pxm`);".}

proc eraseRect*(p: Pntr, x, y, w, h: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->eraseRect(`xi`,`yi`,`wi`,`hi`);".}

proc painterIsActive*(p: Pntr): bool =
  var v:cint
  {.emit:"`v`=`p`->isActive()?1:0;".}
  result=v==1

proc painterViewport*(p: Pntr): NimRect =
  var x,y,w,h: cint
  {.emit:"QRect _pv=`p`->viewport(); `x`=_pv.x();`y`=_pv.y();`w`=_pv.width();`h`=_pv.height();".}
  result=(x:x.int, y:y.int, w:w.int, h:h.int)

proc setViewport*(p: Pntr, x, y, w, h: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->setViewport(`xi`,`yi`,`wi`,`hi`);".}

proc setWindow*(p: Pntr, x, y, w, h: int) =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`p`->setWindow(`xi`,`yi`,`wi`,`hi`);".}

# ── QPainterPath ─────────────────────────────────────────────────────────────

proc newPainterPath*(): QPainterPath =
  {.emit:"`result` = QPainterPath();".}

proc newPainterPathAt*(x, y: float64): QPainterPath =
  {.emit:"`result` = QPainterPath(QPointF(`x`,`y`));".}

proc ppMoveTo*(path: var QPainterPath, x, y: float64) =
  {.emit:"`path`.moveTo(`x`,`y`);".}
proc ppLineTo*(path: var QPainterPath, x, y: float64) =
  {.emit:"`path`.lineTo(`x`,`y`);".}
proc ppArcTo*(path: var QPainterPath, x, y, w, h, startAngle, sweepLength: float64) =
  {.emit:"`path`.arcTo(`x`,`y`,`w`,`h`,`startAngle`,`sweepLength`);".}
proc ppCubicTo*(path: var QPainterPath, c1x, c1y, c2x, c2y, ex, ey: float64) =
  {.emit:"`path`.cubicTo(`c1x`,`c1y`,`c2x`,`c2y`,`ex`,`ey`);".}
proc ppQuadTo*(path: var QPainterPath, cx, cy, ex, ey: float64) =
  {.emit:"`path`.quadTo(`cx`,`cy`,`ex`,`ey`);".}
proc ppCloseSubpath*(path: var QPainterPath) {.importcpp: "#.closeSubpath()".}
proc ppAddRect*(path: var QPainterPath, x, y, w, h: float64) =
  {.emit:"`path`.addRect(`x`,`y`,`w`,`h`);".}
proc ppAddEllipse*(path: var QPainterPath, x, y, w, h: float64) =
  {.emit:"`path`.addEllipse(`x`,`y`,`w`,`h`);".}
proc ppAddRoundedRect*(path: var QPainterPath, x, y, w, h, xr, yr: float64) =
  {.emit:"`path`.addRoundedRect(`x`,`y`,`w`,`h`,`xr`,`yr`);".}
proc ppAddText*(path: var QPainterPath, x, y: float64, font: QFont, text: string) =
  let cs=text.cstring
  {.emit:"`path`.addText(`x`,`y`,`font`,QString::fromUtf8(`cs`));".}
proc ppAddPath*(path: var QPainterPath, other: QPainterPath) {.importcpp: "#.addPath(#)".}
proc ppUnited*(a, b: QPainterPath): QPainterPath = {.emit:"`result`=`a`.united(`b`);".}
proc ppIntersected*(a, b: QPainterPath): QPainterPath = {.emit:"`result`=`a`.intersected(`b`);".}
proc ppSubtracted*(a, b: QPainterPath): QPainterPath = {.emit:"`result`=`a`.subtracted(`b`);".}
proc ppContainsPoint*(path: QPainterPath, x, y: float64): bool =
  var v:cint
  {.emit:"`v`=`path`.contains(QPointF(`x`,`y`))?1:0;".}
  result=v==1
proc ppContainsRect*(path: QPainterPath, x, y, w, h: float64): bool =
  var v:cint
  {.emit:"`v`=`path`.contains(QRectF(`x`,`y`,`w`,`h`))?1:0;".}
  result=v==1
proc ppBoundingRect*(path: QPainterPath): NimRectF =
  var x,y,w,h: cdouble
  {.emit:"QRectF _ppbr=`path`.boundingRect(); `x`=_ppbr.x();`y`=_ppbr.y();`w`=_ppbr.width();`h`=_ppbr.height();".}
  result=(x:x.float64, y:y.float64, w:w.float64, h:h.float64)
proc ppIsEmpty*(path: QPainterPath): bool =
  var v:cint
  {.emit:"`v`=`path`.isEmpty()?1:0;".}
  result=v==1
proc ppElementCount*(path: QPainterPath): int =
  var v:cint
  {.emit:"`v`=`path`.elementCount();".}
  result=v.int
proc ppSimplified*(path: QPainterPath): QPainterPath =
  {.emit:"`result`=`path`.simplified();".}
proc ppToFillPolygons*(path: QPainterPath, t: QTransform): seq[QPolygonF] =
  var n:cint
  {.emit:"QList<QPolygonF> _pfp=`path`.toFillPolygons(`t`); `n`=_pfp.size();".}
  result=newSeq[QPolygonF](n.int)
  for i in 0..<n.int:
    let idx=i.cint
    {.emit:"`result`[`idx`]=_pfp.at(`idx`);".}

# ── QRegion ───────────────────────────────────────────────────────────────────

proc newRegion*(): QRegion =
  {.emit:"`result` = QRegion();".}

proc newRegionRect*(x, y, w, h: int): QRegion =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit:"`result` = QRegion(`xi`,`yi`,`wi`,`hi`);".}

proc regionUnited*(a, b: QRegion): QRegion = {.emit:"`result`=`a`.united(`b`);".}
proc regionIntersected*(a, b: QRegion): QRegion = {.emit:"`result`=`a`.intersected(`b`);".}
proc regionSubtracted*(a, b: QRegion): QRegion = {.emit:"`result`=`a`.subtracted(`b`);".}
proc regionXored*(a, b: QRegion): QRegion = {.emit:"`result`=`a`.xored(`b`);".}
proc regionIsEmpty*(r: QRegion): bool =
  var v:cint
  {.emit:"`v`=`r`.isEmpty()?1:0;".}
  result=v==1
proc regionContainsPoint*(r: QRegion, x, y: int): bool =
  let xi=x.cint; let yi=y.cint; var v:cint
  {.emit:"`v`=`r`.contains(QPoint(`xi`,`yi`))?1:0;".}
  result=v==1
proc regionBoundingRect*(r: QRegion): NimRect =
  var x,y,w,h: cint
  {.emit:"QRect _rbr=`r`.boundingRect(); `x`=_rbr.x();`y`=_rbr.y();`w`=_rbr.width();`h`=_rbr.height();".}
  result=(x:x.int, y:y.int, w:w.int, h:h.int)
proc regionTranslate*(r: var QRegion, dx, dy: int) =
  let dxi=dx.cint; let dyi=dy.cint
  {.emit:"`r`.translate(`dxi`,`dyi`);".}

# ── QKeyEvent ────────────────────────────────────────────────────────────────

proc keyEventKey*(e: ptr QKeyEvent): int =
  var v:cint
  {.emit:"`v`=`e`->key();".}
  result=v.int

proc keyEventText*(e: ptr QKeyEvent): string =
  var p:cstring
  {.emit:"static QByteArray _bket; _bket=`e`->text().toUtf8(); `p`=_bket.constData();".}
  result = $p

proc keyEventModifiers*(e: ptr QKeyEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->modifiers();".}
  result=v

proc keyEventIsAutoRepeat*(e: ptr QKeyEvent): bool =
  var v:cint
  {.emit:"`v`=`e`->isAutoRepeat()?1:0;".}
  result=v==1

proc keyEventCount*(e: ptr QKeyEvent): int =
  var v:cint
  {.emit:"`v`=`e`->count();".}
  result=v.int

proc keyEventNativeScanCode*(e: ptr QKeyEvent): uint32 =
  var v:cuint
  {.emit:"`v`=`e`->nativeScanCode();".}
  result=v.uint32

proc keyEventNativeVirtualKey*(e: ptr QKeyEvent): uint32 =
  var v:cuint
  {.emit:"`v`=`e`->nativeVirtualKey();".}
  result=v.uint32

proc keyEventNativeModifiers*(e: ptr QKeyEvent): uint32 =
  var v:cuint
  {.emit:"`v`=`e`->nativeModifiers();".}
  result=v.uint32

# ── QMouseEvent ──────────────────────────────────────────────────────────────

proc mouseEventPos*(e: ptr QMouseEvent): NimPoint =
  var x,y:cint
  {.emit:"QPoint _mpos=`e`->pos(); `x`=_mpos.x(); `y`=_mpos.y();".}
  result=(x:x.int, y:y.int)

proc mouseEventPosF*(e: ptr QMouseEvent): NimPointF =
  var x,y: cdouble
  {.emit:"QPointF _mposf=`e`->position(); `x`=_mposf.x(); `y`=_mposf.y();".}
  result=(x:x.float64, y:y.float64)

proc mouseEventGlobalPos*(e: ptr QMouseEvent): NimPoint =
  var x,y:cint
  {.emit:"QPoint _mgp=`e`->globalPos(); `x`=_mgp.x(); `y`=_mgp.y();".}
  result=(x:x.int, y:y.int)

proc mouseEventButton*(e: ptr QMouseEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->button();".}
  result=v

proc mouseEventButtons*(e: ptr QMouseEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->buttons();".}
  result=v

proc mouseEventModifiers*(e: ptr QMouseEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->modifiers();".}
  result=v

proc mouseEventSource*(e: ptr QMouseEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->source();".}
  result=v

# ── QWheelEvent ──────────────────────────────────────────────────────────────

proc wheelEventPos*(e: ptr QWheelEvent): NimPoint =
  var x,y:cint
  {.emit:"QPoint _wpos=`e`->position().toPoint(); `x`=_wpos.x(); `y`=_wpos.y();".}
  result=(x:x.int, y:y.int)

proc wheelEventAngleDelta*(e: ptr QWheelEvent): NimPoint =
  var x,y:cint
  {.emit:"QPoint _wad=`e`->angleDelta(); `x`=_wad.x(); `y`=_wad.y();".}
  result=(x:x.int, y:y.int)

proc wheelEventPixelDelta*(e: ptr QWheelEvent): NimPoint =
  var x,y:cint
  {.emit:"QPoint _wpd=`e`->pixelDelta(); `x`=_wpd.x(); `y`=_wpd.y();".}
  result=(x:x.int, y:y.int)

proc wheelEventButtons*(e: ptr QWheelEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->buttons();".}
  result=v

proc wheelEventModifiers*(e: ptr QWheelEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->modifiers();".}
  result=v

proc wheelEventPhase*(e: ptr QWheelEvent): cint =
  var v:cint
  {.emit:"`v`=(int)`e`->phase();".}
  result=v

proc wheelEventInverted*(e: ptr QWheelEvent): bool =
  var v:cint
  {.emit:"`v`=`e`->inverted()?1:0;".}
  result=v==1

# ── QClipboard ───────────────────────────────────────────────────────────────

proc clipboardText*(c: Clip, mode: cint = 0): string =
  var p:cstring
  {.emit:"static QByteArray _bct; _bct=`c`->text((QClipboard::Mode)`mode`).toUtf8(); `p`=_bct.constData();".}
  result = $p

proc clipboardSetText*(c: Clip, text: string, mode: cint = 0) =
  let cs=text.cstring
  {.emit:"`c`->setText(QString::fromUtf8(`cs`),(QClipboard::Mode)`mode`);".}

proc clipboardPixmap*(c: Clip, mode: cint = 0): Pxm =
  {.emit:"`result` = new QPixmap(`c`->pixmap((QClipboard::Mode)`mode`));".}

proc clipboardSetPixmap*(c: Clip, p: Pxm, mode: cint = 0) =
  {.emit:"`c`->setPixmap(*`p`,(QClipboard::Mode)`mode`);".}

proc clipboardImage*(c: Clip, mode: cint = 0): QImage =
  {.emit:"`result` = `c`->image((QClipboard::Mode)`mode`);".}

proc clipboardSetImage*(c: Clip, img: QImage, mode: cint = 0) =
  {.emit:"`c`->setImage(`img`,(QClipboard::Mode)`mode`);".}

proc clipboardMimeData*(c: Clip, mode: cint = 0): MimeD =
  {.emit:"`result` = const_cast<QMimeData*>(`c`->mimeData((QClipboard::Mode)`mode`));".}

proc clipboardSetMimeData*(c: Clip, d: MimeD, mode: cint = 0) =
  {.emit:"`c`->setMimeData(`d`,(QClipboard::Mode)`mode`);".}

proc clipboardClear*(c: Clip, mode: cint = 0) =
  {.emit:"`c`->clear((QClipboard::Mode)`mode`);".}

proc clipboardSupportsSelection*(c: Clip): bool =
  var v:cint
  {.emit:"`v`=`c`->supportsSelection()?1:0;".}
  result=v==1

# ── QMimeData ────────────────────────────────────────────────────────────────

proc newMimeData*(): MimeD {.importcpp: "new QMimeData()".}

proc mimeHasText*(d: MimeD): bool =
  var v:cint
  {.emit:"`v`=`d`->hasText()?1:0;".}
  result=v==1
proc mimeHasHtml*(d: MimeD): bool =
  var v:cint
  {.emit:"`v`=`d`->hasHtml()?1:0;".}
  result=v==1
proc mimeHasImage*(d: MimeD): bool =
  var v:cint
  {.emit:"`v`=`d`->hasImage()?1:0;".}
  result=v==1
proc mimeHasUrls*(d: MimeD): bool =
  var v:cint
  {.emit:"`v`=`d`->hasUrls()?1:0;".}
  result=v==1
proc mimeHasFormat*(d: MimeD, fmt: string): bool =
  let cs=fmt.cstring; var v:cint
  {.emit:"`v`=`d`->hasFormat(QString::fromUtf8(`cs`))?1:0;".}
  result=v==1

proc mimeText*(d: MimeD): string =
  var p:cstring
  {.emit:"static QByteArray _bmt; _bmt=`d`->text().toUtf8(); `p`=_bmt.constData();".}
  result = $p

proc mimeHtml*(d: MimeD): string =
  var p:cstring
  {.emit:"static QByteArray _bmh; _bmh=`d`->html().toUtf8(); `p`=_bmh.constData();".}
  result = $p

proc mimeSetText*(d: MimeD, text: string) =
  let cs=text.cstring
  {.emit:"`d`->setText(QString::fromUtf8(`cs`));".}
proc mimeSetHtml*(d: MimeD, html: string) =
  let cs=html.cstring
  {.emit:"`d`->setHtml(QString::fromUtf8(`cs`));".}
proc mimeSetImage*(d: MimeD, img: QImage) =
  {.emit:"`d`->setImageData(QVariant(`img`));".}

proc mimeFormats*(d: MimeD): seq[string] =
  var n:cint
  {.emit:"QStringList _mfl=`d`->formats(); `n`=_mfl.size();".}
  result=newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p:cstring
    {.emit:"static QByteArray _bmfv; _bmfv=_mfl.at(`idx`).toUtf8(); `p`=_bmfv.constData();".}
    result[i]=$p

proc mimeData*(d: MimeD, fmt: string): string =
  let cs=fmt.cstring; var p:cstring
  {.emit:"static QByteArray _bmd; _bmd=`d`->data(QString::fromUtf8(`cs`)); `p`=_bmd.constData();".}
  result = $p

proc mimeSetData*(d: MimeD, fmt: string, data: string) =
  let cf=fmt.cstring; let cd=data.cstring; let n=data.len.cint
  {.emit:"`d`->setData(QString::fromUtf8(`cf`),QByteArray(`cd`,`n`));".}

proc mimeUrls*(d: MimeD): seq[string] =
  var n:cint
  {.emit:"QList<QUrl> _mul=`d`->urls(); `n`=_mul.size();".}
  result=newSeq[string](n.int)
  for i in 0..<n.int:
    let idx=i.cint; var p:cstring
    {.emit:"static QByteArray _bmu; _bmu=_mul.at(`idx`).toString().toUtf8(); `p`=_bmu.constData();".}
    result[i]=$p

# ── QPalette ─────────────────────────────────────────────────────────────────

proc newPalette*(): QPalette =
  {.emit:"`result` = QPalette();".}

proc paletteColor*(pal: QPalette, group: QPaletteColorGroup, role: QPaletteColorRole): QColor =
  let gi=group.cint; let ri=role.cint
  {.emit:"`result`=`pal`.color((QPalette::ColorGroup)`gi`,(QPalette::ColorRole)`ri`);".}

proc paletteColorActive*(pal: QPalette, role: QPaletteColorRole): QColor =
  let ri=role.cint
  {.emit:"`result`=`pal`.color(QPalette::Active,(QPalette::ColorRole)`ri`);".}

proc paletteSetColor*(pal: var QPalette, group: QPaletteColorGroup, role: QPaletteColorRole, color: QColor) =
  let gi=group.cint; let ri=role.cint
  {.emit:"`pal`.setColor((QPalette::ColorGroup)`gi`,(QPalette::ColorRole)`ri`,`color`);".}

proc paletteSetColorAll*(pal: var QPalette, role: QPaletteColorRole, color: QColor) =
  let ri=role.cint
  {.emit:"`pal`.setColor((QPalette::ColorRole)`ri`,`color`);".}

proc paletteIsEqual*(a, b: QPalette, group: QPaletteColorGroup): bool =
  let gi=group.cint; var v:cint
  {.emit:"`v`=`a`.isCopyOf(`b`)?1:0;".}
  result=v==1

# ── QSurfaceFormat ───────────────────────────────────────────────────────────

proc newSurfaceFormat*(): QSurfaceFormat =
  {.emit:"`result` = QSurfaceFormat();".}

proc sfSetVersion*(f: var QSurfaceFormat, major, minor: int) =
  let mai=major.cint; let mii=minor.cint
  {.emit:"`f`.setVersion(`mai`,`mii`);".}

proc sfSetProfile*(f: var QSurfaceFormat, profile: QSurfaceFormatProfile) =
  let pi=profile.cint
  {.emit:"`f`.setProfile((QSurfaceFormat::OpenGLContextProfile)`pi`);".}

proc sfSetDepthBufferSize*(f: var QSurfaceFormat, size: int) =
  let si=size.cint
  {.emit:"`f`.setDepthBufferSize(`si`);".}

proc sfSetStencilBufferSize*(f: var QSurfaceFormat, size: int) =
  let si=size.cint
  {.emit:"`f`.setStencilBufferSize(`si`);".}

proc sfSetSamples*(f: var QSurfaceFormat, samples: int) =
  let si=samples.cint
  {.emit:"`f`.setSamples(`si`);".}

proc sfSetSwapInterval*(f: var QSurfaceFormat, interval: int) =
  let ii=interval.cint
  {.emit:"`f`.setSwapInterval(`ii`);".}

proc sfSetOption*(f: var QSurfaceFormat, opt: QSurfaceFormatOption) =
  let oi=opt.cint
  {.emit:"`f`.setOption((QSurfaceFormat::FormatOption)`oi`);".}

proc sfMajorVersion*(f: QSurfaceFormat): int =
  var v:cint
  {.emit:"`v`=`f`.majorVersion();".}
  result=v.int

proc sfMinorVersion*(f: QSurfaceFormat): int =
  var v:cint
  {.emit:"`v`=`f`.minorVersion();".}
  result=v.int

proc sfSetDefaultFormat*(fmt: QSurfaceFormat) =
  {.emit:"QSurfaceFormat::setDefaultFormat(`fmt`);".}

# ── QWindow ───────────────────────────────────────────────────────────────────

proc newQWindow*(parent: Win = nil): Win {.importcpp: "new QWindow(#)".}
proc windowShow*(w: Win)     {.importcpp: "#->show()".}
proc windowHide*(w: Win)     {.importcpp: "#->hide()".}
proc windowClose*(w: Win)    {.importcpp: "#->close()".}
proc windowRaise*(w: Win)    {.importcpp: "#->raise()".}
proc windowLower*(w: Win)    {.importcpp: "#->lower()".}
proc windowActivate*(w: Win) {.importcpp: "#->requestActivate()".}

proc windowSetTitle*(w: Win, title: string) =
  let cs=title.cstring
  {.emit:"`w`->setTitle(QString::fromUtf8(`cs`));".}

proc windowTitle*(w: Win): string =
  var p:cstring
  {.emit:"static QByteArray _bwt; _bwt=`w`->title().toUtf8(); `p`=_bwt.constData();".}
  result = $p

proc windowSetGeometry*(w: Win, x, y, width, height: int) =
  let xi=x.cint; let yi=y.cint; let wi=width.cint; let hi=height.cint
  {.emit:"`w`->setGeometry(`xi`,`yi`,`wi`,`hi`);".}

proc windowGeometry*(w: Win): NimRect =
  var x,y,wd,h: cint
  {.emit:"QRect _wg=`w`->geometry(); `x`=_wg.x();`y`=_wg.y();`wd`=_wg.width();`h`=_wg.height();".}
  result=(x:x.int, y:y.int, w:wd.int, h:h.int)

proc windowSetWidth*(w: Win, width: int) =
  let wi=width.cint
  {.emit:"`w`->setWidth(`wi`);".}
proc windowSetHeight*(w: Win, height: int) =
  let hi=height.cint
  {.emit:"`w`->setHeight(`hi`);".}
proc windowWidth*(w: Win): int =
  var v:cint
  {.emit:"`v`=`w`->width();".}
  result=v.int
proc windowHeight*(w: Win): int =
  var v:cint
  {.emit:"`v`=`w`->height();".}
  result=v.int

proc windowSetMinimumSize*(w: Win, width, height: int) =
  let wi=width.cint; let hi=height.cint
  {.emit:"`w`->setMinimumSize(QSize(`wi`,`hi`));".}
proc windowSetMaximumSize*(w: Win, width, height: int) =
  let wi=width.cint; let hi=height.cint
  {.emit:"`w`->setMaximumSize(QSize(`wi`,`hi`));".}

proc windowSetState*(w: Win, state: QWindowState) =
  let si=state.cint
  {.emit:"`w`->setWindowState((Qt::WindowStates)`si`);".}
proc windowState*(w: Win): cint =
  var v:cint
  {.emit:"`v`=(int)`w`->windowState();".}
  result=v

proc windowSetOpacity*(w: Win, opacity: float64) {.importcpp: "#->setOpacity(#)".}
proc windowOpacity*(w: Win): float64 {.importcpp: "#->opacity()".}

proc windowSetCursor*(w: Win, cursor: QCursor) {.importcpp: "#->setCursor(#)".}
proc windowUnsetCursor*(w: Win) {.importcpp: "#->unsetCursor()".}

proc windowSetIcon*(w: Win, icon: QIcon) {.importcpp: "#->setIcon(#)".}
proc windowSetFormat*(w: Win, fmt: QSurfaceFormat) {.importcpp: "#->setFormat(#)".}
proc windowFormat*(w: Win): QSurfaceFormat {.importcpp: "#->format()".}

proc windowScreen*(w: Win): Scr {.importcpp: "#->screen()".}
proc windowIsVisible*(w: Win): bool =
  var v:cint
  {.emit:"`v`=`w`->isVisible()?1:0;".}
  result=v==1
proc windowIsActive*(w: Win): bool =
  var v:cint
  {.emit:"`v`=`w`->isActive()?1:0;".}
  result=v==1
proc windowIsExposed*(w: Win): bool =
  var v:cint
  {.emit:"`v`=`w`->isExposed()?1:0;".}
  result=v==1

# ── QDesktopServices ──────────────────────────────────────────────────────────

proc openUrl*(url: string): bool =
  ## Открыть URL во внешнем браузере / приложении
  let cs=url.cstring; var r:cint
  {.emit:"`r`=QDesktopServices::openUrl(QUrl(QString::fromUtf8(`cs`)))?1:0;".}
  result=r==1

proc openFile*(path: string): bool =
  ## Открыть файл в ассоциированном приложении
  let cs=path.cstring; var r:cint
  {.emit:"`r`=QDesktopServices::openUrl(QUrl::fromLocalFile(QString::fromUtf8(`cs`)))?1:0;".}
  result=r==1

# ── QMovie ────────────────────────────────────────────────────────────────────

proc newMovie*(path: string): Mov =
  let cs=path.cstring
  {.emit:"`result` = new QMovie(QString::fromUtf8(`cs`));".}

proc movieStart*(m: Mov) {.importcpp: "#->start()".}
proc movieStop*(m: Mov)  {.importcpp: "#->stop()".}
proc moviePause*(m: Mov) {.importcpp: "#->setPaused(true)".}
proc movieResume*(m: Mov){.importcpp: "#->setPaused(false)".}

proc movieIsValid*(m: Mov): bool =
  var v:cint
  {.emit:"`v`=`m`->isValid()?1:0;".}
  result=v==1

proc movieCurrentPixmap*(m: Mov): Pxm =
  {.emit:"`result` = new QPixmap(`m`->currentPixmap());".}

proc movieCurrentImage*(m: Mov): QImage =
  {.emit:"`result` = `m`->currentImage();".}

proc movieFrameCount*(m: Mov): int =
  var v:cint
  {.emit:"`v`=`m`->frameCount();".}
  result=v.int

proc movieCurrentFrameNumber*(m: Mov): int =
  var v:cint
  {.emit:"`v`=`m`->currentFrameNumber();".}
  result=v.int

proc movieSetSpeed*(m: Mov, speed: int) =
  let si=speed.cint
  {.emit:"`m`->setSpeed(`si`);".}

proc movieSpeed*(m: Mov): int =
  var v:cint
  {.emit:"`v`=`m`->speed();".}
  result=v.int

proc movieSetScaledSize*(m: Mov, w, h: int) =
  let wi=w.cint
  let hi=h.cint
  {.emit:"`m`->setScaledSize(QSize(`wi`,`hi`));".}

proc movieJumpToFrame*(m: Mov, frame: int): bool =
  let fi=frame.cint; var r:cint
  {.emit:"`r`=`m`->jumpToFrame(`fi`)?1:0;".}
  result=r==1

type CBMovie* = proc(frameNumber: cint, ud: pointer) {.cdecl.}

proc movieOnFrameChanged*(m: Mov, cb: CBMovie, ud: pointer) =
  {.emit:"""
    QObject::connect(`m`, &QMovie::frameChanged, [=](int fn){
      `cb`(fn, `ud`);
    });
  """.}

# ── QPageSize / QPageLayout ───────────────────────────────────────────────────

proc newPageSizeById*(id: QPageSizeId): QPageSize =
  let ii=id.cint
  {.emit:"`result` = QPageSize((QPageSize::PageSizeId)`ii`);".}

proc newPageSizeCustom*(widthMM, heightMM: float64): QPageSize =
  {.emit:"`result` = QPageSize(QSizeF(`widthMM`,`heightMM`), QPageSize::Millimeter);".}

proc pageSizeName*(ps: QPageSize): string =
  var p:cstring
  {.emit:"static QByteArray _bpsn; _bpsn=`ps`.name().toUtf8(); `p`=_bpsn.constData();".}
  result = $p

proc pageSizeRectMM*(ps: QPageSize): NimRectF =
  var x,y,w,h: cdouble
  {.emit:"QRectF _psr=`ps`.rect(QPageSize::Millimeter); `x`=_psr.x();`y`=_psr.y();`w`=_psr.width();`h`=_psr.height();".}
  result=(x:x.float64, y:y.float64, w:w.float64, h:h.float64)

proc pageSizeSizeMM*(ps: QPageSize): NimSizeF =
  var w,h: cdouble
  {.emit:"QSizeF _pss=`ps`.size(QPageSize::Millimeter); `w`=_pss.width();`h`=_pss.height();".}
  result=(w:w.float64, h:h.float64)

proc newPageLayout*(ps: QPageSize, orientation: QPageLayoutOrientation,
                   leftMM, topMM, rightMM, bottomMM: float64): QPageLayout =
  let oi=orientation.cint
  {.emit:"`result` = QPageLayout(`ps`,(QPageLayout::Orientation)`oi`,QMarginsF(`leftMM`,`topMM`,`rightMM`,`bottomMM`),QPageLayout::Millimeter);".}

proc pageLayoutPaintRect*(pl: QPageLayout): NimRectF =
  var x,y,w,h: cdouble
  {.emit:"QRectF _plpr=`pl`.paintRect(QPageLayout::Millimeter); `x`=_plpr.x();`y`=_plpr.y();`w`=_plpr.width();`h`=_plpr.height();".}
  result=(x:x.float64, y:y.float64, w:w.float64, h:h.float64)

proc pageLayoutFullRect*(pl: QPageLayout): NimRectF =
  var x,y,w,h: cdouble
  {.emit:"QRectF _plfr=`pl`.fullRect(QPageLayout::Millimeter); `x`=_plfr.x();`y`=_plfr.y();`w`=_plfr.width();`h`=_plfr.height();".}
  result=(x:x.float64, y:y.float64, w:w.float64, h:h.float64)

proc pageLayoutIsValid*(pl: QPageLayout): bool =
  var v:cint
  {.emit:"`v`=`pl`.isValid()?1:0;".}
  result=v==1

# ── QColorSpace ───────────────────────────────────────────────────────────────

proc newColorSpaceSRGB*(): QColorSpace =
  {.emit:"`result` = QColorSpace(QColorSpace::SRgb);".}

proc newColorSpaceDisplayP3*(): QColorSpace =
  {.emit:"`result` = QColorSpace(QColorSpace::DisplayP3);".}

proc colorSpaceIsValid*(cs: QColorSpace): bool =
  var v:cint
  {.emit:"`v`=`cs`.isValid()?1:0;".}
  result=v==1

proc colorSpaceDescription*(cs: QColorSpace): string =
  var p:cstring
  {.emit:"static QByteArray _bcsd; _bcsd=`cs`.description().toUtf8(); `p`=_bcsd.constData();".}
  result = $p




