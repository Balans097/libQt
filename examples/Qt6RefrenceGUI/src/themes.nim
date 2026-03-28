## themes.nim — 8 светлых тем + 1 тёмная (Catppuccin Mocha)



const themeWindowsXP* = """
/* Windows XP — Luna Blue
   Характерно: синий градиент тулбара/менюбара, зелёные кнопки Пуск-стиля,
   рельефные кнопки с 3D-эффектом, фон #ece9d8, шрифт Tahoma */

QMainWindow {
  background-color: #ece9d8;
}
QWidget {
  background-color: #ece9d8;
  color: #000000;
  font-family: "Tahoma", "Arial", sans-serif;
  font-size: 11px;
}

/* Синяя полоска менюбара — характерная черта XP */
QMenuBar {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #1c5ca8, stop:0.5 #1255a0, stop:1 #0d4a8c);
  color: #ffffff;
  padding: 2px 4px;
  font-weight: bold;
  font-size: 11px;
}
QMenuBar::item {
  padding: 4px 10px;
  background: transparent;
  border-radius: 0;
}
QMenuBar::item:selected {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #3a7fd4, stop:1 #1a5cb8);
  border: 1px solid #4a8fdd;
}
QMenu {
  background-color: #ffffff;
  color: #000000;
  border: 1px solid #919b8c;
  border-top: 2px solid #0a3da0;
  padding: 2px 0;
  font-size: 11px;
}
QMenu::item {
  padding: 5px 24px 5px 24px;
  background: transparent;
}
QMenu::item:selected {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #3a7fd4, stop:1 #1a5cb8);
  color: #ffffff;
}
QMenu::separator {
  height: 1px;
  background: #d4d0c8;
  margin: 3px 6px;
}
QMenu::icon { padding-left: 6px; }

/* Тулбар — XP-стиль серебристый с синей полоской */
QToolBar {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #e8e4d8, stop:1 #d0ccbf);
  border-bottom: 2px solid #919b8c;
  spacing: 3px;
  padding: 2px 4px;
}
QToolButton {
  color: #000000;
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #f0ece0, stop:1 #ddd8cc);
  border: 1px solid #9a9a9a;
  border-radius: 2px;
  padding: 4px 10px;
  font-size: 11px;
}
QToolButton:hover {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #fce8a0, stop:1 #f0d060);
  border-color: #d0a020;
  color: #000000;
}
QToolButton:pressed {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #d8c840, stop:1 #e8d850);
  border-color: #808020;
}

/* Статусбар */
QStatusBar {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #d0ccbf, stop:1 #bab6a8);
  color: #000000;
  border-top: 1px solid #919b8c;
  padding: 2px 6px;
  font-size: 11px;
}
QStatusBar::item { border: none; }

/* Вкладки */
QTabWidget::pane {
  border: 1px solid #919b8c;
  background: #ffffff;
}
QTabBar::tab {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #f0ece0, stop:1 #d8d4c8);
  color: #000000;
  padding: 5px 14px;
  border: 1px solid #919b8c;
  border-bottom: none;
  margin-right: 2px;
  font-size: 11px;
}
QTabBar::tab:selected {
  background: #ffffff;
  font-weight: bold;
  border-top: 2px solid #1255a0;
  border-bottom-color: #ffffff;
  color: #000000;
}
QTabBar::tab:hover:!selected {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #fce8a0, stop:1 #e8d460);
}

/* Поля ввода */
QTextEdit {
  background-color: #ffffff;
  color: #000000;
  border: 2px inset #919b8c;
  padding: 4px;
  font-family: "Courier New", monospace;
  font-size: 11px;
  selection-background-color: #1255a0;
  selection-color: #ffffff;
}
QTextEdit:focus { border: 2px inset #4a78c0; }

QLineEdit {
  background-color: #ffffff;
  color: #000000;
  border: 2px inset #919b8c;
  padding: 3px 6px;
  font-size: 11px;
  selection-background-color: #1255a0;
  selection-color: #ffffff;
}
QLineEdit:focus { border: 2px inset #4a78c0; }

/* Список */
QListWidget {
  background-color: #ffffff;
  color: #000000;
  border: 2px inset #919b8c;
  alternate-background-color: #f5f3ee;
  outline: none;
}
QListWidget::item { padding: 3px 8px; }
QListWidget::item:hover {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #d4eafa, stop:1 #c0dcf5);
}
QListWidget::item:selected {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #2468b8, stop:1 #1255a0);
  color: #ffffff;
}

/* Дерево */
QTreeWidget {
  background-color: #ffffff;
  color: #000000;
  border: 2px inset #919b8c;
  alternate-background-color: #f5f3ee;
  outline: none;
}
QTreeWidget::item { padding: 3px 4px; }
QTreeWidget::item:hover {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #d4eafa, stop:1 #c0dcf5);
}
QTreeWidget::item:selected {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #2468b8, stop:1 #1255a0);
  color: #ffffff;
}
QHeaderView::section {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #f0ece0, stop:1 #d8d4c8);
  color: #000000;
  padding: 4px 8px;
  border: 1px solid #919b8c;
  font-weight: bold;
  font-size: 11px;
}

/* Кнопки — XP зелёные с 3D рельефом */
QPushButton {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #78d840, stop:0.45 #50b820,
    stop:0.5  #3ea010, stop:1 #2e8808);
  color: #ffffff;
  border: 1px solid #2a7008;
  border-radius: 3px;
  padding: 5px 16px;
  font-weight: bold;
  font-size: 11px;
  min-height: 22px;
  text-shadow: 0 1px 0 rgba(0,0,0,0.4);
}
QPushButton:hover {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #90e850, stop:0.45 #68c830,
    stop:0.5 #50b020, stop:1 #3a9810);
  border-color: #3a9010;
}
QPushButton:pressed {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #2e8808, stop:1 #78d840);
  border-color: #207000;
}
QPushButton:disabled {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #c8c4b8, stop:1 #b8b4a8);
  color: #888880;
  border-color: #909090;
}

/* GroupBox */
QGroupBox {
  color: #1255a0;
  border: 1px solid #919b8c;
  border-radius: 0;
  margin-top: 12px;
  padding-top: 8px;
  font-weight: bold;
  font-size: 11px;
}
QGroupBox::title {
  subcontrol-origin: margin;
  left: 8px;
  padding: 0 4px;
  background: #ece9d8;
}

/* Скроллбары */
QScrollBar:vertical {
  background: #d8d4c8;
  width: 16px;
  border: 1px solid #919b8c;
}
QScrollBar::handle:vertical {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #e8e4d8, stop:0.5 #d0ccbf, stop:1 #c0bcb0);
  border: 1px solid #919b8c;
  min-height: 20px;
}
QScrollBar::handle:vertical:hover {
  background: qlineargradient(x1:0,y1:0,x2:1,y2:0,
    stop:0 #5090e0, stop:1 #2060c0);
}
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal {
  background: #d8d4c8;
  height: 16px;
  border: 1px solid #919b8c;
}
QScrollBar::handle:horizontal {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #e8e4d8, stop:0.5 #d0ccbf, stop:1 #c0bcb0);
  border: 1px solid #919b8c;
  min-width: 20px;
}
QScrollBar::handle:horizontal:hover {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #5090e0, stop:1 #2060c0);
}
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }

/* Dock */
QDockWidget::title {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #1c5ca8, stop:1 #0d4a8c);
  color: #ffffff;
  text-align: center;
  padding: 4px;
  border-bottom: 1px solid #0a3da0;
  font-weight: bold;
  font-size: 11px;
}

QSplitter::handle { background: #c0bcb0; border: 1px solid #919b8c; }
QSplitter::handle:hover {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #5090e0, stop:1 #2060c0);
}

QToolTip {
  background-color: #ffffcc;
  color: #000000;
  border: 1px solid #808080;
  padding: 3px 6px;
  font-size: 11px;
}
QScrollArea { border: none; background: #ece9d8; }
"""


