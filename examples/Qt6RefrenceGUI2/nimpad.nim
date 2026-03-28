## nimpad.nim — NimPad: образцовое приложение на Nim + Qt6
##
## Демонстрирует:
##   • nimQtWidgets  — QMainWindow, Tabs, Table, List, Splitter, Dock,
##                     SpinBox, Slider, Dial, ComboBox, CheckBox, Radio,
##                     ProgressBar, DateTimeEdit, ToolBar, StatusBar
##   • nimQtDialogs  — msgInfo/Warning/YesNo, inputText/Int/Float,
##                     fileOpen/Save, colorGet, fontGet, buildSimpleDialog
##   • nimQtCore     — QSettings, QTimer, QRegularExpression, QFile I/O,
##                     QElapsedTimer, sysProductName, sysCpuArch
##   • nimQtFFI      — QtAlignment, callback types CB/CBStr/CBInt/CBBool
##   • nimQtUtils    — qs(), nimStr(), toQStringList(), NimColor, NimRect
##
## Структура окна:
##   MenuBar  ── Файл | Правка | Вид | Инструменты | Помощь
##   ToolBar  ── быстрые действия
##   ─────────────────────────────────────────────────────
##   Left dock │  TabWidget (центр)
##   (Проект)  │    • Заметки (QTableWidget + редактор)
##             │    • Задачи  (QListWidget + чекбоксы)
##             │    • Виджеты (витрина всех контролов)
##             │    • Консоль (лог + QRegExp поиск)
##   ─────────────────────────────────────────────────────
##   StatusBar ── время | статус | прогресс-бар
##
## Компиляция:
##   nim cpp --mm:orc --exceptions:cpp -d:release --opt:speed \
##     --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Widgets)" \
##     --passL:"$(pkg-config --libs Qt6Widgets)" \
##     -o:nimpad nimpad.nim

import nimQtWidgets
import nimQtDialogs
import nimQtCore
import nimQtFFI
import nimQtUtils
import themes
import strformat, strutils, times, os, math


# ── Дополнительные asW для типов без overloads в nimQtWidgets ────────────────
proc asW*(d: Dial): W {.importcpp: "(QWidget*)#".}
proc asW*(l: LCD): W  {.importcpp: "(QWidget*)#".}
proc asW*(e: DtTmEdit): W {.importcpp: "(QWidget*)#".}
proc asW*(e: DtEdit): W   {.importcpp: "(QWidget*)#".}
proc asW*(e: TmEdit): W   {.importcpp: "(QWidget*)#".}

