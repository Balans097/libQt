## nimQtFFI.nim — Низкоуровневые типы, константы и платформенные хелперы Qt6
## ============================================================================
## Содержит:
##   - Константы путей к библиотекам Qt6 (libQt6Core, libQt6Widgets, …)
##   - Фундаментальные C-opaque типы (QCoreAppPtr, QObjectPtr, …)
##   - Полные Qt namespace enums (Qt::Alignment, Qt::WindowFlag, …)
##   - Callback-типы для Nim ↔ C++ сигналов (CB, CBStr, CBInt, …)
##   - Runtime версия Qt (qtVersionStr, qtVersionMajor, …)
##   - Математические хелперы (qFuzzyCompare, qRound, …)
##   - Системная информация (QSysInfo, QStandardPaths)
##   - Хелперы файловой системы (dirExists, fileExists, mkPath, …)
##   - Debug/logging (qDebug, qWarning, qCritical, qInstallMessageHandler)
##   - Загрузка динамических библиотек (qtLibIsLoaded)
##
## Зависимости: нет (самый нижний уровень системы обёрток)
##
## Компиляция:
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Core)" \
##     --passL:"$(pkg-config --libs Qt6Core)" app.nim
##
## Совместимость: Qt 6.2 – Qt 6.11

# ── Пути заголовков (Windows/MSYS2 UCRT64) ───────────────────────────────────
# Для Linux/macOS используйте pkg-config вместо ручных путей:
#   {.passC: gorge("pkg-config --cflags Qt6Core Qt6Gui Qt6Widgets").}
#   {.passL: gorge("pkg-config --libs Qt6Core Qt6Gui Qt6Widgets").}
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}

# ── Обнаружение платформы ─────────────────────────────────────────────────────
const
  ## Префикс имени динамической библиотеки Qt
  QtLibPrefix* = when defined(windows): ""
                 elif defined(macosx):  "lib"
                 else:                  "lib"

  ## Суффикс (расширение) динамической библиотеки Qt
  QtLibSuffix* = when defined(windows): ".dll"
                 elif defined(macosx):  ".dylib"
                 else:                  ".so.6"

# ── Имена динамических библиотек Qt6 ─────────────────────────────────────────
const
  ## Ядро Qt: QObject, QCoreApplication, QThread, QTimer, QFile, …
  libQt6Core*          = QtLibPrefix & "Qt6Core"          & QtLibSuffix
  ## GUI-слой: QFont, QPixmap, QPainter, QColor, QIcon, …
  libQt6Gui*           = QtLibPrefix & "Qt6Gui"           & QtLibSuffix
  ## Виджеты: QApplication, QWidget, QPushButton, QDialog, …
  libQt6Widgets*       = QtLibPrefix & "Qt6Widgets"       & QtLibSuffix
  ## Сетевой стек: QTcpSocket, QNetworkAccessManager, …
  libQt6Network*       = QtLibPrefix & "Qt6Network"       & QtLibSuffix
  ## SQL: QSqlDatabase, QSqlQuery, …
  libQt6Sql*           = QtLibPrefix & "Qt6Sql"           & QtLibSuffix
  ## XML: QXmlStreamReader/Writer, QDomDocument, …
  libQt6Xml*           = QtLibPrefix & "Qt6Xml"           & QtLibSuffix
  ## Параллельные вычисления: QtConcurrent::run, …
  libQt6Concurrent*    = QtLibPrefix & "Qt6Concurrent"    & QtLibSuffix
  ## D-Bus: межпроцессное взаимодействие (Linux)
  libQt6DBus*          = QtLibPrefix & "Qt6DBus"          & QtLibSuffix
  ## OpenGL: QOpenGLContext, QOpenGLFunctions, …
  libQt6OpenGL*        = QtLibPrefix & "Qt6OpenGL"        & QtLibSuffix
  ## Виджеты OpenGL: QOpenGLWidget
  libQt6OpenGLWidgets* = QtLibPrefix & "Qt6OpenGLWidgets" & QtLibSuffix
  ## SVG: QSvgRenderer
  libQt6Svg*           = QtLibPrefix & "Qt6Svg"           & QtLibSuffix
  ## SVG-виджеты: QSvgWidget
  libQt6SvgWidgets*    = QtLibPrefix & "Qt6SvgWidgets"    & QtLibSuffix
  ## Печать: QPrinter, QPrintDialog, …
  libQt6PrintSupport*  = QtLibPrefix & "Qt6PrintSupport"  & QtLibSuffix
  ## PDF-рендеринг (Qt 6.4+)
  libQt6Pdf*           = QtLibPrefix & "Qt6Pdf"           & QtLibSuffix
  ## PDF-виджет (Qt 6.4+)
  libQt6PdfWidgets*    = QtLibPrefix & "Qt6PdfWidgets"    & QtLibSuffix
  ## Веб-движок — ядро (Chromium-based)
  libQt6WebEngineCore*    = QtLibPrefix & "Qt6WebEngineCore"    & QtLibSuffix
  ## Веб-виджеты
  libQt6WebEngineWidgets* = QtLibPrefix & "Qt6WebEngineWidgets" & QtLibSuffix
  ## Быстрый веб-движок (QML)
  libQt6WebEngineQuick*   = QtLibPrefix & "Qt6WebEngineQuick"   & QtLibSuffix
  ## WebSockets
  libQt6WebSockets*    = QtLibPrefix & "Qt6WebSockets"    & QtLibSuffix
  ## WebChannel
  libQt6WebChannel*    = QtLibPrefix & "Qt6WebChannel"    & QtLibSuffix
  ## Геопозиционирование
  libQt6Positioning*   = QtLibPrefix & "Qt6Positioning"   & QtLibSuffix
  ## Qt Quick (QML)
  libQt6Quick*         = QtLibPrefix & "Qt6Quick"         & QtLibSuffix
  ## Qt Multimedia (Qt 6.2+)
  libQt6Multimedia*    = QtLibPrefix & "Qt6Multimedia"    & QtLibSuffix
  ## Qt Charts (Qt 6.2+)
  libQt6Charts*        = QtLibPrefix & "Qt6Charts"        & QtLibSuffix
  ## Qt Data Visualization (Qt 6.2+)
  libQt6DataVisualization* = QtLibPrefix & "Qt6DataVisualization" & QtLibSuffix
  ## Qt HTTP Server (Qt 6.4+)
  libQt6HttpServer*    = QtLibPrefix & "Qt6HttpServer"    & QtLibSuffix
  ## Qt Graphs (Qt 6.6+ — замена DataVisualization)
  libQt6Graphs*        = QtLibPrefix & "Qt6Graphs"        & QtLibSuffix
  ## Qt Location (карты, Qt 6.5+)
  libQt6Location*      = QtLibPrefix & "Qt6Location"      & QtLibSuffix
  ## Qt Bluetooth
  libQt6Bluetooth*     = QtLibPrefix & "Qt6Bluetooth"     & QtLibSuffix
  ## Qt Serial Port
  libQt6SerialPort*    = QtLibPrefix & "Qt6SerialPort"    & QtLibSuffix
  ## Qt Serial Bus (CAN, LIN)
  libQt6SerialBus*     = QtLibPrefix & "Qt6SerialBus"     & QtLibSuffix
  ## Qt State Machine
  libQt6StateMachine*  = QtLibPrefix & "Qt6StateMachine"  & QtLibSuffix
  ## Qt SCXML
  libQt6Scxml*         = QtLibPrefix & "Qt6Scxml"         & QtLibSuffix

