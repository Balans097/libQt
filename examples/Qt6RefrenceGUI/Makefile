# Makefile — сборка Nim + Qt6 приложения
#
# Windows (MinGW / MSYS2):
#   Установите Qt6 через MSYS2:
#     pacman -S mingw-w64-x86_64-qt6-base mingw-w64-x86_64-gcc
#   Или укажите пути вручную через QT_DIR ниже.
#
# Linux (Fedora):  sudo dnf install nim qt6-qtbase-devel gcc-c++
# Linux (Ubuntu):  sudo apt install nim qt6-base-dev g++
#
# Использование:
#   make              — release-сборка
#   make debug        — debug-сборка
#   make run          — собрать и запустить
#   make check        — проверить зависимости
#   make clean        — очистить артефакты

# ── Определение платформы ────────────────────────────────────────────────────

ifeq ($(OS),Windows_NT)
  PLATFORM := windows
else
  PLATFORM := linux
endif

# ── Qt6 пути ─────────────────────────────────────────────────────────────────
# Windows: задайте QT_DIR если Qt6 не в PATH MSYS2
# Примеры:
#   QT_DIR = C:/msys64/mingw64
#   QT_DIR = C:/Qt/6.7.0/mingw_64
QT_DIR ?=

ifeq ($(PLATFORM),windows)
  # Windows — пробуем pkg-config (MSYS2), иначе собираем флаги вручную
  HAS_PKGCONFIG := $(shell pkg-config --exists Qt6Widgets 2>nul && echo yes || echo no)
  ifeq ($(HAS_PKGCONFIG),yes)
    _QT_CF := $(shell pkg-config --cflags Qt6Widgets 2>nul)
    _QT_LF := $(shell pkg-config --libs   Qt6Widgets 2>nul)
    # Отфильтровываем пустые значения
    QT_CFLAGS := $(if $(strip $(_QT_CF)),$(_QT_CF),)
    QT_LIBS   := $(if $(strip $(_QT_LF)),$(_QT_LF),)
  else
    # Ручные пути для MSYS2 mingw64
    ifeq ($(QT_DIR),)
      QT_DIR := C:/msys64/mingw64
    endif
    QT_INC    := $(QT_DIR)/include
    QT_LIB    := $(QT_DIR)/lib
    QT_CFLAGS := -I$(QT_INC) -I$(QT_INC)/QtWidgets -I$(QT_INC)/QtGui -I$(QT_INC)/QtCore -DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB
    QT_LIBS   := -L$(QT_LIB) -lQt6Widgets -lQt6Gui -lQt6Core
  endif
  TARGET   := NimQT6app.exe
  EXT      := .exe
else
  # Linux — pkg-config
  HAS_PKGCONFIG := $(shell pkg-config --exists Qt6Widgets 2>/dev/null && echo yes || echo no)
  ifeq ($(HAS_PKGCONFIG),yes)
    QT_CFLAGS := $(shell pkg-config --cflags Qt6Widgets)
    QT_LIBS   := $(shell pkg-config --libs   Qt6Widgets)
  else
    $(warning Qt6Widgets не найден через pkg-config)
    QT_CFLAGS :=
    QT_LIBS   :=
  endif
  TARGET := NimQT6app
  EXT    :=
endif

SRC := src/app.nim

# ── Функция добавления флага только если он непустой ─────────────────────────
# Nim не принимает --passC:"" и --passL:"" — они буквально передаются в g++
passC = $(if $(strip $(1)),--passC:"$(strip $(1))",)
passL = $(if $(strip $(1)),--passL:"$(strip $(1))",)

# ── Флаги Nim ─────────────────────────────────────────────────────────────────
NIM_COMMON := \
  --mm:orc \
  --exceptions:cpp \
  --passC:"-std=c++20"

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

# ── Цели ─────────────────────────────────────────────────────────────────────
.PHONY: all release debug run check clean

all: release

release: $(SRC)
	@echo "┌─────────────────────────────────────────────┐"
	@echo "│  nim cpp → $(TARGET)  (release)             │"
	@echo "└─────────────────────────────────────────────┘"
	nim cpp $(NIM_RELEASE) -o:$(TARGET) $(SRC)
	@echo ""
	@echo "✓  ./$(TARGET)"

debug: $(SRC)
	@echo "Building debug..."
	nim cpp $(NIM_DEBUG) -o:$(TARGET:$(EXT)=_debug$(EXT)) $(SRC)
	@echo "✓  Debug build done"

run: release
	./$(TARGET)

check:
	@echo "Проверка зависимостей:"
	@echo "  Платформа : $(PLATFORM)"
ifeq ($(PLATFORM),windows)
	@nim --version 2>nul | head -1 || echo "  nim    : НЕ НАЙДЕН"
	@g++ --version 2>nul | head -1 || echo "  g++    : НЕ НАЙДЕН"
	@echo "  pkg-config Qt6: $(HAS_PKGCONFIG)"
else
	@echo -n "  nim    : "; nim --version 2>/dev/null | head -1 || echo "НЕ НАЙДЕН"
	@echo -n "  Qt6    : "; pkg-config --modversion Qt6Widgets 2>/dev/null || echo "НЕ НАЙДЕН"
	@echo -n "  g++    : "; g++ --version 2>/dev/null | head -1 || echo "НЕ НАЙДЕН"
endif
	@echo "  QT_CFLAGS = $(QT_CFLAGS)"
	@echo "  QT_LIBS   = $(QT_LIBS)"

clean:
ifeq ($(PLATFORM),windows)
	-del /f /q $(TARGET) $(TARGET:$(EXT)=_debug$(EXT)) 2>nul
	-rmdir /s /q nimcache 2>nul
else
	rm -f $(TARGET) $(TARGET:$(EXT)=_debug$(EXT))
	rm -rf nimcache
endif
