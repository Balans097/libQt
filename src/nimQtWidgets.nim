## nimQtWidgets.nim — Полная обёртка Qt6Widgets для Nim (nim cpp --passC:"-std=c++20")
##
## Включает:
##   QApplication, QMainWindow, QWidget, QDialog,
##   QAbstractButton, QPushButton, QToolButton, QRadioButton, QCheckBox,
##   QCommandLinkButton,
##   QAbstractItemView, QListView, QTreeView, QTableView,
##   QListWidget, QListWidgetItem, QTreeWidget, QTreeWidgetItem,
##   QTableWidget, QTableWidgetItem,
##   QAbstractScrollArea, QScrollArea,
##   QPlainTextEdit, QTextEdit, QTextBrowser,
##   QLineEdit, QTextEdit,
##   QSpinBox, QDoubleSpinBox, QTimeEdit, QDateEdit, QDateTimeEdit,
##   QDial, QSlider, QScrollBar, QProgressBar,
##   QComboBox, QFontComboBox,
##   QLabel, QLCDNumber,
##   QGroupBox, QFrame, QStackedWidget, QTabWidget, QTabBar,
##   QSplitter, QSplitterHandle,
##   QDockWidget, QMdiArea, QMdiSubWindow,
##   QMenu, QMenuBar, QAction, QActionGroup, QToolBar, QStatusBar,
##   QSizeGrip, QRubberBand,
##   Layouts: QLayout, QBoxLayout, QVBoxLayout, QHBoxLayout,
##             QGridLayout, QFormLayout, QStackedLayout,
##             QSpacerItem, QWidgetItem,
##   QAbstractItemDelegate, QStyledItemDelegate, QItemDelegate,
##   QStyle, QStyleOption, QStyleFactory,
##   QApplication extras: font, palette, style, screen,
##   QSystemTrayIcon, QCompleter,
##   QButtonGroup, QShortcut,
##   QSizePolicy,
##   QCalendarWidget, QWizard, QWizardPage
##
## Зависимости: nimQtUtils, nimQtFFI

{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}


import nimQtUtils
import nimQtFFI
import strutils

{.emit: """
#include <QApplication>
#include <QMainWindow>
#include <QWidget>
#include <QDialog>
#include <QAbstractButton>
#include <QPushButton>
#include <QToolButton>
#include <QRadioButton>
#include <QCheckBox>
#include <QCommandLinkButton>
#include <QAbstractItemView>
#include <QListView>
#include <QTreeView>
#include <QTableView>
#include <QHeaderView>
#include <QListWidget>
#include <QListWidgetItem>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QAbstractScrollArea>
#include <QScrollArea>
#include <QPlainTextEdit>
#include <QTextEdit>
#include <QTextBrowser>
#include <QLineEdit>
#include <QSpinBox>
#include <QDoubleSpinBox>
#include <QTimeEdit>
#include <QDateEdit>
#include <QDateTimeEdit>
#include <QDial>
#include <QSlider>
#include <QScrollBar>
#include <QProgressBar>
#include <QComboBox>
#include <QFontComboBox>
#include <QLabel>
#include <QLCDNumber>
#include <QGroupBox>
#include <QFrame>
#include <QStackedWidget>
#include <QTabWidget>
#include <QTabBar>
#include <QSplitter>
#include <QDockWidget>
#include <QMdiArea>
#include <QMdiSubWindow>
#include <QMenu>
#include <QMenuBar>
#include <QAction>
#include <QActionGroup>
#include <QToolBar>
#include <QStatusBar>
#include <QSizeGrip>
#include <QRubberBand>
#include <QLayout>
#include <QBoxLayout>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QFormLayout>
#include <QStackedLayout>
#include <QSpacerItem>
#include <QWidgetItem>
#include <QAbstractItemDelegate>
#include <QStyledItemDelegate>
#include <QItemDelegate>
#include <QStyle>
#include <QStyleOption>
#include <QStyleFactory>
#include <QSystemTrayIcon>
#include <QCompleter>
#include <QButtonGroup>
#include <QShortcut>
#include <QKeySequence>
#include <QSizePolicy>
#include <QCalendarWidget>
#include <QWizard>
#include <QWizardPage>
#include <QScreen>
#include <QFontDatabase>
#include <QPalette>
#include <QFont>
#include <QIcon>
#include <QPixmap>
#include <QCursor>
#include <QToolTip>
#include <QWhatsThis>
#include <QInputMethod>
#include <QAbstractItemModel>
#include <QStandardItemModel>
#include <QStandardItem>
#include <QStringListModel>
#include <QSortFilterProxyModel>
#include <QItemSelectionModel>
#include <QItemSelection>
#include <QModelIndex>
#include <functional>
#include <cstring>

// Синглтон QApplication
static int   _nim_wgt_argc = 0;
static char* _nim_wgt_argv[] = {nullptr};
static QApplication* _nim_wgt_app = nullptr;
""".}

# ═══════════════════════════════════════════════════════════════════════════════
# Opaque типы — Widgets
# ═══════════════════════════════════════════════════════════════════════════════
type
  QApplication*        {.importcpp: "QApplication",        header: "<QApplication>".}        = object
  QMainWindow*         {.importcpp: "QMainWindow",         header: "<QMainWindow>".}         = object
  QWidget*             {.importcpp: "QWidget",             header: "<QWidget>".}             = object
  QDialog*             {.importcpp: "QDialog",             header: "<QDialog>".}             = object
  QAbstractButton*     {.importcpp: "QAbstractButton",     header: "<QAbstractButton>".}     = object
  QPushButton*         {.importcpp: "QPushButton",         header: "<QPushButton>".}         = object
  QToolButton*         {.importcpp: "QToolButton",         header: "<QToolButton>".}         = object
  QRadioButton*        {.importcpp: "QRadioButton",        header: "<QRadioButton>".}        = object
  QCheckBox*           {.importcpp: "QCheckBox",           header: "<QCheckBox>".}           = object
  QCommandLinkButton*  {.importcpp: "QCommandLinkButton",  header: "<QCommandLinkButton>".}  = object
  QAbstractItemView*   {.importcpp: "QAbstractItemView",   header: "<QAbstractItemView>".}   = object
  QListView*           {.importcpp: "QListView",           header: "<QListView>".}           = object
  QTreeView*           {.importcpp: "QTreeView",           header: "<QTreeView>".}           = object
  QTableView*          {.importcpp: "QTableView",          header: "<QTableView>".}          = object
  QHeaderView*         {.importcpp: "QHeaderView",         header: "<QHeaderView>".}         = object
  QListWidget*         {.importcpp: "QListWidget",         header: "<QListWidget>".}         = object
  QListWidgetItem*     {.importcpp: "QListWidgetItem",     header: "<QListWidget>".}         = object
  QTreeWidget*         {.importcpp: "QTreeWidget",         header: "<QTreeWidget>".}         = object
  QTreeWidgetItem*     {.importcpp: "QTreeWidgetItem",     header: "<QTreeWidget>".}         = object
  QTableWidget*        {.importcpp: "QTableWidget",        header: "<QTableWidget>".}        = object
  QTableWidgetItem*    {.importcpp: "QTableWidgetItem",    header: "<QTableWidget>".}        = object
  QAbstractScrollArea* {.importcpp: "QAbstractScrollArea", header: "<QAbstractScrollArea>".} = object
  QScrollArea*         {.importcpp: "QScrollArea",         header: "<QScrollArea>".}         = object
  QPlainTextEdit*      {.importcpp: "QPlainTextEdit",      header: "<QPlainTextEdit>".}      = object
  QTextEdit*           {.importcpp: "QTextEdit",           header: "<QTextEdit>".}           = object
  QTextBrowser*        {.importcpp: "QTextBrowser",        header: "<QTextBrowser>".}        = object
  QLineEdit*           {.importcpp: "QLineEdit",           header: "<QLineEdit>".}           = object
  QSpinBox*            {.importcpp: "QSpinBox",            header: "<QSpinBox>".}            = object
  QDoubleSpinBox*      {.importcpp: "QDoubleSpinBox",      header: "<QDoubleSpinBox>".}      = object
  QTimeEdit*           {.importcpp: "QTimeEdit",           header: "<QTimeEdit>".}           = object
  QDateEdit*           {.importcpp: "QDateEdit",           header: "<QDateEdit>".}           = object
  QDateTimeEdit*       {.importcpp: "QDateTimeEdit",       header: "<QDateTimeEdit>".}       = object
  QDial*               {.importcpp: "QDial",               header: "<QDial>".}               = object
  QSlider*             {.importcpp: "QSlider",             header: "<QSlider>".}             = object
  QScrollBar*          {.importcpp: "QScrollBar",          header: "<QScrollBar>".}          = object
  QProgressBar*        {.importcpp: "QProgressBar",        header: "<QProgressBar>".}        = object
  QComboBox*           {.importcpp: "QComboBox",           header: "<QComboBox>".}           = object
  QFontComboBox*       {.importcpp: "QFontComboBox",       header: "<QFontComboBox>".}       = object
  QLabel*              {.importcpp: "QLabel",              header: "<QLabel>".}              = object
  QLCDNumber*          {.importcpp: "QLCDNumber",          header: "<QLCDNumber>".}          = object
  QGroupBox*           {.importcpp: "QGroupBox",           header: "<QGroupBox>".}           = object
  QFrame*              {.importcpp: "QFrame",              header: "<QFrame>".}              = object
  QStackedWidget*      {.importcpp: "QStackedWidget",      header: "<QStackedWidget>".}      = object
  QTabWidget*          {.importcpp: "QTabWidget",          header: "<QTabWidget>".}          = object
  QTabBar*             {.importcpp: "QTabBar",             header: "<QTabBar>".}             = object
  QSplitter*           {.importcpp: "QSplitter",          header: "<QSplitter>".}           = object
  QDockWidget*         {.importcpp: "QDockWidget",         header: "<QDockWidget>".}         = object
  QMdiArea*            {.importcpp: "QMdiArea",            header: "<QMdiArea>".}            = object
  QMdiSubWindow*       {.importcpp: "QMdiSubWindow",       header: "<QMdiSubWindow>".}       = object
  QMenu*               {.importcpp: "QMenu",               header: "<QMenu>".}               = object
  QMenuBar*            {.importcpp: "QMenuBar",            header: "<QMenuBar>".}            = object
  QAction*             {.importcpp: "QAction",             header: "<QAction>".}             = object
  QActionGroup*        {.importcpp: "QActionGroup",        header: "<QActionGroup>".}        = object
  QToolBar*            {.importcpp: "QToolBar",            header: "<QToolBar>".}            = object
  QStatusBar*          {.importcpp: "QStatusBar",          header: "<QStatusBar>".}          = object
  QSizeGrip*           {.importcpp: "QSizeGrip",           header: "<QSizeGrip>".}           = object
  QRubberBand*         {.importcpp: "QRubberBand",         header: "<QRubberBand>".}         = object
  QLayout*             {.importcpp: "QLayout",             header: "<QLayout>".}             = object
  QBoxLayout*          {.importcpp: "QBoxLayout",          header: "<QBoxLayout>".}          = object
  QVBoxLayout*         {.importcpp: "QVBoxLayout",         header: "<QVBoxLayout>".}         = object
  QHBoxLayout*         {.importcpp: "QHBoxLayout",         header: "<QHBoxLayout>".}         = object
  QGridLayout*         {.importcpp: "QGridLayout",         header: "<QGridLayout>".}         = object
  QFormLayout*         {.importcpp: "QFormLayout",         header: "<QFormLayout>".}         = object
  QStackedLayout*      {.importcpp: "QStackedLayout",      header: "<QStackedLayout>".}      = object
  QSpacerItem*         {.importcpp: "QSpacerItem",         header: "<QSpacerItem>".}         = object
  QAbstractItemDelegate*  {.importcpp: "QAbstractItemDelegate",  header: "<QAbstractItemDelegate>".}  = object
  QStyledItemDelegate* {.importcpp: "QStyledItemDelegate", header: "<QStyledItemDelegate>".} = object
  QStyle*              {.importcpp: "QStyle",              header: "<QStyle>".}              = object
  QSystemTrayIcon*     {.importcpp: "QSystemTrayIcon",     header: "<QSystemTrayIcon>".}     = object
  QCompleter*          {.importcpp: "QCompleter",          header: "<QCompleter>".}          = object
  QButtonGroup*        {.importcpp: "QButtonGroup",        header: "<QButtonGroup>".}        = object
  QShortcut*           {.importcpp: "QShortcut",           header: "<QShortcut>".}           = object
  QCalendarWidget*     {.importcpp: "QCalendarWidget",     header: "<QCalendarWidget>".}     = object
  QWizard*             {.importcpp: "QWizard",             header: "<QWizard>".}             = object
  QWizardPage*         {.importcpp: "QWizardPage",         header: "<QWizardPage>".}         = object
  QStandardItemModel*  {.importcpp: "QStandardItemModel",  header: "<QStandardItemModel>".}  = object
  QStandardItem*       {.importcpp: "QStandardItem",       header: "<QStandardItem>".}       = object
  QStringListModel*    {.importcpp: "QStringListModel",    header: "<QStringListModel>".}    = object
  QItemSelectionModel* {.importcpp: "QItemSelectionModel", header: "<QItemSelectionModel>".} = object
  QAbstractItemModel*  {.importcpp: "QAbstractItemModel",  header: "<QAbstractItemModel>".}  = object
  QSortFilterProxyModel* {.importcpp: "QSortFilterProxyModel", header: "<QSortFilterProxyModel>".} = object
  QModelIndex*         {.importcpp: "QModelIndex",         header: "<QAbstractItemModel>".}  = object

# ── Короткие псевдонимы указателей ─────────────────────────────────────────
type
  App*     = ptr QApplication
  Win*     = ptr QMainWindow
  W*       = ptr QWidget
  Dlg*     = ptr QDialog
  Btn*     = ptr QPushButton
  TBtn*    = ptr QToolButton
  Radio*   = ptr QRadioButton
  ChkBox*  = ptr QCheckBox
  CmdBtn*  = ptr QCommandLinkButton
  AbsView* = ptr QAbstractItemView
  LstView* = ptr QListView
  TreView* = ptr QTreeView
  TblView* = ptr QTableView
  HdrView* = ptr QHeaderView
  LW*      = ptr QListWidget
  LWI*     = ptr QListWidgetItem
  TW*      = ptr QTreeWidget
  TWI*     = ptr QTreeWidgetItem
  TblW*    = ptr QTableWidget
  TblWI*   = ptr QTableWidgetItem
  Scroll*  = ptr QScrollArea
  PTE*     = ptr QPlainTextEdit
  TE*      = ptr QTextEdit
  TBrw*    = ptr QTextBrowser
  LE*      = ptr QLineEdit
  Spin*    = ptr QSpinBox
  DSpin*   = ptr QDoubleSpinBox
  TmEdit*  = ptr QTimeEdit
  DtEdit*  = ptr QDateEdit
  DtTmEdit* = ptr QDateTimeEdit
  Dial*    = ptr QDial
  Slider*  = ptr QSlider
  SBar*    = ptr QScrollBar
  Prog*    = ptr QProgressBar
  Combo*   = ptr QComboBox
  FCombo*  = ptr QFontComboBox
  Lbl*     = ptr QLabel
  LCD*     = ptr QLCDNumber
  Grp*     = ptr QGroupBox
  Frm*     = ptr QFrame
  Stack*   = ptr QStackedWidget
  Tab*     = ptr QTabWidget
  TabBar*  = ptr QTabBar
  Splt*    = ptr QSplitter
  Dock*    = ptr QDockWidget
  Mdi*     = ptr QMdiArea
  MdiSub*  = ptr QMdiSubWindow
  Menu*    = ptr QMenu
  MBar*    = ptr QMenuBar
  Act*     = ptr QAction
  ActGrp*  = ptr QActionGroup
  TB*      = ptr QToolBar
  StatusBar* = ptr QStatusBar
  VBox*    = ptr QVBoxLayout
  HBox*    = ptr QHBoxLayout
  Grid*    = ptr QGridLayout
  Form*    = ptr QFormLayout
  StkLyt*  = ptr QStackedLayout
  Tray*    = ptr QSystemTrayIcon
  Compltr* = ptr QCompleter
  BtnGrp*  = ptr QButtonGroup
  Shortcut* = ptr QShortcut
  Calendar* = ptr QCalendarWidget
  Wizard*  = ptr QWizard
  WizPage* = ptr QWizardPage
  SIM*     = ptr QStandardItemModel
  SI*      = ptr QStandardItem
  SLM*     = ptr QStringListModel
  ISM*     = ptr QItemSelectionModel
  AIM*     = ptr QAbstractItemModel
  SFPM*    = ptr QSortFilterProxyModel

