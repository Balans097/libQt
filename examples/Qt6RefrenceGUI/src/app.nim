## app.nim — Nim + Qt6 Reference Application
##
## Компиляция (Fedora):
##   nim cpp --mm:orc --exceptions:cpp -d:release \
##     --passC:"-std=c++17" \
##     --passC:"$(pkg-config --cflags Qt6Widgets)" \
##     --passL:"$(pkg-config --libs Qt6Widgets)" \
##     -o:nim_qt6_app src/app.nim
##
## Или просто:  make

import qt6, themes
import strformat, strutils, times, os

# ── Подавление Qt-предупреждений (font-size px → pointSize <= 0 на Windows) ──
# Фильтрует QFont::setPointSize: Point size <= 0 и другой Qt-шум в stderr.
# Остальные сообщения (warning, critical, fatal) пропускаем как есть.
{.emit: """
#include <QMessageLogContext>
#include <QtGlobal>
#include <cstdio>
#include <cstring>

static void _nimQtMsgHandler(QtMsgType type, const QMessageLogContext&, const QString& msg) {
  if (type == QtDebugMsg) {
    // Подавляем известный шум от неверного point size при px-стилях
    QByteArray b = msg.toUtf8();
    const char* s = b.constData();
    if (strstr(s, "setPointSize") != nullptr) return;
    if (strstr(s, "Point size <= 0") != nullptr) return;
    if (strstr(s, "setPixelSize") != nullptr) return;
    // Остальные debug сообщения тоже молчим в release
    return;
  }
  // Warning / Critical / Fatal — оставляем
  fprintf(stderr, "%s\n", msg.toUtf8().constData());
}

static struct _NimQtMsgHandlerInstaller {
  _NimQtMsgHandlerInstaller() { qInstallMessageHandler(_nimQtMsgHandler); }
} _nimQtMsgHandlerInstance;
""".}

# ══════════════════════════════════════════════════════════════════════════════
#  Глобальное состояние
# ══════════════════════════════════════════════════════════════════════════════
var
  gApp:       App
  gWin:       Win
  gSB:        SB
  gLog:       TE        # лог событий
  gTasks:     LW        # список задач
  gNotes:     TE        # редактор заметок
  gClock:     Lbl       # часы
  gThemeBtn:  Btn       # кнопка смены темы
  gIsDark:    bool = false
  gCurTheme:  string = "Classic Blue"

# ══════════════════════════════════════════════════════════════════════════════
#  Утилиты
# ══════════════════════════════════════════════════════════════════════════════
proc log(msg: string) =
  let t = now().format("HH:mm:ss")
  gLog.append(qs(fmt"[{t}]  {msg}"))

proc status(msg: string, ms: int = 4000) =
  gSB.showMsg(qs(msg), ms.cint)

proc applyTheme(dark: bool) =
  gIsDark = dark
  if dark:
    gApp.setStyleSheet(qs(darkTheme))
    gThemeBtn.setText(qs("☀  Светлая тема"))
    gThemeBtn.setStyleSheet(qs("""
      QPushButton { background:#f9e2af; color:#1e1e2e;
        border-radius:6px; padding:5px 14px; font-weight:bold; }
      QPushButton:hover { background:#fab387; }
    """))
    log("Тёмная тема (Catppuccin Mocha)")
    status("🌙  Тёмная тема")
  else:
    gApp.setStyleSheet(qs(lightTheme))
    gThemeBtn.setText(qs("🌙  Тёмная тема"))
    gThemeBtn.setStyleSheet(qs("""
      QPushButton { background:#ffffff; color:#2c5f9e;
        border:2px solid #ffffff; border-radius:6px;
        padding:5px 14px; font-weight:bold; }
      QPushButton:hover { background:#e8f0fc; }
    """))
    log("Светлая тема: " & gCurTheme)
    status("☀  " & gCurTheme)

proc applyLightTheme(css: string, name: string) =
  gIsDark = false
  gCurTheme = name
  gApp.setStyleSheet(qs(css))
  gThemeBtn.setText(qs("🌙  Тёмная тема"))
  gThemeBtn.setStyleSheet(qs("""
    QPushButton { background:#ffffff; color:#2c5f9e;
      border:2px solid #ffffff; border-radius:6px;
      padding:5px 14px; font-weight:bold; }
    QPushButton:hover { background:#e8f0fc; }
  """))
  log("Тема: " & name)
  status("☀  " & name)

# ══════════════════════════════════════════════════════════════════════════════
#  Вкладка «Задачи»
# ══════════════════════════════════════════════════════════════════════════════