const themeWindows7* = """
QMainWindow { background-color: #f0f0f0; }
QWidget { background-color: #ffffff; color: #000000; font-family: "Segoe UI",Arial,sans-serif; font-size: 13px; }

QMenuBar { background-color: qlineargradient(x1:0,y1:0,x2:0,y2:1, stop:0 #eaf3ff, stop:1 #d6e0f0); color: #000000; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #cce4ff; border-radius: 3px; }

QMenu { background-color: #ffffff; color: #000000; border: 1px solid #a0a0a0; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #3399ff; color: #ffffff; }
QMenu::separator { height: 1px; background: #d0d0d0; margin: 4px 8px; }

QToolBar { background-color: qlineargradient(x1:0,y1:0,x2:0,y2:1, stop:0 #f8fbff, stop:1 #e0e8f5); border-bottom: 1px solid #a0a0a0; spacing: 4px; padding: 3px 8px; }

QToolButton { color: #000000; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #eaf3ff; border: 1px solid #3399ff; }
QToolButton:pressed { background-color: #cce4ff; }

QStatusBar { background-color: #f0f6ff; color: #000000; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }

QTabWidget::pane { border: 1px solid #a0a0a0; background: #ffffff; }
QTabBar::tab { background: qlineargradient(x1:0,y1:0,x2:0,y2:1, stop:0 #f8fbff, stop:1 #e0e8f5); color: #000000; padding: 8px 20px; border: 1px solid #a0a0a0; border-bottom: none; margin-right: 2px; border-top-left-radius: 5px; border-top-right-radius: 5px; }
QTabBar::tab:selected { background: #ffffff; font-weight: bold; border-top: 2px solid #3399ff; }
QTabBar::tab:hover:!selected { background: #eaf3ff; }

QTextEdit, QLineEdit { background-color: #ffffff; color: #000000; border: 1px solid #a0a0a0; border-radius: 4px; padding: 6px; font-family: "Consolas","Courier New",monospace; font-size: 12px; selection-background-color: #3399ff; selection-color: #ffffff; }
QTextEdit:focus, QLineEdit:focus { border: 2px solid #3399ff; }

QListWidget, QTreeWidget { background-color: #ffffff; color: #000000; border: 1px solid #a0a0a0; border-radius: 4px; alternate-background-color: #f4f7fc; }
QListWidget::item:hover, QTreeWidget::item:hover { background-color: #eaf3ff; }
QListWidget::item:selected, QTreeWidget::item:selected { background-color: #3399ff; color: #ffffff; }

QHeaderView::section { background-color: #f0f6ff; color: #000000; padding: 6px 10px; border: 1px solid #a0a0a0; font-weight: bold; font-size: 12px; }

QPushButton { background-color: qlineargradient(x1:0,y1:0,x2:0,y2:1, stop:0 #ffffff, stop:1 #d6e0f0); color: #000000; border: 1px solid #a0a0a0; border-radius: 4px; padding: 7px 18px; font-weight: 500; min-height: 28px; }
QPushButton:hover { background-color: #eaf3ff; }
QPushButton:pressed { background-color: #cce4ff; }
QPushButton:disabled { background-color: #f0f0f0; color: #808080; }

QGroupBox { color: #3399ff; border: 1px solid #a0a0a0; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #ffffff; }

QScrollBar:vertical, QScrollBar:horizontal { background: #f0f6ff; border: 1px solid #a0a0a0; }
QScrollBar::handle:vertical, QScrollBar::handle:horizontal { background: #cce4ff; border-radius: 5px; }
QScrollBar::handle:vertical:hover, QScrollBar::handle:horizontal:hover { background: #3399ff; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }

QDockWidget::title { background: #f0f6ff; text-align: center; padding: 6px; border-bottom: 1px solid #a0a0a0; font-weight: bold; }

QSplitter::handle { background: #d0d8e8; }
QSplitter::handle:hover { background: #3399ff; }

QToolTip { background-color: #3399ff; color: #ffffff; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #ffffff; }
"""



const themeWindows10* = """
QMainWindow { background-color: #f3f3f3; }
QWidget { background-color: #ffffff; color: #000000; font-family: "Segoe UI",Arial,sans-serif; font-size: 13px; }

QMenuBar { background-color: #f3f3f3; color: #000000; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #e5e5e5; }

QMenu { background-color: #ffffff; color: #000000; border: 1px solid #cccccc; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; }
QMenu::item:selected { background-color: #0078d7; color: #ffffff; }
QMenu::separator { height: 1px; background: #e5e5e5; margin: 4px 8px; }

QToolBar { background-color: #f3f3f3; border-bottom: 1px solid #cccccc; spacing: 4px; padding: 3px 8px; }

QToolButton { color: #000000; background: transparent; border: none; border-radius: 2px; padding: 5px 10px; }
QToolButton:hover { background-color: #e5e5e5; }
QToolButton:pressed { background-color: #d0d0d0; }

QStatusBar { background-color: #f3f3f3; color: #000000; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }

QTabWidget::pane { border: 1px solid #cccccc; background: #ffffff; }
QTabBar::tab { background: #f3f3f3; color: #000000; padding: 8px 20px; border: 1px solid #cccccc; border-bottom: none; margin-right: 2px; }
QTabBar::tab:selected { background: #ffffff; color: #000000; font-weight: bold; border-top: 2px solid #0078d7; }
QTabBar::tab:hover:!selected { background: #e5e5e5; }

QTextEdit, QLineEdit { background-color: #ffffff; color: #000000; border: 1px solid #cccccc; border-radius: 2px; padding: 6px; font-family: "Consolas","Courier New",monospace; font-size: 12px; selection-background-color: #0078d7; selection-color: #ffffff; }
QTextEdit:focus, QLineEdit:focus { border: 2px solid #0078d7; }

QListWidget, QTreeWidget { background-color: #ffffff; color: #000000; border: 1px solid #cccccc; border-radius: 2px; alternate-background-color: #f9f9f9; }
QListWidget::item:hover, QTreeWidget::item:hover { background-color: #e5e5e5; }
QListWidget::item:selected, QTreeWidget::item:selected { background-color: #0078d7; color: #ffffff; }

QHeaderView::section { background-color: #f3f3f3; color: #000000; padding: 6px 10px; border: 1px solid #cccccc; font-weight: bold; font-size: 12px; }

QPushButton { background-color: #0078d7; color: #ffffff; border: none; border-radius: 2px; padding: 7px 18px; font-weight: 500; min-height: 28px; }
QPushButton:hover { background-color: #106ebe; }
QPushButton:pressed { background-color: #005a9e; }
QPushButton:disabled { background-color: #cccccc; color: #666666; }

QGroupBox { color: #0078d7; border: 1px solid #cccccc; border-radius: 4px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #ffffff; }

QScrollBar:vertical { background: #f3f3f3; width: 12px; border: 1px solid #cccccc; }
QScrollBar::handle:vertical { background: #cccccc; border-radius: 6px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #0078d7; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }

QScrollBar:horizontal { background: #f3f3f3; height: 12px; border: 1px solid #cccccc; }
QScrollBar::handle:horizontal { background: #cccccc; border-radius: 6px; min-width: 30px; }
QScrollBar::handle:horizontal:hover { background: #0078d7; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }

QDockWidget::title { background: #f3f3f3; text-align: center; padding: 6px; border-bottom: 1px solid #cccccc; font-weight: bold; }

QSplitter::handle { background: #e5e5e5; }
QSplitter::handle:hover { background: #0078d7; }

QToolTip { background-color: #333333; color: #ffffff; border: none; padding: 5px 10px; border-radius: 2px; }
QScrollArea { border: none; background: #ffffff; }
"""



