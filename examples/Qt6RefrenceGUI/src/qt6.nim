## qt6.nim — биндинги Qt6 Widgets для Nim (nim cpp)
## Без NimClosureProc, без C++ обёрток.
## Паттерн коллбэков: cdecl proc + pointer userdata.
##
## Компиляция:
##   nim cpp --passC:"-std=c++17" \
##     --passC:"$(pkg-config --cflags Qt6Widgets)" \
##     --passL:"$(pkg-config --libs Qt6Widgets)" \
##     app.nim

# ── Qt6 headers через {.emit.} в начале файла ────────────────────────────────
{.emit: """
#include <QApplication>
#include <QMainWindow>
#include <QMenuBar>
#include <QMenu>
#include <QMenuBar>
#include <QAction>
#include <QToolBar>
#include <QStatusBar>
#include <QLabel>
#include <QPushButton>
#include <QTextEdit>
#include <QLineEdit>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QWidget>
#include <QFrame>
#include <QSplitter>
#include <QTabWidget>
#include <QListWidget>
#include <QListWidgetItem>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include <QGroupBox>
#include <QDockWidget>
#include <QScrollArea>
#include <QMessageBox>
#include <QInputDialog>
#include <QFileDialog>
#include <QScreen>
#include <QString>
#include <QStringList>
#include <QKeySequence>
#include <QTimer>
#include <QDateTime>
#include <QFont>
#include <QSize>
#include <QRect>
#include <QPoint>
#include <functional>

// Синглтон QApplication — создаётся один раз при старте
static int   _nim_qt6_argc = 0;
static char* _nim_qt6_argv[] = {nullptr};
static QApplication* _nim_qt6_app = nullptr;
""".}

# ── Типы Qt объектов (opaque) ─────────────────────────────────────────────────
type
  QApplication*   {.importcpp: "QApplication",   header: "<QApplication>".}  = object
  QMainWindow*    {.importcpp: "QMainWindow",     header: "<QMainWindow>".}   = object
  QWidget*        {.importcpp: "QWidget",         header: "<QWidget>".}       = object
  QMenu*          {.importcpp: "QMenu",           header: "<QMenu>".}         = object
  QAction*        {.importcpp: "QAction",         header: "<QAction>".}       = object
  QToolBar*       {.importcpp: "QToolBar",        header: "<QToolBar>".}      = object
  QStatusBar*     {.importcpp: "QStatusBar",      header: "<QStatusBar>".}    = object
  QLabel*         {.importcpp: "QLabel",          header: "<QLabel>".}        = object
  QPushButton*    {.importcpp: "QPushButton",     header: "<QPushButton>".}   = object
  QTextEdit*      {.importcpp: "QTextEdit",       header: "<QTextEdit>".}     = object
  QLineEdit*      {.importcpp: "QLineEdit",       header: "<QLineEdit>".}     = object
  QVBoxLayout*    {.importcpp: "QVBoxLayout",     header: "<QVBoxLayout>".}   = object
  QHBoxLayout*    {.importcpp: "QHBoxLayout",     header: "<QHBoxLayout>".}   = object
  QGridLayout*    {.importcpp: "QGridLayout",     header: "<QGridLayout>".}   = object
  QFrame*         {.importcpp: "QFrame",          header: "<QFrame>".}        = object
  QSplitter*      {.importcpp: "QSplitter",       header: "<QSplitter>".}     = object
  QTabWidget*     {.importcpp: "QTabWidget",      header: "<QTabWidget>".}    = object
  QListWidget*    {.importcpp: "QListWidget",     header: "<QListWidget>".}   = object
  QListWidgetItem*{.importcpp: "QListWidgetItem", header: "<QListWidget>".}   = object
  QTreeWidget*    {.importcpp: "QTreeWidget",     header: "<QTreeWidget>".}   = object
  QTreeWidgetItem*{.importcpp: "QTreeWidgetItem", header: "<QTreeWidget>".}   = object
  QGroupBox*      {.importcpp: "QGroupBox",       header: "<QGroupBox>".}     = object
  QDockWidget*    {.importcpp: "QDockWidget",     header: "<QDockWidget>".}   = object
  QScrollArea*    {.importcpp: "QScrollArea",     header: "<QScrollArea>".}   = object
  QString*        {.importcpp: "QString",         header: "<QString>".}       = object
  QTimer*         {.importcpp: "QTimer",          header: "<QTimer>".}        = object

