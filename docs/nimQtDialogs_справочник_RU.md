# nimQtDialogs — Полный справочник библиотеки

> **Версия:** Qt6Widgets · **Компилятор:** `nim cpp --passC:"-std=c++20"`  
> **Зависимости:** `nimQtUtils`, `nimQtFFI`, `nimQtWidgets`  
> **Совместимость:** Qt 6.2+ (полностью), Qt 6.7+ (расширенные enum), Qt 6.11 (setCheckBox API)

---

## Содержание

1. [Конфигурация компилятора](#конфигурация-компилятора)
2. [Типы и псевдонимы](#типы-и-псевдонимы)
3. [Перечисления (enum)](#перечисления-enum)
4. [Nim-типы результатов](#nim-типы-результатов)
5. [QMessageBox — статические методы](#qmessagebox--статические-методы)
6. [QMessageBox — объектный API](#qmessagebox--объектный-api)
7. [QMessageBox — сигналы](#qmessagebox--сигналы)
8. [QInputDialog — статические методы](#qinputdialog--статические-методы)
9. [QInputDialog — объектный API](#qinputdialog--объектный-api)
10. [QInputDialog — сигналы](#qinputdialog--сигналы)
11. [QFileDialog — статические методы](#qfiledialog--статические-методы)
12. [QFileDialog — объектный API](#qfiledialog--объектный-api)
13. [QFileDialog — сигналы](#qfiledialog--сигналы)
14. [QFontDialog](#qfontdialog)
15. [QFontDialog — сигналы](#qfontdialog--сигналы)
16. [QColorDialog](#qcolordialog)
17. [QColorDialog — сигналы](#qcolordialog--сигналы)
18. [QProgressDialog](#qprogressdialog)
19. [QErrorMessage](#qerrormessage)
20. [QDialogButtonBox](#qdialogbuttonbox)
21. [QDialogButtonBox — сигналы](#qdialogbuttonbox--сигналы)
22. [QDialog — базовый кастомный диалог](#qdialog--базовый-кастомный-диалог)
23. [QDialog — builder-хелперы](#qdialog--builder-хелперы)
24. [QDialog — сигналы](#qdialog--сигналы)
25. [QWizard — мастер](#qwizard--мастер)
26. [QWizard — сигналы](#qwizard--сигналы)
27. [QWizardPage — страница мастера](#qwizardpage--страница-мастера)
28. [Высокоуровневые Nim-утилиты](#высокоуровневые-nim-утилиты)

---

## Конфигурация компилятора

```nim
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

---

## Типы и псевдонимы

### Opaque Qt-типы

| Nim-тип | Qt-класс | Описание |
|---|---|---|
| `QMessageBox` | `QMessageBox` | Диалог информации, предупреждений, ошибок |
| `QInputDialog` | `QInputDialog` | Диалог ввода данных |
| `QFileDialog` | `QFileDialog` | Диалог файловой системы |
| `QFontDialog` | `QFontDialog` | Диалог выбора шрифта |
| `QColorDialog` | `QColorDialog` | Диалог выбора цвета |
| `QProgressDialog` | `QProgressDialog` | Диалог прогресса |
| `QErrorMessage` | `QErrorMessage` | Подавляемые сообщения об ошибках |
| `QDialogButtonBox` | `QDialogButtonBox` | Стандартная панель кнопок |

### Псевдонимы указателей

```nim
type
  MsgBox*  = ptr QMessageBox
  InDlg*   = ptr QInputDialog
  FileDlg* = ptr QFileDialog
  FontDlg* = ptr QFontDialog
  ColDlg*  = ptr QColorDialog
  ProgDlg* = ptr QProgressDialog
  ErrMsg*  = ptr QErrorMessage
  Wiz*     = ptr QWizard          # из nimQtWidgets
  CDlg*    = ptr QDialog          # из nimQtWidgets
  DlgBBx*  = ptr QDialogButtonBox
  AbsBtn*  = ptr QAbstractButton  # из nimQtWidgets
```

---

## Перечисления (enum)

### MsgBoxIcon — иконки QMessageBox

```nim
type MsgBoxIcon* = enum
  MBNoIcon      = 0  # Без иконки
  MBInformation = 1  # Информация (i)
  MBWarning     = 2  # Предупреждение (!)
  MBCritical    = 3  # Критическая ошибка (X)
  MBQuestion    = 4  # Вопрос (?)
```

### MsgBoxStdBtn — стандартные кнопки QMessageBox

```nim
type MsgBoxStdBtn* = enum
  MBBtnNoButton        = 0x00000000
  MBBtnOk              = 0x00000400
  MBBtnSave            = 0x00000800
  MBBtnSaveAll         = 0x00001000
  MBBtnOpen            = 0x00002000
  MBBtnYes             = 0x00004000
  MBBtnYesToAll        = 0x00008000
  MBBtnNo              = 0x00010000
  MBBtnNoToAll         = 0x00020000
  MBBtnAbort           = 0x00040000
  MBBtnRetry           = 0x00080000
  MBBtnIgnore          = 0x00100000
  MBBtnClose           = 0x00200000
  MBBtnCancel          = 0x00400000
  MBBtnDiscard         = 0x00800000
  MBBtnHelp            = 0x01000000
  MBBtnApply           = 0x02000000
  MBBtnReset           = 0x04000000
  MBBtnRestoreDefaults = 0x08000000
```

### MsgBoxRole — роли кнопок QMessageBox

```nim
type MsgBoxRole* = enum
  MBRoleInvalid     = -1
  MBRoleAccept      =  0
  MBRoleReject      =  1
  MBRoleDestructive =  2
  MBRoleAction      =  3
  MBRoleHelp        =  4
  MBRoleYes         =  5
  MBRoleNo          =  6
  MBRoleReset       =  7
  MBRoleApply       =  8
```

### DlgBBxStdBtn — кнопки QDialogButtonBox

Аналогичны `MsgBoxStdBtn`, с префиксом `DBB`:

```nim
DBBNoButton, DBBOk, DBBSave, DBBSaveAll, DBBOpen,
DBBYes, DBBYesToAll, DBBNo, DBBNoToAll, DBBAbort,
DBBRetry, DBBIgnore, DBBClose, DBBCancel, DBBDiscard,
DBBHelp, DBBApply, DBBReset, DBBRestoreDefaults
```

### DlgBBxRole — роли кнопок QDialogButtonBox

```nim
DBBRoleInvalid=-1, DBBRoleAccept=0, DBBRoleReject=1,
DBBRoleDestructive=2, DBBRoleAction=3, DBBRoleHelp=4,
DBBRoleYes=5, DBBRoleNo=6, DBBRoleReset=7, DBBRoleApply=8
```

### DlgResult — результат диалога

```nim
type DlgResult* = enum
  DlgRejected = 0  # Cancel / No / закрытие крестиком
  DlgAccepted = 1  # OK / Yes / Finish
```

### Режимы и флаги QFileDialog

```nim
type FDAcceptMode* = enum
  FDAcceptOpen = 0   # Режим «Открыть»
  FDAcceptSave = 1   # Режим «Сохранить»

type FDFileMode* = enum
  FDModeAnyFile       = 0  # Любое имя (для «Сохранить как»)
  FDModeExistingFile  = 1  # Только существующий файл
  FDModeDirectory     = 2  # Директория
  FDModeExistingFiles = 3  # Несколько существующих файлов

type FDOption* = enum
  FDShowDirsOnly          = 0x01
  FDDontResolveSymlinks   = 0x02
  FDDontConfirmOverwrite  = 0x04
  FDDontUseNativeDialog   = 0x08
  FDReadOnly              = 0x10
  FDHideNameFilterDetails = 0x20
  FDDontUseCustomDirIcons = 0x40

type FDViewMode* = enum
  FDViewDetail = 0  # Детальный список
  FDViewList   = 1  # Иконки

type FDDialogLabel* = enum
  FDLabelLookIn   = 0   # «Папка:»
  FDLabelFileName = 1   # «Имя файла:»
  FDLabelFileType = 2   # «Тип файла:»
  FDLabelAccept   = 3   # «Открыть» / «Сохранить»
  FDLabelReject   = 4   # «Отмена»
```

### Флаги QColorDialog

```nim
type ColorDlgOption* = enum
  CDShowAlphaChannel    = 0x01  # Показать альфа-канал
  CDNoButtons           = 0x02  # Скрыть кнопки OK/Cancel
  CDDontUseNativeDialog = 0x04  # Встроенный Qt-диалог
```

### Флаги QFontDialog

```nim
type FontDlgOption* = enum
  FtNoButtons          = 0x01  # Скрыть кнопки OK/Cancel
  FtDontUseNativeDialog= 0x02  # Встроенный Qt-диалог
  FtScalableFonts      = 0x04  # Только масштабируемые
  FtNonScalableFonts   = 0x08  # Только немасштабируемые
  FtMonospacedFonts    = 0x10  # Только моноширинные
  FtProportionalFonts  = 0x20  # Только пропорциональные
```

### Режимы QInputDialog

```nim
type InputDlgMode* = enum
  IDModeText   = 0  # Текстовая строка
  IDModeInt    = 1  # Целое число
  IDModeDouble = 2  # Вещественное число
```

### QWizard — стили и опции

```nim
type WizardStyle* = enum
  WizClassicStyle = 0  # Классический
  WizModernStyle  = 1  # Современный (Vista+)
  WizMacStyle     = 2  # macOS
  WizAeroStyle    = 3  # Aero

type WizardButton* = enum
  WizBtnBack=0, WizBtnNext=1, WizBtnCommit=2, WizBtnFinish=3,
  WizBtnCancel=4, WizBtnHelp=5, WizBtnCustom1=6,
  WizBtnCustom2=7, WizBtnCustom3=8
```

Опции мастера (префикс `WizOpt`):  
`WizOptIndependentPages`, `WizOptIgnoreSubTitles`, `WizOptNoDefaultButton`, `WizOptNoBackButtonOnStartPage`, `WizOptNoBackButtonOnLastPage`, `WizOptDisabledBackButtonOnLastPage`, `WizOptHaveNextButtonOnLastPage`, `WizOptHaveFinishButtonOnEarlyPages`, `WizOptNoCancelButton`, `WizOptCancelButtonOnLeft`, `WizOptHaveHelpButton`, `WizOptHelpButtonOnRight`, `WizOptHaveCustomButton1/2/3`, `WizOptNoCancelButtonOnLastPage` (Qt 6.2+).

### WindowModality — модальность

```nim
type WindowModality* = enum
  NonModal         = 0  # Немодальный
  WindowModal      = 1  # Модальный относительно родителя
  ApplicationModal = 2  # Модальный для всего приложения
```

---

## Nim-типы результатов

```nim
type
  InputStrResult*   = tuple[ok: bool, value: string]
  InputIntResult*   = tuple[ok: bool, value: int]
  InputFloatResult* = tuple[ok: bool, value: float64]
  InputItemResult*  = tuple[ok: bool, item: string]

  FontPickResult* = tuple[
    ok: bool,
    family: string,
    pointSize: int,
    bold, italic, underline, strikeOut: bool,
    weight: int
  ]

  ColorPickResult* = tuple[ok: bool, r, g, b, a: int]
  FilePickResult*  = tuple[ok: bool, path: string]
  FilesPickResult* = tuple[ok: bool, paths: seq[string]]
```

---

## QMessageBox — статические методы

Быстрые однострочные диалоги без создания объекта.

```nim
proc msgInfo*(parent: W, title, text: string)
```
Информационный диалог. Ждёт нажатия OK.

```nim
proc msgWarning*(parent: W, title, text: string)
```
Предупреждающий диалог.

```nim
proc msgCritical*(parent: W, title, text: string)
```
Диалог критической ошибки.

```nim
proc msgAbout*(parent: W, title, text: string)
```
Диалог «О программе» (поддерживает HTML/Rich Text).

```nim
proc msgAboutQt*(parent: W, title: string = "About Qt")
```
Стандартный диалог «О Qt».

```nim
proc msgQuestion*(parent: W, title, text: string,
                  buttons: cint = MBBtnYes.cint or MBBtnNo.cint): MsgBoxStdBtn
```
Диалог с вопросом. Возвращает нажатую кнопку.

```nim
proc msgYesNo*(parent: W, title, text: string): bool
```
Быстрый диалог Да/Нет. `true` = нажали Yes.

```nim
proc msgYesNoCancel*(parent: W, title, text: string): MsgBoxStdBtn
```
Диалог Да/Нет/Отмена.

```nim
proc msgOkCancel*(parent: W, title, text: string): bool
```
Быстрый диалог OK/Отмена. `true` = OK.

```nim
proc msgSaveDiscardCancel*(parent: W, title, text: string): MsgBoxStdBtn
```
Диалог Save/Discard/Cancel (при закрытии несохранённого документа).

```nim
proc msgRetryCancelAbort*(parent: W, title, text: string): MsgBoxStdBtn
```
Диалог Retry/Cancel/Abort (при ошибках операций).

**Пример:**
```nim
if msgYesNo(win.asW, "Удаление", "Удалить выбранные файлы?"):
  deleteSelectedFiles()

case msgSaveDiscardCancel(win.asW, "Выход", "Сохранить изменения?")
of MBBtnSave:    saveDocument()
of MBBtnDiscard: discard
of MBBtnCancel:  return  # Не выходить
else: discard
```

---

## QMessageBox — объектный API

Создание объекта для полной ручной настройки.

```nim
proc newMsgBox*(parent: W = nil): MsgBox
```

### Настройка содержимого

```nim
proc msgBoxSetWindowTitle*(mb: MsgBox, title: string)
proc msgBoxSetIcon*(mb: MsgBox, icon: MsgBoxIcon)
proc msgBoxSetText*(mb: MsgBox, text: string)
# Основной текст. Поддерживает HTML.

proc msgBoxSetInformativeText*(mb: MsgBox, text: string)
# Дополнительный текст (меньший шрифт).

proc msgBoxSetDetailedText*(mb: MsgBox, text: string)
# Детальный текст (скрыт за кнопкой «Подробнее»).

proc msgBoxSetTextFormat*(mb: MsgBox, fmt: cint)
# 0=PlainText, 1=RichText, 2=AutoText, 3=MarkdownText

proc msgBoxSetTextInteractionFlags*(mb: MsgBox, flags: cint)
# Копирование, переход по ссылкам и т.п.
```

### Управление кнопками

```nim
proc msgBoxSetStdButtons*(mb: MsgBox, buttons: cint)
# OR-комбинация MsgBoxStdBtn.

proc msgBoxSetDefaultButton*(mb: MsgBox, btn: MsgBoxStdBtn)
# Кнопка, срабатывающая по Enter.

proc msgBoxSetEscapeButton*(mb: MsgBox, btn: MsgBoxStdBtn)
# Кнопка, срабатывающая по Escape.

proc msgBoxAddButton*(mb: MsgBox, text: string, role: MsgBoxRole): AbsBtn
# Добавить произвольную кнопку.

proc msgBoxStdButton*(mb: MsgBox, btn: MsgBoxStdBtn): AbsBtn
# Получить стандартную кнопку для настройки.
```

### Флажок «Не показывать»

```nim
proc msgBoxAddCheckBox*(mb: MsgBox, text: string): ptr QCheckBox
# Добавить checkbox. Пример: «Больше не показывать».

proc msgBoxIsCheckBoxChecked*(mb: MsgBox): bool
# Прочитать состояние флажка после exec().
```

### Управление окном

```nim
proc msgBoxExec*(mb: MsgBox): MsgBoxStdBtn
# Показать модально. Возвращает нажатую кнопку.

proc msgBoxShow*(mb: MsgBox)      # Немодально
proc msgBoxHide*(mb: MsgBox)
proc msgBoxClose*(mb: MsgBox)
proc msgBoxSetModal*(mb: MsgBox, b: bool)
proc msgBoxSetStyleSheet*(mb: MsgBox, css: QString)
proc msgBoxResize*(mb: MsgBox, w, h: cint)
proc msgBoxAsW*(mb: MsgBox): W    # Upcast к QWidget*

proc msgBoxClickedButton*(mb: MsgBox): AbsBtn
# Получить нажатую кнопку (для нестандартных).
```

**Пример:**
```nim
let mb = newMsgBox(win.asW)
mb.msgBoxSetIcon(MBWarning)
mb.msgBoxSetWindowTitle("Предупреждение")
mb.msgBoxSetText("<b>Файл не найден</b>")
mb.msgBoxSetInformativeText("Проверьте путь и повторите.")
mb.msgBoxSetDetailedText("Путь: /home/user/missing.txt\nОшибка: ENOENT")
mb.msgBoxSetStdButtons(MBBtnOk.cint or MBBtnRetry.cint)
mb.msgBoxSetDefaultButton(MBBtnRetry)
let cb = mb.msgBoxAddCheckBox("Больше не показывать")
let btn = mb.msgBoxExec()
if mb.msgBoxIsCheckBoxChecked(): savePreference("suppress_warning", true)
```

---

## QMessageBox — сигналы

```nim
proc onMsgBoxFinished*(mb: MsgBox, cb: CBInt, ud: pointer)
# Диалог закрыт. Параметр: 1=Accepted, 0=Rejected.

proc onMsgBoxAccepted*(mb: MsgBox, cb: CB, ud: pointer)
# Пользователь нажал OK/Yes/Save.

proc onMsgBoxRejected*(mb: MsgBox, cb: CB, ud: pointer)
# Пользователь нажал Cancel/No.
```

---

## QInputDialog — статические методы

```nim
proc inputText*(parent: W, title, label: string,
                default: string = "",
                echo: cint = 0): InputStrResult
```
Диалог ввода строки. `echo`: 0=Normal, 2=Password, 3=PasswordEchoOnEdit.

```nim
proc inputPassword*(parent: W, title, label: string,
                    default: string = ""): InputStrResult
```
Специализация для ввода пароля (звёздочки).

```nim
proc inputMultiLine*(parent: W, title, label: string,
                     default: string = ""): InputStrResult
```
Диалог ввода многострочного текста.

```nim
proc inputInt*(parent: W, title, label: string,
               default: int = 0,
               min: int = low(cint).int,
               max: int = high(cint).int,
               step: int = 1): InputIntResult
```
Диалог ввода целого числа со спиннером.

```nim
proc inputFloat*(parent: W, title, label: string,
                 default: float64 = 0.0,
                 min: float64 = -1e9,
                 max: float64 = 1e9,
                 decimals: int = 3,
                 step: float64 = 1.0): InputFloatResult
```
Диалог ввода вещественного числа.

```nim
proc inputItem*(parent: W, title, label: string,
                items: openArray[string],
                currentIdx: int = 0,
                editable: bool = false): InputItemResult
```
Диалог выбора из выпадающего списка.

**Пример:**
```nim
let (ok, name) = inputText(win.asW, "Новый файл", "Введите имя:")
if ok: createFile(name)

let (ok2, n) = inputInt(win.asW, "Кол-во копий", "Копий:", 1, 1, 100)
if ok2: printCopies(n)

let (ok3, lang) = inputItem(win.asW, "Язык", "Выберите язык:",
                             ["Русский", "English", "Deutsch"])
if ok3: setLanguage(lang3.item)
```

---

## QInputDialog — объектный API

```nim
proc newInputDialog*(parent: W = nil): InDlg
```

### Настройка

```nim
proc idSetWindowTitle*(d: InDlg, s: string)
proc idSetLabelText*(d: InDlg, s: string)
proc idSetOkButtonText*(d: InDlg, s: string)
proc idSetCancelButtonText*(d: InDlg, s: string)
proc idSetInputMode*(d: InDlg, mode: InputDlgMode)
proc idSetStyleSheet*(d: InDlg, css: QString)
proc idResize*(d: InDlg, w, h: cint)
```

### Текстовый режим (`IDModeText`)

```nim
proc idSetTextValue*(d: InDlg, s: string)
proc idTextValue*(d: InDlg): string
proc idSetTextEchoMode*(d: InDlg, mode: cint)
# 0=Normal, 2=Password, 3=PasswordEchoOnEdit
```

### Целочисленный режим (`IDModeInt`)

```nim
proc idSetIntValue*(d: InDlg, v: int)
proc idIntValue*(d: InDlg): int
proc idSetIntRange*(d: InDlg, mn, mx: int)
proc idSetIntStep*(d: InDlg, step: int)
```

### Режим вещественного числа (`IDModeDouble`)

```nim
proc idSetDoubleValue*(d: InDlg, v: float64)
proc idDoubleValue*(d: InDlg): float64
proc idSetDoubleRange*(d: InDlg, mn, mx: float64)
proc idSetDoubleDecimals*(d: InDlg, dec: int)
proc idSetDoubleStep*(d: InDlg, step: float64)
```

### Режим выбора из списка

```nim
proc idSetComboBoxItems*(d: InDlg, items: openArray[string])
proc idSetComboBoxEditable*(d: InDlg, b: bool)
```

### Управление

```nim
proc idExec*(d: InDlg): DlgResult
proc idShow*(d: InDlg)
proc idAsW*(d: InDlg): W
```

---

## QInputDialog — сигналы

```nim
proc onIdTextChanged*(d: InDlg, cb: CBStr, ud: pointer)
# Текст изменился (параметр: новое значение).

proc onIdIntChanged*(d: InDlg, cb: CBInt, ud: pointer)
# Целое число изменилось.

proc onIdDoubleChanged*(d: InDlg, cb: proc(v: cdouble, ud: pointer) {.cdecl.}, ud: pointer)
# Вещественное число изменилось.

proc onIdAccepted*(d: InDlg, cb: CB, ud: pointer)
proc onIdRejected*(d: InDlg, cb: CB, ud: pointer)

proc onIdTextSelected*(d: InDlg, cb: CBStr, ud: pointer)
# Элемент выбран из списка и подтверждён.
```

---

## QFileDialog — статические методы

```nim
proc fileOpen*(parent: W,
               title: string = "Открыть файл",
               dir: string = "",
               filter: string = "Все файлы (*)"): FilePickResult
```
Диалог выбора одного существующего файла.

```nim
proc fileOpenMany*(parent: W,
                   title: string = "Открыть файлы",
                   dir: string = "",
                   filter: string = "Все файлы (*)"): FilesPickResult
```
Диалог выбора нескольких файлов.

```nim
proc fileSave*(parent: W,
               title: string = "Сохранить файл",
               dir: string = "",
               filter: string = "Все файлы (*)"): FilePickResult
```
Диалог сохранения файла.

```nim
proc dirSelect*(parent: W,
                title: string = "Выбрать директорию",
                dir: string = "",
                showDirsOnly: bool = true): FilePickResult
```
Диалог выбора директории.

```nim
proc fileOpenUrl*(parent: W, title, dir, filter: string): tuple[ok: bool, url: string]
proc fileSaveUrl*(parent: W, title, dir, filter: string): tuple[ok: bool, url: string]
```
Диалоги с поддержкой удалённых ресурсов (через `QUrl`).

**Строки фильтров** имеют формат:
```
"Изображения (*.png *.jpg);;PDF-файлы (*.pdf);;Все файлы (*)"
```

**Пример:**
```nim
let (ok, path) = fileOpen(win.asW, "Открыть документ", "/home",
                           "Документы (*.doc *.docx *.odt);;Все файлы (*)")
if ok: openDocument(path)

let (ok2, paths) = fileOpenMany(win.asW, "Выбрать файлы", "", "Все файлы (*)")
if ok2:
  for p in paths2: processFile(p)
```

---

## QFileDialog — объектный API

```nim
proc newFileDialog*(parent: W = nil): FileDlg
```

### Настройка

```nim
proc fdSetWindowTitle*(d: FileDlg, s: string)
proc fdSetDirectory*(d: FileDlg, path: string)
proc fdDirectory*(d: FileDlg): string       # Текущая директория
proc fdSetDefaultSuffix*(d: FileDlg, suffix: string)
# Расширение по умолчанию без точки (напр. "png").
```

### Фильтры

```nim
proc fdSetNameFilter*(d: FileDlg, filter: string)
# Один фильтр.

proc fdSetNameFilters*(d: FileDlg, filters: openArray[string])
# Несколько фильтров.

proc fdSetMimeTypeFilters*(d: FileDlg, mimes: openArray[string])
# Фильтры по MIME-типу: ["image/png", "application/pdf"]

proc fdSelectedNameFilter*(d: FileDlg): string
# Текущий выбранный фильтр.
```

### Режимы и опции

```nim
proc fdSetAcceptMode*(d: FileDlg, mode: FDAcceptMode)
proc fdSetFileMode*(d: FileDlg, mode: FDFileMode)
proc fdSetViewMode*(d: FileDlg, mode: FDViewMode)
proc fdSetOption*(d: FileDlg, opt: FDOption, on: bool = true)
proc fdSetOptions*(d: FileDlg, opts: cint)
```

### Выбранные файлы

```nim
proc fdSelectFile*(d: FileDlg, path: string)
# Предварительно выбрать файл.

proc fdSelectedFiles*(d: FileDlg): seq[string]
proc fdSelectedFile*(d: FileDlg): string
# Первый выбранный файл (или "").
```

### Навигация и вид

```nim
proc fdSetLabelText*(d: FileDlg, label: FDDialogLabel, text: string)
proc fdSetSidebarUrls*(d: FileDlg, urls: openArray[string])
proc fdSetHistory*(d: FileDlg, paths: openArray[string])
proc fdHistory*(d: FileDlg): seq[string]
```

### Управление

```nim
proc fdExec*(d: FileDlg): DlgResult
proc fdOpen*(d: FileDlg)   # Немодально
proc fdShow*(d: FileDlg)
proc fdHide*(d: FileDlg)
proc fdSetStyleSheet*(d: FileDlg, css: QString)
proc fdResize*(d: FileDlg, w, h: cint)
proc fdAsW*(d: FileDlg): W
```

---

## QFileDialog — сигналы

```nim
proc onFdCurrentChanged*(d: FileDlg, cb: CBStr, ud: pointer)
# Текущий путь изменился при навигации.

proc onFdCurrentUrlChanged*(d: FileDlg, cb: CBStr, ud: pointer)
# Текущий URL изменился.

proc onFdFileSelected*(d: FileDlg, cb: CBStr, ud: pointer)
# Файл выбран (одиночный).

proc onFdDirectoryEntered*(d: FileDlg, cb: CBStr, ud: pointer)
# Пользователь вошёл в директорию.

proc onFdFilterSelected*(d: FileDlg, cb: CBStr, ud: pointer)
# Пользователь сменил фильтр.

proc onFdAccepted*(d: FileDlg, cb: CB, ud: pointer)
proc onFdRejected*(d: FileDlg, cb: CB, ud: pointer)
```

---

## QFontDialog

### Статический метод

```nim
proc fontGet*(parent: W,
              title: string = "Выбрать шрифт",
              initFamily: string = "Arial",
              initSize: int = 12,
              initBold: bool = false,
              initItalic: bool = false): FontPickResult
```
Диалог выбора шрифта. Возвращает `FontPickResult` с полным описанием.

**Пример:**
```nim
let res = fontGet(win.asW, "Шрифт текста", "Verdana", 14, true, false)
if res.ok:
  echo res.family    # "Verdana"
  echo res.pointSize # 14
  echo res.bold      # true
```

### Объектный API

```nim
proc newFontDialog*(parent: W = nil): FontDlg
```

```nim
proc ftdSetCurrentFont*(d: FontDlg, family: string, size: int,
                        bold: bool = false, italic: bool = false,
                        underline: bool = false, strikeOut: bool = false)
# Задать начальный шрифт.
```

Получение текущего шрифта:
```nim
proc ftdCurrentFamily*(d: FontDlg): string
proc ftdCurrentPointSize*(d: FontDlg): int
proc ftdCurrentBold*(d: FontDlg): bool
proc ftdCurrentItalic*(d: FontDlg): bool
proc ftdCurrentUnderline*(d: FontDlg): bool
proc ftdCurrentStrikeOut*(d: FontDlg): bool
proc ftdCurrentWeight*(d: FontDlg): int

proc ftdCurrentFontStr*(d: FontDlg): string
# Возвращает строку "family,size,bold,italic" для сохранения.
```

Опции и управление:
```nim
proc ftdSetOption*(d: FontDlg, opt: FontDlgOption, on: bool = true)
proc ftdSetWindowTitle*(d: FontDlg, s: string)
proc ftdExec*(d: FontDlg): DlgResult
proc ftdShow*(d: FontDlg)
proc ftdSetStyleSheet*(d: FontDlg, css: QString)
proc ftdAsW*(d: FontDlg): W
```

---

## QFontDialog — сигналы

```nim
proc onFtdCurrentFontChanged*(d: FontDlg, cb: CBStr, ud: pointer)
# Текущий шрифт изменился. Параметр: семейство шрифта.

proc onFtdFontSelected*(d: FontDlg, cb: CBStr, ud: pointer)
# Шрифт выбран и подтверждён.

proc onFtdAccepted*(d: FontDlg, cb: CB, ud: pointer)
proc onFtdRejected*(d: FontDlg, cb: CB, ud: pointer)
```

---

## QColorDialog

### Статические методы

```nim
proc colorGet*(parent: W,
               title: string = "Выбрать цвет",
               initR, initG, initB: int = 255,
               initA: int = 255,
               showAlpha: bool = false): ColorPickResult
```
Диалог выбора цвета в формате RGBA (0–255 каждый канал).

```nim
proc colorGetHex*(parent: W,
                  title: string = "Выбрать цвет",
                  initHex: string = "#ffffff"): tuple[ok: bool, hex: string]
```
Возвращает hex-строку `"#rrggbb"`.

```nim
proc colorGetHexAlpha*(parent: W,
                       title: string = "...",
                       initHex: string = "#ffffffff"): tuple[ok: bool, hex: string]
```
Возвращает hex-строку `"#aarrggbb"` с альфа-каналом.

**Пример:**
```nim
let (ok, hex) = colorGetHex(win.asW, "Цвет фона", "#336699")
if ok: setBackground(hex)
```

### Объектный API

```nim
proc newColorDialog*(parent: W = nil): ColDlg
```

Установка начального цвета:
```nim
proc cdSetCurrentColor*(d: ColDlg, r, g, b: int, a: int = 255)
proc cdSetCurrentColorHex*(d: ColDlg, hex: string)
# hex: "#rrggbb" или "#aarrggbb"
```

Получение текущего цвета:
```nim
proc cdCurrentRGBA*(d: ColDlg): tuple[r, g, b, a: int]
proc cdCurrentR*(d: ColDlg): int
proc cdCurrentG*(d: ColDlg): int
proc cdCurrentB*(d: ColDlg): int
proc cdCurrentA*(d: ColDlg): int
proc cdCurrentHex*(d: ColDlg): string       # "#rrggbb"
proc cdCurrentHexAlpha*(d: ColDlg): string  # "#aarrggbb"
```

Палитра кастомных цветов (16 слотов):
```nim
proc cdSetCustomColor*(index: int, r, g, b: int)
# Статический метод. index: 0..15.

proc cdCustomColor*(index: int): tuple[r, g, b: int]
proc cdCustomColorCount*(): int
# Обычно 16.
```

Опции и управление:
```nim
proc cdSetOption*(d: ColDlg, opt: ColorDlgOption, on: bool = true)
proc cdSetWindowTitle*(d: ColDlg, s: string)
proc cdExec*(d: ColDlg): DlgResult
proc cdOpen*(d: ColDlg)   # Немодально
proc cdShow*(d: ColDlg)
proc cdSetStyleSheet*(d: ColDlg, css: QString)
proc cdAsW*(d: ColDlg): W
```

---

## QColorDialog — сигналы

```nim
proc onCdColorSelected*(d: ColDlg, cb: CBStr, ud: pointer)
# Цвет выбран и подтверждён. Параметр: "#rrggbb".

proc onCdCurrentColorChanged*(d: ColDlg, cb: CBStr, ud: pointer)
# Текущий цвет изменился (до подтверждения).

proc onCdAccepted*(d: ColDlg, cb: CB, ud: pointer)
proc onCdRejected*(d: ColDlg, cb: CB, ud: pointer)
```

---

## QProgressDialog

### Создание

```nim
proc newProgressDialog*(parent: W = nil,
                        label: string = "Выполняется...",
                        cancelBtn: string = "Отмена",
                        minVal: int = 0,
                        maxVal: int = 100): ProgDlg
# cancelBtn = "" — скрыть кнопку отмены.
```

```nim
proc newProgressDialogNoCancel*(parent: W = nil,
                                label: string = "Выполняется...",
                                minVal: int = 0,
                                maxVal: int = 100): ProgDlg
# Без кнопки «Отмена» (неотменяемая операция).
```

### Управление прогрессом

```nim
proc pdSetValue*(d: ProgDlg, v: int)     # Установить значение (0..max).
proc pdValue*(d: ProgDlg): int           # Текущее значение.
proc pdSetRange*(d: ProgDlg, mn, mx: int)
proc pdMinimum*(d: ProgDlg): int
proc pdMaximum*(d: ProgDlg): int

proc pdStep*(d: ProgDlg, increment: int = 1)
# Увеличить на increment и вызвать processEvents().
# Используйте в цикле для отзывчивости UI.
```

### Настройка отображения

```nim
proc pdSetLabelText*(d: ProgDlg, s: string)
# Обновить текст метки (можно вызывать в цикле).

proc pdSetWindowTitle*(d: ProgDlg, s: string)
proc pdSetCancelButtonText*(d: ProgDlg, s: string)

proc pdSetMinimumDuration*(d: ProgDlg, ms: int)
# Задержка перед показом (по умолчанию 4000 мс). 0 = сразу.
```

### Поведение

```nim
proc pdSetAutoClose*(d: ProgDlg, b: bool)   # Закрывать при 100%.
proc pdSetAutoReset*(d: ProgDlg, b: bool)   # Сбрасывать при 100%.
proc pdSetModal*(d: ProgDlg, b: bool)
proc pdWasCanceled*(d: ProgDlg): bool       # true если нажали «Отмена».
```

### Управление окном

```nim
proc pdReset*(d: ProgDlg)
proc pdShow*(d: ProgDlg)
proc pdHide*(d: ProgDlg)
proc pdClose*(d: ProgDlg)
proc pdSetStyleSheet*(d: ProgDlg, css: QString)
proc pdResize*(d: ProgDlg, w, h: cint)
proc pdAsW*(d: ProgDlg): W
```

### Сигнал

```nim
proc onPdCanceled*(d: ProgDlg, cb: CB, ud: pointer)
# Пользователь нажал «Отмена».
```

**Пример:**
```nim
let pd = newProgressDialog(win.asW, "Копирование файлов", "Остановить", 0, files.len)
pd.pdSetWindowTitle("Копирование")
pd.pdSetMinimumDuration(0)
pd.pdShow()

for i, f in files:
  if pd.pdWasCanceled(): break
  copyFile(f)
  pd.pdSetLabelText("Копирую: " & f.extractFilename)
  pd.pdSetValue(i + 1)
  processEvents()
```

---

## QErrorMessage

Диалог сообщений об ошибках с возможностью подавления повторных показов.

```nim
proc newErrorMessage*(parent: W = nil): ErrMsg

proc emShowMessage*(d: ErrMsg, msg: string)
# Показать сообщение. Повторные вызовы с тем же текстом
# подавляются после нажатия «Не показывать снова».

proc emShowMessageType*(d: ErrMsg, msg: string, msgType: string)
# Разные типы подавляются независимо.

proc emSetWindowTitle*(d: ErrMsg, s: string)
proc emExec*(d: ErrMsg): int
proc emShow*(d: ErrMsg)
proc emAsW*(d: ErrMsg): W

proc appErrorMessage*(): ErrMsg
# Синглтон QErrorMessage::qtHandler() — перехватывает qWarning().
```

**Пример:**
```nim
let em = newErrorMessage(win.asW)
em.emShowMessage("Не удалось подключиться к базе данных.")
# При повторном вызове с тем же текстом диалог не появится,
# если пользователь установил «Не показывать снова».
```

---

## QDialogButtonBox

Стандартная горизонтальная (или вертикальная) панель кнопок.

### Создание

```nim
proc newDlgButtonBox*(buttons: cint, parent: W = nil): DlgBBx
# OR-комбинация DlgBBxStdBtn, напр. DBBOk.cint or DBBCancel.cint

proc newDlgButtonBoxH*(buttons: cint, parent: W = nil): DlgBBx
# Явно горизонтальная.

proc newDlgButtonBoxV*(buttons: cint, parent: W = nil): DlgBBx
# Вертикальная.
```

### Работа с кнопками

```nim
proc dbbButton*(box: DlgBBx, btn: DlgBBxStdBtn): AbsBtn
# Получить стандартную кнопку для настройки текста, иконки и т.п.

proc dbbAddButton*(box: DlgBBx, text: string, role: DlgBBxRole): AbsBtn
# Добавить произвольную кнопку с ролью.

proc dbbRemoveButton*(box: DlgBBx, btn: AbsBtn)
proc dbbSetEnabled*(box: DlgBBx, btn: DlgBBxStdBtn, on: bool)
proc dbbSetButtonText*(box: DlgBBx, btn: DlgBBxStdBtn, text: string)
proc dbbSetStdButtons*(box: DlgBBx, buttons: cint)
```

### Вид

```nim
proc dbbSetOrientation*(box: DlgBBx, horiz: bool)
proc dbbSetCenterButtons*(box: DlgBBx, b: bool)
proc dbbSetStyleSheet*(box: DlgBBx, css: QString)
proc dbbAsW*(box: DlgBBx): W
```

---

## QDialogButtonBox — сигналы

```nim
proc onDbbAccepted*(box: DlgBBx, cb: CB, ud: pointer)
# Нажата кнопка с ролью AcceptRole (OK/Yes/Save).

proc onDbbRejected*(box: DlgBBx, cb: CB, ud: pointer)
# Нажата кнопка с ролью RejectRole (Cancel/No).

proc onDbbClicked*(box: DlgBBx, cb: CBStr, ud: pointer)
# Нажата любая кнопка. Параметр: текст кнопки.

proc onDbbHelpRequested*(box: DlgBBx, cb: CB, ud: pointer)
# Нажата кнопка справки.
```

---

## QDialog — базовый кастомный диалог

### Создание

```nim
proc newCustomDialog*(parent: W = nil, flags: cint = 0): CDlg
# flags — Qt::WindowFlags (0 = стандартные флаги).
```

### Управление

```nim
proc cdlgExec*(d: CDlg): DlgResult     # Модальный показ.
proc cdlgOpen*(d: CDlg)                # Полумодальный (блокирует только родителя).
proc cdlgShow*(d: CDlg)                # Немодальный.
proc cdlgHide*(d: CDlg)
proc cdlgClose*(d: CDlg)
proc cdlgAccept*(d: CDlg)              # Программный accept.
proc cdlgReject*(d: CDlg)              # Программный reject.
proc cdlgDone*(d: CDlg, r: cint)       # Завершить с кодом.
proc cdlgResult*(d: CDlg): int         # Результат последнего exec().
```

### Модальность

```nim
proc cdlgSetModal*(d: CDlg, b: bool)
proc cdlgSetWindowModality*(d: CDlg, m: WindowModality)
```

### Заголовок и размер

```nim
proc cdlgSetWindowTitle*(d: CDlg, s: string)
proc cdlgWindowTitle*(d: CDlg): string
proc cdlgResize*(d: CDlg, w, h: cint)
proc cdlgSetMinSize*(d: CDlg, w, h: cint)
proc cdlgSetMaxSize*(d: CDlg, w, h: cint)
proc cdlgSetFixedSize*(d: CDlg, w, h: cint)
proc cdlgAdjustSize*(d: CDlg)
proc cdlgSetSizeGripEnabled*(d: CDlg, b: bool)
```

### Раскладка и стиль

```nim
proc cdlgSetLayout*(d: CDlg, l: VBox)
proc cdlgSetLayout*(d: CDlg, l: HBox)
proc cdlgSetLayout*(d: CDlg, l: Grid)
proc cdlgSetLayout*(d: CDlg, l: Form)

proc cdlgSetStyleSheet*(d: CDlg, css: QString)
proc cdlgAsW*(d: CDlg): W
```

### Флаги окна

```nim
proc cdlgSetWindowFlags*(d: CDlg, flags: cint)
proc cdlgSetWindowFlag*(d: CDlg, flag: cint, on: bool = true)
```

---

## QDialog — builder-хелперы

Быстрое создание типовых диалогов без шаблонного кода.

```nim
proc buildSimpleDialog*(parent: W, title: string, body: W,
                        buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg
```
Создаёт диалог: заголовок + виджет + `QDialogButtonBox`. Accept/Reject подключены автоматически.

```nim
proc buildLabeledDialog*(parent: W, title, labelText: string, body: W,
                         buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg
```
Как `buildSimpleDialog`, но с `QLabel` над виджетом.

```nim
proc buildGridDialog*(parent: W, title: string,
                      rows: openArray[tuple[label: string, widget: W]],
                      buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg
```
Диалог с `QFormLayout` (пары label–виджет).

**Примеры:**
```nim
# Простой диалог с редактором
let editor = newPlainTextEdit(nil)
let dlg = buildSimpleDialog(win.asW, "Редактор", editor.asW)
if dlg.cdlgExec() == DlgAccepted:
  echo editor.toPlainText()

# Диалог с подписью
let le = newLineEdit(nil)
let dlg2 = buildLabeledDialog(nil, "Ввод", "Введите имя пользователя:", le.asW)
if dlg2.cdlgExec() == DlgAccepted:
  setUsername(le.text())

# Форма
let nameEdit = newLineEdit(nil)
let ageBox   = newSpinBox(nil)
let dlg3 = buildGridDialog(nil, "Новый пользователь", [
  ("Имя:",     nameEdit.asW),
  ("Возраст:", ageBox.asW)
])
if dlg3.cdlgExec() == DlgAccepted:
  addUser(nameEdit.text(), ageBox.value())
```

---

## QDialog — сигналы

```nim
proc onCdlgAccepted*(d: CDlg, cb: CB, ud: pointer)
proc onCdlgRejected*(d: CDlg, cb: CB, ud: pointer)
proc onCdlgFinished*(d: CDlg, cb: CBInt, ud: pointer)
# Параметр: 1=Accepted, 0=Rejected.
```

---

## QWizard — мастер

Многостраничный диалог-мастер (wizard).

### Создание

```nim
proc newWizard*(parent: W = nil): Wiz
```

### Управление страницами

```nim
proc wizAddPage*(w: Wiz, page: WizPage): int
# Добавить страницу. Возвращает автоматически назначенный ID.

proc wizSetPage*(w: Wiz, id: int, page: WizPage)
# Добавить страницу с фиксированным ID.

proc wizRemovePage*(w: Wiz, id: int)
```

### Навигация

```nim
proc wizCurrentId*(w: Wiz): int
proc wizCurrentPage*(w: Wiz): WizPage
proc wizNextId*(w: Wiz): int
proc wizSetStartId*(w: Wiz, id: int)
proc wizStartId*(w: Wiz): int
proc wizRestart*(w: Wiz)    # Начать сначала.
proc wizBack*(w: Wiz)
proc wizNext*(w: Wiz)
```

### История посещений

```nim
proc wizHasVisitedPage*(w: Wiz, id: int): bool
proc wizVisitedIds*(w: Wiz): seq[int]
```

### Настройка вида

```nim
proc wizSetWindowTitle*(w: Wiz, s: string)
proc wizSetWizardStyle*(w: Wiz, style: WizardStyle)
proc wizSetOption*(w: Wiz, opt: WizardOption, on: bool = true)
proc wizTestOption*(w: Wiz, opt: WizardOption): bool
proc wizSetTitleFormat*(w: Wiz, fmt: cint)     # 0=Plain, 1=Rich
proc wizSetSubTitleFormat*(w: Wiz, fmt: cint)
```

### Кнопки

```nim
proc wizSetButtonText*(w: Wiz, which: WizardButton, text: string)
proc wizButtonText*(w: Wiz, which: WizardButton): string
proc wizSetButton*(w: Wiz, which: WizardButton, btn: AbsBtn)
# Заменить стандартную кнопку кастомной.
```

### Поля (fields)

Поля регистрируются на страницах (через `wpRegisterField`) и читаются на уровне мастера:

```nim
proc wizSetField*(w: Wiz, name: string, value: string)
proc wizFieldStr*(w: Wiz, name: string): string
proc wizFieldInt*(w: Wiz, name: string): int
proc wizFieldBool*(w: Wiz, name: string): bool
```

### Управление

```nim
proc wizExec*(w: Wiz): DlgResult
proc wizShow*(w: Wiz)
proc wizResize*(w: Wiz, ww, h: cint)
proc wizSetStyleSheet*(w: Wiz, css: QString)
proc wizAsW*(w: Wiz): W
```

**Пример:**
```nim
let wiz = newWizard()
wiz.wizSetWindowTitle("Настройка проекта")
wiz.wizSetWizardStyle(WizModernStyle)
wiz.wizSetOption(WizOptNoBackButtonOnStartPage)

let page1 = newWizardPage()
page1.wpSetTitle("Шаг 1: Имя проекта")
let nameEdit = newLineEdit(nil)
page1.wpRegisterField("projectName*", nameEdit.asW)
let vbox = newVBox(nil)
vbox.addW(nameEdit.asW)
page1.wpSetLayout(vbox)

discard wiz.wizAddPage(page1)

if wiz.wizExec() == DlgAccepted:
  echo wiz.wizFieldStr("projectName")
```

---

## QWizard — сигналы

```nim
proc onWizCurrentIdChanged*(w: Wiz, cb: CBInt, ud: pointer)
# Перешли на другую страницу. Параметр: новый ID.

proc onWizPageAdded*(w: Wiz, cb: CBInt, ud: pointer)
proc onWizPageRemoved*(w: Wiz, cb: CBInt, ud: pointer)

proc onWizAccepted*(w: Wiz, cb: CB, ud: pointer)
# Пользователь завершил мастер (Finish).

proc onWizRejected*(w: Wiz, cb: CB, ud: pointer)
# Пользователь отменил.

proc onWizFinished*(w: Wiz, cb: CBInt, ud: pointer)
# Мастер закрыт. Параметр: 1=Accepted, 0=Rejected.

proc onWizHelpRequested*(w: Wiz, cb: CB, ud: pointer)
proc onWizCustomButtonClicked*(w: Wiz, cb: CBInt, ud: pointer)
# Параметр: 1, 2 или 3 (Custom1/2/3).
```

---

## QWizardPage — страница мастера

```nim
proc newWizardPage*(parent: W = nil): WizPage
```

### Заголовок и подзаголовок

```nim
proc wpSetTitle*(p: WizPage, s: string)
proc wpTitle*(p: WizPage): string
proc wpSetSubTitle*(p: WizPage, s: string)
proc wpSubTitle*(p: WizPage): string
```

### Раскладка

```nim
proc wpSetLayout*(p: WizPage, l: VBox)
proc wpSetLayout*(p: WizPage, l: HBox)
proc wpSetLayout*(p: WizPage, l: Grid)
proc wpSetLayout*(p: WizPage, l: Form)
```

### Поведение страницы

```nim
proc wpSetFinalPage*(p: WizPage, b: bool)
# Финальная страница — показывает кнопку Finish.

proc wpIsFinalPage*(p: WizPage): bool

proc wpSetCommitPage*(p: WizPage, b: bool)
# «Без возврата» — Back недоступна после перехода.

proc wpIsCommitPage*(p: WizPage): bool

proc wpIsComplete*(p: WizPage): bool
# true если страница завершена (Next/Finish доступна).

proc wpNextId*(p: WizPage): int
# ID следующей страницы (-1 = автовыбор).
```

### Поля страницы

```nim
proc wpRegisterField*(p: WizPage, name: string, widget: W,
                      prop: cstring = nil, changedSig: cstring = nil)
```
Регистрирует именованное поле. Имя с суффиксом `*` (звёздочка) делает поле обязательным — страница не считается завершённой, пока поле пустое. Значения читаются через `wizFieldStr/Int/Bool`.

### Прочее

```nim
proc wpSetStyleSheet*(p: WizPage, css: QString)
proc wpAsW*(p: WizPage): W
```

---

## Высокоуровневые Nim-утилиты

### Диалоги подтверждения

```nim
proc confirmDelete*(parent: W, itemName: string): bool
# «Вы уверены, что хотите удалить «itemName»?»

proc confirmDiscard*(parent: W): bool
# «Имеются несохранённые изменения. Отменить их?»

proc confirmOverwrite*(parent: W, path: string): bool
# «Файл «path» уже существует. Перезаписать?»

proc confirmAction*(parent: W, title, question: string): bool
# Общий диалог подтверждения.

proc confirmSaveChanges*(parent: W): MsgBoxStdBtn
# «Сохранить/Отменить/Отмена» при закрытии документа.
# Возвращает MBBtnSave, MBBtnDiscard или MBBtnCancel.
```

### Диалоги ввода

```nim
proc showValidationError*(parent: W, field, reason: string)
# Показывает предупреждение: «Поле «field»: reason».

proc askTextRequired*(parent: W, title, prompt: string,
                      maxLen: int = 0): string
# Запросить непустую строку. Повторяет до получения.
# Возвращает "" если нажали «Отмена».

proc askInt*(parent: W, title, prompt: string,
             default: int = 0, min, max: int): tuple[ok: bool, value: int]

proc askFloat*(parent: W, title, prompt: string,
               default: float64 = 0.0, min, max: float64): tuple[ok: bool, value: float64]

proc askChoice*(parent: W, title, prompt: string,
                choices: openArray[string],
                currentIdx: int = 0): string
# Возвращает выбранный элемент или "" при отмене.
```

### Диалоги файловой системы

```nim
proc pickOpenFile*(parent: W, title, filter, dir: string): string
# Путь к файлу или "".

proc pickSaveFile*(parent: W, title, filter, dir: string): string
proc pickDirectory*(parent: W, title, dir: string): string
proc pickOpenFiles*(parent: W, title, filter, dir: string): seq[string]

proc pickImageFile*(parent: W, title: string = "Выбрать изображение"): string
# Фильтр: PNG, JPG, BMP, GIF, WEBP, TIFF, ICO.

proc pickVideoFile*(parent: W, title: string = "Выбрать видео"): string
# Фильтр: MP4, MKV, AVI, MOV, WMV, FLV, WEBM.

proc pickAudioFile*(parent: W, title: string = "Выбрать аудио"): string
# Фильтр: MP3, WAV, OGG, FLAC, AAC, M4A.
```

### Диалоги цвета и шрифта

```nim
proc pickColorHex*(parent: W, title, init: string): string
# Возвращает "#rrggbb" или "".

proc pickColorHexAlpha*(parent: W, title, init: string): string
# Возвращает "#aarrggbb" или "".

proc pickColorRgba*(parent: W, title: string,
                    showAlpha: bool = false): tuple[ok: bool, r, g, b, a: int]

proc pickFontStr*(parent: W, title, initFamily: string,
                  initSize: int): string
# Возвращает "family,size" или "".

proc pickFontFull*(parent: W, title, initFamily: string,
                   initSize: int): FontPickResult
# Полное описание шрифта.
```

### Утилиты прогресса

```nim
proc withProgress*(parent: W, title, label: string,
                   total: int, minDuration: int = 500,
                   body: proc(pd: ProgDlg) {.closure.})
```
Запустить неотменяемую операцию с прогресс-диалогом. Диалог закрывается автоматически.

```nim
proc withProgressCancellable*(parent: W, title, label: string,
                               total: int, minDuration: int = 500,
                               body: proc(pd: ProgDlg): bool {.closure.}): bool
```
Запустить отменяемую операцию. `body` должна возвращать `false` при отмене. Возвращает `true` если завершена.

**Примеры:**
```nim
# Подтверждение
if confirmDelete(win.asW, "report_2024.pdf"):
  deleteFile("report_2024.pdf")

# Ввод
let name = askTextRequired(win.asW, "Имя проекта", "Введите имя:", 64)
if name != "": createProject(name)

# Файлы
let img = pickImageFile(win.asW)
if img != "": loadImage(img)

# Прогресс
withProgress(win.asW, "Экспорт", "Экспортирую данные...", records.len):
  proc(pd: ProgDlg) =
    for i, rec in records:
      exportRecord(rec)
      pd.pdSetValue(i + 1)

# Отменяемый прогресс
let ok = withProgressCancellable(win.asW, "Загрузка", "Загружаю...", 100):
  proc(pd: ProgDlg): bool =
    for i in 1..100:
      if pd.pdWasCanceled(): return false
      downloadChunk(i)
      pd.pdSetValue(i)
    true
if ok: echo "Загрузка завершена"
else:  echo "Загрузка отменена"
```

---

## Совместимость и особенности

- Все строки конвертируются через `QString::fromUtf8()`. Поддерживается полный Unicode.
- Статические `QByteArray` для возврата строк **не потокобезопасны** при одновременных вызовах.
- Указатели на диалоги не управляются GC Nim. Используйте `objDelete` / `objDeleteLater` для освобождения.
- Коллбэки (`CB`, `CBStr`, `CBInt`) требуют соглашения `{.cdecl.}`.
- `exec()` запускает вложенный цикл событий — диалог блокирует поток до закрытия.
- `open()` показывает полумодальный диалог — блокирует только родительское окно.
- `show()` — немодальный показ, возвращает управление немедленно.
- Сборка: `nim cpp --passC:"-std=c++20" your_file.nim`