const themeWindows11* = """
QMainWindow { background-color: #f3f3f3; border-radius: 8px; }
QWidget { background-color: #ffffff; color: #000000; font-family: "Segoe UI Variable","Segoe UI",sans-serif; font-size: 13px; border-radius: 8px; }

QMenuBar { background-color: #f9f9f9; color: #000000; padding: 4px; border-radius: 8px; }
QMenuBar::item { padding: 6px 14px; background: transparent; border-radius: 6px; }
QMenuBar::item:selected { background-color: #e5e5e5; }

QMenu { background-color: #ffffff; color: #000000; border: 1px solid #d0d0d0; border-radius: 8px; padding: 6px; }
QMenu::item { padding: 8px 28px 8px 14px; border-radius: 6px; }
QMenu::item:selected { background-color: #2563eb; color: #ffffff; }
QMenu::separator { height: 1px; background: #e0e0e0; margin: 6px 10px; }

QToolBar { background-color: #f9f9f9; border-bottom: 1px solid #d0d0d0; spacing: 6px; padding: 6px; border-radius: 8px; }

QToolButton { color: #000000; background: transparent; border: none; border-radius: 6px; padding: 6px 12px; }
QToolButton:hover { background-color: #e5e5e5; }
QToolButton:pressed { background-color: #d0d0d0; }

QStatusBar { background-color: #f9f9f9; color: #000000; padding: 4px 12px; font-size: 12px; border-radius: 8px; }
QStatusBar::item { border: none; }

QTabWidget::pane { border: 1px solid #d0d0d0; background: #ffffff; border-radius: 8px; }
QTabBar::tab { background: #f3f3f3; color: #000000; padding: 8px 20px; border: 1px solid #d0d0d0; border-bottom: none; margin-right: 4px; border-top-left-radius: 8px; border-top-right-radius: 8px; }
QTabBar::tab:selected { background: #ffffff; font-weight: 500; border-top: 2px solid #2563eb; }
QTabBar::tab:hover:!selected { background: #e5e5e5; }

QTextEdit, QLineEdit { background-color: #ffffff; color: #000000; border: 1px solid #d0d0d0; border-radius: 8px; padding: 8px; font-family: "Consolas","Courier New",monospace; font-size: 12px; selection-background-color: #2563eb; selection-color: #ffffff; }
QTextEdit:focus, QLineEdit:focus { border: 2px solid #2563eb; }

QListWidget, QTreeWidget { background-color: #ffffff; color: #000000; border: 1px solid #d0d0d0; border-radius: 8px; alternate-background-color: #f9f9f9; }
QListWidget::item:hover, QTreeWidget::item:hover { background-color: #e5e5e5; border-radius: 6px; }
QListWidget::item:selected, QTreeWidget::item:selected { background-color: #2563eb; color: #ffffff; border-radius: 6px; }

QHeaderView::section { background-color: #f9f9f9; color: #000000; padding: 6px 12px; border: 1px solid #d0d0d0; font-weight: 500; font-size: 12px; border-radius: 6px; }

QPushButton { background-color: #2563eb; color: #ffffff; border: none; border-radius: 8px; padding: 8px 20px; font-weight: 500; min-height: 32px; }
QPushButton:hover { background-color: #1e4fcf; }
QPushButton:pressed { background-color: #163fa3; }
QPushButton:disabled { background-color: #cccccc; color: #666666; }

QGroupBox { color: #2563eb; border: 1px solid #d0d0d0; border-radius: 8px; margin-top: 16px; padding-top: 12px; font-weight: 500; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 14px; padding: 0 8px; background: #ffffff; }

QScrollBar:vertical { background: #f3f3f3; width: 12px; border: 1px solid #d0d0d0; border-radius: 8px; }
QScrollBar::handle:vertical { background: #cccccc; border-radius: 8px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #2563eb; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }

QScrollBar:horizontal { background: #f3f3f3; height: 12px; border: 1px solid #d0d0d0; border-radius: 8px; }
QScrollBar::handle:horizontal { background: #cccccc; border-radius: 8px; min-width: 30px; }
QScrollBar::handle:horizontal:hover { background: #2563eb; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }

QDockWidget::title { background: #f9f9f9; text-align: center; padding: 6px; border-bottom: 1px solid #d0d0d0; font-weight: 500; border-radius: 8px; }

QSplitter::handle { background: #e5e5e5; border-radius: 8px; }
QSplitter::handle:hover { background: #2563eb; }

QToolTip { background-color: #333333; color: #ffffff; border: none; padding: 6px 12px; border-radius: 8px; }
QScrollArea { border: none; background: #ffffff; border-radius: 8px; }
"""


const themeMacOS* = """
/* macOS Monterey / Ventura
   Характерно: белый/светло-серый фон #f2f2f7, шрифт SF Pro,
   синие акценты #007aff, тонкие границы rgba, скругления,
   единый тулбар без резких границ, sidebar-стиль dock */

QMainWindow {
  background-color: #f2f2f7;
}
QWidget {
  background-color: #ffffff;
  color: #1c1c1e;
  font-family: "SF Pro Text", ".AppleSystemUIFont", "Helvetica Neue",
               "Segoe UI", Arial, sans-serif;
  font-size: 13px;
}

/* Менюбар — полупрозрачный светло-серый как macOS */
QMenuBar {
  background-color: #f2f2f7;
  color: #1c1c1e;
  border-bottom: 1px solid rgba(0,0,0,0.12);
  padding: 2px 6px;
  font-size: 13px;
  font-weight: 500;
}
QMenuBar::item {
  padding: 4px 10px;
  background: transparent;
  border-radius: 4px;
}
QMenuBar::item:selected {
  background-color: rgba(0,0,0,0.08);
  color: #1c1c1e;
}

/* Меню с тенью macOS-стиль */
QMenu {
  background-color: rgba(248,248,250,0.98);
  color: #1c1c1e;
  border: 1px solid rgba(0,0,0,0.15);
  border-radius: 8px;
  padding: 5px 0;
  font-size: 13px;
}
QMenu::item {
  padding: 6px 28px 6px 18px;
  border-radius: 4px;
  margin: 1px 5px;
}
QMenu::item:selected {
  background-color: #007aff;
  color: #ffffff;
}
QMenu::separator {
  height: 1px;
  background: rgba(0,0,0,0.1);
  margin: 4px 12px;
}

/* Тулбар — слитный с фоном окна */
QToolBar {
  background-color: #f2f2f7;
  border: none;
  border-bottom: 1px solid rgba(0,0,0,0.1);
  spacing: 4px;
  padding: 6px 10px;
}
QToolButton {
  color: #1c1c1e;
  background: transparent;
  border: none;
  border-radius: 6px;
  padding: 5px 12px;
  font-size: 13px;
  font-weight: 500;
}
QToolButton:hover {
  background-color: rgba(0,0,0,0.07);
}
QToolButton:pressed {
  background-color: rgba(0,0,0,0.14);
}

/* Статусбар */
QStatusBar {
  background-color: #f2f2f7;
  color: #6e6e73;
  border-top: 1px solid rgba(0,0,0,0.1);
  padding: 3px 12px;
  font-size: 11px;
}
QStatusBar::item { border: none; }

/* Вкладки — macOS Pills-стиль */
QTabWidget::pane {
  border: none;
  border-top: 1px solid rgba(0,0,0,0.1);
  background: #ffffff;
}
QTabBar::tab {
  background: transparent;
  color: #6e6e73;
  padding: 8px 20px;
  border: none;
  border-bottom: 2px solid transparent;
  margin-right: 2px;
  font-size: 13px;
  font-weight: 500;
}
QTabBar::tab:selected {
  color: #007aff;
  border-bottom: 2px solid #007aff;
  font-weight: 600;
  background: transparent;
}
QTabBar::tab:hover:!selected {
  color: #1c1c1e;
  background: rgba(0,0,0,0.04);
  border-radius: 6px 6px 0 0;
}

/* Текстовые поля */
QTextEdit {
  background-color: #ffffff;
  color: #1c1c1e;
  border: 1px solid rgba(0,0,0,0.15);
  border-radius: 8px;
  padding: 8px;
  font-family: "SF Mono", "Menlo", "Monaco", "Courier New", monospace;
  font-size: 12px;
  selection-background-color: #007aff;
  selection-color: #ffffff;
}
QTextEdit:focus {
  border: 2px solid #007aff;
  outline: 3px solid rgba(0,122,255,0.25);
}
QLineEdit {
  background-color: #ffffff;
  color: #1c1c1e;
  border: 1px solid rgba(0,0,0,0.2);
  border-radius: 8px;
  padding: 7px 10px;
  font-size: 13px;
  selection-background-color: #007aff;
  selection-color: #ffffff;
}
QLineEdit:focus {
  border: 2px solid #007aff;
}
QLineEdit:hover { border-color: rgba(0,0,0,0.3); }

/* Список — macOS Sidebar-стиль */
QListWidget {
  background-color: #ffffff;
  color: #1c1c1e;
  border: 1px solid rgba(0,0,0,0.12);
  border-radius: 10px;
  outline: none;
  alternate-background-color: rgba(0,0,0,0.02);
}
QListWidget::item {
  padding: 8px 14px;
  border-radius: 8px;
  margin: 2px 5px;
}
QListWidget::item:hover {
  background-color: rgba(0,0,0,0.05);
}
QListWidget::item:selected {
  background-color: #007aff;
  color: #ffffff;
  border-radius: 8px;
}

/* Дерево */
QTreeWidget {
  background-color: #ffffff;
  color: #1c1c1e;
  border: 1px solid rgba(0,0,0,0.12);
  border-radius: 10px;
  outline: none;
  alternate-background-color: rgba(0,0,0,0.02);
}
QTreeWidget::item {
  padding: 5px 6px;
  border-radius: 6px;
}
QTreeWidget::item:hover {
  background-color: rgba(0,0,0,0.05);
}
QTreeWidget::item:selected {
  background-color: #007aff;
  color: #ffffff;
}
QHeaderView::section {
  background-color: rgba(242,242,247,0.9);
  color: #6e6e73;
  padding: 6px 12px;
  border: none;
  border-bottom: 1px solid rgba(0,0,0,0.1);
  border-right: 1px solid rgba(0,0,0,0.06);
  font-weight: 600;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Кнопки — macOS aqua blue */
QPushButton {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #42a2ff, stop:1 #007aff);
  color: #ffffff;
  border: 1px solid rgba(0,60,200,0.3);
  border-radius: 7px;
  padding: 7px 20px;
  font-weight: 600;
  font-size: 13px;
  min-height: 28px;
}
QPushButton:hover {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #60b4ff, stop:1 #1a8fff);
  border-color: rgba(0,60,200,0.4);
}
QPushButton:pressed {
  background: qlineargradient(x1:0,y1:0,x2:0,y2:1,
    stop:0 #0060d0, stop:1 #0070e8);
}
QPushButton:disabled {
  background: rgba(0,0,0,0.08);
  color: rgba(0,0,0,0.26);
  border: 1px solid rgba(0,0,0,0.1);
}

/* GroupBox */
QGroupBox {
  color: #007aff;
  border: 1px solid rgba(0,0,0,0.12);
  border-radius: 10px;
  margin-top: 14px;
  padding-top: 10px;
  font-weight: 600;
  font-size: 12px;
  background: rgba(0,0,0,0.01);
}
QGroupBox::title {
  subcontrol-origin: margin;
  left: 14px;
  padding: 0 6px;
  background: #ffffff;
}

/* Скроллбары — macOS overlay style */
QScrollBar:vertical {
  background: transparent;
  width: 8px;
  border-radius: 4px;
  margin: 2px;
}
QScrollBar::handle:vertical {
  background: rgba(0,0,0,0.25);
  border-radius: 4px;
  min-height: 30px;
}
QScrollBar::handle:vertical:hover {
  background: rgba(0,0,0,0.45);
}
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal {
  background: transparent;
  height: 8px;
  border-radius: 4px;
  margin: 2px;
}
QScrollBar::handle:horizontal {
  background: rgba(0,0,0,0.25);
  border-radius: 4px;
  min-width: 30px;
}
QScrollBar::handle:horizontal:hover { background: rgba(0,0,0,0.45); }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }

/* Dock — macOS sidebar */
QDockWidget::title {
  background: #f2f2f7;
  color: #1c1c1e;
  text-align: center;
  padding: 6px;
  border-bottom: 1px solid rgba(0,0,0,0.1);
  font-weight: 600;
  font-size: 12px;
}
QDockWidget {
  color: #1c1c1e;
  font-size: 13px;
}

QSplitter::handle { background: rgba(0,0,0,0.08); }
QSplitter::handle:hover { background: #007aff; }

QFrame[frameShape="4"],
QFrame[frameShape="5"] {
  color: rgba(0,0,0,0.1);
  background: rgba(0,0,0,0.1);
}

QToolTip {
  background-color: rgba(50,50,50,0.95);
  color: #ffffff;
  border: none;
  padding: 5px 10px;
  border-radius: 6px;
  font-size: 12px;
}
QScrollArea { border: none; background: #ffffff; }
"""