# Короткие псевдонимы-указатели
type
  App*    = ptr QApplication
  Win*    = ptr QMainWindow
  W*      = ptr QWidget
  Menu*   = ptr QMenu
  Act*    = ptr QAction
  TB*     = ptr QToolBar
  SB*     = ptr QStatusBar
  Lbl*    = ptr QLabel
  Btn*    = ptr QPushButton
  TE*     = ptr QTextEdit
  LE*     = ptr QLineEdit
  VBox*   = ptr QVBoxLayout
  HBox*   = ptr QHBoxLayout
  Grid*   = ptr QGridLayout
  Frm*    = ptr QFrame
  Splt*   = ptr QSplitter
  Tab*    = ptr QTabWidget
  LW*     = ptr QListWidget
  LWI*    = ptr QListWidgetItem
  TW*     = ptr QTreeWidget
  TWI*    = ptr QTreeWidgetItem
  Grp*    = ptr QGroupBox
  Dock*   = ptr QDockWidget
  Scroll* = ptr QScrollArea
  Timer*  = ptr QTimer

# ── Тип коллбэка (cdecl + userdata pointer) ───────────────────────────────────
type CB* = proc(ud: pointer) {.cdecl.}
type CBStr* = proc(text: cstring, ud: pointer) {.cdecl.}

# ── QString ───────────────────────────────────────────────────────────────────
proc qs*(s: cstring): QString {.
  importcpp: "QString::fromUtf8(#)", header: "<QString>".}

proc qs*(s: string): QString = qs(s.cstring)

proc `$`*(q: QString): string =
  var p: cstring
  {.emit: "static QByteArray _b; _b = `q`.toUtf8(); `p` = _b.constData();".}
  result = $p

# ── QApplication ─────────────────────────────────────────────────────────────
proc newApp*(): App =
  {.emit: "_nim_qt6_app = new QApplication(_nim_qt6_argc, _nim_qt6_argv); `result` = _nim_qt6_app;".}