# ── setFixedSize / setMinSize для типов, не имеющих overloads в nimQtWidgets ─
proc setFixedSize*(d: Dial,    w, h: cint) {.importcpp: "#->setFixedSize(#, #)".}
proc setFixedSize*(l: LCD,     w, h: cint) {.importcpp: "#->setFixedSize(#, #)".}
proc setMinSize*(p: Prog,      w, h: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setMinSize*(c: Combo,     w, h: cint) {.importcpp: "#->setMinimumSize(#, #)".}
proc setMinSize*(e: DtTmEdit,  w, h: cint) {.importcpp: "#->setMinimumSize(#, #)".}

# ── Дополнительные proc для Act ──────────────────────────────────────────────
proc text*(a: Act): QString {.importcpp: "#->text()".}


# ── Подавление Qt-шума (font-size px → pointSize <= 0) ───────────────────────
{.emit: """
#include <QMessageLogContext>
#include <QtGlobal>
#include <cstdio>
#include <cstring>
static void _nimPadMsgHandler(QtMsgType type, const QMessageLogContext&, const QString& msg) {
  if (type == QtDebugMsg) {
    QByteArray b = msg.toUtf8();
    const char* s = b.constData();
    if (strstr(s, "setPointSize") || strstr(s, "Point size <= 0") ||
        strstr(s, "setPixelSize")) return;
    return;
  }
  fprintf(stderr, "%s\n", msg.toUtf8().constData());
}
static struct _NimPadMsgHandlerInstaller {
  _NimPadMsgHandlerInstaller() { qInstallMessageHandler(_nimPadMsgHandler); }
} _nimPadMsgHandlerInst;
""".}


proc asW*(tb: TB): W {.importcpp: "(QWidget*)#".}
# ── Локальный хелпер для CSS-имён виджетов ───────────────────────────────────
proc setObjectName(w: W, name: QString) =
  {.emit: "`w`->setObjectName(`name`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# Константы и стили
# ═══════════════════════════════════════════════════════════════════════════════

const AppName    = "NimPad"
const AppVersion = "1.0.0"
const OrgName    = "NimExamples"

# ── Таблица тем ──────────────────────────────────────────────────────────────
type ThemeEntry = tuple[name: string, css: string]

const allThemes*: seq[ThemeEntry] = @[
  ("Windows 7",       themeWindows7),
  ("Windows XP",      themeWindowsXP),
  ("Windows 10",      themeWindows10),
  ("Windows 11",      themeWindows11),
  ("macOS",           themeMacOS),
  ("Classic Blue",    themeClassicBlue),
  ("Forest Green",    themeForestGreen),
  ("Crimson",         themeCrimson),
  ("Solarized",       themeSolarized),
  ("GitHub",          themeGitHub),
  ("Nord",            themeNord),
  ("Amber",           themeAmber),
  ("High Contrast",   themeHighContrast),
  ("Dark (Mocha)",    darkTheme),
]

const DefaultTheme = "Windows 7"

# ═══════════════════════════════════════════════════════════════════════════════
# Глобальное состояние
# ═══════════════════════════════════════════════════════════════════════════════
var
  gApp:       App
  gWin:       Win
  gSB:        StatusBar
  gMFile:     Menu
  gMHelp:     Menu

  # Вкладка «Заметки»
  gNoteTable: TblW
  gNoteEdit:  TE
  gNoteTitle: LE
  gNoteIdx:   int = -1

  # Вкладка «Задачи»
  gTaskList:  LW
  gTaskLE:    LE
  gTaskProg:  Prog

  # Вкладка «Виджеты»
  gWgtSlider: Slider
  gWgtSpin:   Spin
  gWgtDial:   Dial
  gWgtProg:   Prog
  gWgtLcd:    LCD
  gWgtCombo:  Combo
  gWgtLabel:  Lbl
  gWgtDTEdit: DtTmEdit

  # Вкладка «Консоль»
  gConLog:    TE
  gConSearch: LE

  # Левый Dock — проводник
  gTree:      TW

  # Таймер часов
  gClockLbl:  Lbl

  # QSettings
  gSettings:     ptr QSettings

  # Текущая тема
  gCurrentTheme: string = DefaultTheme
  gThemeActions: seq[Act]

# ═══════════════════════════════════════════════════════════════════════════════
# Утилиты
# ═══════════════════════════════════════════════════════════════════════════════

proc ts(): string =
  now().format("HH:mm:ss")

proc log(msg: string) =
  if gConLog == nil: return
  let line = fmt"[{ts()}]  {msg}"
  append(gConLog, qs(line))

proc status(msg: string, ms: int = 5000) =
  if gSB == nil: return
  gSB.showMsg(qs(msg), ms.cint)

# ═══════════════════════════════════════════════════════════════════════════════
# Вкладка «Заметки» — QTableWidget + QTextEdit
# ═══════════════════════════════════════════════════════════════════════════════

proc applyTheme(name: string) =
  ## Применяет тему по имени; обновляет галочки в меню
  for e in allThemes:
    if e.name == name:
      setStyleSheet(gApp, qs(e.css))
      gCurrentTheme = name
      break
  # Обновляем галочки меню «Вид»
  for a in gThemeActions:
    setChecked(a, nimStr(text(a)) == name)
  if gSB != nil:
    status("Тема: " & name)
  if gSettings != nil:
    settingsBeginGroup(gSettings, "appearance")
    setVal(gSettings, "theme", name)
    settingsEndGroup(gSettings)
  log("🎨 Тема изменена: " & name)

proc notesRefreshTree() =
  ## Обновляет ветку «Заметки» в дереве проводника
  if gTree == nil or gNoteTable == nil: return
  var twiNotes: TWI
  {.emit: """
    for (int _ti = 0; _ti < `gTree`->topLevelItemCount(); ++_ti) {
      if (`gTree`->topLevelItem(_ti)->text(0).contains("Заметки")) {
        `twiNotes` = `gTree`->topLevelItem(_ti);
        break;
      }
    }
  """.}
  if twiNotes == nil: return
  {.emit: """
    while (`twiNotes`->childCount() > 0)
      delete `twiNotes`->takeChild(0);
  """.}
  for r in 0 ..< rowCount(gNoteTable):
    let title = gNoteTable.itemText(r.cint, 0)
    let dt    = gNoteTable.itemText(r.cint, 1)
    var ch: TWI
    {.emit: "`ch` = new QTreeWidgetItem(`twiNotes`);".}
    twiSetText(ch, 0, qs(title))
    twiSetText(ch, 1, qs(dt))

proc notesSave() =
  if gNoteIdx < 0: return
  let title = text(gNoteTitle)
  let body  = text(gNoteEdit)
  if title.strip().len == 0: return
  setItemText(gNoteTable, gNoteIdx.cint, 0, qs(title.strip()))
  setItemText(gNoteTable, gNoteIdx.cint, 2, qs(body))
  let dt = now().format("yyyy-MM-dd HH:mm")
  setItemText(gNoteTable, gNoteIdx.cint, 1, qs(dt))
  notesRefreshTree()
  log(fmt"💾 Заметка сохранена: «{title.strip()}»")
  status(fmt"Сохранено: «{title.strip()}»")

proc notesLoad(row: int) =
  if row < 0 or row >= rowCount(gNoteTable): return
  gNoteIdx = row
  setText(gNoteTitle, qs(gNoteTable.itemText(row.cint, 0)))
  setText(gNoteEdit, qs(gNoteTable.itemText(row.cint, 2)))
  log(fmt"📖 Открыта: «{gNoteTable.itemText(row.cint, 0)}»")

proc notesNew() =
  let row = rowCount(gNoteTable)
  insertRow(gNoteTable, row.cint)
  let dt = now().format("yyyy-MM-dd HH:mm")
  setItemText(gNoteTable, row.cint, 0, qs(fmt"Заметка {row+1}"))
  setItemText(gNoteTable, row.cint, 1, qs(dt))
  setItemText(gNoteTable, row.cint, 2, qs(""))
  setCurrentCell(gNoteTable, row.cint, 0)
  notesLoad(row)
  {.emit: "`gNoteTitle`->setFocus();".}
  notesRefreshTree()
  log(fmt"✚ Новая заметка #{row+1}")

proc notesDelete() =
  if gNoteIdx < 0: return
  let title = gNoteTable.itemText(gNoteIdx.cint, 0)
  if not msgYesNo(gWin.asW(), "Удалить заметку",
      fmt"Удалить «{title}»?"):
    return
  removeRow(gNoteTable, gNoteIdx.cint)
  gNoteIdx = -1
  setText(gNoteTitle, qs(""))
  setText(gNoteEdit, qs(""))
  if rowCount(gNoteTable) > 0:
    notesLoad(0)
  notesRefreshTree()
  log(fmt"🗑 Удалена: «{title}»")

proc notesExport() =
  if gNoteIdx < 0:
    msgWarning(gWin.asW(), "Нет выбора", "Выберите заметку для экспорта.")
    return
  let path = pickSaveFile(gWin.asW(), "Экспорт заметки",
    "Текстовые файлы (*.txt);;Все файлы (*)")
  if path.len == 0: return
  let title = gNoteTable.itemText(gNoteIdx.cint, 0)
  let body  = gNoteTable.itemText(gNoteIdx.cint, 2)
  let content = fmt"# {title}" & "\n\n" & body & "\n"
  let ok = writeTextFile(path, content)
  if ok:
    log(fmt"📤 Экспорт: {path}")
    status(fmt"Экспортировано в {path.splitPath().tail}")
  else:
    msgCritical(gWin.asW(), "Ошибка", "Не удалось сохранить файл.")

# Callbacks для заметок
proc cbNotesNew(ud: pointer) {.cdecl.}    = notesNew()
proc cbNotesDelete(ud: pointer) {.cdecl.} = notesDelete()
proc cbNotesSave(ud: pointer) {.cdecl.}   = notesSave()
proc cbNotesExport(ud: pointer) {.cdecl.} = notesExport()

proc cbNoteSelected(row, col, pr, pc: cint, ud: pointer) {.cdecl.} =
  notesLoad(row.int)

proc buildNotesTab(): W =
  let page = newWidget()

  let splt = newHSplitter(page)
  setHandleWidth(splt, 6)

  ## Левая панель — таблица заметок
  let leftW = newWidget(splt.asW())
  let lv = newVBox(leftW)
  setContentsMargins(lv, 8, 8, 8, 8)
  setSpacing(lv, 6)

  let hdr = newLabel(qs("📔  Заметки"), leftW)
  setStyleSheet(hdr, qs("font-size: 14pt; font-weight: bold; color: #0d6efd; background: transparent;"))
  add(lv, hdr)

  gNoteTable = newTableWidget(0, 3, leftW)
  setHorizontalHeaders(gNoteTable, ["Название", "Дата", "Содержимое"])
  setColumnHidden(gNoteTable, 2, true)
  setAlternatingRowColors(gNoteTable, true)
  setSelectionBehavior(gNoteTable, 1)  # SelectRows
  setSelectionMode(gNoteTable, 1)      # SingleSelection
  setEditTriggers(gNoteTable, 0)       # NoEditTriggers
  let hv = horizontalHeader(gNoteTable)
  hdrSetStretchLastSection(hv, false)
  hdrSetResizeMode(hv, 0, 1)  # Stretch
  hdrSetResizeMode(hv, 1, 2)  # ResizeToContents
  add(lv, gNoteTable)

  let btns = newHBox()
  setSpacing(btns, 6)
  let bNew = newBtn(qs("✚ Новая"), leftW)
  let bDel = newBtn(qs("🗑 Удалить"), leftW)
  setObjectName(bDel.asW(), qs("danger"))
  let bExp = newBtn(qs("📤 Экспорт"), leftW)
  setObjectName(bExp.asW(), qs("success"))
  setMinSize(bNew, 80, 30); setMinSize(bDel, 80, 30); setMinSize(bExp, 80, 30)
  add(btns, bNew); add(btns, bDel); stretch(btns)
  add(btns, bExp)
  let btnsW = newWidget(leftW); setLayout(btnsW, btns)
  add(lv, btnsW)
  setLayout(leftW, lv)

  ## Правая панель — редактор
  let rightW = newWidget(splt.asW())
  let rv = newVBox(rightW)
  setContentsMargins(rv, 8, 8, 8, 8)
  setSpacing(rv, 6)

  let hl = newHBox()
  let lblT = newLabel(qs("Заголовок:"), rightW)
  setStyleSheet(lblT, qs("font-weight:bold; background:transparent;"))
  add(hl, lblT)
  gNoteTitle = newLineEdit(qs(""), rightW)
  setPlaceholder(gNoteTitle, qs("Введите заголовок заметки…"))
  add(hl, gNoteTitle)
  let bSave = newBtn(qs("💾 Сохранить"), rightW)
  setObjectName(bSave.asW(), qs("success"))
  setMinSize(bSave, 110, 30)
  add(hl, bSave)
  let hlW = newWidget(rightW); setLayout(hlW, hl)
  add(rv, hlW)

  gNoteEdit = newTextEdit(rightW)
  setPlaceholder(gNoteEdit, qs("Начните вводить текст заметки…"))
  setStyleSheet(gNoteEdit, qs("font-size: 11pt; line-height: 1.4;"))
  add(rv, gNoteEdit)
  setLayout(rightW, rv)

  setSizes(splt, @[320, 600])

  let outerV = newVBox(page)
  setContentsMargins(outerV, 0, 0, 0, 0)
  add(outerV, splt)
  setLayout(page, outerV)

  onTblCurrentCellChanged(gNoteTable, cbNoteSelected, nil)
  onClicked(bNew, cbNotesNew, nil)
  onClicked(bDel, cbNotesDelete, nil)
  onClicked(bSave, cbNotesSave, nil)
  onClicked(bExp, cbNotesExport, nil)

  result = page

# ═══════════════════════════════════════════════════════════════════════════════
# Вкладка «Задачи» — QListWidget с чекбоксами
# ═══════════════════════════════════════════════════════════════════════════════

proc tasksDone(): int =
  var cnt = 0
  for i in 0 ..< count(gTaskList):
    let it = item(gTaskList, i.cint)
    if lwiCheckState(it) == 2: inc cnt
  cnt

proc tasksUpdateProgress() =
  let total = count(gTaskList)
  if total == 0:
    setRange(gTaskProg, 0, 1)
    setValue(gTaskProg, 0)
    setFormat(gTaskProg, qs("Нет задач"))
  else:
    let done = tasksDone()
    setRange(gTaskProg, 0, total.cint)
    setValue(gTaskProg, done.cint)
    setFormat(gTaskProg, qs(fmt"{done}/{total} выполнено"))

proc taskAdd(text: string) =
  if text.strip().len == 0: return
  let it = newLWI(qs(text.strip()))
  {.emit: "`it`->setFlags(Qt::ItemIsUserCheckable | Qt::ItemIsEnabled | Qt::ItemIsSelectable); `it`->setCheckState(Qt::Unchecked);".}
  addItem(gTaskList, it)
  tasksUpdateProgress()
  log(fmt"✚ Задача: «{text.strip()}»")
  status(fmt"Добавлено: «{text.strip()}»")

proc cbTaskAdd(ud: pointer) {.cdecl.} =
  let txt = text(gTaskLE).strip()
  if txt.len == 0:
    msgWarning(gWin.asW(), "Пустая задача", "Введите текст задачи.")
    return
  taskAdd(txt)
  clear(gTaskLE)

proc cbTaskDel(ud: pointer) {.cdecl.} =
  let row = currentRow(gTaskList)
  if row < 0:
    msgWarning(gWin.asW(), "Нет выбора", "Выберите задачу для удаления.")
    return
  let it = item(gTaskList, row.cint)
  let txt = lwiText(it)
  discard takeItem(gTaskList, row.cint)
  tasksUpdateProgress()
  log(fmt"🗑 Задача удалена: «{txt}»")

proc cbTaskClear(ud: pointer) {.cdecl.} =
  if count(gTaskList) == 0: return
  if not msgYesNo(gWin.asW(), "Очистить",
      "Удалить все задачи?"): return
  clear(gTaskList)
  tasksUpdateProgress()
  log("✖ Все задачи удалены")

proc cbTaskCheck(item: LWI, ud: pointer) {.cdecl.} =
  tasksUpdateProgress()
  log(fmt"☑ Изменено: «{lwiText(item)}»")

proc cbTaskDblClk(item: LWI, ud: pointer) {.cdecl.} =
  let s = lwiText(item)
  let res = inputText(gWin.asW(), "Редактировать", "Новый текст:", s)
  if res.ok and res.value.strip().len > 0:
    let row = currentRow(gTaskList)
    if row >= 0:
      let it = item(gTaskList, row.cint)
      lwiSetText(it, qs(res.value.strip()))
      log(fmt"✏ Изменено: «{res.value.strip()}»")

proc buildTasksTab(): W =
  let page = newWidget()
  let root = newVBox(page)
  setContentsMargins(root, 12, 12, 12, 12)
  setSpacing(root, 10)

  let hdr = newLabel(qs("✅  Менеджер задач"), page)
  setStyleSheet(hdr, qs("font-size: 14pt; font-weight: bold; color: #0d6efd; background: transparent;"))
  add(root, hdr)

  # Строка ввода
  let row1 = newHBox(); setSpacing(row1, 8)
  gTaskLE = newLineEdit(qs(""), page)
  setPlaceholder(gTaskLE, qs("Введите новую задачу…"))
  let bAdd = newBtn(qs("➕ Добавить"), page)
  setObjectName(bAdd.asW(), qs("success"))
  setMinSize(bAdd, 120, 34)
  add(row1, gTaskLE); add(row1, bAdd)
  let row1W = newWidget(page); setLayout(row1W, row1)
  add(root, row1W)

  # Список задач
  gTaskList = newListWidget(page)
  setAlternatingRowColors(gTaskList, true)
  setSelectionMode(gTaskList, 1)
  add(root, gTaskList)

  # Прогресс
  gTaskProg = newProgressBar(page)
  setMinSize(gTaskProg, 0, 28)
  setTextVisible(gTaskProg, true)
  add(root, gTaskProg)

  # Кнопки
  let row2 = newHBox(); setSpacing(row2, 8)
  let bDel = newBtn(qs("🗑 Удалить"), page)
  setObjectName(bDel.asW(), qs("danger"))
  let bClr = newBtn(qs("✖ Очистить"), page)
  setObjectName(bClr.asW(), qs("danger"))
  setMinSize(bDel, 110, 32); setMinSize(bClr, 110, 32)
  add(row2, bDel); add(row2, bClr); stretch(row2)
  let row2W = newWidget(page); setLayout(row2W, row2)
  add(root, row2W)

  setLayout(page, root)

  onReturnPressed(gTaskLE, cbTaskAdd, nil)
  onClicked(bAdd, cbTaskAdd, nil)
  onClicked(bDel, cbTaskDel, nil)
  onClicked(bClr, cbTaskClear, nil)
  onLWItemClicked(gTaskList, cbTaskCheck, nil)
  onLWItemDoubleClicked(gTaskList, cbTaskDblClk, nil)

  # Начальные задачи
  for t in [
    "🔷 Изучить обёртки nimQtWidgets",
    "🔷 Написать образцовое приложение",
    "🔶 Добавить QSettings для сохранения",
    "🔶 Протестировать все диалоги",
    "⚪ Оформить Makefile для Windows",
  ]:
    taskAdd(t)

  tasksUpdateProgress()
  result = page

# ═══════════════════════════════════════════════════════════════════════════════
# Вкладка «Виджеты» — витрина всех контролов
# ═══════════════════════════════════════════════════════════════════════════════

proc cbSliderChanged(v: cint, ud: pointer) {.cdecl.} =
  setValue(gWgtSpin, v)
  setValue(gWgtDial, v)
  setValue(gWgtProg, v)
  display(gWgtLcd, v.cdouble)
  setText(gWgtLabel, qs(fmt"Значение: {v}  ·  sin: {sin(v.float * PI / 180.0):.4f}"))
  log(fmt"🎚 Слайдер: {v}")

proc cbSpinChanged(v: cint, ud: pointer) {.cdecl.} =
  setValue(gWgtSlider, v)
  setValue(gWgtDial, v)
  setValue(gWgtProg, v)
  display(gWgtLcd, v.cdouble)

proc cbDialChanged(v: cint, ud: pointer) {.cdecl.} =
  setValue(gWgtSlider, v)
  setValue(gWgtSpin, v)
  setValue(gWgtProg, v)
  display(gWgtLcd, v.cdouble)

proc cbComboChanged(v: cint, ud: pointer) {.cdecl.} =
  let txt = currentText(gWgtCombo)
  log(fmt"📋 Комбо: «{txt}»")
  status(fmt"Выбрано: «{txt}»")

proc cbPickColor(ud: pointer) {.cdecl.} =
  let res = colorGet(gWin.asW(), "Выбрать цвет", 13, 110, 253)
  if res.ok:
    let css = fmt"background-color: rgb({res.r},{res.g},{res.b}); border-radius: 4px; border: 1px solid #dee2e6;"
    setStyleSheet(gWgtLabel, qs(css))
    log(fmt"🎨 Цвет: rgb({res.r},{res.g},{res.b})")

proc cbPickFont(ud: pointer) {.cdecl.} =
  let res = fontGet(gWin.asW(), "Выбрать шрифт")
  if res.ok:
    let css = fmt"font-family: '{res.family}'; font-size: {res.pointSize}pt;" &
              (if res.bold: " font-weight: bold;" else: "") &
              (if res.italic: " font-style: italic;" else: "")
    setStyleSheet(gWgtLabel, qs(css))
    log(fmt"🔤 Шрифт: {res.family} {res.pointSize}pt")

proc cbRadioToggled(checked: cint, ud: pointer) {.cdecl.} =
  let lbl = cast[Lbl](ud)
  if checked != 0:
    log(fmt"◎ Радио: «{text(lbl)}»")


proc cbBtnInt(ud: pointer) {.cdecl.} =
  let res = inputInt(gWin.asW(), "Ввод числа", "Введите целое (0–100):", 42, 0, 100)
  if res.ok:
    setValue(gWgtSlider, res.value.cint)
    log(fmt"🔢 Введено: {res.value}")

proc cbBtnFlt(ud: pointer) {.cdecl.} =
  let res = inputFloat(gWin.asW(), "Ввод числа", "Введите вещественное:", 3.14)
  if res.ok: log(fmt"🔣 Введено: {res.value:.4f}")

proc cbBtnTxt(ud: pointer) {.cdecl.} =
  let res = inputText(gWin.asW(), "Ввод текста", "Введите строку:", "Привет, Nim!")
  if res.ok: log(fmt"✏ Введено: «{res.value}»")

proc cbBtnFil(ud: pointer) {.cdecl.} =
  let path = pickOpenFile(gWin.asW(), "Открыть файл",
    "Текст (*.txt *.nim *.md);;Все файлы (*)")
  if path.len > 0: log(fmt"📂 Файл: {path}")

proc cbDlgTxt(ud: pointer) {.cdecl.} =
  let r = inputText(gWin.asW(), "Ввод", "Введите текст:", "Nim")
  if r.ok: log(fmt"✏ Введено: «{r.value}»")

proc cbDlgInt(ud: pointer) {.cdecl.} =
  let r = inputInt(gWin.asW(), "Ввод числа", "Введите целое:", 0)
  if r.ok: log(fmt"🔢 Число: {r.value}")

proc cbDlgFil(ud: pointer) {.cdecl.} =
  let p = pickOpenFile(gWin.asW(), "Открыть", "Все файлы (*)")
  if p.len > 0: log(fmt"📂 {p}")

proc buildWidgetsTab(): W =
  let page = newWidget()
  let scroll = newScrollArea(page)
  setResizable(scroll, true)

  let inner = newWidget()
  let root = newVBox(inner)
  setContentsMargins(root, 12, 12, 12, 12)
  setSpacing(root, 16)

  # Заголовок
  let hdr = newLabel(qs("🧩  Витрина виджетов Qt6"), inner)
  setStyleSheet(hdr, qs("font-size: 14pt; font-weight: bold; color: #0d6efd; background: transparent;"))
  add(root, hdr)

  # ── Группа 1: числовые контролы ──────────────────────────────────────────
  let grpNum = newGroupBox(qs("Числовые контролы (Slider ↔ SpinBox ↔ Dial)"), inner)
  let gvNum = newVBox(grpNum.asW())
  setSpacing(gvNum, 10)

  gWgtSlider = newSlider(1, inner)  # Horizontal
  setRange(gWgtSlider, 0, 100)
  setValue(gWgtSlider, 42)
  setTickPosition(gWgtSlider, 2)  # TicksBelow
  setTickInterval(gWgtSlider, 10)
  add(gvNum, gWgtSlider)

  let spinRow = newHBox(); setSpacing(spinRow, 16)
  let lblSpin = newLabel(qs("SpinBox:"), inner)
  setStyleSheet(lblSpin, qs("background: transparent; min-width: 70px;"))
  add(spinRow, lblSpin)
  gWgtSpin = newSpinBox(inner)
  setRange(gWgtSpin, 0, 100)
  setValue(gWgtSpin, 42)
  setSuffix(gWgtSpin, qs(" %"))
  add(spinRow, gWgtSpin)
  let lblDial = newLabel(qs("QDial:"), inner)
  setStyleSheet(lblDial, qs("background: transparent; min-width: 50px;"))
  add(spinRow, lblDial)
  gWgtDial = newDial(inner)
  setRange(gWgtDial, 0, 100)
  setValue(gWgtDial, 42)
  setNotchesVisible(gWgtDial, true)
  setFixedSize(gWgtDial, 80, 80)
  add(spinRow, gWgtDial.asW())
  stretch(spinRow)
  let spinRowW = newWidget(grpNum.asW()); setLayout(spinRowW, spinRow)
  add(gvNum, spinRowW)

  let lcdRow = newHBox(); setSpacing(lcdRow, 16)
  let lblLcd = newLabel(qs("QLCDNumber:"), inner)
  setStyleSheet(lblLcd, qs("background: transparent;"))
  add(lcdRow, lblLcd)
  gWgtLcd = newLCDNumber(4, inner)
  display(gWgtLcd, 42.cdouble)
  setFixedSize(gWgtLcd, 120, 50)
  add(lcdRow, gWgtLcd.asW())
  let lblProg = newLabel(qs("ProgressBar:"), inner)
  setStyleSheet(lblProg, qs("background: transparent;"))
  add(lcdRow, lblProg)
  gWgtProg = newProgressBar(inner)
  setRange(gWgtProg, 0, 100)
  setValue(gWgtProg, 42)
  setMinSize(gWgtProg, 200, 28)
  add(lcdRow, gWgtProg)
  stretch(lcdRow)
  let lcdRowW = newWidget(grpNum.asW()); setLayout(lcdRowW, lcdRow)
  add(gvNum, lcdRowW)

  setLayout(grpNum, gvNum)
  add(root, grpNum)

  # ── Группа 2: выбор и текст ───────────────────────────────────────────────
  let grpSel = newGroupBox(qs("Выпадающие списки и радиокнопки"), inner)
  let gvSel = newVBox(grpSel.asW())
  setSpacing(gvSel, 8)

  let comboRow = newHBox(); setSpacing(comboRow, 12)
  let lblCmb = newLabel(qs("ComboBox:"), inner)
  setStyleSheet(lblCmb, qs("background: transparent; min-width: 80px;"))
  add(comboRow, lblCmb)
  gWgtCombo = newComboBox(inner)
  addItems(gWgtCombo, @["🔵 Синий", "🟢 Зелёный", "🔴 Красный",
                        "🟡 Жёлтый", "🟣 Фиолетовый", "🟠 Оранжевый"])
  setMinSize(gWgtCombo, 200, 32)
  add(comboRow, gWgtCombo)
  stretch(comboRow)
  let comboRowW = newWidget(grpSel.asW()); setLayout(comboRowW, comboRow)
  add(gvSel, comboRowW)

  let radioRow = newHBox(); setSpacing(radioRow, 16)
  for rTxt in ["Вариант А", "Вариант Б", "Вариант В"]:
    let rb = newRadio(qs(rTxt), grpSel.asW())
    let lbl = newLabel(qs(rTxt))
    onRadioToggled(rb, cbRadioToggled, cast[pointer](lbl))
    add(radioRow, rb)
  stretch(radioRow)
  let radioRowW = newWidget(grpSel.asW()); setLayout(radioRowW, radioRow)
  add(gvSel, radioRowW)

  let chkRow = newHBox(); setSpacing(chkRow, 16)
  for cTxt in ["✓ Опция 1", "✓ Опция 2", "✓ Опция 3"]:
    let cb = newCheckBox(qs(cTxt), grpSel.asW())
    add(chkRow, cb)
  stretch(chkRow)
  let chkRowW = newWidget(grpSel.asW()); setLayout(chkRowW, chkRow)
  add(gvSel, chkRowW)

  setLayout(grpSel, gvSel)
  add(root, grpSel)

  # ── Группа 3: дата/время ──────────────────────────────────────────────────
  let grpDT = newGroupBox(qs("Дата и время"), inner)
  let gvDT = newHBox(grpDT.asW())
  setSpacing(gvDT, 12)
  let lblDT = newLabel(qs("QDateTimeEdit:"), grpDT.asW())
  setStyleSheet(lblDT, qs("background: transparent;"))
  add(gvDT, lblDT)
  gWgtDTEdit = newDateTimeEdit(grpDT.asW())
  setCalendarPopup(gWgtDTEdit, true)
  setCurrentDateTime(gWgtDTEdit)
  setDateTimeFormat(gWgtDTEdit, qs("dd.MM.yyyy  HH:mm:ss"))
  setMinSize(gWgtDTEdit, 240, 32)
  add(gvDT, gWgtDTEdit.asW())
  stretch(gvDT)
  setLayout(grpDT, gvDT)
  add(root, grpDT)

  # ── Группа 4: диалоги ────────────────────────────────────────────────────
  let grpDlg = newGroupBox(qs("Диалоги Qt6"), inner)
  let gvDlg = newVBox(grpDlg.asW())
  setSpacing(gvDlg, 8)

  let dlgRow1 = newHBox(); setSpacing(dlgRow1, 8)
  block:
    let bInfo = newBtn(qs("ℹ Info"), grpDlg.asW())
    let bWarn = newBtn(qs("⚠ Warning"), grpDlg.asW())
    let bErr  = newBtn(qs("🔴 Error"), grpDlg.asW())
    let bQst  = newBtn(qs("❓ Question"), grpDlg.asW())
    for b in [bInfo, bWarn, bErr, bQst]:
      setMinSize(b, 110, 32)
      add(dlgRow1, b)
    stretch(dlgRow1)
    onClicked(bInfo, proc(ud: pointer) {.cdecl.} =
      msgInfo(gWin.asW(), "Информация", "Nim + Qt6 работает отлично! 🎉"), nil)
    onClicked(bWarn, proc(ud: pointer) {.cdecl.} =
      msgWarning(gWin.asW(), "Предупреждение", "Тестовое предупреждение."), nil)
    onClicked(bErr, proc(ud: pointer) {.cdecl.} =
      msgCritical(gWin.asW(), "Ошибка", "Тестовая ошибка."), nil)
    onClicked(bQst, proc(ud: pointer) {.cdecl.} =
      (if msgYesNo(gWin.asW(), "Вопрос", "Вам нравится Nim + Qt6?"):
        log("💚 Ответ: Да!") else: log("💛 Ответ: Нет")), nil)
  let dlgRow1W = newWidget(grpDlg.asW()); setLayout(dlgRow1W, dlgRow1)
  add(gvDlg, dlgRow1W)

  let dlgRow2 = newHBox(); setSpacing(dlgRow2, 8)
  let bInt = newBtn(qs("🔢 Число"), grpDlg.asW())
  let bFlt = newBtn(qs("🔣 Float"), grpDlg.asW())
  let bTxt = newBtn(qs("✏ Текст"), grpDlg.asW())
  let bCol = newBtn(qs("🎨 Цвет"), grpDlg.asW())
  let bFnt = newBtn(qs("🔤 Шрифт"), grpDlg.asW())
  let bFil = newBtn(qs("📂 Файл"), grpDlg.asW())
  for b in [bInt, bFlt, bTxt, bCol, bFnt, bFil]:
    setMinSize(b, 90, 32)
    add(dlgRow2, b)
  stretch(dlgRow2)
  let dlgRow2W = newWidget(grpDlg.asW()); setLayout(dlgRow2W, dlgRow2)
  add(gvDlg, dlgRow2W)
  setLayout(grpDlg, gvDlg)
  add(root, grpDlg)

  # Индикатор под контролами
  gWgtLabel = newLabel(qs("Значение: 42  ·  sin: 0.6691"), inner)
  setStyleSheet(gWgtLabel, qs("background: #e9ecef; border-radius: 6px; padding: 8px; color: #212529; font-size: 11pt;"))
  setWordWrap(gWgtLabel, true)
  setAlignment(gWgtLabel, 0x0004 or 0x0080)  # HCenter|VCenter
  setMinSize(gWgtLabel, 0, 48)
  add(root, gWgtLabel)

  stretch(root)
  setWidget(scroll, inner)
  setLayout(inner, root)

  let outerV = newVBox(page)
  setContentsMargins(outerV, 0, 0, 0, 0)
  add(outerV, scroll)
  setLayout(page, outerV)

  # Подключение сигналов
  onSliderValueChanged(gWgtSlider, cbSliderChanged, nil)
  onSpinValueChanged(gWgtSpin, cbSpinChanged, nil)
  onDialValueChanged(gWgtDial, cbDialChanged, nil)
  onComboCurrentIndexChanged(gWgtCombo, cbComboChanged, nil)
  onClicked(bCol, cbPickColor, nil)
  onClicked(bFnt, cbPickFont, nil)

  onClicked(bInt, cbBtnInt, nil)
  onClicked(bFlt, cbBtnFlt, nil)
  onClicked(bTxt, cbBtnTxt, nil)
  onClicked(bFil, cbBtnFil, nil)

  result = page

# ═══════════════════════════════════════════════════════════════════════════════
# Вкладка «Консоль» — лог + поиск по регвыражению
# ═══════════════════════════════════════════════════════════════════════════════

proc cbConClear(ud: pointer) {.cdecl.} =
  clear(gConLog)
  log("── Консоль очищена ──")

proc cbConSearch(ud: pointer) {.cdecl.} =
  let pattern = text(gConSearch).strip()
  if pattern.len == 0:
    msgWarning(gWin.asW(), "Поиск", "Введите шаблон для поиска.")
    return
  let txt = text(gConLog)
  var matches = 0
  # QRegularExpression поиск через nimQtCore
  let re = newRegExp(pattern)
  let found = rxGlobalMatch(re, txt)
  matches = found.len
  log(fmt"🔍 Регекс «{pattern}»: {matches} совпадений")
  status(fmt"Найдено: {matches}")

proc buildConsoleTab(): W =
  let page = newWidget()
  let root = newVBox(page)
  setContentsMargins(root, 12, 12, 12, 12)
  setSpacing(root, 8)

  let hdr = newLabel(qs("📟  Консоль событий"), page)
  setStyleSheet(hdr, qs("font-size: 14pt; font-weight: bold; color: #0d6efd; background: transparent;"))
  add(root, hdr)

  let ctrlRow = newHBox(); setSpacing(ctrlRow, 8)
  gConSearch = newLineEdit(qs(""), page)
  setPlaceholder(gConSearch, qs("Регулярное выражение для поиска в логе…"))
  let bSearch = newBtn(qs("🔍 Искать"), page)
  let bClear  = newBtn(qs("🧹 Очистить"), page)
  setObjectName(bClear.asW(), qs("danger"))
  setMinSize(bSearch, 100, 32); setMinSize(bClear, 100, 32)
  add(ctrlRow, gConSearch)
  add(ctrlRow, bSearch)
  add(ctrlRow, bClear)
  let ctrlW = newWidget(page); setLayout(ctrlW, ctrlRow)
  add(root, ctrlW)

  gConLog = newTextEdit(page)
  setReadOnly(gConLog, true)
  setStyleSheet(gConLog, qs(
    "font-family: 'Consolas', 'Courier New', monospace; font-size: 10pt; background: #1e1e2e; color: #cdd6f4;"))
  add(root, gConLog)

  setLayout(page, root)

  onClicked(bSearch, cbConSearch, nil)
  onClicked(bClear, cbConClear, nil)
  onReturnPressed(gConSearch, cbConSearch, nil)

  result = page

# ═══════════════════════════════════════════════════════════════════════════════
# Левый Dock — проводник
# ═══════════════════════════════════════════════════════════════════════════════

proc buildProjectDock() =
  let dock = newDockWidget(qs("📁  Проводник"), gWin)
  setAllowedAreas(dock, 0x0f)  # All areas

  gTree = newTreeWidget(dock.asW())
  setColCount(gTree, 2)
  setHeaders(gTree, ["Элемент", "Инфо"])
  setAltColors(gTree, true)
  setAnimated(gTree, true)
  setHeaderHidden(gTree, false)

  # Ветка приложения
  let nApp = addTopItem(gTree, "🦎 " & AppName)
  proc mkChild(p: TWI, c0, c1: string): TWI =
    result = addChild(p, [c0, c1])
  discard mkChild(nApp, "Платформа", sysProductName())
  discard mkChild(nApp, "Архитектура", sysCpuArch())
  discard mkChild(nApp, "Qt версия", qtVersionStr())
  discard mkChild(nApp, "Nim версия", NimVersion)

  # Ветка заметок (будет обновляться)
  let nNotes = mkChild(nApp, "📔 Заметки", "0")
  discard mkChild(nNotes, "(пусто)", "")

  # Ветка задач
  let nTasks = mkChild(nApp, "✅ Задачи", "")
  discard mkChild(nTasks, "Активных", "0")
  discard mkChild(nTasks, "Выполнено", "0")

  # QSettings
  let nCfg = mkChild(nApp, "⚙ Настройки", "")
  if gSettings != nil:
    discard mkChild(nCfg, "Файл", settingsFileName(gSettings))

  twiSetExpanded(nApp, true)
  twiSetExpanded(nNotes, true)
  resizeCol(gTree, 0)

  setWidget(dock, gTree.asW())
  addDock(gWin, 0x01, dock)  # LeftDockWidgetArea

# ═══════════════════════════════════════════════════════════════════════════════
# MenuBar
# ═══════════════════════════════════════════════════════════════════════════════

proc cbMenuQuit(ud: pointer) {.cdecl.} =
  if msgYesNo(gWin.asW(), "Выход", "Завершить NimPad?"):
    settingsSync(gSettings)
    gApp.quit()

proc cbMenuNewNote(ud: pointer)  {.cdecl.} = notesNew()
proc cbMenuSave(ud: pointer)     {.cdecl.} = notesSave()
proc cbMenuAbout(ud: pointer)    {.cdecl.} =
  msgAbout(gWin.asW(), fmt"О программе {AppName}",
    fmt"<h2>🦎 {AppName} v{AppVersion}</h2>" &
    "<p>Образцовое приложение на <b>Nim 2.x</b> + <b>Qt6</b>.</p>" &
    "<p>Демонстрирует все обёртки системы:<br>" &
    "<code>nimQtWidgets · nimQtDialogs · nimQtCore</code><br>" &
    "<code>nimQtFFI · nimQtUtils</code></p>" &
    "<hr><p>Компиляция: <code>nim cpp --mm:orc --exceptions:cpp -d:release</code></p>" &
    fmt"<p>Qt {qtVersionStr()} · {sysProductName()}</p>" &
    "<p><small>© 2026 · MIT License</small></p>")

proc buildMenuBar() =
  # Файл
  gMFile = addMenu(gWin, qs("Файл"))
  let mFile = gMFile
  let aN = newAction(mFile, qs("✚ Новая заметка"))
  setShortcut(aN, "Ctrl+N"); setTip(aN, qs("Создать новую заметку"))
  onTriggered(aN, cbMenuNewNote, nil)
  let aSave = newAction(mFile, qs("💾 Сохранить"))
  setShortcut(aSave, "Ctrl+S"); setTip(aSave, qs("Сохранить текущую заметку"))
  onTriggered(aSave, cbMenuSave, nil)
  let aExp = newAction(mFile, qs("📤 Экспорт…"))
  setShortcut(aExp, "Ctrl+E"); setTip(aExp, qs("Экспорт заметки в файл"))
  onTriggered(aExp, cbNotesExport, nil)
  addSep(mFile)
  let aQ = newAction(mFile, qs("Выход"))
  setShortcut(aQ, "Ctrl+Q")
  onTriggered(aQ, cbMenuQuit, nil)

  # Правка
  let mEdit = addMenu(gWin, qs("Правка"))
  let aDel = newAction(mEdit, qs("🗑 Удалить заметку"))
  setShortcut(aDel, "Delete")
  onTriggered(aDel, cbNotesDelete, nil)
  let aClr = newAction(mEdit, qs("✖ Очистить задачи"))
  setShortcut(aClr, "Ctrl+D")
  onTriggered(aClr, cbTaskClear, nil)

  # Диалоги
  let mDlg = addMenu(gWin, qs("Диалоги"))
  block:
    let aDlgInfo = newAction(mDlg, qs("ℹ Информация…"))
    let aDlgWarn = newAction(mDlg, qs("⚠ Предупреждение…"))
    let aDlgErr  = newAction(mDlg, qs("🔴 Ошибка…"))
    let aDlgTxt  = newAction(mDlg, qs("✏ Ввод текста…"))
    let aDlgInt  = newAction(mDlg, qs("🔢 Ввод числа…"))
    let aDlgFil  = newAction(mDlg, qs("📁 Открыть файл…"))
    setShortcut(aDlgInfo, "F1"); setShortcut(aDlgWarn, "F2")
    setShortcut(aDlgErr,  "F3"); setShortcut(aDlgTxt,  "F4")
    setShortcut(aDlgInt,  "F5"); setShortcut(aDlgFil,  "F6")
    onTriggered(aDlgInfo, proc(ud: pointer) {.cdecl.} =
      msgInfo(gWin.asW(), "Информация", "Всё работает штатно.\nNim + Qt6 = ❤"), nil)
    onTriggered(aDlgWarn, proc(ud: pointer) {.cdecl.} =
      msgWarning(gWin.asW(), "Предупреждение", "Тестовое предупреждение."), nil)
    onTriggered(aDlgErr, proc(ud: pointer) {.cdecl.} =
      msgCritical(gWin.asW(), "Ошибка", "Тестовая ошибка."), nil)
    onTriggered(aDlgTxt, cbDlgTxt, nil)
    onTriggered(aDlgInt, cbDlgInt, nil)
    onTriggered(aDlgFil, cbDlgFil, nil)

  # Вид — смена тем
  let mView = addMenu(gWin, qs("Вид"))
  let ag = newActionGroup(gWin.asW())
  setExclusive(ag, true)
  gThemeActions = @[]
  for i, e in allThemes:
    let a = newAction(mView, qs(e.name))
    setCheckable(a, true)
    setChecked(a, e.name == gCurrentTheme)
    discard addAction(ag, a)
    gThemeActions.add(a)
  # Единый обработчик группы — ищем нажатое действие по тексту
  onActionGroupTriggered(ag, proc(a: Act, ud: pointer) {.cdecl.} =
    let nm = nimStr(text(a))
    applyTheme(nm), nil)

  # Помощь
  gMHelp = addMenu(gWin, qs("Помощь"))
  let mHelp = gMHelp
  let aAb = newAction(mHelp, qs("О программе…"))
  setShortcut(aAb, "F12"); onTriggered(aAb, cbMenuAbout, nil)
  let aQt = newAction(mHelp, qs("О Qt…"))
  onTriggered(aQt, proc(ud: pointer) {.cdecl.} =
    msgAboutQt(gWin.asW(), "О Qt"), nil)

# ═══════════════════════════════════════════════════════════════════════════════
# ToolBar
# ═══════════════════════════════════════════════════════════════════════════════

proc buildToolBar() =
  let tb = addToolBar(gWin, qs("Основная"))
  setMovable(tb, false)

  block:
    # Qt6: QAction(QString, QObject*) - no QWidget* as first arg
    let aTBNew  = newAction(gMFile, qs("✚ Заметка"))
    let aTBSave = newAction(gMFile, qs("💾 Сохранить"))
    let aTBExp  = newAction(gMFile, qs("📤 Экспорт"))
    let aTBDel  = newAction(gMFile, qs("🗑 Удалить"))
    setTip(aTBNew,  qs("Новая заметка (Ctrl+N)"))
    setTip(aTBSave, qs("Сохранить заметку (Ctrl+S)"))
    setTip(aTBExp,  qs("Экспорт в файл (Ctrl+E)"))
    setTip(aTBDel,  qs("Удалить заметку"))
    onTriggered(aTBNew,  cbMenuNewNote,   nil)
    onTriggered(aTBSave, cbMenuSave,      nil)
    onTriggered(aTBExp,  cbNotesExport,   nil)
    onTriggered(aTBDel,  cbNotesDelete,   nil)
    addAction(tb, aTBNew)
    addAction(tb, aTBSave)
    addAction(tb, aTBExp)
    addAction(tb, aTBDel)

  discard addSep(tb)

  gClockLbl = newLabel(qs(""), tb.asW())
  setStyleSheet(gClockLbl, qs(
    "color: #f8f9fa; font-family: monospace; font-size: 10pt; padding: 0 12px; background: transparent;"))
  discard addWidget(tb, gClockLbl.asW())

  discard addSep(tb)

  let aTBAb = newAction(gMHelp, qs("?  О программе"))
  addAction(tb, aTBAb)
  onTriggered(aTBAb, cbMenuAbout, nil)
  let aTBQ = newAction(gMFile, qs("✕  Выход"))
  addAction(tb, aTBQ)
  onTriggered(aTBQ, cbMenuQuit, nil)

# ═══════════════════════════════════════════════════════════════════════════════
# StatusBar
# ═══════════════════════════════════════════════════════════════════════════════

proc buildStatusBar() =
  gSB = statusBar(gWin)
  let infoLbl = newLabel(qs(fmt"NimPad {AppVersion}  ·  Qt {qtVersionStr()}  ·  {sysProductName()}"), nil)
  setStyleSheet(infoLbl, qs("color: #6c757d; font-size: 9pt; background: transparent;"))
  addPermanentWidget(gSB, infoLbl.asW())

# ═══════════════════════════════════════════════════════════════════════════════
# Таймер часов
# ═══════════════════════════════════════════════════════════════════════════════

proc cbClock(ud: pointer) {.cdecl.} =
  let t = now().format("HH:mm:ss  dd.MM.yyyy")
  setText(gClockLbl, qs(t))

# ═══════════════════════════════════════════════════════════════════════════════
# QSettings — сохранение/восстановление состояния
# ═══════════════════════════════════════════════════════════════════════════════

proc saveSettings() =
  if gSettings == nil: return
  settingsBeginGroup(gSettings, "geometry")
  setValBool(gSettings, "maximized", false)
  settingsEndGroup(gSettings)
  settingsBeginGroup(gSettings, "appearance")
  setVal(gSettings, "theme", gCurrentTheme)
  settingsEndGroup(gSettings)
  settingsBeginGroup(gSettings, "notes")
  setValInt(gSettings, "count", rowCount(gNoteTable))
  for i in 0 ..< rowCount(gNoteTable):
    setVal(gSettings, fmt"title_{i}", gNoteTable.itemText(i.cint, 0))
    setVal(gSettings, fmt"date_{i}", gNoteTable.itemText(i.cint, 1))
    setVal(gSettings, fmt"body_{i}", gNoteTable.itemText(i.cint, 2))
  settingsEndGroup(gSettings)
  settingsSync(gSettings)
  log(fmt"⚙ Настройки сохранены: {settingsFileName(gSettings)}")

proc loadSettings() =
  if gSettings == nil: return
  settingsBeginGroup(gSettings, "appearance")
  let savedTheme = getVal(gSettings, "theme", DefaultTheme)
  settingsEndGroup(gSettings)
  if savedTheme.len > 0:
    applyTheme(savedTheme)
  settingsBeginGroup(gSettings, "notes")
  let count = getValInt(gSettings, "count", 0).int
  settingsEndGroup(gSettings)
  if count == 0: return
  settingsBeginGroup(gSettings, "notes")
  for i in 0 ..< count:
    let title = getVal(gSettings, fmt"title_{i}", fmt"Заметка {i+1}")
    let dt    = getVal(gSettings, fmt"date_{i}", "")
    let body  = getVal(gSettings, fmt"body_{i}", "")
    let row   = rowCount(gNoteTable)
    insertRow(gNoteTable, row.cint)
    setItemText(gNoteTable, row.cint, 0, qs(title))
    setItemText(gNoteTable, row.cint, 1, qs(dt))
    setItemText(gNoteTable, row.cint, 2, qs(body))
  settingsEndGroup(gSettings)
  if rowCount(gNoteTable) > 0:
    notesLoad(0)
  log(fmt"⚙ Загружено {count} заметок из настроек")

# ═══════════════════════════════════════════════════════════════════════════════
# Центральный виджет
# ═══════════════════════════════════════════════════════════════════════════════

proc buildCentral() =
  let tabs = newTabWidget()
  setDocumentMode(tabs, true)
  setMovable(tabs, false)

  discard addTab(tabs, buildNotesTab(),   qs("📔  Заметки"))
  discard addTab(tabs, buildTasksTab(),   qs("✅  Задачи"))
  discard addTab(tabs, buildWidgetsTab(), qs("🧩  Виджеты"))
  discard addTab(tabs, buildConsoleTab(), qs("📟  Консоль"))

  setCentral(gWin, tabs.asW())

# ═══════════════════════════════════════════════════════════════════════════════
# Точка входа
# ═══════════════════════════════════════════════════════════════════════════════

when isMainModule:
  gApp = newApp()
  setAppName(gApp, qs(AppName))
  setOrgName(gApp, qs(OrgName))
  setAppVersion(gApp, qs(AppVersion))

  gSettings = newSettings(OrgName, AppName)

  # Читаем сохранённую тему до построения окна, чтобы оно сразу отрисовалось в нужной теме
  settingsBeginGroup(gSettings, "appearance")
  let initTheme = getVal(gSettings, "theme", DefaultTheme)
  settingsEndGroup(gSettings)
  # Применяем CSS напрямую (gSB/gWin ещё nil, используем setStyleSheet(App))
  block:
    var found = false
    for e in allThemes:
      if e.name == initTheme:
        setStyleSheet(gApp, qs(e.css))
        gCurrentTheme = e.name
        found = true
        break
    if not found:
      setStyleSheet(gApp, qs(themeWindows7))
      gCurrentTheme = DefaultTheme

  gWin = newWin()
  setTitle(gWin, qs(fmt"{AppName} — образцовое Nim + Qt6 приложение"))
  resize(gWin, 1200, 760)
  setMinSize(gWin, 900, 600)
  centerOnScreen(gWin)
  setDockNestingEnabled(gWin, true)
  setAnimated(gWin, true)

  buildMenuBar()
  buildToolBar()
  buildStatusBar()
  buildCentral()
  buildProjectDock()

  # Начальные заметки (если нет сохранённых)
  settingsBeginGroup(gSettings, "notes")
  let savedCount = getValInt(gSettings, "count", 0).int
  settingsEndGroup(gSettings)
  if savedCount == 0:
    let initNotes = [
      ("Добро пожаловать в NimPad! 🦎",
       "NimPad — образцовое приложение на чистом Nim + Qt6.\n\n" &
       "Все элементы управления — прямые биндинги Qt6 через importcpp.\n" &
       "Никаких C++ оберток, никаких дополнительных фреймворков.\n\n" &
       "Вкладки:\n" &
       "• Заметки — QTableWidget + QTextEdit с сохранением\n" &
       "• Задачи — QListWidget с чекбоксами и прогрессом\n" &
       "• Виджеты — витрина всех контролов Qt6\n" &
       "• Консоль — лог событий с поиском по RegExp"),
      ("Горячие клавиши",
       "Ctrl+N — новая заметка\n" &
       "Ctrl+S — сохранить заметку\n" &
       "Ctrl+E — экспорт в файл\n" &
       "Ctrl+Q — выход\n" &
       "F1..F6 — диалоги\n" &
       "F12    — о программе"),
      ("Архитектура обёрток",
       "nimQtFFI.nim    — типы CB/CBStr/CBInt/CBBool, перечисления Qt\n" &
       "nimQtUtils.nim  — QString↔string, QStringList↔seq, NimColor...\n" &
       "nimQtCore.nim   — QTimer, QSettings, QFile, QRegExp, QThread...\n" &
       "nimQtWidgets.nim — все виджеты: Button, Table, List, Splitter...\n" &
       "nimQtDialogs.nim — msgInfo/Warn/YesNo, inputText/Int, filePick..."),
    ]
    for (title, body) in initNotes:
      let row = rowCount(gNoteTable)
      insertRow(gNoteTable, row.cint)
      let dt = now().format("yyyy-MM-dd HH:mm")
      setItemText(gNoteTable, row.cint, 0, qs(title))
      setItemText(gNoteTable, row.cint, 1, qs(dt))
      setItemText(gNoteTable, row.cint, 2, qs(body))
    notesLoad(0)
    notesRefreshTree()
  else:
    loadSettings()

  # Таймер часов
  let timer = newTimer(cast[Obj](nil))
  onTimeout(timer, cbClock, nil)
  start(timer, 1000)
  cbClock(nil)

  showMsg(gSB, qs("✓ NimPad готов  ·  Ctrl+N — заметка  ·  F12 — о программе"), 0)

  log("══════════════════════════════════════════")
  log(fmt"  {AppName} v{AppVersion}")
  log(fmt"  Nim {NimVersion}  ·  Qt {qtVersionStr()}")
  log(fmt"  {sysProductName()}  ·  {sysCpuArch()}")
  log("══════════════════════════════════════════")
  log("Используйте вкладку «Виджеты» для демонстрации")
  log("всех контролов Qt6 с живыми сигналами.")
  log("──────────────────────────────────────────")

  show(gWin)
  discard exec(gApp)
  saveSettings()