const themeClassicBlue* = """
QMainWindow { background-color: #f0f0f0; }
QWidget { background-color: #ffffff; color: #1a1a1a; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #2c5f9e; color: #ffffff; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #1a4a82; border-radius: 3px; }
QMenu { background-color: #ffffff; color: #1a1a1a; border: 1px solid #b0b8c8; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #2c5f9e; color: #ffffff; }
QMenu::separator { height: 1px; background: #d0d8e8; margin: 4px 8px; }
QToolBar { background-color: #e8edf5; border-bottom: 2px solid #2c5f9e; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #1a1a1a; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #d0ddef; border-color: #2c5f9e; color: #2c5f9e; }
QToolButton:pressed { background-color: #b8ccdf; }
QStatusBar { background-color: #2c5f9e; color: #ffffff; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #b0b8c8; border-top: 2px solid #2c5f9e; background: #ffffff; }
QTabBar::tab { background: #d8e2f0; color: #4a5568; padding: 8px 20px; border: 1px solid #b0b8c8; border-bottom: none; border-top-left-radius: 5px; border-top-right-radius: 5px; margin-right: 2px; }
QTabBar::tab:selected { background: #ffffff; color: #1a1a1a; font-weight: bold; border-top: 2px solid #2c5f9e; border-bottom-color: #ffffff; }
QTabBar::tab:hover:!selected { background: #c4d4e8; }
QTextEdit { background-color: #ffffff; color: #1a1a1a; border: 1px solid #b0b8c8; border-radius: 4px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #2c5f9e; selection-color: #ffffff; }
QTextEdit:focus { border: 2px solid #2c5f9e; }
QLineEdit { background-color: #ffffff; color: #1a1a1a; border: 1px solid #b0b8c8; border-radius: 4px; padding: 6px 8px; selection-background-color: #2c5f9e; selection-color: #ffffff; }
QLineEdit:focus { border: 2px solid #2c5f9e; }
QListWidget { background-color: #ffffff; color: #1a1a1a; border: 1px solid #b0b8c8; border-radius: 4px; outline: none; alternate-background-color: #f4f7fc; }
QListWidget::item { padding: 8px 12px; border-radius: 3px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #e4edf8; }
QListWidget::item:selected { background-color: #2c5f9e; color: #ffffff; font-weight: 500; }
QTreeWidget { background-color: #ffffff; color: #1a1a1a; border: 1px solid #b0b8c8; border-radius: 4px; outline: none; alternate-background-color: #f4f7fc; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #e4edf8; }
QTreeWidget::item:selected { background-color: #2c5f9e; color: #ffffff; }
QHeaderView::section { background-color: #e8edf5; color: #1a1a1a; padding: 6px 10px; border: none; border-right: 1px solid #b0b8c8; border-bottom: 2px solid #2c5f9e; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #2c5f9e; color: #ffffff; border: none; border-radius: 5px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #3a70b5; }
QPushButton:pressed { background-color: #1a4a82; }
QPushButton:disabled { background-color: #c0c8d8; color: #808898; }
QGroupBox { color: #2c5f9e; border: 1.5px solid #b0b8c8; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #ffffff; }
QScrollBar:vertical { background: #f0f4fa; width: 12px; border-radius: 6px; border: 1px solid #d8e0ec; }
QScrollBar::handle:vertical { background: #9ab0cc; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #2c5f9e; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #f0f4fa; height: 12px; border-radius: 6px; border: 1px solid #d8e0ec; }
QScrollBar::handle:horizontal { background: #9ab0cc; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #e8edf5; text-align: center; padding: 6px; border-bottom: 2px solid #2c5f9e; font-weight: bold; }
QSplitter::handle { background: #d0d8e8; }
QSplitter::handle:hover { background: #2c5f9e; }
QToolTip { background-color: #1a3a6e; color: #ffffff; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #ffffff; }
"""






