# nimQtWidgets — Справочник библиотеки (Русский)

> Полная обёртка Qt6Widgets для языка Nim.  
> Компиляция: `nim cpp --passC:"-std=c++20" yourapp.nim`  
> Зависимости: `nimQtUtils`, `nimQtFFI`

---

## Содержание

1. [Общие сведения](#общие-сведения)
2. [Типы виджетов и псевдонимы](#типы-виджетов-и-псевдонимы)
3. [Перечисления (Enums)](#перечисления-enums)
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
43. [Layouts (компоновщики)](#layouts-компоновщики)
44. [QCompleter](#qcompleter)
45. [QShortcut](#qshortcut)
46. [QSystemTrayIcon](#qsystemtrayicon)
47. [QCalendarWidget](#qcalendarwidget)
48. [QWizard / QWizardPage](#qwizard--qwizardpage)
49. [QDialog](#qdialog)
50. [Модели данных](#модели-данных)
51. [QSortFilterProxyModel](#qsortfilterproxymodel)
52. [QSizeGrip / QRubberBand](#qsizegrip--qrubberband)
53. [QFontDatabase](#qfontdatabase)
54. [QToolTip (статический)](#qtooltip-статический)
55. [Утилиты и стили](#утилиты-и-стили)

---

## Общие сведения

Библиотека `nimQtWidgets` предоставляет тонкую Nim-обёртку над Qt6 Widgets через механизм `importcpp`. Все типы виджетов являются **opaque-типами** (непрозрачными), операции выполняются через указатели (`ptr`).

### Настройка компилятора (MSYS2/ucrt64)

```nim
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

### Типы обратных вызовов (из nimQtFFI)

| Тип       | Сигнатура                                   |
|-----------|---------------------------------------------|
| `CB`      | `proc(ud: pointer) {.cdecl.}`               |
| `CBBool`  | `proc(v: cint, ud: pointer) {.cdecl.}`      |
| `CBInt`   | `proc(v: cint, ud: pointer) {.cdecl.}`      |
| `CBStr`   | `proc(s: cstring, ud: pointer) {.cdecl.}`   |

---

## Типы виджетов и псевдонимы

### Opaque-типы (C++ классы)

| Nim-тип               | Qt-класс               |
|-----------------------|------------------------|
| `QApplication`        | `QApplication`         |
| `QMainWindow`         | `QMainWindow`          |
| `QWidget`             | `QWidget`              |
| `QDialog`             | `QDialog`              |
| `QPushButton`         | `QPushButton`          |
| `QToolButton`         | `QToolButton`          |
| `QRadioButton`        | `QRadioButton`         |
| `QCheckBox`           | `QCheckBox`            |
| `QCommandLinkButton`  | `QCommandLinkButton`   |
| `QLabel`              | `QLabel`               |
| `QLineEdit`           | `QLineEdit`            |
| `QTextEdit`           | `QTextEdit`            |
| `QPlainTextEdit`      | `QPlainTextEdit`       |
| `QTextBrowser`        | `QTextBrowser`         |
| `QSpinBox`            | `QSpinBox`             |
| `QDoubleSpinBox`      | `QDoubleSpinBox`       |
| `QTimeEdit`           | `QTimeEdit`            |
| `QDateEdit`           | `QDateEdit`            |
| `QDateTimeEdit`       | `QDateTimeEdit`        |
| `QDial`               | `QDial`                |
| `QSlider`             | `QSlider`              |
| `QScrollBar`          | `QScrollBar`           |
| `QProgressBar`        | `QProgressBar`         |
| `QComboBox`           | `QComboBox`            |
| `QFontComboBox`       | `QFontComboBox`        |
| `QLCDNumber`          | `QLCDNumber`           |
| `QGroupBox`           | `QGroupBox`            |
| `QFrame`              | `QFrame`               |
| `QStackedWidget`      | `QStackedWidget`       |
| `QTabWidget`          | `QTabWidget`           |
| `QTabBar`             | `QTabBar`              |
| `QSplitter`           | `QSplitter`            |
| `QScrollArea`         | `QScrollArea`          |
| `QDockWidget`         | `QDockWidget`          |
| `QMdiArea`            | `QMdiArea`             |
| `QMdiSubWindow`       | `QMdiSubWindow`        |
| `QListWidget`         | `QListWidget`          |
| `QListWidgetItem`     | `QListWidgetItem`      |
| `QTreeWidget`         | `QTreeWidget`          |
| `QTreeWidgetItem`     | `QTreeWidgetItem`      |
| `QTableWidget`        | `QTableWidget`         |
| `QTableWidgetItem`    | `QTableWidgetItem`     |
| `QHeaderView`         | `QHeaderView`          |
| `QMenu`               | `QMenu`                |
| `QMenuBar`            | `QMenuBar`             |
| `QAction`             | `QAction`              |
| `QActionGroup`        | `QActionGroup`         |
| `QToolBar`            | `QToolBar`             |
| `QStatusBar`          | `QStatusBar`           |
| `QLayout`             | `QLayout`              |
| `QVBoxLayout`         | `QVBoxLayout`          |
| `QHBoxLayout`         | `QHBoxLayout`          |
| `QGridLayout`         | `QGridLayout`          |
| `QFormLayout`         | `QFormLayout`          |
| `QStackedLayout`      | `QStackedLayout`       |
| `QSystemTrayIcon`     | `QSystemTrayIcon`      |
| `QCompleter`          | `QCompleter`           |
| `QButtonGroup`        | `QButtonGroup`         |
| `QShortcut`           | `QShortcut`            |
| `QCalendarWidget`     | `QCalendarWidget`      |
| `QWizard`             | `QWizard`              |
| `QWizardPage`         | `QWizardPage`          |
| `QStandardItemModel`  | `QStandardItemModel`   |
| `QStandardItem`       | `QStandardItem`        |
| `QStringListModel`    | `QStringListModel`     |
| `QItemSelectionModel` | `QItemSelectionModel`  |
| `QAbstractItemModel`  | `QAbstractItemModel`   |
| `QSortFilterProxyModel`| `QSortFilterProxyModel`|
| `QModelIndex`         | `QModelIndex`          |

### Короткие псевдонимы (`ptr`-типы)

| Псевдоним  | Тип                          |
|------------|------------------------------|
| `App`      | `ptr QApplication`           |
| `Win`      | `ptr QMainWindow`            |
| `W`        | `ptr QWidget`                |
| `Dlg`      | `ptr QDialog`                |
| `Btn`      | `ptr QPushButton`            |
| `TBtn`     | `ptr QToolButton`            |
| `Radio`    | `ptr QRadioButton`           |
| `ChkBox`   | `ptr QCheckBox`              |
| `CmdBtn`   | `ptr QCommandLinkButton`     |
| `Lbl`      | `ptr QLabel`                 |
| `LE`       | `ptr QLineEdit`              |
| `TE`       | `ptr QTextEdit`              |
| `PTE`      | `ptr QPlainTextEdit`         |
| `TBrw`     | `ptr QTextBrowser`           |
| `Spin`     | `ptr QSpinBox`               |
| `DSpin`    | `ptr QDoubleSpinBox`         |
| `TmEdit`   | `ptr QTimeEdit`              |
| `DtEdit`   | `ptr QDateEdit`              |
| `DtTmEdit` | `ptr QDateTimeEdit`          |
| `Dial`     | `ptr QDial`                  |
| `Slider`   | `ptr QSlider`                |
| `SBar`     | `ptr QScrollBar`             |
| `Prog`     | `ptr QProgressBar`           |
| `Combo`    | `ptr QComboBox`              |
| `FCombo`   | `ptr QFontComboBox`          |
| `LCD`      | `ptr QLCDNumber`             |
| `Grp`      | `ptr QGroupBox`              |
| `Frm`      | `ptr QFrame`                 |
| `Stack`    | `ptr QStackedWidget`         |
| `Tab`      | `ptr QTabWidget`             |
| `TabBar`   | `ptr QTabBar`                |
| `Splt`     | `ptr QSplitter`              |
| `Scroll`   | `ptr QScrollArea`            |
| `Dock`     | `ptr QDockWidget`            |
| `Mdi`      | `ptr QMdiArea`               |
| `MdiSub`   | `ptr QMdiSubWindow`          |
| `LW`       | `ptr QListWidget`            |
| `LWI`      | `ptr QListWidgetItem`        |
| `TW`       | `ptr QTreeWidget`            |
| `TWI`      | `ptr QTreeWidgetItem`        |
| `TblW`     | `ptr QTableWidget`           |
| `TblWI`    | `ptr QTableWidgetItem`       |
| `HdrView`  | `ptr QHeaderView`            |
| `Menu`     | `ptr QMenu`                  |
| `MBar`     | `ptr QMenuBar`               |
| `Act`      | `ptr QAction`                |
| `ActGrp`   | `ptr QActionGroup`           |
| `TB`       | `ptr QToolBar`               |
| `StatusBar`| `ptr QStatusBar`             |
| `VBox`     | `ptr QVBoxLayout`            |
| `HBox`     | `ptr QHBoxLayout`            |
| `Grid`     | `ptr QGridLayout`            |
| `Form`     | `ptr QFormLayout`            |
| `StkLyt`   | `ptr QStackedLayout`         |
| `Tray`     | `ptr QSystemTrayIcon`        |
| `Compltr`  | `ptr QCompleter`             |
| `BtnGrp`   | `ptr QButtonGroup`           |
| `Shortcut` | `ptr QShortcut`              |
| `Calendar` | `ptr QCalendarWidget`        |
| `Wizard`   | `ptr QWizard`                |
| `WizPage`  | `ptr QWizardPage`            |
| `SIM`      | `ptr QStandardItemModel`     |
| `SI`       | `ptr QStandardItem`          |
| `SLM`      | `ptr QStringListModel`       |
| `ISM`      | `ptr QItemSelectionModel`    |
| `AIM`      | `ptr QAbstractItemModel`     |
| `SFPM`     | `ptr QSortFilterProxyModel`  |

---

## Перечисления (Enums)

### QLineEditEchoMode
| Значение             | Описание                          |
|----------------------|-----------------------------------|
| `Normal`             | Обычный ввод (0)                  |
| `NoEcho`             | Ввод не отображается (1)          |
| `Password`           | Пароль — скрытые символы (2)      |
| `PasswordEchoOnEdit` | Показ при редактировании (3)      |

### QTabPosition
| Значение    | Описание            |
|-------------|---------------------|
| `TabNorth`  | Вкладки сверху (0)  |
| `TabSouth`  | Вкладки снизу (1)   |
| `TabWest`   | Вкладки слева (2)   |
| `TabEast`   | Вкладки справа (3)  |

### QTabShape
| Значение      | Описание               |
|---------------|------------------------|
| `Rounded`     | Скруглённые вкладки (0)|
| `Triangular`  | Треугольные вкладки (1)|

### QSelectionMode
| Значение               | Описание                       |
|------------------------|--------------------------------|
| `NoSelection`          | Выбор отключён (0)             |
| `SingleSelection`      | Одиночный выбор (1)            |
| `MultiSelection`       | Множественный выбор (2)        |
| `ExtendedSelection`    | Расширенный выбор (3)          |
| `ContiguousSelection`  | Непрерывный выбор (4)          |

### QSelectionBehavior
| Значение        | Описание                 |
|-----------------|--------------------------|
| `SelectItems`   | Выбор ячеек (0)          |
| `SelectRows`    | Выбор строк (1)          |
| `SelectColumns` | Выбор столбцов (2)       |

### QScrollHint
| Значение           | Описание                        |
|--------------------|---------------------------------|
| `EnsureVisible`    | Гарантировать видимость (0)     |
| `PositionAtTop`    | Прокрутить к верхнему краю (1)  |
| `PositionAtBottom` | Прокрутить к нижнему краю (2)   |
| `PositionAtCenter` | Прокрутить к центру (3)         |

### QToolButtonStyle
| Значение                  | Описание                          |
|---------------------------|-----------------------------------|
| `ToolButtonIconOnly`      | Только иконка (0)                 |
| `ToolButtonTextOnly`      | Только текст (1)                  |
| `ToolButtonTextBesideIcon`| Текст рядом с иконкой (2)         |
| `ToolButtonTextUnderIcon` | Текст под иконкой (3)             |
| `ToolButtonFollowStyle`   | По системному стилю (4)           |

### QComboBoxInsertPolicy
| Значение               | Описание                    |
|------------------------|-----------------------------|
| `NoInsert`             | Не вставлять (0)            |
| `InsertAtTop`          | Вставить сверху (1)         |
| `InsertAtCurrent`      | Вставить на текущее (2)     |
| `InsertAtBottom`       | Вставить снизу (3)          |
| `InsertAfterCurrent`   | Вставить после текущего (4) |
| `InsertBeforeCurrent`  | Вставить до текущего (5)    |
| `InsertAlphabetically` | По алфавиту (6)             |

### QItemDataRole
| Значение           | Числовое | Описание                        |
|--------------------|----------|---------------------------------|
| `DisplayRole`      | 0        | Отображаемый текст              |
| `DecorationRole`   | 1        | Иконка/изображение              |
| `EditRole`         | 2        | Данные для редактирования       |
| `ToolTipRole`      | 3        | Всплывающая подсказка           |
| `CheckStateRole`   | 10       | Состояние чекбокса              |
| `UserRole`         | 0x0100   | Пользовательские данные         |

### QLCDNumberMode
| Значение  | Описание                    |
|-----------|-----------------------------|
| `LcdHex`  | Шестнадцатеричный (0)       |
| `LcdDec`  | Десятичный (1)              |
| `LcdOct`  | Восьмеричный (2)            |
| `LcdBin`  | Двоичный (3)                |

### QTrayIconActivationReason
| Значение          | Описание                    |
|-------------------|-----------------------------|
| `TrayUnknown`     | Неизвестно (0)              |
| `TrayContext`     | Контекстное меню (1)        |
| `TrayDoubleClick` | Двойной клик (2)            |
| `TrayTrigger`     | Одиночный клик (3)          |
| `TrayMiddleClick` | Клик средней кнопкой (4)    |

### QWizardOption
Флаги для настройки поведения QWizard (битовые маски):

| Значение                        | Описание                                      |
|---------------------------------|-----------------------------------------------|
| `IndependentPages`              | Страницы независимы (0x001)                   |
| `IgnoreSubTitles`               | Не показывать подзаголовки (0x002)            |
| `NoDefaultButton`               | Кнопка Next не по умолчанию (0x008)           |
| `NoCancelButton`                | Скрыть кнопку Cancel (0x200)                  |
| `HaveHelpButton`                | Показать кнопку Help (0x800)                  |
| `HaveCustomButton1/2/3`         | Пользовательские кнопки (0x2000–0x8000)       |

---

## QApplication

Синглтон приложения. Создаётся один раз в начале программы.

### Создание и жизненный цикл

```nim
proc newApp*(): App
  ## Создаёт QApplication (без аргументов командной строки)

proc appInstance*(): App
  ## Получить существующий экземпляр QApplication

proc exec*(a: App): cint
  ## Запустить цикл событий; возвращает код завершения

proc quit*(a: App)
  ## Завершить цикл событий

proc exit*(a: App, code: cint = 0)
  ## Завершить с кодом

proc processEvents*(a: App)
  ## Обработать накопившиеся события (без блокировки)
```

### Метаданные приложения

```nim
proc setAppName*(a: App, s: QString)
proc setOrgName*(a: App, s: QString)
proc setOrgDomain*(a: App, s: QString)
proc setAppVersion*(a: App, s: QString)
proc appName*(): string
```

### Внешний вид

```nim
proc setStyleSheet*(a: App, css: QString)
  ## Глобальная QSS для всего приложения

proc setStyle*(a: App, styleName: string)
  ## Установить стиль: "Fusion", "Windows", "WindowsVista" и др.

proc availableStyles*(): seq[string]
  ## Список доступных стилей QStyleFactory

proc setFont*(a: App, family: string, size: int, bold: bool = false)
  ## Установить глобальный шрифт приложения
```

### Экран

```nim
proc primaryScreen*(): pointer
  ## Указатель на QScreen (opaque)

proc screenGeometry*(): tuple[x, y, w, h: int]
  ## Доступная геометрия основного экрана

proc screenDpi*(): int
  ## Логическое DPI основного экрана
```

### Пример

```nim
let app = newApp()
app.setAppName(qs"МоёПриложение")
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

Базовый класс для всех виджетов. Тип `W = ptr QWidget`.

### Создание и отображение

```nim
proc newWidget*(parent: W = nil): W
proc show*(w: W)
proc hide*(w: W)
proc close*(w: W)
proc raiseW*(w: W)   ## Поднять виджет поверх других
proc lower*(w: W)    ## Опустить виджет
proc update*(w: W)   ## Запланировать перерисовку
proc repaint*(w: W)  ## Немедленная перерисовка
```

### Видимость и доступность

```nim
proc setVisible*(w: W, v: bool)
proc isVisible*(w: W): bool
proc setEnabled*(w: W, b: bool)
proc setDisabled*(w: W, b: bool)
proc isEnabled*(w: W): bool
```

### Геометрия

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
proc geometry*(w: W): NimRect    ## tuple[x, y, w, h: int]
proc centerOnScreen*(w: W)       ## Отцентрировать по экрану
```

### Заголовок и подсказки

```nim
proc setWindowTitle*(w: W, s: QString)
proc windowTitle*(w: W): string
proc setToolTip*(w: W, s: QString)
proc setWhatsThis*(w: W, s: QString)
proc setStatusTip*(w: W, s: QString)
```

### Стиль и оформление

```nim
proc setStyleSheet*(w: W, css: QString)
proc setContentsMargins*(w: W, l, t, r, b: cint)
proc setContentsMargins*(w: W, all: cint)
proc setSizePolicy*(w: W, h, v: cint)
proc setCursor*(w: W, shape: cint)
proc unsetCursor*(w: W)
```

### Компоновщик

```nim
proc setLayout*(w: W, l: ptr QLayout)
proc setLayout*(w: W, l: VBox)
proc setLayout*(w: W, l: HBox)
proc setLayout*(w: W, l: Grid)
proc setLayout*(w: W, l: Form)
```

### Фокус и ввод

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

### Прочее

```nim
proc setWindowFlags*(w: W, flags: cint)
proc setWindowModality*(w: W, modal: bool)
proc setAcceptDrops*(w: W, b: bool)
proc setAttribute*(w: W, attr: cint, on: bool = true)
proc setParent*(w, parent: W)
proc parentWidget*(w: W): W
```

### Upcast-помощники (приведение к W)

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
# ... и другие типы виджетов
```

---

## QMainWindow

Главное окно приложения. Тип `Win = ptr QMainWindow`.

```nim
proc newWin*(parent: W = nil): Win
proc show*(w: Win)
proc hide*(w: Win)
proc close*(w: Win)
proc setTitle*(w: Win, s: QString)
proc resize*(w: Win, width, height: cint)
proc setMinSize*(w: Win, width, height: cint)
proc centerOnScreen*(w: Win)

# Центральный виджет
proc setCentral*(w: Win, c: W)
proc centralWidget*(w: Win): W

# Строка состояния
proc statusBar*(w: Win): StatusBar

# Меню
proc menuBar*(w: Win): MBar
proc setMenuBar*(w: Win, mb: MBar)
proc addMenu*(w: Win, title: QString): Menu

# Панель инструментов
proc addToolBar*(w: Win, title: QString): TB
proc addToolBarBreak*(w: Win)

# Докируемые панели
proc addDock*(w: Win, area: cint, d: Dock)
proc removeDock*(w: Win, d: Dock)
proc splitDock*(w: Win, first, second: Dock, orientation: cint)
proc tabifyDock*(w: Win, first, second: Dock)
proc setDockNestingEnabled*(w: Win, b: bool)

# Состояние
proc saveState*(w: Win): string
proc restoreState*(w: Win, state: string): bool
proc setAnimated*(w: Win, b: bool)
proc setStyleSheet*(w: Win, css: QString)
proc setUnifiedTitleAndToolBarOnMac*(w: Win, b: bool)
```

**Области дока** (передаётся как `cint`): `1`=Left, `2`=Right, `4`=Top, `8`=Bottom, `15`=All

---

## QStatusBar

```nim
proc showMsg*(sb: StatusBar, msg: QString, ms: cint = 0)
  ## Показать сообщение (ms=0 — постоянно)
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
proc execAt*(m: Menu, x, y: cint): Act   ## Показать контекстное меню в точке
proc popup*(m: Menu, x, y: cint)

# Событие
proc onMenuAboutToShow*(m: Menu, cb: CB, ud: pointer)
```

---

## QAction

```nim
proc newAction*(parent: W, text: QString): Act
proc newActionSep*(parent: W): Act          ## Разделитель

proc setText*(a: Act, s: QString)
proc setShortcut*(a: Act, keys: cstring)    ## "Ctrl+S", "F5" и т.д.
proc setShortcut*(a: Act, ks: QString)
proc setTip*(a: Act, s: QString)            ## Подсказка строки состояния
proc setToolTip*(a: Act, s: QString)
proc setEnabled*(a: Act, b: bool)
proc setCheckable*(a: Act, b: bool)
proc setChecked*(a: Act, b: bool)
proc isChecked*(a: Act): bool
proc isEnabled*(a: Act): bool
proc setSeparator*(a: Act, b: bool)
proc setIconText*(a: Act, s: QString)
proc setVisible*(a: Act, b: bool)

# События
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
proc setToolButtonStyle*(tb: TB, style: cint)  ## см. QToolButtonStyle
proc setOrientation*(tb: TB, o: cint)          ## 1=Горизонтально, 2=Вертикально
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
proc setAlignment*(l: Lbl, a: cint)     ## Qt::Alignment flags
proc setWordWrap*(l: Lbl, b: bool)
proc setOpenExternalLinks*(l: Lbl, b: bool)
proc setTextFormat*(l: Lbl, f: cint)    ## 0=PlainText, 1=RichText, 2=AutoText
proc setScaledContents*(l: Lbl, b: bool)
proc setIndent*(l: Lbl, n: cint)
proc setMargin*(l: Lbl, n: cint)
proc setStyleSheet*(l: Lbl, css: QString)
proc setMinSize*(l: Lbl, w, h: cint)
proc setFixedWidth*(l: Lbl, w: cint)

# Событие
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
proc setDefault*(b: Btn, v: bool)      ## Кнопка по умолчанию в диалоге
proc setAutoDefault*(b: Btn, v: bool)
proc setFlat*(b: Btn, v: bool)
proc setStyleSheet*(b: Btn, css: QString)
proc setToolTip*(b: Btn, s: QString)
proc setMinSize*(b: Btn, w, h: cint)
proc setFixedSize*(b: Btn, w, h: cint)
proc click*(b: Btn)
proc animateClick*(b: Btn)

# События
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

# Событие
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

# Событие
proc onRadioToggled*(r: Radio, cb: CBBool, ud: pointer)
```

---

## QCheckBox

```nim
proc newCheckBox*(text: QString, parent: W = nil): ChkBox
proc setText*(c: ChkBox, s: QString)
proc isChecked*(c: ChkBox): bool
proc setChecked*(c: ChkBox, b: bool)
proc setTristate*(c: ChkBox, b: bool)    ## Включить трёхсостоятельный режим
proc checkState*(c: ChkBox): int         ## 0=Unchecked, 1=Partial, 2=Checked
proc setCheckState*(c: ChkBox, s: cint)
proc setEnabled*(c: ChkBox, b: bool)
proc setStyleSheet*(c: ChkBox, css: QString)

# События
proc onCheckBoxToggled*(c: ChkBox, cb: CBBool, ud: pointer)
proc onCheckStateChanged*(c: ChkBox, cb: CBInt, ud: pointer)
```

---

## QButtonGroup

Логическая группировка кнопок (без визуального отображения).

```nim
proc newButtonGroup*(parent: W = nil): BtnGrp
proc addButton*(bg: BtnGrp, b: Btn, id: cint = -1)
proc addButton*(bg: BtnGrp, b: Radio, id: cint = -1)
proc addButton*(bg: BtnGrp, b: ChkBox, id: cint = -1)
proc removeButton*(bg: BtnGrp, b: Btn)
proc setExclusive*(bg: BtnGrp, b: bool)
proc checkedId*(bg: BtnGrp): int
proc setId*(bg: BtnGrp, b: Btn, id: cint)

# Событие
proc onBtnGroupIdClicked*(bg: BtnGrp, cb: CBInt, ud: pointer)
```

---

## QCommandLinkButton

```nim
proc newCmdBtn*(text, desc: QString, parent: W = nil): CmdBtn
proc setDescription*(b: CmdBtn, s: QString)
proc description*(b: CmdBtn): string

# Событие
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
proc setEchoMode*(e: LE, mode: cint)       ## см. QLineEditEchoMode
proc setAlignment*(e: LE, a: cint)
proc clear*(e: LE)
proc selectAll*(e: LE)
proc setClearButtonEnabled*(e: LE, b: bool)
proc setStyleSheet*(e: LE, css: QString)
proc setToolTip*(e: LE, s: QString)
proc setInputMask*(e: LE, mask: QString)   ## Маска ввода, напр. "000.000.000.000"
proc hasAcceptableInput*(e: LE): bool
proc setCompleter*(e: LE, c: Compltr)

# События
proc onTextChanged*(e: LE, cb: CBStr, ud: pointer)
proc onTextEdited*(e: LE, cb: CBStr, ud: pointer)   ## Только ручной ввод
proc onReturnPressed*(e: LE, cb: CB, ud: pointer)
proc onEditingFinished*(e: LE, cb: CB, ud: pointer)
```

---

## QTextEdit

Многострочный редактор с поддержкой HTML/Rich Text.

```nim
proc newTextEdit*(parent: W = nil): TE
proc newTextEdit*(text: QString, parent: W = nil): TE
proc text*(e: TE): string        ## Получить как plain text
proc html*(e: TE): string        ## Получить как HTML
proc setText*(e: TE, s: QString) ## Установить plain text
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
proc setLineWrapMode*(e: TE, mode: cint)   ## 0=NoWrap, 1=WidgetWidth
proc setMaximumBlockCount*(e: TE, n: cint)
proc zoomIn*(e: TE, range: cint = 1)
proc zoomOut*(e: TE, range: cint = 1)

# События
proc onTextChanged*(e: TE, cb: CB, ud: pointer)
proc onCursorPositionChanged*(e: TE, cb: CB, ud: pointer)
```

---

## QPlainTextEdit

Эффективный многострочный редактор (только plain text).

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
proc setMaxBlockCount*(e: PTE, n: cint)    ## Ограничение числа строк (буфер лога)
proc setLineWrapMode*(e: PTE, mode: cint)
proc setStyleSheet*(e: PTE, css: QString)
proc setUndoRedoEnabled*(e: PTE, b: bool)
proc blockCount*(e: PTE): int
proc centerCursor*(e: PTE)
proc scrollToBottom*(e: PTE)

# Событие
proc onPTETextChanged*(e: PTE, cb: CB, ud: pointer)
```

---

## QTextBrowser

Браузер HTML-документов с поддержкой навигации по ссылкам.

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

# Событие
proc onTBrwAnchorClicked*(b: TBrw, cb: CBStr, ud: pointer)
```

---

## QSpinBox / QDoubleSpinBox

### QSpinBox (целые числа)

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

# Событие
proc onSpinValueChanged*(s: Spin, cb: CBInt, ud: pointer)
```

### QDoubleSpinBox (вещественные числа)

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

# Событие
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

# События
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

# Событие
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

# Событие
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
proc setFormat*(p: Prog, fmt: QString)     ## "%p%" — процент, "%v" — значение
proc setOrientation*(p: Prog, o: cint)    ## 1=Horizontal, 2=Vertical
proc setInvertedAppearance*(p: Prog, b: bool)
proc setStyleSheet*(p: Prog, css: QString)
proc reset*(p: Prog)
```

> **Неопределённое состояние** (бегущая строка): `setRange(0, 0)`

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
proc findText*(c: Combo, text: QString): int  ## -1 если не найден
proc setEditable*(c: Combo, b: bool)
proc setMaxVisibleItems*(c: Combo, n: cint)
proc setInsertPolicy*(c: Combo, p: cint)      ## см. QComboBoxInsertPolicy
proc setMaxCount*(c: Combo, n: cint)
proc setDuplicatesEnabled*(c: Combo, b: bool)
proc setStyleSheet*(c: Combo, css: QString)
proc setCompleter*(c: Combo, comp: Compltr)

# События
proc onComboCurrentIndexChanged*(c: Combo, cb: CBInt, ud: pointer)
proc onComboTextActivated*(c: Combo, cb: CBStr, ud: pointer)
```

### QFontComboBox

```nim
proc newFontComboBox*(parent: W = nil): FCombo
proc currentFont*(fc: FCombo): string     ## Возвращает название семейства шрифта
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
proc setMode*(l: LCD, m: cint)              ## см. QLCDNumberMode
proc setSegmentStyle*(l: LCD, s: cint)     ## 0=Outline, 1=Filled, 2=Flat
proc value*(l: LCD): float64
proc setStyleSheet*(l: LCD, css: QString)
```

---

## QGroupBox

```nim
proc newGroupBox*(title: QString, parent: W = nil): Grp
proc setTitle*(g: Grp, s: QString)
proc title*(g: Grp): string
proc setCheckable*(g: Grp, b: bool)      ## Включить заголовок-чекбокс
proc isChecked*(g: Grp): bool
proc setChecked*(g: Grp, b: bool)
proc setFlat*(g: Grp, b: bool)
proc setLayout*(g: Grp, l: VBox)
proc setLayout*(g: Grp, l: HBox)
proc setLayout*(g: Grp, l: Grid)
proc setLayout*(g: Grp, l: Form)
proc setStyleSheet*(g: Grp, css: QString)
proc setAlignment*(g: Grp, a: cint)

# Событие
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
proc addPage*(s: Stack, w: W): int           ## Возвращает индекс страницы
proc insertPage*(s: Stack, index: cint, w: W): int
proc removePage*(s: Stack, w: W)
proc currentIndex*(s: Stack): int
proc setCurrentIndex*(s: Stack, i: cint)
proc setCurrentWidget*(s: Stack, w: W)
proc currentWidget*(s: Stack): W
proc count*(s: Stack): int

# Событие
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
proc setTabPosition*(t: Tab, pos: cint)        ## см. QTabPosition
proc setTabShape*(t: Tab, s: cint)             ## см. QTabShape
proc setMovable*(t: Tab, b: bool)
proc setDocumentMode*(t: Tab, b: bool)
proc setTabsClosable*(t: Tab, b: bool)
proc setUsesScrollButtons*(t: Tab, b: bool)
proc setElideMode*(t: Tab, mode: cint)
proc setStyleSheet*(t: Tab, css: QString)
proc widget*(t: Tab, i: cint): W
proc indexOf*(t: Tab, w: W): int

# События
proc onTabCurrentChanged*(t: Tab, cb: CBInt, ud: pointer)
proc onTabCloseRequested*(t: Tab, cb: CBInt, ud: pointer)
```

---

## QTabBar

Отдельная панель вкладок (без содержимого).

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

# События
proc onTabBarCurrentChanged*(tb: TabBar, cb: CBInt, ud: pointer)
proc onTabBarCloseRequested*(tb: TabBar, cb: CBInt, ud: pointer)
```

---

## QSplitter

```nim
proc newSplitter*(orientation: cint, parent: W = nil): Splt
proc newHSplitter*(parent: W = nil): Splt     ## Горизонтальный
proc newVSplitter*(parent: W = nil): Splt     ## Вертикальный
proc addWidget*(sp: Splt, w: W)
proc insertWidget*(sp: Splt, index: cint, w: W)
proc setCollapsible*(sp: Splt, index: cint, b: bool)
proc setHandleWidth*(sp: Splt, w: cint)
proc setChildrenCollapsible*(sp: Splt, b: bool)
proc setOpaqueResize*(sp: Splt, b: bool)
proc setSizes*(sp: Splt, sizes: seq[int])     ## До 4 элементов
proc count*(sp: Splt): int
proc setStyleSheet*(sp: Splt, css: QString)

# Событие
proc onSplitterMoved*(sp: Splt,
    cb: proc(pos, index: cint, ud: pointer) {.cdecl.}, ud: pointer)
```

---

## QScrollArea

```nim
proc newScrollArea*(parent: W = nil): Scroll
proc setWidget*(s: Scroll, w: W)
proc widget*(s: Scroll): W
proc setResizable*(s: Scroll, b: bool)          ## setWidgetResizable
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
proc setAllowedAreas*(d: Dock, areas: cint)     ## 1=Left, 2=Right, 4=Top, 8=Bottom
proc setFeatures*(d: Dock, f: cint)             ## DockWidgetClosable=1, Movable=2, Floatable=4
proc setFloating*(d: Dock, b: bool)
proc isFloating*(d: Dock): bool
proc setTitleBarWidget*(d: Dock, w: W)
proc setWindowTitle*(d: Dock, s: QString)
proc setStyleSheet*(d: Dock, css: QString)

# События
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
proc setSelectionMode*(lw: LW, mode: cint)      ## см. QSelectionMode
proc setSelectionBehavior*(lw: LW, b: cint)
proc setAlternatingRowColors*(lw: LW, b: bool)
proc setSortingEnabled*(lw: LW, b: bool)
proc sortItems*(lw: LW, order: cint = 0)        ## 0=Ascending, 1=Descending
proc setDragDropMode*(lw: LW, mode: cint)
proc setWordWrap*(lw: LW, b: bool)
proc setSpacing*(lw: LW, s: cint)
proc setGridSize*(lw: LW, w, h: cint)
proc setIconSize*(lw: LW, w, h: cint)
proc setViewMode*(lw: LW, mode: cint)           ## 0=ListMode, 1=IconMode
proc setStyleSheet*(lw: LW, css: QString)
proc scrollToItem*(lw: LW, item: LWI, hint: cint = 0)
proc scrollToTop*(lw: LW)
proc scrollToBottom*(lw: LW)

# События
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
proc lwiSetCheckState*(i: LWI, s: cint)     ## 0=Unchecked, 2=Checked
proc lwiCheckState*(i: LWI): int
proc lwiSetData*(i: LWI, role: cint, v: QVariant)
proc lwiData*(i: LWI, role: cint): QVariant
proc lwiSetToolTip*(i: LWI, s: QString)
proc lwiSetSelected*(i: LWI, b: bool)
proc lwiIsSelected*(i: LWI): bool
proc lwiSetFlags*(i: LWI, f: cint)          ## Qt::ItemFlags
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

# События
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

# События
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

proc setDateTimeFormat*(e: DtTmEdit, fmt: QString)   ## "yyyy-MM-dd HH:mm:ss"
proc setDateFormat*(e: DtEdit, fmt: QString)          ## "yyyy-MM-dd"
proc setTimeFormat*(e: TmEdit, fmt: QString)          ## "HH:mm:ss"

proc setCalendarPopup*(e: DtTmEdit, b: bool)
proc setCalendarPopup*(e: DtEdit, b: bool)

proc dateTimeStr*(e: DtTmEdit, fmt: string = "yyyy-MM-dd HH:mm:ss"): string
proc dateStr*(e: DtEdit, fmt: string = "yyyy-MM-dd"): string
proc timeStr*(e: TmEdit, fmt: string = "HH:mm:ss"): string

proc setMinDateTime*(e: DtTmEdit, s: string)    ## ISO 8601 формат
proc setMaxDateTime*(e: DtTmEdit, s: string)
proc setDateTime*(e: DtTmEdit, s: string)
proc setCurrentDateTime*(e: DtTmEdit)

# Событие
proc onDTEDateTimeChanged*(e: DtTmEdit, cb: CBStr, ud: pointer)
```

---

## Layouts (компоновщики)

### QVBoxLayout

```nim
proc newVBox*(parent: W = nil): VBox
proc add*(l: VBox, w: W)         ## Добавить QWidget
proc add*(l: VBox, w: Lbl)       ## и другие типы виджетов...
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
proc add*(l: HBox, w: W)         ## Аналогично VBox
# ... те же методы что у VBox
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
proc setStackingMode*(l: StkLyt, mode: cint)  ## 0=StackOne, 1=StackAll
```

---

## QCompleter

```nim
proc newCompleter*(words: seq[string], parent: W = nil): Compltr
proc setCaseSensitivity*(c: Compltr, cs: cint)   ## 0=CaseInsensitive, 1=CaseSensitive
proc setCompletionMode*(c: Compltr, mode: cint)  ## 0=PopupCompletion, 1=Inline, 2=UnfilteredPopup
proc setMaxVisibleItems*(c: Compltr, n: cint)
proc setFilterMode*(c: Compltr, flags: cint)
proc setModel*(c: Compltr, m: AIM)
proc setModelSorting*(c: Compltr, sorting: cint)

# Событие
proc onCompleterActivated*(c: Compltr, cb: CBStr, ud: pointer)
```

---

## QShortcut

```nim
proc newShortcut*(keys: cstring, parent: W): Shortcut
  ## Например: "Ctrl+S", "F5", "Alt+F4"
proc setEnabled*(s: Shortcut, b: bool)
proc setAutoRepeat*(s: Shortcut, b: bool)
proc setContext*(s: Shortcut, ctx: cint)
  ## 0=WidgetShortcut, 1=WidgetWithChildrenShortcut, 2=WindowShortcut, 3=ApplicationShortcut

# Событие
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

# События
proc onTrayActivated*(t: Tray, cb: CBInt, ud: pointer)   ## см. QTrayIconActivationReason
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

# События
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
proc setWizardStyle*(wz: Wizard, style: cint)  ## 0=ClassicStyle, 1=Modern, 2=Mac, 3=Aero
proc setOptions*(wz: Wizard, opts: cint)        ## см. QWizardOption
proc setOption*(wz: Wizard, opt: cint, on: bool = true)
proc currentPage*(wz: Wizard): WizPage
proc currentId*(wz: Wizard): int
proc page*(wz: Wizard, id: cint): WizPage
proc execWizard*(wz: Wizard): int
proc setWindowTitle*(wz: Wizard, s: QString)
proc restart*(wz: Wizard)

# Событие
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
proc execDlg*(d: Dlg): int    ## Блокирующий вызов; 1=Accept, 0=Reject
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

# События
proc onDlgFinished*(d: Dlg, cb: CBInt, ud: pointer)
proc onDlgAccepted*(d: Dlg, cb: CB, ud: pointer)
proc onDlgRejected*(d: Dlg, cb: CB, ud: pointer)
```

---

## Модели данных

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
proc sfpmSetFilterStr*(m: SFPM, pattern: QString)   ## Регулярное выражение
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
  ## Загрузить шрифт из файла. Возвращает id (или -1 при ошибке)

proc availableFontFamilies*(): seq[string]
  ## Список всех доступных семейств шрифтов

proc fontFamilyStyles*(family: string): seq[string]
  ## Стили шрифта: "Regular", "Bold", "Italic" и т.д.

proc fontPointSizes*(family, style: string): seq[int]
  ## Доступные размеры шрифта
```

---

## QToolTip (статический)

```nim
proc showToolTip*(x, y: cint, text: QString)
  ## Показать всплывающую подсказку в абсолютных координатах экрана
proc hideToolTip*()
proc toolTipFont*(): string
```

---

## Утилиты и стили

```nim
proc setFontSize*(w: W, px: int)
  ## Применяет font-size через stylesheet

proc makeStylesheet*(bg: string = ""; fg: string = ""; font: string = "";
                     border: string = ""; radius: int = 0;
                     padding: int = -1): string
  ## Простой DSL для генерации QSS строк
```

### Пример makeStylesheet

```nim
let css = makeStylesheet(bg="#2d2d2d", fg="white", radius=8, padding=6)
# Результат: "{ background-color: #2d2d2d; color: white; border-radius: 8px; padding: 6px }"
btn.setStyleSheet(qs(css))
```

---

## Полный пример программы

```nim
import nimQtWidgets
import nimQtUtils

proc main() =
  let app = newApp()
  app.setAppName(qs"Пример")
  app.setStyle("Fusion")

  let win = newWin()
  win.setTitle(qs"Моё окно")
  win.resize(640.cint, 480.cint)
  win.centerOnScreen()

  let central = newWidget()
  let vbox = newVBox()

  let lbl = newLabel(qs"Введите текст:", central.asW)
  let edit = newLineEdit(central.asW)
  let btn = newBtn(qs"Нажми меня", central.asW)
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