# Коллбэки для вкладки задач — все cdecl
proc cbAddTask(ud: pointer) {.cdecl.} =
  let le = cast[LE](ud)
  let txt = ($(le.text())).strip()
  if txt.len == 0:
    gWin.asW().dlgInfo("Пустая строка", "Введите текст задачи.")
    return
  gTasks.addItem(qs(txt))
  le.clear()
  log(fmt"✚ Задача: «{txt}»")
  status(fmt"Добавлено: «{txt}»")

proc cbDelTask(ud: pointer) {.cdecl.} =
  let row = gTasks.currentRow()
  if row < 0:
    gWin.asW().dlgInfo("Нет выбора", "Выберите задачу.")
    return
  discard gTasks.takeItem(row)
  log(fmt"✖ Задача #{row+1} удалена")
  status("Задача удалена")

proc cbClearTasks(ud: pointer) {.cdecl.} =
  if gTasks.count() == 0: return
  if gWin.asW().dlgYesNo("Очистить список", "Удалить все задачи?"):
    gTasks.clear()
    log("✖ Список задач очищен")
    status("Задачи очищены")

proc cbSortTasks(ud: pointer) {.cdecl.} =
  gTasks.setSorting(true)
  gTasks.setSorting(false)
  log("🔤 Список отсортирован")
  status("Задачи отсортированы")

proc cbTaskClick(text: cstring, ud: pointer) {.cdecl.} =
  let s = $text
  log(fmt"◆ Выбрана: «{s}»")
  status(fmt"«{s}»")

proc cbTaskDbl(text: cstring, ud: pointer) {.cdecl.} =
  let s = $text
  let (ok, newText) = gWin.asW().dlgInput("Редактировать", "Новый текст:", s)
  if ok and newText.strip().len > 0:
    let row = gTasks.currentRow()
    if row >= 0:
      discard gTasks.takeItem(row)
      gTasks.addItem(qs(newText.strip()))
      log(fmt"✏ Изменено: «{newText.strip()}»")
      status(fmt"Изменено: «{newText.strip()}»")

proc buildTaskTab(): W =
  let page = newW()
  let root = newVBox()
  root.setMargins(12, 12, 12, 12)
  root.setSpacing(10)

  # Заголовок
  let hdr  = newHBox(); hdr.setSpacing(6)
  let ico  = newLbl(qs("📋")); ico.setStyleSheet(qs("font-size:18px; background:transparent;"))
  let ttl  = newLbl(qs("Диспетчер задач"))
  ttl.setStyleSheet(qs("font-size:15px; font-weight:bold; background:transparent;"))
  hdr.add(ico); hdr.add(ttl); hdr.stretch()
  let hdrW = newW(); hdrW.setLayout(hdr)
  root.add(hdrW)

  # Строка ввода
  let row1 = newHBox(); row1.setSpacing(8)
  let le = newLE()
  le.setPlaceholder(qs("Введите задачу и нажмите Enter или «Добавить»…"))
  let btnAdd = newBtn(qs("➕ Добавить"))
  btnAdd.setMinSize(110, 34)
  row1.add(le); row1.add(btnAdd)
  let row1W = newW(); row1W.setLayout(row1)
  root.add(row1W)

  # Список задач
  gTasks = newLW()
  gTasks.setAltColors(true)
  for t in ["🎯  Изучить биндинги Qt6 для Nim",
            "🚀  Написать эталонное приложение",
            "⚡  Настроить сборку nim cpp -d:release",
            "📦  Оформить как Nimble-пакет",
            "📝  Написать README с примерами"]:
    gTasks.addItem(qs(t))
  root.add(gTasks)

  # Кнопки действий
  let row2 = newHBox(); row2.setSpacing(8)
  let btnDel = newBtn(qs("🗑  Удалить"))
  btnDel.setMinSize(140, 34)
  btnDel.setStyleSheet(qs("""
    QPushButton { background:#e64553; color:#eff1f5;
      border-radius:6px; padding:5px 14px; font-weight:bold; }
    QPushButton:hover { background:#d20f39; }"""))
  let btnClr = newBtn(qs("✖  Очистить"))
  btnClr.setMinSize(130, 34)
  btnClr.setStyleSheet(qs("""
    QPushButton { background:#fe640b; color:#eff1f5;
      border-radius:6px; padding:5px 14px; font-weight:bold; }
    QPushButton:hover { background:#e64553; }"""))
  let btnSort = newBtn(qs("🔤  Сортировать"))
  btnSort.setMinSize(130, 34)
  row2.add(btnDel); row2.add(btnClr); row2.stretch(); row2.add(btnSort)
  let row2W = newW(); row2W.setLayout(row2)
  root.add(row2W)

  page.setLayout(root)

  # Подключение коллбэков
  btnAdd.onClicked(cbAddTask, cast[pointer](le))
  le.onReturn(cbAddTask, cast[pointer](le))
  btnDel.onClicked(cbDelTask, nil)
  btnClr.onClicked(cbClearTasks, nil)
  btnSort.onClicked(cbSortTasks, nil)
  gTasks.onItemClicked(cbTaskClick, nil)
  gTasks.onItemDblClicked(cbTaskDbl, nil)

  result = page