const themeForestGreen* = """
QMainWindow { background-color: #eef2ee; }
QWidget { background-color: #f8faf8; color: #1a2a1a; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #2d6a2d; color: #ffffff; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #1e4d1e; border-radius: 3px; }
QMenu { background-color: #f8faf8; color: #1a2a1a; border: 1px solid #aac4aa; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #2d6a2d; color: #ffffff; }
QMenu::separator { height: 1px; background: #c8d8c8; margin: 4px 8px; }
QToolBar { background-color: #ddeedd; border-bottom: 2px solid #2d6a2d; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #1a2a1a; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #c8e0c8; border-color: #2d6a2d; }
QToolButton:pressed { background-color: #b0ccb0; }
QStatusBar { background-color: #2d6a2d; color: #ffffff; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #aac4aa; border-top: 2px solid #2d6a2d; background: #f8faf8; }
QTabBar::tab { background: #cce0cc; color: #2a4a2a; padding: 8px 20px; border: 1px solid #aac4aa; border-bottom: none; border-top-left-radius: 5px; border-top-right-radius: 5px; margin-right: 2px; }
QTabBar::tab:selected { background: #f8faf8; color: #1a2a1a; font-weight: bold; border-top: 2px solid #2d6a2d; border-bottom-color: #f8faf8; }
QTabBar::tab:hover:!selected { background: #b8d4b8; }
QTextEdit { background-color: #f8faf8; color: #1a2a1a; border: 1px solid #aac4aa; border-radius: 4px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #2d6a2d; selection-color: #ffffff; }
QTextEdit:focus { border: 2px solid #2d6a2d; }
QLineEdit { background-color: #ffffff; color: #1a2a1a; border: 1px solid #aac4aa; border-radius: 4px; padding: 6px 8px; selection-background-color: #2d6a2d; selection-color: #ffffff; }
QLineEdit:focus { border: 2px solid #2d6a2d; }
QListWidget { background-color: #f8faf8; color: #1a2a1a; border: 1px solid #aac4aa; border-radius: 4px; outline: none; alternate-background-color: #eef4ee; }
QListWidget::item { padding: 8px 12px; border-radius: 3px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #d8eed8; }
QListWidget::item:selected { background-color: #2d6a2d; color: #ffffff; }
QTreeWidget { background-color: #f8faf8; color: #1a2a1a; border: 1px solid #aac4aa; border-radius: 4px; outline: none; alternate-background-color: #eef4ee; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #d8eed8; }
QTreeWidget::item:selected { background-color: #2d6a2d; color: #ffffff; }
QHeaderView::section { background-color: #ddeedd; color: #1a2a1a; padding: 6px 10px; border: none; border-right: 1px solid #aac4aa; border-bottom: 2px solid #2d6a2d; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #2d6a2d; color: #ffffff; border: none; border-radius: 5px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #3a803a; }
QPushButton:pressed { background-color: #1e4d1e; }
QPushButton:disabled { background-color: #b8c8b8; color: #7a8a7a; }
QGroupBox { color: #2d6a2d; border: 1.5px solid #aac4aa; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #f8faf8; }
QScrollBar:vertical { background: #eef4ee; width: 12px; border-radius: 6px; border: 1px solid #c0d4c0; }
QScrollBar::handle:vertical { background: #88b888; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #2d6a2d; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #eef4ee; height: 12px; border-radius: 6px; border: 1px solid #c0d4c0; }
QScrollBar::handle:horizontal { background: #88b888; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #ddeedd; text-align: center; padding: 6px; border-bottom: 2px solid #2d6a2d; font-weight: bold; }
QSplitter::handle { background: #c0d8c0; }
QSplitter::handle:hover { background: #2d6a2d; }
QToolTip { background-color: #1a4a1a; color: #ffffff; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #f8faf8; }
"""

const themeCrimson* = """
QMainWindow { background-color: #f5f0f0; }
QWidget { background-color: #ffffff; color: #1a0a0a; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #9b1c1c; color: #ffffff; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #7a1414; border-radius: 3px; }
QMenu { background-color: #ffffff; color: #1a0a0a; border: 1px solid #d4b0b0; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #9b1c1c; color: #ffffff; }
QMenu::separator { height: 1px; background: #e8d0d0; margin: 4px 8px; }
QToolBar { background-color: #f5e8e8; border-bottom: 2px solid #9b1c1c; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #1a0a0a; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #edd8d8; border-color: #9b1c1c; }
QToolButton:pressed { background-color: #ddc0c0; }
QStatusBar { background-color: #9b1c1c; color: #ffffff; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #d4b0b0; border-top: 2px solid #9b1c1c; background: #ffffff; }
QTabBar::tab { background: #f0d8d8; color: #5a2a2a; padding: 8px 20px; border: 1px solid #d4b0b0; border-bottom: none; border-top-left-radius: 5px; border-top-right-radius: 5px; margin-right: 2px; }
QTabBar::tab:selected { background: #ffffff; color: #1a0a0a; font-weight: bold; border-top: 2px solid #9b1c1c; border-bottom-color: #ffffff; }
QTabBar::tab:hover:!selected { background: #e4c4c4; }
QTextEdit { background-color: #ffffff; color: #1a0a0a; border: 1px solid #d4b0b0; border-radius: 4px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #9b1c1c; selection-color: #ffffff; }
QTextEdit:focus { border: 2px solid #9b1c1c; }
QLineEdit { background-color: #ffffff; color: #1a0a0a; border: 1px solid #d4b0b0; border-radius: 4px; padding: 6px 8px; selection-background-color: #9b1c1c; selection-color: #ffffff; }
QLineEdit:focus { border: 2px solid #9b1c1c; }
QListWidget { background-color: #ffffff; color: #1a0a0a; border: 1px solid #d4b0b0; border-radius: 4px; outline: none; alternate-background-color: #fdf5f5; }
QListWidget::item { padding: 8px 12px; border-radius: 3px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #f4e0e0; }
QListWidget::item:selected { background-color: #9b1c1c; color: #ffffff; }
QTreeWidget { background-color: #ffffff; color: #1a0a0a; border: 1px solid #d4b0b0; border-radius: 4px; outline: none; alternate-background-color: #fdf5f5; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #f4e0e0; }
QTreeWidget::item:selected { background-color: #9b1c1c; color: #ffffff; }
QHeaderView::section { background-color: #f5e8e8; color: #1a0a0a; padding: 6px 10px; border: none; border-right: 1px solid #d4b0b0; border-bottom: 2px solid #9b1c1c; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #9b1c1c; color: #ffffff; border: none; border-radius: 5px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #b52424; }
QPushButton:pressed { background-color: #7a1414; }
QPushButton:disabled { background-color: #d8c4c4; color: #907070; }
QGroupBox { color: #9b1c1c; border: 1.5px solid #d4b0b0; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #ffffff; }
QScrollBar:vertical { background: #faf0f0; width: 12px; border-radius: 6px; border: 1px solid #e0c8c8; }
QScrollBar::handle:vertical { background: #cc9898; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #9b1c1c; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #faf0f0; height: 12px; border-radius: 6px; border: 1px solid #e0c8c8; }
QScrollBar::handle:horizontal { background: #cc9898; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #f5e8e8; text-align: center; padding: 6px; border-bottom: 2px solid #9b1c1c; font-weight: bold; }
QSplitter::handle { background: #e0c8c8; }
QSplitter::handle:hover { background: #9b1c1c; }
QToolTip { background-color: #6a0f0f; color: #ffffff; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #ffffff; }
"""

