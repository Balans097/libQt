# nimQtDialogs — Complete Library Reference

> **Version:** Qt6Widgets · **Compiler:** `nim cpp --passC:"-std=c++20"`  
> **Dependencies:** `nimQtUtils`, `nimQtFFI`, `nimQtWidgets`  
> **Compatibility:** Qt 6.2+ (full), Qt 6.7+ (extended enums), Qt 6.11 (setCheckBox API)

---

## Table of Contents

1. [Compiler Configuration](#compiler-configuration)
2. [Types and Aliases](#types-and-aliases)
3. [Enumerations](#enumerations)
4. [Nim Result Types](#nim-result-types)
5. [QMessageBox — Static Methods](#qmessagebox--static-methods)
6. [QMessageBox — Object API](#qmessagebox--object-api)
7. [QMessageBox — Signals](#qmessagebox--signals)
8. [QInputDialog — Static Methods](#qinputdialog--static-methods)
9. [QInputDialog — Object API](#qinputdialog--object-api)
10. [QInputDialog — Signals](#qinputdialog--signals)
11. [QFileDialog — Static Methods](#qfiledialog--static-methods)
12. [QFileDialog — Object API](#qfiledialog--object-api)
13. [QFileDialog — Signals](#qfiledialog--signals)
14. [QFontDialog](#qfontdialog)
15. [QFontDialog — Signals](#qfontdialog--signals)
16. [QColorDialog](#qcolordialog)
17. [QColorDialog — Signals](#qcolordialog--signals)
18. [QProgressDialog](#qprogressdialog)
19. [QErrorMessage](#qerrormessage)
20. [QDialogButtonBox](#qdialogbuttonbox)
21. [QDialogButtonBox — Signals](#qdialogbuttonbox--signals)
22. [QDialog — Custom Base Dialog](#qdialog--custom-base-dialog)
23. [QDialog — Builder Helpers](#qdialog--builder-helpers)
24. [QDialog — Signals](#qdialog--signals)
25. [QWizard — Wizard Dialog](#qwizard--wizard-dialog)
26. [QWizard — Signals](#qwizard--signals)
27. [QWizardPage — Wizard Page](#qwizardpage--wizard-page)
28. [High-Level Nim Utilities](#high-level-nim-utilities)

---

## Compiler Configuration

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

## Types and Aliases

### Opaque Qt Types

| Nim Type | Qt Class | Description |
|---|---|---|
| `QMessageBox` | `QMessageBox` | Information, warning, and error dialogs |
| `QInputDialog` | `QInputDialog` | Data input dialog |
| `QFileDialog` | `QFileDialog` | File system dialog |
| `QFontDialog` | `QFontDialog` | Font selection dialog |
| `QColorDialog` | `QColorDialog` | Color selection dialog |
| `QProgressDialog` | `QProgressDialog` | Progress dialog |
| `QErrorMessage` | `QErrorMessage` | Suppressible error messages |
| `QDialogButtonBox` | `QDialogButtonBox` | Standard button panel |

### Pointer Aliases

```nim
type
  MsgBox*  = ptr QMessageBox
  InDlg*   = ptr QInputDialog
  FileDlg* = ptr QFileDialog
  FontDlg* = ptr QFontDialog
  ColDlg*  = ptr QColorDialog
  ProgDlg* = ptr QProgressDialog
  ErrMsg*  = ptr QErrorMessage
  Wiz*     = ptr QWizard          # from nimQtWidgets
  CDlg*    = ptr QDialog          # from nimQtWidgets
  DlgBBx*  = ptr QDialogButtonBox
  AbsBtn*  = ptr QAbstractButton  # from nimQtWidgets
```

---

## Enumerations

### MsgBoxIcon — QMessageBox Icons

```nim
type MsgBoxIcon* = enum
  MBNoIcon      = 0  # No icon
  MBInformation = 1  # Information (i)
  MBWarning     = 2  # Warning (!)
  MBCritical    = 3  # Critical error (X)
  MBQuestion    = 4  # Question (?)
```

### MsgBoxStdBtn — QMessageBox Standard Buttons

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

### MsgBoxRole — QMessageBox Button Roles

```nim
type MsgBoxRole* = enum
  MBRoleInvalid=-1, MBRoleAccept=0, MBRoleReject=1,
  MBRoleDestructive=2, MBRoleAction=3, MBRoleHelp=4,
  MBRoleYes=5, MBRoleNo=6, MBRoleReset=7, MBRoleApply=8
```

### DlgBBxStdBtn — QDialogButtonBox Standard Buttons

Mirrors `MsgBoxStdBtn` with the `DBB` prefix:

```nim
DBBNoButton, DBBOk, DBBSave, DBBSaveAll, DBBOpen,
DBBYes, DBBYesToAll, DBBNo, DBBNoToAll, DBBAbort,
DBBRetry, DBBIgnore, DBBClose, DBBCancel, DBBDiscard,
DBBHelp, DBBApply, DBBReset, DBBRestoreDefaults
```

### DlgBBxRole — QDialogButtonBox Button Roles

```nim
DBBRoleInvalid=-1, DBBRoleAccept=0, DBBRoleReject=1,
DBBRoleDestructive=2, DBBRoleAction=3, DBBRoleHelp=4,
DBBRoleYes=5, DBBRoleNo=6, DBBRoleReset=7, DBBRoleApply=8
```

### DlgResult — Dialog Result

```nim
type DlgResult* = enum
  DlgRejected = 0  # Cancel / No / closed with X
  DlgAccepted = 1  # OK / Yes / Finish
```

### QFileDialog Modes and Flags

```nim
type FDAcceptMode* = enum
  FDAcceptOpen = 0   # Open mode
  FDAcceptSave = 1   # Save mode

type FDFileMode* = enum
  FDModeAnyFile       = 0  # Any filename (for Save As)
  FDModeExistingFile  = 1  # Existing file only
  FDModeDirectory     = 2  # Directory
  FDModeExistingFiles = 3  # Multiple existing files

type FDOption* = enum
  FDShowDirsOnly          = 0x01
  FDDontResolveSymlinks   = 0x02
  FDDontConfirmOverwrite  = 0x04
  FDDontUseNativeDialog   = 0x08
  FDReadOnly              = 0x10
  FDHideNameFilterDetails = 0x20
  FDDontUseCustomDirIcons = 0x40

type FDViewMode* = enum
  FDViewDetail = 0  # Detail list
  FDViewList   = 1  # Icon view

type FDDialogLabel* = enum
  FDLabelLookIn=0, FDLabelFileName=1, FDLabelFileType=2,
  FDLabelAccept=3, FDLabelReject=4
```

### QColorDialog Flags

```nim
type ColorDlgOption* = enum
  CDShowAlphaChannel    = 0x01  # Show alpha slider
  CDNoButtons           = 0x02  # Hide OK/Cancel buttons
  CDDontUseNativeDialog = 0x04  # Use Qt built-in dialog
```

### QFontDialog Flags

```nim
type FontDlgOption* = enum
  FtNoButtons          = 0x01  # Hide OK/Cancel buttons
  FtDontUseNativeDialog= 0x02  # Use Qt built-in dialog
  FtScalableFonts      = 0x04  # Scalable fonts only
  FtNonScalableFonts   = 0x08  # Non-scalable fonts only
  FtMonospacedFonts    = 0x10  # Monospaced fonts only
  FtProportionalFonts  = 0x20  # Proportional fonts only
```

### QInputDialog Modes

```nim
type InputDlgMode* = enum
  IDModeText   = 0  # Text string
  IDModeInt    = 1  # Integer
  IDModeDouble = 2  # Floating-point
```

### QWizard — Styles and Options

```nim
type WizardStyle* = enum
  WizClassicStyle=0, WizModernStyle=1, WizMacStyle=2, WizAeroStyle=3

type WizardButton* = enum
  WizBtnBack=0, WizBtnNext=1, WizBtnCommit=2, WizBtnFinish=3,
  WizBtnCancel=4, WizBtnHelp=5,
  WizBtnCustom1=6, WizBtnCustom2=7, WizBtnCustom3=8
```

Wizard options (prefix `WizOpt`):  
`WizOptIndependentPages`, `WizOptIgnoreSubTitles`, `WizOptNoDefaultButton`, `WizOptNoBackButtonOnStartPage`, `WizOptNoBackButtonOnLastPage`, `WizOptDisabledBackButtonOnLastPage`, `WizOptHaveNextButtonOnLastPage`, `WizOptHaveFinishButtonOnEarlyPages`, `WizOptNoCancelButton`, `WizOptCancelButtonOnLeft`, `WizOptHaveHelpButton`, `WizOptHelpButtonOnRight`, `WizOptHaveCustomButton1/2/3`, `WizOptNoCancelButtonOnLastPage` (Qt 6.2+).

### WindowModality

```nim
type WindowModality* = enum
  NonModal         = 0  # Non-modal
  WindowModal      = 1  # Blocks parent window only
  ApplicationModal = 2  # Blocks entire application
```

---

## Nim Result Types

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

## QMessageBox — Static Methods

Quick one-liner dialogs without creating an object.

```nim
proc msgInfo*(parent: W, title, text: string)
```
Information dialog. Waits for OK.

```nim
proc msgWarning*(parent: W, title, text: string)
```
Warning dialog.

```nim
proc msgCritical*(parent: W, title, text: string)
```
Critical error dialog.

```nim
proc msgAbout*(parent: W, title, text: string)
```
About dialog (supports HTML/Rich Text).

```nim
proc msgAboutQt*(parent: W, title: string = "About Qt")
```
Standard Qt About dialog.

```nim
proc msgQuestion*(parent: W, title, text: string,
                  buttons: cint = MBBtnYes.cint or MBBtnNo.cint): MsgBoxStdBtn
```
Question dialog. Returns the clicked button.

```nim
proc msgYesNo*(parent: W, title, text: string): bool
```
Quick Yes/No dialog. `true` = Yes clicked.

```nim
proc msgYesNoCancel*(parent: W, title, text: string): MsgBoxStdBtn
```
Yes/No/Cancel dialog.

```nim
proc msgOkCancel*(parent: W, title, text: string): bool
```
Quick OK/Cancel dialog. `true` = OK clicked.

```nim
proc msgSaveDiscardCancel*(parent: W, title, text: string): MsgBoxStdBtn
```
Save/Discard/Cancel dialog (for unsaved documents on close).

```nim
proc msgRetryCancelAbort*(parent: W, title, text: string): MsgBoxStdBtn
```
Retry/Cancel/Abort dialog (for operation errors).

**Example:**
```nim
if msgYesNo(win.asW, "Delete", "Delete the selected files?"):
  deleteSelectedFiles()

case msgSaveDiscardCancel(win.asW, "Exit", "Save changes?")
of MBBtnSave:    saveDocument()
of MBBtnDiscard: discard
of MBBtnCancel:  return
else: discard
```

---

## QMessageBox — Object API

Full manual configuration via object creation.

```nim
proc newMsgBox*(parent: W = nil): MsgBox
```

### Content

```nim
proc msgBoxSetWindowTitle*(mb: MsgBox, title: string)
proc msgBoxSetIcon*(mb: MsgBox, icon: MsgBoxIcon)
proc msgBoxSetText*(mb: MsgBox, text: string)
# Main text. Supports HTML.

proc msgBoxSetInformativeText*(mb: MsgBox, text: string)
# Secondary text (smaller font).

proc msgBoxSetDetailedText*(mb: MsgBox, text: string)
# Detail text (hidden behind a "Details" button).

proc msgBoxSetTextFormat*(mb: MsgBox, fmt: cint)
# 0=PlainText, 1=RichText, 2=AutoText, 3=MarkdownText

proc msgBoxSetTextInteractionFlags*(mb: MsgBox, flags: cint)
# Copying, link navigation, etc.
```

### Button Management

```nim
proc msgBoxSetStdButtons*(mb: MsgBox, buttons: cint)
# OR-combination of MsgBoxStdBtn values.

proc msgBoxSetDefaultButton*(mb: MsgBox, btn: MsgBoxStdBtn)
# Button activated by Enter.

proc msgBoxSetEscapeButton*(mb: MsgBox, btn: MsgBoxStdBtn)
# Button activated by Escape.

proc msgBoxAddButton*(mb: MsgBox, text: string, role: MsgBoxRole): AbsBtn
# Add a custom button.

proc msgBoxStdButton*(mb: MsgBox, btn: MsgBoxStdBtn): AbsBtn
# Get a standard button to customize it.
```

### "Don't Show Again" Checkbox

```nim
proc msgBoxAddCheckBox*(mb: MsgBox, text: string): ptr QCheckBox
# Add a checkbox (e.g. "Don't show this again").

proc msgBoxIsCheckBoxChecked*(mb: MsgBox): bool
# Read checkbox state after exec().
```

### Window Control

```nim
proc msgBoxExec*(mb: MsgBox): MsgBoxStdBtn
# Show modally. Returns the clicked button.

proc msgBoxShow*(mb: MsgBox)      # Non-modal
proc msgBoxHide*(mb: MsgBox)
proc msgBoxClose*(mb: MsgBox)
proc msgBoxSetModal*(mb: MsgBox, b: bool)
proc msgBoxSetStyleSheet*(mb: MsgBox, css: QString)
proc msgBoxResize*(mb: MsgBox, w, h: cint)
proc msgBoxAsW*(mb: MsgBox): W    # Upcast to QWidget*

proc msgBoxClickedButton*(mb: MsgBox): AbsBtn
# Get the button that was clicked (for custom buttons).
```

**Example:**
```nim
let mb = newMsgBox(win.asW)
mb.msgBoxSetIcon(MBWarning)
mb.msgBoxSetWindowTitle("Warning")
mb.msgBoxSetText("<b>File not found</b>")
mb.msgBoxSetInformativeText("Please check the path and try again.")
mb.msgBoxSetDetailedText("Path: /home/user/missing.txt\nError: ENOENT")
mb.msgBoxSetStdButtons(MBBtnOk.cint or MBBtnRetry.cint)
mb.msgBoxSetDefaultButton(MBBtnRetry)
let cb = mb.msgBoxAddCheckBox("Don't show again")
let btn = mb.msgBoxExec()
if mb.msgBoxIsCheckBoxChecked(): savePreference("suppress_warning", true)
```

---

## QMessageBox — Signals

```nim
proc onMsgBoxFinished*(mb: MsgBox, cb: CBInt, ud: pointer)
# Dialog closed. Parameter: 1=Accepted, 0=Rejected.

proc onMsgBoxAccepted*(mb: MsgBox, cb: CB, ud: pointer)
# User clicked OK/Yes/Save.

proc onMsgBoxRejected*(mb: MsgBox, cb: CB, ud: pointer)
# User clicked Cancel/No.
```

---

## QInputDialog — Static Methods

```nim
proc inputText*(parent: W, title, label: string,
                default: string = "",
                echo: cint = 0): InputStrResult
```
Text input dialog. `echo`: 0=Normal, 2=Password, 3=PasswordEchoOnEdit.

```nim
proc inputPassword*(parent: W, title, label: string,
                    default: string = ""): InputStrResult
```
Password entry specialization (shows asterisks).

```nim
proc inputMultiLine*(parent: W, title, label: string,
                     default: string = ""): InputStrResult
```
Multi-line text input dialog.

```nim
proc inputInt*(parent: W, title, label: string,
               default: int = 0,
               min: int = low(cint).int,
               max: int = high(cint).int,
               step: int = 1): InputIntResult
```
Integer input dialog with a spinner.

```nim
proc inputFloat*(parent: W, title, label: string,
                 default: float64 = 0.0,
                 min: float64 = -1e9,
                 max: float64 = 1e9,
                 decimals: int = 3,
                 step: float64 = 1.0): InputFloatResult
```
Floating-point number input dialog.

```nim
proc inputItem*(parent: W, title, label: string,
                items: openArray[string],
                currentIdx: int = 0,
                editable: bool = false): InputItemResult
```
Dropdown list selection dialog.

**Example:**
```nim
let (ok, name) = inputText(win.asW, "New File", "Enter name:")
if ok: createFile(name)

let (ok2, n) = inputInt(win.asW, "Copies", "Number of copies:", 1, 1, 100)
if ok2: printCopies(n)

let (ok3, lang) = inputItem(win.asW, "Language", "Select language:",
                             ["English", "Deutsch", "Français"])
if ok3: setLanguage(lang3.item)
```

---

## QInputDialog — Object API

```nim
proc newInputDialog*(parent: W = nil): InDlg
```

### Configuration

```nim
proc idSetWindowTitle*(d: InDlg, s: string)
proc idSetLabelText*(d: InDlg, s: string)
proc idSetOkButtonText*(d: InDlg, s: string)
proc idSetCancelButtonText*(d: InDlg, s: string)
proc idSetInputMode*(d: InDlg, mode: InputDlgMode)
proc idSetStyleSheet*(d: InDlg, css: QString)
proc idResize*(d: InDlg, w, h: cint)
```

### Text Mode (`IDModeText`)

```nim
proc idSetTextValue*(d: InDlg, s: string)
proc idTextValue*(d: InDlg): string
proc idSetTextEchoMode*(d: InDlg, mode: cint)
# 0=Normal, 2=Password, 3=PasswordEchoOnEdit
```

### Integer Mode (`IDModeInt`)

```nim
proc idSetIntValue*(d: InDlg, v: int)
proc idIntValue*(d: InDlg): int
proc idSetIntRange*(d: InDlg, mn, mx: int)
proc idSetIntStep*(d: InDlg, step: int)
```

### Double Mode (`IDModeDouble`)

```nim
proc idSetDoubleValue*(d: InDlg, v: float64)
proc idDoubleValue*(d: InDlg): float64
proc idSetDoubleRange*(d: InDlg, mn, mx: float64)
proc idSetDoubleDecimals*(d: InDlg, dec: int)
proc idSetDoubleStep*(d: InDlg, step: float64)
```

### Combo Box Mode

```nim
proc idSetComboBoxItems*(d: InDlg, items: openArray[string])
proc idSetComboBoxEditable*(d: InDlg, b: bool)
```

### Control

```nim
proc idExec*(d: InDlg): DlgResult
proc idShow*(d: InDlg)
proc idAsW*(d: InDlg): W
```

---

## QInputDialog — Signals

```nim
proc onIdTextChanged*(d: InDlg, cb: CBStr, ud: pointer)
# Text changed (parameter: new value).

proc onIdIntChanged*(d: InDlg, cb: CBInt, ud: pointer)
proc onIdDoubleChanged*(d: InDlg, cb: proc(v: cdouble, ud: pointer) {.cdecl.}, ud: pointer)
proc onIdAccepted*(d: InDlg, cb: CB, ud: pointer)
proc onIdRejected*(d: InDlg, cb: CB, ud: pointer)

proc onIdTextSelected*(d: InDlg, cb: CBStr, ud: pointer)
# Item selected from combo and confirmed.
```

---

## QFileDialog — Static Methods

```nim
proc fileOpen*(parent: W,
               title: string = "Open File",
               dir: string = "",
               filter: string = "All Files (*)"): FilePickResult
```
Open a single existing file.

```nim
proc fileOpenMany*(parent: W,
                   title: string = "Open Files",
                   dir: string = "",
                   filter: string = "All Files (*)"): FilesPickResult
```
Select multiple files.

```nim
proc fileSave*(parent: W,
               title: string = "Save File",
               dir: string = "",
               filter: string = "All Files (*)"): FilePickResult
```
Save file dialog.

```nim
proc dirSelect*(parent: W,
                title: string = "Select Directory",
                dir: string = "",
                showDirsOnly: bool = true): FilePickResult
```
Directory selection dialog.

```nim
proc fileOpenUrl*(parent: W, title, dir, filter: string): tuple[ok: bool, url: string]
proc fileSaveUrl*(parent: W, title, dir, filter: string): tuple[ok: bool, url: string]
```
Dialogs with remote resource support (via `QUrl`).

**Filter string format:**
```
"Images (*.png *.jpg);;PDF Files (*.pdf);;All Files (*)"
```

**Example:**
```nim
let (ok, path) = fileOpen(win.asW, "Open Document", "/home",
                           "Documents (*.doc *.docx *.odt);;All Files (*)")
if ok: openDocument(path)
```

---

## QFileDialog — Object API

```nim
proc newFileDialog*(parent: W = nil): FileDlg
```

### Configuration

```nim
proc fdSetWindowTitle*(d: FileDlg, s: string)
proc fdSetDirectory*(d: FileDlg, path: string)
proc fdDirectory*(d: FileDlg): string        # Current directory
proc fdSetDefaultSuffix*(d: FileDlg, suffix: string)
# Default extension without dot (e.g. "png").
```

### Filters

```nim
proc fdSetNameFilter*(d: FileDlg, filter: string)
proc fdSetNameFilters*(d: FileDlg, filters: openArray[string])
proc fdSetMimeTypeFilters*(d: FileDlg, mimes: openArray[string])
# e.g. ["image/png", "application/pdf"]
proc fdSelectedNameFilter*(d: FileDlg): string
```

### Modes and Options

```nim
proc fdSetAcceptMode*(d: FileDlg, mode: FDAcceptMode)
proc fdSetFileMode*(d: FileDlg, mode: FDFileMode)
proc fdSetViewMode*(d: FileDlg, mode: FDViewMode)
proc fdSetOption*(d: FileDlg, opt: FDOption, on: bool = true)
proc fdSetOptions*(d: FileDlg, opts: cint)
```

### Selected Files

```nim
proc fdSelectFile*(d: FileDlg, path: string)    # Pre-select a file.
proc fdSelectedFiles*(d: FileDlg): seq[string]
proc fdSelectedFile*(d: FileDlg): string         # First selected file or "".
```

### Navigation

```nim
proc fdSetLabelText*(d: FileDlg, label: FDDialogLabel, text: string)
proc fdSetSidebarUrls*(d: FileDlg, urls: openArray[string])
proc fdSetHistory*(d: FileDlg, paths: openArray[string])
proc fdHistory*(d: FileDlg): seq[string]
```

### Control

```nim
proc fdExec*(d: FileDlg): DlgResult
proc fdOpen*(d: FileDlg)    # Non-modal
proc fdShow*(d: FileDlg)
proc fdHide*(d: FileDlg)
proc fdSetStyleSheet*(d: FileDlg, css: QString)
proc fdResize*(d: FileDlg, w, h: cint)
proc fdAsW*(d: FileDlg): W
```

---

## QFileDialog — Signals

```nim
proc onFdCurrentChanged*(d: FileDlg, cb: CBStr, ud: pointer)
# Current path changed during navigation.

proc onFdCurrentUrlChanged*(d: FileDlg, cb: CBStr, ud: pointer)
proc onFdFileSelected*(d: FileDlg, cb: CBStr, ud: pointer)
# Single file selected.

proc onFdDirectoryEntered*(d: FileDlg, cb: CBStr, ud: pointer)
proc onFdFilterSelected*(d: FileDlg, cb: CBStr, ud: pointer)
proc onFdAccepted*(d: FileDlg, cb: CB, ud: pointer)
proc onFdRejected*(d: FileDlg, cb: CB, ud: pointer)
```

---

## QFontDialog

### Static Method

```nim
proc fontGet*(parent: W,
              title: string = "Select Font",
              initFamily: string = "Arial",
              initSize: int = 12,
              initBold: bool = false,
              initItalic: bool = false): FontPickResult
```
Font selection dialog returning a full `FontPickResult`.

**Example:**
```nim
let res = fontGet(win.asW, "Text Font", "Verdana", 14, true, false)
if res.ok:
  echo res.family    # "Verdana"
  echo res.pointSize # 14
  echo res.bold      # true
```

### Object API

```nim
proc newFontDialog*(parent: W = nil): FontDlg
```

```nim
proc ftdSetCurrentFont*(d: FontDlg, family: string, size: int,
                        bold: bool = false, italic: bool = false,
                        underline: bool = false, strikeOut: bool = false)
```

Reading the current font:
```nim
proc ftdCurrentFamily*(d: FontDlg): string
proc ftdCurrentPointSize*(d: FontDlg): int
proc ftdCurrentBold*(d: FontDlg): bool
proc ftdCurrentItalic*(d: FontDlg): bool
proc ftdCurrentUnderline*(d: FontDlg): bool
proc ftdCurrentStrikeOut*(d: FontDlg): bool
proc ftdCurrentWeight*(d: FontDlg): int

proc ftdCurrentFontStr*(d: FontDlg): string
# Returns "family,size,bold,italic" string for storage.
```

Options and control:
```nim
proc ftdSetOption*(d: FontDlg, opt: FontDlgOption, on: bool = true)
proc ftdSetWindowTitle*(d: FontDlg, s: string)
proc ftdExec*(d: FontDlg): DlgResult
proc ftdShow*(d: FontDlg)
proc ftdSetStyleSheet*(d: FontDlg, css: QString)
proc ftdAsW*(d: FontDlg): W
```

---

## QFontDialog — Signals

```nim
proc onFtdCurrentFontChanged*(d: FontDlg, cb: CBStr, ud: pointer)
# Current font changed. Parameter: font family name.

proc onFtdFontSelected*(d: FontDlg, cb: CBStr, ud: pointer)
# Font selected and confirmed.

proc onFtdAccepted*(d: FontDlg, cb: CB, ud: pointer)
proc onFtdRejected*(d: FontDlg, cb: CB, ud: pointer)
```

---

## QColorDialog

### Static Methods

```nim
proc colorGet*(parent: W,
               title: string = "Select Color",
               initR, initG, initB: int = 255,
               initA: int = 255,
               showAlpha: bool = false): ColorPickResult
```
Color dialog returning RGBA components (0–255 each).

```nim
proc colorGetHex*(parent: W,
                  title: string = "Select Color",
                  initHex: string = "#ffffff"): tuple[ok: bool, hex: string]
```
Returns `"#rrggbb"` hex string.

```nim
proc colorGetHexAlpha*(parent: W,
                       title: string = "...",
                       initHex: string = "#ffffffff"): tuple[ok: bool, hex: string]
```
Returns `"#aarrggbb"` with alpha channel.

**Example:**
```nim
let (ok, hex) = colorGetHex(win.asW, "Background Color", "#336699")
if ok: setBackground(hex)
```

### Object API

```nim
proc newColorDialog*(parent: W = nil): ColDlg
```

Setting initial color:
```nim
proc cdSetCurrentColor*(d: ColDlg, r, g, b: int, a: int = 255)
proc cdSetCurrentColorHex*(d: ColDlg, hex: string)
# hex: "#rrggbb" or "#aarrggbb"
```

Reading the current color:
```nim
proc cdCurrentRGBA*(d: ColDlg): tuple[r, g, b, a: int]
proc cdCurrentR*(d: ColDlg): int
proc cdCurrentG*(d: ColDlg): int
proc cdCurrentB*(d: ColDlg): int
proc cdCurrentA*(d: ColDlg): int
proc cdCurrentHex*(d: ColDlg): string       # "#rrggbb"
proc cdCurrentHexAlpha*(d: ColDlg): string  # "#aarrggbb"
```

Custom color palette (16 slots):
```nim
proc cdSetCustomColor*(index: int, r, g, b: int)  # Static. index: 0..15.
proc cdCustomColor*(index: int): tuple[r, g, b: int]
proc cdCustomColorCount*(): int                    # Usually 16.
```

Options and control:
```nim
proc cdSetOption*(d: ColDlg, opt: ColorDlgOption, on: bool = true)
proc cdSetWindowTitle*(d: ColDlg, s: string)
proc cdExec*(d: ColDlg): DlgResult
proc cdOpen*(d: ColDlg)    # Non-modal
proc cdShow*(d: ColDlg)
proc cdSetStyleSheet*(d: ColDlg, css: QString)
proc cdAsW*(d: ColDlg): W
```

---

## QColorDialog — Signals

```nim
proc onCdColorSelected*(d: ColDlg, cb: CBStr, ud: pointer)
# Color selected and confirmed. Parameter: "#rrggbb".

proc onCdCurrentColorChanged*(d: ColDlg, cb: CBStr, ud: pointer)
# Current color changed (before confirmation).

proc onCdAccepted*(d: ColDlg, cb: CB, ud: pointer)
proc onCdRejected*(d: ColDlg, cb: CB, ud: pointer)
```

---

## QProgressDialog

### Creation

```nim
proc newProgressDialog*(parent: W = nil,
                        label: string = "Please wait...",
                        cancelBtn: string = "Cancel",
                        minVal: int = 0,
                        maxVal: int = 100): ProgDlg
# cancelBtn = "" hides the cancel button.
```

```nim
proc newProgressDialogNoCancel*(parent: W = nil,
                                label: string = "Please wait...",
                                minVal: int = 0,
                                maxVal: int = 100): ProgDlg
# Without a Cancel button (non-cancellable operation).
```

### Progress Control

```nim
proc pdSetValue*(d: ProgDlg, v: int)      # Set current value (0..max).
proc pdValue*(d: ProgDlg): int            # Current value.
proc pdSetRange*(d: ProgDlg, mn, mx: int)
proc pdMinimum*(d: ProgDlg): int
proc pdMaximum*(d: ProgDlg): int

proc pdStep*(d: ProgDlg, increment: int = 1)
# Increment by `increment` and call processEvents().
# Use in loops to keep the UI responsive.
```

### Display

```nim
proc pdSetLabelText*(d: ProgDlg, s: string)
# Update the label text (can be called in a loop).

proc pdSetWindowTitle*(d: ProgDlg, s: string)
proc pdSetCancelButtonText*(d: ProgDlg, s: string)

proc pdSetMinimumDuration*(d: ProgDlg, ms: int)
# Delay before showing the dialog (default 4000 ms). 0 = show immediately.
```

### Behavior

```nim
proc pdSetAutoClose*(d: ProgDlg, b: bool)   # Close automatically at 100%.
proc pdSetAutoReset*(d: ProgDlg, b: bool)   # Reset at 100%.
proc pdSetModal*(d: ProgDlg, b: bool)
proc pdWasCanceled*(d: ProgDlg): bool       # true if Cancel was clicked.
```

### Window Control

```nim
proc pdReset*(d: ProgDlg)
proc pdShow*(d: ProgDlg)
proc pdHide*(d: ProgDlg)
proc pdClose*(d: ProgDlg)
proc pdSetStyleSheet*(d: ProgDlg, css: QString)
proc pdResize*(d: ProgDlg, w, h: cint)
proc pdAsW*(d: ProgDlg): W
```

### Signal

```nim
proc onPdCanceled*(d: ProgDlg, cb: CB, ud: pointer)
# User clicked Cancel.
```

**Example:**
```nim
let pd = newProgressDialog(win.asW, "Copying files", "Stop", 0, files.len)
pd.pdSetWindowTitle("File Copy")
pd.pdSetMinimumDuration(0)
pd.pdShow()

for i, f in files:
  if pd.pdWasCanceled(): break
  copyFile(f)
  pd.pdSetLabelText("Copying: " & f.extractFilename)
  pd.pdSetValue(i + 1)
  processEvents()
```

---

## QErrorMessage

Suppressible error message dialog.

```nim
proc newErrorMessage*(parent: W = nil): ErrMsg

proc emShowMessage*(d: ErrMsg, msg: string)
# Show a message. Repeated calls with the same text are suppressed
# once the user clicks "Don't show again".

proc emShowMessageType*(d: ErrMsg, msg: string, msgType: string)
# Different types are suppressed independently.

proc emSetWindowTitle*(d: ErrMsg, s: string)
proc emExec*(d: ErrMsg): int
proc emShow*(d: ErrMsg)
proc emAsW*(d: ErrMsg): W

proc appErrorMessage*(): ErrMsg
# Singleton QErrorMessage::qtHandler() — intercepts qWarning().
```

**Example:**
```nim
let em = newErrorMessage(win.asW)
em.emShowMessage("Failed to connect to the database.")
# On repeated calls with the same text, the dialog will not appear
# if the user has checked "Don't show again".
```

---

## QDialogButtonBox

Standard horizontal (or vertical) button panel.

### Creation

```nim
proc newDlgButtonBox*(buttons: cint, parent: W = nil): DlgBBx
# OR-combination of DlgBBxStdBtn, e.g. DBBOk.cint or DBBCancel.cint

proc newDlgButtonBoxH*(buttons: cint, parent: W = nil): DlgBBx
# Explicitly horizontal.

proc newDlgButtonBoxV*(buttons: cint, parent: W = nil): DlgBBx
# Vertical.
```

### Button Management

```nim
proc dbbButton*(box: DlgBBx, btn: DlgBBxStdBtn): AbsBtn
# Get a standard button to customize text, icon, etc.

proc dbbAddButton*(box: DlgBBx, text: string, role: DlgBBxRole): AbsBtn
# Add a custom button with the given role.

proc dbbRemoveButton*(box: DlgBBx, btn: AbsBtn)
proc dbbSetEnabled*(box: DlgBBx, btn: DlgBBxStdBtn, on: bool)
proc dbbSetButtonText*(box: DlgBBx, btn: DlgBBxStdBtn, text: string)
proc dbbSetStdButtons*(box: DlgBBx, buttons: cint)
```

### Appearance

```nim
proc dbbSetOrientation*(box: DlgBBx, horiz: bool)
proc dbbSetCenterButtons*(box: DlgBBx, b: bool)
proc dbbSetStyleSheet*(box: DlgBBx, css: QString)
proc dbbAsW*(box: DlgBBx): W
```

---

## QDialogButtonBox — Signals

```nim
proc onDbbAccepted*(box: DlgBBx, cb: CB, ud: pointer)
# Button with AcceptRole clicked (OK/Yes/Save).

proc onDbbRejected*(box: DlgBBx, cb: CB, ud: pointer)
# Button with RejectRole clicked (Cancel/No).

proc onDbbClicked*(box: DlgBBx, cb: CBStr, ud: pointer)
# Any button clicked. Parameter: button text.

proc onDbbHelpRequested*(box: DlgBBx, cb: CB, ud: pointer)
# Help button clicked.
```

---

## QDialog — Custom Base Dialog

### Creation

```nim
proc newCustomDialog*(parent: W = nil, flags: cint = 0): CDlg
# flags — Qt::WindowFlags (0 = standard flags).
```

### Control

```nim
proc cdlgExec*(d: CDlg): DlgResult      # Modal show.
proc cdlgOpen*(d: CDlg)                 # Semi-modal (blocks parent only).
proc cdlgShow*(d: CDlg)                 # Non-modal.
proc cdlgHide*(d: CDlg)
proc cdlgClose*(d: CDlg)
proc cdlgAccept*(d: CDlg)               # Programmatic accept.
proc cdlgReject*(d: CDlg)               # Programmatic reject.
proc cdlgDone*(d: CDlg, r: cint)        # Finish with code.
proc cdlgResult*(d: CDlg): int          # Last exec() result.
```

### Modality

```nim
proc cdlgSetModal*(d: CDlg, b: bool)
proc cdlgSetWindowModality*(d: CDlg, m: WindowModality)
```

### Title and Size

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

### Layout and Style

```nim
proc cdlgSetLayout*(d: CDlg, l: VBox)
proc cdlgSetLayout*(d: CDlg, l: HBox)
proc cdlgSetLayout*(d: CDlg, l: Grid)
proc cdlgSetLayout*(d: CDlg, l: Form)
proc cdlgSetStyleSheet*(d: CDlg, css: QString)
proc cdlgAsW*(d: CDlg): W
```

### Window Flags

```nim
proc cdlgSetWindowFlags*(d: CDlg, flags: cint)
proc cdlgSetWindowFlag*(d: CDlg, flag: cint, on: bool = true)
```

---

## QDialog — Builder Helpers

Quickly create common dialog patterns without boilerplate.

```nim
proc buildSimpleDialog*(parent: W, title: string, body: W,
                        buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg
```
Creates: title + widget + `QDialogButtonBox`. Accept/Reject wired automatically.

```nim
proc buildLabeledDialog*(parent: W, title, labelText: string, body: W,
                         buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg
```
Like `buildSimpleDialog` but with a `QLabel` above the widget.

```nim
proc buildGridDialog*(parent: W, title: string,
                      rows: openArray[tuple[label: string, widget: W]],
                      buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg
```
Creates a `QFormLayout`-based dialog with label–widget pairs.

**Examples:**
```nim
# Simple dialog with an editor
let editor = newPlainTextEdit(nil)
let dlg = buildSimpleDialog(win.asW, "Editor", editor.asW)
if dlg.cdlgExec() == DlgAccepted:
  echo editor.toPlainText()

# Labeled dialog
let le = newLineEdit(nil)
let dlg2 = buildLabeledDialog(nil, "Input", "Enter username:", le.asW)
if dlg2.cdlgExec() == DlgAccepted:
  setUsername(le.text())

# Form dialog
let nameEdit = newLineEdit(nil)
let ageBox   = newSpinBox(nil)
let dlg3 = buildGridDialog(nil, "New User", [
  ("Name:",  nameEdit.asW),
  ("Age:",   ageBox.asW)
])
if dlg3.cdlgExec() == DlgAccepted:
  addUser(nameEdit.text(), ageBox.value())
```

---

## QDialog — Signals

```nim
proc onCdlgAccepted*(d: CDlg, cb: CB, ud: pointer)
proc onCdlgRejected*(d: CDlg, cb: CB, ud: pointer)
proc onCdlgFinished*(d: CDlg, cb: CBInt, ud: pointer)
# Parameter: 1=Accepted, 0=Rejected.
```

---

## QWizard — Wizard Dialog

Multi-page wizard dialog.

### Creation

```nim
proc newWizard*(parent: W = nil): Wiz
```

### Page Management

```nim
proc wizAddPage*(w: Wiz, page: WizPage): int
# Add a page. Returns the auto-assigned ID.

proc wizSetPage*(w: Wiz, id: int, page: WizPage)
# Add a page with a fixed ID.

proc wizRemovePage*(w: Wiz, id: int)
```

### Navigation

```nim
proc wizCurrentId*(w: Wiz): int
proc wizCurrentPage*(w: Wiz): WizPage
proc wizNextId*(w: Wiz): int
proc wizSetStartId*(w: Wiz, id: int)
proc wizStartId*(w: Wiz): int
proc wizRestart*(w: Wiz)    # Restart from the beginning.
proc wizBack*(w: Wiz)
proc wizNext*(w: Wiz)
```

### Visit History

```nim
proc wizHasVisitedPage*(w: Wiz, id: int): bool
proc wizVisitedIds*(w: Wiz): seq[int]
```

### Appearance

```nim
proc wizSetWindowTitle*(w: Wiz, s: string)
proc wizSetWizardStyle*(w: Wiz, style: WizardStyle)
proc wizSetOption*(w: Wiz, opt: WizardOption, on: bool = true)
proc wizTestOption*(w: Wiz, opt: WizardOption): bool
proc wizSetTitleFormat*(w: Wiz, fmt: cint)    # 0=Plain, 1=Rich
proc wizSetSubTitleFormat*(w: Wiz, fmt: cint)
```

### Buttons

```nim
proc wizSetButtonText*(w: Wiz, which: WizardButton, text: string)
proc wizButtonText*(w: Wiz, which: WizardButton): string
proc wizSetButton*(w: Wiz, which: WizardButton, btn: AbsBtn)
# Replace a standard button with a custom one.
```

### Fields

Fields are registered on pages (via `wpRegisterField`) and read at the wizard level:

```nim
proc wizSetField*(w: Wiz, name: string, value: string)
proc wizFieldStr*(w: Wiz, name: string): string
proc wizFieldInt*(w: Wiz, name: string): int
proc wizFieldBool*(w: Wiz, name: string): bool
```

### Control

```nim
proc wizExec*(w: Wiz): DlgResult
proc wizShow*(w: Wiz)
proc wizResize*(w: Wiz, ww, h: cint)
proc wizSetStyleSheet*(w: Wiz, css: QString)
proc wizAsW*(w: Wiz): W
```

**Example:**
```nim
let wiz = newWizard()
wiz.wizSetWindowTitle("Project Setup")
wiz.wizSetWizardStyle(WizModernStyle)
wiz.wizSetOption(WizOptNoBackButtonOnStartPage)

let page1 = newWizardPage()
page1.wpSetTitle("Step 1: Project Name")
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

## QWizard — Signals

```nim
proc onWizCurrentIdChanged*(w: Wiz, cb: CBInt, ud: pointer)
# Navigated to a different page. Parameter: new page ID.

proc onWizPageAdded*(w: Wiz, cb: CBInt, ud: pointer)
proc onWizPageRemoved*(w: Wiz, cb: CBInt, ud: pointer)
proc onWizAccepted*(w: Wiz, cb: CB, ud: pointer)   # Finish clicked.
proc onWizRejected*(w: Wiz, cb: CB, ud: pointer)   # Cancel clicked.
proc onWizFinished*(w: Wiz, cb: CBInt, ud: pointer)
# Wizard closed. Parameter: 1=Accepted, 0=Rejected.
proc onWizHelpRequested*(w: Wiz, cb: CB, ud: pointer)
proc onWizCustomButtonClicked*(w: Wiz, cb: CBInt, ud: pointer)
# Parameter: 1, 2, or 3 (Custom1/2/3).
```

---

## QWizardPage — Wizard Page

```nim
proc newWizardPage*(parent: W = nil): WizPage
```

### Title and Subtitle

```nim
proc wpSetTitle*(p: WizPage, s: string)
proc wpTitle*(p: WizPage): string
proc wpSetSubTitle*(p: WizPage, s: string)
proc wpSubTitle*(p: WizPage): string
```

### Layout

```nim
proc wpSetLayout*(p: WizPage, l: VBox)
proc wpSetLayout*(p: WizPage, l: HBox)
proc wpSetLayout*(p: WizPage, l: Grid)
proc wpSetLayout*(p: WizPage, l: Form)
```

### Page Behavior

```nim
proc wpSetFinalPage*(p: WizPage, b: bool)
# Mark as final — shows the Finish button.
proc wpIsFinalPage*(p: WizPage): bool

proc wpSetCommitPage*(p: WizPage, b: bool)
# Mark as commit — Back is disabled after crossing it.
proc wpIsCommitPage*(p: WizPage): bool

proc wpIsComplete*(p: WizPage): bool
# true if the page is complete (Next/Finish enabled).

proc wpNextId*(p: WizPage): int
# Next page ID (-1 = auto).
```

### Page Fields

```nim
proc wpRegisterField*(p: WizPage, name: string, widget: W,
                      prop: cstring = nil, changedSig: cstring = nil)
```
Register a named field. A `*` suffix (e.g. `"email*"`) makes it mandatory — the page is not complete until it is filled. Values are read via `wizFieldStr/Int/Bool` on the wizard.

### Other

```nim
proc wpSetStyleSheet*(p: WizPage, css: QString)
proc wpAsW*(p: WizPage): W
```

---

## High-Level Nim Utilities

### Confirmation Dialogs

```nim
proc confirmDelete*(parent: W, itemName: string): bool
# "Are you sure you want to delete «itemName»?"

proc confirmDiscard*(parent: W): bool
# "There are unsaved changes. Discard them?"

proc confirmOverwrite*(parent: W, path: string): bool
# "File «path» already exists. Overwrite?"

proc confirmAction*(parent: W, title, question: string): bool
# General-purpose confirmation dialog.

proc confirmSaveChanges*(parent: W): MsgBoxStdBtn
# "Save/Discard/Cancel" on document close.
# Returns MBBtnSave, MBBtnDiscard, or MBBtnCancel.
```

### Input Dialogs

```nim
proc showValidationError*(parent: W, field, reason: string)
# Shows: "Field «field»: reason".

proc askTextRequired*(parent: W, title, prompt: string,
                      maxLen: int = 0): string
# Request a non-empty string. Repeats until one is entered.
# Returns "" if Cancel is clicked.

proc askInt*(parent: W, title, prompt: string,
             default: int = 0, min, max: int): tuple[ok: bool, value: int]

proc askFloat*(parent: W, title, prompt: string,
               default: float64 = 0.0, min, max: float64): tuple[ok: bool, value: float64]

proc askChoice*(parent: W, title, prompt: string,
                choices: openArray[string],
                currentIdx: int = 0): string
# Returns selected item or "" on cancel.
```

### File System Dialogs

```nim
proc pickOpenFile*(parent: W, title, filter, dir: string): string
# File path or "".

proc pickSaveFile*(parent: W, title, filter, dir: string): string
proc pickDirectory*(parent: W, title, dir: string): string
proc pickOpenFiles*(parent: W, title, filter, dir: string): seq[string]

proc pickImageFile*(parent: W, title: string = "Select Image"): string
# Filter: PNG, JPG, BMP, GIF, WEBP, TIFF, ICO.

proc pickVideoFile*(parent: W, title: string = "Select Video"): string
# Filter: MP4, MKV, AVI, MOV, WMV, FLV, WEBM.

proc pickAudioFile*(parent: W, title: string = "Select Audio"): string
# Filter: MP3, WAV, OGG, FLAC, AAC, M4A.
```

### Color and Font Dialogs

```nim
proc pickColorHex*(parent: W, title, init: string): string
# Returns "#rrggbb" or "".

proc pickColorHexAlpha*(parent: W, title, init: string): string
# Returns "#aarrggbb" or "".

proc pickColorRgba*(parent: W, title: string,
                    showAlpha: bool = false): tuple[ok: bool, r, g, b, a: int]

proc pickFontStr*(parent: W, title, initFamily: string,
                  initSize: int): string
# Returns "family,size" or "".

proc pickFontFull*(parent: W, title, initFamily: string,
                   initSize: int): FontPickResult
# Full font description.
```

### Progress Utilities

```nim
proc withProgress*(parent: W, title, label: string,
                   total: int, minDuration: int = 500,
                   body: proc(pd: ProgDlg) {.closure.})
```
Run a non-cancellable operation with a progress dialog. Dialog closes automatically.

```nim
proc withProgressCancellable*(parent: W, title, label: string,
                               total: int, minDuration: int = 500,
                               body: proc(pd: ProgDlg): bool {.closure.}): bool
```
Run a cancellable operation. `body` should return `false` on cancellation. Returns `true` if completed.

**Examples:**
```nim
# Confirmation
if confirmDelete(win.asW, "report_2024.pdf"):
  deleteFile("report_2024.pdf")

# Input
let name = askTextRequired(win.asW, "Project Name", "Enter name:", 64)
if name != "": createProject(name)

# Files
let img = pickImageFile(win.asW)
if img != "": loadImage(img)

# Non-cancellable progress
withProgress(win.asW, "Export", "Exporting data...", records.len):
  proc(pd: ProgDlg) =
    for i, rec in records:
      exportRecord(rec)
      pd.pdSetValue(i + 1)

# Cancellable progress
let ok = withProgressCancellable(win.asW, "Download", "Downloading...", 100):
  proc(pd: ProgDlg): bool =
    for i in 1..100:
      if pd.pdWasCanceled(): return false
      downloadChunk(i)
      pd.pdSetValue(i)
    true
if ok: echo "Download complete"
else:  echo "Download cancelled"
```

---

## Compatibility Notes and Caveats

- All strings are converted via `QString::fromUtf8()`. Full Unicode is supported.
- Static `QByteArray` instances used for string return values are **not thread-safe** under concurrent calls.
- Dialog pointers are not managed by Nim's GC. Use `objDelete` / `objDeleteLater` to free memory.
- Callbacks (`CB`, `CBStr`, `CBInt`) require the `{.cdecl.}` calling convention.
- `exec()` runs a nested event loop — the dialog blocks the thread until closed.
- `open()` shows a semi-modal dialog — blocks the parent window only.
- `show()` is non-modal and returns control immediately.
- Build command: `nim cpp --passC:"-std=c++20" your_file.nim`