# ══════════════════════════════════════════════════════════════════════════════
#  Вкладка «Заметки»
# ══════════════════════════════════════════════════════════════════════════════

proc cbNoteNew(ud: pointer) {.cdecl.} =
  if gWin.asW().dlgYesNo("Новый документ", "Очистить текущий документ?"):
    gNotes.clear()
    log("📄 Новый документ")
    status("Новый документ")

proc cbNoteOpen(ud: pointer) {.cdecl.} =
  let path = gWin.asW().dlgOpenFile("Открыть файл",
    "Текст (*.txt *.md *.html);;Все файлы (*)")
  if path.len == 0: return
  try:
    let content = readFile(path)
    if path.endsWith(".html") or path.endsWith(".htm"):
      gNotes.setHtml(qs(content))
    else:
      gNotes.setHtml(qs("<pre>" & content & "</pre>"))
    log(fmt"📂 Открыт: {path.splitPath().tail}")
    status(fmt"Открыт: {path.splitPath().tail}")
  except IOError as e:
    gWin.asW().dlgErr("Ошибка", "Не удалось открыть:\n" & e.msg)

proc cbNoteSave(ud: pointer) {.cdecl.} =
  let path = gWin.asW().dlgSaveFile("Сохранить файл",
    "Текст (*.txt);;HTML (*.html);;Все файлы (*)")
  if path.len == 0: return
  try:
    writeFile(path, $(gNotes.toPlainText()))
    log(fmt"💾 Сохранено: {path.splitPath().tail}")
    status(fmt"Сохранено: {path.splitPath().tail}")
  except IOError as e:
    gWin.asW().dlgErr("Ошибка", "Не удалось сохранить:\n" & e.msg)

proc buildNoteTab(): W =
  let page = newW()
  let root = newVBox()
  root.setMargins(12, 12, 12, 12)
  root.setSpacing(10)

  let tb = newHBox(); tb.setSpacing(8)
  let ttl = newLbl(qs("📝  Редактор заметок"))
  ttl.setStyleSheet(qs("font-size:15px; font-weight:bold; background:transparent;"))
  tb.add(ttl); tb.stretch()

  let btnNew  = newBtn(qs("📄 Новый"))
  let btnOpen = newBtn(qs("📂 Открыть"))
  let btnSave = newBtn(qs("💾 Сохранить"))
  btnNew.setMinSize(90, 32); btnOpen.setMinSize(100, 32); btnSave.setMinSize(110, 32)
  tb.add(btnNew); tb.add(btnOpen); tb.add(btnSave)

  let tbW = newW(); tbW.setLayout(tb)
  root.add(tbW)

  gNotes = newTE()
  gNotes.setPlaceholder(qs("Начните вводить текст заметки…"))
  gNotes.setHtml(qs("""
    <h2 style="color:#1e66f5;">Nim + Qt6 Reference App</h2>
    <p>Добро пожаловать в эталонное приложение на <b>чистом Nim</b>.</p>
    <p><b>Технический стек:</b></p>
    <ul>
      <li><b>Nim 2.2</b> — основной язык</li>
      <li><b>Qt6 6.10</b> — графический фреймворк</li>
      <li><b>nim cpp</b> — компиляция Nim → C++ → нативный бинарник</li>
      <li><b>Fedora Linux</b> — платформа</li>
    </ul>
    <p>Нет C++ обёрток — только <code>importcpp</code> и <code>{.emit.}</code>.</p>
  """))
  root.add(gNotes)

  page.setLayout(root)

  btnNew.onClicked(cbNoteNew, nil)
  btnOpen.onClicked(cbNoteOpen, nil)
  btnSave.onClicked(cbNoteSave, nil)

  result = page

# ══════════════════════════════════════════════════════════════════════════════
#  Вкладка «Лог»
# ══════════════════════════════════════════════════════════════════════════════

proc cbClearLog(ud: pointer) {.cdecl.} =
  gLog.clear()
  log("── Лог очищен ──")

