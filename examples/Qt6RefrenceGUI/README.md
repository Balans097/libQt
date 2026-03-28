# Nim + Qt6 Reference App

Полноценное эталонное GUI-приложение на **чистом Nim** с **Qt6 Widgets**.  
Никаких C++ обёрток — `nim cpp` компилирует Nim прямо в C++ и линкует  
с системными библиотеками Qt6.

```
nimqt6/
├── Makefile
├── README.md
└── src/
    ├── app.nim      # главное приложение (~650 строк)
    ├── qt6.nim      # биндинги Qt6 (~430 строк)
    └── themes.nim   # Catppuccin Latte / Mocha CSS
```

## Установка зависимостей

```bash
# Fedora
sudo dnf install nim qt6-qtbase-devel gcc-c++

# Ubuntu / Debian
sudo apt install nim qt6-base-dev g++
```

## Сборка

```bash
make              # release-сборка → ./nim_qt6_app
make debug        # debug-сборка
make run          # собрать и запустить
make check        # проверить зависимости
```

Вручную:
```bash
nim cpp \
  --mm:orc --exceptions:cpp -d:release --opt:speed \
  --passC:"-std=c++17" \
  --passC:"$(pkg-config --cflags Qt6Widgets)" \
  --passL:"$(pkg-config --libs Qt6Widgets)" \
  -o:nim_qt6_app src/app.nim
```

## Возможности

| Компонент | Описание |
|-----------|----------|
| `QMainWindow` | Главное окно с MenuBar, ToolBar, StatusBar |
| `QDockWidget` | Отстыкуемая панель «Структура проекта» (справа) |
| `QTabWidget` | 4 вкладки: Задачи / Заметки / Лог / О программе |
| `QSplitter` | Вертикальное разделение областей |
| `QListWidget` | Список задач: добавление, удаление, редактирование двойным кликом |
| `QTreeWidget` | Дерево структуры проекта в dock-панели |
| `QTextEdit` | Редактор с HTML, открытие/сохранение файлов |
| `QLineEdit` | Поле ввода с обработкой Enter |
| `QPushButton` | Кнопки с `cdecl + pointer` callbacks |
| `QTimer` | Часы реального времени в нижней полосе |
| Диалоги | `QMessageBox`, `QInputDialog`, `QFileDialog` |
| Темы | Переключение светлая ↔ тёмная (Catppuccin) |

## Горячие клавиши

| Клавиша | Действие |
|---------|----------|
| `Ctrl+N` | Новая задача |
| `Ctrl+S` | Сохранить заметку |
| `Ctrl+Q` | Выход |
| `Ctrl+D` | Очистить список задач |
| `Ctrl+L` | Очистить лог |
| `F9` | Светлая тема |
| `F10` | Тёмная тема |
| `F1–F4` | Демо-диалоги |
| `F12` | О программе |

## Архитектура биндингов

```nim
# 1. Qt-типы через importcpp
type QMainWindow* {.importcpp: "QMainWindow", header: "<QMainWindow>".} = object

# 2. Методы через importcpp (инлайн в C++)
proc resize*(w: ptr QMainWindow, w, h: cint) {.importcpp: "#->resize(#,#)".}

# 3. Сложные вызовы через emit (остаются в qt6.nim.cpp, где есть все заголовки)
proc addMenu*(w: Win, title: QString): Menu =
  {.emit: "`result` = `w`->menuBar()->addMenu(`title`);".}

# 4. Callbacks — cdecl proc + pointer (без NimClosureProc, без лямбда-captures)
type CB* = proc(ud: pointer) {.cdecl.}

proc onClicked*(b: Btn, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`b`, &QPushButton::clicked, [=](bool){
      `cb`(`ud`);
    });
  """.}

# Использование: передаём глобальный cdecl proc + данные через pointer
proc cbMyAction(ud: pointer) {.cdecl.} =
  echo "clicked!"

btn.onClicked(cbMyAction, nil)
```

**Ключевые флаги компилятора:**

| Флаг | Назначение |
|------|-----------|
| `nim cpp` | C++ бэкенд — Nim компилируется в C++ |
| `--mm:orc` | GC совместимый с C++ объектами |
| `--exceptions:cpp` | Нативные C++ исключения (Qt их использует) |
| `--passC:"-std=c++17"` | Qt6 требует C++17 |
| `--passC/L` | Флаги из `pkg-config --cflags/libs Qt6Widgets` |