# ── Дополнительные enum-типы виджетов ─────────────────────────────────────
type
  QLineEditEchoMode* {.size: sizeof(cint).} = enum
    Normal          = 0
    NoEcho          = 1
    Password        = 2
    PasswordEchoOnEdit = 3

  QTabPosition* {.size: sizeof(cint).} = enum
    TabNorth = 0
    TabSouth = 1
    TabWest  = 2
    TabEast  = 3

  QTabShape* {.size: sizeof(cint).} = enum
    Rounded    = 0
    Triangular = 1

  QFormLabelAlign* {.size: sizeof(cint).} = enum
    LabelAlignLeft   = 0x0001
    LabelAlignCenter = 0x0004
    LabelAlignRight  = 0x0002

  QFormRowWrap* {.size: sizeof(cint).} = enum
    DontWrapRows      = 0
    WrapLongRows      = 1
    WrapAllRows       = 2

  QSplitterOrientation* {.size: sizeof(cint).} = enum
    SplitHorizontal = 1
    SplitVertical   = 2

  QMdiSubWinFlag* {.size: sizeof(cint).} = enum
    AllowedAreaLeft  = 0x1
    AllowedAreaRight = 0x2
    AllowedAreaTop   = 0x4
    AllowedAreaBottom= 0x8
    AllowedAreaAll   = 0xf

  QWizardOption* {.size: sizeof(cint).} = enum
    IndependentPages        = 0x00000001
    IgnoreSubTitles         = 0x00000002
    ExtendedWatermarkPixmap = 0x00000004
    NoDefaultButton         = 0x00000008
    NoBackButtonOnStartPage = 0x00000010
    NoBackButtonOnLastPage  = 0x00000020
    DisabledBackButtonOnLastPage = 0x00000040
    HaveNextButtonOnLastPage= 0x00000080
    HaveFinishButtonOnEarlyPages = 0x00000100
    NoCancelButton          = 0x00000200
    CancelButtonOnLeft      = 0x00000400
    HaveHelpButton          = 0x00000800
    HelpButtonOnRight       = 0x00001000
    HaveCustomButton1       = 0x00002000
    HaveCustomButton2       = 0x00004000
    HaveCustomButton3       = 0x00008000
    NoCancelButtonOnLastPage= 0x00010000

  QTrayIconActivationReason* {.size: sizeof(cint).} = enum
    TrayUnknown     = 0
    TrayContext     = 1
    TrayDoubleClick = 2
    TrayTrigger     = 3
    TrayMiddleClick = 4

  QSelectionBehavior* {.size: sizeof(cint).} = enum
    SelectItems   = 0
    SelectRows    = 1
    SelectColumns = 2

  QSelectionMode* {.size: sizeof(cint).} = enum
    SingleSelection         = 1
    ContiguousSelection     = 4
    ExtendedSelection       = 3
    MultiSelection          = 2
    NoSelection             = 0

  QScrollHint* {.size: sizeof(cint).} = enum
    EnsureVisible        = 0
    PositionAtTop        = 1
    PositionAtBottom     = 2
    PositionAtCenter     = 3

  QToolButtonStyle* {.size: sizeof(cint).} = enum
    ToolButtonIconOnly     = 0
    ToolButtonTextOnly     = 1
    ToolButtonTextBesideIcon = 2
    ToolButtonTextUnderIcon = 3
    ToolButtonFollowStyle  = 4

  QProgressBarDirection* {.size: sizeof(cint).} = enum
    ProgressTopToBottom = 0
    ProgressBottomToTop = 1

  QLCDNumberMode* {.size: sizeof(cint).} = enum
    LcdHex = 0
    LcdDec = 1
    LcdOct = 2
    LcdBin = 3

  QComboBoxInsertPolicy* {.size: sizeof(cint).} = enum
    NoInsert                = 0
    InsertAtTop             = 1
    InsertAtCurrent         = 2
    InsertAtBottom          = 3
    InsertAfterCurrent      = 4
    InsertBeforeCurrent     = 5
    InsertAlphabetically    = 6

  QItemDataRole* {.size: sizeof(cint).} = enum
    DisplayRole        = 0
    DecorationRole     = 1
    EditRole           = 2
    ToolTipRole        = 3
    StatusTipRole      = 4
    WhatsThisRole      = 5
    FontRole           = 6
    TextAlignmentRole  = 7
    BackgroundRole     = 8
    ForegroundRole     = 9
    CheckStateRole     = 10
    SizeHintRole       = 13
    UserRole           = 0x0100

# ═══════════════════════════════════════════════════════════════════════════════
# QApplication
# ═══════════════════════════════════════════════════════════════════════════════

proc newApp*(): App =
  ## Создаёт синглтон QApplication (без аргументов командной строки)
  {.emit: "_nim_wgt_app = new QApplication(_nim_wgt_argc, _nim_wgt_argv); `result` = _nim_wgt_app;".}

proc appInstance*(): App =
  ## Получить существующий экземпляр QApplication
  {.emit: "`result` = static_cast<QApplication*>(QCoreApplication::instance());".}

proc exec*(a: App): cint {.importcpp: "#->exec()".}
proc quit*(a: App) {.importcpp: "#->quit()".}
proc exit*(a: App, code: cint = 0) {.importcpp: "#->exit(#)".}
proc processEvents*(a: App) {.importcpp: "QApplication::processEvents()".}