proc buildLogTab(): W =
  let page = newW()
  let root = newVBox()
  root.setMargins(12, 12, 12, 12)
  root.setSpacing(10)

  let tb = newHBox(); tb.setSpacing(8)
  let ttl = newLbl(qs("📜  Лог событий"))
  ttl.setStyleSheet(qs("font-size:15px; font-weight:bold; background:transparent;"))
  tb.add(ttl); tb.stretch()

  let btnClr = newBtn(qs("🧹 Очистить"))
  btnClr.setMinSize(100, 32)
  btnClr.setStyleSheet(qs("""
    QPushButton { background:#40a02b; color:#eff1f5;
      border-radius:6px; padding:5px 14px; font-weight:bold; }
    QPushButton:hover { background:#179299; }"""))
  tb.add(btnClr)

  let tbW = newW(); tbW.setLayout(tb)
  root.add(tbW)

  gLog = newTE()
  gLog.setReadOnly(true)
  gLog.setStyleSheet(qs("font-size:12px;"))
  root.add(gLog)

  page.setLayout(root)
  btnClr.onClicked(cbClearLog, nil)
  result = page

# ══════════════════════════════════════════════════════════════════════════════
#  Вкладка «О программе»
# ══════════════════════════════════════════════════════════════════════════════

proc buildAboutTab(): W =
  let page = newW()
  let scroll = newScroll()
  scroll.setResizable(true)

  let inner = newW()
  let root = newVBox()
  root.setMargins(30, 30, 30, 30)
  root.setSpacing(20)

  let logo = newLbl(qs("🦎"))
  logo.setAlign(4)
  logo.setStyleSheet(qs("font-size:80px; background:transparent;"))
  root.add(logo)

  let name = newLbl(qs("Nim + Qt6 Reference App"))
  name.setAlign(4)
  name.setStyleSheet(qs("font-size:22px; font-weight:bold; background:transparent;"))
  root.add(name)

  let ver = newLbl(qs("v1.0  ·  Nim 2.2  ·  Qt6 6.10  ·  Fedora Linux"))
  ver.setAlign(4)
  ver.setStyleSheet(qs("font-size:13px; color:#6c6f85; background:transparent;"))
  root.add(ver)

  let sep = newFrm(); sep.setShape(4); sep.setMinH(1)
  root.add(sep)

  let desc = newLbl(qs(
    "Эталонное приложение — прямые биндинги Qt6 из Nim\n" &
    "без C++ обёрток. Компиляция через nim cpp,\n" &
    "динамическая линковка с системными Qt6."))
  desc.setAlign(4); desc.setWrap(true)
  desc.setStyleSheet(qs("font-size:13px; background:transparent;"))
  root.add(desc)

  # Таблица стека
  let gbStack = newGrp(qs("Стек технологий"))
  let gv = newVBox(); gv.setSpacing(8); gv.setMargins(16, 8, 16, 16)
  for (k, v) in [
    ("🟡  Nim 2.2.x",        "Основной язык программирования"),
    ("🔵  Qt6 Widgets 6.10", "Фреймворк графического интерфейса"),
    ("⚙   nim cpp",          "Nim → C++ → нативный бинарник"),
    ("🔗  Динам. линковка",  "libQt6Widgets, libQt6Gui, libQt6Core"),
    ("🐧  Fedora Linux",     "fc43, x86_64"),
  ]:
    let hb = newHBox(); hb.setSpacing(16)
    let lk = newLbl(qs(k)); lk.setStyleSheet(qs("font-weight:bold; min-width:200px; background:transparent;"))
    let lv = newLbl(qs(v)); lv.setStyleSheet(qs("color:#6c6f85; background:transparent;"))
    hb.add(lk); hb.add(lv); hb.stretch()
    let hw = newW(); hw.setLayout(hb)
    gv.add(hw)
  gbStack.setLayout(gv)
  root.add(gbStack)

  # Список возможностей
  let gbFeats = newGrp(qs("Возможности Qt6"))
  let fv = newVBox(); fv.setSpacing(5); fv.setMargins(16, 8, 16, 16)
  for feat in [
    "✓  QMainWindow — MenuBar, ToolBar, StatusBar",
    "✓  QDockWidget — отстыкуемая панель",
    "✓  QTabWidget  — несколько вкладок",
    "✓  QSplitter   — разделение областей",
    "✓  QListWidget — список с cdecl callbacks",
    "✓  QTreeWidget — дерево структуры проекта",
    "✓  QTextEdit   — редактор с HTML",
    "✓  QLineEdit   — ввод с обработкой Enter",
    "✓  QPushButton — cdecl + pointer userdata",
    "✓  QTimer      — часы реального времени",
    "✓  Диалоги: Info, Warning, Error, Question, Input, File",
    "✓  Переключение тём: светлая ↔ тёмная (F9/F10)",
  ]:
    let lbl = newLbl(qs(feat)); lbl.setStyleSheet(qs("font-size:12px; background:transparent;"))
    fv.add(lbl)
  gbFeats.setLayout(fv)
  root.add(gbFeats)

  root.stretch()

  let copy = newLbl(qs("© 2026  MIT License  ·  github.com/nim-lang/Nim"))
  copy.setAlign(4)
  copy.setStyleSheet(qs("color:#9ca0b0; font-size:11px; background:transparent;"))
  root.add(copy)

  inner.setLayout(root)
  scroll.setWidget(inner)

  let outerV = newVBox(); outerV.setMargins(0,0,0,0)
  outerV.add(scroll)
  page.setLayout(outerV)
  result = page

