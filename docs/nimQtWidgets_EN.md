# nimQtWidgets — Library Reference (English)

> A comprehensive Qt6Widgets wrapper for the Nim programming language.  
> Compilation: `nim cpp --passC:"-std=c++20" yourapp.nim`  
> Dependencies: `nimQtUtils`, `nimQtFFI`

---

## Table of Contents

1. [Overview](#overview)
2. [Widget Types and Aliases](#widget-types-and-aliases)
3. [Enumerations](#enumerations)
4. [QApplication](#qapplication)
5. [QWidget](#qwidget)
6. [QMainWindow](#qmainwindow)
7. [QStatusBar](#qstatusbar)
8. [QMenuBar](#qmenubar)
9. [QMenu](#qmenu)
10. [QAction](#qaction)
11. [QActionGroup](#qactiongroup)
12. [QToolBar](#qtoolbar)
13. [QLabel](#qlabel)
14. [QPushButton](#qpushbutton)
15. [QToolButton](#qtoolbutton)
16. [QRadioButton](#qradiobutton)
17. [QCheckBox](#qcheckbox)
18. [QButtonGroup](#qbuttongroup)
19. [QCommandLinkButton](#qcommandlinkbutton)
20. [QLineEdit](#qlineedit)
21. [QTextEdit](#qtextedit)
22. [QPlainTextEdit](#qplaintextedit)
23. [QTextBrowser](#qtextbrowser)
24. [QSpinBox / QDoubleSpinBox](#qspinbox--qdoublespinbox)
25. [QSlider / QScrollBar / QDial](#qslider--qscrollbar--qdial)
26. [QProgressBar](#qprogressbar)
27. [QComboBox / QFontComboBox](#qcombobox--qfontcombobox)
28. [QLCDNumber](#qlcdnumber)
29. [QGroupBox](#qgroupbox)
30. [QFrame](#qframe)
31. [QStackedWidget](#qstackedwidget)
32. [QTabWidget](#qtabwidget)
33. [QTabBar](#qtabbar)
34. [QSplitter](#qsplitter)
35. [QScrollArea](#qscrollarea)
36. [QDockWidget](#qdockwidget)
37. [QMdiArea / QMdiSubWindow](#qmdiarea--qmdisubwindow)
38. [QListWidget / QListWidgetItem](#qlistwidget--qlistwidgetitem)
39. [QTreeWidget / QTreeWidgetItem](#qtreewidget--qtreewidgetitem)
40. [QTableWidget / QTableWidgetItem](#qtablewidget--qtablewidgetitem)
41. [QHeaderView](#qheaderview)
42. [QDateTimeEdit / QDateEdit / QTimeEdit](#qdatetimeedit--qdateedit--qtimeedit)
43. [Layouts](#layouts)
44. [QCompleter](#qcompleter)
45. [QShortcut](#qshortcut)
46. [QSystemTrayIcon](#qsystemtrayicon)
47. [QCalendarWidget](#qcalendarwidget)
48. [QWizard / QWizardPage](#qwizard--qwizardpage)
49. [QDialog](#qdialog)
50. [Data Models](#data-models)
51. [QSortFilterProxyModel](#qsortfilterproxymodel)
52. [QSizeGrip / QRubberBand](#qsizegrip--qrubberband)
53. [QFontDatabase](#qfontdatabase)
54. [QToolTip (static)](#qtooltip-static)
55. [Utilities and Styling](#utilities-and-styling)

---

## Overview

`nimQtWidgets` provides a thin Nim wrapper over Qt6 Widgets using the `importcpp` mechanism. All widget types are **opaque types** and operations are performed through pointers (`ptr`).

### Compiler Setup (MSYS2/ucrt64)

```nim
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

### Callback Types (from nimQtFFI)

| Type      | Signature                                   |
|-----------|---------------------------------------------|
| `CB`      | `proc(ud: pointer) {.cdecl.}`               |
| `CBBool`  | `proc(v: cint, ud: pointer) {.cdecl.}`      |
| `CBInt`   | `proc(v: cint, ud: pointer) {.cdecl.}`      |
| `CBStr`   | `proc(s: cstring, ud: pointer) {.cdecl.}`   |

---

## Widget Types and Aliases

### Opaque Types (C++ classes)

| Nim Type               | Qt Class               |
|------------------------|------------------------|
| `QApplication`         | `QApplication`         |
| `QMainWindow`          | `QMainWindow`          |
| `QWidget`              | `QWidget`              |
| `QDialog`              | `QDialog`              |
| `QPushButton`          | `QPushButton`          |
| `QToolButton`          | `QToolButton`          |
| `QRadioButton`         | `QRadioButton`         |
| `QCheckBox`            | `QCheckBox`            |
| `QCommandLinkButton`   | `QCommandLinkButton`   |
| `QLabel`               | `QLabel`               |
| `QLineEdit`            | `QLineEdit`            |
| `QTextEdit`            | `QTextEdit`            |
| `QPlainTextEdit`       | `QPlainTextEdit`       |
| `QTextBrowser`         | `QTextBrowser`         |
| `QSpinBox`             | `QSpinBox`             |
| `QDoubleSpinBox`       | `QDoubleSpinBox`       |
| `QTimeEdit`            | `QTimeEdit`            |
| `QDateEdit`            | `QDateEdit`            |
| `QDateTimeEdit`        | `QDateTimeEdit`        |
| `QDial`                | `QDial`                |
| `QSlider`              | `QSlider`              |
| `QScrollBar`           | `QScrollBar`           |
| `QProgressBar`         | `QProgressBar`         |
| `QComboBox`            | `QComboBox`            |
| `QFontComboBox`        | `QFontComboBox`        |
| `QLCDNumber`           | `QLCDNumber`           |
| `QGroupBox`            | `QGroupBox`            |
| `QFrame`               | `QFrame`               |
| `QStackedWidget`       | `QStackedWidget`       |
| `QTabWidget`           | `QTabWidget`           |
| `QTabBar`              | `QTabBar`              |
| `QSplitter`            | `QSplitter`            |
| `QScrollArea`          | `QScrollArea`          |
| `QDockWidget`          | `QDockWidget`          |
| `QMdiArea`             | `QMdiArea`             |
| `QMdiSubWindow`        | `QMdiSubWindow`        |
| `QListWidget`          | `QListWidget`          |
| `QListWidgetItem`      | `QListWidgetItem`      |
| `QTreeWidget`          | `QTreeWidget`          |
| `QTreeWidgetItem`      | `QTreeWidgetItem`      |
| `QTableWidget`         | `QTableWidget`         |
| `QTableWidgetItem`     | `QTableWidgetItem`     |
| `QHeaderView`          | `QHeaderView`          |
| `QMenu`                | `QMenu`                |
| `QMenuBar`             | `QMenuBar`             |
| `QAction`              | `QAction`              |
| `QActionGroup`         | `QActionGroup`         |
| `QToolBar`             | `QToolBar`             |
| `QStatusBar`           | `QStatusBar`           |
| `QLayout`              | `QLayout`              |
| `QVBoxLayout`          | `QVBoxLayout`          |
| `QHBoxLayout`          | `QHBoxLayout`          |
| `QGridLayout`          | `QGridLayout`          |
| `QFormLayout`          | `QFormLayout`          |
| `QStackedLayout`       | `QStackedLayout`       |
| `QSystemTrayIcon`      | `QSystemTrayIcon`      |
| `QCompleter`           | `QCompleter`           |
| `QButtonGroup`         | `QButtonGroup`         |
| `QShortcut`            | `QShortcut`            |
| `QCalendarWidget`      | `QCalendarWidget`      |
| `QWizard`              | `QWizard`              |
| `QWizardPage`          | `QWizardPage`          |
| `QStandardItemModel`   | `QStandardItemModel`   |
| `QStandardItem`        | `QStandardItem`        |
| `QStringListModel`     | `QStringListModel`     |
| `QItemSelectionModel`  | `QItemSelectionModel`  |
| `QAbstractItemModel`   | `QAbstractItemModel`   |
| `QSortFilterProxyModel`| `QSortFilterProxyModel`|
| `QModelIndex`          | `QModelIndex`          |

### Short Pointer Aliases

| Alias      | Type                           |
|------------|--------------------------------|
| `App`      | `ptr QApplication`             |
| `Win`      | `ptr QMainWindow`              |
| `W`        | `ptr QWidget`                  |
| `Dlg`      | `ptr QDialog`                  |
| `Btn`      | `ptr QPushButton`              |
| `TBtn`     | `ptr QToolButton`              |
| `Radio`    | `ptr QRadioButton`             |
| `ChkBox`   | `ptr QCheckBox`                |
| `CmdBtn`   | `ptr QCommandLinkButton`       |
| `Lbl`      | `ptr QLabel`                   |
| `LE`       | `ptr QLineEdit`                |
| `TE`       | `ptr QTextEdit`                |
| `PTE`      | `ptr QPlainTextEdit`           |
| `TBrw`     | `ptr QTextBrowser`             |
| `Spin`     | `ptr QSpinBox`                 |
| `DSpin`    | `ptr QDoubleSpinBox`           |
| `TmEdit`   | `ptr QTimeEdit`                |
| `DtEdit`   | `ptr QDateEdit`                |
| `DtTmEdit` | `ptr QDateTimeEdit`            |
| `Dial`     | `ptr QDial`                    |
| `Slider`   | `ptr QSlider`                  |
| `SBar`     | `ptr QScrollBar`               |
| `Prog`     | `ptr QProgressBar`             |
| `Combo`    | `ptr QComboBox`                |
| `FCombo`   | `ptr QFontComboBox`            |
| `LCD`      | `ptr QLCDNumber`               |
| `Grp`      | `ptr QGroupBox`                |
| `Frm`      | `ptr QFrame`                   |
| `Stack`    | `ptr QStackedWidget`           |
| `Tab`      | `ptr QTabWidget`               |
| `TabBar`   | `ptr QTabBar`                  |
| `Splt`     | `ptr QSplitter`                |
| `Scroll`   | `ptr QScrollArea`              |
| `Dock`     | `ptr QDockWidget`              |
| `Mdi`      | `ptr QMdiArea`                 |
| `MdiSub`   | `ptr QMdiSubWindow`            |
| `LW`       | `ptr QListWidget`              |
| `LWI`      | `ptr QListWidgetItem`          |
| `TW`       | `ptr QTreeWidget`              |
| `TWI`      | `ptr QTreeWidgetItem`          |
| `TblW`     | `ptr QTableWidget`             |
| `TblWI`    | `ptr QTableWidgetItem`         |
| `HdrView`  | `ptr QHeaderView`              |
| `Menu`     | `ptr QMenu`                    |
| `MBar`     | `ptr QMenuBar`                 |
| `Act`      | `ptr QAction`                  |
| `ActGrp`   | `ptr QActionGroup`             |
| `TB`       | `ptr QToolBar`                 |
| `StatusBar`| `ptr QStatusBar`               |
| `VBox`     | `ptr QVBoxLayout`              |
| `HBox`     | `ptr QHBoxLayout`              |
| `Grid`     | `ptr QGridLayout`              |
| `Form`     | `ptr QFormLayout`              |
| `StkLyt`   | `ptr QStackedLayout`           |
| `Tray`     | `ptr QSystemTrayIcon`          |
| `Compltr`  | `ptr QCompleter`               |
| `BtnGrp`   | `ptr QButtonGroup`             |
| `Shortcut` | `ptr QShortcut`                |
| `Calendar` | `ptr QCalendarWidget`          |
| `Wizard`   | `ptr QWizard`                  |
| `WizPage`  | `ptr QWizardPage`              |
| `SIM`      | `ptr QStandardItemModel`       |
| `SI`       | `ptr QStandardItem`            |
| `SLM`      | `ptr QStringListModel`         |
| `ISM`      | `ptr QItemSelectionModel`      |
| `AIM`      | `ptr QAbstractItemModel`       |
| `SFPM`     | `ptr QSortFilterProxyModel`    |

---

## Enumerations

### QLineEditEchoMode
| Value                | Description                        |
|----------------------|------------------------------------|
| `Normal`             | Normal input display (0)           |
| `NoEcho`             | Input is not displayed (1)         |
| `Password`           | Dots replace characters (2)        |
| `PasswordEchoOnEdit` | Visible while editing (3)          |

### QTabPosition
| Value       | Description           |
|-------------|-----------------------|
| `TabNorth`  | Tabs at top (0)       |
| `TabSouth`  | Tabs at bottom (1)    |
| `TabWest`   | Tabs at left (2)      |
| `TabEast`   | Tabs at right (3)     |

### QTabShape
| Value        | Description              |
|--------------|--------------------------|
| `Rounded`    | Rounded tab corners (0)  |
| `Triangular` | Triangular tabs (1)      |

### QSelectionMode
| Value                  | Description                    |
|------------------------|--------------------------------|
| `NoSelection`          | No selection allowed (0)       |
| `SingleSelection`      | One item at a time (1)         |
| `MultiSelection`       | Multiple items (2)             |
| `ExtendedSelection`    | Extended with Ctrl/Shift (3)   |
| `ContiguousSelection`  | Contiguous range only (4)      |

### QSelectionBehavior
| Value           | Description            |
|-----------------|------------------------|
| `SelectItems`   | Select individual cells (0) |
| `SelectRows`    | Select whole rows (1)  |
| `SelectColumns` | Select whole columns (2)|

### QScrollHint
| Value              | Description                    |
|--------------------|--------------------------------|
| `EnsureVisible`    | Ensure the item is visible (0) |
| `PositionAtTop`    | Scroll to top edge (1)         |
| `PositionAtBottom` | Scroll to bottom edge (2)      |
| `PositionAtCenter` | Center the item (3)            |

### QToolButtonStyle
| Value                     | Description                     |
|---------------------------|---------------------------------|
| `ToolButtonIconOnly`      | Icon only (0)                   |
| `ToolButtonTextOnly`      | Text only (1)                   |
| `ToolButtonTextBesideIcon`| Text beside icon (2)            |
| `ToolButtonTextUnderIcon` | Text under icon (3)             |
| `ToolButtonFollowStyle`   | Follow system style (4)         |

### QComboBoxInsertPolicy
| Value                  | Description                   |
|------------------------|-------------------------------|
| `NoInsert`             | Do not insert (0)             |
| `InsertAtTop`          | Insert at top (1)             |
| `InsertAtCurrent`      | Replace current (2)           |
| `InsertAtBottom`       | Insert at bottom (3)          |
| `InsertAfterCurrent`   | After current item (4)        |
| `InsertBeforeCurrent`  | Before current item (5)       |
| `InsertAlphabetically` | Alphabetical order (6)        |

### QItemDataRole
| Value              | Numeric | Description                 |
|--------------------|---------|-----------------------------|
| `DisplayRole`      | 0       | Displayed text              |
| `DecorationRole`   | 1       | Icon or image               |
| `EditRole`         | 2       | Data for editing            |
| `ToolTipRole`      | 3       | Tooltip text                |
| `CheckStateRole`   | 10      | Checkbox state              |
| `UserRole`         | 0x0100  | Custom user data            |

### QLCDNumberMode
| Value     | Description             |
|-----------|-------------------------|
| `LcdHex`  | Hexadecimal (0)         |
| `LcdDec`  | Decimal (1)             |
| `LcdOct`  | Octal (2)               |
| `LcdBin`  | Binary (3)              |

### QTrayIconActivationReason
| Value             | Description              |
|-------------------|--------------------------|
| `TrayUnknown`     | Unknown (0)              |
| `TrayContext`     | Context menu (1)         |
| `TrayDoubleClick` | Double click (2)         |
| `TrayTrigger`     | Single click (3)         |
| `TrayMiddleClick` | Middle button click (4)  |

### QWizardOption (bitmask flags)
| Value                           | Description                                  |
|---------------------------------|----------------------------------------------|
| `IndependentPages`              | Pages are independent (0x001)                |
| `IgnoreSubTitles`               | Do not show subtitles (0x002)                |
| `NoDefaultButton`               | Next is not default (0x008)                  |
| `NoCancelButton`                | Hide Cancel button (0x200)                   |
| `HaveHelpButton`                | Show Help button (0x800)                     |
| `HaveCustomButton1/2/3`         | Custom buttons (0x2000–0x8000)               |

---

## QApplication

The application singleton. Create exactly once at program start.

### Creation and Lifecycle

```nim
proc newApp*(): App
  ## Create a QApplication (no command-line arguments)

proc appInstance*(): App
  ## Get the existing QApplication instance

proc exec*(a: App): cint
  ## Start the event loop; returns exit code

proc quit*(a: App)
  ## Exit the event loop

proc exit*(a: App, code: cint = 0)
  ## Exit with code

proc processEvents*(a: App)
  ## Process pending events without blocking
```

### Application Metadata

```nim
proc setAppName*(a: App, s: QString)
proc setOrgName*(a: App, s: QString)
proc setOrgDomain*(a: App, s: QString)
proc setAppVersion*(a: App, s: QString)
proc appName*(): string
```

### Appearance

```nim
proc setStyleSheet*(a: App, css: QString)
  ## Global QSS stylesheet for the entire application

proc setStyle*(a: App, styleName: string)
  ## Set style: "Fusion", "Windows", "WindowsVista", etc.

proc availableStyles*(): seq[string]
  ## List of available QStyleFactory styles

proc setFont*(a: App, family: string, size: int, bold: bool = false)
  ## Set the global application font
```

### Screen

```nim
proc primaryScreen*(): pointer
  ## Pointer to QScreen (opaque)

proc screenGeometry*(): tuple[x, y, w, h: int]
  ## Available geometry of the primary screen

proc screenDpi*(): int
  ## Logical DPI of the primary screen
```

### Example

```nim
let app = newApp()
app.setAppName(qs"MyApplication")
app.setStyle("Fusion")
let (_, _, sw, sh) = screenGeometry()
let win = newWin()
win.resize(800.cint, 600.cint)
win.centerOnScreen()
win.show()
discard app.exec()
```

---

## QWidget

Base class for all widgets. Type alias: `W = ptr QWidget`.

### Creation and Visibility

```nim
proc newWidget*(parent: W = nil): W
proc show*(w: W)
proc hide*(w: W)
proc close*(w: W)
proc raiseW*(w: W)    ## Raise widget above siblings
proc lower*(w: W)     ## Lower widget below siblings
proc update*(w: W)    ## Schedule a repaint
proc repaint*(w: W)   ## Immediate repaint
```

### Visibility and Enabled State

```nim
proc setVisible*(w: W, v: bool)
proc isVisible*(w: W): bool
proc setEnabled*(w: W, b: bool)
proc setDisabled*(w: W, b: bool)
proc isEnabled*(w: W): bool
```

### Geometry

```nim
proc resize*(w: W, width, height: cint)
proc move*(w: W, x, y: cint)
proc setFixedSize*(w: W, width, height: cint)
proc setFixedWidth*(w: W, width: cint)
proc setFixedHeight*(w: W, height: cint)
proc setMinSize*(w: W, width, height: cint)
proc setMaxSize*(w: W, width, height: cint)
proc setMinWidth*(w: W, v: cint)
proc setMinHeight*(w: W, v: cint)
proc width*(w: W): int
proc height*(w: W): int
proc x*(w: W): int
proc y*(w: W): int
proc geometry*(w: W): NimRect     ## tuple[x, y, w, h: int]
proc centerOnScreen*(w: W)        ## Center widget on screen
```

### Title and Tooltips

```nim
proc setWindowTitle*(w: W, s: QString)
proc windowTitle*(w: W): string
proc setToolTip*(w: W, s: QString)
proc setWhatsThis*(w: W, s: QString)
proc setStatusTip*(w: W, s: QString)
```

### Style and Appearance

```nim
proc setStyleSheet*(w: W, css: QString)
proc setContentsMargins*(w: W, l, t, r, b: cint)
proc setContentsMargins*(w: W, all: cint)
proc setSizePolicy*(w: W, h, v: cint)
proc setCursor*(w: W, shape: cint)
proc unsetCursor*(w: W)
```

### Layout

```nim
proc setLayout*(w: W, l: ptr QLayout)
proc setLayout*(w: W, l: VBox)
proc setLayout*(w: W, l: HBox)
proc setLayout*(w: W, l: Grid)
proc setLayout*(w: W, l: Form)
```

### Focus and Input

```nim
proc setFocus*(w: W)
proc clearFocus*(w: W)
proc hasFocus*(w: W): bool
proc setTabOrder*(first, second: W)
proc grabKeyboard*(w: W)
proc releaseKeyboard*(w: W)
proc grabMouse*(w: W)
proc releaseMouse*(w: W)
```

### Miscellaneous

```nim
proc setWindowFlags*(w: W, flags: cint)
proc setWindowModality*(w: W, modal: bool)
proc setAcceptDrops*(w: W, b: bool)
proc setAttribute*(w: W, attr: cint, on: bool = true)
proc setParent*(w, parent: W)
proc parentWidget*(w: W): W
```

### Upcast Helpers (to W)

```nim
proc asW*(w: Win): W
proc asW*(d: Dlg): W
proc asW*(b: Btn): W
proc asW*(b: Radio): W
proc asW*(b: ChkBox): W
proc asW*(l: Lbl): W
proc asW*(e: LE): W
proc asW*(e: TE): W
proc asW*(e: PTE): W
# ... and other widget types
```

---

## QMainWindow

The main application window. Type alias: `Win = ptr QMainWindow`.

```nim
proc newWin*(parent: W = nil): Win
proc show*(w: Win)
proc hide*(w: Win)
proc close*(w: Win)
proc setTitle*(w: Win, s: QString)
proc resize*(w: Win, width, height: cint)
proc setMinSize*(w: Win, width, height: cint)
proc centerOnScreen*(w: Win)

# Central widget
proc setCentral*(w: Win, c: W)
proc centralWidget*(w: Win): W

# Status bar
proc statusBar*(w: Win): StatusBar

# Menu bar
proc menuBar*(w: Win): MBar
proc setMenuBar*(w: Win, mb: MBar)
proc addMenu*(w: Win, title: QString): Menu

# Toolbars
proc addToolBar*(w: Win, title: QString): TB
proc addToolBarBreak*(w: Win)

# Dock widgets
proc addDock*(w: Win, area: cint, d: Dock)
proc removeDock*(w: Win, d: Dock)
proc splitDock*(w: Win, first, second: Dock, orientation: cint)
proc tabifyDock*(w: Win, first, second: Dock)
proc setDockNestingEnabled*(w: Win, b: bool)

# State persistence
proc saveState*(w: Win): string
proc restoreState*(w: Win, state: string): bool
proc setAnimated*(w: Win, b: bool)
proc setStyleSheet*(w: Win, css: QString)
proc setUnifiedTitleAndToolBarOnMac*(w: Win, b: bool)
```

**Dock areas** (as `cint`): `1`=Left, `2`=Right, `4`=Top, `8`=Bottom, `15`=All

---

## QStatusBar

```nim
proc showMsg*(sb: StatusBar, msg: QString, ms: cint = 0)
  ## Show message (ms=0 means permanent)
proc clearMsg*(sb: StatusBar)
proc addWidget*(sb: StatusBar, w: W, stretch: cint = 0)
proc addPermanentWidget*(sb: StatusBar, w: W, stretch: cint = 0)
proc removeWidget*(sb: StatusBar, w: W)
proc setStyleSheet*(sb: StatusBar, css: QString)
```

---

## QMenuBar

```nim
proc newMenuBar*(parent: W = nil): MBar
proc addMenu*(mb: MBar, title: QString): Menu
proc addMenu*(mb: MBar, m: Menu): Act
proc addAction*(mb: MBar, a: Act)
proc setVisible*(mb: MBar, v: bool)
proc setNativeMenuBar*(mb: MBar, b: bool)
```

---

## QMenu

```nim
proc newMenu*(title: QString, parent: W = nil): Menu
proc addSubMenu*(m: Menu, title: QString): Menu
proc addSubMenu*(m: Menu, sub: Menu): Act
proc newAction*(m: Menu, text: QString): Act
proc addAction*(m: Menu, a: Act)
proc removeAction*(m: Menu, a: Act)
proc addSep*(m: Menu)
proc clear*(m: Menu)
proc setTitle*(m: Menu, s: QString)
proc setEnabled*(m: Menu, b: bool)
proc setTearOffEnabled*(m: Menu, b: bool)
proc execAt*(m: Menu, x, y: cint): Act   ## Show context menu at point
proc popup*(m: Menu, x, y: cint)

# Signal
proc onMenuAboutToShow*(m: Menu, cb: CB, ud: pointer)
```

---

## QAction

```nim
proc newAction*(parent: W, text: QString): Act
proc newActionSep*(parent: W): Act           ## Separator

proc setText*(a: Act, s: QString)
proc setShortcut*(a: Act, keys: cstring)     ## "Ctrl+S", "F5", etc.
proc setShortcut*(a: Act, ks: QString)
proc setTip*(a: Act, s: QString)             ## Status tip
proc setToolTip*(a: Act, s: QString)
proc setEnabled*(a: Act, b: bool)
proc setCheckable*(a: Act, b: bool)
proc setChecked*(a: Act, b: bool)
proc isChecked*(a: Act): bool
proc isEnabled*(a: Act): bool
proc setSeparator*(a: Act, b: bool)
proc setIconText*(a: Act, s: QString)
proc setVisible*(a: Act, b: bool)

# Signals
proc onTriggered*(a: Act, cb: CB, ud: pointer)
proc onToggled*(a: Act, cb: CBBool, ud: pointer)
```

---

## QActionGroup

```nim
proc newActionGroup*(parent: W): ActGrp
proc addAction*(ag: ActGrp, a: Act): Act
proc removeAction*(ag: ActGrp, a: Act)
proc setExclusive*(ag: ActGrp, b: bool)
proc setEnabled*(ag: ActGrp, b: bool)
proc checkedAction*(ag: ActGrp): Act

proc onActionGroupTriggered*(ag: ActGrp,
    cb: proc(a: Act, ud: pointer) {.cdecl.}, ud: pointer)
```

---

## QToolBar

```nim
proc newToolBar*(title: QString, parent: Win = nil): TB
proc addAction*(tb: TB, a: Act)
proc addWidget*(tb: TB, w: W): Act
proc addSep*(tb: TB): Act
proc clear*(tb: TB)
proc setMovable*(tb: TB, b: bool)
proc setFloatable*(tb: TB, b: bool)
proc setIconSize*(tb: TB, w, h: cint)
proc setToolButtonStyle*(tb: TB, style: cint)  ## See QToolButtonStyle
proc setOrientation*(tb: TB, o: cint)          ## 1=Horizontal, 2=Vertical
proc setAllowedAreas*(tb: TB, areas: cint)
proc setStyleSheet*(tb: TB, css: QString)
```

---

## QLabel

```nim
proc newLabel*(text: QString, parent: W = nil): Lbl
proc newLabel*(parent: W = nil): Lbl
proc setText*(l: Lbl, s: QString)
proc text*(l: Lbl): string
proc setAlignment*(l: Lbl, a: cint)        ## Qt::Alignment flags
proc setWordWrap*(l: Lbl, b: bool)
proc setOpenExternalLinks*(l: Lbl, b: bool)
proc setTextFormat*(l: Lbl, f: cint)       ## 0=PlainText, 1=RichText, 2=AutoText
proc setScaledContents*(l: Lbl, b: bool)
proc setIndent*(l: Lbl, n: cint)
proc setMargin*(l: Lbl, n: cint)
proc setStyleSheet*(l: Lbl, css: QString)
proc setMinSize*(l: Lbl, w, h: cint)
proc setFixedWidth*(l: Lbl, w: cint)

# Signal
proc onLabelLinkActivated*(l: Lbl, cb: CBStr, ud: pointer)
```

---

## QPushButton

```nim
proc newBtn*(text: QString, parent: W = nil): Btn
proc newBtn*(parent: W = nil): Btn
proc setText*(b: Btn, s: QString)
proc text*(b: Btn): string
proc setEnabled*(b: Btn, v: bool)
proc setCheckable*(b: Btn, v: bool)
proc setChecked*(b: Btn, v: bool)
proc isChecked*(b: Btn): bool
proc setDefault*(b: Btn, v: bool)        ## Default button in a dialog
proc setAutoDefault*(b: Btn, v: bool)
proc setFlat*(b: Btn, v: bool)
proc setStyleSheet*(b: Btn, css: QString)
proc setToolTip*(b: Btn, s: QString)
proc setMinSize*(b: Btn, w, h: cint)
proc setFixedSize*(b: Btn, w, h: cint)
proc click*(b: Btn)
proc animateClick*(b: Btn)

# Signals
proc onClicked*(b: Btn, cb: CB, ud: pointer)
proc onToggled*(b: Btn, cb: CBBool, ud: pointer)
proc onPressed*(b: Btn, cb: CB, ud: pointer)
proc onReleased*(b: Btn, cb: CB, ud: pointer)
```

---

## QToolButton

```nim
proc newToolButton*(parent: W = nil): TBtn
proc setDefaultAction*(tb: TBtn, a: Act)
proc setPopupMode*(tb: TBtn, mode: cint)    ## 0=DelayedPopup, 1=MenuButtonPopup, 2=InstantPopup
proc setMenu*(tb: TBtn, m: Menu)
proc setAutoRaise*(tb: TBtn, b: bool)
proc setToolButtonStyle*(tb: TBtn, style: cint)
proc setArrowType*(tb: TBtn, t: cint)       ## 0=NoArrow, 1=Up, 2=Down, 3=Left, 4=Right

# Signal
proc onTBClicked*(tb: TBtn, cb: CB, ud: pointer)
```

---

## QRadioButton

```nim
proc newRadio*(text: QString, parent: W = nil): Radio
proc setText*(r: Radio, s: QString)
proc isChecked*(r: Radio): bool
proc setChecked*(r: Radio, b: bool)
proc setEnabled*(r: Radio, b: bool)
proc setStyleSheet*(r: Radio, css: QString)

# Signal
proc onRadioToggled*(r: Radio, cb: CBBool, ud: pointer)
```

---

## QCheckBox

```nim
proc newCheckBox*(text: QString, parent: W = nil): ChkBox
proc setText*(c: ChkBox, s: QString)
proc isChecked*(c: ChkBox): bool
proc setChecked*(c: ChkBox, b: bool)
proc setTristate*(c: ChkBox, b: bool)     ## Enable three-state mode
proc checkState*(c: ChkBox): int          ## 0=Unchecked, 1=Partial, 2=Checked
proc setCheckState*(c: ChkBox, s: cint)
proc setEnabled*(c: ChkBox, b: bool)
proc setStyleSheet*(c: ChkBox, css: QString)

# Signals
proc onCheckBoxToggled*(c: ChkBox, cb: CBBool, ud: pointer)
proc onCheckStateChanged*(c: ChkBox, cb: CBInt, ud: pointer)
```

---

## QButtonGroup

Logical grouping of buttons (no visual representation).

```nim
proc newButtonGroup*(parent: W = nil): BtnGrp
proc addButton*(bg: BtnGrp, b: Btn, id: cint = -1)
proc addButton*(bg: BtnGrp, b: Radio, id: cint = -1)
proc addButton*(bg: BtnGrp, b: ChkBox, id: cint = -1)
proc removeButton*(bg: BtnGrp, b: Btn)
proc setExclusive*(bg: BtnGrp, b: bool)
proc checkedId*(bg: BtnGrp): int
proc setId*(bg: BtnGrp, b: Btn, id: cint)

# Signal
proc onBtnGroupIdClicked*(bg: BtnGrp, cb: CBInt, ud: pointer)
```

---

## QCommandLinkButton

```nim
proc newCmdBtn*(text, desc: QString, parent: W = nil): CmdBtn
proc setDescription*(b: CmdBtn, s: QString)
proc description*(b: CmdBtn): string

# Signal
proc onCmdClicked*(b: CmdBtn, cb: CB, ud: pointer)
```

---

## QLineEdit

```nim
proc newLineEdit*(text: QString, parent: W = nil): LE
proc newLineEdit*(parent: W = nil): LE
proc text*(e: LE): string
proc setText*(e: LE, s: QString)
proc setPlaceholder*(e: LE, s: QString)
proc setReadOnly*(e: LE, b: bool)
proc isReadOnly*(e: LE): bool
proc setMaxLength*(e: LE, n: cint)
proc setEchoMode*(e: LE, mode: cint)        ## See QLineEditEchoMode
proc setAlignment*(e: LE, a: cint)
proc clear*(e: LE)
proc selectAll*(e: LE)
proc setClearButtonEnabled*(e: LE, b: bool)
proc setStyleSheet*(e: LE, css: QString)
proc setToolTip*(e: LE, s: QString)
proc setInputMask*(e: LE, mask: QString)    ## e.g. "000.000.000.000"
proc hasAcceptableInput*(e: LE): bool
proc setCompleter*(e: LE, c: Compltr)

# Signals
proc onTextChanged*(e: LE, cb: CBStr, ud: pointer)
proc onTextEdited*(e: LE, cb: CBStr, ud: pointer)   ## User input only
proc onReturnPressed*(e: LE, cb: CB, ud: pointer)
proc onEditingFinished*(e: LE, cb: CB, ud: pointer)
```

---

## QTextEdit

Multi-line editor with HTML/Rich Text support.

```nim
proc newTextEdit*(parent: W = nil): TE
proc newTextEdit*(text: QString, parent: W = nil): TE
proc text*(e: TE): string          ## Get as plain text
proc html*(e: TE): string          ## Get as HTML
proc setText*(e: TE, s: QString)   ## Set plain text
proc setHtml*(e: TE, s: QString)
proc append*(e: TE, s: QString)
proc clear*(e: TE)
proc setReadOnly*(e: TE, b: bool)
proc setPlaceholder*(e: TE, s: QString)
proc setWordWrap*(e: TE, mode: cint)
proc setTabStop*(e: TE, distance: cint)
proc setUndoRedoEnabled*(e: TE, b: bool)
proc setAcceptRichText*(e: TE, b: bool)
proc setStyleSheet*(e: TE, css: QString)
proc scrollToBottom*(e: TE)
proc moveCursorEnd*(e: TE)
proc selectAll*(e: TE)
proc setLineWrapMode*(e: TE, mode: cint)      ## 0=NoWrap, 1=WidgetWidth
proc setMaximumBlockCount*(e: TE, n: cint)
proc zoomIn*(e: TE, range: cint = 1)
proc zoomOut*(e: TE, range: cint = 1)

# Signals
proc onTextChanged*(e: TE, cb: CB, ud: pointer)
proc onCursorPositionChanged*(e: TE, cb: CB, ud: pointer)
```

---

## QPlainTextEdit

High-performance multi-line editor (plain text only).

```nim
proc newPlainTextEdit*(parent: W = nil): PTE
proc newPlainTextEdit*(text: QString, parent: W = nil): PTE
proc text*(e: PTE): string
proc setText*(e: PTE, s: QString)
proc appendLine*(e: PTE, s: QString)
proc clear*(e: PTE)
proc setReadOnly*(e: PTE, b: bool)
proc setPlaceholder*(e: PTE, s: QString)
proc setTabStop*(e: PTE, distance: cint)
proc setMaxBlockCount*(e: PTE, n: cint)      ## Limit lines (log buffer)
proc setLineWrapMode*(e: PTE, mode: cint)
proc setStyleSheet*(e: PTE, css: QString)
proc setUndoRedoEnabled*(e: PTE, b: bool)
proc blockCount*(e: PTE): int
proc centerCursor*(e: PTE)
proc scrollToBottom*(e: PTE)

# Signal
proc onPTETextChanged*(e: PTE, cb: CB, ud: pointer)
```

---

## QTextBrowser

HTML document browser with hyperlink navigation.

```nim
proc newTextBrowser*(parent: W = nil): TBrw
proc setHtml*(b: TBrw, s: QString)
proc setSource*(b: TBrw, url: QString)
proc setSearchPaths*(b: TBrw, paths: seq[string])
proc setOpenLinks*(b: TBrw, v: bool)
proc setOpenExternalLinks*(b: TBrw, v: bool)
proc backward*(b: TBrw)
proc forward*(b: TBrw)
proc home*(b: TBrw)

# Signal
proc onTBrwAnchorClicked*(b: TBrw, cb: CBStr, ud: pointer)
```

---

## QSpinBox / QDoubleSpinBox

### QSpinBox (integer)

```nim
proc newSpinBox*(parent: W = nil): Spin
proc value*(s: Spin): int
proc setValue*(s: Spin, v: cint)
proc setRange*(s: Spin, lo, hi: cint)
proc setMinimum*(s: Spin, v: cint)
proc setMaximum*(s: Spin, v: cint)
proc setSingleStep*(s: Spin, v: cint)
proc setPrefix*(s: Spin, p: QString)
proc setSuffix*(s: Spin, p: QString)
proc setWrapping*(s: Spin, b: bool)
proc setReadOnly*(s: Spin, b: bool)
proc setStyleSheet*(s: Spin, css: QString)

# Signal
proc onSpinValueChanged*(s: Spin, cb: CBInt, ud: pointer)
```

### QDoubleSpinBox (floating point)

```nim
proc newDoubleSpinBox*(parent: W = nil): DSpin
proc value*(s: DSpin): float64
proc setValue*(s: DSpin, v: cdouble)
proc setRange*(s: DSpin, lo, hi: cdouble)
proc setDecimals*(s: DSpin, d: cint)
proc setSingleStep*(s: DSpin, v: cdouble)
proc setPrefix*(s: DSpin, p: QString)
proc setSuffix*(s: DSpin, p: QString)
proc setStyleSheet*(s: DSpin, css: QString)

# Signal
proc onDSpinValueChanged*(s: DSpin,
    cb: proc(v: cdouble, ud: pointer) {.cdecl.}, ud: pointer)
```

---

## QSlider / QScrollBar / QDial

### QSlider

```nim
proc newSlider*(orientation: cint, parent: W = nil): Slider
  ## orientation: 1=Horizontal, 2=Vertical
proc value*(s: Slider): int
proc setValue*(s: Slider, v: cint)
proc setRange*(s: Slider, lo, hi: cint)
proc setMinimum*(s: Slider, v: cint)
proc setMaximum*(s: Slider, v: cint)
proc setSingleStep*(s: Slider, v: cint)
proc setPageStep*(s: Slider, v: cint)
proc setTickInterval*(s: Slider, v: cint)
proc setTickPosition*(s: Slider, pos: cint)  ## 0=NoTicks, 1=BothSides, 2=Above, 3=Below
proc setInvertedAppearance*(s: Slider, b: bool)
proc setTracking*(s: Slider, b: bool)
proc setStyleSheet*(s: Slider, css: QString)

# Signals
proc onSliderValueChanged*(s: Slider, cb: CBInt, ud: pointer)
proc onSliderMoved*(s: Slider, cb: CBInt, ud: pointer)
```

### QScrollBar

```nim
proc newScrollBar*(orientation: cint, parent: W = nil): SBar
proc value*(s: SBar): int
proc setValue*(s: SBar, v: cint)
proc setRange*(s: SBar, lo, hi: cint)
proc setPageStep*(s: SBar, v: cint)
proc setSingleStep*(s: SBar, v: cint)
proc setStyleSheet*(s: SBar, css: QString)

# Signal
proc onSBarValueChanged*(s: SBar, cb: CBInt, ud: pointer)
```

### QDial

```nim
proc newDial*(parent: W = nil): Dial
proc value*(d: Dial): int
proc setValue*(d: Dial, v: cint)
proc setRange*(d: Dial, lo, hi: cint)
proc setNotchesVisible*(d: Dial, b: bool)
proc setWrapping*(d: Dial, b: bool)
proc setNotchTarget*(d: Dial, v: cdouble)
proc setStyleSheet*(d: Dial, css: QString)

# Signal
proc onDialValueChanged*(d: Dial, cb: CBInt, ud: pointer)
```

---

## QProgressBar

```nim
proc newProgressBar*(parent: W = nil): Prog
proc setValue*(p: Prog, v: cint)
proc value*(p: Prog): int
proc setRange*(p: Prog, lo, hi: cint)
proc setMinimum*(p: Prog, v: cint)
proc setMaximum*(p: Prog, v: cint)
proc setTextVisible*(p: Prog, b: bool)
proc setFormat*(p: Prog, fmt: QString)      ## "%p%" = percent, "%v" = value
proc setOrientation*(p: Prog, o: cint)     ## 1=Horizontal, 2=Vertical
proc setInvertedAppearance*(p: Prog, b: bool)
proc setStyleSheet*(p: Prog, css: QString)
proc reset*(p: Prog)
```

> **Indeterminate/busy state** (animated): `setRange(0, 0)`

---

## QComboBox / QFontComboBox

### QComboBox

```nim
proc newComboBox*(parent: W = nil): Combo
proc addItem*(c: Combo, text: QString)
proc addItem*(c: Combo, text: QString, userData: QVariant)
proc addItems*(c: Combo, items: seq[string])
proc insertItem*(c: Combo, index: cint, text: QString)
proc removeItem*(c: Combo, index: cint)
proc clear*(c: Combo)
proc currentIndex*(c: Combo): int
proc setCurrentIndex*(c: Combo, i: cint)
proc currentText*(c: Combo): string
proc setCurrentText*(c: Combo, s: QString)
proc itemText*(c: Combo, i: cint): string
proc count*(c: Combo): int
proc findText*(c: Combo, text: QString): int  ## -1 if not found
proc setEditable*(c: Combo, b: bool)
proc setMaxVisibleItems*(c: Combo, n: cint)
proc setInsertPolicy*(c: Combo, p: cint)       ## See QComboBoxInsertPolicy
proc setMaxCount*(c: Combo, n: cint)
proc setDuplicatesEnabled*(c: Combo, b: bool)
proc setStyleSheet*(c: Combo, css: QString)
proc setCompleter*(c: Combo, comp: Compltr)

# Signals
proc onComboCurrentIndexChanged*(c: Combo, cb: CBInt, ud: pointer)
proc onComboTextActivated*(c: Combo, cb: CBStr, ud: pointer)
```

### QFontComboBox

```nim
proc newFontComboBox*(parent: W = nil): FCombo
proc currentFont*(fc: FCombo): string      ## Returns font family name
proc setCurrentFont*(fc: FCombo, family: string)
```

---

## QLCDNumber

```nim
proc newLCDNumber*(digits: cint = 5, parent: W = nil): LCD
proc display*(l: LCD, v: cdouble)
proc display*(l: LCD, v: cint)
proc display*(l: LCD, s: cstring)
proc setDigitCount*(l: LCD, n: cint)
proc setMode*(l: LCD, m: cint)               ## See QLCDNumberMode
proc setSegmentStyle*(l: LCD, s: cint)      ## 0=Outline, 1=Filled, 2=Flat
proc value*(l: LCD): float64
proc setStyleSheet*(l: LCD, css: QString)
```

---

## QGroupBox

```nim
proc newGroupBox*(title: QString, parent: W = nil): Grp
proc setTitle*(g: Grp, s: QString)
proc title*(g: Grp): string
proc setCheckable*(g: Grp, b: bool)         ## Enable checkbox in title
proc isChecked*(g: Grp): bool
proc setChecked*(g: Grp, b: bool)
proc setFlat*(g: Grp, b: bool)
proc setLayout*(g: Grp, l: VBox)
proc setLayout*(g: Grp, l: HBox)
proc setLayout*(g: Grp, l: Grid)
proc setLayout*(g: Grp, l: Form)
proc setStyleSheet*(g: Grp, css: QString)
proc setAlignment*(g: Grp, a: cint)

# Signal
proc onGroupBoxToggled*(g: Grp, cb: CBBool, ud: pointer)
```

---

## QFrame

```nim
proc newFrame*(parent: W = nil): Frm
proc setFrameShape*(f: Frm, s: cint)    ## 0=NoFrame, 1=Box, 2=Panel, 4=HLine, 5=VLine
proc setFrameShadow*(f: Frm, s: cint)  ## 16=Plain, 32=Raised, 48=Sunken
proc setLineWidth*(f: Frm, w: cint)
proc setMidLineWidth*(f: Frm, w: cint)
proc setLayout*(f: Frm, l: VBox)
proc setLayout*(f: Frm, l: HBox)
proc setLayout*(f: Frm, l: Grid)
proc setStyleSheet*(f: Frm, css: QString)
proc setMinH*(f: Frm, h: cint)
```

---

## QStackedWidget

```nim
proc newStackedWidget*(parent: W = nil): Stack
proc addPage*(s: Stack, w: W): int           ## Returns page index
proc insertPage*(s: Stack, index: cint, w: W): int
proc removePage*(s: Stack, w: W)
proc currentIndex*(s: Stack): int
proc setCurrentIndex*(s: Stack, i: cint)
proc setCurrentWidget*(s: Stack, w: W)
proc currentWidget*(s: Stack): W
proc count*(s: Stack): int

# Signal
proc onStackCurrentChanged*(s: Stack, cb: CBInt, ud: pointer)
```

---

## QTabWidget

```nim
proc newTabWidget*(parent: W = nil): Tab
proc addTab*(t: Tab, w: W, label: QString): int
proc insertTab*(t: Tab, index: cint, w: W, label: QString): int
proc removeTab*(t: Tab, index: cint)
proc currentIndex*(t: Tab): int
proc setCurrentIndex*(t: Tab, i: cint)
proc currentWidget*(t: Tab): W
proc setCurrentWidget*(t: Tab, w: W)
proc count*(t: Tab): int
proc setTabText*(t: Tab, i: cint, s: QString)
proc tabText*(t: Tab, i: cint): string
proc setTabEnabled*(t: Tab, i: cint, b: bool)
proc setTabVisible*(t: Tab, i: cint, b: bool)
proc setTabToolTip*(t: Tab, i: cint, s: QString)
proc setTabPosition*(t: Tab, pos: cint)        ## See QTabPosition
proc setTabShape*(t: Tab, s: cint)             ## See QTabShape
proc setMovable*(t: Tab, b: bool)
proc setDocumentMode*(t: Tab, b: bool)
proc setTabsClosable*(t: Tab, b: bool)
proc setUsesScrollButtons*(t: Tab, b: bool)
proc setElideMode*(t: Tab, mode: cint)
proc setStyleSheet*(t: Tab, css: QString)
proc widget*(t: Tab, i: cint): W
proc indexOf*(t: Tab, w: W): int

# Signals
proc onTabCurrentChanged*(t: Tab, cb: CBInt, ud: pointer)
proc onTabCloseRequested*(t: Tab, cb: CBInt, ud: pointer)
```

---

## QTabBar

Standalone tab bar (without managed content).

```nim
proc newTabBar*(parent: W = nil): TabBar
proc addTab*(tb: TabBar, text: QString): int
proc removeTab*(tb: TabBar, idx: cint)
proc currentIndex*(tb: TabBar): int
proc setCurrentIndex*(tb: TabBar, idx: cint)
proc tabText*(tb: TabBar, idx: cint): string
proc setTabText*(tb: TabBar, idx: cint, s: QString)
proc setMovable*(tb: TabBar, b: bool)
proc setTabsClosable*(tb: TabBar, b: bool)
proc count*(tb: TabBar): int
proc setStyleSheet*(tb: TabBar, css: QString)

# Signals
proc onTabBarCurrentChanged*(tb: TabBar, cb: CBInt, ud: pointer)
proc onTabBarCloseRequested*(tb: TabBar, cb: CBInt, ud: pointer)
```

---

## QSplitter

```nim
proc newSplitter*(orientation: cint, parent: W = nil): Splt
proc newHSplitter*(parent: W = nil): Splt     ## Horizontal
proc newVSplitter*(parent: W = nil): Splt     ## Vertical
proc addWidget*(sp: Splt, w: W)
proc insertWidget*(sp: Splt, index: cint, w: W)
proc setCollapsible*(sp: Splt, index: cint, b: bool)
proc setHandleWidth*(sp: Splt, w: cint)
proc setChildrenCollapsible*(sp: Splt, b: bool)
proc setOpaqueResize*(sp: Splt, b: bool)
proc setSizes*(sp: Splt, sizes: seq[int])      ## Up to 4 sections
proc count*(sp: Splt): int
proc setStyleSheet*(sp: Splt, css: QString)

# Signal
proc onSplitterMoved*(sp: Splt,
    cb: proc(pos, index: cint, ud: pointer) {.cdecl.}, ud: pointer)
```

---

## QScrollArea

```nim
proc newScrollArea*(parent: W = nil): Scroll
proc setWidget*(s: Scroll, w: W)
proc widget*(s: Scroll): W
proc setResizable*(s: Scroll, b: bool)             ## setWidgetResizable
proc setAlignment*(s: Scroll, a: cint)
proc setHorizontalScrollBarPolicy*(s: Scroll, p: cint)  ## 0=AsNeeded, 1=AlwaysOff, 2=AlwaysOn
proc setVerticalScrollBarPolicy*(s: Scroll, p: cint)
proc ensureVisible*(s: Scroll, x, y: cint; xm: cint = 50; ym: cint = 50)
proc setStyleSheet*(s: Scroll, css: QString)
```

---

## QDockWidget

```nim
proc newDockWidget*(title: QString, parent: Win): Dock
proc newDockWidget*(title: QString): Dock
proc setWidget*(d: Dock, w: W)
proc dockWidget*(d: Dock): W
proc setAllowedAreas*(d: Dock, areas: cint)    ## 1=Left, 2=Right, 4=Top, 8=Bottom
proc setFeatures*(d: Dock, f: cint)            ## Closable=1, Movable=2, Floatable=4
proc setFloating*(d: Dock, b: bool)
proc isFloating*(d: Dock): bool
proc setTitleBarWidget*(d: Dock, w: W)
proc setWindowTitle*(d: Dock, s: QString)
proc setStyleSheet*(d: Dock, css: QString)

# Signals
proc onDockVisibilityChanged*(d: Dock, cb: CBBool, ud: pointer)
proc onDockTopLevelChanged*(d: Dock, cb: CBBool, ud: pointer)
```

---

## QMdiArea / QMdiSubWindow

### QMdiArea

```nim
proc newMdiArea*(parent: W = nil): Mdi
proc addSubWindow*(m: Mdi, w: W): MdiSub
proc activateNextSubWindow*(m: Mdi)
proc activatePreviousSubWindow*(m: Mdi)
proc tileSubWindows*(m: Mdi)
proc cascadeSubWindows*(m: Mdi)
proc closeAllSubWindows*(m: Mdi)
proc setViewMode*(m: Mdi, mode: cint)    ## 0=SubWindowView, 1=TabbedView
proc setTabsMovable*(m: Mdi, b: bool)
proc setTabsClosable*(m: Mdi, b: bool)
proc currentSubWindow*(m: Mdi): MdiSub
proc setStyleSheet*(m: Mdi, css: QString)
```

### QMdiSubWindow

```nim
proc show*(sub: MdiSub)
proc showMaximized*(sub: MdiSub)
proc showMinimized*(sub: MdiSub)
proc showNormal*(sub: MdiSub)
proc close*(sub: MdiSub)
proc setWidget*(sub: MdiSub, w: W)
proc widget*(sub: MdiSub): W
proc setWindowTitle*(sub: MdiSub, s: QString)
proc resize*(sub: MdiSub, w, h: cint)
proc move*(sub: MdiSub, x, y: cint)
```

---

## QListWidget / QListWidgetItem

### QListWidget

```nim
proc newListWidget*(parent: W = nil): LW
proc addItem*(lw: LW, text: QString)
proc addItem*(lw: LW, item: LWI)
proc addItems*(lw: LW, items: seq[string])
proc insertItem*(lw: LW, row: cint, text: QString)
proc removeItemAt*(lw: LW, row: cint)
proc takeItem*(lw: LW, row: cint): LWI
proc clear*(lw: LW)
proc count*(lw: LW): int
proc currentRow*(lw: LW): int
proc setCurrentRow*(lw: LW, row: cint)
proc currentItem*(lw: LW): LWI
proc item*(lw: LW, row: cint): LWI
proc itemText*(lw: LW, row: cint): string
proc setItemText*(lw: LW, row: cint, s: QString)
proc setSelectionMode*(lw: LW, mode: cint)       ## See QSelectionMode
proc setSelectionBehavior*(lw: LW, b: cint)
proc setAlternatingRowColors*(lw: LW, b: bool)
proc setSortingEnabled*(lw: LW, b: bool)
proc sortItems*(lw: LW, order: cint = 0)         ## 0=Ascending, 1=Descending
proc setDragDropMode*(lw: LW, mode: cint)
proc setWordWrap*(lw: LW, b: bool)
proc setSpacing*(lw: LW, s: cint)
proc setGridSize*(lw: LW, w, h: cint)
proc setIconSize*(lw: LW, w, h: cint)
proc setViewMode*(lw: LW, mode: cint)            ## 0=ListMode, 1=IconMode
proc setStyleSheet*(lw: LW, css: QString)
proc scrollToItem*(lw: LW, item: LWI, hint: cint = 0)
proc scrollToTop*(lw: LW)
proc scrollToBottom*(lw: LW)

# Signals
proc onLWCurrentRowChanged*(lw: LW, cb: CBInt, ud: pointer)
proc onLWItemClicked*(lw: LW, cb: proc(item: LWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onLWItemDoubleClicked*(lw: LW, cb: proc(item: LWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onLWItemChanged*(lw: LW, cb: proc(item: LWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onLWSelectionChanged*(lw: LW, cb: CB, ud: pointer)
```

### QListWidgetItem

```nim
proc newLWI*(text: QString): LWI
proc newLWI*(): LWI
proc lwiText*(i: LWI): string
proc lwiSetText*(i: LWI, s: QString)
proc lwiSetCheckState*(i: LWI, s: cint)      ## 0=Unchecked, 2=Checked
proc lwiCheckState*(i: LWI): int
proc lwiSetData*(i: LWI, role: cint, v: QVariant)
proc lwiData*(i: LWI, role: cint): QVariant
proc lwiSetToolTip*(i: LWI, s: QString)
proc lwiSetSelected*(i: LWI, b: bool)
proc lwiIsSelected*(i: LWI): bool
proc lwiSetFlags*(i: LWI, f: cint)           ## Qt::ItemFlags
```

---

## QTreeWidget / QTreeWidgetItem

### QTreeWidget

```nim
proc newTreeWidget*(parent: W = nil): TW
proc setColCount*(t: TW, n: cint)
proc colCount*(t: TW): int
proc setHeaders*(t: TW, labels: openArray[string])
proc setHeaderHidden*(t: TW, b: bool)
proc addTopItem*(t: TW, texts: openArray[string]): TWI
proc addTopItem*(t: TW, text: string): TWI
proc topLevelItemCount*(t: TW): int
proc topLevelItem*(t: TW, i: cint): TWI
proc currentItem*(t: TW): TWI
proc setCurrentItem*(t: TW, item: TWI)
proc invisibleRootItem*(t: TW): TWI
proc scrollToItem*(t: TW, item: TWI, hint: cint = 0)
proc expandAll*(t: TW)
proc collapseAll*(t: TW)
proc clear*(t: TW)
proc setAltColors*(t: TW, b: bool)
proc setAnimated*(t: TW, b: bool)
proc resizeCol*(t: TW, col: cint)
proc setColumnWidth*(t: TW, col, width: cint)
proc setColumnHidden*(t: TW, col: cint, hide: bool)
proc setSortingEnabled*(t: TW, b: bool)
proc sortByColumn*(t: TW, col: cint, order: cint = 0)
proc setSelectionMode*(t: TW, mode: cint)
proc setSelectionBehavior*(t: TW, b: cint)
proc setRootIsDecorated*(t: TW, b: bool)
proc setItemsExpandable*(t: TW, b: bool)
proc setDragDropMode*(t: TW, mode: cint)
proc setDragEnabled*(t: TW, b: bool)
proc setStyleSheet*(t: TW, css: QString)

# Signals
proc onTWCurrentItemChanged*(t: TW,
    cb: proc(cur, prev: TWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onTWItemClicked*(t: TW,
    cb: proc(item: TWI, col: cint, ud: pointer) {.cdecl.}, ud: pointer)
proc onTWItemDoubleClicked*(t: TW,
    cb: proc(item: TWI, col: cint, ud: pointer) {.cdecl.}, ud: pointer)
proc onTWItemExpanded*(t: TW, cb: proc(item: TWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onTWItemCollapsed*(t: TW, cb: proc(item: TWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onTWSelectionChanged*(t: TW, cb: CB, ud: pointer)
```

### QTreeWidgetItem

```nim
proc addChild*(parent: TWI, texts: openArray[string]): TWI
proc addChild*(parent: TWI, c0: string, c1: string = ""): TWI
proc twiText*(i: TWI, col: cint = 0): string
proc twiSetText*(i: TWI, col: cint, s: QString)
proc twiSetCheckState*(i: TWI, col: cint, s: cint)
proc twiCheckState*(i: TWI, col: cint): int
proc twiSetData*(i: TWI, col, role: cint, v: QVariant)
proc twiSetFlags*(i: TWI, f: cint)
proc twiSetExpanded*(i: TWI, b: bool)
proc twiIsExpanded*(i: TWI): bool
proc twiChildCount*(i: TWI): int
proc twiChild*(i: TWI, idx: cint): TWI
proc twiParent*(i: TWI): TWI
proc twiSetHidden*(i: TWI, b: bool)
proc twiSetSelected*(i: TWI, b: bool)
proc twiSetToolTip*(i: TWI, col: cint, s: QString)
proc twiAddChild*(parent: TWI, child: TWI)
```

---

## QTableWidget / QTableWidgetItem

### QTableWidget

```nim
proc newTableWidget*(rows, cols: cint, parent: W = nil): TblW
proc newTableWidget*(parent: W = nil): TblW
proc setRowCount*(t: TblW, n: cint)
proc setColumnCount*(t: TblW, n: cint)
proc rowCount*(t: TblW): int
proc columnCount*(t: TblW): int
proc setItem*(t: TblW, row, col: cint, item: TblWI)
proc item*(t: TblW, row, col: cint): TblWI
proc takeItem*(t: TblW, row, col: cint): TblWI
proc itemText*(t: TblW, row, col: cint): string
proc setItemText*(t: TblW, row, col: cint, s: QString)
proc setCellWidget*(t: TblW, row, col: cint, w: W)
proc cellWidget*(t: TblW, row, col: cint): W
proc removeCellWidget*(t: TblW, row, col: cint)
proc currentRow*(t: TblW): int
proc currentColumn*(t: TblW): int
proc setCurrentCell*(t: TblW, row, col: cint)
proc insertRow*(t: TblW, row: cint)
proc insertColumn*(t: TblW, col: cint)
proc removeRow*(t: TblW, row: cint)
proc removeColumn*(t: TblW, col: cint)
proc clear*(t: TblW)
proc clearContents*(t: TblW)
proc setHorizontalHeaders*(t: TblW, labels: openArray[string])
proc setVerticalHeaders*(t: TblW, labels: openArray[string])
proc setSelectionMode*(t: TblW, mode: cint)
proc setSelectionBehavior*(t: TblW, b: cint)
proc setAlternatingRowColors*(t: TblW, b: bool)
proc setSortingEnabled*(t: TblW, b: bool)
proc sortByColumn*(t: TblW, col: cint, order: cint = 0)
proc setWordWrap*(t: TblW, b: bool)
proc setShowGrid*(t: TblW, b: bool)
proc setGridStyle*(t: TblW, s: cint)
proc setSpan*(t: TblW, row, col, rowSpan, colSpan: cint)
proc setRowHeight*(t: TblW, row, height: cint)
proc setColumnWidth*(t: TblW, col, width: cint)
proc setColumnHidden*(t: TblW, col: cint, hide: bool)
proc setRowHidden*(t: TblW, row: cint, hide: bool)
proc resizeColumnsToContents*(t: TblW)
proc resizeRowsToContents*(t: TblW)
proc horizontalHeader*(t: TblW): HdrView
proc verticalHeader*(t: TblW): HdrView
proc setStyleSheet*(t: TblW, css: QString)
proc setEditTriggers*(t: TblW, triggers: cint)

# Signals
proc onTblCurrentCellChanged*(t: TblW,
    cb: proc(row, col, prevRow, prevCol: cint, ud: pointer) {.cdecl.}, ud: pointer)
proc onTblItemClicked*(t: TblW, cb: proc(item: TblWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onTblItemDoubleClicked*(t: TblW, cb: proc(item: TblWI, ud: pointer) {.cdecl.}, ud: pointer)
proc onTblSelectionChanged*(t: TblW, cb: CB, ud: pointer)
```

### QTableWidgetItem

```nim
proc newTblWI*(text: QString): TblWI
proc newTblWI*(): TblWI
proc twText*(i: TblWI): string
proc twSetText*(i: TblWI, s: QString)
proc twSetData*(i: TblWI, role: cint, v: QVariant)
proc twSetFlags*(i: TblWI, f: cint)
proc twSetCheckState*(i: TblWI, s: cint)
proc twCheckState*(i: TblWI): int
proc twSetToolTip*(i: TblWI, s: QString)
proc twSetSelected*(i: TblWI, b: bool)
proc twRow*(i: TblWI): int
proc twColumn*(i: TblWI): int
proc twSetTextAlignment*(i: TblWI, a: cint)
```

---

## QHeaderView

```nim
proc hdrSetResizeMode*(h: HdrView, section: cint, mode: cint)
  ## mode: 0=Interactive, 1=Fixed, 2=Stretch, 3=ResizeToContents
proc hdrSetResizeModeAll*(h: HdrView, mode: cint)
proc hdrSetStretchLastSection*(h: HdrView, b: bool)
proc hdrSetMovable*(h: HdrView, b: bool)
proc hdrSetClickable*(h: HdrView, b: bool)
proc hdrSetHighlightSections*(h: HdrView, b: bool)
proc hdrSetDefaultSectionSize*(h: HdrView, size: cint)
proc hdrSetMinimumSectionSize*(h: HdrView, size: cint)
proc hdrHideSection*(h: HdrView, section: cint)
proc hdrShowSection*(h: HdrView, section: cint)
proc hdrSectionCount*(h: HdrView): int
proc hdrVisualIndex*(h: HdrView, logicalIndex: cint): int
proc hdrLogicalIndex*(h: HdrView, visualIndex: cint): int
proc hdrSectionSize*(h: HdrView, logicalIndex: cint): int
proc hdrResizeSection*(h: HdrView, logicalIndex, size: cint)
proc hdrSetCascadingSectionResizes*(h: HdrView, b: bool)
proc hdrSetSortIndicator*(h: HdrView, section: cint, order: cint)
proc hdrSetSortIndicatorShown*(h: HdrView, b: bool)
```

---

## QDateTimeEdit / QDateEdit / QTimeEdit

```nim
proc newDateTimeEdit*(parent: W = nil): DtTmEdit
proc newDateEdit*(parent: W = nil): DtEdit
proc newTimeEdit*(parent: W = nil): TmEdit

proc setDateTimeFormat*(e: DtTmEdit, fmt: QString)    ## "yyyy-MM-dd HH:mm:ss"
proc setDateFormat*(e: DtEdit, fmt: QString)           ## "yyyy-MM-dd"
proc setTimeFormat*(e: TmEdit, fmt: QString)           ## "HH:mm:ss"

proc setCalendarPopup*(e: DtTmEdit, b: bool)
proc setCalendarPopup*(e: DtEdit, b: bool)

proc dateTimeStr*(e: DtTmEdit, fmt: string = "yyyy-MM-dd HH:mm:ss"): string
proc dateStr*(e: DtEdit, fmt: string = "yyyy-MM-dd"): string
proc timeStr*(e: TmEdit, fmt: string = "HH:mm:ss"): string

proc setMinDateTime*(e: DtTmEdit, s: string)     ## ISO 8601 format
proc setMaxDateTime*(e: DtTmEdit, s: string)
proc setDateTime*(e: DtTmEdit, s: string)
proc setCurrentDateTime*(e: DtTmEdit)

# Signal
proc onDTEDateTimeChanged*(e: DtTmEdit, cb: CBStr, ud: pointer)
```

---

## Layouts

### QVBoxLayout

```nim
proc newVBox*(parent: W = nil): VBox
proc add*(l: VBox, w: W)          ## Add QWidget (and other widget types)
proc addLayout*(l: VBox, sub: VBox)
proc addLayout*(l: VBox, sub: HBox)
proc addLayout*(l: VBox, sub: Grid)
proc addLayout*(l: VBox, sub: Form)
proc stretch*(l: VBox)
proc stretch*(l: VBox, factor: cint)
proc addSpacing*(l: VBox, size: cint)
proc setSpacing*(l: VBox, px: cint)
proc setMargins*(l: VBox, a, b, c, d: cint)
proc setContentsMargins*(l: VBox, a, b, c, d: cint)
```

### QHBoxLayout

```nim
proc newHBox*(parent: W = nil): HBox
proc add*(l: HBox, w: W)          ## Same methods as VBox
proc stretch*(l: HBox)
proc addSpacing*(l: HBox, size: cint)
proc setSpacing*(l: HBox, px: cint)
proc setMargins*(l: HBox, a, b, c, d: cint)
```

### QGridLayout

```nim
proc newGrid*(parent: W = nil): Grid
proc add*(l: Grid, w: W, row, col: cint)
proc add*(l: Grid, w: Lbl, row, col: cint)
proc add*(l: Grid, w: Btn, row, col: cint)
proc add*(l: Grid, w: LE, row, col: cint)
proc add*(l: Grid, w: TE, row, col: cint)
proc add*(l: Grid, w: Combo, row, col: cint)
proc add*(l: Grid, w: Spin, row, col: cint)
proc add*(l: Grid, w: ChkBox, row, col: cint)
proc addSpan*(l: Grid, w: W, row, col, rowSpan, colSpan: cint)
proc addLayout*(l: Grid, sub: HBox, row, col: cint)
proc addLayout*(l: Grid, sub: VBox, row, col: cint)
proc setSpacing*(l: Grid, px: cint)
proc setHorizontalSpacing*(l: Grid, px: cint)
proc setVerticalSpacing*(l: Grid, px: cint)
proc setMargins*(l: Grid, a, b, c, d: cint)
proc setColumnStretch*(l: Grid, col, stretch: cint)
proc setRowStretch*(l: Grid, row, stretch: cint)
proc setColumnMinimumWidth*(l: Grid, col, minWidth: cint)
proc setRowMinimumHeight*(l: Grid, row, minHeight: cint)
```

### QFormLayout

```nim
proc newFormLayout*(parent: W = nil): Form
proc addRow*(f: Form, label: QString, field: W)
proc addRow*(f: Form, label: Lbl, field: W)
proc addRow*(f: Form, label: Lbl, field: LE)
proc addRow*(f: Form, label: Lbl, field: Combo)
proc addRow*(f: Form, label: Lbl, field: Spin)
proc addRow*(f: Form, label: Lbl, field: HBox)
proc addRow*(f: Form, w: W)
proc insertRow*(f: Form, row: cint, label: QString, field: W)
proc removeRow*(f: Form, row: cint)
proc setLabelAlignment*(f: Form, a: cint)
proc setFormAlignment*(f: Form, a: cint)
proc setRowWrapPolicy*(f: Form, p: cint)
proc setFieldGrowthPolicy*(f: Form, p: cint)
proc setSpacing*(f: Form, px: cint)
proc setContentsMargins*(f: Form, a, b, c, d: cint)
proc rowCount*(f: Form): int
```

### QStackedLayout

```nim
proc newStackedLayout*(parent: W = nil): StkLyt
proc addWidget*(l: StkLyt, w: W): int
proc setCurrentIndex*(l: StkLyt, i: cint)
proc currentIndex*(l: StkLyt): int
proc setStackingMode*(l: StkLyt, mode: cint)   ## 0=StackOne, 1=StackAll
```

---

## QCompleter

```nim
proc newCompleter*(words: seq[string], parent: W = nil): Compltr
proc setCaseSensitivity*(c: Compltr, cs: cint)    ## 0=CaseInsensitive, 1=CaseSensitive
proc setCompletionMode*(c: Compltr, mode: cint)   ## 0=Popup, 1=Inline, 2=UnfilteredPopup
proc setMaxVisibleItems*(c: Compltr, n: cint)
proc setFilterMode*(c: Compltr, flags: cint)
proc setModel*(c: Compltr, m: AIM)
proc setModelSorting*(c: Compltr, sorting: cint)

# Signal
proc onCompleterActivated*(c: Compltr, cb: CBStr, ud: pointer)
```

---

## QShortcut

```nim
proc newShortcut*(keys: cstring, parent: W): Shortcut
  ## e.g. "Ctrl+S", "F5", "Alt+F4"
proc setEnabled*(s: Shortcut, b: bool)
proc setAutoRepeat*(s: Shortcut, b: bool)
proc setContext*(s: Shortcut, ctx: cint)
  ## 0=WidgetShortcut, 1=WidgetWithChildren, 2=Window, 3=Application

# Signal
proc onShortcutActivated*(s: Shortcut, cb: CB, ud: pointer)
```

---

## QSystemTrayIcon

```nim
proc newTrayIcon*(parent: W = nil): Tray
proc traySetVisible*(t: Tray, b: bool)
proc traySetToolTip*(t: Tray, s: QString)
proc traySetContextMenu*(t: Tray, m: Menu)
proc trayShow*(t: Tray)
proc trayHide*(t: Tray)
proc trayShowMessage*(t: Tray, title, msg: QString, ms: cint = 3000)
proc trayIsAvailable*(): bool

# Signals
proc onTrayActivated*(t: Tray, cb: CBInt, ud: pointer)   ## See QTrayIconActivationReason
proc onTrayMessageClicked*(t: Tray, cb: CB, ud: pointer)
```

---

## QCalendarWidget

```nim
proc newCalendarWidget*(parent: W = nil): Calendar
proc setGridVisible*(c: Calendar, b: bool)
proc setNavigationBarVisible*(c: Calendar, b: bool)
proc setFirstDayOfWeek*(c: Calendar, day: cint)  ## 1=Mon ... 7=Sun
proc setMinimumDate*(c: Calendar, y, m, d: cint)
proc setMaximumDate*(c: Calendar, y, m, d: cint)
proc selectedDate*(c: Calendar): tuple[y, m, d: int]
proc setSelectedDate*(c: Calendar, y, m, d: cint)
proc setStyleSheet*(c: Calendar, css: QString)

# Signals
proc onCalendarSelectionChanged*(c: Calendar, cb: CB, ud: pointer)
proc onCalendarActivated*(c: Calendar,
    cb: proc(y, m, d: cint, ud: pointer) {.cdecl.}, ud: pointer)
```

---

## QWizard / QWizardPage

### QWizard

```nim
proc newWizard*(parent: W = nil): Wizard
proc addPage*(wz: Wizard, page: WizPage): int
proc setPage*(wz: Wizard, id: cint, page: WizPage)
proc setStartId*(wz: Wizard, id: cint)
proc setWizardStyle*(wz: Wizard, style: cint)  ## 0=Classic, 1=Modern, 2=Mac, 3=Aero
proc setOptions*(wz: Wizard, opts: cint)        ## See QWizardOption
proc setOption*(wz: Wizard, opt: cint, on: bool = true)
proc currentPage*(wz: Wizard): WizPage
proc currentId*(wz: Wizard): int
proc page*(wz: Wizard, id: cint): WizPage
proc execWizard*(wz: Wizard): int
proc setWindowTitle*(wz: Wizard, s: QString)
proc restart*(wz: Wizard)

# Signal
proc onWizardFinished*(wz: Wizard, cb: CBInt, ud: pointer)
```

### QWizardPage

```nim
proc newWizardPage*(parent: W = nil): WizPage
proc setPageTitle*(p: WizPage, s: QString)
proc setPageSubTitle*(p: WizPage, s: QString)
proc setLayout*(p: WizPage, l: VBox)
proc setLayout*(p: WizPage, l: HBox)
proc setLayout*(p: WizPage, l: Grid)
proc setLayout*(p: WizPage, l: Form)
proc registerField*(p: WizPage, name: QString, w: W)
proc isWizPageComplete*(p: WizPage): bool
proc setWizPageFinalPage*(p: WizPage, b: bool)
```

---

## QDialog

```nim
proc newDialog*(parent: W = nil): Dlg
proc execDlg*(d: Dlg): int     ## Blocking; returns 1=Accept, 0=Reject
proc accept*(d: Dlg)
proc reject*(d: Dlg)
proc done*(d: Dlg, r: cint)
proc show*(d: Dlg)
proc hide*(d: Dlg)
proc setWindowTitle*(d: Dlg, s: QString)
proc resize*(d: Dlg, w, h: cint)
proc setModal*(d: Dlg, b: bool)
proc setSizeGripEnabled*(d: Dlg, b: bool)
proc setLayout*(d: Dlg, l: VBox)
proc setLayout*(d: Dlg, l: HBox)
proc setLayout*(d: Dlg, l: Grid)
proc setLayout*(d: Dlg, l: Form)
proc setStyleSheet*(d: Dlg, css: QString)

# Signals
proc onDlgFinished*(d: Dlg, cb: CBInt, ud: pointer)
proc onDlgAccepted*(d: Dlg, cb: CB, ud: pointer)
proc onDlgRejected*(d: Dlg, cb: CB, ud: pointer)
```

---

## Data Models

### QStandardItemModel

```nim
proc newSIM*(rows, cols: cint, parent: W = nil): SIM
proc newSIM*(parent: W = nil): SIM
proc simRowCount*(m: SIM): int
proc simColCount*(m: SIM): int
proc simAppendRow*(m: SIM, items: seq[SI])
proc simAppendRow*(m: SIM, item: SI)
proc simSetHorizontalHeaders*(m: SIM, labels: openArray[string])
proc simClear*(m: SIM)
proc simItem*(m: SIM, row, col: cint): SI
```

### QStandardItem

```nim
proc newSI*(text: QString): SI
proc newSI*(): SI
proc siSetText*(i: SI, s: QString)
proc siText*(i: SI): string
proc siSetEditable*(i: SI, b: bool)
proc siSetCheckable*(i: SI, b: bool)
proc siSetCheckState*(i: SI, s: cint)
proc siSetData*(i: SI, role: cint, v: QVariant)
proc siSetFlags*(i: SI, f: cint)
proc siAppendRow*(i: SI, child: SI)
proc siRowCount*(i: SI): int
proc siChild*(i: SI, row: cint, col: cint = 0): SI
```

### QStringListModel

```nim
proc newStringListModel*(words: seq[string], parent: W = nil): SLM
proc slmSetStrings*(m: SLM, words: seq[string])
proc slmStrings*(m: SLM): seq[string]
```

---

## QSortFilterProxyModel

```nim
proc newSFPM*(parent: W = nil): SFPM
proc sfpmSetSource*(m: SFPM, src: AIM)
proc sfpmSetSource*(m: SFPM, src: SIM)
proc sfpmSetSource*(m: SFPM, src: SLM)
proc sfpmSetFilterStr*(m: SFPM, pattern: QString)    ## Regular expression
proc sfpmSetFilterCol*(m: SFPM, col: cint)
proc sfpmSetSortCol*(m: SFPM, col: cint, order: cint = 0)
proc sfpmSetCaseSensitive*(m: SFPM, b: bool)
proc sfpmRowCount*(m: SFPM): int
proc sfpmColCount*(m: SFPM): int
proc sfpmInvalidate*(m: SFPM)
proc sfpmSetDynamic*(m: SFPM, b: bool)
proc sfpmSetRecursive*(m: SFPM, b: bool)
proc sfpmMapToSource*(m: SFPM, idx: QModelIndex): QModelIndex
proc sfpmMapFromSource*(m: SFPM, idx: QModelIndex): QModelIndex
```

---

## QSizeGrip / QRubberBand

```nim
proc newSizeGrip*(parent: W = nil): ptr QSizeGrip

proc newRubberBand*(shape: cint, parent: W = nil): ptr QRubberBand
  ## shape: 0=Line, 1=Rectangle
proc rubberBandMove*(rb: ptr QRubberBand, x, y: cint)
proc rubberBandResize*(rb: ptr QRubberBand, w, h: cint)
proc rubberBandShow*(rb: ptr QRubberBand)
proc rubberBandHide*(rb: ptr QRubberBand)
proc rubberBandSetGeometry*(rb: ptr QRubberBand, x, y, w, h: cint)
```

---

## QFontDatabase

```nim
proc addApplicationFont*(path: string): int
  ## Load a font from file. Returns id (-1 on failure)

proc availableFontFamilies*(): seq[string]
  ## All available font families

proc fontFamilyStyles*(family: string): seq[string]
  ## Font styles: "Regular", "Bold", "Italic", etc.

proc fontPointSizes*(family, style: string): seq[int]
  ## Available point sizes for a font
```

---

## QToolTip (static)

```nim
proc showToolTip*(x, y: cint, text: QString)
  ## Show tooltip at absolute screen coordinates
proc hideToolTip*()
proc toolTipFont*(): string
```

---

## Utilities and Styling

```nim
proc setFontSize*(w: W, px: int)
  ## Apply font-size via stylesheet

proc makeStylesheet*(bg: string = ""; fg: string = ""; font: string = "";
                     border: string = ""; radius: int = 0;
                     padding: int = -1): string
  ## Simple DSL for generating QSS strings
```

### makeStylesheet Example

```nim
let css = makeStylesheet(bg="#2d2d2d", fg="white", radius=8, padding=6)
# Result: "{ background-color: #2d2d2d; color: white; border-radius: 8px; padding: 6px }"
btn.setStyleSheet(qs(css))
```

---

## Complete Example Program

```nim
import nimQtWidgets
import nimQtUtils

proc main() =
  let app = newApp()
  app.setAppName(qs"Example App")
  app.setStyle("Fusion")

  let win = newWin()
  win.setTitle(qs"My Window")
  win.resize(640.cint, 480.cint)
  win.centerOnScreen()

  let central = newWidget()
  let vbox = newVBox()

  let lbl = newLabel(qs"Enter text:", central.asW)
  let edit = newLineEdit(central.asW)
  let btn = newBtn(qs"Click me", central.asW)
  let output = newPlainTextEdit(central.asW)

  vbox.add(lbl)
  vbox.add(edit)
  vbox.add(btn)
  vbox.add(output)
  central.setLayout(vbox)
  win.setCentral(central)

  var ctx = (edit: edit, output: output)
  btn.onClicked(proc(ud: pointer) {.cdecl.} =
    let c = cast[ptr typeof(ctx)](ud)
    c.output.appendLine(qs(c.edit.text()))
  , addr ctx)

  win.show()
  discard app.exec()

main()
```