proc setAppName*(a: App, s: QString) {.importcpp: "#->setApplicationName(#)".}
proc setOrgName*(a: App, s: QString) {.importcpp: "#->setOrganizationName(#)".}
proc setOrgDomain*(a: App, s: QString) {.importcpp: "#->setOrganizationDomain(#)".}
proc setAppVersion*(a: App, s: QString) {.importcpp: "#->setApplicationVersion(#)".}
proc setStyleSheet*(a: App, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc appName*(): string =
  var p: cstring
  {.emit: "static QByteArray _bwan; _bwan = QApplication::applicationName().toUtf8(); `p` = _bwan.constData();".}
  result = $p

proc setStyle*(a: App, styleName: string) =
  let cs = styleName.cstring
  {.emit: "QApplication::setStyle(QStyleFactory::create(QString::fromUtf8(`cs`)));".}

proc availableStyles*(): seq[string] =
  var n: cint
  {.emit: "QStringList _stls = QStyleFactory::keys(); `n` = _stls.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bstl; _bstl = _stls.at(`idx`).toUtf8(); `p` = _bstl.constData();".}
    result[i] = $p

proc setFont*(a: App, family: string, size: int, bold: bool = false) =
  let cs = family.cstring; let si = size.cint; let bi = bold.cint
  {.emit: """
    QFont _f(QString::fromUtf8(`cs`), `si`);
    if (`bi`) _f.setBold(true);
    QApplication::setFont(_f);
  """.}

proc primaryScreen*(): pointer =
  ## Возвращает указатель на QScreen (opaque)
  {.emit: "`result` = QApplication::primaryScreen();".}

proc screenGeometry*(): tuple[x, y, w, h: int] =
  var x, y, w, h: cint
  {.emit: """
    QRect _sg = QApplication::primaryScreen()->availableGeometry();
    `x` = _sg.x(); `y` = _sg.y(); `w` = _sg.width(); `h` = _sg.height();
  """.}
  result = (x.int, y.int, w.int, h.int)

proc screenDpi*(): int =
  var v: cint
  {.emit: "`v` = (int)QApplication::primaryScreen()->logicalDotsPerInch();".}
  result = v.int

# ═══════════════════════════════════════════════════════════════════════════════
# QWidget — базовый виджет
# ═══════════════════════════════════════════════════════════════════════════════

proc newWidget*(parent: W = nil): W {.importcpp: "new QWidget(#)".}
proc show*(w: W) {.importcpp: "#->show()".}
proc hide*(w: W) {.importcpp: "#->hide()".}
proc close*(w: W) {.importcpp: "#->close()".}
proc raiseW*(w: W) {.importcpp: "#->raise()".}
proc lower*(w: W) {.importcpp: "#->lower()".}
proc update*(w: W) {.importcpp: "#->update()".}
proc repaint*(w: W) {.importcpp: "#->repaint()".}

proc setVisible*(w: W, v: bool) {.importcpp: "#->setVisible(#)".}
proc isVisible*(w: W): bool =
  var r: cint
  {.emit: "`r` = `w`->isVisible() ? 1 : 0;".}
  result = r == 1
proc isEnabled*(w: W): bool =
  var r: cint
  {.emit: "`r` = `w`->isEnabled() ? 1 : 0;".}
  result = r == 1
proc setEnabled*(w: W, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setDisabled*(w: W, b: bool) {.importcpp: "#->setDisabled(#)".}

proc resize*(w: W, width, height: cint) {.importcpp: "#->resize(#, #)".}
proc move*(w: W, x, y: cint) {.importcpp: "#->move(#, #)".}
proc setFixedSize*(w: W, width, height: cint) {.importcpp: "#->setFixedSize(#, #)".}
proc setFixedWidth*(w: W, width: cint) {.importcpp: "#->setFixedWidth(#)".}
proc setFixedHeight*(w: W, height: cint) {.importcpp: "#->setFixedHeight(#)".}
proc setMinSize*(w: W, width, height: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setMaxSize*(w: W, width, height: cint) {.importcpp: "#->setMaximumSize(#, #)".}
proc setMinWidth*(w: W, v: cint) {.importcpp: "#->setMinimumWidth(#)".}
proc setMinHeight*(w: W, v: cint) {.importcpp: "#->setMinimumHeight(#)".}

proc width*(w: W): int =
  var v: cint
  {.emit: "`v` = `w`->width();".}
  result = v.int
proc height*(w: W): int =
  var v: cint
  {.emit: "`v` = `w`->height();".}
  result = v.int
proc x*(w: W): int =
  var v: cint
  {.emit: "`v` = `w`->x();".}
  result = v.int
proc y*(w: W): int =
  var v: cint
  {.emit: "`v` = `w`->y();".}
  result = v.int

proc setWindowTitle*(w: W, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc windowTitle*(w: W): string =
  var p: cstring
  {.emit: "static QByteArray _bwt; _bwt = `w`->windowTitle().toUtf8(); `p` = _bwt.constData();".}
  result = $p

proc setToolTip*(w: W, s: QString) {.importcpp: "#->setToolTip(#)".}
proc setWhatsThis*(w: W, s: QString) {.importcpp: "#->setWhatsThis(#)".}
proc setStatusTip*(w: W, s: QString) {.importcpp: "#->setStatusTip(#)".}
proc setStyleSheet*(w: W, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc setLayout*(w: W, l: ptr QLayout) {.importcpp: "#->setLayout(#)".}
proc setLayout*(w: W, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(w: W, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(w: W, l: Grid) {.importcpp: "#->setLayout(#)".}
proc setLayout*(w: W, l: Form) {.importcpp: "#->setLayout(#)".}

proc setFocus*(w: W) {.importcpp: "#->setFocus()".}
proc clearFocus*(w: W) {.importcpp: "#->clearFocus()".}
proc hasFocus*(w: W): bool =
  var r: cint
  {.emit: "`r` = `w`->hasFocus() ? 1 : 0;".}
  result = r == 1

proc setTabOrder*(first, second: W) =
  {.emit: "QWidget::setTabOrder(`first`, `second`);".}

proc setWindowFlags*(w: W, flags: cint) =
  {.emit: "`w`->setWindowFlags((Qt::WindowFlags)`flags`);".}

proc setWindowModality*(w: W, modal: bool) =
  let mi = modal.cint
  {.emit: "`w`->setWindowModality(`mi` ? Qt::ApplicationModal : Qt::NonModal);".}

proc setAcceptDrops*(w: W, b: bool) {.importcpp: "#->setAcceptDrops(#)".}

proc setAttribute*(w: W, attr: cint, on: bool = true) =
  {.emit: "`w`->setAttribute((Qt::WidgetAttribute)`attr`, `on`);".}

proc setSizePolicy*(w: W, h, v: cint) =
  {.emit: "`w`->setSizePolicy((QSizePolicy::Policy)`h`, (QSizePolicy::Policy)`v`);".}

proc setContentsMargins*(w: W, l, t, r, b: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}

proc centerOnScreen*(w: W) =
  {.emit: """
    if (auto *_sc = QApplication::primaryScreen())
      `w`->move(_sc->availableGeometry().center() - `w`->rect().center());
  """.}

proc setParent*(w, parent: W) {.importcpp: "#->setParent(#)".}
proc parentWidget*(w: W): W {.importcpp: "(QWidget*)#->parentWidget()".}

proc setCursor*(w: W, shape: cint) =
  {.emit: "`w`->setCursor(QCursor((Qt::CursorShape)`shape`));".}
proc unsetCursor*(w: W) {.importcpp: "#->unsetCursor()".}

proc grabKeyboard*(w: W) {.importcpp: "#->grabKeyboard()".}
proc releaseKeyboard*(w: W) {.importcpp: "#->releaseKeyboard()".}
proc grabMouse*(w: W) {.importcpp: "#->grabMouse()".}
proc releaseMouse*(w: W) {.importcpp: "#->releaseMouse()".}

proc geometry*(w: W): NimRect =
  var x, y, wv, h: cint
  {.emit: "QRect _gr = `w`->geometry(); `x`=_gr.x(); `y`=_gr.y(); `wv`=_gr.width(); `h`=_gr.height();".}
  result = (x.int, y.int, wv.int, h.int)

## Upcast helpers
proc asW*(w: Win): W       {.importcpp: "(QWidget*)#".}
proc asW*(d: Dlg): W       {.importcpp: "(QWidget*)#".}
proc asW*(b: Btn): W       {.importcpp: "(QWidget*)#".}
proc asW*(b: Radio): W     {.importcpp: "(QWidget*)#".}
proc asW*(b: ChkBox): W    {.importcpp: "(QWidget*)#".}
proc asW*(l: Lbl): W       {.importcpp: "(QWidget*)#".}
proc asW*(e: LE): W        {.importcpp: "(QWidget*)#".}
proc asW*(e: TE): W        {.importcpp: "(QWidget*)#".}
proc asW*(e: PTE): W       {.importcpp: "(QWidget*)#".}
proc asW*(s: Spin): W      {.importcpp: "(QWidget*)#".}
proc asW*(s: DSpin): W     {.importcpp: "(QWidget*)#".}
proc asW*(s: Slider): W    {.importcpp: "(QWidget*)#".}
proc asW*(p: Prog): W      {.importcpp: "(QWidget*)#".}
proc asW*(c: Combo): W     {.importcpp: "(QWidget*)#".}
proc asW*(t: Tab): W       {.importcpp: "(QWidget*)#".}
proc asW*(lw: LW): W       {.importcpp: "(QWidget*)#".}
proc asW*(tw: TW): W       {.importcpp: "(QWidget*)#".}
proc asW*(tw: TblW): W     {.importcpp: "(QWidget*)#".}
proc asW*(g: Grp): W       {.importcpp: "(QWidget*)#".}
proc asW*(f: Frm): W       {.importcpp: "(QWidget*)#".}
proc asW*(sp: Splt): W     {.importcpp: "(QWidget*)#".}
proc asW*(d: Dock): W      {.importcpp: "(QWidget*)#".}
proc asW*(sc: Scroll): W   {.importcpp: "(QWidget*)#".}
proc asW*(st: Stack): W    {.importcpp: "(QWidget*)#".}
proc asW*(m: Mdi): W       {.importcpp: "(QWidget*)#".}

# ═══════════════════════════════════════════════════════════════════════════════
# QMainWindow
# ═══════════════════════════════════════════════════════════════════════════════

proc newWin*(parent: W = nil): Win {.importcpp: "new QMainWindow(#)".}
proc show*(w: Win) {.importcpp: "#->show()".}
proc hide*(w: Win) {.importcpp: "#->hide()".}
proc close*(w: Win) {.importcpp: "#->close()".}
proc setTitle*(w: Win, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc resize*(w: Win, width, height: cint) {.importcpp: "#->resize(#, #)".}
proc setMinSize*(w: Win, width, height: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setCentral*(w: Win, c: W) {.importcpp: "#->setCentralWidget(#)".}
proc centralWidget*(w: Win): W {.importcpp: "(QWidget*)#->centralWidget()".}
proc statusBar*(w: Win): StatusBar {.importcpp: "#->statusBar()".}
proc menuBar*(w: Win): MBar {.importcpp: "#->menuBar()".}
proc setMenuBar*(w: Win, mb: MBar) {.importcpp: "#->setMenuBar(#)".}
proc addToolBar*(w: Win, title: QString): TB {.importcpp: "#->addToolBar(#)".}
proc addToolBarBreak*(w: Win) {.importcpp: "#->addToolBarBreak()".}
proc setStyleSheet*(w: Win, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setUnifiedTitleAndToolBarOnMac*(w: Win, b: bool) {.importcpp: "#->setUnifiedTitleAndToolBarOnMac(#)".}

proc addMenu*(w: Win, title: QString): Menu =
  {.emit: "`result` = `w`->menuBar()->addMenu(`title`);".}

proc addDock*(w: Win, area: cint, d: Dock) =
  {.emit: "`w`->addDockWidget((Qt::DockWidgetArea)`area`, `d`);".}

proc splitDock*(w: Win, first, second: Dock, orientation: cint) =
  {.emit: "`w`->splitDockWidget(`first`, `second`, (Qt::Orientation)`orientation`);".}

proc tabifyDock*(w: Win, first, second: Dock) {.importcpp: "#->tabifyDockWidget(#, #)".}
proc removeDock*(w: Win, d: Dock) {.importcpp: "#->removeDockWidget(#)".}
proc restoreState*(w: Win, state: string): bool =
  let cs = state.cstring; let n = state.len.cint; var r: cint
  {.emit: "`r` = `w`->restoreState(QByteArray(`cs`, `n`)) ? 1 : 0;".}
  result = r == 1
proc saveState*(w: Win): string =
  var p: cstring
  {.emit: "static QByteArray _bss; _bss = `w`->saveState(); `p` = _bss.constData();".}
  result = $p
proc setDockNestingEnabled*(w: Win, b: bool) {.importcpp: "#->setDockNestingEnabled(#)".}
proc setAnimated*(w: Win, b: bool) {.importcpp: "#->setAnimated(#)".}
proc centerOnScreen*(w: Win) =
  {.emit: """
    if (auto *_sc = QApplication::primaryScreen())
      `w`->move(_sc->availableGeometry().center() - `w`->rect().center());
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QStatusBar
# ═══════════════════════════════════════════════════════════════════════════════

proc showMsg*(sb: StatusBar, msg: QString, ms: cint = 0) {.importcpp: "#->showMessage(#, #)".}
proc clearMsg*(sb: StatusBar) {.importcpp: "#->clearMessage()".}
proc addWidget*(sb: StatusBar, w: W, stretch: cint = 0) {.importcpp: "#->addWidget(#, #)".}
proc addPermanentWidget*(sb: StatusBar, w: W, stretch: cint = 0) {.importcpp: "#->addPermanentWidget(#, #)".}
proc removeWidget*(sb: StatusBar, w: W) {.importcpp: "#->removeWidget(#)".}
proc setStyleSheet*(sb: StatusBar, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QMenuBar
# ═══════════════════════════════════════════════════════════════════════════════

proc newMenuBar*(parent: W = nil): MBar {.importcpp: "new QMenuBar(#)".}
proc addMenu*(mb: MBar, title: QString): Menu {.importcpp: "#->addMenu(#)".}
proc addMenu*(mb: MBar, m: Menu): Act {.importcpp: "#->addMenu(#)".}
proc addAction*(mb: MBar, a: Act) {.importcpp: "#->addAction(#)".}
proc setVisible*(mb: MBar, v: bool) {.importcpp: "#->setVisible(#)".}
proc setNativeMenuBar*(mb: MBar, b: bool) {.importcpp: "#->setNativeMenuBar(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QMenu
# ═══════════════════════════════════════════════════════════════════════════════

proc newMenu*(title: QString, parent: W = nil): Menu {.importcpp: "new QMenu(#, #)".}
proc addSubMenu*(m: Menu, title: QString): Menu {.importcpp: "#->addMenu(#)".}
proc addSubMenu*(m: Menu, sub: Menu): Act {.importcpp: "#->addMenu(#)".}
proc newAction*(m: Menu, text: QString): Act {.importcpp: "#->addAction(#)".}
proc addSep*(m: Menu) {.importcpp: "#->addSeparator()".}
proc addAction*(m: Menu, a: Act) {.importcpp: "#->addAction(#)".}
proc removeAction*(m: Menu, a: Act) {.importcpp: "#->removeAction(#)".}
proc clear*(m: Menu) {.importcpp: "#->clear()".}
proc setTitle*(m: Menu, s: QString) {.importcpp: "#->setTitle(#)".}
proc setEnabled*(m: Menu, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setTearOffEnabled*(m: Menu, b: bool) {.importcpp: "#->setTearOffEnabled(#)".}
proc execAt*(m: Menu, x, y: cint): Act =
  {.emit: "`result` = `m`->exec(QPoint(`x`, `y`));".}
proc popup*(m: Menu, x, y: cint) =
  {.emit: "`m`->popup(QPoint(`x`, `y`));".}

proc onMenuAboutToShow*(m: Menu, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`m`, &QMenu::aboutToShow, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QAction
# ═══════════════════════════════════════════════════════════════════════════════

proc newAction*(parent: W, text: QString): Act {.importcpp: "new QAction(#, #)".}
proc newActionSep*(parent: W): Act =
  {.emit: "`result` = new QAction(`parent`); `result`->setSeparator(true);".}

proc setText*(a: Act, s: QString) {.importcpp: "#->setText(#)".}
proc setShortcut*(a: Act, keys: cstring) =
  {.emit: "`a`->setShortcut(QKeySequence(QString::fromUtf8(`keys`)));".}
proc setShortcut*(a: Act, ks: QString) =
  {.emit: "`a`->setShortcut(QKeySequence(`ks`));".}
proc setTip*(a: Act, s: QString) {.importcpp: "#->setStatusTip(#)".}
proc setToolTip*(a: Act, s: QString) {.importcpp: "#->setToolTip(#)".}
proc setEnabled*(a: Act, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setCheckable*(a: Act, b: bool) {.importcpp: "#->setCheckable(#)".}
proc setChecked*(a: Act, b: bool) {.importcpp: "#->setChecked(#)".}
proc isChecked*(a: Act): bool =
  var r: cint
  {.emit: "`r` = `a`->isChecked() ? 1 : 0;".}
  result = r == 1
proc isEnabled*(a: Act): bool =
  var r: cint
  {.emit: "`r` = `a`->isEnabled() ? 1 : 0;".}
  result = r == 1
proc setSeparator*(a: Act, b: bool) {.importcpp: "#->setSeparator(#)".}
proc setIconText*(a: Act, s: QString) {.importcpp: "#->setIconText(#)".}
proc setVisible*(a: Act, b: bool) {.importcpp: "#->setVisible(#)".}

proc onTriggered*(a: Act, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`a`, &QAction::triggered, [=](bool){
      `cb`(`ud`);
    });
  """.}

proc onToggled*(a: Act, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`a`, &QAction::toggled, [=](bool _checked){
      `cb`(_checked ? 1 : 0, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QActionGroup
# ═══════════════════════════════════════════════════════════════════════════════

proc newActionGroup*(parent: W): ActGrp {.importcpp: "new QActionGroup(#)".}
proc addAction*(ag: ActGrp, a: Act): Act {.importcpp: "#->addAction(#)".}
proc removeAction*(ag: ActGrp, a: Act) {.importcpp: "#->removeAction(#)".}
proc setExclusive*(ag: ActGrp, b: bool) {.importcpp: "#->setExclusive(#)".}
proc setEnabled*(ag: ActGrp, b: bool) {.importcpp: "#->setEnabled(#)".}
proc checkedAction*(ag: ActGrp): Act {.importcpp: "#->checkedAction()".}

proc onActionGroupTriggered*(ag: ActGrp, cb: proc(a: Act, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`ag`, &QActionGroup::triggered, [=](QAction* _a){
      `cb`(_a, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QToolBar
# ═══════════════════════════════════════════════════════════════════════════════

proc newToolBar*(title: QString, parent: Win = nil): TB {.importcpp: "new QToolBar(#, #)".}
proc addAction*(tb: TB, a: Act) {.importcpp: "#->addAction(#)".}
proc addWidget*(tb: TB, w: W): Act {.importcpp: "#->addWidget(#)".}
proc addSep*(tb: TB): Act {.importcpp: "#->addSeparator()".}
proc clear*(tb: TB) {.importcpp: "#->clear()".}
proc setMovable*(tb: TB, b: bool) {.importcpp: "#->setMovable(#)".}
proc setFloatable*(tb: TB, b: bool) {.importcpp: "#->setFloatable(#)".}
proc setIconSize*(tb: TB, w, h: cint) =
  {.emit: "`tb`->setIconSize(QSize(`w`, `h`));".}
proc setToolButtonStyle*(tb: TB, style: cint) =
  {.emit: "`tb`->setToolButtonStyle((Qt::ToolButtonStyle)`style`);".}
proc setStyleSheet*(tb: TB, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setOrientation*(tb: TB, o: cint) =
  {.emit: "`tb`->setOrientation((Qt::Orientation)`o`);".}
proc setAllowedAreas*(tb: TB, areas: cint) =
  {.emit: "`tb`->setAllowedAreas((Qt::ToolBarAreas)`areas`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# QLabel
# ═══════════════════════════════════════════════════════════════════════════════

proc newLabel*(text: QString, parent: W = nil): Lbl {.importcpp: "new QLabel(#, #)".}
proc newLabel*(parent: W = nil): Lbl {.importcpp: "new QLabel(#)".}
proc setText*(l: Lbl, s: QString) {.importcpp: "#->setText(#)".}
proc text*(l: Lbl): string =
  var p: cstring
  {.emit: "static QByteArray _blbl; _blbl = `l`->text().toUtf8(); `p` = _blbl.constData();".}
  result = $p
proc setAlignment*(l: Lbl, a: cint) =
  {.emit: "`l`->setAlignment((Qt::Alignment)`a`);".}
proc setWordWrap*(l: Lbl, b: bool) {.importcpp: "#->setWordWrap(#)".}
proc setOpenExternalLinks*(l: Lbl, b: bool) {.importcpp: "#->setOpenExternalLinks(#)".}
proc setTextFormat*(l: Lbl, f: cint) =
  {.emit: "`l`->setTextFormat((Qt::TextFormat)`f`);".}
proc setScaledContents*(l: Lbl, b: bool) {.importcpp: "#->setScaledContents(#)".}
proc setIndent*(l: Lbl, n: cint) {.importcpp: "#->setIndent(#)".}
proc setMargin*(l: Lbl, n: cint) {.importcpp: "#->setMargin(#)".}
proc setStyleSheet*(l: Lbl, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setMinSize*(l: Lbl, w, h: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setFixedWidth*(l: Lbl, w: cint) {.importcpp: "#->setFixedWidth(#)".}

proc onLabelLinkActivated*(l: Lbl, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`l`, &QLabel::linkActivated, [=](const QString& _link){
      static QByteArray _blnk; _blnk = _link.toUtf8();
      `cb`(_blnk.constData(), `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QPushButton
# ═══════════════════════════════════════════════════════════════════════════════

proc newBtn*(text: QString, parent: W = nil): Btn {.importcpp: "new QPushButton(#, #)".}
proc newBtn*(parent: W = nil): Btn {.importcpp: "new QPushButton(#)".}
proc setText*(b: Btn, s: QString) {.importcpp: "#->setText(#)".}
proc text*(b: Btn): string =
  var p: cstring
  {.emit: "static QByteArray _bbt; _bbt = `b`->text().toUtf8(); `p` = _bbt.constData();".}
  result = $p
proc setEnabled*(b: Btn, v: bool) {.importcpp: "#->setEnabled(#)".}
proc setCheckable*(b: Btn, v: bool) {.importcpp: "#->setCheckable(#)".}
proc setChecked*(b: Btn, v: bool) {.importcpp: "#->setChecked(#)".}
proc isChecked*(b: Btn): bool =
  var r: cint
  {.emit: "`r` = `b`->isChecked() ? 1 : 0;".}
  result = r == 1
proc setDefault*(b: Btn, v: bool) {.importcpp: "#->setDefault(#)".}
proc setAutoDefault*(b: Btn, v: bool) {.importcpp: "#->setAutoDefault(#)".}
proc setFlat*(b: Btn, v: bool) {.importcpp: "#->setFlat(#)".}
proc setStyleSheet*(b: Btn, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setToolTip*(b: Btn, s: QString) {.importcpp: "#->setToolTip(#)".}
proc setMinSize*(b: Btn, w, h: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setFixedSize*(b: Btn, w, h: cint) {.importcpp: "#->setFixedSize(#, #)".}
proc click*(b: Btn) {.importcpp: "#->click()".}
proc animateClick*(b: Btn) {.importcpp: "#->animateClick()".}

proc onClicked*(b: Btn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QPushButton::clicked, [=](bool){
      `cb`(`ud`);
    });
  """.}

proc onToggled*(b: Btn, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QPushButton::toggled, [=](bool _checked){
      `cb`(_checked ? 1 : 0, `ud`);
    });
  """.}

proc onPressed*(b: Btn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QPushButton::pressed, [=](){
      `cb`(`ud`);
    });
  """.}

proc onReleased*(b: Btn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QPushButton::released, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QToolButton
# ═══════════════════════════════════════════════════════════════════════════════

proc newToolButton*(parent: W = nil): TBtn {.importcpp: "new QToolButton(#)".}
proc setDefaultAction*(tb: TBtn, a: Act) {.importcpp: "#->setDefaultAction(#)".}
proc setPopupMode*(tb: TBtn, mode: cint) =
  {.emit: "`tb`->setPopupMode((QToolButton::ToolButtonPopupMode)`mode`);".}
proc setMenu*(tb: TBtn, m: Menu) {.importcpp: "#->setMenu(#)".}
proc setAutoRaise*(tb: TBtn, b: bool) {.importcpp: "#->setAutoRaise(#)".}
proc setToolButtonStyle*(tb: TBtn, style: cint) =
  {.emit: "`tb`->setToolButtonStyle((Qt::ToolButtonStyle)`style`);".}
proc setArrowType*(tb: TBtn, t: cint) =
  {.emit: "`tb`->setArrowType((Qt::ArrowType)`t`);".}
proc onTBClicked*(tb: TBtn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`tb`, &QToolButton::clicked, [=](bool){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QRadioButton
# ═══════════════════════════════════════════════════════════════════════════════

proc newRadio*(text: QString, parent: W = nil): Radio {.importcpp: "new QRadioButton(#, #)".}
proc setText*(r: Radio, s: QString) {.importcpp: "#->setText(#)".}
proc isChecked*(r: Radio): bool =
  var v: cint
  {.emit: "`v` = `r`->isChecked() ? 1 : 0;".}
  result = v == 1
proc setChecked*(r: Radio, b: bool) {.importcpp: "#->setChecked(#)".}
proc setEnabled*(r: Radio, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setStyleSheet*(r: Radio, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onRadioToggled*(r: Radio, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`r`, &QRadioButton::toggled, [=](bool _c){
      `cb`(_c ? 1 : 0, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QCheckBox
# ═══════════════════════════════════════════════════════════════════════════════

proc newCheckBox*(text: QString, parent: W = nil): ChkBox {.importcpp: "new QCheckBox(#, #)".}
proc setText*(c: ChkBox, s: QString) {.importcpp: "#->setText(#)".}
proc isChecked*(c: ChkBox): bool =
  var r: cint
  {.emit: "`r` = `c`->isChecked() ? 1 : 0;".}
  result = r == 1
proc setChecked*(c: ChkBox, b: bool) {.importcpp: "#->setChecked(#)".}
proc setTristate*(c: ChkBox, b: bool) {.importcpp: "#->setTristate(#)".}
proc checkState*(c: ChkBox): int =
  var v: cint
  {.emit: "`v` = (int)`c`->checkState();".}
  result = v.int
proc setCheckState*(c: ChkBox, s: cint) =
  {.emit: "`c`->setCheckState((Qt::CheckState)`s`);".}
proc setEnabled*(c: ChkBox, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setStyleSheet*(c: ChkBox, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onCheckBoxToggled*(c: ChkBox, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, &QCheckBox::toggled, [=](bool _ch){
      `cb`(_ch ? 1 : 0, `ud`);
    });
  """.}

proc onCheckStateChanged*(c: ChkBox, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, &QCheckBox::checkStateChanged, [=](Qt::CheckState _st){
      `cb`((int)_st, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QButtonGroup
# ═══════════════════════════════════════════════════════════════════════════════

proc newButtonGroup*(parent: W = nil): BtnGrp =
  {.emit: "`result` = new QButtonGroup((QObject*)`parent`);".}
proc addButton*(bg: BtnGrp, b: Btn, id: cint = -1) {.importcpp: "#->addButton(#, #)".}
proc addButton*(bg: BtnGrp, b: Radio, id: cint = -1) {.importcpp: "#->addButton(#, #)".}
proc addButton*(bg: BtnGrp, b: ChkBox, id: cint = -1) {.importcpp: "#->addButton(#, #)".}
proc removeButton*(bg: BtnGrp, b: Btn) {.importcpp: "#->removeButton(#)".}
proc setExclusive*(bg: BtnGrp, b: bool) {.importcpp: "#->setExclusive(#)".}
proc checkedId*(bg: BtnGrp): int =
  var v: cint
  {.emit: "`v` = `bg`->checkedId();".}
  result = v.int
proc setId*(bg: BtnGrp, b: Btn, id: cint) {.importcpp: "#->setId(#, #)".}

proc onBtnGroupIdClicked*(bg: BtnGrp, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`bg`, &QButtonGroup::idClicked, [=](int _id){
      `cb`(_id, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QCommandLinkButton
# ═══════════════════════════════════════════════════════════════════════════════

proc newCmdBtn*(text, desc: QString, parent: W = nil): CmdBtn {.importcpp: "new QCommandLinkButton(#, #, #)".}
proc setDescription*(b: CmdBtn, s: QString) {.importcpp: "#->setDescription(#)".}
proc description*(b: CmdBtn): string =
  var p: cstring
  {.emit: "static QByteArray _bcmd; _bcmd = `b`->description().toUtf8(); `p` = _bcmd.constData();".}
  result = $p
proc onCmdClicked*(b: CmdBtn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QCommandLinkButton::clicked, [=](bool){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QLineEdit
# ═══════════════════════════════════════════════════════════════════════════════

proc newLineEdit*(text: QString, parent: W = nil): LE {.importcpp: "new QLineEdit(#, #)".}
proc newLineEdit*(parent: W = nil): LE {.importcpp: "new QLineEdit(#)".}
proc text*(e: LE): string =
  var p: cstring
  {.emit: "static QByteArray _ble; _ble = `e`->text().toUtf8(); `p` = _ble.constData();".}
  result = $p
proc setText*(e: LE, s: QString) {.importcpp: "#->setText(#)".}
proc setPlaceholder*(e: LE, s: QString) {.importcpp: "#->setPlaceholderText(#)".}
proc setReadOnly*(e: LE, b: bool) {.importcpp: "#->setReadOnly(#)".}
proc isReadOnly*(e: LE): bool =
  var r: cint
  {.emit: "`r` = `e`->isReadOnly() ? 1 : 0;".}
  result = r == 1
proc setMaxLength*(e: LE, n: cint) {.importcpp: "#->setMaxLength(#)".}
proc setEchoMode*(e: LE, mode: cint) =
  {.emit: "`e`->setEchoMode((QLineEdit::EchoMode)`mode`);".}
proc setAlignment*(e: LE, a: cint) =
  {.emit: "`e`->setAlignment((Qt::Alignment)`a`);".}
proc clear*(e: LE) {.importcpp: "#->clear()".}
proc selectAll*(e: LE) {.importcpp: "#->selectAll()".}
proc setClearButtonEnabled*(e: LE, b: bool) {.importcpp: "#->setClearButtonEnabled(#)".}
proc setStyleSheet*(e: LE, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setToolTip*(e: LE, s: QString) {.importcpp: "#->setToolTip(#)".}
proc setInputMask*(e: LE, mask: QString) {.importcpp: "#->setInputMask(#)".}
proc hasAcceptableInput*(e: LE): bool =
  var r: cint
  {.emit: "`r` = `e`->hasAcceptableInput() ? 1 : 0;".}
  result = r == 1

proc setCompleter*(e: LE, c: Compltr) {.importcpp: "#->setCompleter(#)".}

proc onTextChanged*(e: LE, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QLineEdit::textChanged, [=](const QString& _t){
      static QByteArray _blet; _blet = _t.toUtf8();
      `cb`(_blet.constData(), `ud`);
    });
  """.}

proc onTextEdited*(e: LE, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QLineEdit::textEdited, [=](const QString& _t){
      static QByteArray _blee; _blee = _t.toUtf8();
      `cb`(_blee.constData(), `ud`);
    });
  """.}

proc onReturnPressed*(e: LE, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QLineEdit::returnPressed, [=](){
      `cb`(`ud`);
    });
  """.}

proc onEditingFinished*(e: LE, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QLineEdit::editingFinished, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QTextEdit
# ═══════════════════════════════════════════════════════════════════════════════

proc newTextEdit*(parent: W = nil): TE {.importcpp: "new QTextEdit(#)".}
proc newTextEdit*(text: QString, parent: W = nil): TE {.importcpp: "new QTextEdit(#, #)".}
proc text*(e: TE): string =
  var p: cstring
  {.emit: "static QByteArray _bte; _bte = `e`->toPlainText().toUtf8(); `p` = _bte.constData();".}
  result = $p
proc html*(e: TE): string =
  var p: cstring
  {.emit: "static QByteArray _bteh; _bteh = `e`->toHtml().toUtf8(); `p` = _bteh.constData();".}
  result = $p
proc setText*(e: TE, s: QString) {.importcpp: "#->setPlainText(#)".}
proc setHtml*(e: TE, s: QString) {.importcpp: "#->setHtml(#)".}
proc append*(e: TE, s: QString) {.importcpp: "#->append(#)".}
proc clear*(e: TE) {.importcpp: "#->clear()".}
proc setReadOnly*(e: TE, b: bool) {.importcpp: "#->setReadOnly(#)".}
proc setPlaceholder*(e: TE, s: QString) {.importcpp: "#->setPlaceholderText(#)".}
proc setWordWrap*(e: TE, mode: cint) =
  {.emit: "`e`->setWordWrapMode((QTextOption::WrapMode)`mode`);".}
proc setTabStop*(e: TE, distance: cint) =
  {.emit: "`e`->setTabStopDistance(`distance`);".}
proc setUndoRedoEnabled*(e: TE, b: bool) {.importcpp: "#->setUndoRedoEnabled(#)".}
proc setAcceptRichText*(e: TE, b: bool) {.importcpp: "#->setAcceptRichText(#)".}
proc setStyleSheet*(e: TE, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc scrollToBottom*(e: TE) =
  {.emit: "`e`->verticalScrollBar()->setValue(`e`->verticalScrollBar()->maximum());".}
proc moveCursorEnd*(e: TE) =
  {.emit: """
    QTextCursor _cur = `e`->textCursor();
    _cur.movePosition(QTextCursor::End);
    `e`->setTextCursor(_cur);
  """.}
proc selectAll*(e: TE) {.importcpp: "#->selectAll()".}
proc setLineWrapMode*(e: TE, mode: cint) =
  {.emit: "`e`->setLineWrapMode((QTextEdit::LineWrapMode)`mode`);".}
proc setMaximumBlockCount*(e: TE, n: cint) {.importcpp: "#->document()->setMaximumBlockCount(#)".}
proc zoomIn*(e: TE, range: cint = 1) {.importcpp: "#->zoomIn(#)".}
proc zoomOut*(e: TE, range: cint = 1) {.importcpp: "#->zoomOut(#)".}

proc onTextChanged*(e: TE, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QTextEdit::textChanged, [=](){
      `cb`(`ud`);
    });
  """.}

proc onCursorPositionChanged*(e: TE, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QTextEdit::cursorPositionChanged, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QPlainTextEdit
# ═══════════════════════════════════════════════════════════════════════════════

proc newPlainTextEdit*(parent: W = nil): PTE {.importcpp: "new QPlainTextEdit(#)".}
proc newPlainTextEdit*(text: QString, parent: W = nil): PTE {.importcpp: "new QPlainTextEdit(#, #)".}
proc text*(e: PTE): string =
  var p: cstring
  {.emit: "static QByteArray _bpte; _bpte = `e`->toPlainText().toUtf8(); `p` = _bpte.constData();".}
  result = $p
proc setText*(e: PTE, s: QString) {.importcpp: "#->setPlainText(#)".}
proc appendLine*(e: PTE, s: QString) {.importcpp: "#->appendPlainText(#)".}
proc clear*(e: PTE) {.importcpp: "#->clear()".}
proc setReadOnly*(e: PTE, b: bool) {.importcpp: "#->setReadOnly(#)".}
proc setPlaceholder*(e: PTE, s: QString) {.importcpp: "#->setPlaceholderText(#)".}
proc setTabStop*(e: PTE, distance: cint) =
  {.emit: "`e`->setTabStopDistance(`distance`);".}
proc setMaxBlockCount*(e: PTE, n: cint) {.importcpp: "#->setMaximumBlockCount(#)".}
proc setLineWrapMode*(e: PTE, mode: cint) =
  {.emit: "`e`->setLineWrapMode((QPlainTextEdit::LineWrapMode)`mode`);".}
proc setStyleSheet*(e: PTE, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setUndoRedoEnabled*(e: PTE, b: bool) {.importcpp: "#->setUndoRedoEnabled(#)".}
proc blockCount*(e: PTE): int =
  var v: cint
  {.emit: "`v` = `e`->blockCount();".}
  result = v.int
proc centerCursor*(e: PTE) {.importcpp: "#->centerCursor()".}
proc scrollToBottom*(e: PTE) =
  {.emit: "`e`->verticalScrollBar()->setValue(`e`->verticalScrollBar()->maximum());".}

proc onPTETextChanged*(e: PTE, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QPlainTextEdit::textChanged, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QTextBrowser
# ═══════════════════════════════════════════════════════════════════════════════

proc newTextBrowser*(parent: W = nil): TBrw {.importcpp: "new QTextBrowser(#)".}
proc setHtml*(b: TBrw, s: QString) {.importcpp: "#->setHtml(#)".}
proc setSource*(b: TBrw, url: QString) =
  {.emit: "`b`->setSource(QUrl(`url`));".}
proc setSearchPaths*(b: TBrw, paths: seq[string]) =
  var joined = ""
  for i, s in paths:
    if i > 0: joined.add('\0')
    joined.add(s)
  let data = joined.cstring; let n = paths.len.cint
  {.emit: """
    QStringList _sp;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _sp << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `b`->setSearchPaths(_sp);
  """.}
proc setOpenLinks*(b: TBrw, v: bool) {.importcpp: "#->setOpenLinks(#)".}
proc setOpenExternalLinks*(b: TBrw, v: bool) {.importcpp: "#->setOpenExternalLinks(#)".}
proc backward*(b: TBrw) {.importcpp: "#->backward()".}
proc forward*(b: TBrw) {.importcpp: "#->forward()".}
proc home*(b: TBrw) {.importcpp: "#->home()".}

proc onTBrwAnchorClicked*(b: TBrw, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QTextBrowser::anchorClicked, [=](const QUrl& _u){
      static QByteArray _btburl; _btburl = _u.toString().toUtf8();
      `cb`(_btburl.constData(), `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QSpinBox / QDoubleSpinBox
# ═══════════════════════════════════════════════════════════════════════════════

proc newSpinBox*(parent: W = nil): Spin {.importcpp: "new QSpinBox(#)".}
proc value*(s: Spin): int =
  var v: cint
  {.emit: "`v` = `s`->value();".}
  result = v.int
proc setValue*(s: Spin, v: cint) {.importcpp: "#->setValue(#)".}
proc setRange*(s: Spin, lo, hi: cint) {.importcpp: "#->setRange(#, #)".}
proc setMinimum*(s: Spin, v: cint) {.importcpp: "#->setMinimum(#)".}
proc setMaximum*(s: Spin, v: cint) {.importcpp: "#->setMaximum(#)".}
proc setSingleStep*(s: Spin, v: cint) {.importcpp: "#->setSingleStep(#)".}
proc setPrefix*(s: Spin, p: QString) {.importcpp: "#->setPrefix(#)".}
proc setSuffix*(s: Spin, p: QString) {.importcpp: "#->setSuffix(#)".}
proc setWrapping*(s: Spin, b: bool) {.importcpp: "#->setWrapping(#)".}
proc setReadOnly*(s: Spin, b: bool) {.importcpp: "#->setReadOnly(#)".}
proc setStyleSheet*(s: Spin, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onSpinValueChanged*(s: Spin, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, QOverload<int>::of(&QSpinBox::valueChanged), [=](int _v){
      `cb`(_v, `ud`);
    });
  """.}

proc newDoubleSpinBox*(parent: W = nil): DSpin {.importcpp: "new QDoubleSpinBox(#)".}
proc value*(s: DSpin): float64 =
  var v: cdouble
  {.emit: "`v` = `s`->value();".}
  result = v.float64
proc setValue*(s: DSpin, v: cdouble) {.importcpp: "#->setValue(#)".}
proc setRange*(s: DSpin, lo, hi: cdouble) {.importcpp: "#->setRange(#, #)".}
proc setDecimals*(s: DSpin, d: cint) {.importcpp: "#->setDecimals(#)".}
proc setSingleStep*(s: DSpin, v: cdouble) {.importcpp: "#->setSingleStep(#)".}
proc setPrefix*(s: DSpin, p: QString) {.importcpp: "#->setPrefix(#)".}
proc setSuffix*(s: DSpin, p: QString) {.importcpp: "#->setSuffix(#)".}
proc setStyleSheet*(s: DSpin, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onDSpinValueChanged*(s: DSpin, cb: proc(v: cdouble, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, QOverload<double>::of(&QDoubleSpinBox::valueChanged), [=](double _v){
      `cb`(_v, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QSlider / QScrollBar / QDial
# ═══════════════════════════════════════════════════════════════════════════════

proc newSlider*(orientation: cint, parent: W = nil): Slider =
  {.emit: "`result` = new QSlider((Qt::Orientation)`orientation`, `parent`);".}
proc value*(s: Slider): int =
  var v: cint
  {.emit: "`v` = `s`->value();".}
  result = v.int
proc setValue*(s: Slider, v: cint) {.importcpp: "#->setValue(#)".}
proc setRange*(s: Slider, lo, hi: cint) {.importcpp: "#->setRange(#, #)".}
proc setMinimum*(s: Slider, v: cint) {.importcpp: "#->setMinimum(#)".}
proc setMaximum*(s: Slider, v: cint) {.importcpp: "#->setMaximum(#)".}
proc setSingleStep*(s: Slider, v: cint) {.importcpp: "#->setSingleStep(#)".}
proc setPageStep*(s: Slider, v: cint) {.importcpp: "#->setPageStep(#)".}
proc setTickInterval*(s: Slider, v: cint) {.importcpp: "#->setTickInterval(#)".}
proc setTickPosition*(s: Slider, pos: cint) =
  {.emit: "`s`->setTickPosition((QSlider::TickPosition)`pos`);".}
proc setInvertedAppearance*(s: Slider, b: bool) {.importcpp: "#->setInvertedAppearance(#)".}
proc setTracking*(s: Slider, b: bool) {.importcpp: "#->setTracking(#)".}
proc setStyleSheet*(s: Slider, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onSliderValueChanged*(s: Slider, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QSlider::valueChanged, [=](int _v){
      `cb`(_v, `ud`);
    });
  """.}

proc onSliderMoved*(s: Slider, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QSlider::sliderMoved, [=](int _v){
      `cb`(_v, `ud`);
    });
  """.}

proc newScrollBar*(orientation: cint, parent: W = nil): SBar =
  {.emit: "`result` = new QScrollBar((Qt::Orientation)`orientation`, `parent`);".}
proc value*(s: SBar): int =
  var v: cint
  {.emit: "`v` = `s`->value();".}
  result = v.int
proc setValue*(s: SBar, v: cint) {.importcpp: "#->setValue(#)".}
proc setRange*(s: SBar, lo, hi: cint) {.importcpp: "#->setRange(#, #)".}
proc setPageStep*(s: SBar, v: cint) {.importcpp: "#->setPageStep(#)".}
proc setSingleStep*(s: SBar, v: cint) {.importcpp: "#->setSingleStep(#)".}
proc setStyleSheet*(s: SBar, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onSBarValueChanged*(s: SBar, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QScrollBar::valueChanged, [=](int _v){
      `cb`(_v, `ud`);
    });
  """.}

proc newDial*(parent: W = nil): Dial {.importcpp: "new QDial(#)".}
proc value*(d: Dial): int =
  var v: cint
  {.emit: "`v` = `d`->value();".}
  result = v.int
proc setValue*(d: Dial, v: cint) {.importcpp: "#->setValue(#)".}
proc setRange*(d: Dial, lo, hi: cint) {.importcpp: "#->setRange(#, #)".}
proc setNotchesVisible*(d: Dial, b: bool) {.importcpp: "#->setNotchesVisible(#)".}
proc setWrapping*(d: Dial, b: bool) {.importcpp: "#->setWrapping(#)".}
proc setNotchTarget*(d: Dial, v: cdouble) {.importcpp: "#->setNotchTarget(#)".}
proc setStyleSheet*(d: Dial, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onDialValueChanged*(d: Dial, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`d`, &QDial::valueChanged, [=](int _v){
      `cb`(_v, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QProgressBar
# ═══════════════════════════════════════════════════════════════════════════════

proc newProgressBar*(parent: W = nil): Prog {.importcpp: "new QProgressBar(#)".}
proc setValue*(p: Prog, v: cint) {.importcpp: "#->setValue(#)".}
proc value*(p: Prog): int =
  var v: cint
  {.emit: "`v` = `p`->value();".}
  result = v.int
proc setRange*(p: Prog, lo, hi: cint) {.importcpp: "#->setRange(#, #)".}
proc setMinimum*(p: Prog, v: cint) {.importcpp: "#->setMinimum(#)".}
proc setMaximum*(p: Prog, v: cint) {.importcpp: "#->setMaximum(#)".}
proc setTextVisible*(p: Prog, b: bool) {.importcpp: "#->setTextVisible(#)".}
proc setFormat*(p: Prog, fmt: QString) {.importcpp: "#->setFormat(#)".}
proc setOrientation*(p: Prog, o: cint) =
  {.emit: "`p`->setOrientation((Qt::Orientation)`o`);".}
proc setInvertedAppearance*(p: Prog, b: bool) {.importcpp: "#->setInvertedAppearance(#)".}
proc setStyleSheet*(p: Prog, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc reset*(p: Prog) {.importcpp: "#->reset()".}

# ═══════════════════════════════════════════════════════════════════════════════
# QComboBox
# ═══════════════════════════════════════════════════════════════════════════════

proc newComboBox*(parent: W = nil): Combo {.importcpp: "new QComboBox(#)".}
proc addItem*(c: Combo, text: QString) {.importcpp: "#->addItem(#)".}
proc addItem*(c: Combo, text: QString, userData: QVariant) {.importcpp: "#->addItem(#, #)".}
proc addItems*(c: Combo, items: seq[string]) =
  var joined = ""
  for i, s in items:
    if i > 0: joined.add('\0')
    joined.add(s)
  let data = joined.cstring; let n = items.len.cint
  {.emit: """
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      `c`->addItem(QString::fromUtf8(_p));
      _p += strlen(_p) + 1;
    }
  """.}
proc insertItem*(c: Combo, index: cint, text: QString) {.importcpp: "#->insertItem(#, #)".}
proc removeItem*(c: Combo, index: cint) {.importcpp: "#->removeItem(#)".}
proc clear*(c: Combo) {.importcpp: "#->clear()".}
proc currentIndex*(c: Combo): int =
  var v: cint
  {.emit: "`v` = `c`->currentIndex();".}
  result = v.int
proc setCurrentIndex*(c: Combo, i: cint) {.importcpp: "#->setCurrentIndex(#)".}
proc currentText*(c: Combo): string =
  var p: cstring
  {.emit: "static QByteArray _bcmb; _bcmb = `c`->currentText().toUtf8(); `p` = _bcmb.constData();".}
  result = $p
proc setCurrentText*(c: Combo, s: QString) {.importcpp: "#->setCurrentText(#)".}
proc itemText*(c: Combo, i: cint): string =
  var p: cstring
  {.emit: "static QByteArray _bcit; _bcit = `c`->itemText(`i`).toUtf8(); `p` = _bcit.constData();".}
  result = $p
proc count*(c: Combo): int =
  var v: cint
  {.emit: "`v` = `c`->count();".}
  result = v.int
proc setEditable*(c: Combo, b: bool) {.importcpp: "#->setEditable(#)".}
proc setMaxVisibleItems*(c: Combo, n: cint) {.importcpp: "#->setMaxVisibleItems(#)".}
proc setInsertPolicy*(c: Combo, p: cint) =
  {.emit: "`c`->setInsertPolicy((QComboBox::InsertPolicy)`p`);".}
proc setMaxCount*(c: Combo, n: cint) {.importcpp: "#->setMaxCount(#)".}
proc setSizeAdjustPolicy*(c: Combo, p: cint) =
  {.emit: "`c`->setSizeAdjustPolicy((QComboBox::SizeAdjustPolicy)`p`);".}
proc setDuplicatesEnabled*(c: Combo, b: bool) {.importcpp: "#->setDuplicatesEnabled(#)".}
proc setStyleSheet*(c: Combo, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setCompleter*(c: Combo, comp: Compltr) {.importcpp: "#->setCompleter(#)".}
proc findText*(c: Combo, text: QString): int =
  var v: cint
  {.emit: "`v` = `c`->findText(`text`);".}
  result = v.int

proc onComboCurrentIndexChanged*(c: Combo, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, QOverload<int>::of(&QComboBox::currentIndexChanged), [=](int _i){
      `cb`(_i, `ud`);
    });
  """.}

proc onComboTextActivated*(c: Combo, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, &QComboBox::textActivated, [=](const QString& _t){
      static QByteArray _bcta; _bcta = _t.toUtf8();
      `cb`(_bcta.constData(), `ud`);
    });
  """.}

proc newFontComboBox*(parent: W = nil): FCombo {.importcpp: "new QFontComboBox(#)".}
proc currentFont*(fc: FCombo): string =
  var p: cstring
  {.emit: "static QByteArray _bfcf; _bfcf = `fc`->currentFont().family().toUtf8(); `p` = _bfcf.constData();".}
  result = $p
proc setCurrentFont*(fc: FCombo, family: string) =
  let cs = family.cstring
  {.emit: "`fc`->setCurrentFont(QFont(QString::fromUtf8(`cs`)));".}

# ═══════════════════════════════════════════════════════════════════════════════
# QLCDNumber
# ═══════════════════════════════════════════════════════════════════════════════

proc newLCDNumber*(digits: cint = 5, parent: W = nil): LCD {.importcpp: "new QLCDNumber(#, #)".}
proc display*(l: LCD, v: cdouble) {.importcpp: "#->display(#)".}
proc display*(l: LCD, v: cint) {.importcpp: "#->display(#)".}
proc display*(l: LCD, s: cstring) {.importcpp: "#->display(#)".}
proc setDigitCount*(l: LCD, n: cint) {.importcpp: "#->setDigitCount(#)".}
proc setMode*(l: LCD, m: cint) =
  {.emit: "`l`->setMode((QLCDNumber::Mode)`m`);".}
proc setSegmentStyle*(l: LCD, s: cint) =
  {.emit: "`l`->setSegmentStyle((QLCDNumber::SegmentStyle)`s`);".}
proc value*(l: LCD): float64 =
  var v: cdouble
  {.emit: "`v` = `l`->value();".}
  result = v.float64
proc setStyleSheet*(l: LCD, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QGroupBox
# ═══════════════════════════════════════════════════════════════════════════════

proc newGroupBox*(title: QString, parent: W = nil): Grp {.importcpp: "new QGroupBox(#, #)".}
proc setTitle*(g: Grp, s: QString) {.importcpp: "#->setTitle(#)".}
proc title*(g: Grp): string =
  var p: cstring
  {.emit: "static QByteArray _bgbt; _bgbt = `g`->title().toUtf8(); `p` = _bgbt.constData();".}
  result = $p
proc setCheckable*(g: Grp, b: bool) {.importcpp: "#->setCheckable(#)".}
proc isChecked*(g: Grp): bool =
  var r: cint
  {.emit: "`r` = `g`->isChecked() ? 1 : 0;".}
  result = r == 1
proc setChecked*(g: Grp, b: bool) {.importcpp: "#->setChecked(#)".}
proc setFlat*(g: Grp, b: bool) {.importcpp: "#->setFlat(#)".}
proc setLayout*(g: Grp, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(g: Grp, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(g: Grp, l: Grid) {.importcpp: "#->setLayout(#)".}
proc setLayout*(g: Grp, l: Form) {.importcpp: "#->setLayout(#)".}
proc setStyleSheet*(g: Grp, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setAlignment*(g: Grp, a: cint) =
  {.emit: "`g`->setAlignment((Qt::Alignment)`a`);".}

proc onGroupBoxToggled*(g: Grp, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`g`, &QGroupBox::toggled, [=](bool _b){
      `cb`(_b ? 1 : 0, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QFrame
# ═══════════════════════════════════════════════════════════════════════════════

proc newFrame*(parent: W = nil): Frm {.importcpp: "new QFrame(#)".}
proc setFrameShape*(f: Frm, s: cint) =
  {.emit: "`f`->setFrameShape((QFrame::Shape)`s`);".}
proc setFrameShadow*(f: Frm, s: cint) =
  {.emit: "`f`->setFrameShadow((QFrame::Shadow)`s`);".}
proc setLineWidth*(f: Frm, w: cint) {.importcpp: "#->setLineWidth(#)".}
proc setMidLineWidth*(f: Frm, w: cint) {.importcpp: "#->setMidLineWidth(#)".}
proc setLayout*(f: Frm, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(f: Frm, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(f: Frm, l: Grid) {.importcpp: "#->setLayout(#)".}
proc setStyleSheet*(f: Frm, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setMinH*(f: Frm, h: cint) {.importcpp: "#->setMinimumHeight(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QStackedWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newStackedWidget*(parent: W = nil): Stack {.importcpp: "new QStackedWidget(#)".}
proc addPage*(s: Stack, w: W): int =
  var v: cint
  {.emit: "`v` = `s`->addWidget(`w`);".}
  result = v.int
proc insertPage*(s: Stack, index: cint, w: W): int =
  var v: cint
  {.emit: "`v` = `s`->insertWidget(`index`, `w`);".}
  result = v.int
proc removePage*(s: Stack, w: W) {.importcpp: "#->removeWidget(#)".}
proc currentIndex*(s: Stack): int =
  var v: cint
  {.emit: "`v` = `s`->currentIndex();".}
  result = v.int
proc setCurrentIndex*(s: Stack, i: cint) {.importcpp: "#->setCurrentIndex(#)".}
proc setCurrentWidget*(s: Stack, w: W) {.importcpp: "#->setCurrentWidget(#)".}
proc currentWidget*(s: Stack): W {.importcpp: "(QWidget*)#->currentWidget()".}
proc count*(s: Stack): int =
  var v: cint
  {.emit: "`v` = `s`->count();".}
  result = v.int

proc onStackCurrentChanged*(s: Stack, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QStackedWidget::currentChanged, [=](int _i){
      `cb`(_i, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QTabWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newTabWidget*(parent: W = nil): Tab {.importcpp: "new QTabWidget(#)".}
proc addTab*(t: Tab, w: W, label: QString): int =
  var v: cint
  {.emit: "`v` = `t`->addTab(`w`, `label`);".}
  result = v.int
proc insertTab*(t: Tab, index: cint, w: W, label: QString): int =
  var v: cint
  {.emit: "`v` = `t`->insertTab(`index`, `w`, `label`);".}
  result = v.int
proc removeTab*(t: Tab, index: cint) {.importcpp: "#->removeTab(#)".}
proc currentIndex*(t: Tab): int =
  var v: cint
  {.emit: "`v` = `t`->currentIndex();".}
  result = v.int
proc setCurrentIndex*(t: Tab, i: cint) {.importcpp: "#->setCurrentIndex(#)".}
proc currentWidget*(t: Tab): W {.importcpp: "(QWidget*)#->currentWidget()".}
proc setCurrentWidget*(t: Tab, w: W) {.importcpp: "#->setCurrentWidget(#)".}
proc count*(t: Tab): int =
  var v: cint
  {.emit: "`v` = `t`->count();".}
  result = v.int
proc setTabText*(t: Tab, i: cint, s: QString) {.importcpp: "#->setTabText(#, #)".}
proc tabText*(t: Tab, i: cint): string =
  var p: cstring
  {.emit: "static QByteArray _btabt; _btabt = `t`->tabText(`i`).toUtf8(); `p` = _btabt.constData();".}
  result = $p
proc setTabEnabled*(t: Tab, i: cint, b: bool) {.importcpp: "#->setTabEnabled(#, #)".}
proc setTabVisible*(t: Tab, i: cint, b: bool) {.importcpp: "#->setTabVisible(#, #)".}
proc setTabToolTip*(t: Tab, i: cint, s: QString) {.importcpp: "#->setTabToolTip(#, #)".}
proc setTabPosition*(t: Tab, pos: cint) =
  {.emit: "`t`->setTabPosition((QTabWidget::TabPosition)`pos`);".}
proc setTabShape*(t: Tab, s: cint) =
  {.emit: "`t`->setTabShape((QTabWidget::TabShape)`s`);".}
proc setMovable*(t: Tab, b: bool) {.importcpp: "#->setMovable(#)".}
proc setDocumentMode*(t: Tab, b: bool) {.importcpp: "#->setDocumentMode(#)".}
proc setTabsClosable*(t: Tab, b: bool) {.importcpp: "#->setTabsClosable(#)".}
proc setUsesScrollButtons*(t: Tab, b: bool) {.importcpp: "#->setUsesScrollButtons(#)".}
proc setElideMode*(t: Tab, mode: cint) =
  {.emit: "`t`->setElideMode((Qt::TextElideMode)`mode`);".}
proc setStyleSheet*(t: Tab, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc widget*(t: Tab, i: cint): W {.importcpp: "(QWidget*)#->widget(#)".}
proc indexOf*(t: Tab, w: W): int =
  var v: cint
  {.emit: "`v` = `t`->indexOf(`w`);".}
  result = v.int

proc onTabCurrentChanged*(t: Tab, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTabWidget::currentChanged, [=](int _i){
      `cb`(_i, `ud`);
    });
  """.}

proc onTabCloseRequested*(t: Tab, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTabWidget::tabCloseRequested, [=](int _i){
      `cb`(_i, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QSplitter
# ═══════════════════════════════════════════════════════════════════════════════

proc newSplitter*(orientation: cint, parent: W = nil): Splt =
  {.emit: "`result` = new QSplitter((Qt::Orientation)`orientation`, `parent`);".}
proc newHSplitter*(parent: W = nil): Splt =
  {.emit: "`result` = new QSplitter(Qt::Horizontal, `parent`);".}
proc newVSplitter*(parent: W = nil): Splt =
  {.emit: "`result` = new QSplitter(Qt::Vertical, `parent`);".}
proc addWidget*(sp: Splt, w: W) {.importcpp: "#->addWidget(#)".}
proc insertWidget*(sp: Splt, index: cint, w: W) {.importcpp: "#->insertWidget(#, #)".}
proc setCollapsible*(sp: Splt, index: cint, b: bool) {.importcpp: "#->setCollapsible(#, #)".}
proc setHandleWidth*(sp: Splt, w: cint) {.importcpp: "#->setHandleWidth(#)".}
proc setChildrenCollapsible*(sp: Splt, b: bool) {.importcpp: "#->setChildrenCollapsible(#)".}
proc setOpaqueResize*(sp: Splt, b: bool) {.importcpp: "#->setOpaqueResize(#)".}
proc setSizes*(sp: Splt, sizes: seq[int]) =
  ## Set splitter sizes
  var s0, s1, s2, s3: cint = 0
  var n = sizes.len
  if n > 0: s0 = sizes[0].cint
  if n > 1: s1 = sizes[1].cint
  if n > 2: s2 = sizes[2].cint
  if n > 3: s3 = sizes[3].cint
  let cnt = n.cint
  {.emit: """
    QList<int> _sl;
    if (`cnt` > 0) _sl.append(`s0`);
    if (`cnt` > 1) _sl.append(`s1`);
    if (`cnt` > 2) _sl.append(`s2`);
    if (`cnt` > 3) _sl.append(`s3`);
    `sp`->setSizes(_sl);
  """.}
proc count*(sp: Splt): int =
  var v: cint
  {.emit: "`v` = `sp`->count();".}
  result = v.int
proc setStyleSheet*(sp: Splt, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onSplitterMoved*(sp: Splt, cb: proc(pos, index: cint, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`sp`, &QSplitter::splitterMoved, [=](int _pos, int _idx){
      `cb`(_pos, _idx, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QScrollArea
# ═══════════════════════════════════════════════════════════════════════════════

proc newScrollArea*(parent: W = nil): Scroll {.importcpp: "new QScrollArea(#)".}
proc setWidget*(s: Scroll, w: W) {.importcpp: "#->setWidget(#)".}
proc widget*(s: Scroll): W {.importcpp: "(QWidget*)#->widget()".}
proc setResizable*(s: Scroll, b: bool) {.importcpp: "#->setWidgetResizable(#)".}
proc setAlignment*(s: Scroll, a: cint) =
  {.emit: "`s`->setAlignment((Qt::Alignment)`a`);".}
proc setHorizontalScrollBarPolicy*(s: Scroll, p: cint) =
  {.emit: "`s`->setHorizontalScrollBarPolicy((Qt::ScrollBarPolicy)`p`);".}
proc setVerticalScrollBarPolicy*(s: Scroll, p: cint) =
  {.emit: "`s`->setVerticalScrollBarPolicy((Qt::ScrollBarPolicy)`p`);".}
proc ensureVisible*(s: Scroll, x, y: cint; xm: cint = 50; ym: cint = 50) {.importcpp: "#->ensureVisible(#, #, #, #)".}
proc setStyleSheet*(s: Scroll, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QDockWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newDockWidget*(title: QString, parent: Win): Dock {.importcpp: "new QDockWidget(#, #)".}
proc newDockWidget*(title: QString): Dock {.importcpp: "new QDockWidget(#)".}
proc setWidget*(d: Dock, w: W) {.importcpp: "#->setWidget(#)".}
proc dockWidget*(d: Dock): W {.importcpp: "(QWidget*)#->widget()".}
proc setAllowedAreas*(d: Dock, areas: cint) =
  {.emit: "`d`->setAllowedAreas((Qt::DockWidgetAreas)`areas`);".}
proc setFeatures*(d: Dock, f: cint) =
  {.emit: "`d`->setFeatures((QDockWidget::DockWidgetFeatures)`f`);".}
proc setFloating*(d: Dock, b: bool) {.importcpp: "#->setFloating(#)".}
proc isFloating*(d: Dock): bool =
  var r: cint
  {.emit: "`r` = `d`->isFloating() ? 1 : 0;".}
  result = r == 1
proc setTitleBarWidget*(d: Dock, w: W) {.importcpp: "#->setTitleBarWidget(#)".}
proc setWindowTitle*(d: Dock, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc setStyleSheet*(d: Dock, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onDockVisibilityChanged*(d: Dock, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`d`, &QDockWidget::visibilityChanged, [=](bool _v){
      `cb`(_v ? 1 : 0, `ud`);
    });
  """.}

proc onDockTopLevelChanged*(d: Dock, cb: CBBool, ud: pointer) =
  {.emit: """
    QObject::connect(`d`, &QDockWidget::topLevelChanged, [=](bool _v){
      `cb`(_v ? 1 : 0, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QMdiArea / QMdiSubWindow
# ═══════════════════════════════════════════════════════════════════════════════

proc newMdiArea*(parent: W = nil): Mdi {.importcpp: "new QMdiArea(#)".}
proc addSubWindow*(m: Mdi, w: W): MdiSub =
  {.emit: "`result` = `m`->addSubWindow(`w`);".}
proc activateNextSubWindow*(m: Mdi) {.importcpp: "#->activateNextSubWindow()".}
proc activatePreviousSubWindow*(m: Mdi) {.importcpp: "#->activatePreviousSubWindow()".}
proc tileSubWindows*(m: Mdi) {.importcpp: "#->tileSubWindows()".}
proc cascadeSubWindows*(m: Mdi) {.importcpp: "#->cascadeSubWindows()".}
proc closeAllSubWindows*(m: Mdi) {.importcpp: "#->closeAllSubWindows()".}
proc setViewMode*(m: Mdi, mode: cint) =
  {.emit: "`m`->setViewMode((QMdiArea::ViewMode)`mode`);".}
proc setTabsMovable*(m: Mdi, b: bool) {.importcpp: "#->setTabsMovable(#)".}
proc setTabsClosable*(m: Mdi, b: bool) {.importcpp: "#->setTabsClosable(#)".}
proc currentSubWindow*(m: Mdi): MdiSub {.importcpp: "#->currentSubWindow()".}
proc setStyleSheet*(m: Mdi, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc show*(sub: MdiSub) {.importcpp: "#->show()".}
proc showMaximized*(sub: MdiSub) {.importcpp: "#->showMaximized()".}
proc showMinimized*(sub: MdiSub) {.importcpp: "#->showMinimized()".}
proc showNormal*(sub: MdiSub) {.importcpp: "#->showNormal()".}
proc close*(sub: MdiSub) {.importcpp: "#->close()".}
proc setWidget*(sub: MdiSub, w: W) {.importcpp: "#->setWidget(#)".}
proc widget*(sub: MdiSub): W {.importcpp: "(QWidget*)#->widget()".}
proc setWindowTitle*(sub: MdiSub, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc resize*(sub: MdiSub, w, h: cint) {.importcpp: "#->resize(#, #)".}
proc move*(sub: MdiSub, x, y: cint) {.importcpp: "#->move(#, #)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QListWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newListWidget*(parent: W = nil): LW {.importcpp: "new QListWidget(#)".}
proc addItem*(lw: LW, text: QString) {.importcpp: "#->addItem(#)".}
proc addItem*(lw: LW, item: LWI) {.importcpp: "#->addItem(#)".}
proc addItems*(lw: LW, items: seq[string]) =
  var joined = ""
  for i, s in items:
    if i > 0: joined.add('\0')
    joined.add(s)
  let data = joined.cstring; let n = items.len.cint
  {.emit: """
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      `lw`->addItem(QString::fromUtf8(_p));
      _p += strlen(_p) + 1;
    }
  """.}
proc insertItem*(lw: LW, row: cint, text: QString) {.importcpp: "#->insertItem(#, #)".}
proc removeItemAt*(lw: LW, row: cint) =
  {.emit: "delete `lw`->takeItem(`row`);".}
proc takeItem*(lw: LW, row: cint): LWI {.importcpp: "#->takeItem(#)".}
proc clear*(lw: LW) {.importcpp: "#->clear()".}
proc count*(lw: LW): int =
  var v: cint
  {.emit: "`v` = `lw`->count();".}
  result = v.int
proc currentRow*(lw: LW): int =
  var v: cint
  {.emit: "`v` = `lw`->currentRow();".}
  result = v.int
proc setCurrentRow*(lw: LW, row: cint) {.importcpp: "#->setCurrentRow(#)".}
proc currentItem*(lw: LW): LWI {.importcpp: "#->currentItem()".}
proc item*(lw: LW, row: cint): LWI {.importcpp: "#->item(#)".}
proc itemText*(lw: LW, row: cint): string =
  var p: cstring
  {.emit: "static QByteArray _blwit; auto* _it = `lw`->item(`row`); if(_it){ _blwit=_it->text().toUtf8(); `p`=_blwit.constData(); } else `p`=\"\";".}
  result = $p
proc setItemText*(lw: LW, row: cint, s: QString) =
  {.emit: "if (auto* _it = `lw`->item(`row`)) _it->setText(`s`);".}
proc setSelectionMode*(lw: LW, mode: cint) =
  {.emit: "`lw`->setSelectionMode((QAbstractItemView::SelectionMode)`mode`);".}
proc setSelectionBehavior*(lw: LW, b: cint) =
  {.emit: "`lw`->setSelectionBehavior((QAbstractItemView::SelectionBehavior)`b`);".}
proc setAlternatingRowColors*(lw: LW, b: bool) {.importcpp: "#->setAlternatingRowColors(#)".}
proc setSortingEnabled*(lw: LW, b: bool) {.importcpp: "#->setSortingEnabled(#)".}
proc sortItems*(lw: LW, order: cint = 0) =
  {.emit: "`lw`->sortItems((Qt::SortOrder)`order`);".}
proc setDragDropMode*(lw: LW, mode: cint) =
  {.emit: "`lw`->setDragDropMode((QAbstractItemView::DragDropMode)`mode`);".}
proc setWordWrap*(lw: LW, b: bool) {.importcpp: "#->setWordWrap(#)".}
proc setSpacing*(lw: LW, s: cint) {.importcpp: "#->setSpacing(#)".}
proc setGridSize*(lw: LW, w, h: cint) =
  {.emit: "`lw`->setGridSize(QSize(`w`, `h`));".}
proc setIconSize*(lw: LW, w, h: cint) =
  {.emit: "`lw`->setIconSize(QSize(`w`, `h`));".}
proc setViewMode*(lw: LW, mode: cint) =
  {.emit: "`lw`->setViewMode((QListView::ViewMode)`mode`);".}
proc setStyleSheet*(lw: LW, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc scrollToItem*(lw: LW, item: LWI, hint: cint = 0) =
  {.emit: "`lw`->scrollToItem(`item`, (QAbstractItemView::ScrollHint)`hint`);".}
proc scrollToTop*(lw: LW) {.importcpp: "#->scrollToTop()".}
proc scrollToBottom*(lw: LW) {.importcpp: "#->scrollToBottom()".}

proc onLWCurrentRowChanged*(lw: LW, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`lw`, &QListWidget::currentRowChanged, [=](int _r){
      `cb`(_r, `ud`);
    });
  """.}

proc onLWItemClicked*(lw: LW, cb: proc(item: LWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`lw`, &QListWidget::itemClicked, [=](QListWidgetItem* _it){
      `cb`(_it, `ud`);
    });
  """.}

proc onLWItemDoubleClicked*(lw: LW, cb: proc(item: LWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`lw`, &QListWidget::itemDoubleClicked, [=](QListWidgetItem* _it){
      `cb`(_it, `ud`);
    });
  """.}

proc onLWItemChanged*(lw: LW, cb: proc(item: LWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`lw`, &QListWidget::itemChanged, [=](QListWidgetItem* _it){
      `cb`(_it, `ud`);
    });
  """.}

proc onLWSelectionChanged*(lw: LW, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`lw`, &QListWidget::itemSelectionChanged, [=](){
      `cb`(`ud`);
    });
  """.}

# ── QListWidgetItem ───────────────────────────────────────────────────────────

proc newLWI*(text: QString): LWI {.importcpp: "new QListWidgetItem(#)".}
proc newLWI*(): LWI {.importcpp: "new QListWidgetItem()".}
proc lwiText*(i: LWI): string =
  var p: cstring
  {.emit: "static QByteArray _blwi; _blwi = `i`->text().toUtf8(); `p` = _blwi.constData();".}
  result = $p
proc lwiSetText*(i: LWI, s: QString) {.importcpp: "#->setText(#)".}
proc lwiSetCheckState*(i: LWI, s: cint) =
  {.emit: "`i`->setCheckState((Qt::CheckState)`s`);".}
proc lwiCheckState*(i: LWI): int =
  var v: cint
  {.emit: "`v` = (int)`i`->checkState();".}
  result = v.int
proc lwiSetData*(i: LWI, role: cint, v: QVariant) {.importcpp: "#->setData(#, #)".}
proc lwiData*(i: LWI, role: cint): QVariant {.importcpp: "#->data(#)".}
proc lwiSetToolTip*(i: LWI, s: QString) {.importcpp: "#->setToolTip(#)".}
proc lwiSetSelected*(i: LWI, b: bool) {.importcpp: "#->setSelected(#)".}
proc lwiIsSelected*(i: LWI): bool =
  var r: cint
  {.emit: "`r` = `i`->isSelected() ? 1 : 0;".}
  result = r == 1
proc lwiSetFlags*(i: LWI, f: cint) =
  {.emit: "`i`->setFlags((Qt::ItemFlags)`f`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# QTreeWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newTreeWidget*(parent: W = nil): TW {.importcpp: "new QTreeWidget(#)".}
proc setColCount*(t: TW, n: cint) {.importcpp: "#->setColumnCount(#)".}
proc colCount*(t: TW): int =
  var v: cint
  {.emit: "`v` = `t`->columnCount();".}
  result = v.int
proc expandAll*(t: TW) {.importcpp: "#->expandAll()".}
proc collapseAll*(t: TW) {.importcpp: "#->collapseAll()".}
proc setStyleSheet*(t: TW, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setAltColors*(t: TW, b: bool) {.importcpp: "#->setAlternatingRowColors(#)".}
proc setAnimated*(t: TW, b: bool) {.importcpp: "#->setAnimated(#)".}
proc resizeCol*(t: TW, col: cint) {.importcpp: "#->resizeColumnToContents(#)".}
proc setColumnWidth*(t: TW, col, width: cint) {.importcpp: "#->setColumnWidth(#, #)".}
proc setColumnHidden*(t: TW, col: cint, hide: bool) {.importcpp: "#->setColumnHidden(#, #)".}
proc setSortingEnabled*(t: TW, b: bool) {.importcpp: "#->setSortingEnabled(#)".}
proc sortByColumn*(t: TW, col: cint, order: cint = 0) =
  {.emit: "`t`->sortByColumn(`col`, (Qt::SortOrder)`order`);".}
proc setSelectionMode*(t: TW, mode: cint) =
  {.emit: "`t`->setSelectionMode((QAbstractItemView::SelectionMode)`mode`);".}
proc setSelectionBehavior*(t: TW, b: cint) =
  {.emit: "`t`->setSelectionBehavior((QAbstractItemView::SelectionBehavior)`b`);".}
proc setRootIsDecorated*(t: TW, b: bool) {.importcpp: "#->setRootIsDecorated(#)".}
proc setItemsExpandable*(t: TW, b: bool) {.importcpp: "#->setItemsExpandable(#)".}
proc setDragDropMode*(t: TW, mode: cint) =
  {.emit: "`t`->setDragDropMode((QAbstractItemView::DragDropMode)`mode`);".}
proc setDragEnabled*(t: TW, b: bool) {.importcpp: "#->setDragEnabled(#)".}
proc clear*(t: TW) {.importcpp: "#->clear()".}
proc topLevelItemCount*(t: TW): int =
  var v: cint
  {.emit: "`v` = `t`->topLevelItemCount();".}
  result = v.int
proc topLevelItem*(t: TW, i: cint): TWI {.importcpp: "#->topLevelItem(#)".}
proc currentItem*(t: TW): TWI {.importcpp: "#->currentItem()".}
proc setCurrentItem*(t: TW, item: TWI) {.importcpp: "#->setCurrentItem(#)".}
proc invisibleRootItem*(t: TW): TWI {.importcpp: "#->invisibleRootItem()".}
proc scrollToItem*(t: TW, item: TWI, hint: cint = 0) =
  {.emit: "`t`->scrollToItem(`item`, (QAbstractItemView::ScrollHint)`hint`);".}

proc setHeaders*(t: TW, labels: openArray[string]) =
  var joined = ""
  for i, s in labels:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = labels.len.cint
  {.emit: """
    QStringList _sl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _sl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `t`->setHeaderLabels(_sl);
  """.}

proc setHeaderHidden*(t: TW, b: bool) {.importcpp: "#->setHeaderHidden(#)".}

proc addTopItem*(t: TW, texts: openArray[string]): TWI =
  let n = texts.len.cint
  var joined = ""
  for i, s in texts:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    `result` = new QTreeWidgetItem(`t`);
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      `result`->setText(i, QString::fromUtf8(_p));
      _p += strlen(_p) + 1;
    }
  """.}

proc addTopItem*(t: TW, text: string): TWI =
  let cs = text.cstring
  {.emit: """
    `result` = new QTreeWidgetItem(`t`);
    `result`->setText(0, QString::fromUtf8(`cs`));
  """.}

proc addChild*(parent: TWI, texts: openArray[string]): TWI =
  let n = texts.len.cint
  var joined = ""
  for i, s in texts:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    `result` = new QTreeWidgetItem(`parent`);
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      `result`->setText(i, QString::fromUtf8(_p));
      _p += strlen(_p) + 1;
    }
  """.}

proc addChild*(parent: TWI, c0: string, c1: string = ""): TWI =
  let s0 = c0.cstring; let s1 = c1.cstring
  {.emit: """
    `result` = new QTreeWidgetItem(`parent`);
    `result`->setText(0, QString::fromUtf8(`s0`));
    if (`s1`[0]) `result`->setText(1, QString::fromUtf8(`s1`));
  """.}

proc onTWCurrentItemChanged*(t: TW, cb: proc(cur, prev: TWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTreeWidget::currentItemChanged,
      [=](QTreeWidgetItem* _cur, QTreeWidgetItem* _prev){
        `cb`(_cur, _prev, `ud`);
      });
  """.}

proc onTWItemClicked*(t: TW, cb: proc(item: TWI, col: cint, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTreeWidget::itemClicked,
      [=](QTreeWidgetItem* _it, int _col){
        `cb`(_it, _col, `ud`);
      });
  """.}

proc onTWItemDoubleClicked*(t: TW, cb: proc(item: TWI, col: cint, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTreeWidget::itemDoubleClicked,
      [=](QTreeWidgetItem* _it, int _col){
        `cb`(_it, _col, `ud`);
      });
  """.}

proc onTWItemExpanded*(t: TW, cb: proc(item: TWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTreeWidget::itemExpanded,
      [=](QTreeWidgetItem* _it){ `cb`(_it, `ud`); });
  """.}

proc onTWItemCollapsed*(t: TW, cb: proc(item: TWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTreeWidget::itemCollapsed,
      [=](QTreeWidgetItem* _it){ `cb`(_it, `ud`); });
  """.}

proc onTWSelectionChanged*(t: TW, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTreeWidget::itemSelectionChanged, [=](){
      `cb`(`ud`);
    });
  """.}

# ── QTreeWidgetItem ───────────────────────────────────────────────────────────

proc twiText*(i: TWI, col: cint = 0): string =
  var p: cstring
  {.emit: "static QByteArray _btwi; _btwi = `i`->text(`col`).toUtf8(); `p` = _btwi.constData();".}
  result = $p
proc twiSetText*(i: TWI, col: cint, s: QString) {.importcpp: "#->setText(#, #)".}
proc twiSetCheckState*(i: TWI, col: cint, s: cint) =
  {.emit: "`i`->setCheckState(`col`, (Qt::CheckState)`s`);".}
proc twiCheckState*(i: TWI, col: cint): int =
  var v: cint
  {.emit: "`v` = (int)`i`->checkState(`col`);".}
  result = v.int
proc twiSetData*(i: TWI, col, role: cint, v: QVariant) {.importcpp: "#->setData(#, #, #)".}
proc twiSetFlags*(i: TWI, f: cint) =
  {.emit: "`i`->setFlags((Qt::ItemFlags)`f`);".}
proc twiSetExpanded*(i: TWI, b: bool) {.importcpp: "#->setExpanded(#)".}
proc twiIsExpanded*(i: TWI): bool =
  var r: cint
  {.emit: "`r` = `i`->isExpanded() ? 1 : 0;".}
  result = r == 1
proc twiChildCount*(i: TWI): int =
  var v: cint
  {.emit: "`v` = `i`->childCount();".}
  result = v.int
proc twiChild*(i: TWI, idx: cint): TWI {.importcpp: "#->child(#)".}
proc twiParent*(i: TWI): TWI {.importcpp: "#->parent()".}
proc twiSetHidden*(i: TWI, b: bool) {.importcpp: "#->setHidden(#)".}
proc twiSetSelected*(i: TWI, b: bool) {.importcpp: "#->setSelected(#)".}
proc twiSetToolTip*(i: TWI, col: cint, s: QString) {.importcpp: "#->setToolTip(#, #)".}
proc twiAddChild*(parent: TWI, child: TWI) {.importcpp: "#->addChild(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QTableWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newTableWidget*(rows, cols: cint, parent: W = nil): TblW {.importcpp: "new QTableWidget(#, #, #)".}
proc newTableWidget*(parent: W = nil): TblW {.importcpp: "new QTableWidget(#)".}
proc setRowCount*(t: TblW, n: cint) {.importcpp: "#->setRowCount(#)".}
proc setColumnCount*(t: TblW, n: cint) {.importcpp: "#->setColumnCount(#)".}
proc rowCount*(t: TblW): int =
  var v: cint
  {.emit: "`v` = `t`->rowCount();".}
  result = v.int
proc columnCount*(t: TblW): int =
  var v: cint
  {.emit: "`v` = `t`->columnCount();".}
  result = v.int
proc setItem*(t: TblW, row, col: cint, item: TblWI) {.importcpp: "#->setItem(#, #, #)".}
proc item*(t: TblW, row, col: cint): TblWI {.importcpp: "#->item(#, #)".}
proc takeItem*(t: TblW, row, col: cint): TblWI {.importcpp: "#->takeItem(#, #)".}
proc itemText*(t: TblW, row, col: cint): string =
  var p: cstring
  {.emit: "static QByteArray _btit; auto* _i=`t`->item(`row`,`col`); if(_i){_btit=_i->text().toUtf8();`p`=_btit.constData();}else `p`=\"\";".}
  result = $p
proc setItemText*(t: TblW, row, col: cint, s: QString) =
  {.emit: """
    auto* _it = `t`->item(`row`, `col`);
    if (!_it) { _it = new QTableWidgetItem(); `t`->setItem(`row`, `col`, _it); }
    _it->setText(`s`);
  """.}
proc setCellWidget*(t: TblW, row, col: cint, w: W) {.importcpp: "#->setCellWidget(#, #, #)".}
proc cellWidget*(t: TblW, row, col: cint): W {.importcpp: "(QWidget*)#->cellWidget(#, #)".}
proc removeCellWidget*(t: TblW, row, col: cint) {.importcpp: "#->removeCellWidget(#, #)".}
proc currentRow*(t: TblW): int =
  var v: cint
  {.emit: "`v` = `t`->currentRow();".}
  result = v.int
proc currentColumn*(t: TblW): int =
  var v: cint
  {.emit: "`v` = `t`->currentColumn();".}
  result = v.int
proc setCurrentCell*(t: TblW, row, col: cint) {.importcpp: "#->setCurrentCell(#, #)".}
proc insertRow*(t: TblW, row: cint) {.importcpp: "#->insertRow(#)".}
proc insertColumn*(t: TblW, col: cint) {.importcpp: "#->insertColumn(#)".}
proc removeRow*(t: TblW, row: cint) {.importcpp: "#->removeRow(#)".}
proc removeColumn*(t: TblW, col: cint) {.importcpp: "#->removeColumn(#)".}
proc clear*(t: TblW) {.importcpp: "#->clear()".}
proc clearContents*(t: TblW) {.importcpp: "#->clearContents()".}
proc setHorizontalHeaders*(t: TblW, labels: openArray[string]) =
  var joined = ""
  for i, s in labels:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = labels.len.cint
  {.emit: """
    QStringList _hl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _hl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `t`->setHorizontalHeaderLabels(_hl);
  """.}
proc setVerticalHeaders*(t: TblW, labels: openArray[string]) =
  var joined = ""
  for i, s in labels:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = labels.len.cint
  {.emit: """
    QStringList _vl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _vl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `t`->setVerticalHeaderLabels(_vl);
  """.}
proc setSelectionMode*(t: TblW, mode: cint) =
  {.emit: "`t`->setSelectionMode((QAbstractItemView::SelectionMode)`mode`);".}
proc setSelectionBehavior*(t: TblW, b: cint) =
  {.emit: "`t`->setSelectionBehavior((QAbstractItemView::SelectionBehavior)`b`);".}
proc setAlternatingRowColors*(t: TblW, b: bool) {.importcpp: "#->setAlternatingRowColors(#)".}
proc setSortingEnabled*(t: TblW, b: bool) {.importcpp: "#->setSortingEnabled(#)".}
proc sortByColumn*(t: TblW, col: cint, order: cint = 0) =
  {.emit: "`t`->sortByColumn(`col`, (Qt::SortOrder)`order`);".}
proc setWordWrap*(t: TblW, b: bool) {.importcpp: "#->setWordWrap(#)".}
proc setShowGrid*(t: TblW, b: bool) {.importcpp: "#->setShowGrid(#)".}
proc setGridStyle*(t: TblW, s: cint) =
  {.emit: "`t`->setGridStyle((Qt::PenStyle)`s`);".}
proc setSpan*(t: TblW, row, col, rowSpan, colSpan: cint) {.importcpp: "#->setSpan(#, #, #, #)".}
proc setRowHeight*(t: TblW, row, height: cint) {.importcpp: "#->setRowHeight(#, #)".}
proc setColumnWidth*(t: TblW, col, width: cint) {.importcpp: "#->setColumnWidth(#, #)".}
proc setColumnHidden*(t: TblW, col: cint, hide: bool) {.importcpp: "#->setColumnHidden(#, #)".}
proc setRowHidden*(t: TblW, row: cint, hide: bool) {.importcpp: "#->setRowHidden(#, #)".}
proc resizeColumnsToContents*(t: TblW) {.importcpp: "#->resizeColumnsToContents()".}
proc resizeRowsToContents*(t: TblW) {.importcpp: "#->resizeRowsToContents()".}
proc horizontalHeader*(t: TblW): HdrView {.importcpp: "#->horizontalHeader()".}
proc verticalHeader*(t: TblW): HdrView {.importcpp: "#->verticalHeader()".}
proc setStyleSheet*(t: TblW, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setEditTriggers*(t: TblW, triggers: cint) =
  {.emit: "`t`->setEditTriggers((QAbstractItemView::EditTriggers)`triggers`);".}

proc onTblCurrentCellChanged*(t: TblW,
    cb: proc(row, col, prevRow, prevCol: cint, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTableWidget::currentCellChanged,
      [=](int _r, int _c, int _pr, int _pc){
        `cb`(_r, _c, _pr, _pc, `ud`);
      });
  """.}

proc onTblItemClicked*(t: TblW, cb: proc(item: TblWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTableWidget::itemClicked, [=](QTableWidgetItem* _it){
      `cb`(_it, `ud`);
    });
  """.}

proc onTblItemDoubleClicked*(t: TblW, cb: proc(item: TblWI, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTableWidget::itemDoubleClicked, [=](QTableWidgetItem* _it){
      `cb`(_it, `ud`);
    });
  """.}

proc onTblSelectionChanged*(t: TblW, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTableWidget::itemSelectionChanged, [=](){
      `cb`(`ud`);
    });
  """.}

# ── QTableWidgetItem ──────────────────────────────────────────────────────────

proc newTblWI*(text: QString): TblWI {.importcpp: "new QTableWidgetItem(#)".}
proc newTblWI*(): TblWI {.importcpp: "new QTableWidgetItem()".}
proc twText*(i: TblWI): string =
  var p: cstring
  {.emit: "static QByteArray _btwi2; _btwi2 = `i`->text().toUtf8(); `p` = _btwi2.constData();".}
  result = $p
proc twSetText*(i: TblWI, s: QString) {.importcpp: "#->setText(#)".}
proc twSetData*(i: TblWI, role: cint, v: QVariant) {.importcpp: "#->setData(#, #)".}
proc twSetFlags*(i: TblWI, f: cint) =
  {.emit: "`i`->setFlags((Qt::ItemFlags)`f`);".}
proc twSetCheckState*(i: TblWI, s: cint) =
  {.emit: "`i`->setCheckState((Qt::CheckState)`s`);".}
proc twCheckState*(i: TblWI): int =
  var v: cint
  {.emit: "`v` = (int)`i`->checkState();".}
  result = v.int
proc twSetToolTip*(i: TblWI, s: QString) {.importcpp: "#->setToolTip(#)".}
proc twSetSelected*(i: TblWI, b: bool) {.importcpp: "#->setSelected(#)".}
proc twRow*(i: TblWI): int =
  var v: cint
  {.emit: "`v` = `i`->row();".}
  result = v.int
proc twColumn*(i: TblWI): int =
  var v: cint
  {.emit: "`v` = `i`->column();".}
  result = v.int
proc twSetTextAlignment*(i: TblWI, a: cint) =
  {.emit: "`i`->setTextAlignment(`a`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# QHeaderView
# ═══════════════════════════════════════════════════════════════════════════════

proc hdrSetResizeMode*(h: HdrView, section: cint, mode: cint) =
  {.emit: "`h`->setSectionResizeMode(`section`, (QHeaderView::ResizeMode)`mode`);".}
proc hdrSetResizeModeAll*(h: HdrView, mode: cint) =
  {.emit: "`h`->setSectionResizeMode((QHeaderView::ResizeMode)`mode`);".}
proc hdrSetStretchLastSection*(h: HdrView, b: bool) {.importcpp: "#->setStretchLastSection(#)".}
proc hdrSetMovable*(h: HdrView, b: bool) {.importcpp: "#->setSectionsMovable(#)".}
proc hdrSetClickable*(h: HdrView, b: bool) {.importcpp: "#->setSectionsClickable(#)".}
proc hdrSetHighlightSections*(h: HdrView, b: bool) {.importcpp: "#->setHighlightSections(#)".}
proc hdrSetDefaultSectionSize*(h: HdrView, size: cint) {.importcpp: "#->setDefaultSectionSize(#)".}
proc hdrSetMinimumSectionSize*(h: HdrView, size: cint) {.importcpp: "#->setMinimumSectionSize(#)".}
proc hdrHideSection*(h: HdrView, section: cint) {.importcpp: "#->hideSection(#)".}
proc hdrShowSection*(h: HdrView, section: cint) {.importcpp: "#->showSection(#)".}
proc hdrSectionCount*(h: HdrView): int =
  var v: cint
  {.emit: "`v` = `h`->count();".}
  result = v.int
proc hdrVisualIndex*(h: HdrView, logicalIndex: cint): int =
  var v: cint
  {.emit: "`v` = `h`->visualIndex(`logicalIndex`);".}
  result = v.int
proc hdrLogicalIndex*(h: HdrView, visualIndex: cint): int =
  var v: cint
  {.emit: "`v` = `h`->logicalIndex(`visualIndex`);".}
  result = v.int
proc hdrSectionSize*(h: HdrView, logicalIndex: cint): int =
  var v: cint
  {.emit: "`v` = `h`->sectionSize(`logicalIndex`);".}
  result = v.int
proc hdrResizeSection*(h: HdrView, logicalIndex, size: cint) {.importcpp: "#->resizeSection(#, #)".}
proc hdrSetCascadingSectionResizes*(h: HdrView, b: bool) {.importcpp: "#->setCascadingSectionResizes(#)".}
proc hdrSetSortIndicator*(h: HdrView, section: cint, order: cint) =
  {.emit: "`h`->setSortIndicator(`section`, (Qt::SortOrder)`order`);".}
proc hdrSetSortIndicatorShown*(h: HdrView, b: bool) {.importcpp: "#->setSortIndicatorShown(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QDateTimeEdit / QDateEdit / QTimeEdit
# ═══════════════════════════════════════════════════════════════════════════════

proc newDateTimeEdit*(parent: W = nil): DtTmEdit {.importcpp: "new QDateTimeEdit(#)".}
proc newDateEdit*(parent: W = nil): DtEdit {.importcpp: "new QDateEdit(#)".}
proc newTimeEdit*(parent: W = nil): TmEdit {.importcpp: "new QTimeEdit(#)".}

proc setDateTimeFormat*(e: DtTmEdit, fmt: QString) {.importcpp: "#->setDisplayFormat(#)".}
proc setDateFormat*(e: DtEdit, fmt: QString) {.importcpp: "#->setDisplayFormat(#)".}
proc setTimeFormat*(e: TmEdit, fmt: QString) {.importcpp: "#->setDisplayFormat(#)".}

proc setCalendarPopup*(e: DtTmEdit, b: bool) {.importcpp: "#->setCalendarPopup(#)".}
proc setCalendarPopup*(e: DtEdit, b: bool) {.importcpp: "#->setCalendarPopup(#)".}

proc dateTimeStr*(e: DtTmEdit, fmt: string = "yyyy-MM-dd HH:mm:ss"): string =
  let cs = fmt.cstring; var p: cstring
  {.emit: "static QByteArray _bdts; _bdts = `e`->dateTime().toString(QString::fromUtf8(`cs`)).toUtf8(); `p` = _bdts.constData();".}
  result = $p

proc dateStr*(e: DtEdit, fmt: string = "yyyy-MM-dd"): string =
  let cs = fmt.cstring; var p: cstring
  {.emit: "static QByteArray _bds; _bds = `e`->date().toString(QString::fromUtf8(`cs`)).toUtf8(); `p` = _bds.constData();".}
  result = $p

proc timeStr*(e: TmEdit, fmt: string = "HH:mm:ss"): string =
  let cs = fmt.cstring; var p: cstring
  {.emit: "static QByteArray _bts; _bts = `e`->time().toString(QString::fromUtf8(`cs`)).toUtf8(); `p` = _bts.constData();".}
  result = $p

proc setMinDateTime*(e: DtTmEdit, s: string) =
  let cs = s.cstring
  {.emit: "`e`->setMinimumDateTime(QDateTime::fromString(QString::fromUtf8(`cs`), Qt::ISODate));".}
proc setMaxDateTime*(e: DtTmEdit, s: string) =
  let cs = s.cstring
  {.emit: "`e`->setMaximumDateTime(QDateTime::fromString(QString::fromUtf8(`cs`), Qt::ISODate));".}
proc setDateTime*(e: DtTmEdit, s: string) =
  let cs = s.cstring
  {.emit: "`e`->setDateTime(QDateTime::fromString(QString::fromUtf8(`cs`), Qt::ISODate));".}
proc setCurrentDateTime*(e: DtTmEdit) =
  {.emit: "`e`->setDateTime(QDateTime::currentDateTime());".}

proc onDTEDateTimeChanged*(e: DtTmEdit, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`e`, &QDateTimeEdit::dateTimeChanged, [=](const QDateTime& _dt){
      static QByteArray _bdtc; _bdtc = _dt.toString(Qt::ISODate).toUtf8();
      `cb`(_bdtc.constData(), `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# Layouts
# ═══════════════════════════════════════════════════════════════════════════════

# ── QVBoxLayout ──────────────────────────────────────────────────────────────
proc newVBox*(parent: W = nil): VBox {.importcpp: "new QVBoxLayout(#)".}
proc add*(l: VBox, w: W)       {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Lbl)     {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Btn)     {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: TE)      {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: PTE)     {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: LE)      {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: LW)      {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: TW)      {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: TblW)    {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Tab)     {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Splt)    {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Grp)     {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Frm)     {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Scroll)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Stack)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Spin)    {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: DSpin)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Slider)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Prog)    {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Combo)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: ChkBox)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Radio)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Calendar){.importcpp: "#->addWidget(#)".}
proc addLayout*(l: VBox, sub: VBox)  {.importcpp: "#->addLayout(#)".}
proc addLayout*(l: VBox, sub: HBox)  {.importcpp: "#->addLayout(#)".}
proc addLayout*(l: VBox, sub: Grid)  {.importcpp: "#->addLayout(#)".}
proc addLayout*(l: VBox, sub: Form)  {.importcpp: "#->addLayout(#)".}
proc stretch*(l: VBox) {.importcpp: "#->addStretch()".}
proc stretch*(l: VBox, factor: cint) {.importcpp: "#->addStretch(#)".}
proc addSpacing*(l: VBox, size: cint) {.importcpp: "#->addSpacing(#)".}
proc setSpacing*(l: VBox, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setMargins*(l: VBox, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}
proc setContentsMargins*(l: VBox, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}

# ── QHBoxLayout ──────────────────────────────────────────────────────────────
proc newHBox*(parent: W = nil): HBox {.importcpp: "new QHBoxLayout(#)".}
proc add*(l: HBox, w: W)       {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Lbl)     {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Btn)     {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: TE)      {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: PTE)     {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: LE)      {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: LW)      {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: TW)      {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: TblW)    {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Tab)     {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Splt)    {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Grp)     {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Frm)     {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Scroll)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Stack)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Spin)    {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: DSpin)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Slider)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Prog)    {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Combo)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: ChkBox)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Radio)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: TBtn)    {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Calendar){.importcpp: "#->addWidget(#)".}
proc addLayout*(l: HBox, sub: VBox) {.importcpp: "#->addLayout(#)".}
proc addLayout*(l: HBox, sub: HBox) {.importcpp: "#->addLayout(#)".}
proc addLayout*(l: HBox, sub: Grid) {.importcpp: "#->addLayout(#)".}
proc addLayout*(l: HBox, sub: Form) {.importcpp: "#->addLayout(#)".}
proc stretch*(l: HBox) {.importcpp: "#->addStretch()".}
proc stretch*(l: HBox, factor: cint) {.importcpp: "#->addStretch(#)".}
proc addSpacing*(l: HBox, size: cint) {.importcpp: "#->addSpacing(#)".}
proc setSpacing*(l: HBox, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setMargins*(l: HBox, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}
proc setContentsMargins*(l: HBox, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}

# ── QGridLayout ──────────────────────────────────────────────────────────────
proc newGrid*(parent: W = nil): Grid {.importcpp: "new QGridLayout(#)".}
proc add*(l: Grid, w: W,       row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: Lbl,     row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: Btn,     row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: LE,      row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: TE,      row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: Combo,   row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: Spin,    row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: ChkBox,  row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc addSpan*(l: Grid, w: W, row, col, rowSpan, colSpan: cint) {.importcpp: "#->addWidget(#,#,#,#,#)".}
proc addSpan*(l: Grid, w: Lbl, row, col, rowSpan, colSpan: cint) {.importcpp: "#->addWidget(#,#,#,#,#)".}
proc addLayout*(l: Grid, sub: HBox, row, col: cint) {.importcpp: "#->addLayout(#,#,#)".}
proc addLayout*(l: Grid, sub: VBox, row, col: cint) {.importcpp: "#->addLayout(#,#,#)".}
proc setSpacing*(l: Grid, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setHorizontalSpacing*(l: Grid, px: cint) {.importcpp: "#->setHorizontalSpacing(#)".}
proc setVerticalSpacing*(l: Grid, px: cint) {.importcpp: "#->setVerticalSpacing(#)".}
proc setMargins*(l: Grid, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}
proc setContentsMargins*(l: Grid, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}
proc setColumnStretch*(l: Grid, col, stretch: cint) {.importcpp: "#->setColumnStretch(#,#)".}
proc setRowStretch*(l: Grid, row, stretch: cint) {.importcpp: "#->setRowStretch(#,#)".}
proc setColumnMinimumWidth*(l: Grid, col, minWidth: cint) {.importcpp: "#->setColumnMinimumWidth(#,#)".}
proc setRowMinimumHeight*(l: Grid, row, minHeight: cint) {.importcpp: "#->setRowMinimumHeight(#,#)".}

# ── QFormLayout ──────────────────────────────────────────────────────────────
proc newFormLayout*(parent: W = nil): Form {.importcpp: "new QFormLayout(#)".}
proc addRow*(f: Form, label: QString, field: W) =
  {.emit: "`f`->addRow(`label`, `field`);".}
proc addRow*(f: Form, label: Lbl, field: W) {.importcpp: "#->addRow(#, #)".}
proc addRow*(f: Form, label: Lbl, field: LE) {.importcpp: "#->addRow(#, #)".}
proc addRow*(f: Form, label: Lbl, field: Combo) {.importcpp: "#->addRow(#, #)".}
proc addRow*(f: Form, label: Lbl, field: Spin) {.importcpp: "#->addRow(#, #)".}
proc addRow*(f: Form, label: Lbl, field: HBox) {.importcpp: "#->addRow(#, #)".}
proc addRow*(f: Form, w: W) {.importcpp: "#->addRow(#)".}
proc insertRow*(f: Form, row: cint, label: QString, field: W) =
  {.emit: "`f`->insertRow(`row`, `label`, `field`);".}
proc removeRow*(f: Form, row: cint) {.importcpp: "#->removeRow(#)".}
proc setLabelAlignment*(f: Form, a: cint) =
  {.emit: "`f`->setLabelAlignment((Qt::Alignment)`a`);".}
proc setFormAlignment*(f: Form, a: cint) =
  {.emit: "`f`->setFormAlignment((Qt::Alignment)`a`);".}
proc setRowWrapPolicy*(f: Form, p: cint) =
  {.emit: "`f`->setRowWrapPolicy((QFormLayout::RowWrapPolicy)`p`);".}
proc setFieldGrowthPolicy*(f: Form, p: cint) =
  {.emit: "`f`->setFieldGrowthPolicy((QFormLayout::FieldGrowthPolicy)`p`);".}
proc setSpacing*(f: Form, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setContentsMargins*(f: Form, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}
proc rowCount*(f: Form): int =
  var v: cint
  {.emit: "`v` = `f`->rowCount();".}
  result = v.int

# ── QStackedLayout ───────────────────────────────────────────────────────────
proc newStackedLayout*(parent: W = nil): StkLyt {.importcpp: "new QStackedLayout(#)".}
proc addWidget*(l: StkLyt, w: W): int =
  var v: cint
  {.emit: "`v` = `l`->addWidget(`w`);".}
  result = v.int
proc setCurrentIndex*(l: StkLyt, i: cint) {.importcpp: "#->setCurrentIndex(#)".}
proc currentIndex*(l: StkLyt): int =
  var v: cint
  {.emit: "`v` = `l`->currentIndex();".}
  result = v.int
proc setStackingMode*(l: StkLyt, mode: cint) =
  {.emit: "`l`->setStackingMode((QStackedLayout::StackingMode)`mode`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# QCompleter
# ═══════════════════════════════════════════════════════════════════════════════

proc newCompleter*(words: seq[string], parent: W = nil): Compltr =
  var joined = ""
  for i, s in words:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = words.len.cint
  {.emit: """
    QStringList _clist;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _clist << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `result` = new QCompleter(_clist, (QObject*)`parent`);
  """.}
proc setCaseSensitivity*(c: Compltr, cs: cint) =
  {.emit: "`c`->setCaseSensitivity((Qt::CaseSensitivity)`cs`);".}
proc setCompletionMode*(c: Compltr, mode: cint) =
  {.emit: "`c`->setCompletionMode((QCompleter::CompletionMode)`mode`);".}
proc setMaxVisibleItems*(c: Compltr, n: cint) {.importcpp: "#->setMaxVisibleItems(#)".}
proc setFilterMode*(c: Compltr, flags: cint) =
  {.emit: "`c`->setFilterMode((Qt::MatchFlags)`flags`);".}
proc setModel*(c: Compltr, m: AIM) {.importcpp: "#->setModel(#)".}
proc setModelSorting*(c: Compltr, sorting: cint) =
  {.emit: "`c`->setModelSorting((QCompleter::ModelSorting)`sorting`);".}

proc onCompleterActivated*(c: Compltr, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, QOverload<const QString&>::of(&QCompleter::activated),
      [=](const QString& _t){
        static QByteArray _bca; _bca = _t.toUtf8();
        `cb`(_bca.constData(), `ud`);
      });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QShortcut
# ═══════════════════════════════════════════════════════════════════════════════

proc newShortcut*(keys: cstring, parent: W): Shortcut =
  {.emit: "`result` = new QShortcut(QKeySequence(QString::fromUtf8(`keys`)), `parent`);".}
proc setEnabled*(s: Shortcut, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setAutoRepeat*(s: Shortcut, b: bool) {.importcpp: "#->setAutoRepeat(#)".}
proc setContext*(s: Shortcut, ctx: cint) =
  {.emit: "`s`->setContext((Qt::ShortcutContext)`ctx`);".}

proc onShortcutActivated*(s: Shortcut, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QShortcut::activated, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QSystemTrayIcon
# ═══════════════════════════════════════════════════════════════════════════════

proc newTrayIcon*(parent: W = nil): Tray =
  {.emit: "`result` = new QSystemTrayIcon((QObject*)`parent`);".}
proc traySetVisible*(t: Tray, b: bool) {.importcpp: "#->setVisible(#)".}
proc traySetToolTip*(t: Tray, s: QString) {.importcpp: "#->setToolTip(#)".}
proc traySetContextMenu*(t: Tray, m: Menu) {.importcpp: "#->setContextMenu(#)".}
proc trayShow*(t: Tray) {.importcpp: "#->show()".}
proc trayHide*(t: Tray) {.importcpp: "#->hide()".}
proc trayShowMessage*(t: Tray, title, msg: QString, ms: cint = 3000) =
  {.emit: "`t`->showMessage(`title`, `msg`, QSystemTrayIcon::Information, `ms`);".}
proc trayIsAvailable*(): bool =
  var r: cint
  {.emit: "`r` = QSystemTrayIcon::isSystemTrayAvailable() ? 1 : 0;".}
  result = r == 1

proc onTrayActivated*(t: Tray, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QSystemTrayIcon::activated,
      [=](QSystemTrayIcon::ActivationReason _r){
        `cb`((int)_r, `ud`);
      });
  """.}

proc onTrayMessageClicked*(t: Tray, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QSystemTrayIcon::messageClicked, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QCalendarWidget
# ═══════════════════════════════════════════════════════════════════════════════

proc newCalendarWidget*(parent: W = nil): Calendar {.importcpp: "new QCalendarWidget(#)".}
proc setGridVisible*(c: Calendar, b: bool) {.importcpp: "#->setGridVisible(#)".}
proc setNavigationBarVisible*(c: Calendar, b: bool) {.importcpp: "#->setNavigationBarVisible(#)".}
proc setFirstDayOfWeek*(c: Calendar, day: cint) =
  {.emit: "`c`->setFirstDayOfWeek((Qt::DayOfWeek)`day`);".}
proc setMinimumDate*(c: Calendar, y, m, d: cint) =
  {.emit: "`c`->setMinimumDate(QDate(`y`, `m`, `d`));".}
proc setMaximumDate*(c: Calendar, y, m, d: cint) =
  {.emit: "`c`->setMaximumDate(QDate(`y`, `m`, `d`));".}
proc selectedDate*(c: Calendar): tuple[y, m, d: int] =
  var y, m, d: cint
  {.emit: "QDate _cd = `c`->selectedDate(); `y`=_cd.year(); `m`=_cd.month(); `d`=_cd.day();".}
  result = (y.int, m.int, d.int)
proc setSelectedDate*(c: Calendar, y, m, d: cint) =
  {.emit: "`c`->setSelectedDate(QDate(`y`, `m`, `d`));".}
proc setStyleSheet*(c: Calendar, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onCalendarSelectionChanged*(c: Calendar, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, &QCalendarWidget::selectionChanged, [=](){
      `cb`(`ud`);
    });
  """.}

proc onCalendarActivated*(c: Calendar, cb: proc(y, m, d: cint, ud: pointer) {.cdecl.}, ud: pointer) =
  {.emit: """
    QObject::connect(`c`, &QCalendarWidget::activated, [=](const QDate& _date){
      `cb`(_date.year(), _date.month(), _date.day(), `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QWizard / QWizardPage
# ═══════════════════════════════════════════════════════════════════════════════

proc newWizard*(parent: W = nil): Wizard {.importcpp: "new QWizard(#)".}
proc addPage*(wz: Wizard, page: WizPage): int =
  var v: cint
  {.emit: "`v` = `wz`->addPage(`page`);".}
  result = v.int
proc setPage*(wz: Wizard, id: cint, page: WizPage) {.importcpp: "#->setPage(#, #)".}
proc setStartId*(wz: Wizard, id: cint) {.importcpp: "#->setStartId(#)".}
proc setWizardStyle*(wz: Wizard, style: cint) =
  {.emit: "`wz`->setWizardStyle((QWizard::WizardStyle)`style`);".}
proc setOptions*(wz: Wizard, opts: cint) =
  {.emit: "`wz`->setOptions((QWizard::WizardOptions)`opts`);".}
proc setOption*(wz: Wizard, opt: cint, on: bool = true) =
  {.emit: "`wz`->setOption((QWizard::WizardOption)`opt`, `on`);".}
proc currentPage*(wz: Wizard): WizPage {.importcpp: "#->currentPage()".}
proc currentId*(wz: Wizard): int =
  var v: cint
  {.emit: "`v` = `wz`->currentId();".}
  result = v.int
proc page*(wz: Wizard, id: cint): WizPage {.importcpp: "#->page(#)".}
proc execWizard*(wz: Wizard): int =
  var v: cint
  {.emit: "`v` = `wz`->exec();".}
  result = v.int
proc setWindowTitle*(wz: Wizard, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc restart*(wz: Wizard) {.importcpp: "#->restart()".}

proc onWizardFinished*(wz: Wizard, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`wz`, &QDialog::finished, [=](int _r){
      `cb`(_r, `ud`);
    });
  """.}

proc newWizardPage*(parent: W = nil): WizPage {.importcpp: "new QWizardPage(#)".}
proc setPageTitle*(p: WizPage, s: QString) {.importcpp: "#->setTitle(#)".}
proc setPageSubTitle*(p: WizPage, s: QString) {.importcpp: "#->setSubTitle(#)".}
proc setLayout*(p: WizPage, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(p: WizPage, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(p: WizPage, l: Grid) {.importcpp: "#->setLayout(#)".}
proc setLayout*(p: WizPage, l: Form) {.importcpp: "#->setLayout(#)".}
proc registerField*(p: WizPage, name: QString, w: W) =
  {.emit: "`p`->registerField(`name`, `w`);".}
proc isWizPageComplete*(p: WizPage): bool =
  var r: cint
  {.emit: "`r` = `p`->isComplete() ? 1 : 0;".}
  result = r == 1
proc setWizPageFinalPage*(p: WizPage, b: bool) =
  let bv = b.cint
  {.emit: "if (`bv`) `p`->setFinalPage(true); else `p`->setFinalPage(false);".}

# ═══════════════════════════════════════════════════════════════════════════════
# QStandardItemModel / QStandardItem
# ═══════════════════════════════════════════════════════════════════════════════

proc newSIM*(rows, cols: cint, parent: W = nil): SIM =
  {.emit: "`result` = new QStandardItemModel(`rows`, `cols`, (QObject*)`parent`);".}
proc newSIM*(parent: W = nil): SIM =
  {.emit: "`result` = new QStandardItemModel((QObject*)`parent`);".}
proc simRowCount*(m: SIM): int =
  var v: cint
  {.emit: "`v` = `m`->rowCount();".}
  result = v.int
proc simColCount*(m: SIM): int =
  var v: cint
  {.emit: "`v` = `m`->columnCount();".}
  result = v.int
proc simAppendRow*(m: SIM, items: seq[SI]) =
  let n = items.len.cint
  {.emit: """
    QList<QStandardItem*> _row;
    for (int i = 0; i < `n`; i++) _row << (&`items`)[i];
    `m`->appendRow(_row);
  """.}
proc simAppendRow*(m: SIM, item: SI) {.importcpp: "#->appendRow(#)".}
proc simSetHorizontalHeaders*(m: SIM, labels: openArray[string]) =
  var joined = ""
  for i, s in labels:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = labels.len.cint
  {.emit: """
    QStringList _hl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _hl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `m`->setHorizontalHeaderLabels(_hl);
  """.}
proc simClear*(m: SIM) {.importcpp: "#->clear()".}
proc simItem*(m: SIM, row, col: cint): SI {.importcpp: "#->item(#, #)".}

proc newSI*(text: QString): SI {.importcpp: "new QStandardItem(#)".}
proc newSI*(): SI {.importcpp: "new QStandardItem()".}
proc siSetText*(i: SI, s: QString) {.importcpp: "#->setText(#)".}
proc siText*(i: SI): string =
  var p: cstring
  {.emit: "static QByteArray _bsi; _bsi = `i`->text().toUtf8(); `p` = _bsi.constData();".}
  result = $p
proc siSetEditable*(i: SI, b: bool) {.importcpp: "#->setEditable(#)".}
proc siSetCheckable*(i: SI, b: bool) {.importcpp: "#->setCheckable(#)".}
proc siSetCheckState*(i: SI, s: cint) =
  {.emit: "`i`->setCheckState((Qt::CheckState)`s`);".}
proc siSetData*(i: SI, role: cint, v: QVariant) {.importcpp: "#->setData(#, #)".}
proc siSetFlags*(i: SI, f: cint) =
  {.emit: "`i`->setFlags((Qt::ItemFlags)`f`);".}
proc siAppendRow*(i: SI, child: SI) {.importcpp: "#->appendRow(#)".}
proc siRowCount*(i: SI): int =
  var v: cint
  {.emit: "`v` = `i`->rowCount();".}
  result = v.int
proc siChild*(i: SI, row: cint, col: cint = 0): SI {.importcpp: "#->child(#, #)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QStringListModel
# ═══════════════════════════════════════════════════════════════════════════════

proc newStringListModel*(words: seq[string], parent: W = nil): SLM =
  var joined = ""
  for i, s in words:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = words.len.cint
  {.emit: """
    QStringList _sl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _sl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `result` = new QStringListModel(_sl, (QObject*)`parent`);
  """.}
proc slmSetStrings*(m: SLM, words: seq[string]) =
  var joined = ""
  for i, s in words:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring; let n = words.len.cint
  {.emit: """
    QStringList _sl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _sl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `m`->setStringList(_sl);
  """.}
proc slmStrings*(m: SLM): seq[string] =
  var n: cint
  {.emit: "QStringList _sl = `m`->stringList(); `n` = _sl.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bslm; _bslm = _sl.at(`idx`).toUtf8(); `p` = _bslm.constData();".}
    result[i] = $p

# ═══════════════════════════════════════════════════════════════════════════════
# QSortFilterProxyModel
# ═══════════════════════════════════════════════════════════════════════════════

proc newSFPM*(parent: W = nil): SFPM =
  {.emit: "`result` = new QSortFilterProxyModel((QObject*)`parent`);".}
proc sfpmSetSource*(m: SFPM, src: AIM) {.importcpp: "#->setSourceModel(#)".}
proc sfpmSetSource*(m: SFPM, src: SIM) =
  {.emit: "`m`->setSourceModel(`src`);".}
proc sfpmSetSource*(m: SFPM, src: SLM) =
  {.emit: "`m`->setSourceModel(`src`);".}
proc sfpmSetFilterStr*(m: SFPM, pattern: QString) {.importcpp: "#->setFilterRegularExpression(#)".}
proc sfpmSetFilterCol*(m: SFPM, col: cint) {.importcpp: "#->setFilterKeyColumn(#)".}
proc sfpmSetSortCol*(m: SFPM, col: cint, order: cint = 0) =
  {.emit: "`m`->sort(`col`, (Qt::SortOrder)`order`);".}
proc sfpmSetCaseSensitive*(m: SFPM, b: bool) =
  let bv = b.cint
  {.emit: "`m`->setFilterCaseSensitivity(`bv` ? Qt::CaseSensitive : Qt::CaseInsensitive);".}
proc sfpmRowCount*(m: SFPM): int =
  var v: cint
  {.emit: "`v` = `m`->rowCount();".}
  result = v.int
proc sfpmColCount*(m: SFPM): int =
  var v: cint
  {.emit: "`v` = `m`->columnCount();".}
  result = v.int
proc sfpmInvalidate*(m: SFPM) {.importcpp: "#->invalidate()".}
proc sfpmSetDynamic*(m: SFPM, b: bool) {.importcpp: "#->setDynamicSortFilter(#)".}
proc sfpmSetRecursive*(m: SFPM, b: bool) {.importcpp: "#->setRecursiveFilteringEnabled(#)".}
proc sfpmMapToSource*(m: SFPM, idx: QModelIndex): QModelIndex {.importcpp: "#->mapToSource(#)".}
proc sfpmMapFromSource*(m: SFPM, idx: QModelIndex): QModelIndex {.importcpp: "#->mapFromSource(#)".}

# ═══════════════════════════════════════════════════════════════════════════════
# QTabBar (standalone)
# ═══════════════════════════════════════════════════════════════════════════════

proc newTabBar*(parent: W = nil): TabBar {.importcpp: "new QTabBar(#)".}
proc addTab*(tb: TabBar, text: QString): int =
  var v: cint
  {.emit: "`v` = `tb`->addTab(`text`);".}
  result = v.int
proc removeTab*(tb: TabBar, idx: cint) {.importcpp: "#->removeTab(#)".}
proc currentIndex*(tb: TabBar): int =
  var v: cint
  {.emit: "`v` = `tb`->currentIndex();".}
  result = v.int
proc setCurrentIndex*(tb: TabBar, idx: cint) {.importcpp: "#->setCurrentIndex(#)".}
proc tabText*(tb: TabBar, idx: cint): string =
  var p: cstring
  {.emit: "static QByteArray _btbrt; _btbrt = `tb`->tabText(`idx`).toUtf8(); `p` = _btbrt.constData();".}
  result = $p
proc setTabText*(tb: TabBar, idx: cint, s: QString) {.importcpp: "#->setTabText(#, #)".}
proc setMovable*(tb: TabBar, b: bool) {.importcpp: "#->setMovable(#)".}
proc setTabsClosable*(tb: TabBar, b: bool) {.importcpp: "#->setTabsClosable(#)".}
proc count*(tb: TabBar): int =
  var v: cint
  {.emit: "`v` = `tb`->count();".}
  result = v.int
proc setStyleSheet*(tb: TabBar, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onTabBarCurrentChanged*(tb: TabBar, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`tb`, &QTabBar::currentChanged, [=](int _i){
      `cb`(_i, `ud`);
    });
  """.}

proc onTabBarCloseRequested*(tb: TabBar, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`tb`, &QTabBar::tabCloseRequested, [=](int _i){
      `cb`(_i, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QDialog (базовый)
# ═══════════════════════════════════════════════════════════════════════════════

proc newDialog*(parent: W = nil): Dlg {.importcpp: "new QDialog(#)".}
proc execDlg*(d: Dlg): int =
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = v.int
proc accept*(d: Dlg) {.importcpp: "#->accept()".}
proc reject*(d: Dlg) {.importcpp: "#->reject()".}
proc done*(d: Dlg, r: cint) {.importcpp: "#->done(#)".}
proc show*(d: Dlg) {.importcpp: "#->show()".}
proc hide*(d: Dlg) {.importcpp: "#->hide()".}
proc setWindowTitle*(d: Dlg, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc resize*(d: Dlg, w, h: cint) {.importcpp: "#->resize(#, #)".}
proc setModal*(d: Dlg, b: bool) {.importcpp: "#->setModal(#)".}
proc setSizeGripEnabled*(d: Dlg, b: bool) {.importcpp: "#->setSizeGripEnabled(#)".}
proc setLayout*(d: Dlg, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(d: Dlg, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(d: Dlg, l: Grid) {.importcpp: "#->setLayout(#)".}
proc setLayout*(d: Dlg, l: Form) {.importcpp: "#->setLayout(#)".}
proc setStyleSheet*(d: Dlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc onDlgFinished*(d: Dlg, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`d`, &QDialog::finished, [=](int _r){
      `cb`(_r, `ud`);
    });
  """.}

proc onDlgAccepted*(d: Dlg, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`d`, &QDialog::accepted, [=](){
      `cb`(`ud`);
    });
  """.}

proc onDlgRejected*(d: Dlg, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`d`, &QDialog::rejected, [=](){
      `cb`(`ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# QSizeGrip / QRubberBand
# ═══════════════════════════════════════════════════════════════════════════════

proc newSizeGrip*(parent: W = nil): ptr QSizeGrip {.importcpp: "new QSizeGrip(#)".}

proc newRubberBand*(shape: cint, parent: W = nil): ptr QRubberBand =
  {.emit: "`result` = new QRubberBand((QRubberBand::Shape)`shape`, `parent`);".}
proc rubberBandMove*(rb: ptr QRubberBand, x, y: cint) {.importcpp: "#->move(#, #)".}
proc rubberBandResize*(rb: ptr QRubberBand, w, h: cint) {.importcpp: "#->resize(#, #)".}
proc rubberBandShow*(rb: ptr QRubberBand) {.importcpp: "#->show()".}
proc rubberBandHide*(rb: ptr QRubberBand) {.importcpp: "#->hide()".}
proc rubberBandSetGeometry*(rb: ptr QRubberBand, x, y, w, h: cint) =
  {.emit: "`rb`->setGeometry(`x`, `y`, `w`, `h`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# QFontDatabase helpers
# ═══════════════════════════════════════════════════════════════════════════════

proc addApplicationFont*(path: string): int =
  let cs = path.cstring; var v: cint
  {.emit: "`v` = QFontDatabase::addApplicationFont(QString::fromUtf8(`cs`));".}
  result = v.int

proc availableFontFamilies*(): seq[string] =
  var n: cint
  {.emit: "QStringList _ff = QFontDatabase::families(); `n` = _ff.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bff; _bff = _ff.at(`idx`).toUtf8(); `p` = _bff.constData();".}
    result[i] = $p

proc fontFamilyStyles*(family: string): seq[string] =
  let cs = family.cstring; var n: cint
  {.emit: "QStringList _fs = QFontDatabase::styles(QString::fromUtf8(`cs`)); `n` = _fs.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bffs; _bffs = _fs.at(`idx`).toUtf8(); `p` = _bffs.constData();".}
    result[i] = $p

proc fontPointSizes*(family, style: string): seq[int] =
  let cf = family.cstring; let cs = style.cstring; var n: cint
  {.emit: """
    QList<int> _fps = QFontDatabase::pointSizes(
      QString::fromUtf8(`cf`), QString::fromUtf8(`cs`));
    `n` = _fps.size();
  """.}
  result = newSeq[int](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var v: cint
    {.emit: "`v` = _fps.at(`idx`);".}
    result[i] = v.int

# ═══════════════════════════════════════════════════════════════════════════════
# QToolTip (static)
# ═══════════════════════════════════════════════════════════════════════════════

proc showToolTip*(x, y: cint, text: QString) =
  {.emit: "QToolTip::showText(QPoint(`x`, `y`), `text`);".}
proc hideToolTip*() =
  {.emit: "QToolTip::hideText();".}
proc toolTipFont*(): string =
  var p: cstring
  {.emit: "static QByteArray _bttf; _bttf = QToolTip::font().family().toUtf8(); `p` = _bttf.constData();".}
  result = $p

# ═══════════════════════════════════════════════════════════════════════════════
# Утилиты центрирования, установки шрифта через stylesheet
# ═══════════════════════════════════════════════════════════════════════════════

proc setFontSize*(w: W, px: int) =
  let s = "font-size: " & $px & "px;"
  let cs = s.cstring
  {.emit: "`w`->setStyleSheet(QString::fromUtf8(`cs`));".}

proc makeStylesheet*(bg: string = ""; fg: string = ""; font: string = ""; border: string = "";
                     radius: int = 0, padding: int = -1): string =
  ## Простой DSL для генерации QSS
  var parts: seq[string]
  if bg != "": parts.add("background-color: " & bg)
  if fg != "": parts.add("color: " & fg)
  if font != "": parts.add("font: " & font)
  if border != "": parts.add("border: " & border)
  if radius > 0: parts.add("border-radius: " & $radius & "px")
  if padding >= 0: parts.add("padding: " & $padding & "px")
  result = "{ " & parts.join("; ") & " }"

proc setContentsMargins*(w: W, all: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}