# ══════════════════════════════════════════════════════════════════════════════
#  Dock-панель — структура проекта
# ══════════════════════════════════════════════════════════════════════════════
proc buildProjectDock() =
  let dock = newDock(qs("Структура проекта"), gWin)
  dock.setAllowed(0x1 or 0x2)

  let tree = newTW()
  tree.setColCount(2)
  tree.setHeaders(["Элемент", "Значение"])
  tree.setAltColors(true)
  tree.setAnimated(true)

  let nNim = tree.addTopItem("📦 Nim Layer")
  discard nNim.addChild("Версия", "2.2.8")
  discard nNim.addChild("Бэкенд", "nim cpp")
  discard nNim.addChild("GC", "--mm:orc")
  discard nNim.addChild("Исключения", "--exceptions:cpp")
  discard nNim.addChild("Сборка", "-d:release")

  let nQt = tree.addTopItem("🔷 Qt6 Widgets")
  discard nQt.addChild("Версия", "6.10.2")
  discard nQt.addChild("libQt6Widgets", "✓")
  discard nQt.addChild("libQt6Gui", "✓")
  discard nQt.addChild("libQt6Core", "✓")

  let nBindings = tree.addTopItem("🔗 Биндинги")
  discard nBindings.addChild("qt6.nim", "importcpp + emit")
  discard nBindings.addChild("Callbacks", "cdecl + pointer")
  discard nBindings.addChild("Строки", "qs() → QString")

  let nOS = tree.addTopItem("🐧 Система")
  discard nOS.addChild("ОС", "Fedora Linux")
  discard nOS.addChild("Релиз", "fc43")
  discard nOS.addChild("Arch", "x86_64")
  discard nOS.addChild("Компилятор", "g++/clang++")

  tree.expandAll()
  tree.resizeCol(0)
  tree.resizeCol(1)

  dock.setWidget(tree.asW())
  gWin.addDock(2, dock)   # Qt::RightDockWidgetArea = 2

# ══════════════════════════════════════════════════════════════════════════════
#  MenuBar — все коллбэки cdecl
# ══════════════════════════════════════════════════════════════════════════════

# ── Коллбэки светлых тем ─────────────────────────────────────────────────────
proc cbThemeClassicBlue(ud: pointer) {.cdecl.} =
  applyLightTheme(themeClassicBlue, "Classic Blue")
proc cbThemeForestGreen(ud: pointer) {.cdecl.} =
  applyLightTheme(themeForestGreen, "Forest Green")
proc cbThemeCrimson(ud: pointer) {.cdecl.} =
  applyLightTheme(themeCrimson, "Crimson")
proc cbThemeSolarized(ud: pointer) {.cdecl.} =
  applyLightTheme(themeSolarized, "Solarized Light")
proc cbThemeGitHub(ud: pointer) {.cdecl.} =
  applyLightTheme(themeGitHub, "GitHub Light")
proc cbThemeNord(ud: pointer) {.cdecl.} =
  applyLightTheme(themeNord, "Nord Light")
proc cbThemeAmber(ud: pointer) {.cdecl.} =
  applyLightTheme(themeAmber, "Amber")
proc cbThemeHighContrast(ud: pointer) {.cdecl.} =
  applyLightTheme(themeHighContrast, "High Contrast")
proc cbThemeWindowsXP(ud: pointer) {.cdecl.} =
  applyLightTheme(themeWindowsXP, "Windows XP")
proc cbThemeWindows7(ud: pointer) {.cdecl.} =
  applyLightTheme(themeWindows7, "Windows 7")
proc cbThemeWindows10(ud: pointer) {.cdecl.} =
  applyLightTheme(themeWindows10, "Windows 10")