# ── Включаем системные заголовки Qt ──────────────────────────────────────────
{.emit: """
#include <QtCore/qglobal.h>
#include <QSysInfo>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QLibrary>
#include <QProcessEnvironment>
#include <QLoggingCategory>
#include <QVersionNumber>
#include <QtMath>
#include <limits>
""".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 1. Opaque C-совместимые указатели Qt
# ═══════════════════════════════════════════════════════════════════════════════

type
  ## Непрозрачный указатель на QCoreApplication
  QCoreAppPtr* = pointer
  ## Непрозрачный указатель на QObject (базовый тип всех Qt-объектов)
  QObjectPtr*  = pointer
  ## Непрозрачный указатель на QString (хранится на куче)
  QStringPtr*  = pointer
  ## Непрозрачный указатель на QByteArray
  QByteArrayPtr* = pointer
  ## Непрозрачный указатель на QVariant (тип-значение Qt)
  QVariantPtr* = pointer

# ═══════════════════════════════════════════════════════════════════════════════
# § 2. Callback-типы (cdecl для Nim↔C++ сигналов)
# ═══════════════════════════════════════════════════════════════════════════════

type
  ## Простой callback без параметров (для clicked(), timeout() и т.п.)
  CB*     = proc(ud: pointer) {.cdecl.}

  ## Callback с C-строкой (для textChanged, fileSelected, …)
  CBStr*  = proc(text: cstring, ud: pointer) {.cdecl.}

  ## Callback с целым числом (для currentIndexChanged, valueChanged, …)
  CBInt*  = proc(value: cint, ud: pointer) {.cdecl.}

  ## Callback с булевым значением (для toggled, stateChanged, …)
  ## Передаётся как cint (1=true, 0=false) для совместимости с C
  CBBool* = proc(checked: cint, ud: pointer) {.cdecl.}

  ## Callback с двумя целыми числами (для currentCellChanged, itemClicked(row,col), …)
  CBIdx*  = proc(row, col: cint, ud: pointer) {.cdecl.}

  ## Callback с вещественным числом (для valueChanged(double), …)
  CBDouble* = proc(value: cdouble, ud: pointer) {.cdecl.}

  ## Callback с двумя строками (для ключ-значение пар)
  CBStrStr* = proc(key, value: cstring, ud: pointer) {.cdecl.}

  ## Callback с целым и строкой (для smешанных сигналов)
  CBIntStr* = proc(index: cint, text: cstring, ud: pointer) {.cdecl.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 3. Qt namespace enums
# ═══════════════════════════════════════════════════════════════════════════════

# ── Qt::Orientation ───────────────────────────────────────────────────────────
type
  QtOrientation* {.size: sizeof(cint).} = enum
    ## Горизонтальное направление (для слайдеров, сплиттеров, …)
    Horizontal = 0x1
    ## Вертикальное направление
    Vertical   = 0x2

# ── Qt::Alignment ─────────────────────────────────────────────────────────────
type
  QtAlignment* {.size: sizeof(cint).} = enum
    ## Горизонтальное выравнивание: по левому краю
    AlignLeft     = 0x0001
    ## По правому краю
    AlignRight    = 0x0002
    ## По центру горизонтально
    AlignHCenter  = 0x0004
    ## По ширине (justify)
    AlignJustify  = 0x0008
    ## По верхнему краю
    AlignTop      = 0x0020
    ## По нижнему краю
    AlignBottom   = 0x0040
    ## По центру вертикально
    AlignVCenter  = 0x0080
    ## По базовой линии текста
    AlignBaseline = 0x0100
    ## Полное центрирование (AlignHCenter | AlignVCenter = 0x0084)
    AlignCenter   = 0x0084

# ── Qt::WindowType / WindowFlag ───────────────────────────────────────────────
type
  ## Тип окна и флаги оформления
  QtWindowType* {.size: sizeof(cint).} = enum
    WF_Widget           = 0x00000000  ## Встроенный виджет (дочерний)
    WF_Window           = 0x00000001  ## Независимое окно
    WF_Dialog           = 0x00000003  ## Диалоговое окно (Dialog|Window)
    WF_Sheet            = 0x00000005  ## Прикреплённый лист (macOS)
    WF_Popup            = 0x00000009  ## Всплывающее окно
    WF_Tool             = 0x00000011  ## Вспомогательная панель инструментов
    WF_SplashScreen     = 0x0000000D  ## Заставка (SplashScreen|Window)
    WF_Desktop          = 0x00000041  ## Рабочий стол
    WF_SubWindow        = 0x00000080  ## Подокно (QMdiSubWindow)
    WF_ForeignWindow    = 0x00000101  ## Внешнее окно другого приложения
    WF_CoverWindow      = 0x00000201  ## Обложка (мобильные ОС)
    WF_FramelessWindowHint    = 0x00000800  ## Без рамки окна
    WF_NoTitleHint            = 0x00000800  ## Псевдоним FramelessWindowHint
    WF_CustomizeWindowHint    = 0x02000000  ## Кастомный набор декораций
    WF_WindowTitleHint        = 0x00001000  ## Показать заголовок
    WF_WindowSystemMenuHint   = 0x00002000  ## Системное меню
    WF_WindowMinimizeButtonHint = 0x00004000  ## Кнопка свернуть
    WF_WindowMaximizeButtonHint = 0x00008000  ## Кнопка развернуть
    WF_WindowCloseButtonHint  = 0x08000000  ## Кнопка закрыть
    WF_WindowContextHelpButtonHint = 0x00010000  ## Кнопка «?» (только Windows)
    WF_MacWindowToolBarButtonHint  = 0x10000000  ## Кнопка тулбара (macOS)
    WF_WindowStaysOnTopHint   = 0x00040000  ## Всегда поверх других окон
    WF_WindowStaysOnBottomHint= 0x04000000  ## Всегда под другими окнами
    WF_WindowTransparentForInput = 0x00080000  ## Не получает события мыши
    WF_WindowOverridesSystemGestures = 0x00100000  ## Перехватывает жесты

# ── Qt::KeyboardModifier ──────────────────────────────────────────────────────
type
  QtKeyboardModifier* {.size: sizeof(cint).} = enum
    ## Нет модификатора
    NoModifier     = 0x00000000
    ## Shift
    ShiftModifier  = 0x02000000
    ## Ctrl (Cmd на macOS)
    ControlModifier= 0x04000000
    ## Alt
    AltModifier    = 0x08000000
    ## Meta (Win на Windows, Ctrl на macOS)
    MetaModifier   = 0x10000000
    ## Цифровая клавиатура
    KeypadModifier = 0x20000000
    ## GroupSwitch (Linux X11)
    GroupSwitchModifier = 0x40000000

# ── Qt::MouseButton ───────────────────────────────────────────────────────────
type
  QtMouseButton* {.size: sizeof(cint).} = enum
    ## Нет кнопки
    NoButton       = 0x00000000
    ## Левая кнопка мыши
    LeftButton     = 0x00000001
    ## Правая кнопка
    RightButton    = 0x00000002
    ## Средняя кнопка (колёсико)
    MiddleButton   = 0x00000004
    ## Кнопка «Назад» (боковая)
    BackButton     = 0x00000008
    ## Кнопка «Вперёд» (боковая)
    ForwardButton  = 0x00000010
    ## Кнопка «Задача» (некоторые мыши)
    TaskButton     = 0x00000020
    ## Дополнительная кнопка 4
    ExtraButton4   = 0x00000040
    ## Дополнительная кнопка 5
    ExtraButton5   = 0x00000080

# ── Qt::SortOrder ─────────────────────────────────────────────────────────────
type
  QtSortOrder* {.size: sizeof(cint).} = enum
    ## По возрастанию (A → Z, 0 → 9)
    AscendingOrder  = 0
    ## По убыванию (Z → A, 9 → 0)
    DescendingOrder = 1

# ── Qt::CheckState ────────────────────────────────────────────────────────────
type
  QtCheckState* {.size: sizeof(cint).} = enum
    ## Флажок снят
    Unchecked        = 0
    ## Частично установлен (tristate)
    PartiallyChecked = 1
    ## Флажок установлен
    Checked          = 2

# ── Qt::ItemFlag ──────────────────────────────────────────────────────────────
type
  QtItemFlag* {.size: sizeof(cint).} = enum
    ## Элемент можно выделить
    ItemIsSelectable     = 1
    ## Элемент можно редактировать
    ItemIsEditable       = 2
    ## Элемент можно перетащить (drag)
    ItemIsDragEnabled    = 4
    ## На элемент можно бросить (drop)
    ItemIsDropEnabled    = 8
    ## Элемент имеет checkbox
    ItemIsUserCheckable  = 16
    ## Элемент доступен для взаимодействия
    ItemIsEnabled        = 32
    ## Автоматический tristate-checkbox
    ItemIsAutoTristate   = 64
    ## Элемент не может иметь дочерних
    ItemNeverHasChildren = 128
    ## Пользователь управляет tristate
    ItemIsUserTristate   = 256

# ── Qt::DockWidgetArea ────────────────────────────────────────────────────────
type
  QtDockWidgetArea* {.size: sizeof(cint).} = enum
    ## Нет области прикрепления
    NoDockWidgetArea     = 0x00
    ## Левая панель
    LeftDockWidgetArea   = 0x01
    ## Правая панель
    RightDockWidgetArea  = 0x02
    ## Верхняя панель
    TopDockWidgetArea    = 0x04
    ## Нижняя панель
    BottomDockWidgetArea = 0x08
    ## Все стороны
    AllDockWidgetAreas   = 0x0f

# ── Qt::ScrollBarPolicy ───────────────────────────────────────────────────────
type
  QtScrollBarPolicy* {.size: sizeof(cint).} = enum
    ## Показывать только при необходимости
    ScrollBarAsNeeded  = 0
    ## Всегда скрывать
    ScrollBarAlwaysOff = 1
    ## Всегда показывать
    ScrollBarAlwaysOn  = 2

# ── Qt::FocusPolicy ───────────────────────────────────────────────────────────
type
  QtFocusPolicy* {.size: sizeof(cint).} = enum
    ## Виджет не получает фокус
    NoFocus     = 0
    ## Фокус только по Tab
    TabFocus    = 0x1
    ## Фокус только по клику
    ClickFocus  = 0x2
    ## Фокус по Tab и клику (рекомендуется)
    StrongFocus = 0x11
    ## Как StrongFocus + колёсико мыши
    WheelFocus  = 0x13

# ── Qt::CursorShape ───────────────────────────────────────────────────────────
type
  QtCursorShape* {.size: sizeof(cint).} = enum
    ArrowCursor        = 0   ## Обычная стрелка
    UpArrowCursor      = 1   ## Стрелка вверх
    CrossCursor        = 2   ## Перекрестие
    WaitCursor         = 3   ## Ожидание (часы)
    IBeamCursor        = 4   ## Текстовый курсор
    SizeVerCursor      = 5   ## Изменение размера вертикально
    SizeHorCursor      = 6   ## Изменение размера горизонтально
    SizeBDiagCursor    = 7   ## Изменение размера ↗↙
    SizeFDiagCursor    = 8   ## Изменение размера ↖↘
    SizeAllCursor      = 9   ## Перемещение (все стороны)
    BlankCursor        = 10  ## Невидимый курсор
    SplitVCursor       = 11  ## Разделитель вертикальный
    SplitHCursor       = 12  ## Разделитель горизонтальный
    PointingHandCursor = 13  ## Указательный палец (ссылки)
    ForbiddenCursor    = 14  ## Запрещено
    WhatsThisCursor    = 15  ## «Что это?»
    BusyCursor         = 16  ## Занято (анимированные часы)
    OpenHandCursor     = 17  ## Открытая ладонь
    ClosedHandCursor   = 18  ## Закрытая ладонь (захват)
    DragCopyCursor     = 19  ## Копирование при перетаскивании (Qt 6.x)
    DragMoveCursor     = 20  ## Перемещение при перетаскивании
    DragLinkCursor     = 21  ## Создание ссылки при перетаскивании

# ── Qt::TextFormat ────────────────────────────────────────────────────────────
type
  QtTextFormat* {.size: sizeof(cint).} = enum
    ## Чистый текст (без разметки)
    PlainText    = 0
    ## HTML-разметка
    RichText     = 1
    ## Qt сам определяет формат
    AutoText     = 2
    ## Markdown (Qt 5.14+)
    MarkdownText = 3

# ── Qt::ConnectionType ────────────────────────────────────────────────────────
type
  QtConnectionType* {.size: sizeof(cint).} = enum
    ## Qt выбирает тип автоматически (рекомендуется)
    AutoConnection           = 0
    ## Прямой вызов (в том же потоке)
    DirectConnection         = 1
    ## Через очередь событий (безопасно между потоками)
    QueuedConnection         = 2
    ## Блокирующий через очередь (межпоточный, ждёт завершения)
    BlockingQueuedConnection = 3
    ## Только одно соединение (не дублировать)
    UniqueConnection         = 0x80
    ## Одноразовое соединение (Qt 6.0+)
    SingleShotConnection     = 0x100

# ── Qt::SizePolicy ────────────────────────────────────────────────────────────
type
  QtSizePolicyPolicy* {.size: sizeof(cint).} = enum
    ## Фиксированный размер, не растягивается
    SPFixed            = 0
    ## Минимальный размер, не меньше sizeHint
    SPMinimum          = 0x1
    ## Максимальный размер, не больше sizeHint
    SPMaximum          = 0x4
    ## Предпочтительный, может увеличиваться/уменьшаться
    SPPreferred        = 0x8
    ## Растягивается (поглощает лишнее пространство)
    SPExpanding        = 0x38
    ## Минимум + растяжка
    SPMinimumExpanding = 0x31
    ## Игнорировать sizeHint (любой размер)
    SPIgnored          = 0x38

# ── Qt::LayoutDirection ───────────────────────────────────────────────────────
type
  QtLayoutDirection* {.size: sizeof(cint).} = enum
    ## Слева направо (LTR, большинство языков)
    LeftToRight        = 0
    ## Справа налево (RTL: арабский, иврит)
    RightToLeft        = 1
    ## Определяется автоматически по локали
    LayoutDirectionAuto= 2

# ── Qt::BrushStyle ────────────────────────────────────────────────────────────
type
  QtBrushStyle* {.size: sizeof(cint).} = enum
    NoBrush               = 0   ## Без заливки
    SolidPattern          = 1   ## Сплошная заливка
    Dense1Pattern         = 2   ## Очень плотная штриховка
    Dense2Pattern         = 3
    Dense3Pattern         = 4
    Dense4Pattern         = 5
    Dense5Pattern         = 6
    Dense6Pattern         = 7
    Dense7Pattern         = 8   ## Очень редкая штриховка
    HorPattern            = 9   ## Горизонтальные линии
    VerPattern            = 10  ## Вертикальные линии
    CrossPattern          = 11  ## Решётка
    BDiagPattern          = 12  ## Диагональ ↗
    FDiagPattern          = 13  ## Диагональ ↘
    DiagCrossPattern      = 14  ## Диагональная решётка
    LinearGradientPattern = 15  ## Линейный градиент
    RadialGradientPattern = 16  ## Радиальный градиент
    ConicalGradientPattern= 17  ## Конический градиент
    TexturePattern        = 24  ## Текстура (изображение)

# ── Qt::PenStyle ──────────────────────────────────────────────────────────────
type
  QtPenStyle* {.size: sizeof(cint).} = enum
    NoPen          = 0  ## Без линии
    SolidLine      = 1  ## Сплошная линия
    DashLine       = 2  ## Пунктирная (–  –  –)
    DotLine        = 3  ## Точечная (·  ·  ·)
    DashDotLine    = 4  ## Штрихпунктирная (– · –)
    DashDotDotLine = 5  ## Двойная штрихпунктирная (– ·· –)
    CustomDashLine = 6  ## Пользовательская

# ── Qt::PenCapStyle ───────────────────────────────────────────────────────────
type
  QtPenCapStyle* {.size: sizeof(cint).} = enum
    FlatCap   = 0x00  ## Обрезанный конец
    SquareCap = 0x10  ## Квадратный конец (выступает)
    RoundCap  = 0x20  ## Круглый конец

# ── Qt::PenJoinStyle ──────────────────────────────────────────────────────────
type
  QtPenJoinStyle* {.size: sizeof(cint).} = enum
    MiterJoin   = 0x00  ## Острый угол (стык)
    BevelJoin   = 0x40  ## Скошенный угол
    RoundJoin   = 0x80  ## Скруглённый угол
    SvgMiterJoin= 0x100 ## SVG-совместимый острый стык

# ── Qt::FillRule ──────────────────────────────────────────────────────────────
type
  QtFillRule* {.size: sizeof(cint).} = enum
    ## Правило чётности (odd-even)
    OddEvenFill = 0
    ## Правило ненулевого обхода
    WindingFill = 1

# ── Qt::GlobalColor ───────────────────────────────────────────────────────────
type
  QtGlobalColor* {.size: sizeof(cint).} = enum
    color_color0     = 0   ## Чёрный для 1-bit (монохром)
    color_color1     = 1   ## Белый для 1-bit (монохром)
    color_black      = 2   ## Чёрный (#000000)
    color_white      = 3   ## Белый (#ffffff)
    color_darkGray   = 4   ## Тёмно-серый (#808080)
    color_gray       = 5   ## Серый (#a0a0a4)
    color_lightGray  = 6   ## Светло-серый (#c0c0c0)
    color_red        = 7   ## Красный (#ff0000)
    color_green      = 8   ## Зелёный (#00ff00)
    color_blue       = 9   ## Синий (#0000ff)
    color_cyan       = 10  ## Голубой (#00ffff)
    color_magenta    = 11  ## Пурпурный (#ff00ff)
    color_yellow     = 12  ## Жёлтый (#ffff00)
    color_darkRed    = 13  ## Тёмно-красный (#800000)
    color_darkGreen  = 14  ## Тёмно-зелёный (#008000)
    color_darkBlue   = 15  ## Тёмно-синий (#000080)
    color_darkCyan   = 16  ## Тёмно-голубой (#008080)
    color_darkMagenta= 17  ## Тёмно-пурпурный (#800080)
    color_darkYellow = 18  ## Тёмно-жёлтый (#808000)
    color_transparent= 19  ## Прозрачный

# ── Qt::ItemDataRole ──────────────────────────────────────────────────────────
type
  QtItemDataRole* {.size: sizeof(cint).} = enum
    ## Текст для отображения (QListWidgetItem.text())
    DisplayRole      = 0
    ## Иконка
    DecorationRole   = 1
    ## Значение для редактирования
    EditRole         = 2
    ## Всплывающая подсказка
    ToolTipRole      = 3
    ## Строка в статусной строке
    StatusTipRole    = 4
    ## Текст «Что это?»
    WhatsThisRole    = 5
    ## Шрифт
    FontRole         = 6
    ## Выравнивание текста (Qt::Alignment)
    TextAlignmentRole= 7
    ## Цвет фона
    BackgroundRole   = 8
    ## Цвет переднего плана
    ForegroundRole   = 9
    ## Состояние флажка (Qt::CheckState)
    CheckStateRole   = 10
    ## Текст для accessibility
    AccessibleTextRole = 11
    ## Описание для accessibility
    AccessibleDescriptionRole = 12
    ## Рекомендуемый размер (QSize)
    SizeHintRole     = 13
    ## Начальный порядок сортировки
    InitialSortOrderRole = 14
    ## Пользовательские данные начинаются с 256
    UserRole         = 256

# ── Qt::ToolButtonStyle ───────────────────────────────────────────────────────
type
  QtToolButtonStyle* {.size: sizeof(cint).} = enum
    ## Только иконка
    ToolButtonIconOnly       = 0
    ## Только текст
    ToolButtonTextOnly       = 1
    ## Текст рядом с иконкой
    ToolButtonTextBesideIcon = 2
    ## Текст под иконкой
    ToolButtonTextUnderIcon  = 3
    ## По стилю приложения
    ToolButtonFollowStyle    = 4

# ── Qt::ArrowType ─────────────────────────────────────────────────────────────
type
  QtArrowType* {.size: sizeof(cint).} = enum
    NoArrow    = 0  ## Без стрелки
    UpArrow    = 1  ## Вверх
    DownArrow  = 2  ## Вниз
    LeftArrow  = 3  ## Влево
    RightArrow = 4  ## Вправо

# ── Qt::FrameShape и FrameShadow ──────────────────────────────────────────────
type
  QtFrameShape* {.size: sizeof(cint).} = enum
    NoFrame     = 0       ## Без рамки
    Box         = 0x0001  ## Прямоугольная рамка
    Panel       = 0x0002  ## Панельная рамка
    WinPanel    = 0x0003  ## Рамка в стиле Windows
    HLine       = 0x0004  ## Горизонтальная линия
    VLine       = 0x0005  ## Вертикальная линия
    StyledPanel = 0x0006  ## Рамка стиля (QStyleOptionFrame)

  QtFrameShadow* {.size: sizeof(cint).} = enum
    Plain  = 0x0010  ## Без тени
    Raised = 0x0020  ## Выпуклый вид
    Sunken = 0x0030  ## Вдавленный вид

# ── Qt::AspectRatioMode ───────────────────────────────────────────────────────
type
  QtAspectRatioMode* {.size: sizeof(cint).} = enum
    ## Игнорировать пропорции
    IgnoreAspectRatio          = 0
    ## Сохранить пропорции (вписать)
    KeepAspectRatio            = 1
    ## Сохранить пропорции (заполнить)
    KeepAspectRatioByExpanding = 2

# ── Qt::TransformationMode ────────────────────────────────────────────────────
type
  QtTransformationMode* {.size: sizeof(cint).} = enum
    ## Быстрое масштабирование (без сглаживания)
    FastTransformation   = 0
    ## Сглаженное масштабирование (медленнее)
    SmoothTransformation = 1

# ── Qt::ImageConversionFlag / QImage::Format ──────────────────────────────────
type
  QtImageFormat* {.size: sizeof(cint).} = enum
    Format_Invalid                = 0   ## Недопустимый формат
    Format_Mono                   = 1   ## 1 бит на пиксель
    Format_MonoLSB                = 2   ## 1 бит (LSB)
    Format_Indexed8               = 3   ## 8 бит (индексированный)
    Format_RGB32                  = 4   ## 32 бита (0xffRRGGBB)
    Format_ARGB32                 = 5   ## 32 бита с альфа
    Format_ARGB32_Premultiplied   = 6   ## 32 бита premultiplied
    Format_RGB16                  = 7   ## 16 бит (5-6-5)
    Format_ARGB8565_Premultiplied = 8   ## 24 бита premultiplied
    Format_RGB666                 = 9   ## 24 бита (6-6-6)
    Format_ARGB6666_Premultiplied = 10
    Format_RGB555                 = 11  ## 16 бит (5-5-5)
    Format_ARGB8555_Premultiplied = 12
    Format_RGB888                 = 13  ## 24 бита (8-8-8)
    Format_RGB444                 = 14  ## 16 бит (4-4-4)
    Format_ARGB4444_Premultiplied = 15
    Format_RGBX8888               = 16  ## 32 бита (X всегда 255)
    Format_RGBA8888               = 17  ## 32 бита RGBA
    Format_RGBA8888_Premultiplied = 18
    Format_BGR30                  = 19  ## 30 бит BGR
    Format_A2BGR30_Premultiplied  = 20
    Format_RGB30                  = 21
    Format_A2RGB30_Premultiplied  = 22
    Format_Alpha8                 = 23  ## 8 бит только альфа
    Format_Grayscale8             = 24  ## 8 бит оттенки серого
    Format_RGBX64                 = 25  ## 64 бита RGB
    Format_RGBA64                 = 26  ## 64 бита RGBA
    Format_RGBA64_Premultiplied   = 27
    Format_Grayscale16            = 28  ## 16 бит оттенки серого
    Format_BGR888                 = 29  ## 24 бита BGR
    Format_RGBX16FPx4             = 30  ## 64 бита (float16×4) Qt 6.2+
    Format_RGBA16FPx4             = 31  ## Qt 6.2+
    Format_RGBA16FPx4_Premultiplied = 32  ## Qt 6.2+
    Format_RGBX32FPx4             = 33  ## 128 бит (float32×4) Qt 6.2+
    Format_RGBA32FPx4             = 34  ## Qt 6.2+
    Format_RGBA32FPx4_Premultiplied = 35  ## Qt 6.2+
    Format_CMYK8888               = 36  ## 32 бита CMYK Qt 6.8+

# ── Qt::FontWeight ────────────────────────────────────────────────────────────
type
  QtFontWeight* {.size: sizeof(cint).} = enum
    Thin       = 100  ## Очень тонкий
    ExtraLight = 200  ## Сверхлёгкий
    Light      = 300  ## Лёгкий
    Normal     = 400  ## Обычный (Regular)
    Medium     = 500  ## Средний
    DemiBold   = 600  ## Полужирный
    Bold       = 700  ## Жирный
    ExtraBold  = 800  ## Очень жирный
    Black      = 900  ## Сверхжирный

# ── Qt::DateFormat ────────────────────────────────────────────────────────────
type
  QtDateFormat* {.size: sizeof(cint).} = enum
    ## Текстовый формат Qt (зависит от локали)
    TextDate      = 0
    ## ISO 8601: "yyyy-MM-dd" / "yyyy-MM-ddTHH:mm:ss"
    ISODate       = 1
    ## RFC 2822 (формат email)
    RFC2822Date   = 8
    ## ISO 8601 с миллисекундами: "yyyy-MM-ddTHH:mm:ss.zzz"
    ISODateWithMs = 9

# ── Qt::ScrollHint ────────────────────────────────────────────────────────────
type
  QtScrollHint* {.size: sizeof(cint).} = enum
    ## Элемент виден (минимальная прокрутка)
    EnsureVisible    = 0
    ## Элемент в начале viewport
    PositionAtTop    = 1
    ## Элемент в конце viewport
    PositionAtBottom = 2
    ## Элемент по центру viewport
    PositionAtCenter = 3

# ── Qt::MatchFlag ─────────────────────────────────────────────────────────────
type
  QtMatchFlag* {.size: sizeof(cint).} = enum
    ## Точное совпадение строки
    MatchExactly       = 0
    ## Подстрока (contains)
    MatchContains      = 1
    ## Начало строки
    MatchStartsWith    = 2
    ## Конец строки
    MatchEndsWith      = 3
    ## Регулярное выражение
    MatchRegularExpression = 4
    ## Шаблон с подстановочными знаками (*, ?)
    MatchWildcard      = 5
    ## Учитывать регистр
    MatchCaseSensitive = 16
    ## Рекурсивный поиск (модели с иерархией)
    MatchRecursive     = 32
    ## Поиск по всему (начинать с начала при достижении конца)
    MatchWrap          = 32

# ── Qt::FindChildOption ───────────────────────────────────────────────────────
type
  QtFindChildOption* {.size: sizeof(cint).} = enum
    ## Поиск только прямых потомков
    FindDirectChildrenOnly = 0
    ## Рекурсивный поиск (по умолчанию)
    FindChildrenRecursively = 1

# ── QStandardButton (для QMessageBox и QDialogButtonBox) ─────────────────────
type
  ## Стандартные кнопки Qt-диалогов
  QStandardButton* {.size: sizeof(cint).} = enum
    StdBtnNone           = 0x00000000
    StdBtnOk             = 0x00000400  ## OK
    StdBtnSave           = 0x00000800  ## Сохранить
    StdBtnSaveAll        = 0x00001000  ## Сохранить всё
    StdBtnOpen           = 0x00002000  ## Открыть
    StdBtnYes            = 0x00004000  ## Да
    StdBtnYesToAll       = 0x00008000  ## Да для всех
    StdBtnNo             = 0x00010000  ## Нет
    StdBtnNoToAll        = 0x00020000  ## Нет для всех
    StdBtnAbort          = 0x00040000  ## Прервать
    StdBtnRetry          = 0x00080000  ## Повторить
    StdBtnIgnore         = 0x00100000  ## Игнорировать
    StdBtnClose          = 0x00200000  ## Закрыть
    StdBtnCancel         = 0x00400000  ## Отмена
    StdBtnDiscard        = 0x00800000  ## Не сохранять
    StdBtnHelp           = 0x01000000  ## Справка
    StdBtnApply          = 0x02000000  ## Применить
    StdBtnReset          = 0x04000000  ## Сбросить
    StdBtnRestoreDefaults= 0x08000000  ## Восстановить

# ── QDialogButtonBox::ButtonRole ─────────────────────────────────────────────
type
  QDialogButtonRole* {.size: sizeof(cint).} = enum
    InvalidRole      = -1  ## Недопустимая роль
    AcceptRole       =  0  ## Принять (OK/Yes/Save)
    RejectRole       =  1  ## Отклонить (Cancel/No)
    DestructiveRole  =  2  ## Разрушительное действие (Discard)
    ActionRole       =  3  ## Произвольное действие
    HelpRole         =  4  ## Справка
    YesRole          =  5  ## Да (для вопросительных диалогов)
    NoRole           =  6  ## Нет
    ResetRole        =  7  ## Сброс настроек
    ApplyRole        =  8  ## Применить (без закрытия)

# ── Qt::TextInteractionFlag ───────────────────────────────────────────────────
type
  QtTextInteractionFlag* {.size: sizeof(cint).} = enum
    ## Текст недоступен для взаимодействия
    NoTextInteraction        = 0
    ## Выделение текста мышью
    TextSelectableByMouse    = 1
    ## Выделение текста клавиатурой
    TextSelectableByKeyboard = 2
    ## Ссылки можно активировать мышью
    LinksAccessibleByMouse   = 4
    ## Ссылки можно активировать клавиатурой
    LinksAccessibleByKeyboard= 8
    ## Текст доступен для редактирования
    TextEditable             = 16
    ## Только для чтения (SelectableByMouse | LinksAccessibleByMouse)
    TextEditorInteraction    = 19  ## Editable | SelectableByMouse | SelectableByKeyboard
    BrowserTextInteraction   = 13  ## SelectableByMouse | LinksAccessibleByMouse | LinksAccessibleByKeyboard

# ── Qt::DropAction ────────────────────────────────────────────────────────────
type
  QtDropAction* {.size: sizeof(cint).} = enum
    ## Копирование при drop
    CopyAction   = 0x1
    ## Перемещение при drop
    MoveAction   = 0x2
    ## Создание ссылки при drop
    LinkAction   = 0x4
    ## Действие определяется целевым виджетом
    ActionMask   = 0xff
    ## Drag игнорирован
    IgnoreAction = 0x0
    ## Несколько действий (OR-комбинация)
    TargetMoveAction = 0x8002

# ── Qt::Key (наиболее употребимые коды клавиш) ───────────────────────────────
type
  QtKey* {.size: sizeof(cint).} = enum
    Key_Escape    = 0x01000000  ## Esc
    Key_Tab       = 0x01000001  ## Tab
    Key_Backtab   = 0x01000002  ## Shift+Tab
    Key_Backspace = 0x01000003  ## Backspace
    Key_Return    = 0x01000004  ## Enter (основной)
    Key_Enter     = 0x01000005  ## Enter (цифровой блок)
    Key_Insert    = 0x01000006  ## Insert
    Key_Delete    = 0x01000007  ## Delete
    Key_Pause     = 0x01000008  ## Pause
    Key_Print     = 0x01000009  ## Print Screen
    Key_SysReq    = 0x0100000a  ## SysRq
    Key_Home      = 0x01000010  ## Home
    Key_End       = 0x01000011  ## End
    Key_Left      = 0x01000012  ## ←
    Key_Up        = 0x01000013  ## ↑
    Key_Right     = 0x01000014  ## →
    Key_Down      = 0x01000015  ## ↓
    Key_PageUp    = 0x01000016  ## Page Up
    Key_PageDown  = 0x01000017  ## Page Down
    Key_Shift     = 0x01000020  ## Shift
    Key_Control   = 0x01000021  ## Ctrl
    Key_Meta      = 0x01000022  ## Meta/Win
    Key_Alt       = 0x01000023  ## Alt
    Key_AltGr     = 0x01001103  ## AltGr
    Key_CapsLock  = 0x01000024  ## CapsLock
    Key_NumLock   = 0x01000025  ## NumLock
    Key_ScrollLock= 0x01000026  ## ScrollLock
    Key_F1        = 0x01000030  ## F1
    Key_F2        = 0x01000031
    Key_F3        = 0x01000032
    Key_F4        = 0x01000033
    Key_F5        = 0x01000034
    Key_F6        = 0x01000035
    Key_F7        = 0x01000036
    Key_F8        = 0x01000037
    Key_F9        = 0x01000038
    Key_F10       = 0x01000039
    Key_F11       = 0x0100003a
    Key_F12       = 0x0100003b
    Key_Space     = 0x20  ## Пробел
    Key_A         = 0x41  ## A (все буквы: 0x41–0x5a)
    Key_Z         = 0x5a  ## Z
    Key_0         = 0x30  ## 0 (цифры: 0x30–0x39)
    Key_9         = 0x39  ## 9

# ── QStandardPaths::StandardLocation ─────────────────────────────────────────
type
  QStandardPathLocation* {.size: sizeof(cint).} = enum
    ## Рабочий стол пользователя
    DesktopLocation      = 0
    ## Документы пользователя
    DocumentsLocation    = 1
    ## Системные шрифты
    FontsLocation        = 2
    ## Папка приложений
    ApplicationsLocation = 3
    ## Музыка пользователя
    MusicLocation        = 4
    ## Видео пользователя
    MoviesLocation       = 5
    ## Изображения пользователя
    PicturesLocation     = 6
    ## Временные файлы
    TempLocation         = 7
    ## Домашний каталог пользователя
    HomeLocation         = 8
    ## Локальные данные приложения (AppData/Local на Windows)
    AppLocalDataLocation = 9
    ## Кэш приложения
    CacheLocation        = 10
    ## Общие данные (не привязаны к приложению)
    GenericDataLocation  = 11
    ## Runtime-файлы (PID-файлы, сокеты)
    RuntimeLocation      = 12
    ## Конфигурационный каталог приложения
    ConfigLocation       = 13
    ## Загрузки пользователя
    DownloadLocation     = 14
    ## Общий кэш
    GenericCacheLocation = 15
    ## Общий конфигурационный каталог
    GenericConfigLocation= 16
    ## Конфигурация только этого приложения
    AppConfigLocation    = 17
    ## Публичная папка
    PublicShareLocation  = 18
    ## Папка шаблонов
    TemplatesLocation    = 19
    ## Состояние приложения (Qt 5.14+)
    StateLocation        = 20
    ## Общее состояние (Qt 5.14+)
    GenericStateLocation = 21

# ═══════════════════════════════════════════════════════════════════════════════
# § 4. Runtime версия Qt
# ═══════════════════════════════════════════════════════════════════════════════

proc qtVersionStr*(): string =
  ## Строка версии Qt во время выполнения, напр. "6.7.2".
  ## Может отличаться от версии при компиляции (если библиотека обновлена).
  var p: cstring
  {.emit: "`p` = qVersion();".}
  result = $p

proc qtVersionMajor*(): int =
  ## Мажорная версия Qt (всегда 6 для Qt6).
  var v: cint
  {.emit: "`v` = QT_VERSION_MAJOR;".}
  result = v.int

proc qtVersionMinor*(): int =
  ## Минорная версия Qt (напр. 7 для Qt 6.7).
  var v: cint
  {.emit: "`v` = QT_VERSION_MINOR;".}
  result = v.int

proc qtVersionPatch*(): int =
  ## Патч-версия Qt (напр. 2 для Qt 6.7.2).
  var v: cint
  {.emit: "`v` = QT_VERSION_PATCH;".}
  result = v.int

proc qtVersionCheck*(major, minor, patch: int): bool =
  ## Проверить, что версия Qt не ниже заданной.
  ## Пример: if qtVersionCheck(6, 5, 0): useNewApi()
  let ma = major.cint; let mi = minor.cint; let pa = patch.cint
  var r: cint
  {.emit: "`r` = (QT_VERSION >= QT_VERSION_CHECK(`ma`, `mi`, `pa`)) ? 1 : 0;".}
  result = r == 1

# ═══════════════════════════════════════════════════════════════════════════════
# § 5. Математические хелперы Qt
# ═══════════════════════════════════════════════════════════════════════════════

proc qFuzzyCompare*(a, b: float64): bool =
  ## Сравнить два вещественных числа с учётом погрешности float64.
  ## Безопаснее, чем a == b для float.
  var r: cint
  {.emit: "`r` = qFuzzyCompare(`a`, `b`) ? 1 : 0;".}
  result = r == 1

proc qFuzzyCompareF*(a, b: float32): bool =
  ## То же для float32.
  var r: cint
  {.emit: "`r` = qFuzzyCompare((float)`a`, (float)`b`) ? 1 : 0;".}
  result = r == 1

proc qFuzzyIsNull*(a: float64): bool =
  ## Проверить, близко ли значение к нулю (|a| < 1e-12).
  var r: cint
  {.emit: "`r` = qFuzzyIsNull(`a`) ? 1 : 0;".}
  result = r == 1

proc qRound*(a: float64): int =
  ## Округлить вещественное до ближайшего целого (0.5 → 1).
  var v: cint
  {.emit: "`v` = qRound(`a`);".}
  result = v.int

proc qRound64*(a: float64): int64 =
  ## Округлить вещественное до int64.
  var v: clonglong
  {.emit: "`v` = qRound64(`a`);".}
  result = v.int64

proc qAbs*(a: int): int =
  ## Абсолютное значение целого.
  let ai = a.cint; var v: cint
  {.emit: "`v` = qAbs(`ai`);".}
  result = v.int

proc qAbsF*(a: float64): float64 =
  ## Абсолютное значение вещественного.
  var v: cdouble
  {.emit: "`v` = qAbs(`a`);".}
  result = v.float64

proc qMax*(a, b: int): int =
  ## Максимум двух целых.
  let ai = a.cint; let bi = b.cint; var v: cint
  {.emit: "`v` = qMax(`ai`, `bi`);".}
  result = v.int

proc qMin*(a, b: int): int =
  ## Минимум двух целых.
  let ai = a.cint; let bi = b.cint; var v: cint
  {.emit: "`v` = qMin(`ai`, `bi`);".}
  result = v.int

proc qMaxF*(a, b: float64): float64 =
  ## Максимум двух вещественных.
  var v: cdouble
  {.emit: "`v` = qMax(`a`, `b`);".}
  result = v.float64

proc qMinF*(a, b: float64): float64 =
  ## Минимум двух вещественных.
  var v: cdouble
  {.emit: "`v` = qMin(`a`, `b`);".}
  result = v.float64

proc qBound*(lo, v, hi: int): int =
  ## Ограничить значение v диапазоном [lo, hi].
  let li = lo.cint; let vi = v.cint; let hi2 = hi.cint; var r: cint
  {.emit: "`r` = qBound(`li`, `vi`, `hi2`);".}
  result = r.int

proc qBoundF*(lo, v, hi: float64): float64 =
  ## Ограничить вещественное значение диапазоном [lo, hi].
  var r: cdouble
  {.emit: "`r` = qBound(`lo`, `v`, `hi`);".}
  result = r.float64

proc qDegreesToRadians*(degrees: float64): float64 =
  ## Конвертировать градусы в радианы.
  var r: cdouble
  {.emit: "`r` = qDegreesToRadians(`degrees`);".}
  result = r.float64

proc qRadiansToDegrees*(radians: float64): float64 =
  ## Конвертировать радианы в градусы.
  var r: cdouble
  {.emit: "`r` = qRadiansToDegrees(`radians`);".}
  result = r.float64

proc qNextPowerOfTwo*(n: uint32): uint32 =
  ## Следующая степень двойки, >= n.
  var r: cuint
  {.emit: "`r` = qNextPowerOfTwo(`n`);".}
  result = r.uint32

# ═══════════════════════════════════════════════════════════════════════════════
# § 6. Системная информация (QSysInfo)
# ═══════════════════════════════════════════════════════════════════════════════

proc sysProductName*(): string =
  ## Человекочитаемое название ОС. Примеры:
  ## "Windows 11 Version 23H2", "Ubuntu 22.04.3 LTS", "macOS 14.0"
  var p: cstring
  {.emit: """
    static QByteArray _sPN;
    _sPN = QSysInfo::prettyProductName().toUtf8();
    `p` = _sPN.constData();
  """.}
  result = $p

proc sysProductType*(): string =
  ## Краткий тип ОС: "windows", "macos", "ubuntu", "arch", …
  var p: cstring
  {.emit: """
    static QByteArray _sPT;
    _sPT = QSysInfo::productType().toUtf8();
    `p` = _sPT.constData();
  """.}
  result = $p

proc sysProductVersion*(): string =
  ## Версия ОС: "11", "22.04", "14.0", …
  var p: cstring
  {.emit: """
    static QByteArray _sPV;
    _sPV = QSysInfo::productVersion().toUtf8();
    `p` = _sPV.constData();
  """.}
  result = $p

proc sysCpuArch*(): string =
  ## Архитектура CPU: "x86_64", "arm64", "i386", …
  var p: cstring
  {.emit: """
    static QByteArray _sCA;
    _sCA = QSysInfo::currentCpuArchitecture().toUtf8();
    `p` = _sCA.constData();
  """.}
  result = $p

proc sysBuildCpuArch*(): string =
  ## Архитектура CPU, для которой собрана Qt.
  var p: cstring
  {.emit: """
    static QByteArray _sBCA;
    _sBCA = QSysInfo::buildCpuArchitecture().toUtf8();
    `p` = _sBCA.constData();
  """.}
  result = $p

proc sysKernelType*(): string =
  ## Тип ядра: "winnt", "linux", "darwin", …
  var p: cstring
  {.emit: """
    static QByteArray _sKT;
    _sKT = QSysInfo::kernelType().toUtf8();
    `p` = _sKT.constData();
  """.}
  result = $p

proc sysKernelVersion*(): string =
  ## Версия ядра ОС: "10.0.22621", "6.1.0-18-amd64", …
  var p: cstring
  {.emit: """
    static QByteArray _sKV;
    _sKV = QSysInfo::kernelVersion().toUtf8();
    `p` = _sKV.constData();
  """.}
  result = $p

proc sysMachineHostName*(): string =
  ## Имя хоста компьютера (hostname).
  var p: cstring
  {.emit: """
    static QByteArray _sMHN;
    _sMHN = QSysInfo::machineHostName().toUtf8();
    `p` = _sMHN.constData();
  """.}
  result = $p

proc sysMachineUniqueId*(): string =
  ## Уникальный идентификатор машины (UUID, если доступен).
  var p: cstring
  {.emit: """
    static QByteArray _sMUI;
    _sMUI = QSysInfo::machineUniqueId();
    `p` = _sMUI.constData();
  """.}
  result = $p

proc sysBootUniqueId*(): string =
  ## Идентификатор текущей сессии загрузки (меняется при каждой загрузке).
  var p: cstring
  {.emit: """
    static QByteArray _sBUI;
    _sBUI = QSysInfo::bootUniqueId();
    `p` = _sBUI.constData();
  """.}
  result = $p

# ── Структура с полной системной информацией ─────────────────────────────────
type
  SysInfo* = object
    ## Полная информация о системе (собирается одним вызовом)
    productName*:    string  ## Полное название ОС
    productType*:    string  ## Тип ОС (windows/linux/macos/…)
    productVersion*: string  ## Версия ОС
    cpuArch*:        string  ## Архитектура CPU
    kernelType*:     string  ## Тип ядра
    kernelVersion*:  string  ## Версия ядра
    hostName*:       string  ## Имя хоста
    qtVersion*:      string  ## Версия Qt runtime

proc getSysInfo*(): SysInfo =
  ## Собрать всю системную информацию за один вызов.
  result = SysInfo(
    productName:    sysProductName(),
    productType:    sysProductType(),
    productVersion: sysProductVersion(),
    cpuArch:        sysCpuArch(),
    kernelType:     sysKernelType(),
    kernelVersion:  sysKernelVersion(),
    hostName:       sysMachineHostName(),
    qtVersion:      qtVersionStr()
  )

# ═══════════════════════════════════════════════════════════════════════════════
# § 7. QStandardPaths — стандартные пути ОС
# ═══════════════════════════════════════════════════════════════════════════════

proc standardPath*(loc: QStandardPathLocation): string =
  ## Получить один записываемый путь для указанного типа.
  ## Пример: standardPath(DocumentsLocation) → "/home/user/Documents"
  let l = loc.cint
  var p: cstring
  {.emit: """
    QByteArray _sp =
      QStandardPaths::writableLocation((QStandardPaths::StandardLocation)`l`).toUtf8();
    `p` = _sp.constData();
  """.}
  # Копируем до освобождения QByteArray
  result = $p

proc standardPaths*(loc: QStandardPathLocation): seq[string] =
  ## Получить все пути для указанного типа (включая системные).
  let l = loc.cint
  var n: cint
  {.emit: """
    static QStringList _sPaths;
    _sPaths = QStandardPaths::standardLocations((QStandardPaths::StandardLocation)`l`);
    `n` = _sPaths.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint
    var p: cstring
    {.emit: """
      QByteArray _spi = _sPaths.at(`idx`).toUtf8();
      `p` = _spi.constData();
    """.}
    result[i] = $p

proc standardPathsFind*(loc: QStandardPathLocation,
                        filename: string): string =
  ## Найти файл в стандартных путях. Возвращает "" если не найден.
  let l = loc.cint; let cs = filename.cstring
  var p: cstring
  {.emit: """
    QByteArray _sFnd = QStandardPaths::locate(
      (QStandardPaths::StandardLocation)`l`,
      QString::fromUtf8(`cs`)).toUtf8();
    `p` = _sFnd.constData();
  """.}
  result = $p

proc displayName*(loc: QStandardPathLocation): string =
  ## Человекочитаемое название типа пути (локализованное).
  let l = loc.cint
  var p: cstring
  {.emit: """
    QByteArray _sDN = QStandardPaths::displayName(
      (QStandardPaths::StandardLocation)`l`).toUtf8();
    `p` = _sDN.constData();
  """.}
  result = $p

# ═══════════════════════════════════════════════════════════════════════════════
# § 8. Переменные окружения (QProcessEnvironment)
# ═══════════════════════════════════════════════════════════════════════════════

proc envValue*(key: string, default: string = ""): string =
  ## Получить значение переменной окружения.
  ## Пример: envValue("HOME") → "/home/user"
  let cs = key.cstring; let ds = default.cstring
  var p: cstring
  {.emit: """
    QByteArray _eV = QProcessEnvironment::systemEnvironment()
      .value(QString::fromUtf8(`cs`), QString::fromUtf8(`ds`)).toUtf8();
    `p` = _eV.constData();
  """.}
  result = $p

proc envContains*(key: string): bool =
  ## Проверить существование переменной окружения.
  let cs = key.cstring
  var r: cint
  {.emit: """
    `r` = QProcessEnvironment::systemEnvironment()
      .contains(QString::fromUtf8(`cs`)) ? 1 : 0;
  """.}
  result = r == 1

proc envKeys*(): seq[string] =
  ## Получить все имена переменных окружения.
  var n: cint
  {.emit: """
    static QStringList _eKeys =
      QProcessEnvironment::systemEnvironment().keys();
    `n` = _eKeys.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint
    var p: cstring
    {.emit: """
      QByteArray _eKi = _eKeys.at(`idx`).toUtf8();
      `p` = _eKi.constData();
    """.}
    result[i] = $p

# ═══════════════════════════════════════════════════════════════════════════════
# § 9. Файловая система (быстрые хелперы без создания объектов)
# ═══════════════════════════════════════════════════════════════════════════════

proc dirExists*(path: string): bool =
  ## Проверить, существует ли директория.
  let cs = path.cstring
  var r: cint
  {.emit: "`r` = QDir(QString::fromUtf8(`cs`)).exists() ? 1 : 0;".}
  result = r == 1

proc fileExists*(path: string): bool =
  ## Проверить, существует ли файл.
  let cs = path.cstring
  var r: cint
  {.emit: "`r` = QFile::exists(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc mkPath*(path: string): bool =
  ## Создать все отсутствующие директории в пути (аналог mkdir -p).
  let cs = path.cstring
  var r: cint
  {.emit: "`r` = QDir().mkpath(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc fileSize*(path: string): int64 =
  ## Получить размер файла в байтах. -1 если файл не существует.
  let cs = path.cstring
  var v: clonglong
  {.emit: "`v` = QFileInfo(QString::fromUtf8(`cs`)).size();".}
  result = v.int64

proc fileSuffix*(path: string): string =
  ## Расширение файла без точки. Пример: "image.tar.gz" → "gz"
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _fSuf = QFileInfo(QString::fromUtf8(`cs`)).suffix().toUtf8();
    `p` = _fSuf.constData();
  """.}
  result = $p

proc fileCompleteSuffix*(path: string): string =
  ## Полное расширение. Пример: "image.tar.gz" → "tar.gz"
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _fCS = QFileInfo(QString::fromUtf8(`cs`)).completeSuffix().toUtf8();
    `p` = _fCS.constData();
  """.}
  result = $p

proc fileBaseName*(path: string): string =
  ## Базовое имя файла без расширения. Пример: "/home/user/doc.tar.gz" → "doc"
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _fBN = QFileInfo(QString::fromUtf8(`cs`)).baseName().toUtf8();
    `p` = _fBN.constData();
  """.}
  result = $p

proc fileCompleteBaseName*(path: string): string =
  ## Полное базовое имя. Пример: "doc.tar.gz" → "doc.tar"
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _fCBN = QFileInfo(QString::fromUtf8(`cs`)).completeBaseName().toUtf8();
    `p` = _fCBN.constData();
  """.}
  result = $p

proc fileName*(path: string): string =
  ## Только имя файла (с расширением). Пример: "/home/user/doc.txt" → "doc.txt"
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _fN = QFileInfo(QString::fromUtf8(`cs`)).fileName().toUtf8();
    `p` = _fN.constData();
  """.}
  result = $p

proc dirName*(path: string): string =
  ## Директория файла. Пример: "/home/user/doc.txt" → "/home/user"
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _dN = QFileInfo(QString::fromUtf8(`cs`)).dir().path().toUtf8();
    `p` = _dN.constData();
  """.}
  result = $p

proc absPath*(path: string): string =
  ## Абсолютный путь (разрешает ".." и ".").
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _aP = QFileInfo(QString::fromUtf8(`cs`)).absoluteFilePath().toUtf8();
    `p` = _aP.constData();
  """.}
  result = $p

proc canonicalPath*(path: string): string =
  ## Канонический путь (разрешает символические ссылки).
  ## Возвращает "" если файл не существует.
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _cP = QFileInfo(QString::fromUtf8(`cs`)).canonicalFilePath().toUtf8();
    `p` = _cP.constData();
  """.}
  result = $p

proc isAbsPath*(path: string): bool =
  ## Проверить, является ли путь абсолютным.
  let cs = path.cstring
  var r: cint
  {.emit: "`r` = QFileInfo(QString::fromUtf8(`cs`)).isAbsolute() ? 1 : 0;".}
  result = r == 1

proc joinPath*(parts: varargs[string]): string =
  ## Объединить части пути через разделитель ОС.
  if parts.len == 0: return ""
  result = parts[0]
  for i in 1 ..< parts.len:
    let cs = result.cstring; let p2 = parts[i].cstring
    var r: cstring
    {.emit: """
      QByteArray _jP = (QDir(QString::fromUtf8(`cs`))
        .filePath(QString::fromUtf8(`p2`))).toUtf8();
      `r` = _jP.constData();
    """.}
    result = $r

proc pathSeparator*(): char =
  ## Системный разделитель путей ('/' или '\').
  var c: char
  {.emit: "`c` = QDir::separator().toLatin1();".}
  result = c

proc cleanPath*(path: string): string =
  ## Нормализовать путь (убрать "//", "..", "./").
  let cs = path.cstring
  var p: cstring
  {.emit: """
    QByteArray _clP = QDir::cleanPath(QString::fromUtf8(`cs`)).toUtf8();
    `p` = _clP.constData();
  """.}
  result = $p

# ═══════════════════════════════════════════════════════════════════════════════
# § 10. Загрузка динамических библиотек
# ═══════════════════════════════════════════════════════════════════════════════

proc qtLibIsLoaded*(libName: string): bool =
  ## Попытаться загрузить динамическую библиотеку и проверить успех.
  ## Пример: if qtLibIsLoaded(libQt6WebEngineCore): enableWebSupport()
  let cs = libName.cstring
  var r: cint
  {.emit: """
    QLibrary _qLib(QString::fromUtf8(`cs`));
    `r` = _qLib.load() ? 1 : 0;
  """.}
  result = r == 1

proc qtLibVersion*(libName: string): string =
  ## Получить версию загруженной библиотеки (если поддерживается).
  let cs = libName.cstring
  var p: cstring
  {.emit: """
    QLibrary _qLibV(QString::fromUtf8(`cs`));
    _qLibV.load();
    QByteArray _qLibVS = _qLibV.fileName().toUtf8();
    `p` = _qLibVS.constData();
  """.}
  result = $p

# ═══════════════════════════════════════════════════════════════════════════════
# § 11. Debug / logging
# ═══════════════════════════════════════════════════════════════════════════════

proc qDebug*(msg: string) =
  ## Вывести отладочное сообщение (видно в Qt Creator, journald и т.п.).
  let cs = msg.cstring
  {.emit: "qDebug().noquote() << QString::fromUtf8(`cs`);".}

proc qInfo*(msg: string) =
  ## Вывести информационное сообщение.
  let cs = msg.cstring
  {.emit: "qInfo().noquote() << QString::fromUtf8(`cs`);".}

proc qWarning*(msg: string) =
  ## Вывести предупреждение.
  let cs = msg.cstring
  {.emit: "qWarning().noquote() << QString::fromUtf8(`cs`);".}

proc qCritical*(msg: string) =
  ## Вывести критическую ошибку.
  let cs = msg.cstring
  {.emit: "qCritical().noquote() << QString::fromUtf8(`cs`);".}

proc qFatalMsg*(msg: string) =
  ## Вывести фатальную ошибку и завершить приложение.
  ## ВНИМАНИЕ: вызов завершает процесс.
  let cs = msg.cstring
  {.emit: "qFatal(\"%s\", `cs`);".}

proc qSetMessagePattern*(pattern: string) =
  ## Установить формат вывода сообщений Qt.
  ## Пример: "%{time yyyy-MM-dd HH:mm:ss} [%{type}] %{message}"
  ## Переменные: %{appname}, %{category}, %{file}, %{function},
  ##             %{line}, %{message}, %{pid}, %{threadid}, %{time}
  let cs = pattern.cstring
  {.emit: "qSetMessagePattern(QString::fromUtf8(`cs`));".}

proc qSetLoggingRule*(rule: string) =
  ## Установить правила фильтрации категорий логов.
  ## Пример: "*.debug=false\napp.network=true"
  let cs = rule.cstring
  {.emit: "QLoggingCategory::setFilterRules(QString::fromUtf8(`cs`));".}

proc qSuppressMessages*() =
  ## Подавить весь вывод Qt (для unit-тестов, release-сборок).
  {.emit: """
    qInstallMessageHandler([](QtMsgType, const QMessageLogContext&, const QString&){});
  """.}

proc qRestoreMessages*() =
  ## Восстановить стандартный обработчик сообщений Qt.
  {.emit: "qInstallMessageHandler(nullptr);".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 12. QVersionNumber (Qt 6.x)
# ═══════════════════════════════════════════════════════════════════════════════

proc parseVersion*(versionStr: string): tuple[major, minor, patch: int] =
  ## Разобрать строку версии "X.Y.Z" в компоненты.
  let cs = versionStr.cstring
  var ma, mi, pa: cint
  {.emit: """
    QString _vs = QString::fromUtf8(`cs`);
    int _suf;
    QVersionNumber _vn = QVersionNumber::fromString(_vs, &_suf);
    `ma` = _vn.majorVersion();
    `mi` = _vn.minorVersion();
    `pa` = _vn.microVersion();
  """.}
  result = (ma.int, mi.int, pa.int)

proc compareVersions*(a, b: string): int =
  ## Сравнить две строки версий.
  ## Возвращает: -1 если a < b, 0 если a == b, 1 если a > b
  let ca = a.cstring; let cb = b.cstring
  var r: cint
  {.emit: """
    QVersionNumber _va = QVersionNumber::fromString(QString::fromUtf8(`ca`));
    QVersionNumber _vb = QVersionNumber::fromString(QString::fromUtf8(`cb`));
    `r` = QVersionNumber::compare(_va, _vb);
    if (`r` < 0) `r` = -1;
    else if (`r` > 0) `r` = 1;
  """.}
  result = r.int

# ═══════════════════════════════════════════════════════════════════════════════
# § 13. Compile-time константы и утилиты
# ═══════════════════════════════════════════════════════════════════════════════

const
  ## Qt6 требует C++17 минимум, рекомендуется C++20
  QtMinCppStandard* = 17

  ## Рекомендуемый стандарт C++ для Qt6 (для --passC:"-std=c++20")
  QtRecommendedCppStandard* = 20

when defined(windows):
  ## Признак сборки на Windows
  const QtPlatformWindows* = true
  const QtPlatformLinux*   = false
  const QtPlatformMacos*   = false
elif defined(macosx):
  const QtPlatformWindows* = false
  const QtPlatformLinux*   = false
  const QtPlatformMacos*   = true
else:
  const QtPlatformWindows* = false
  const QtPlatformLinux*   = true
  const QtPlatformMacos*   = false

## ── Конец nimQtFFI.nim ───────────────────────────────────────────────────────