const themeSolarized* = """
QMainWindow { background-color: #eee8d5; }
QWidget { background-color: #fdf6e3; color: #586e75; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #657b83; color: #fdf6e3; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #586e75; border-radius: 3px; }
QMenu { background-color: #fdf6e3; color: #586e75; border: 1px solid #c3b99a; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #268bd2; color: #fdf6e3; }
QMenu::separator { height: 1px; background: #d8d0b8; margin: 4px 8px; }
QToolBar { background-color: #eee8d5; border-bottom: 2px solid #268bd2; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #586e75; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #ddd8c4; border-color: #268bd2; }
QToolButton:pressed { background-color: #ccc8b0; }
QStatusBar { background-color: #657b83; color: #fdf6e3; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #c3b99a; border-top: 2px solid #268bd2; background: #fdf6e3; }
QTabBar::tab { background: #e8e2ce; color: #7a8a8e; padding: 8px 20px; border: 1px solid #c3b99a; border-bottom: none; border-top-left-radius: 5px; border-top-right-radius: 5px; margin-right: 2px; }
QTabBar::tab:selected { background: #fdf6e3; color: #586e75; font-weight: bold; border-top: 2px solid #268bd2; border-bottom-color: #fdf6e3; }
QTabBar::tab:hover:!selected { background: #ddd8c4; }
QTextEdit { background-color: #fdf6e3; color: #586e75; border: 1px solid #c3b99a; border-radius: 4px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #268bd2; selection-color: #fdf6e3; }
QTextEdit:focus { border: 2px solid #268bd2; }
QLineEdit { background-color: #fdf6e3; color: #586e75; border: 1px solid #c3b99a; border-radius: 4px; padding: 6px 8px; selection-background-color: #268bd2; selection-color: #fdf6e3; }
QLineEdit:focus { border: 2px solid #268bd2; }
QListWidget { background-color: #fdf6e3; color: #586e75; border: 1px solid #c3b99a; border-radius: 4px; outline: none; alternate-background-color: #f5f0e0; }
QListWidget::item { padding: 8px 12px; border-radius: 3px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #e8e2ce; }
QListWidget::item:selected { background-color: #268bd2; color: #fdf6e3; }
QTreeWidget { background-color: #fdf6e3; color: #586e75; border: 1px solid #c3b99a; border-radius: 4px; outline: none; alternate-background-color: #f5f0e0; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #e8e2ce; }
QTreeWidget::item:selected { background-color: #268bd2; color: #fdf6e3; }
QHeaderView::section { background-color: #eee8d5; color: #586e75; padding: 6px 10px; border: none; border-right: 1px solid #c3b99a; border-bottom: 2px solid #268bd2; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #268bd2; color: #fdf6e3; border: none; border-radius: 5px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #359ade; }
QPushButton:pressed { background-color: #1a6fa8; }
QPushButton:disabled { background-color: #c8c0a8; color: #9a9080; }
QGroupBox { color: #268bd2; border: 1.5px solid #c3b99a; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #fdf6e3; }
QScrollBar:vertical { background: #eee8d5; width: 12px; border-radius: 6px; border: 1px solid #ccc5b0; }
QScrollBar::handle:vertical { background: #a8a090; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #268bd2; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #eee8d5; height: 12px; border-radius: 6px; border: 1px solid #ccc5b0; }
QScrollBar::handle:horizontal { background: #a8a090; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #eee8d5; text-align: center; padding: 6px; border-bottom: 2px solid #268bd2; font-weight: bold; }
QSplitter::handle { background: #d0c8b0; }
QSplitter::handle:hover { background: #268bd2; }
QToolTip { background-color: #475e66; color: #fdf6e3; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #fdf6e3; }
"""

const themeGitHub* = """
QMainWindow { background-color: #f6f8fa; }
QWidget { background-color: #ffffff; color: #24292f; font-family: "Segoe UI","Noto Sans",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #24292f; color: #f0f6fc; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #3d444d; border-radius: 3px; }
QMenu { background-color: #ffffff; color: #24292f; border: 1px solid #d0d7de; border-radius: 6px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #0969da; color: #ffffff; }
QMenu::separator { height: 1px; background: #d8dee4; margin: 4px 8px; }
QToolBar { background-color: #f6f8fa; border-bottom: 1px solid #d0d7de; spacing: 4px; padding: 4px 8px; }
QToolButton { color: #24292f; background: transparent; border: 1px solid transparent; border-radius: 6px; padding: 5px 10px; }
QToolButton:hover { background-color: #eaeef2; border-color: #d0d7de; }
QToolButton:pressed { background-color: #d0d7de; }
QStatusBar { background-color: #24292f; color: #f0f6fc; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #d0d7de; background: #ffffff; }
QTabBar::tab { background: #f6f8fa; color: #57606a; padding: 8px 20px; border: 1px solid #d0d7de; border-bottom: none; border-top-left-radius: 6px; border-top-right-radius: 6px; margin-right: 2px; }
QTabBar::tab:selected { background: #ffffff; color: #24292f; font-weight: bold; border-bottom: 2px solid #fd8c73; border-bottom-color: #fd8c73; }
QTabBar::tab:hover:!selected { background: #eaeef2; }
QTextEdit { background-color: #ffffff; color: #24292f; border: 1px solid #d0d7de; border-radius: 6px; padding: 6px; font-family: "JetBrains Mono","Cascadia Code","Courier New",monospace; font-size: 12px; selection-background-color: #0969da; selection-color: #ffffff; }
QTextEdit:focus { border: 2px solid #0969da; }
QLineEdit { background-color: #ffffff; color: #24292f; border: 1px solid #d0d7de; border-radius: 6px; padding: 6px 8px; selection-background-color: #0969da; selection-color: #ffffff; }
QLineEdit:focus { border: 2px solid #0969da; }
QListWidget { background-color: #ffffff; color: #24292f; border: 1px solid #d0d7de; border-radius: 6px; outline: none; alternate-background-color: #f6f8fa; }
QListWidget::item { padding: 8px 12px; border-radius: 6px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #f3f4f6; }
QListWidget::item:selected { background-color: #dbeafe; color: #0969da; font-weight: 600; }
QTreeWidget { background-color: #ffffff; color: #24292f; border: 1px solid #d0d7de; border-radius: 6px; outline: none; alternate-background-color: #f6f8fa; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #f3f4f6; }
QTreeWidget::item:selected { background-color: #dbeafe; color: #0969da; }
QHeaderView::section { background-color: #f6f8fa; color: #24292f; padding: 6px 10px; border: none; border-right: 1px solid #d0d7de; border-bottom: 1px solid #d0d7de; font-weight: 600; font-size: 12px; }
QPushButton { background-color: #0969da; color: #ffffff; border: none; border-radius: 6px; padding: 7px 18px; font-weight: 600; min-height: 28px; }
QPushButton:hover { background-color: #0860c8; }
QPushButton:pressed { background-color: #0550ae; }
QPushButton:disabled { background-color: #c8d4e0; color: #8a9ab0; }
QGroupBox { color: #0969da; border: 1px solid #d0d7de; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #ffffff; }
QScrollBar:vertical { background: #f6f8fa; width: 12px; border-radius: 6px; border: 1px solid #d0d7de; }
QScrollBar::handle:vertical { background: #b0bcc8; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #0969da; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #f6f8fa; height: 12px; border-radius: 6px; border: 1px solid #d0d7de; }
QScrollBar::handle:horizontal { background: #b0bcc8; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #f6f8fa; text-align: center; padding: 6px; border-bottom: 1px solid #d0d7de; font-weight: bold; }
QSplitter::handle { background: #d0d7de; }
QSplitter::handle:hover { background: #0969da; }
QToolTip { background-color: #1b1f23; color: #f0f6fc; border: none; padding: 5px 10px; border-radius: 6px; }
QScrollArea { border: none; background: #ffffff; }
"""

const themeNord* = """
QMainWindow { background-color: #d8dee9; }
QWidget { background-color: #eceff4; color: #2e3440; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #3b4252; color: #eceff4; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #434c5e; border-radius: 3px; }
QMenu { background-color: #eceff4; color: #2e3440; border: 1px solid #c0c8d8; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #5e81ac; color: #eceff4; }
QMenu::separator { height: 1px; background: #d0d8e8; margin: 4px 8px; }
QToolBar { background-color: #e5e9f0; border-bottom: 2px solid #5e81ac; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #2e3440; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #d8dee9; border-color: #5e81ac; }
QToolButton:pressed { background-color: #c8d0e0; }
QStatusBar { background-color: #3b4252; color: #eceff4; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #c0c8d8; border-top: 2px solid #5e81ac; background: #eceff4; }
QTabBar::tab { background: #dde3ec; color: #4c566a; padding: 8px 20px; border: 1px solid #c0c8d8; border-bottom: none; border-top-left-radius: 5px; border-top-right-radius: 5px; margin-right: 2px; }
QTabBar::tab:selected { background: #eceff4; color: #2e3440; font-weight: bold; border-top: 2px solid #5e81ac; border-bottom-color: #eceff4; }
QTabBar::tab:hover:!selected { background: #d0d8e8; }
QTextEdit { background-color: #eceff4; color: #2e3440; border: 1px solid #c0c8d8; border-radius: 4px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #5e81ac; selection-color: #eceff4; }
QTextEdit:focus { border: 2px solid #5e81ac; }
QLineEdit { background-color: #ffffff; color: #2e3440; border: 1px solid #c0c8d8; border-radius: 4px; padding: 6px 8px; selection-background-color: #5e81ac; selection-color: #eceff4; }
QLineEdit:focus { border: 2px solid #5e81ac; }
QListWidget { background-color: #eceff4; color: #2e3440; border: 1px solid #c0c8d8; border-radius: 4px; outline: none; alternate-background-color: #e5e9f0; }
QListWidget::item { padding: 8px 12px; border-radius: 3px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #d8dee9; }
QListWidget::item:selected { background-color: #5e81ac; color: #eceff4; }
QTreeWidget { background-color: #eceff4; color: #2e3440; border: 1px solid #c0c8d8; border-radius: 4px; outline: none; alternate-background-color: #e5e9f0; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #d8dee9; }
QTreeWidget::item:selected { background-color: #5e81ac; color: #eceff4; }
QHeaderView::section { background-color: #e5e9f0; color: #2e3440; padding: 6px 10px; border: none; border-right: 1px solid #c0c8d8; border-bottom: 2px solid #5e81ac; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #5e81ac; color: #eceff4; border: none; border-radius: 5px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #6d92bc; }
QPushButton:pressed { background-color: #4a6e9a; }
QPushButton:disabled { background-color: #c0c8d8; color: #8090a0; }
QGroupBox { color: #5e81ac; border: 1.5px solid #c0c8d8; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #eceff4; }
QScrollBar:vertical { background: #e5e9f0; width: 12px; border-radius: 6px; border: 1px solid #c8d0e0; }
QScrollBar::handle:vertical { background: #9aa8bc; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #5e81ac; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #e5e9f0; height: 12px; border-radius: 6px; border: 1px solid #c8d0e0; }
QScrollBar::handle:horizontal { background: #9aa8bc; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #e5e9f0; text-align: center; padding: 6px; border-bottom: 2px solid #5e81ac; font-weight: bold; }
QSplitter::handle { background: #c8d0e0; }
QSplitter::handle:hover { background: #5e81ac; }
QToolTip { background-color: #2e3440; color: #eceff4; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #eceff4; }
"""