proc cbThemeWindows11(ud: pointer) {.cdecl.} =
  applyLightTheme(themeWindows11, "Windows 11")
proc cbThemeMacOS(ud: pointer) {.cdecl.} =
  applyLightTheme(themeMacOS, "macOS")

proc cbMenuNewTask(ud: pointer) {.cdecl.} =
  let (ok, text) = gWin.asW().dlgInput("Новая задача", "Текст задачи:", "")
  if ok and text.strip().len > 0:
    gTasks.addItem(qs(text.strip()))
    log(fmt"✚ «{text.strip()}»")
    status(fmt"Добавлено: «{text.strip()}»")

proc cbMenuSaveNote(ud: pointer) {.cdecl.} = cbNoteSave(nil)
proc cbMenuQuit(ud: pointer) {.cdecl.} =
  if gWin.asW().dlgYesNo("Выход", "Завершить работу?"):
    gApp.quit()

proc cbMenuClearTasks(ud: pointer) {.cdecl.} = cbClearTasks(nil)
proc cbMenuClearLog(ud: pointer) {.cdecl.} = cbClearLog(nil)
proc cbMenuLightTheme(ud: pointer) {.cdecl.} = applyTheme(false)
proc cbMenuDarkTheme(ud: pointer)  {.cdecl.} = applyTheme(true)

proc cbMenuInfo(ud: pointer) {.cdecl.} =
  gWin.asW().dlgInfo("Информация",
    "Nim + Qt6 Reference App\n\n" &
    "Прямые биндинги Qt6 из Nim без C++ обёрток.\n" &
    "Компиляция: nim cpp -d:release\n" &
    "Платформа: Fedora Linux x86_64")
  log("ℹ Показан диалог информации")

proc cbMenuWarn(ud: pointer) {.cdecl.} =
  gWin.asW().dlgWarn("Предупреждение",
    "Это тестовое предупреждение.\nВсё работает штатно.")
  log("⚠ Показан диалог предупреждения")

proc cbMenuErr(ud: pointer) {.cdecl.} =
  gWin.asW().dlgErr("Критическая ошибка",
    "Демонстрация диалога ошибки.\nРеально всё хорошо 😊")
  log("🔴 Показан диалог ошибки")

proc cbMenuInput(ud: pointer) {.cdecl.} =
  let (ok, text) = gWin.asW().dlgInput("Ввод текста", "Введите что-нибудь:", "Привет, Nim!")
  if ok:
    log(fmt"✏ Введено: «{text}»")
    status(fmt"Введено: «{text}»")

proc cbMenuAbout(ud: pointer) {.cdecl.} =
  gWin.asW().dlgAbout("О программе",
    "<h2>Nim + Qt6 Reference App v1.0</h2>" &
    "<p>Написано на <b>чистом Nim 2.2</b> с <b>Qt6 6.10</b>.</p>" &
    "<p>Компиляция: <code>nim cpp -d:release</code><br>" &
    "Платформа: Fedora Linux · x86_64</p>" &
    "<hr><p><small>© 2026 · MIT License</small></p>")
  log("? Открыт диалог «О программе»")