proc exec*(a: App): cint {.importcpp: "#->exec()".}
proc quit*(a: App) {.importcpp: "#->quit()".}
proc setAppName*(a: App, s: QString) {.importcpp: "#->setApplicationName(#)".}
proc setOrgName*(a: App, s: QString) {.importcpp: "#->setOrganizationName(#)".}
proc setAppVersion*(a: App, s: QString) {.importcpp: "#->setApplicationVersion(#)".}
proc setStyleSheet*(a: App, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ── QMainWindow ───────────────────────────────────────────────────────────────
proc newWin*(): Win {.importcpp: "new QMainWindow()".}
proc show*(w: Win) {.importcpp: "#->show()".}
proc setTitle*(w: Win, s: QString) {.importcpp: "#->setWindowTitle(#)".}
proc resize*(w: Win, width, height: cint) {.importcpp: "#->resize(#, #)".}
proc setMinSize*(w: Win, width, height: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setCentral*(w: Win, c: W) {.importcpp: "#->setCentralWidget(#)".}
proc statusBar*(w: Win): SB {.importcpp: "#->statusBar()".}
proc addToolBar*(w: Win, title: QString): TB {.importcpp: "#->addToolBar(#)".}
proc addMenu*(w: Win, title: QString): Menu =
  {.emit: "`result` = `w`->menuBar()->addMenu(`title`);".}
proc addDock*(w: Win, area: cint, d: Dock) {.
  importcpp: "#->addDockWidget((Qt::DockWidgetArea)#, #)".}
proc setStyleSheet*(w: Win, css: QString) {.importcpp: "#->setStyleSheet(#)".}

proc centerOnScreen*(w: Win) =
  {.emit: """
    if (auto *sc = QApplication::primaryScreen())
      `w`->move(sc->availableGeometry().center() - `w`->rect().center());
  """.}

# Upcast Win → W
proc asW*(w: Win): W {.importcpp: "(QWidget*)#".}

# ── QStatusBar ────────────────────────────────────────────────────────────────
proc showMsg*(sb: SB, msg: QString, ms: cint = 0) {.importcpp: "#->showMessage(#, #)".}

# ── QMenu ─────────────────────────────────────────────────────────────────────
proc addSubMenu*(m: Menu, title: QString): Menu {.importcpp: "#->addMenu(#)".}
proc newAction*(m: Menu, text: QString): Act {.importcpp: "#->addAction(#)".}
proc addSep*(m: Menu) {.importcpp: "#->addSeparator()".}

# ── QAction ───────────────────────────────────────────────────────────────────
proc setShortcut*(a: Act, keys: cstring) =
  {.emit: "`a`->setShortcut(QKeySequence(QString::fromUtf8(`keys`)));".}
proc setTip*(a: Act, s: QString) {.importcpp: "#->setStatusTip(#)".}
proc setEnabled*(a: Act, b: bool) {.importcpp: "#->setEnabled(#)".}
proc setCheckable*(a: Act, b: bool) {.importcpp: "#->setCheckable(#)".}
proc isChecked*(a: Act): bool {.importcpp: "#->isChecked()".}

proc onTriggered*(a: Act, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`a`, &QAction::triggered, [=](bool){
      `cb`(`ud`);
    });
  """.}

# ── QToolBar ──────────────────────────────────────────────────────────────────
proc addAction*(tb: TB, text: QString): Act {.importcpp: "#->addAction(#)".}
proc addSep*(tb: TB) {.importcpp: "#->addSeparator()".}
proc setMovable*(tb: TB, b: bool) {.importcpp: "#->setMovable(#)".}
proc addWidget*(tb: TB, w: W) {.importcpp: "#->addWidget(#)".}
proc addWidget*(tb: TB, b: Btn) =
  {.emit: "`tb`->addWidget(`b`);".}

# ── QWidget ───────────────────────────────────────────────────────────────────
proc newW*(parent: W = nil): W {.importcpp: "new QWidget(#)".}
proc show*(w: W) {.importcpp: "#->show()".}
proc hide*(w: W) {.importcpp: "#->hide()".}
proc setLayout*(w: W, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(w: W, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(w: W, l: Grid) {.importcpp: "#->setLayout(#)".}
proc setStyleSheet*(w: W, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setMinH*(w: W, h: cint) {.importcpp: "#->setMinimumHeight(#)".}
proc setFixedH*(w: W, h: cint) {.importcpp: "#->setFixedHeight(#)".}
proc setFixedW*(w: W, px: cint) {.importcpp: "#->setFixedWidth(#)".}

# Upcasts to W
proc asW*(x: Lbl): W  {.importcpp: "(QWidget*)#".}
proc asW*(x: Btn): W  {.importcpp: "(QWidget*)#".}
proc asW*(x: TE): W   {.importcpp: "(QWidget*)#".}
proc asW*(x: LE): W   {.importcpp: "(QWidget*)#".}
proc asW*(x: LW): W   {.importcpp: "(QWidget*)#".}
proc asW*(x: Tab): W  {.importcpp: "(QWidget*)#".}
proc asW*(x: Splt): W {.importcpp: "(QWidget*)#".}
proc asW*(x: Grp): W  {.importcpp: "(QWidget*)#".}
proc asW*(x: Frm): W  {.importcpp: "(QWidget*)#".}
proc asW*(x: TW): W   {.importcpp: "(QWidget*)#".}
proc asW*(x: Scroll): W {.importcpp: "(QWidget*)#".}

# ── QLabel ────────────────────────────────────────────────────────────────────
proc newLbl*(text: QString, parent: W = nil): Lbl {.
  importcpp: "new QLabel(#, #)".}
proc setText*(l: Lbl, s: QString) {.importcpp: "#->setText(#)".}
proc setAlign*(l: Lbl, a: cint) {.importcpp: "#->setAlignment((Qt::AlignmentFlag)#)".}
proc setWrap*(l: Lbl, b: bool) {.importcpp: "#->setWordWrap(#)".}
proc setStyleSheet*(l: Lbl, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ── QPushButton ───────────────────────────────────────────────────────────────
proc newBtn*(text: QString, parent: W = nil): Btn {.
  importcpp: "new QPushButton(#, #)".}
proc setText*(b: Btn, s: QString) {.importcpp: "#->setText(#)".}
proc setStyleSheet*(b: Btn, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setMinSize*(b: Btn, w, h: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setCheckable*(b: Btn, c: bool) {.importcpp: "#->setCheckable(#)".}
proc isChecked*(b: Btn): bool {.importcpp: "#->isChecked()".}

proc onClicked*(b: Btn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QPushButton::clicked, [=](bool){
      `cb`(`ud`);
    });
  """.}

# ── QTextEdit ─────────────────────────────────────────────────────────────────
proc newTE*(parent: W = nil): TE {.importcpp: "new QTextEdit(#)".}
proc setHtml*(t: TE, html: QString) {.importcpp: "#->setHtml(#)".}
proc append*(t: TE, s: QString) {.importcpp: "#->append(#)".}
proc setReadOnly*(t: TE, b: bool) {.importcpp: "#->setReadOnly(#)".}
proc setStyleSheet*(t: TE, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc clear*(t: TE) {.importcpp: "#->clear()".}
proc setPlaceholder*(t: TE, s: QString) {.importcpp: "#->setPlaceholderText(#)".}
proc toPlainText*(t: TE): QString {.importcpp: "#->toPlainText()".}

# ── QLineEdit ─────────────────────────────────────────────────────────────────
proc newLE*(parent: W = nil): LE {.importcpp: "new QLineEdit(#)".}
proc setText*(l: LE, s: QString) {.importcpp: "#->setText(#)".}
proc text*(l: LE): QString {.importcpp: "#->text()".}
proc setPlaceholder*(l: LE, s: QString) {.importcpp: "#->setPlaceholderText(#)".}
proc setStyleSheet*(l: LE, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc clear*(l: LE) {.importcpp: "#->clear()".}

proc onReturn*(l: LE, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`l`, &QLineEdit::returnPressed, [=](){
      `cb`(`ud`);
    });
  """.}

# ── QListWidget ───────────────────────────────────────────────────────────────
proc newLW*(parent: W = nil): LW {.importcpp: "new QListWidget(#)".}
proc addItem*(l: LW, s: QString) {.importcpp: "#->addItem(#)".}
proc clear*(l: LW) {.importcpp: "#->clear()".}
proc count*(l: LW): cint {.importcpp: "#->count()".}
proc currentRow*(l: LW): cint {.importcpp: "#->currentRow()".}
proc takeItem*(l: LW, row: cint): LWI {.importcpp: "#->takeItem(#)".}
proc setStyleSheet*(l: LW, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setAltColors*(l: LW, b: bool) {.importcpp: "#->setAlternatingRowColors(#)".}
proc setSorting*(l: LW, b: bool) {.importcpp: "#->setSortingEnabled(#)".}
proc itemText*(i: LWI): QString {.importcpp: "#->text()".}

proc currentItemText*(l: LW): string =
  var p: cstring
  {.emit: """
    static QByteArray _b;
    QListWidgetItem* _it = `l`->currentItem();
    if (_it) { _b = _it->text().toUtf8(); `p` = _b.constData(); }
    else `p` = "";
  """.}
  result = $p

proc onItemClicked*(l: LW, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`l`, &QListWidget::itemClicked,
      [=](QListWidgetItem* item){
        static QByteArray _b;
        _b = item->text().toUtf8();
        `cb`(_b.constData(), `ud`);
      });
  """.}

proc onItemDblClicked*(l: LW, cb: CBStr, ud: pointer) =
  {.emit: """
    QObject::connect(`l`, &QListWidget::itemDoubleClicked,
      [=](QListWidgetItem* item){
        static QByteArray _b;
        _b = item->text().toUtf8();
        `cb`(_b.constData(), `ud`);
      });
  """.}

# ── QTabWidget ────────────────────────────────────────────────────────────────
proc newTab*(parent: W = nil): Tab {.importcpp: "new QTabWidget(#)".}
proc addTab*(tw: Tab, w: W, label: QString) {.importcpp: "#->addTab(#, #)".}
proc setStyleSheet*(tw: Tab, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ── QSplitter ─────────────────────────────────────────────────────────────────
proc newSplt*(horiz: bool, parent: W = nil): Splt =
  let o: cint = if horiz: 1 else: 2  # Qt::Horizontal=1, Qt::Vertical=2
  {.emit: "`result` = new QSplitter((Qt::Orientation)`o`, `parent`);".}
proc addWidget*(s: Splt, w: W) {.importcpp: "#->addWidget(#)".}
proc setSizes*(s: Splt, a, b: cint) =
  {.emit: "`s`->setSizes({`a`, `b`});".}
proc setChildCollapsible*(s: Splt, b: bool) {.importcpp: "#->setChildrenCollapsible(#)".}
proc setHandleW*(s: Splt, w: cint) {.importcpp: "#->setHandleWidth(#)".}

# ── QGroupBox ─────────────────────────────────────────────────────────────────
proc newGrp*(title: QString, parent: W = nil): Grp {.
  importcpp: "new QGroupBox(#, #)".}
proc setLayout*(g: Grp, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(g: Grp, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setStyleSheet*(g: Grp, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ── QFrame ────────────────────────────────────────────────────────────────────
proc newFrm*(parent: W = nil): Frm {.importcpp: "new QFrame(#)".}
proc setShape*(f: Frm, s: cint) {.importcpp: "#->setFrameShape((QFrame::Shape)#)".}
proc setLayout*(f: Frm, l: VBox) {.importcpp: "#->setLayout(#)".}
proc setLayout*(f: Frm, l: HBox) {.importcpp: "#->setLayout(#)".}
proc setStyleSheet*(f: Frm, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setMinH*(f: Frm, h: cint) {.importcpp: "#->setMinimumHeight(#)".}

# ── QScrollArea ───────────────────────────────────────────────────────────────
proc newScroll*(parent: W = nil): Scroll {.importcpp: "new QScrollArea(#)".}
proc setResizable*(s: Scroll, b: bool) {.importcpp: "#->setWidgetResizable(#)".}
proc setWidget*(s: Scroll, w: W) {.importcpp: "#->setWidget(#)".}
proc setStyleSheet*(s: Scroll, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ── QTreeWidget ───────────────────────────────────────────────────────────────
proc newTW*(parent: W = nil): TW {.importcpp: "new QTreeWidget(#)".}
proc setColCount*(t: TW, n: cint) {.importcpp: "#->setColumnCount(#)".}
proc expandAll*(t: TW) {.importcpp: "#->expandAll()".}
proc setStyleSheet*(t: TW, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc setAltColors*(t: TW, b: bool) {.importcpp: "#->setAlternatingRowColors(#)".}
proc setAnimated*(t: TW, b: bool) {.importcpp: "#->setAnimated(#)".}
proc resizeCol*(t: TW, col: cint) {.importcpp: "#->resizeColumnToContents(#)".}

proc setHeaders*(t: TW, labels: openArray[string]) =
  var sl: cstring = ""
  var joined = ""
  for i, s in labels:
    if i > 0: joined.add(chr(0))
    joined.add(s)
  let data = joined.cstring
  let n = labels.len.cint
  {.emit: """
    QStringList _sl;
    const char* _p = `data`;
    for (int i = 0; i < `n`; i++) {
      _sl << QString::fromUtf8(_p);
      _p += strlen(_p) + 1;
    }
    `t`->setHeaderLabels(_sl);
  """.}

proc addTopItem*(t: TW, text: string): TWI =
  let cs = text.cstring
  {.emit: """
    `result` = new QTreeWidgetItem(`t`);
    `result`->setText(0, QString::fromUtf8(`cs`));
  """.}

proc addChild*(parent: TWI, c0: string, c1: string = ""): TWI =
  let s0 = c0.cstring
  let s1 = c1.cstring
  {.emit: """
    `result` = new QTreeWidgetItem(`parent`);
    `result`->setText(0, QString::fromUtf8(`s0`));
    if (`s1`[0]) `result`->setText(1, QString::fromUtf8(`s1`));
  """.}

# ── QDockWidget ───────────────────────────────────────────────────────────────
proc newDock*(title: QString, parent: Win): Dock {.
  importcpp: "new QDockWidget(#, #)".}
proc setWidget*(d: Dock, w: W) {.importcpp: "#->setWidget(#)".}
proc setAllowed*(d: Dock, areas: cint) {.
  importcpp: "#->setAllowedAreas((Qt::DockWidgetAreas)#)".}
proc setStyleSheet*(d: Dock, css: QString) {.importcpp: "#->setStyleSheet(#)".}

# ── Layouts ───────────────────────────────────────────────────────────────────
proc newVBox*(): VBox {.importcpp: "new QVBoxLayout()".}
proc add*(l: VBox, w: W)    {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Lbl)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Btn)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: TE)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: LE)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: LW)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Tab)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Splt) {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Grp)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Frm)  {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: TW)   {.importcpp: "#->addWidget(#)".}
proc add*(l: VBox, w: Scroll) {.importcpp: "#->addWidget(#)".}
proc stretch*(l: VBox) {.importcpp: "#->addStretch()".}
proc setSpacing*(l: VBox, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setMargins*(l: VBox, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}

proc newHBox*(): HBox {.importcpp: "new QHBoxLayout()".}
proc add*(l: HBox, w: W)    {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Lbl)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Btn)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: TE)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: LE)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: LW)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Tab)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Splt) {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Grp)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Frm)  {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: TW)   {.importcpp: "#->addWidget(#)".}
proc add*(l: HBox, w: Scroll) {.importcpp: "#->addWidget(#)".}
proc stretch*(l: HBox) {.importcpp: "#->addStretch()".}
proc setSpacing*(l: HBox, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setMargins*(l: HBox, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}

proc newGrid*(): Grid {.importcpp: "new QGridLayout()".}
proc add*(l: Grid, w: Lbl, row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: Btn, row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc add*(l: Grid, w: W,   row, col: cint) {.importcpp: "#->addWidget(#,#,#)".}
proc setSpacing*(l: Grid, px: cint) {.importcpp: "#->setSpacing(#)".}
proc setMargins*(l: Grid, a, b, c, d: cint) {.importcpp: "#->setContentsMargins(#,#,#,#)".}

# ── QTimer ────────────────────────────────────────────────────────────────────
proc newTimer*(): Timer {.importcpp: "new QTimer()".}
proc start*(t: Timer, ms: cint) {.importcpp: "#->start(#)".}
proc stop*(t: Timer) {.importcpp: "#->stop()".}

proc onTimeout*(t: Timer, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTimer::timeout, [=](){
      `cb`(`ud`);
    });
  """.}

# ── Диалоги ───────────────────────────────────────────────────────────────────
proc dlgInfo*(parent: W, title, text: string) =
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::information(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc dlgWarn*(parent: W, title, text: string) =
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::warning(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc dlgErr*(parent: W, title, text: string) =
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::critical(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc dlgYesNo*(parent: W, title, text: string): bool =
  let t = title.cstring; let m = text.cstring
  var r: cint
  {.emit: "`r` = (QMessageBox::question(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`)) == QMessageBox::Yes) ? 1 : 0;".}
  result = r == 1

proc dlgAbout*(parent: W, title, text: string) =
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::about(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc dlgInput*(parent: W, title, label, def: string): tuple[ok: bool, val: string] =
  let t = title.cstring; let l = label.cstring; let d = def.cstring
  var ok: cint; var p: cstring
  {.emit: """
    bool _ok = false;
    static QByteArray _buf;
    _buf = QInputDialog::getText(`parent`,
      QString::fromUtf8(`t`), QString::fromUtf8(`l`),
      QLineEdit::Normal, QString::fromUtf8(`d`), &_ok).toUtf8();
    `ok` = _ok ? 1 : 0;
    `p` = _buf.constData();
  """.}
  result = (ok: ok == 1, val: $p)

proc dlgOpenFile*(parent: W, title, filter: string): string =
  let t = title.cstring; let f = filter.cstring
  var p: cstring
  {.emit: """
    static QByteArray _buf;
    _buf = QFileDialog::getOpenFileName(`parent`,
      QString::fromUtf8(`t`), QString(), QString::fromUtf8(`f`)).toUtf8();
    `p` = _buf.constData();
  """.}
  result = $p

proc dlgSaveFile*(parent: W, title, filter: string): string =
  let t = title.cstring; let f = filter.cstring
  var p: cstring
  {.emit: """
    static QByteArray _buf;
    _buf = QFileDialog::getSaveFileName(`parent`,
      QString::fromUtf8(`t`), QString(), QString::fromUtf8(`f`)).toUtf8();
    `p` = _buf.constData();
  """.}
  result = $p

# ── Утилиты ───────────────────────────────────────────────────────────────────
proc currentTimeStr*(): string =
  var p: cstring
  {.emit: """
    static QByteArray _buf;
    _buf = QDateTime::currentDateTime().toString("dd.MM.yyyy  HH:mm:ss").toUtf8();
    `p` = _buf.constData();
  """.}
  result = $p