const themeAmber* = """
QMainWindow { background-color: #f5f0e8; }
QWidget { background-color: #fffdf5; color: #1a1400; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #b45309; color: #ffffff; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #92400e; border-radius: 3px; }
QMenu { background-color: #fffdf5; color: #1a1400; border: 1px solid #d4b87a; border-radius: 4px; padding: 4px; }
QMenu::item { padding: 7px 30px 7px 16px; border-radius: 3px; }
QMenu::item:selected { background-color: #b45309; color: #ffffff; }
QMenu::separator { height: 1px; background: #e8d8a8; margin: 4px 8px; }
QToolBar { background-color: #fef3c7; border-bottom: 2px solid #b45309; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #1a1400; background: transparent; border: 1px solid transparent; border-radius: 4px; padding: 5px 10px; }
QToolButton:hover { background-color: #fde68a; border-color: #b45309; }
QToolButton:pressed { background-color: #fcd34d; }
QStatusBar { background-color: #b45309; color: #ffffff; padding: 3px 10px; font-size: 12px; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 1px solid #d4b87a; border-top: 2px solid #b45309; background: #fffdf5; }
QTabBar::tab { background: #fef3c7; color: #6a4800; padding: 8px 20px; border: 1px solid #d4b87a; border-bottom: none; border-top-left-radius: 5px; border-top-right-radius: 5px; margin-right: 2px; }
QTabBar::tab:selected { background: #fffdf5; color: #1a1400; font-weight: bold; border-top: 2px solid #b45309; border-bottom-color: #fffdf5; }
QTabBar::tab:hover:!selected { background: #fde68a; }
QTextEdit { background-color: #fffdf5; color: #1a1400; border: 1px solid #d4b87a; border-radius: 4px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #b45309; selection-color: #ffffff; }
QTextEdit:focus { border: 2px solid #b45309; }
QLineEdit { background-color: #ffffff; color: #1a1400; border: 1px solid #d4b87a; border-radius: 4px; padding: 6px 8px; selection-background-color: #b45309; selection-color: #ffffff; }
QLineEdit:focus { border: 2px solid #b45309; }
QListWidget { background-color: #fffdf5; color: #1a1400; border: 1px solid #d4b87a; border-radius: 4px; outline: none; alternate-background-color: #fef9ea; }
QListWidget::item { padding: 8px 12px; border-radius: 3px; margin: 1px 3px; }
QListWidget::item:hover { background-color: #fef3c7; }
QListWidget::item:selected { background-color: #b45309; color: #ffffff; }
QTreeWidget { background-color: #fffdf5; color: #1a1400; border: 1px solid #d4b87a; border-radius: 4px; outline: none; alternate-background-color: #fef9ea; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #fef3c7; }
QTreeWidget::item:selected { background-color: #b45309; color: #ffffff; }
QHeaderView::section { background-color: #fef3c7; color: #1a1400; padding: 6px 10px; border: none; border-right: 1px solid #d4b87a; border-bottom: 2px solid #b45309; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #b45309; color: #ffffff; border: none; border-radius: 5px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #c96010; }
QPushButton:pressed { background-color: #92400e; }
QPushButton:disabled { background-color: #e0d0a8; color: #9a8858; }
QGroupBox { color: #b45309; border: 1.5px solid #d4b87a; border-radius: 6px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #fffdf5; }
QScrollBar:vertical { background: #fef9ea; width: 12px; border-radius: 6px; border: 1px solid #e0c888; }
QScrollBar::handle:vertical { background: #c8a850; border-radius: 5px; min-height: 30px; }
QScrollBar::handle:vertical:hover { background: #b45309; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #fef9ea; height: 12px; border-radius: 6px; border: 1px solid #e0c888; }
QScrollBar::handle:horizontal { background: #c8a850; border-radius: 5px; min-width: 30px; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #fef3c7; text-align: center; padding: 6px; border-bottom: 2px solid #b45309; font-weight: bold; }
QSplitter::handle { background: #e0c888; }
QSplitter::handle:hover { background: #b45309; }
QToolTip { background-color: #6a3200; color: #ffffff; border: none; padding: 5px 10px; border-radius: 4px; }
QScrollArea { border: none; background: #fffdf5; }
"""

const themeHighContrast* = """
QMainWindow { background-color: #000000; }
QWidget { background-color: #ffffff; color: #000000; font-family: "Noto Sans","Segoe UI",Arial,sans-serif; font-size: 13px; }
QMenuBar { background-color: #000000; color: #ffffff; padding: 2px; }
QMenuBar::item { padding: 5px 12px; background: transparent; }
QMenuBar::item:selected { background-color: #0050c8; border-radius: 3px; }
QMenu { background-color: #ffffff; color: #000000; border: 2px solid #000000; border-radius: 0; padding: 2px; }
QMenu::item { padding: 7px 30px 7px 16px; }
QMenu::item:selected { background-color: #0050c8; color: #ffffff; }
QMenu::separator { height: 2px; background: #000000; margin: 2px 0; }
QToolBar { background-color: #e8e8e8; border-bottom: 3px solid #000000; spacing: 4px; padding: 3px 8px; }
QToolButton { color: #000000; background: transparent; border: 2px solid transparent; border-radius: 3px; padding: 5px 10px; font-weight: bold; }
QToolButton:hover { background-color: #d0d0d0; border-color: #000000; }
QToolButton:pressed { background-color: #b0b0b0; }
QStatusBar { background-color: #000000; color: #ffffff; padding: 3px 10px; font-size: 12px; font-weight: bold; }
QStatusBar::item { border: none; }
QTabWidget::pane { border: 2px solid #000000; background: #ffffff; }
QTabBar::tab { background: #e0e0e0; color: #000000; padding: 8px 20px; border: 2px solid #000000; border-bottom: none; border-top-left-radius: 4px; border-top-right-radius: 4px; margin-right: 2px; font-weight: bold; }
QTabBar::tab:selected { background: #ffffff; border-top: 3px solid #0050c8; border-bottom-color: #ffffff; }
QTabBar::tab:hover:!selected { background: #c8c8c8; }
QTextEdit { background-color: #ffffff; color: #000000; border: 2px solid #000000; border-radius: 3px; padding: 6px; font-family: "JetBrains Mono","Courier New",monospace; font-size: 12px; selection-background-color: #0050c8; selection-color: #ffffff; }
QTextEdit:focus { border: 2px solid #0050c8; }
QLineEdit { background-color: #ffffff; color: #000000; border: 2px solid #000000; border-radius: 3px; padding: 6px 8px; selection-background-color: #0050c8; selection-color: #ffffff; }
QLineEdit:focus { border: 2px solid #0050c8; }
QListWidget { background-color: #ffffff; color: #000000; border: 2px solid #000000; border-radius: 3px; outline: none; alternate-background-color: #f0f0f0; }
QListWidget::item { padding: 8px 12px; margin: 0; border-bottom: 1px solid #d0d0d0; }
QListWidget::item:hover { background-color: #e0e8f8; }
QListWidget::item:selected { background-color: #0050c8; color: #ffffff; font-weight: bold; }
QTreeWidget { background-color: #ffffff; color: #000000; border: 2px solid #000000; border-radius: 3px; outline: none; alternate-background-color: #f0f0f0; }
QTreeWidget::item { padding: 5px 6px; }
QTreeWidget::item:hover { background-color: #e0e8f8; }
QTreeWidget::item:selected { background-color: #0050c8; color: #ffffff; font-weight: bold; }
QHeaderView::section { background-color: #000000; color: #ffffff; padding: 6px 10px; border: none; border-right: 1px solid #555555; border-bottom: 1px solid #555555; font-weight: bold; font-size: 12px; }
QPushButton { background-color: #000000; color: #ffffff; border: 2px solid #000000; border-radius: 4px; padding: 7px 18px; font-weight: bold; min-height: 28px; }
QPushButton:hover { background-color: #0050c8; border-color: #0050c8; }
QPushButton:pressed { background-color: #003a9a; }
QPushButton:disabled { background-color: #cccccc; color: #666666; border-color: #999999; }
QGroupBox { color: #000000; border: 2px solid #000000; border-radius: 4px; margin-top: 14px; padding-top: 10px; font-weight: bold; font-size: 12px; }
QGroupBox::title { subcontrol-origin: margin; left: 12px; padding: 0 6px; background: #ffffff; }
QScrollBar:vertical { background: #e8e8e8; width: 14px; border-radius: 0; border: 1px solid #000000; }
QScrollBar::handle:vertical { background: #606060; border-radius: 0; min-height: 30px; border: 1px solid #000000; }
QScrollBar::handle:vertical:hover { background: #0050c8; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal { background: #e8e8e8; height: 14px; border-radius: 0; border: 1px solid #000000; }
QScrollBar::handle:horizontal { background: #606060; border-radius: 0; min-width: 30px; border: 1px solid #000000; }
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title { background: #000000; color: #ffffff; text-align: center; padding: 6px; border-bottom: 2px solid #000000; font-weight: bold; }
QSplitter::handle { background: #000000; height: 4px; }
QSplitter::handle:hover { background: #0050c8; }
QToolTip { background-color: #000000; color: #ffffff; border: 1px solid #ffffff; padding: 5px 10px; }
QScrollArea { border: none; background: #ffffff; }
"""