proc buildMenuBar() =
  # Файл
  let mFile = gWin.addMenu(qs("Файл"))
  let aN = mFile.newAction(qs("Новая задача"))
  aN.setShortcut("Ctrl+N"); aN.setTip(qs("Добавить задачу"))
  aN.onTriggered(cbMenuNewTask, nil)
  let aSave = mFile.newAction(qs("Сохранить заметку"))
  aSave.setShortcut("Ctrl+S"); aSave.setTip(qs("Сохранить заметку в файл"))
  aSave.onTriggered(cbMenuSaveNote, nil)
  mFile.addSep()
  let aQuit = mFile.newAction(qs("Выход"))
  aQuit.setShortcut("Ctrl+Q"); aQuit.setTip(qs("Завершить программу"))
  aQuit.onTriggered(cbMenuQuit, nil)

  # Правка
  let mEdit = gWin.addMenu(qs("Правка"))
  let aCT = mEdit.newAction(qs("Очистить задачи"))
  aCT.setShortcut("Ctrl+D"); aCT.onTriggered(cbMenuClearTasks, nil)
  let aCL = mEdit.newAction(qs("Очистить лог"))
  aCL.setShortcut("Ctrl+L"); aCL.onTriggered(cbMenuClearLog, nil)

  # Вид
  let mView = gWin.addMenu(qs("Вид"))

  # Подменю светлых тем
  let mLight = mView.addSubMenu(qs("☀  Светлые темы"))
  let aBlue  = mLight.newAction(qs("Classic Blue   — белый / синяя шапка"))
  aBlue.onTriggered(cbThemeClassicBlue, nil)
  let aGreen = mLight.newAction(qs("Forest Green   — зелёный / молочный"))
  aGreen.onTriggered(cbThemeForestGreen, nil)
  let aRed   = mLight.newAction(qs("Crimson        — бордовый / белый"))
  aRed.onTriggered(cbThemeCrimson, nil)
  let aSol   = mLight.newAction(qs("Solarized      — тёплый кремовый"))
  aSol.onTriggered(cbThemeSolarized, nil)
  let aGit   = mLight.newAction(qs("GitHub Light   — серая шапка / синий акцент"))
  aGit.onTriggered(cbThemeGitHub, nil)
  let aNord  = mLight.newAction(qs("Nord Light     — холодный арктический"))
  aNord.onTriggered(cbThemeNord, nil)
  let aAmb   = mLight.newAction(qs("Amber          — янтарный / оранжевый"))
  aAmb.onTriggered(cbThemeAmber, nil)
  let aHC    = mLight.newAction(qs("High Contrast  — максимальный контраст"))
  aHC.onTriggered(cbThemeHighContrast, nil)
  mLight.addSep()
  let aXP    = mLight.newAction(qs("Windows XP     — классический Luna"))
  aXP.onTriggered(cbThemeWindowsXP, nil)
  let aW7    = mLight.newAction(qs("Windows 7      — Aero Glass"))
  aW7.onTriggered(cbThemeWindows7, nil)
  let aW10   = mLight.newAction(qs("Windows 10     — Fluent плоский"))
  aW10.onTriggered(cbThemeWindows10, nil)
  let aW11   = mLight.newAction(qs("Windows 11     — Fluent Rounded"))
  aW11.onTriggered(cbThemeWindows11, nil)
  let aMac   = mLight.newAction(qs("macOS          — Aqua / Big Sur"))
  aMac.onTriggered(cbThemeMacOS, nil)

  let aDk = mView.newAction(qs("🌙  Тёмная тема  (Catppuccin Mocha)"))
  aDk.setShortcut("F10"); aDk.onTriggered(cbMenuDarkTheme, nil)

  # Диалоги
  let mDlg = gWin.addMenu(qs("Диалоги"))
  let aInfo2 = mDlg.newAction(qs("ℹ  Информация…"))
  aInfo2.setShortcut("F1"); aInfo2.onTriggered(cbMenuInfo, nil)
  let aWarn2 = mDlg.newAction(qs("⚠  Предупреждение…"))
  aWarn2.setShortcut("F2"); aWarn2.onTriggered(cbMenuWarn, nil)
  let aErr2 = mDlg.newAction(qs("🔴  Ошибка…"))
  aErr2.setShortcut("F3"); aErr2.onTriggered(cbMenuErr, nil)
  mDlg.addSep()
  let aIn = mDlg.newAction(qs("✏  Ввод текста…"))
  aIn.setShortcut("F4"); aIn.onTriggered(cbMenuInput, nil)

  # Помощь
  let mHelp = gWin.addMenu(qs("Помощь"))
  let aAb = mHelp.newAction(qs("О программе…"))
  aAb.setShortcut("F12"); aAb.onTriggered(cbMenuAbout, nil)

# ══════════════════════════════════════════════════════════════════════════════
#  ToolBar — cdecl коллбэки
# ══════════════════════════════════════════════════════════════════════════════

proc cbTBAdd(ud: pointer) {.cdecl.} = cbMenuNewTask(nil)
proc cbTBDel(ud: pointer) {.cdecl.} = cbDelTask(nil)
proc cbTBAbout(ud: pointer) {.cdecl.} = cbMenuAbout(nil)
proc cbTBQuit(ud: pointer) {.cdecl.} = cbMenuQuit(nil)
proc cbToggleTheme(ud: pointer) {.cdecl.} = applyTheme(not gIsDark)

