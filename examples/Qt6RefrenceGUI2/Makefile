# Makefile — NimPad (Nim + Qt6)
#
# ┌─ НАСТРОЙКА ──────────────────────────────────────────────────────────────┐
# │ Раскомментируйте строку QT_DIR для вашей установки Qt6:                  │
# │                                                                           │
QT_DIR ?= C:/msys64/ucrt64
# QT_DIR ?= C:/msys64/mingw64
# QT_DIR ?= C:/msys2/ucrt64
# QT_DIR ?= C:/Qt/6.9.0/mingw_64
# QT_DIR ?= C:/Qt/6.8.0/mingw_64
# QT_DIR ?= C:/Qt/6.7.0/mingw_64
# QT_DIR ?= C:/Qt/6.6.0/mingw_64
# │                                                                           │
# │ Или передайте при вызове: make QT_DIR=C:/путь/к/qt6                      │
# └──────────────────────────────────────────────────────────────────────────┘
#
# Установка Qt6 (MSYS2 UCRT64 терминал):
#   pacman -S mingw-w64-ucrt-x86_64-qt6-base mingw-w64-ucrt-x86_64-gcc
#
# Команды:
#   make         — release-сборка
#   make debug   — debug-сборка
#   make run     — собрать и запустить
#   make check   — проверить пути и инструменты
#   make clean   — очистить

# ── Платформа ─────────────────────────────────────────────────────────────────
ifeq ($(OS),Windows_NT)
  PLATFORM := windows
  EXT      := .exe
else
  PLATFORM := linux
  EXT      :=
  # Linux: переопределяем QT_DIR через pkg-config
  ifeq ($(shell pkg-config --exists Qt6Widgets 2>/dev/null && echo yes),yes)
    QT_CFLAGS := $(shell pkg-config --cflags Qt6Widgets)
    QT_LIBS   := $(shell pkg-config --libs   Qt6Widgets)
  endif
endif

TARGET := nimpad$(EXT)
SRC    := nimpad.nim

# ── Флаги Qt6 (только Windows — Linux использует pkg-config выше) ─────────────
ifeq ($(PLATFORM),windows)
  QT_INC    := $(QT_DIR)/include
  QT_LIB    := $(QT_DIR)/lib
  QT_CFLAGS := -I$(QT_INC) -I$(QT_INC)/QtWidgets -I$(QT_INC)/QtGui -I$(QT_INC)/QtCore -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB
  QT_LIBS   := -L$(QT_LIB) -lQt6Widgets -lQt6Gui -lQt6Core
endif

# ── passC/passL: пустые значения не передаются g++ ───────────────────────────
passC = $(if $(strip $(1)),--passC:"$(strip $(1))",)
passL = $(if $(strip $(1)),--passL:"$(strip $(1))",)

# ── Флаги Nim ─────────────────────────────────────────────────────────────────
NIM_COMMON := \
  --mm:orc \
  --exceptions:cpp \
  --passC:"-std=c++20" \
  --path:"$(CURDIR)"

NIM_RELEASE := \
  $(NIM_COMMON) \
  -d:release \
  --opt:speed \
  $(call passC,$(QT_CFLAGS)) \
  $(call passL,$(QT_LIBS))

NIM_DEBUG := \
  $(NIM_COMMON) \
  -d:debug \
  --debuginfo \
  $(call passC,$(QT_CFLAGS)) \
  $(call passL,$(QT_LIBS))

# ── Цели ──────────────────────────────────────────────────────────────────────
.PHONY: all release debug run check clean

all: release

release: $(SRC)
	@echo "┌──────────────────────────────────────────┐"
	@echo "│  nim cpp → $(TARGET)  (release)          │"
	@echo "└──────────────────────────────────────────┘"
	@echo "  QT_DIR = $(QT_DIR)"
	nim cpp $(NIM_RELEASE) -o:$(TARGET) $(SRC)
	@echo ""
	@echo "OK  ./$(TARGET)"

debug: $(SRC)
	@echo "Building debug..."
	nim cpp $(NIM_DEBUG) -o:nimpad_debug$(EXT) $(SRC)
	@echo "OK  ./nimpad_debug$(EXT)"

run: release
	./$(TARGET)

check:
	@echo "==================================="
	@echo "  Платформа : $(PLATFORM)"
	@echo "  QT_DIR    : $(QT_DIR)"
	@echo "  QT_CFLAGS : $(QT_CFLAGS)"
	@echo "  QT_LIBS   : $(QT_LIBS)"
	@echo "==================================="
ifeq ($(PLATFORM),windows)
	@echo ""
	@echo "  Проверка файлов Qt6:"
	@if exist "$(QT_INC)\QtCore\qglobal.h" (echo "  [OK] $(QT_INC)\QtCore\qglobal.h") else (echo "  [!!] qglobal.h НЕ НАЙДЕН — проверьте QT_DIR")
	@if exist "$(QT_LIB)\libQt6Widgets.a"  (echo "  [OK] $(QT_LIB)\libQt6Widgets.a")  else (echo "  [!!] libQt6Widgets.a НЕ НАЙДЕН")
	@echo ""
	@echo "  Инструменты:"
	@nim --version 2>nul | findstr /i "nim" || echo "  [!!] nim не найден в PATH"
	@g++ --version 2>nul | findstr /i "g++" || echo "  [!!] g++ не найден в PATH"
	@where qmake6 2>nul || echo "  qmake6: не найден (не критично)"
else
	@echo -n "  qglobal.h : "; test -f "$(QT_INC)/QtCore/qglobal.h" && echo "OK" || echo "НЕ НАЙДЕН"
	@echo -n "  nim       : "; nim --version 2>/dev/null | head -1 || echo "НЕ НАЙДЕН"
	@echo -n "  g++       : "; g++ --version 2>/dev/null | head -1 || echo "НЕ НАЙДЕН"
endif

clean:
ifeq ($(PLATFORM),windows)
	-del /f /q $(TARGET) nimpad_debug$(EXT) 2>nul
	-rmdir /s /q nimcache 2>nul
else
	rm -f $(TARGET) nimpad_debug$(EXT)
	rm -rf nimcache
endif