const darkTheme* = """
/* ═══════════════════════════════════════════
   ТЁМНАЯ ТЕМА — Catppuccin Mocha
   ═══════════════════════════════════════════ */
QMainWindow, QWidget {
  background-color: #1e1e2e;
  color: #cdd6f4;
  font-family: "Noto Sans", "Segoe UI", Arial, sans-serif;
  font-size: 13px;
}
QMenuBar {
  background-color: #181825;
  color: #cdd6f4;
  border-bottom: 1px solid #313244;
  padding: 2px;
}
QMenuBar::item { padding: 4px 10px; border-radius: 4px; }
QMenuBar::item:selected { background-color: #313244; }
QMenu {
  background-color: #181825;
  color: #cdd6f4;
  border: 1px solid #313244;
  border-radius: 6px;
  padding: 4px;
}
QMenu::item { padding: 6px 28px 6px 16px; border-radius: 4px; }
QMenu::item:selected { background-color: #89b4fa; color: #1e1e2e; }
QMenu::separator { height: 1px; background: #313244; margin: 3px 8px; }
QToolBar {
  background-color: #181825;
  border-bottom: 1px solid #313244;
  spacing: 3px;
  padding: 3px 6px;
}
QToolButton {
  color: #cdd6f4;
  background: transparent;
  border: 1px solid transparent;
  border-radius: 5px;
  padding: 5px 10px;
}
QToolButton:hover  { background-color: #313244; border-color: #45475a; }
QToolButton:pressed { background-color: #45475a; }
QStatusBar {
  background-color: #11111b;
  color: #a6adc8;
  border-top: 1px solid #313244;
  padding: 2px 8px;
  font-size: 12px;
}
QStatusBar::item { border: none; }
QTabWidget::pane {
  border: 1px solid #313244;
  border-radius: 0 6px 6px 6px;
  background: #1e1e2e;
}
QTabBar::tab {
  background: #181825;
  color: #a6adc8;
  padding: 7px 18px;
  border: 1px solid #313244;
  border-bottom: none;
  border-top-left-radius: 6px;
  border-top-right-radius: 6px;
  margin-right: 2px;
}
QTabBar::tab:selected {
  background: #1e1e2e;
  color: #cdd6f4;
  font-weight: bold;
  border-bottom-color: #1e1e2e;
}
QTabBar::tab:hover:!selected { background: #313244; }
QTextEdit {
  background-color: #181825;
  color: #cdd6f4;
  border: 1px solid #313244;
  border-radius: 6px;
  padding: 6px;
  font-family: "JetBrains Mono","Cascadia Code","Courier New",monospace;
  font-size: 12px;
  selection-background-color: #89b4fa;
  selection-color: #1e1e2e;
}
QTextEdit:focus { border-color: #89b4fa; }
QLineEdit {
  background-color: #181825;
  color: #cdd6f4;
  border: 1px solid #313244;
  border-radius: 5px;
  padding: 5px 8px;
}
QLineEdit:focus { border-color: #89b4fa; }
QListWidget {
  background-color: #181825;
  color: #cdd6f4;
  border: 1px solid #313244;
  border-radius: 6px;
  outline: none;
}
QListWidget::item { padding: 7px 12px; border-radius: 4px; margin: 1px 3px; }
QListWidget::item:hover    { background-color: #313244; }
QListWidget::item:selected { background-color: #89b4fa; color: #1e1e2e; }
QListWidget::item:alternate { background-color: #1e1e2e; }
QTreeWidget {
  background-color: #181825;
  color: #cdd6f4;
  border: 1px solid #313244;
  border-radius: 6px;
  outline: none;
  alternate-background-color: #1e1e2e;
}
QTreeWidget::item { padding: 4px 6px; }
QTreeWidget::item:hover    { background-color: #313244; }
QTreeWidget::item:selected { background-color: #89b4fa; color: #1e1e2e; }
QHeaderView::section {
  background-color: #11111b;
  color: #a6adc8;
  padding: 5px 8px;
  border: none;
  border-right: 1px solid #313244;
  border-bottom: 1px solid #313244;
  font-weight: bold;
  font-size: 12px;
}
QPushButton {
  background-color: #89b4fa;
  color: #1e1e2e;
  border: none;
  border-radius: 6px;
  padding: 7px 18px;
  font-weight: bold;
}
QPushButton:hover   { background-color: #b4befe; }
QPushButton:pressed { background-color: #74c7ec; }
QPushButton:disabled { background-color: #313244; color: #585b70; }
QPushButton:checked { background-color: #cba6f7; color: #1e1e2e; }
QGroupBox {
  color: #89b4fa;
  border: 1.5px solid #313244;
  border-radius: 7px;
  margin-top: 12px;
  padding-top: 8px;
  font-weight: bold;
  font-size: 12px;
}
QGroupBox::title {
  subcontrol-origin: margin;
  left: 12px;
  padding: 0 5px;
  background: #1e1e2e;
}
QScrollBar:vertical {
  background: #181825;
  width: 10px;
  border-radius: 5px;
}
QScrollBar::handle:vertical {
  background: #45475a;
  border-radius: 5px;
  min-height: 30px;
}
QScrollBar::handle:vertical:hover { background: #585b70; }
QScrollBar::add-line:vertical, QScrollBar::sub-line:vertical { height: 0; }
QScrollBar:horizontal {
  background: #181825;
  height: 10px;
  border-radius: 5px;
}
QScrollBar::handle:horizontal {
  background: #45475a;
  border-radius: 5px;
  min-width: 30px;
}
QScrollBar::add-line:horizontal, QScrollBar::sub-line:horizontal { width: 0; }
QDockWidget::title {
  background: #181825;
  text-align: center;
  padding: 5px;
  border-bottom: 1px solid #313244;
}
QSplitter::handle { background: #313244; }
QSplitter::handle:hover { background: #45475a; }
QToolTip {
  background-color: #313244;
  color: #cdd6f4;
  border: 1px solid #45475a;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
}
"""


# Обратная совместимость
const lightTheme* = themeWindows7