proc buildToolBar() =
  let tb = gWin.addToolBar(qs("Основная"))
  tb.setMovable(false)

  let aN = tb.addAction(qs("➕  Задача"))
  aN.setTip(qs("Новая задача (Ctrl+N)"))
  aN.onTriggered(cbTBAdd, nil)

  let aD = tb.addAction(qs("🗑  Удалить"))
  aD.setTip(qs("Удалить выбранную задачу"))
  aD.onTriggered(cbTBDel, nil)

  tb.addSep()

  # Кнопка переключения темы (добавляем как QWidget)
  gThemeBtn = newBtn(qs("🌙  Тёмная тема"))
  gThemeBtn.setMinSize(150, 30)
  gThemeBtn.setStyleSheet(qs("""
    QPushButton { background:#ffffff; color:#2c5f9e;
      border:2px solid #ffffff; border-radius:6px;
      padding:5px 14px; font-weight:bold; }
    QPushButton:hover { background:#e8f0fc; }"""))
  gThemeBtn.onClicked(cbToggleTheme, nil)
  tb.addWidget(gThemeBtn)

  tb.addSep()

  let aAb = tb.addAction(qs("?  О программе"))
  aAb.setTip(qs("О программе (F12)"))
  aAb.onTriggered(cbTBAbout, nil)

  let aTBQuit = tb.addAction(qs("✕  Выход"))
  aTBQuit.setTip(qs("Выход (Ctrl+Q)"))
  aTBQuit.onTriggered(cbTBQuit, nil)

# ══════════════════════════════════════════════════════════════════════════════
#  Центральный виджет
# ══════════════════════════════════════════════════════════════════════════════
proc buildCentral() =
  let splt = newSplt(false)   # vertical
  splt.setChildCollapsible(false)
  splt.setHandleW(5)

  let tabs = newTab()
  tabs.addTab(buildTaskTab(),  qs("📋  Задачи"))
  tabs.addTab(buildNoteTab(),  qs("📝  Заметки"))
  tabs.addTab(buildLogTab(),   qs("📜  Лог"))
  tabs.addTab(buildAboutTab(), qs("ℹ  О программе"))
  splt.addWidget(tabs.asW())

  # Нижняя полоска с часами
  let bottom = newW()
  let hb = newHBox(); hb.setMargins(8, 4, 8, 4); hb.setSpacing(12)
  let info = newLbl(qs("Nim+Qt6 · nim cpp · Fedora"))
  info.setStyleSheet(qs("color:#6c6f85; font-size:11px; background:transparent;"))
  hb.add(info); hb.stretch()
  gClock = newLbl(qs(""))
  gClock.setStyleSheet(qs(
    "font-family:monospace; font-size:12px; font-weight:bold; background:transparent;"))
  hb.add(gClock)
  bottom.setLayout(hb)
  bottom.setFixedH(28)
  splt.addWidget(bottom)
  splt.setSizes(650, 28)

  gWin.setCentral(splt.asW())

# ══════════════════════════════════════════════════════════════════════════════
#  Таймер часов
# ══════════════════════════════════════════════════════════════════════════════
proc cbClock(ud: pointer) {.cdecl.} =
  gClock.setText(qs(currentTimeStr()))

# ══════════════════════════════════════════════════════════════════════════════
#  Точка входа
# ══════════════════════════════════════════════════════════════════════════════
when isMainModule:
  gApp = newApp()
  gApp.setAppName(qs("NimQt6App"))
  gApp.setOrgName(qs("NimExamples"))
  gApp.setAppVersion(qs("1.0.0"))

  # Светлая тема по умолчанию
  gApp.setStyleSheet(qs(lightTheme))
  gIsDark = false

  gWin = newWin()
  gWin.setTitle(qs("Nim + Qt6 — Эталонное приложение"))
  gWin.resize(1100, 720)
  gWin.setMinSize(800, 580)
  gWin.centerOnScreen()

  gSB = gWin.statusBar()

  buildMenuBar()
  buildToolBar()
  buildCentral()
  buildProjectDock()

  # Запустить таймер часов
  let timer = newTimer()
  timer.onTimeout(cbClock, nil)
  timer.start(1000)
  cbClock(nil)  # Первичное отображение

  gSB.showMsg(qs(
    "✓ Запущено  ·  Вид → Светлые темы  ·  F10 — тёмная  ·  Ctrl+N — задача"), 0)

  log("══════════════════════════════════════")
  log("  Nim + Qt6 Reference App v1.0")
  log(fmt"  Nim {NimVersion}  ·  Qt6 6.10  ·  Fedora")
  log("══════════════════════════════════════")
  log("Тема: Classic Blue (по умолчанию)")
  log("Меню «Вид» → «Светлые темы» — 13 вариантов")
  log("F10 — переключить в тёмную тему")
  log("Кнопка «🌙 Тёмная тема» в тулбаре")
  log("──────────────────────────────────────")
  log("Ctrl+N  — новая задача")
  log("Двойной клик по задаче — редактировать")
  log("Ctrl+S  — сохранить заметку")
  log("──────────────────────────────────────")

  gWin.show()
  discard gApp.exec()
