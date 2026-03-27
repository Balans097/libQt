## nimQtDialogs.nim — Полная обёртка диалогов Qt6 для Nim
## =============================================================
## Поддерживаемые классы:
##   QMessageBox     — информационные / вопросительные / критические окна
##   QInputDialog    — однострочный/многострочный текст, целое, вещественное,
##                     выбор из списка
##   QFileDialog     — открытие/сохранение файлов и директорий
##   QFontDialog     — выбор шрифта
##   QColorDialog    — выбор цвета (RGB/HSV/CMYK, hex, alpha)
##   QProgressDialog — прогресс-диалог
##   QErrorMessage   — подавляемые сообщения об ошибках
##   QDialogButtonBox— стандартная панель кнопок
##   QDialog         — базовый кастомный диалог + builder-хелперы
##   QWizard         — мастер (wizard) + страницы
##   QWizardPage     — страница мастера
##
## Высокоуровневые Nim-утилиты:
##   confirmDelete, confirmDiscard, confirmOverwrite,
##   showValidationError, askTextRequired, askInt, askFloat, askChoice,
##   pickOpenFile, pickSaveFile, pickDirectory, pickColorHex, pickFontStr,
##   withProgress, withProgressCancellable
##
## Зависимости: nimQtUtils, nimQtFFI, nimQtWidgets
##
## Компиляция:
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Widgets)" \
##     --passL:"$(pkg-config --libs Qt6Widgets)" myapp.nim
##
## Совместимость: Qt 6.2+ (полностью), Qt 6.7+ (расширенные enum Qt6.7),
##               Qt 6.11 (setCheckBox API, DontUseNativeDialog уточнён)

# ── Пути для Windows/MSYS2 (адаптируйте для других платформ) ─────────────────
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}

import nimQtUtils   ## QString, NimColor, NimPointF и др.
import nimQtFFI     ## CB, CBStr, CBInt, CBBool, константы Qt
import nimQtWidgets ## W, VBox, HBox, Grid, Form, WizPage, ChkBox, …

# ── Все заголовки Qt, необходимые для этого модуля ───────────────────────────
{.emit: """
#include <QMessageBox>
#include <QAbstractButton>
#include <QCheckBox>
#include <QPushButton>
#include <QInputDialog>
#include <QLineEdit>
#include <QFileDialog>
#include <QFontDialog>
#include <QColorDialog>
#include <QProgressDialog>
#include <QErrorMessage>
#include <QWizard>
#include <QWizardPage>
#include <QDialog>
#include <QDialogButtonBox>
#include <QWidget>
#include <QLabel>
#include <QString>
#include <QStringList>
#include <QFont>
#include <QColor>
#include <QUrl>
#include <QList>
#include <QDir>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QGridLayout>
#include <QApplication>
#include <functional>
#include <cstring>
""".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 1. Opaque Qt-типы
# ═══════════════════════════════════════════════════════════════════════════════

type
  ## Диалог сообщений
  QMessageBox*      {.importcpp: "QMessageBox",
                      header: "<QMessageBox>".}      = object
  ## Диалог ввода данных
  QInputDialog*     {.importcpp: "QInputDialog",
                      header: "<QInputDialog>".}     = object
  ## Диалог файловой системы
  QFileDialog*      {.importcpp: "QFileDialog",
                      header: "<QFileDialog>".}      = object
  ## Диалог выбора шрифта
  QFontDialog*      {.importcpp: "QFontDialog",
                      header: "<QFontDialog>".}      = object
  ## Диалог выбора цвета
  QColorDialog*     {.importcpp: "QColorDialog",
                      header: "<QColorDialog>".}     = object
  ## Диалог прогресса
  QProgressDialog*  {.importcpp: "QProgressDialog",
                      header: "<QProgressDialog>".}  = object
  ## Диалог сообщений об ошибках (с возможностью «Не показывать»)
  QErrorMessage*    {.importcpp: "QErrorMessage",
                      header: "<QErrorMessage>".}    = object
  ## Стандартная панель кнопок (Ok/Cancel/Save/…)
  QDialogButtonBox* {.importcpp: "QDialogButtonBox",
                      header: "<QDialogButtonBox>".} = object

# ── Короткие псевдонимы указателей ───────────────────────────────────────────
type
  MsgBox*  = ptr QMessageBox      ## Указатель на QMessageBox
  InDlg*   = ptr QInputDialog     ## Указатель на QInputDialog
  FileDlg* = ptr QFileDialog      ## Указатель на QFileDialog
  FontDlg* = ptr QFontDialog      ## Указатель на QFontDialog
  ColDlg*  = ptr QColorDialog     ## Указатель на QColorDialog
  ProgDlg* = ptr QProgressDialog  ## Указатель на QProgressDialog
  ErrMsg*  = ptr QErrorMessage    ## Указатель на QErrorMessage
  Wiz*     = ptr QWizard          ## Указатель на QWizard (из nimQtWidgets)
  CDlg*    = ptr QDialog          ## Указатель на QDialog (из nimQtWidgets)
  DlgBBx*  = ptr QDialogButtonBox ## Указатель на QDialogButtonBox
  AbsBtn*  = ptr QAbstractButton  ## Указатель на QAbstractButton (из nimQtWidgets)

# ═══════════════════════════════════════════════════════════════════════════════
# § 2. Перечисления (enum)
# ═══════════════════════════════════════════════════════════════════════════════

# ── QMessageBox ───────────────────────────────────────────────────────────────
type
  ## Иконки в QMessageBox
  MsgBoxIcon* {.size: sizeof(cint).} = enum
    MBNoIcon      = 0   ## Без иконки
    MBInformation = 1   ## Информационная (i)
    MBWarning     = 2   ## Предупреждение (!)
    MBCritical    = 3   ## Критическая ошибка (X)
    MBQuestion    = 4   ## Вопрос (?)

  ## Стандартные кнопки QMessageBox (совпадают со значениями Qt)
  MsgBoxStdBtn* {.size: sizeof(cint).} = enum
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

  ## Роль кнопки в QMessageBox (ButtonRole)
  MsgBoxRole* {.size: sizeof(cint).} = enum
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

# ── QDialogButtonBox ─────────────────────────────────────────────────────────
type
  ## Стандартные кнопки QDialogButtonBox
  DlgBBxStdBtn* {.size: sizeof(cint).} = enum
    DBBNoButton        = 0x00000000
    DBBOk              = 0x00000400
    DBBSave            = 0x00000800
    DBBSaveAll         = 0x00001000
    DBBOpen            = 0x00002000
    DBBYes             = 0x00004000
    DBBYesToAll        = 0x00008000
    DBBNo              = 0x00010000
    DBBNoToAll         = 0x00020000
    DBBAbort           = 0x00040000
    DBBRetry           = 0x00080000
    DBBIgnore          = 0x00100000
    DBBClose           = 0x00200000
    DBBCancel          = 0x00400000
    DBBDiscard         = 0x00800000
    DBBHelp            = 0x01000000
    DBBApply           = 0x02000000
    DBBReset           = 0x04000000
    DBBRestoreDefaults = 0x08000000

  ## Роль кнопки в QDialogButtonBox
  DlgBBxRole* {.size: sizeof(cint).} = enum
    DBBRoleInvalid     = -1
    DBBRoleAccept      =  0
    DBBRoleReject      =  1
    DBBRoleDestructive =  2
    DBBRoleAction      =  3
    DBBRoleHelp        =  4
    DBBRoleYes         =  5
    DBBRoleNo          =  6
    DBBRoleReset       =  7
    DBBRoleApply       =  8

# ── QDialog ───────────────────────────────────────────────────────────────────
type
  ## Результат диалога (Accepted = Ok, Rejected = Cancel)
  DlgResult* {.size: sizeof(cint).} = enum
    DlgRejected = 0
    DlgAccepted = 1

# ── QFileDialog ───────────────────────────────────────────────────────────────
type
  ## Режим принятия: открыть или сохранить
  FDAcceptMode* {.size: sizeof(cint).} = enum
    FDAcceptOpen = 0
    FDAcceptSave = 1

  ## Режим выбора файлов
  FDFileMode* {.size: sizeof(cint).} = enum
    FDModeAnyFile      = 0  ## Любое имя (для «Сохранить как»)
    FDModeExistingFile = 1  ## Только существующий файл
    FDModeDirectory    = 2  ## Директория
    FDModeExistingFiles= 3  ## Несколько существующих файлов

  ## Флаги поведения QFileDialog
  FDOption* {.size: sizeof(cint).} = enum
    FDShowDirsOnly           = 0x01
    FDDontResolveSymlinks    = 0x02
    FDDontConfirmOverwrite   = 0x04
    FDDontUseNativeDialog    = 0x08
    FDReadOnly               = 0x10
    FDHideNameFilterDetails  = 0x20
    FDDontUseCustomDirIcons  = 0x40

  ## Вид отображения файлов (список / детали)
  FDViewMode* {.size: sizeof(cint).} = enum
    FDViewDetail = 0
    FDViewList   = 1

  ## Метки в диалоге файла
  FDDialogLabel* {.size: sizeof(cint).} = enum
    FDLabelLookIn   = 0
    FDLabelFileName = 1
    FDLabelFileType = 2
    FDLabelAccept   = 3
    FDLabelReject   = 4

# ── QColorDialog ──────────────────────────────────────────────────────────────
type
  ## Флаги диалога цвета
  ColorDlgOption* {.size: sizeof(cint).} = enum
    CDShowAlphaChannel   = 0x01  ## Показать ползунок прозрачности
    CDNoButtons          = 0x02  ## Скрыть кнопки Ok/Cancel
    CDDontUseNativeDialog= 0x04  ## Использовать встроенный Qt-диалог

# ── QFontDialog ───────────────────────────────────────────────────────────────
type
  ## Флаги диалога шрифта
  FontDlgOption* {.size: sizeof(cint).} = enum
    FtNoButtons         = 0x01   ## Скрыть кнопки Ok/Cancel
    FtDontUseNativeDialog= 0x02  ## Использовать встроенный Qt-диалог
    FtScalableFonts     = 0x04   ## Только масштабируемые шрифты
    FtNonScalableFonts  = 0x08   ## Только немасштабируемые
    FtMonospacedFonts   = 0x10   ## Только моноширинные
    FtProportionalFonts = 0x20   ## Только пропорциональные

# ── QInputDialog ──────────────────────────────────────────────────────────────
type
  ## Режим ввода в QInputDialog
  InputDlgMode* {.size: sizeof(cint).} = enum
    IDModeText   = 0  ## Текстовая строка
    IDModeInt    = 1  ## Целое число
    IDModeDouble = 2  ## Вещественное число

# ── QWizard ───────────────────────────────────────────────────────────────────
type
  ## Стиль мастера
  WizardStyle* {.size: sizeof(cint).} = enum
    WizClassicStyle = 0  ## Классический (Windows)
    WizModernStyle  = 1  ## Современный (Windows Vista+)
    WizMacStyle     = 2  ## macOS
    WizAeroStyle    = 3  ## Aero (Windows Vista/7)

  ## Опции мастера (WizardOption)
  WizardOption* {.size: sizeof(cint).} = enum
    WizOptIndependentPages          = 0x0001
    WizOptIgnoreSubTitles           = 0x0002
    WizOptExtendedWatermarkPixmap   = 0x0004
    WizOptNoDefaultButton           = 0x0008
    WizOptNoBackButtonOnStartPage   = 0x0010
    WizOptNoBackButtonOnLastPage    = 0x0020
    WizOptDisabledBackButtonOnLastPage = 0x0040
    WizOptHaveNextButtonOnLastPage  = 0x0080
    WizOptHaveFinishButtonOnEarlyPages = 0x0100
    WizOptNoCancelButton            = 0x0200
    WizOptCancelButtonOnLeft        = 0x0400
    WizOptHaveHelpButton            = 0x0800
    WizOptHelpButtonOnRight         = 0x1000
    WizOptHaveCustomButton1         = 0x2000
    WizOptHaveCustomButton2         = 0x4000
    WizOptHaveCustomButton3         = 0x8000
    WizOptNoCancelButtonOnLastPage  = 0x10000  ## Qt 6.2+

  ## Кнопки мастера
  WizardButton* {.size: sizeof(cint).} = enum
    WizBtnBack    = 0
    WizBtnNext    = 1
    WizBtnCommit  = 2
    WizBtnFinish  = 3
    WizBtnCancel  = 4
    WizBtnHelp    = 5
    WizBtnCustom1 = 6
    WizBtnCustom2 = 7
    WizBtnCustom3 = 8

# ── QDialog: флаги окна ───────────────────────────────────────────────────────
type
  ## Qt::WindowModality
  WindowModality* {.size: sizeof(cint).} = enum
    NonModal        = 0  ## Немодальный
    WindowModal     = 1  ## Модальный относительно родительского окна
    ApplicationModal= 2  ## Модальный относительно всего приложения

# ═══════════════════════════════════════════════════════════════════════════════
# § 3. Nim-side типы результатов
# ═══════════════════════════════════════════════════════════════════════════════

type
  InputStrResult*   = tuple[ok: bool, value: string]
    ## Результат ввода строки: ok=true если пользователь нажал OK
  InputIntResult*   = tuple[ok: bool, value: int]
    ## Результат ввода целого числа
  InputFloatResult* = tuple[ok: bool, value: float64]
    ## Результат ввода вещественного числа
  InputItemResult*  = tuple[ok: bool, item: string]
    ## Результат выбора из списка
  FontPickResult*   = tuple[ok: bool, family: string, pointSize: int,
                            bold: bool, italic: bool, underline: bool,
                            strikeOut: bool, weight: int]
    ## Результат выбора шрифта
  ColorPickResult*  = tuple[ok: bool, r, g, b, a: int]
    ## Результат выбора цвета (RGBA, 0–255)
  FilePickResult*   = tuple[ok: bool, path: string]
    ## Результат выбора одного файла/директории
  FilesPickResult*  = tuple[ok: bool, paths: seq[string]]
    ## Результат выбора нескольких файлов

# ═══════════════════════════════════════════════════════════════════════════════
# § 4. QMessageBox — статические методы
# ═══════════════════════════════════════════════════════════════════════════════

proc msgInfo*(parent: W, title, text: string) =
  ## Показать информационный диалог. Ждёт нажатия OK.
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::information(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc msgWarning*(parent: W, title, text: string) =
  ## Показать предупреждающий диалог. Ждёт нажатия OK.
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::warning(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc msgCritical*(parent: W, title, text: string) =
  ## Показать диалог критической ошибки. Ждёт нажатия OK.
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::critical(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc msgAbout*(parent: W, title, text: string) =
  ## Диалог «О программе» с поддержкой rich text.
  let t = title.cstring; let m = text.cstring
  {.emit: "QMessageBox::about(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`));".}

proc msgAboutQt*(parent: W, title: string = "About Qt") =
  ## Стандартный диалог «О Qt».
  let t = title.cstring
  {.emit: "QMessageBox::aboutQt(`parent`, QString::fromUtf8(`t`));".}

proc msgQuestion*(parent: W, title, text: string,
                  buttons: cint = 0x00004000 or 0x00010000): MsgBoxStdBtn =
  ## Диалог с вопросом. По умолчанию кнопки Yes/No.
  ## Возвращает нажатую кнопку.
  let t = title.cstring; let m = text.cstring; var r: cint
  {.emit: "`r` = (int)QMessageBox::question(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`), (QMessageBox::StandardButtons)`buttons`);".}
  result = cast[MsgBoxStdBtn](r)

proc msgYesNo*(parent: W, title, text: string): bool =
  ## Быстрый диалог Да/Нет. Возвращает true если нажали Yes.
  result = (msgQuestion(parent, title, text) == MBBtnYes)

proc msgYesNoCancel*(parent: W, title, text: string): MsgBoxStdBtn =
  ## Диалог Да/Нет/Отмена.
  let t = title.cstring; let m = text.cstring; var r: cint
  {.emit: "`r` = (int)QMessageBox::question(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`), QMessageBox::Yes | QMessageBox::No | QMessageBox::Cancel);".}
  result = cast[MsgBoxStdBtn](r)

proc msgOkCancel*(parent: W, title, text: string): bool =
  ## Быстрый диалог OK/Отмена. Возвращает true если нажали OK.
  let t = title.cstring; let m = text.cstring; var r: cint
  {.emit: "`r` = (QMessageBox::question(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`), QMessageBox::Ok | QMessageBox::Cancel) == QMessageBox::Ok) ? 1 : 0;".}
  result = r == 1

proc msgSaveDiscardCancel*(parent: W, title, text: string): MsgBoxStdBtn =
  ## Диалог Save/Discard/Cancel (обычно при закрытии несохранённого документа).
  let t = title.cstring; let m = text.cstring; var r: cint
  {.emit: "`r` = (int)QMessageBox::warning(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`), QMessageBox::Save | QMessageBox::Discard | QMessageBox::Cancel);".}
  result = cast[MsgBoxStdBtn](r)

proc msgRetryCancelAbort*(parent: W, title, text: string): MsgBoxStdBtn =
  ## Диалог Retry/Cancel/Abort (обычно при ошибках операций).
  let t = title.cstring; let m = text.cstring; var r: cint
  {.emit: "`r` = (int)QMessageBox::critical(`parent`, QString::fromUtf8(`t`), QString::fromUtf8(`m`), QMessageBox::Retry | QMessageBox::Cancel | QMessageBox::Abort);".}
  result = cast[MsgBoxStdBtn](r)

# ── QMessageBox объектный API ─────────────────────────────────────────────────

proc newMsgBox*(parent: W = nil): MsgBox {.importcpp: "new QMessageBox(#)".}
  ## Создать новый QMessageBox для ручной настройки.

proc msgBoxSetWindowTitle*(mb: MsgBox, title: string) =
  ## Установить заголовок окна.
  let cs = title.cstring
  {.emit: "`mb`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc msgBoxSetIcon*(mb: MsgBox, icon: MsgBoxIcon) =
  ## Установить иконку диалога.
  let i = icon.cint
  {.emit: "`mb`->setIcon((QMessageBox::Icon)`i`);".}

proc msgBoxSetText*(mb: MsgBox, text: string) =
  ## Установить основной текст (поддерживает HTML/rich text).
  let cs = text.cstring
  {.emit: "`mb`->setText(QString::fromUtf8(`cs`));".}

proc msgBoxSetInformativeText*(mb: MsgBox, text: string) =
  ## Дополнительный информационный текст (отображается меньшим шрифтом).
  let cs = text.cstring
  {.emit: "`mb`->setInformativeText(QString::fromUtf8(`cs`));".}

proc msgBoxSetDetailedText*(mb: MsgBox, text: string) =
  ## Детальный текст (скрыт за кнопкой «Подробнее»).
  let cs = text.cstring
  {.emit: "`mb`->setDetailedText(QString::fromUtf8(`cs`));".}

proc msgBoxSetTextFormat*(mb: MsgBox, fmt: cint) =
  ## Формат текста: 0=PlainText, 1=RichText, 2=AutoText, 3=MarkdownText.
  {.emit: "`mb`->setTextFormat((Qt::TextFormat)`fmt`);".}

proc msgBoxSetStdButtons*(mb: MsgBox, buttons: cint) =
  ## Установить набор стандартных кнопок (OR нескольких MsgBoxStdBtn).
  {.emit: "`mb`->setStandardButtons((QMessageBox::StandardButtons)`buttons`);".}

proc msgBoxSetDefaultButton*(mb: MsgBox, btn: MsgBoxStdBtn) =
  ## Кнопка по умолчанию (нажимается по Enter).
  let b = btn.cint
  {.emit: "`mb`->setDefaultButton((QMessageBox::StandardButton)`b`);".}

proc msgBoxSetEscapeButton*(mb: MsgBox, btn: MsgBoxStdBtn) =
  ## Кнопка, срабатывающая по Escape.
  let b = btn.cint
  {.emit: "`mb`->setEscapeButton((QMessageBox::StandardButton)`b`);".}

proc msgBoxAddButton*(mb: MsgBox, text: string, role: MsgBoxRole): AbsBtn =
  ## Добавить произвольную кнопку с указанной ролью.
  ## Возвращает указатель на созданную кнопку.
  let cs = text.cstring; let r = role.cint
  {.emit: "`result` = `mb`->addButton(QString::fromUtf8(`cs`), (QMessageBox::ButtonRole)`r`);".}

proc msgBoxAddCheckBox*(mb: MsgBox, text: string): ptr QCheckBox =
  ## Добавить флажок (checkbox) в диалог (Qt 6.x).
  ## Пример: «Больше не показывать».
  let cs = text.cstring
  {.emit: """
    auto* _mbcb = new QCheckBox(QString::fromUtf8(`cs`), `mb`);
    `mb`->setCheckBox(_mbcb);
    `result` = _mbcb;
  """.}

proc msgBoxExec*(mb: MsgBox): MsgBoxStdBtn =
  ## Показать диалог модально. Возвращает нажатую кнопку.
  var r: cint
  {.emit: "`r` = (int)`mb`->exec();".}
  result = cast[MsgBoxStdBtn](r)

proc msgBoxClickedButton*(mb: MsgBox): AbsBtn {.importcpp: "#->clickedButton()".}
  ## Получить указатель на кнопку, которую нажали (для нестандартных кнопок).

proc msgBoxIsCheckBoxChecked*(mb: MsgBox): bool =
  ## Проверить, установлен ли флажок, добавленный через msgBoxAddCheckBox.
  var r: cint
  {.emit: """
    if (auto* _cb2 = qobject_cast<QCheckBox*>(`mb`->checkBox()))
      `r` = _cb2->isChecked() ? 1 : 0;
    else `r` = 0;
  """.}
  result = r == 1

proc msgBoxShow*(mb: MsgBox)  {.importcpp: "#->show()".}
  ## Показать немодально.
proc msgBoxHide*(mb: MsgBox)  {.importcpp: "#->hide()".}
  ## Скрыть.
proc msgBoxClose*(mb: MsgBox) {.importcpp: "#->close()".}
  ## Закрыть.
proc msgBoxSetModal*(mb: MsgBox, b: bool) {.importcpp: "#->setModal(#)".}
  ## Установить модальность.
proc msgBoxSetStyleSheet*(mb: MsgBox, css: QString) {.importcpp: "#->setStyleSheet(#)".}
  ## Применить CSS-стиль.
proc msgBoxResize*(mb: MsgBox, w, h: cint) {.importcpp: "#->resize(#, #)".}
  ## Изменить размер.
proc msgBoxAsW*(mb: MsgBox): W {.importcpp: "(QWidget*)#".}
  ## Upcast к QWidget*.

proc msgBoxStdButton*(mb: MsgBox, btn: MsgBoxStdBtn): AbsBtn =
  ## Получить кнопку по её стандартному значению (для настройки текста и т.п.).
  let b = btn.cint
  {.emit: "`result` = `mb`->button((QMessageBox::StandardButton)`b`);".}

proc msgBoxSetTextInteractionFlags*(mb: MsgBox, flags: cint) =
  ## Флаги взаимодействия с текстом (копирование, ссылки и т.п.).
  {.emit: "`mb`->setTextInteractionFlags((Qt::TextInteractionFlags)`flags`);".}

# ── Сигналы QMessageBox ───────────────────────────────────────────────────────

proc onMsgBoxFinished*(mb: MsgBox, cb: CBInt, ud: pointer) =
  ## Сигнал: диалог закрыт. Параметр: результат (Accepted=1/Rejected=0).
  {.emit: "QObject::connect(`mb`, &QMessageBox::finished, [=](int _r){ `cb`(_r, `ud`); });".}

proc onMsgBoxAccepted*(mb: MsgBox, cb: CB, ud: pointer) =
  ## Сигнал: пользователь принял диалог (OK/Yes/Save).
  {.emit: "QObject::connect(`mb`, &QMessageBox::accepted, [=](){ `cb`(`ud`); });".}

proc onMsgBoxRejected*(mb: MsgBox, cb: CB, ud: pointer) =
  ## Сигнал: пользователь отклонил диалог (Cancel/No).
  {.emit: "QObject::connect(`mb`, &QMessageBox::rejected, [=](){ `cb`(`ud`); });".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 5. QInputDialog — статические методы
# ═══════════════════════════════════════════════════════════════════════════════

proc inputText*(parent: W, title, label: string,
                default: string = "",
                echo: cint = 0): InputStrResult =
  ## Показать диалог ввода текста.
  ## echo: 0=Normal, 2=Password, 3=PasswordEchoOnEdit
  ## Возвращает (ok, value).
  let t = title.cstring; let l = label.cstring; let d = default.cstring
  var ok: cint; var p: cstring
  {.emit: """
    bool _idOk = false;
    static QByteArray _bIdTx;
    _bIdTx = QInputDialog::getText(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`l`), (QLineEdit::EchoMode)`echo`,
      QString::fromUtf8(`d`), &_idOk).toUtf8();
    `ok` = _idOk ? 1 : 0;
    `p` = _bIdTx.constData();
  """.}
  result = (ok: ok == 1, value: $p)

proc inputPassword*(parent: W, title, label: string,
                    default: string = ""): InputStrResult =
  ## Удобный метод для ввода пароля (звёздочки).
  result = inputText(parent, title, label, default, 2)

proc inputMultiLine*(parent: W, title, label: string,
                     default: string = ""): InputStrResult =
  ## Диалог ввода многострочного текста.
  let t = title.cstring; let l = label.cstring; let d = default.cstring
  var ok: cint; var p: cstring
  {.emit: """
    bool _idMlOk = false;
    static QByteArray _bIdML;
    _bIdML = QInputDialog::getMultiLineText(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`l`), QString::fromUtf8(`d`), &_idMlOk).toUtf8();
    `ok` = _idMlOk ? 1 : 0;
    `p` = _bIdML.constData();
  """.}
  result = (ok: ok == 1, value: $p)

proc inputInt*(parent: W, title, label: string,
               default: int = 0,
               min: int = low(cint).int,
               max: int = high(cint).int,
               step: int = 1): InputIntResult =
  ## Диалог ввода целого числа со спиннером.
  let t = title.cstring; let l = label.cstring
  let dv = default.cint; let mn = min.cint; let mx = max.cint; let st = step.cint
  var ok: cint; var v: cint
  {.emit: """
    bool _idIntOk = false;
    `v` = QInputDialog::getInt(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`l`), `dv`, `mn`, `mx`, `st`, &_idIntOk);
    `ok` = _idIntOk ? 1 : 0;
  """.}
  result = (ok: ok == 1, value: v.int)

proc inputFloat*(parent: W, title, label: string,
                 default: float64 = 0.0,
                 min: float64 = -1e9,
                 max: float64 = 1e9,
                 decimals: int = 3,
                 step: float64 = 1.0): InputFloatResult =
  ## Диалог ввода вещественного числа.
  ## step поддерживается начиная с Qt 5.10+.
  let t = title.cstring; let l = label.cstring; let dec = decimals.cint
  var ok: cint; var v: cdouble
  {.emit: """
    bool _idDblOk = false;
    `v` = QInputDialog::getDouble(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`l`), `default`, `min`, `max`, `dec`, &_idDblOk, Qt::WindowFlags(), `step`);
    `ok` = _idDblOk ? 1 : 0;
  """.}
  result = (ok: ok == 1, value: v.float64)

proc inputItem*(parent: W, title, label: string,
                items: openArray[string],
                currentIdx: int = 0,
                editable: bool = false): InputItemResult =
  ## Диалог выбора из выпадающего списка.
  let t = title.cstring; let l = label.cstring
  let n = items.len.cint; let ci = currentIdx.cint; let ed = editable.cint
  var joined = ""
  for i, s in items:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  var ok: cint; var p: cstring
  {.emit: """
    QStringList _slItm;
    const char* _pItm = `data`;
    for (int _i = 0; _i < `n`; ++_i) {
      _slItm << QString::fromUtf8(_pItm);
      _pItm += std::strlen(_pItm) + 1;
    }
    bool _idItmOk = false;
    static QByteArray _bIdItm;
    _bIdItm = QInputDialog::getItem(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`l`), _slItm, `ci`, (bool)`ed`, &_idItmOk).toUtf8();
    `ok` = _idItmOk ? 1 : 0;
    `p` = _bIdItm.constData();
  """.}
  result = (ok: ok == 1, item: $p)

# ── QInputDialog объектный API ────────────────────────────────────────────────

proc newInputDialog*(parent: W = nil): InDlg {.importcpp: "new QInputDialog(#)".}
  ## Создать QInputDialog для ручной настройки.

proc idSetWindowTitle*(d: InDlg, s: string) =
  ## Заголовок окна.
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc idSetLabelText*(d: InDlg, s: string) =
  ## Текст метки над полем ввода.
  let cs = s.cstring
  {.emit: "`d`->setLabelText(QString::fromUtf8(`cs`));".}

proc idSetOkButtonText*(d: InDlg, s: string) =
  ## Текст кнопки «OK».
  let cs = s.cstring
  {.emit: "`d`->setOkButtonText(QString::fromUtf8(`cs`));".}

proc idSetCancelButtonText*(d: InDlg, s: string) =
  ## Текст кнопки «Отмена».
  let cs = s.cstring
  {.emit: "`d`->setCancelButtonText(QString::fromUtf8(`cs`));".}

proc idSetInputMode*(d: InDlg, mode: InputDlgMode) =
  ## Переключить режим ввода (текст/целое/вещественное).
  let m = mode.cint
  {.emit: "`d`->setInputMode((QInputDialog::InputMode)`m`);".}

proc idSetTextValue*(d: InDlg, s: string) =
  ## Задать начальный текст (в режиме IDModeText).
  let cs = s.cstring
  {.emit: "`d`->setTextValue(QString::fromUtf8(`cs`));".}

proc idTextValue*(d: InDlg): string =
  ## Получить введённый текст.
  var p: cstring
  {.emit: "static QByteArray _bIdTV; _bIdTV = `d`->textValue().toUtf8(); `p` = _bIdTV.constData();".}
  result = $p

proc idSetTextEchoMode*(d: InDlg, mode: cint) =
  ## Режим эхо (0=Normal, 2=Password, 3=PasswordEchoOnEdit).
  {.emit: "`d`->setTextEchoMode((QLineEdit::EchoMode)`mode`);".}

proc idSetIntValue*(d: InDlg, v: int) =
  ## Задать начальное значение в целочисленном режиме.
  let vi = v.cint
  {.emit: "`d`->setIntValue(`vi`);".}

proc idIntValue*(d: InDlg): int =
  ## Получить введённое целое.
  var v: cint
  {.emit: "`v` = `d`->intValue();".}
  result = v.int

proc idSetIntRange*(d: InDlg, mn, mx: int) =
  ## Диапазон для целочисленного ввода.
  let a = mn.cint; let b = mx.cint
  {.emit: "`d`->setIntRange(`a`, `b`);".}

proc idSetIntStep*(d: InDlg, step: int) =
  ## Шаг спиннера для целочисленного ввода.
  let s = step.cint
  {.emit: "`d`->setIntStep(`s`);".}

proc idSetDoubleValue*(d: InDlg, v: float64) =
  ## Задать начальное значение в режиме double.
  {.emit: "`d`->setDoubleValue(`v`);".}

proc idDoubleValue*(d: InDlg): float64 =
  ## Получить введённое вещественное число.
  var v: cdouble
  {.emit: "`v` = `d`->doubleValue();".}
  result = v.float64

proc idSetDoubleRange*(d: InDlg, mn, mx: float64) =
  ## Диапазон для double-ввода.
  {.emit: "`d`->setDoubleRange(`mn`, `mx`);".}

proc idSetDoubleDecimals*(d: InDlg, dec: int) =
  ## Количество знаков после запятой.
  let d2 = dec.cint
  {.emit: "`d`->setDoubleDecimals(`d2`);".}

proc idSetDoubleStep*(d: InDlg, step: float64) =
  ## Шаг для double-спиннера.
  {.emit: "`d`->setDoubleStep(`step`);".}

proc idSetComboBoxItems*(d: InDlg, items: openArray[string]) =
  ## Установить список вариантов (в режиме выбора из списка).
  let n = items.len.cint
  var joined = ""
  for i, s in items:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    QStringList _slCbi2;
    const char* _pCbi2 = `data`;
    for (int _i = 0; _i < `n`; ++_i) {
      _slCbi2 << QString::fromUtf8(_pCbi2);
      _pCbi2 += std::strlen(_pCbi2) + 1;
    }
    `d`->setComboBoxItems(_slCbi2);
  """.}

proc idSetComboBoxEditable*(d: InDlg, b: bool) {.importcpp: "#->setComboBoxEditable(#)".}
  ## Разрешить редактирование выпадающего списка.

proc idSetStyleSheet*(d: InDlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc idResize*(d: InDlg, w, h: cint) {.importcpp: "#->resize(#, #)".}

proc idExec*(d: InDlg): DlgResult =
  ## Показать диалог модально. Возвращает DlgAccepted или DlgRejected.
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = cast[DlgResult](v)

proc idShow*(d: InDlg) {.importcpp: "#->show()".}
proc idAsW*(d: InDlg): W {.importcpp: "(QWidget*)#".}

# ── Сигналы QInputDialog ──────────────────────────────────────────────────────

proc onIdTextChanged*(d: InDlg, cb: CBStr, ud: pointer) =
  ## Сигнал: текст изменился.
  {.emit: """
    QObject::connect(`d`, &QInputDialog::textValueChanged,
      [=](const QString& _s){
        static QByteArray _bIdTc; _bIdTc = _s.toUtf8();
        `cb`(_bIdTc.constData(), `ud`);
      });
  """.}

proc onIdIntChanged*(d: InDlg, cb: CBInt, ud: pointer) =
  ## Сигнал: целое число изменилось.
  {.emit: "QObject::connect(`d`, &QInputDialog::intValueChanged, [=](int _v){ `cb`(_v, `ud`); });".}

proc onIdDoubleChanged*(d: InDlg, cb: proc(v: cdouble, ud: pointer) {.cdecl.}, ud: pointer) =
  ## Сигнал: вещественное число изменилось.
  {.emit: "QObject::connect(`d`, &QInputDialog::doubleValueChanged, [=](double _v){ `cb`(_v, `ud`); });".}

proc onIdAccepted*(d: InDlg, cb: CB, ud: pointer) =
  ## Сигнал: пользователь нажал OK.
  {.emit: "QObject::connect(`d`, &QInputDialog::accepted, [=](){ `cb`(`ud`); });".}

proc onIdRejected*(d: InDlg, cb: CB, ud: pointer) =
  ## Сигнал: пользователь нажал Cancel.
  {.emit: "QObject::connect(`d`, &QInputDialog::rejected, [=](){ `cb`(`ud`); });".}

proc onIdTextSelected*(d: InDlg, cb: CBStr, ud: pointer) =
  ## Сигнал: пользователь выбрал элемент из списка и подтвердил.
  {.emit: """
    QObject::connect(`d`, &QInputDialog::textValueSelected,
      [=](const QString& _s){
        static QByteArray _bIdTS; _bIdTS = _s.toUtf8();
        `cb`(_bIdTS.constData(), `ud`);
      });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 6. QFileDialog — статические методы
# ═══════════════════════════════════════════════════════════════════════════════

proc fileOpen*(parent: W,
               title: string = "Открыть файл",
               dir: string = "",
               filter: string = "Все файлы (*)"): FilePickResult =
  ## Диалог выбора одного существующего файла.
  ## Возвращает (ok=true, path) или (ok=false, "").
  let t = title.cstring; let dd = dir.cstring; let f = filter.cstring
  var p: cstring
  {.emit: """
    static QByteArray _bFO;
    _bFO = QFileDialog::getOpenFileName(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`dd`), QString::fromUtf8(`f`)).toUtf8();
    `p` = _bFO.constData();
  """.}
  let s = $p; result = (ok: s.len > 0, path: s)

proc fileOpenMany*(parent: W,
                   title: string = "Открыть файлы",
                   dir: string = "",
                   filter: string = "Все файлы (*)"): FilesPickResult =
  ## Диалог выбора нескольких файлов.
  let t = title.cstring; let dd = dir.cstring; let f = filter.cstring
  var n: cint
  {.emit: """
    static QStringList _slFOM;
    _slFOM = QFileDialog::getOpenFileNames(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`dd`), QString::fromUtf8(`f`));
    `n` = _slFOM.size();
  """.}
  var paths = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var pp: cstring
    {.emit: "static QByteArray _bFOMi; _bFOMi = _slFOM.at(`idx`).toUtf8(); `pp` = _bFOMi.constData();".}
    paths[i] = $pp
  result = (ok: n > 0, paths: paths)

proc fileSave*(parent: W,
               title: string = "Сохранить файл",
               dir: string = "",
               filter: string = "Все файлы (*)"): FilePickResult =
  ## Диалог выбора имени файла для сохранения.
  let t = title.cstring; let dd = dir.cstring; let f = filter.cstring
  var p: cstring
  {.emit: """
    static QByteArray _bFS;
    _bFS = QFileDialog::getSaveFileName(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`dd`), QString::fromUtf8(`f`)).toUtf8();
    `p` = _bFS.constData();
  """.}
  let s = $p; result = (ok: s.len > 0, path: s)

proc dirSelect*(parent: W,
                title: string = "Выбрать директорию",
                dir: string = "",
                showDirsOnly: bool = true): FilePickResult =
  ## Диалог выбора директории.
  let t = title.cstring; let dd = dir.cstring; let sd = showDirsOnly.cint
  var p: cstring
  {.emit: """
    QFileDialog::Options _dsOpts = QFileDialog::DontResolveSymlinks;
    if (`sd`) _dsOpts |= QFileDialog::ShowDirsOnly;
    static QByteArray _bDS;
    _bDS = QFileDialog::getExistingDirectory(`parent`, QString::fromUtf8(`t`),
      QString::fromUtf8(`dd`), _dsOpts).toUtf8();
    `p` = _bDS.constData();
  """.}
  let s = $p; result = (ok: s.len > 0, path: s)

proc fileOpenUrl*(parent: W,
                  title: string = "Открыть URL",
                  dir: string = "",
                  filter: string = "Все файлы (*)"): tuple[ok: bool, url: string] =
  ## Диалог открытия через QUrl (поддерживает удалённые ресурсы).
  let t = title.cstring; let dd = dir.cstring; let f = filter.cstring
  var p: cstring
  {.emit: """
    static QByteArray _bFUrl;
    QUrl _fUrl = QFileDialog::getOpenFileUrl(`parent`, QString::fromUtf8(`t`),
      QUrl(QString::fromUtf8(`dd`)), QString::fromUtf8(`f`));
    _bFUrl = _fUrl.toString().toUtf8();
    `p` = _bFUrl.constData();
  """.}
  let s = $p; result = (ok: s.len > 0, url: s)

proc fileSaveUrl*(parent: W,
                  title: string = "Сохранить файл",
                  dir: string = "",
                  filter: string = "Все файлы (*)"): tuple[ok: bool, url: string] =
  ## Диалог сохранения через QUrl.
  let t = title.cstring; let dd = dir.cstring; let f = filter.cstring
  var p: cstring
  {.emit: """
    static QByteArray _bFSUrl;
    QUrl _fsUrl = QFileDialog::getSaveFileUrl(`parent`, QString::fromUtf8(`t`),
      QUrl(QString::fromUtf8(`dd`)), QString::fromUtf8(`f`));
    _bFSUrl = _fsUrl.toString().toUtf8();
    `p` = _bFSUrl.constData();
  """.}
  let s = $p; result = (ok: s.len > 0, url: s)

# ── QFileDialog объектный API ─────────────────────────────────────────────────

proc newFileDialog*(parent: W = nil): FileDlg {.importcpp: "new QFileDialog(#)".}
  ## Создать QFileDialog для ручной настройки.

proc fdSetWindowTitle*(d: FileDlg, s: string) =
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc fdSetDirectory*(d: FileDlg, path: string) =
  ## Начальная директория.
  let cs = path.cstring
  {.emit: "`d`->setDirectory(QString::fromUtf8(`cs`));".}

proc fdDirectory*(d: FileDlg): string =
  ## Текущая директория диалога.
  var p: cstring
  {.emit: "static QByteArray _bFDDir; _bFDDir = `d`->directory().path().toUtf8(); `p` = _bFDDir.constData();".}
  result = $p

proc fdSetNameFilter*(d: FileDlg, filter: string) =
  ## Один фильтр вида "Изображения (*.png *.jpg)".
  let cs = filter.cstring
  {.emit: "`d`->setNameFilter(QString::fromUtf8(`cs`));".}

proc fdSetNameFilters*(d: FileDlg, filters: openArray[string]) =
  ## Несколько фильтров. Каждый — отдельная строка.
  let n = filters.len.cint
  var joined = ""
  for i, s in filters:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    QStringList _slNF;
    const char* _pNF = `data`;
    for (int _i = 0; _i < `n`; ++_i) {
      _slNF << QString::fromUtf8(_pNF);
      _pNF += std::strlen(_pNF) + 1;
    }
    `d`->setNameFilters(_slNF);
  """.}

proc fdSetMimeTypeFilters*(d: FileDlg, mimes: openArray[string]) =
  ## Фильтры по MIME-типу вместо масок.
  ## Пример: ["image/png", "image/jpeg", "application/pdf"]
  let n = mimes.len.cint
  var joined = ""
  for i, s in mimes:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    QStringList _slMF;
    const char* _pMF = `data`;
    for (int _i = 0; _i < `n`; ++_i) {
      _slMF << QString::fromUtf8(_pMF);
      _pMF += std::strlen(_pMF) + 1;
    }
    `d`->setMimeTypeFilters(_slMF);
  """.}

proc fdSetAcceptMode*(d: FileDlg, mode: FDAcceptMode) =
  ## Режим диалога: открыть или сохранить.
  let m = mode.cint
  {.emit: "`d`->setAcceptMode((QFileDialog::AcceptMode)`m`);".}

proc fdSetFileMode*(d: FileDlg, mode: FDFileMode) =
  ## Режим выбора: один файл, несколько, директория.
  let m = mode.cint
  {.emit: "`d`->setFileMode((QFileDialog::FileMode)`m`);".}

proc fdSetViewMode*(d: FileDlg, mode: FDViewMode) =
  ## Режим отображения: детали или иконки.
  let m = mode.cint
  {.emit: "`d`->setViewMode((QFileDialog::ViewMode)`m`);".}

proc fdSetOption*(d: FileDlg, opt: FDOption, on: bool = true) =
  ## Установить опцию поведения диалога.
  let o = opt.cint; let v = on.cint
  {.emit: "`d`->setOption((QFileDialog::Option)`o`, (bool)`v`);".}

proc fdSetOptions*(d: FileDlg, opts: cint) =
  ## Установить несколько опций сразу (OR-комбинация FDOption).
  {.emit: "`d`->setOptions((QFileDialog::Options)`opts`);".}

proc fdSetDefaultSuffix*(d: FileDlg, suffix: string) =
  ## Расширение по умолчанию (без точки, напр. "png").
  let cs = suffix.cstring
  {.emit: "`d`->setDefaultSuffix(QString::fromUtf8(`cs`));".}

proc fdSelectFile*(d: FileDlg, path: string) =
  ## Предварительно выбрать файл.
  let cs = path.cstring
  {.emit: "`d`->selectFile(QString::fromUtf8(`cs`));".}

proc fdSelectedFiles*(d: FileDlg): seq[string] =
  ## Список выбранных файлов (после exec).
  var n: cint
  {.emit: "static QStringList _slFSel; _slFSel = `d`->selectedFiles(); `n` = _slFSel.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bFSeli; _bFSeli = _slFSel.at(`idx`).toUtf8(); `p` = _bFSeli.constData();".}
    result[i] = $p

proc fdSelectedFile*(d: FileDlg): string =
  ## Первый выбранный файл (или "" если ничего не выбрано).
  let files = fdSelectedFiles(d)
  result = if files.len > 0: files[0] else: ""

proc fdSelectedNameFilter*(d: FileDlg): string =
  ## Возвращает текущий выбранный фильтр.
  var p: cstring
  {.emit: "static QByteArray _bFSNF; _bFSNF = `d`->selectedNameFilter().toUtf8(); `p` = _bFSNF.constData();".}
  result = $p

proc fdSetLabelText*(d: FileDlg, label: FDDialogLabel, text: string) =
  ## Переопределить текст стандартной метки диалога.
  let lv = label.cint; let cs = text.cstring
  {.emit: "`d`->setLabelText((QFileDialog::DialogLabel)`lv`, QString::fromUtf8(`cs`));".}

proc fdSetSidebarUrls*(d: FileDlg, urls: openArray[string]) =
  ## Закладки на боковой панели диалога.
  let n = urls.len.cint
  var joined = ""
  for i, s in urls:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    QList<QUrl> _urlL;
    const char* _pUrl = `data`;
    for (int _i = 0; _i < `n`; ++_i) {
      _urlL << QUrl(QString::fromUtf8(_pUrl));
      _pUrl += std::strlen(_pUrl) + 1;
    }
    `d`->setSidebarUrls(_urlL);
  """.}

proc fdSetHistory*(d: FileDlg, paths: openArray[string]) =
  ## Задать историю навигации.
  let n = paths.len.cint
  var joined = ""
  for i, s in paths:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  {.emit: """
    QStringList _hist;
    const char* _ph = `data`;
    for (int _i = 0; _i < `n`; ++_i) {
      _hist << QString::fromUtf8(_ph);
      _ph += std::strlen(_ph) + 1;
    }
    `d`->setHistory(_hist);
  """.}

proc fdHistory*(d: FileDlg): seq[string] =
  ## Текущая история навигации.
  var n: cint
  {.emit: "static QStringList _fdHist; _fdHist = `d`->history(); `n` = _fdHist.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bFDH; _bFDH = _fdHist.at(`idx`).toUtf8(); `p` = _bFDH.constData();".}
    result[i] = $p

proc fdExec*(d: FileDlg): DlgResult =
  ## Показать диалог модально. Возвращает DlgAccepted или DlgRejected.
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = cast[DlgResult](v)

proc fdOpen*(d: FileDlg) {.importcpp: "#->open()".}
  ## Показать диалог немодально.
proc fdShow*(d: FileDlg) {.importcpp: "#->show()".}
proc fdHide*(d: FileDlg) {.importcpp: "#->hide()".}
proc fdSetStyleSheet*(d: FileDlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc fdResize*(d: FileDlg, w, h: cint) {.importcpp: "#->resize(#, #)".}
proc fdAsW*(d: FileDlg): W {.importcpp: "(QWidget*)#".}

# ── Сигналы QFileDialog ───────────────────────────────────────────────────────

proc onFdCurrentChanged*(d: FileDlg, cb: CBStr, ud: pointer) =
  ## Текущий путь изменился (навигация).
  {.emit: """
    QObject::connect(`d`, &QFileDialog::currentChanged,
      [=](const QString& _p){
        static QByteArray _bFCC; _bFCC = _p.toUtf8();
        `cb`(_bFCC.constData(), `ud`);
      });
  """.}

proc onFdCurrentUrlChanged*(d: FileDlg, cb: CBStr, ud: pointer) =
  ## Текущий URL изменился.
  {.emit: """
    QObject::connect(`d`, &QFileDialog::currentUrlChanged,
      [=](const QUrl& _u){
        static QByteArray _bFCU; _bFCU = _u.toString().toUtf8();
        `cb`(_bFCU.constData(), `ud`);
      });
  """.}

proc onFdFileSelected*(d: FileDlg, cb: CBStr, ud: pointer) =
  ## Файл выбран (одиночный).
  {.emit: """
    QObject::connect(`d`, &QFileDialog::fileSelected,
      [=](const QString& _p){
        static QByteArray _bFFS; _bFFS = _p.toUtf8();
        `cb`(_bFFS.constData(), `ud`);
      });
  """.}

proc onFdDirectoryEntered*(d: FileDlg, cb: CBStr, ud: pointer) =
  ## Пользователь вошёл в директорию.
  {.emit: """
    QObject::connect(`d`, &QFileDialog::directoryEntered,
      [=](const QString& _p){
        static QByteArray _bFDE; _bFDE = _p.toUtf8();
        `cb`(_bFDE.constData(), `ud`);
      });
  """.}

proc onFdFilterSelected*(d: FileDlg, cb: CBStr, ud: pointer) =
  ## Пользователь сменил фильтр.
  {.emit: """
    QObject::connect(`d`, &QFileDialog::filterSelected,
      [=](const QString& _f){
        static QByteArray _bFFS2; _bFFS2 = _f.toUtf8();
        `cb`(_bFFS2.constData(), `ud`);
      });
  """.}

proc onFdAccepted*(d: FileDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QFileDialog::accepted, [=](){ `cb`(`ud`); });".}

proc onFdRejected*(d: FileDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QFileDialog::rejected, [=](){ `cb`(`ud`); });".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 7. QFontDialog
# ═══════════════════════════════════════════════════════════════════════════════

proc fontGet*(parent: W,
              title: string = "Выбрать шрифт",
              initFamily: string = "Arial",
              initSize: int = 12,
              initBold: bool = false,
              initItalic: bool = false): FontPickResult =
  ## Показать диалог выбора шрифта.
  ## Возвращает полное описание выбранного шрифта.
  let t = title.cstring; let fam = initFamily.cstring
  let sz = initSize.cint; let ib = initBold.cint; let ii = initItalic.cint
  var ok: cint
  var pfam: cstring
  var psz, pbold, pital, punder, pstrike, pweight: cint
  {.emit: """
    QFont _fgInit(QString::fromUtf8(`fam`), `sz`);
    _fgInit.setBold((bool)`ib`);
    _fgInit.setItalic((bool)`ii`);
    bool _fgOk = false;
    QFont _fgF = QFontDialog::getFont(&_fgOk, _fgInit, `parent`, QString::fromUtf8(`t`));
    `ok` = _fgOk ? 1 : 0;
    static QByteArray _bFGF;
    _bFGF = _fgF.family().toUtf8();
    `pfam`   = _bFGF.constData();
    `psz`    = _fgF.pointSize();
    `pbold`  = _fgF.bold()      ? 1 : 0;
    `pital`  = _fgF.italic()    ? 1 : 0;
    `punder` = _fgF.underline() ? 1 : 0;
    `pstrike`= _fgF.strikeOut() ? 1 : 0;
    `pweight`= (int)_fgF.weight();
  """.}
  result = (ok: ok == 1, family: $pfam, pointSize: psz.int,
            bold: pbold == 1, italic: pital == 1, underline: punder == 1,
            strikeOut: pstrike == 1, weight: pweight.int)

proc newFontDialog*(parent: W = nil): FontDlg {.importcpp: "new QFontDialog(#)".}
  ## Создать QFontDialog для ручной настройки.

proc ftdSetCurrentFont*(d: FontDlg, family: string, size: int,
                        bold: bool = false, italic: bool = false,
                        underline: bool = false, strikeOut: bool = false) =
  ## Задать текущий шрифт в диалоге.
  let cs = family.cstring; let sz = size.cint
  let b = bold.cint; let it = italic.cint
  let ul = underline.cint; let so = strikeOut.cint
  {.emit: """
    QFont _ftdF(QString::fromUtf8(`cs`), `sz`);
    _ftdF.setBold((bool)`b`);
    _ftdF.setItalic((bool)`it`);
    _ftdF.setUnderline((bool)`ul`);
    _ftdF.setStrikeOut((bool)`so`);
    `d`->setCurrentFont(_ftdF);
  """.}

proc ftdCurrentFamily*(d: FontDlg): string =
  var p: cstring
  {.emit: "static QByteArray _bFtdF; _bFtdF = `d`->currentFont().family().toUtf8(); `p` = _bFtdF.constData();".}
  result = $p

proc ftdCurrentPointSize*(d: FontDlg): int =
  var v: cint
  {.emit: "`v` = `d`->currentFont().pointSize();".}
  result = v.int

proc ftdCurrentBold*(d: FontDlg): bool =
  var v: cint
  {.emit: "`v` = `d`->currentFont().bold() ? 1 : 0;".}
  result = v == 1

proc ftdCurrentItalic*(d: FontDlg): bool =
  var v: cint
  {.emit: "`v` = `d`->currentFont().italic() ? 1 : 0;".}
  result = v == 1

proc ftdCurrentUnderline*(d: FontDlg): bool =
  var v: cint
  {.emit: "`v` = `d`->currentFont().underline() ? 1 : 0;".}
  result = v == 1

proc ftdCurrentStrikeOut*(d: FontDlg): bool =
  var v: cint
  {.emit: "`v` = `d`->currentFont().strikeOut() ? 1 : 0;".}
  result = v == 1

proc ftdCurrentWeight*(d: FontDlg): int =
  var v: cint
  {.emit: "`v` = (int)`d`->currentFont().weight();".}
  result = v.int

proc ftdCurrentFontStr*(d: FontDlg): string =
  ## Шрифт в виде строки "family,size,bold,italic" для сохранения.
  let fam = ftdCurrentFamily(d)
  let sz  = ftdCurrentPointSize(d)
  let b   = if ftdCurrentBold(d):   "1" else: "0"
  let it  = if ftdCurrentItalic(d): "1" else: "0"
  result = fam & "," & $sz & "," & b & "," & it

proc ftdSetOption*(d: FontDlg, opt: FontDlgOption, on: bool = true) =
  ## Установить флаг поведения диалога.
  let o = opt.cint; let v = on.cint
  {.emit: "`d`->setOption((QFontDialog::FontDialogOption)`o`, (bool)`v`);".}

proc ftdSetWindowTitle*(d: FontDlg, s: string) =
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc ftdExec*(d: FontDlg): DlgResult =
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = cast[DlgResult](v)

proc ftdShow*(d: FontDlg) {.importcpp: "#->show()".}
proc ftdSetStyleSheet*(d: FontDlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc ftdAsW*(d: FontDlg): W {.importcpp: "(QWidget*)#".}

# ── Сигналы QFontDialog ───────────────────────────────────────────────────────

proc onFtdCurrentFontChanged*(d: FontDlg, cb: CBStr, ud: pointer) =
  ## Сигнал: текущий шрифт изменился. Параметр: семейство шрифта.
  {.emit: """
    QObject::connect(`d`, &QFontDialog::currentFontChanged,
      [=](const QFont& _f){
        static QByteArray _bFtdCC; _bFtdCC = _f.family().toUtf8();
        `cb`(_bFtdCC.constData(), `ud`);
      });
  """.}

proc onFtdFontSelected*(d: FontDlg, cb: CBStr, ud: pointer) =
  ## Сигнал: шрифт выбран и подтверждён.
  {.emit: """
    QObject::connect(`d`, &QFontDialog::fontSelected,
      [=](const QFont& _f){
        static QByteArray _bFtdFS; _bFtdFS = _f.family().toUtf8();
        `cb`(_bFtdFS.constData(), `ud`);
      });
  """.}

proc onFtdAccepted*(d: FontDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QFontDialog::accepted, [=](){ `cb`(`ud`); });".}
proc onFtdRejected*(d: FontDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QFontDialog::rejected, [=](){ `cb`(`ud`); });".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 8. QColorDialog
# ═══════════════════════════════════════════════════════════════════════════════

proc colorGet*(parent: W,
               title: string = "Выбрать цвет",
               initR: int = 255, initG: int = 255,
               initB: int = 255, initA: int = 255,
               showAlpha: bool = false): ColorPickResult =
  ## Диалог выбора цвета в формате RGBA (0–255 каждый канал).
  let t = title.cstring
  let ir = initR.cint; let ig = initG.cint
  let ib = initB.cint; let ia = initA.cint; let sa = showAlpha.cint
  var ok: cint; var r, g, b, a: cint
  {.emit: """
    QColorDialog::ColorDialogOptions _cgOpts;
    if (`sa`) _cgOpts |= QColorDialog::ShowAlphaChannel;
    QColor _cgC = QColorDialog::getColor(
      QColor(`ir`, `ig`, `ib`, `ia`), `parent`,
      QString::fromUtf8(`t`), _cgOpts);
    `ok` = _cgC.isValid() ? 1 : 0;
    `r` = _cgC.red();
    `g` = _cgC.green();
    `b` = _cgC.blue();
    `a` = _cgC.alpha();
  """.}
  result = (ok: ok == 1, r: r.int, g: g.int, b: b.int, a: a.int)

proc colorGetHex*(parent: W,
                  title: string = "Выбрать цвет",
                  initHex: string = "#ffffff"): tuple[ok: bool, hex: string] =
  ## Диалог выбора цвета. Возвращает hex-строку формата "#rrggbb".
  let t = title.cstring; let ih = initHex.cstring
  var ok: cint; var p: cstring
  {.emit: """
    QColor _cghC = QColorDialog::getColor(
      QColor(QString::fromUtf8(`ih`)), `parent`, QString::fromUtf8(`t`));
    `ok` = _cghC.isValid() ? 1 : 0;
    static QByteArray _bCGH;
    _bCGH = _cghC.name().toUtf8();
    `p` = _bCGH.constData();
  """.}
  result = (ok: ok == 1, hex: $p)

proc colorGetHexAlpha*(parent: W,
                       title: string = "Выбрать цвет (с прозрачностью)",
                       initHex: string = "#ffffffff"): tuple[ok: bool, hex: string] =
  ## Диалог выбора цвета с прозрачностью.
  ## Возвращает hex-строку формата "#aarrggbb".
  let t = title.cstring; let ih = initHex.cstring
  var ok: cint; var p: cstring
  {.emit: """
    QColor _cghaInit;
    _cghaInit.setNamedColor(QString::fromUtf8(`ih`));
    QColor _cghaC = QColorDialog::getColor(_cghaInit, `parent`,
      QString::fromUtf8(`t`), QColorDialog::ShowAlphaChannel);
    `ok` = _cghaC.isValid() ? 1 : 0;
    static QByteArray _bCGHA;
    _bCGHA = _cghaC.name(QColor::HexArgb).toUtf8();
    `p` = _bCGHA.constData();
  """.}
  result = (ok: ok == 1, hex: $p)

proc newColorDialog*(parent: W = nil): ColDlg {.importcpp: "new QColorDialog(#)".}
  ## Создать QColorDialog для ручной настройки.

proc cdSetCurrentColor*(d: ColDlg, r, g, b: int, a: int = 255) =
  ## Задать начальный цвет в формате RGBA.
  let cr = r.cint; let cg = g.cint; let cb = b.cint; let ca = a.cint
  {.emit: "`d`->setCurrentColor(QColor(`cr`, `cg`, `cb`, `ca`));".}

proc cdSetCurrentColorHex*(d: ColDlg, hex: string) =
  ## Задать начальный цвет в hex-формате "#rrggbb" или "#aarrggbb".
  let cs = hex.cstring
  {.emit: "`d`->setCurrentColor(QColor(QString::fromUtf8(`cs`)));".}

proc cdCurrentRGBA*(d: ColDlg): tuple[r, g, b, a: int] =
  ## Получить текущий цвет (RGBA, 0–255).
  var r, g, b, a: cint
  {.emit: """
    QColor _cdc = `d`->currentColor();
    `r` = _cdc.red(); `g` = _cdc.green();
    `b` = _cdc.blue(); `a` = _cdc.alpha();
  """.}
  result = (r.int, g.int, b.int, a.int)

proc cdCurrentR*(d: ColDlg): int =
  var v: cint
  {.emit: "`v` = `d`->currentColor().red();".}
  result = v.int

proc cdCurrentG*(d: ColDlg): int =
  var v: cint
  {.emit: "`v` = `d`->currentColor().green();".}
  result = v.int

proc cdCurrentB*(d: ColDlg): int =
  var v: cint
  {.emit: "`v` = `d`->currentColor().blue();".}
  result = v.int

proc cdCurrentA*(d: ColDlg): int =
  var v: cint
  {.emit: "`v` = `d`->currentColor().alpha();".}
  result = v.int

proc cdCurrentHex*(d: ColDlg): string =
  ## Текущий цвет как "#rrggbb".
  var p: cstring
  {.emit: "static QByteArray _bCdH; _bCdH = `d`->currentColor().name().toUtf8(); `p` = _bCdH.constData();".}
  result = $p

proc cdCurrentHexAlpha*(d: ColDlg): string =
  ## Текущий цвет как "#aarrggbb".
  var p: cstring
  {.emit: "static QByteArray _bCdHA; _bCdHA = `d`->currentColor().name(QColor::HexArgb).toUtf8(); `p` = _bCdHA.constData();".}
  result = $p

proc cdSetOption*(d: ColDlg, opt: ColorDlgOption, on: bool = true) =
  ## Установить флаг поведения диалога цвета.
  let o = opt.cint; let v = on.cint
  {.emit: "`d`->setOption((QColorDialog::ColorDialogOption)`o`, (bool)`v`);".}

proc cdSetCustomColor*(index: int, r, g, b: int) =
  ## Установить кастомный цвет в палитре (статический метод, 0..15).
  let i = index.cint; let cr = r.cint; let cg = g.cint; let cb = b.cint
  {.emit: "QColorDialog::setCustomColor(`i`, QColor(`cr`, `cg`, `cb`));".}

proc cdCustomColor*(index: int): tuple[r, g, b: int] =
  ## Получить кастомный цвет из палитры (0..15).
  let i = index.cint; var r, g, b: cint
  {.emit: "QColor _ccc = QColorDialog::customColor(`i`); `r`=_ccc.red(); `g`=_ccc.green(); `b`=_ccc.blue();".}
  result = (r.int, g.int, b.int)

proc cdCustomColorCount*(): int =
  ## Количество слотов кастомных цветов (обычно 16).
  var v: cint
  {.emit: "`v` = QColorDialog::customCount();".}
  result = v.int

proc cdSetWindowTitle*(d: ColDlg, s: string) =
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc cdExec*(d: ColDlg): DlgResult =
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = cast[DlgResult](v)

proc cdOpen*(d: ColDlg) {.importcpp: "#->open()".}
proc cdShow*(d: ColDlg) {.importcpp: "#->show()".}
proc cdSetStyleSheet*(d: ColDlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc cdAsW*(d: ColDlg): W {.importcpp: "(QWidget*)#".}

# ── Сигналы QColorDialog ──────────────────────────────────────────────────────

proc onCdColorSelected*(d: ColDlg, cb: CBStr, ud: pointer) =
  ## Сигнал: цвет выбран и подтверждён. Параметр: hex-строка "#rrggbb".
  {.emit: """
    QObject::connect(`d`, &QColorDialog::colorSelected,
      [=](const QColor& _c){
        static QByteArray _bCdCS; _bCdCS = _c.name().toUtf8();
        `cb`(_bCdCS.constData(), `ud`);
      });
  """.}

proc onCdCurrentColorChanged*(d: ColDlg, cb: CBStr, ud: pointer) =
  ## Сигнал: текущий цвет изменился (до подтверждения).
  {.emit: """
    QObject::connect(`d`, &QColorDialog::currentColorChanged,
      [=](const QColor& _c){
        static QByteArray _bCdCC; _bCdCC = _c.name().toUtf8();
        `cb`(_bCdCC.constData(), `ud`);
      });
  """.}

proc onCdAccepted*(d: ColDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QColorDialog::accepted, [=](){ `cb`(`ud`); });".}
proc onCdRejected*(d: ColDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QColorDialog::rejected, [=](){ `cb`(`ud`); });".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 9. QProgressDialog
# ═══════════════════════════════════════════════════════════════════════════════

proc newProgressDialog*(parent: W = nil,
                        label: string = "Выполняется...",
                        cancelBtn: string = "Отмена",
                        minVal: int = 0,
                        maxVal: int = 100): ProgDlg =
  ## Создать диалог прогресса.
  ## cancelBtn = "" скрывает кнопку отмены (неотменяемая операция).
  let l = label.cstring; let c = cancelBtn.cstring
  let mn = minVal.cint; let mx = maxVal.cint
  {.emit: """
    `result` = new QProgressDialog(
      QString::fromUtf8(`l`),
      QString::fromUtf8(`c`),
      `mn`, `mx`, `parent`);
  """.}

proc newProgressDialogNoCancel*(parent: W = nil,
                                label: string = "Выполняется...",
                                minVal: int = 0,
                                maxVal: int = 100): ProgDlg =
  ## Прогресс-диалог без кнопки «Отмена» (неотменяемая операция).
  let l = label.cstring; let mn = minVal.cint; let mx = maxVal.cint
  {.emit: """
    `result` = new QProgressDialog(
      QString::fromUtf8(`l`), QString(), `mn`, `mx`, `parent`);
    `result`->setCancelButton(nullptr);
  """.}

proc pdSetValue*(d: ProgDlg, v: int) =
  ## Установить текущее значение прогресса.
  let vi = v.cint
  {.emit: "`d`->setValue(`vi`);".}

proc pdValue*(d: ProgDlg): int =
  ## Получить текущее значение прогресса.
  var v: cint
  {.emit: "`v` = `d`->value();".}
  result = v.int

proc pdSetRange*(d: ProgDlg, mn, mx: int) =
  ## Задать диапазон значений.
  let a = mn.cint; let b = mx.cint
  {.emit: "`d`->setRange(`a`, `b`);".}

proc pdMinimum*(d: ProgDlg): int =
  var v: cint
  {.emit: "`v` = `d`->minimum();".}
  result = v.int

proc pdMaximum*(d: ProgDlg): int =
  var v: cint
  {.emit: "`v` = `d`->maximum();".}
  result = v.int

proc pdSetLabelText*(d: ProgDlg, s: string) =
  ## Обновить текст метки прогресса (можно вызывать в цикле).
  let cs = s.cstring
  {.emit: "`d`->setLabelText(QString::fromUtf8(`cs`));".}

proc pdSetWindowTitle*(d: ProgDlg, s: string) =
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc pdSetCancelButtonText*(d: ProgDlg, s: string) =
  ## Изменить текст кнопки отмены.
  let cs = s.cstring
  {.emit: "`d`->setCancelButtonText(QString::fromUtf8(`cs`));".}

proc pdSetMinimumDuration*(d: ProgDlg, ms: int) =
  ## Задержка (мс) перед показом диалога (по умолчанию 4000 мс).
  ## 0 — показывать сразу.
  let m = ms.cint
  {.emit: "`d`->setMinimumDuration(`m`);".}

proc pdSetAutoClose*(d: ProgDlg, b: bool) {.importcpp: "#->setAutoClose(#)".}
  ## Закрывать автоматически при 100%.
proc pdSetAutoReset*(d: ProgDlg, b: bool) {.importcpp: "#->setAutoReset(#)".}
  ## Сбрасывать значение при 100%.
proc pdSetModal*(d: ProgDlg, b: bool) {.importcpp: "#->setModal(#)".}
  ## Модальность диалога.

proc pdWasCanceled*(d: ProgDlg): bool =
  ## Вернуть true, если пользователь нажал «Отмена».
  var r: cint
  {.emit: "`r` = `d`->wasCanceled() ? 1 : 0;".}
  result = r == 1

proc pdReset*(d: ProgDlg) {.importcpp: "#->reset()".}
proc pdShow*(d: ProgDlg)  {.importcpp: "#->show()".}
proc pdHide*(d: ProgDlg)  {.importcpp: "#->hide()".}
proc pdClose*(d: ProgDlg) {.importcpp: "#->close()".}
proc pdSetStyleSheet*(d: ProgDlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc pdResize*(d: ProgDlg, w, h: cint) {.importcpp: "#->resize(#, #)".}
proc pdAsW*(d: ProgDlg): W {.importcpp: "(QWidget*)#".}

proc pdStep*(d: ProgDlg, increment: int = 1) =
  ## Увеличить значение прогресса на increment и обработать события GUI.
  ## Используйте в цикле для поддержания отзывчивости UI.
  var cur: cint
  {.emit: "`cur` = `d`->value();".}
  let nxt = cur + increment.cint
  {.emit: "`d`->setValue(`nxt`); QApplication::processEvents();".}

proc onPdCanceled*(d: ProgDlg, cb: CB, ud: pointer) =
  ## Сигнал: пользователь нажал «Отмена».
  {.emit: "QObject::connect(`d`, &QProgressDialog::canceled, [=](){ `cb`(`ud`); });".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 10. QErrorMessage
# ═══════════════════════════════════════════════════════════════════════════════

proc newErrorMessage*(parent: W = nil): ErrMsg {.importcpp: "new QErrorMessage(#)".}
  ## Создать QErrorMessage.

proc emShowMessage*(d: ErrMsg, msg: string) =
  ## Показать сообщение об ошибке.
  ## Повторные вызовы с одинаковым текстом подавляются после «Не показывать».
  let cs = msg.cstring
  {.emit: "`d`->showMessage(QString::fromUtf8(`cs`));".}

proc emShowMessageType*(d: ErrMsg, msg: string, msgType: string) =
  ## Показать сообщение с типом (разные типы подавляются независимо).
  let cm = msg.cstring; let ct = msgType.cstring
  {.emit: "`d`->showMessage(QString::fromUtf8(`cm`), QString::fromUtf8(`ct`));".}

proc emSetWindowTitle*(d: ErrMsg, s: string) =
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc emExec*(d: ErrMsg): int =
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = v.int

proc emShow*(d: ErrMsg) {.importcpp: "#->show()".}
proc emAsW*(d: ErrMsg): W {.importcpp: "(QWidget*)#".}

proc appErrorMessage*(): ErrMsg =
  ## Синглтон QErrorMessage::qtHandler() — перехватывает qWarning().
  {.emit: "`result` = QErrorMessage::qtHandler();".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 11. QDialogButtonBox
# ═══════════════════════════════════════════════════════════════════════════════

proc newDlgButtonBox*(buttons: cint, parent: W = nil): DlgBBx =
  ## Создать панель кнопок с горизонтальной ориентацией.
  ## buttons: OR-комбинация DlgBBxStdBtn, напр. DBBOk.cint or DBBCancel.cint
  {.emit: "`result` = new QDialogButtonBox((QDialogButtonBox::StandardButtons)`buttons`, `parent`);".}

proc newDlgButtonBoxH*(buttons: cint, parent: W = nil): DlgBBx =
  ## Горизонтальная панель кнопок (явно).
  {.emit: "`result` = new QDialogButtonBox((QDialogButtonBox::StandardButtons)`buttons`, Qt::Horizontal, `parent`);".}

proc newDlgButtonBoxV*(buttons: cint, parent: W = nil): DlgBBx =
  ## Вертикальная панель кнопок.
  {.emit: "`result` = new QDialogButtonBox((QDialogButtonBox::StandardButtons)`buttons`, Qt::Vertical, `parent`);".}

proc dbbButton*(box: DlgBBx, btn: DlgBBxStdBtn): AbsBtn =
  ## Получить указатель на стандартную кнопку (для настройки текста и т.п.).
  let b = btn.cint
  {.emit: "`result` = `box`->button((QDialogButtonBox::StandardButton)`b`);".}

proc dbbAddButton*(box: DlgBBx, text: string, role: DlgBBxRole): AbsBtn =
  ## Добавить произвольную кнопку с заданной ролью.
  let cs = text.cstring; let r = role.cint
  {.emit: "`result` = `box`->addButton(QString::fromUtf8(`cs`), (QDialogButtonBox::ButtonRole)`r`);".}

proc dbbRemoveButton*(box: DlgBBx, btn: AbsBtn) {.importcpp: "#->removeButton(#)".}
  ## Удалить кнопку из панели.

proc dbbSetEnabled*(box: DlgBBx, btn: DlgBBxStdBtn, on: bool) =
  ## Включить/отключить стандартную кнопку.
  let b = btn.cint; let v = on.cint
  {.emit: """
    if (auto* _dbbB = `box`->button((QDialogButtonBox::StandardButton)`b`))
      _dbbB->setEnabled((bool)`v`);
  """.}

proc dbbSetButtonText*(box: DlgBBx, btn: DlgBBxStdBtn, text: string) =
  ## Изменить текст стандартной кнопки.
  let b = btn.cint; let cs = text.cstring
  {.emit: """
    if (auto* _dbbBT = `box`->button((QDialogButtonBox::StandardButton)`b`))
      _dbbBT->setText(QString::fromUtf8(`cs`));
  """.}

proc dbbSetStdButtons*(box: DlgBBx, buttons: cint) =
  ## Заменить набор стандартных кнопок.
  {.emit: "`box`->setStandardButtons((QDialogButtonBox::StandardButtons)`buttons`);".}

proc dbbSetOrientation*(box: DlgBBx, horiz: bool) =
  ## Переключить ориентацию панели.
  let o: cint = if horiz: 1 else: 2
  {.emit: "`box`->setOrientation((Qt::Orientation)`o`);".}

proc dbbSetCenterButtons*(box: DlgBBx, b: bool) {.importcpp: "#->setCenterButtons(#)".}
  ## Центрировать кнопки внутри панели.
proc dbbSetStyleSheet*(box: DlgBBx, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc dbbAsW*(box: DlgBBx): W {.importcpp: "(QWidget*)#".}

# ── Сигналы QDialogButtonBox ──────────────────────────────────────────────────

proc onDbbAccepted*(box: DlgBBx, cb: CB, ud: pointer) =
  ## Сигнал: нажата кнопка с ролью AcceptRole (OK/Yes/Save).
  {.emit: "QObject::connect(`box`, &QDialogButtonBox::accepted, [=](){ `cb`(`ud`); });".}

proc onDbbRejected*(box: DlgBBx, cb: CB, ud: pointer) =
  ## Сигнал: нажата кнопка с ролью RejectRole (Cancel/No).
  {.emit: "QObject::connect(`box`, &QDialogButtonBox::rejected, [=](){ `cb`(`ud`); });".}

proc onDbbClicked*(box: DlgBBx, cb: CBStr, ud: pointer) =
  ## Сигнал: нажата любая кнопка. Параметр: текст кнопки.
  {.emit: """
    QObject::connect(`box`, &QDialogButtonBox::clicked,
      [=](QAbstractButton* _b){
        static QByteArray _bDbbCl; _bDbbCl = _b->text().toUtf8();
        `cb`(_bDbbCl.constData(), `ud`);
      });
  """.}

proc onDbbHelpRequested*(box: DlgBBx, cb: CB, ud: pointer) =
  ## Сигнал: нажата кнопка справки.
  {.emit: "QObject::connect(`box`, &QDialogButtonBox::helpRequested, [=](){ `cb`(`ud`); });".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 12. QDialog — базовый кастомный диалог
# ═══════════════════════════════════════════════════════════════════════════════

proc newCustomDialog*(parent: W = nil, flags: cint = 0): CDlg =
  ## Создать пустой QDialog. flags — Qt::WindowFlags.
  if flags == 0:
    {.emit: "`result` = new QDialog(`parent`);".}
  else:
    {.emit: "`result` = new QDialog(`parent`, (Qt::WindowFlags)`flags`);".}

proc cdlgExec*(d: CDlg): DlgResult =
  ## Показать диалог модально. Возвращает DlgAccepted/DlgRejected.
  var v: cint
  {.emit: "`v` = `d`->exec();".}
  result = cast[DlgResult](v)

proc cdlgOpen*(d: CDlg) {.importcpp: "#->open()".}
  ## Показать полумодально (блокирует только родительское окно).
proc cdlgShow*(d: CDlg)  {.importcpp: "#->show()".}
proc cdlgHide*(d: CDlg)  {.importcpp: "#->hide()".}
proc cdlgClose*(d: CDlg) {.importcpp: "#->close()".}
proc cdlgAccept*(d: CDlg) {.importcpp: "#->accept()".}
proc cdlgReject*(d: CDlg) {.importcpp: "#->reject()".}
proc cdlgDone*(d: CDlg, r: cint) {.importcpp: "#->done(#)".}

proc cdlgSetModal*(d: CDlg, b: bool) {.importcpp: "#->setModal(#)".}
proc cdlgSetWindowModality*(d: CDlg, m: WindowModality) =
  ## Установить тип модальности.
  let mi = m.cint
  {.emit: "`d`->setWindowModality((Qt::WindowModality)`mi`);".}

proc cdlgSetWindowTitle*(d: CDlg, s: string) =
  let cs = s.cstring
  {.emit: "`d`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc cdlgWindowTitle*(d: CDlg): string =
  var p: cstring
  {.emit: "static QByteArray _bCdWT; _bCdWT = `d`->windowTitle().toUtf8(); `p` = _bCdWT.constData();".}
  result = $p

proc cdlgResize*(d: CDlg, w, h: cint)      {.importcpp: "#->resize(#, #)".}
proc cdlgSetMinSize*(d: CDlg, w, h: cint)  {.importcpp: "#->setMinimumSize(#, #)".}
proc cdlgSetMaxSize*(d: CDlg, w, h: cint)  {.importcpp: "#->setMaximumSize(#, #)".}
proc cdlgSetFixedSize*(d: CDlg, w, h: cint){.importcpp: "#->setFixedSize(#, #)".}
proc cdlgSetSizeGripEnabled*(d: CDlg, b: bool) {.importcpp: "#->setSizeGripEnabled(#)".}
proc cdlgSetStyleSheet*(d: CDlg, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc cdlgAdjustSize*(d: CDlg) {.importcpp: "#->adjustSize()".}
proc cdlgAsW*(d: CDlg): W    {.importcpp: "(QWidget*)#".}

# Перегрузки setLayout для всех типов раскладок
proc cdlgSetLayout*(d: CDlg, l: VBox) {.importcpp: "#->setLayout(#)".}
proc cdlgSetLayout*(d: CDlg, l: HBox) {.importcpp: "#->setLayout(#)".}
proc cdlgSetLayout*(d: CDlg, l: Grid) {.importcpp: "#->setLayout(#)".}
proc cdlgSetLayout*(d: CDlg, l: Form) {.importcpp: "#->setLayout(#)".}

proc cdlgSetWindowFlags*(d: CDlg, flags: cint) =
  ## Установить флаги окна (Qt::WindowFlags).
  {.emit: "`d`->setWindowFlags((Qt::WindowFlags)`flags`);".}

proc cdlgSetWindowFlag*(d: CDlg, flag: cint, on: bool = true) =
  ## Установить/снять один флаг окна.
  let bv = on.cint
  {.emit: "`d`->setWindowFlag((Qt::WindowType)`flag`, (bool)`bv`);".}

proc cdlgResult*(d: CDlg): int =
  ## Результат последнего exec() (Accepted=1, Rejected=0).
  var v: cint
  {.emit: "`v` = `d`->result();".}
  result = v.int

# ── Сигналы QDialog ───────────────────────────────────────────────────────────

proc onCdlgAccepted*(d: CDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QDialog::accepted, [=](){ `cb`(`ud`); });".}
proc onCdlgRejected*(d: CDlg, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QDialog::rejected, [=](){ `cb`(`ud`); });".}
proc onCdlgFinished*(d: CDlg, cb: CBInt, ud: pointer) =
  {.emit: "QObject::connect(`d`, &QDialog::finished, [=](int _r){ `cb`(_r, `ud`); });".}

# ── Builder-хелперы для быстрого создания диалогов ──────────────────────────

proc buildSimpleDialog*(parent: W, title: string, body: W,
                        buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg =
  ## Быстро создать диалог: заголовок + виджет + QDialogButtonBox.
  ## accept/reject подключены автоматически.
  ## Пример:
  ##   let editor = newPlainTextEdit(nil)
  ##   let dlg = buildSimpleDialog(win.asW, "Редактор", editor.asW)
  ##   if dlg.cdlgExec() == DlgAccepted:
  ##     doSomething(editor.text)
  let t = title.cstring; let b = buttons.cint
  {.emit: """
    `result` = new QDialog(`parent`);
    `result`->setWindowTitle(QString::fromUtf8(`t`));
    auto* _bsdVl = new QVBoxLayout(`result`);
    _bsdVl->addWidget(`body`);
    auto* _bsdBb = new QDialogButtonBox(
      (QDialogButtonBox::StandardButtons)`b`, `result`);
    QObject::connect(_bsdBb, &QDialogButtonBox::accepted, `result`, &QDialog::accept);
    QObject::connect(_bsdBb, &QDialogButtonBox::rejected, `result`, &QDialog::reject);
    _bsdVl->addWidget(_bsdBb);
    `result`->setLayout(_bsdVl);
  """.}

proc buildLabeledDialog*(parent: W, title, labelText: string, body: W,
                         buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg =
  ## Как buildSimpleDialog, но с QLabel над виджетом.
  ## Пример:
  ##   let le = newLineEdit(nil)
  ##   let dlg = buildLabeledDialog(nil, "Ввод", "Введите значение:", le.asW)
  let t = title.cstring; let lt = labelText.cstring; let b = buttons.cint
  {.emit: """
    `result` = new QDialog(`parent`);
    `result`->setWindowTitle(QString::fromUtf8(`t`));
    auto* _bldVl = new QVBoxLayout(`result`);
    _bldVl->addWidget(new QLabel(QString::fromUtf8(`lt`), `result`));
    _bldVl->addWidget(`body`);
    auto* _bldBb = new QDialogButtonBox(
      (QDialogButtonBox::StandardButtons)`b`, `result`);
    QObject::connect(_bldBb, &QDialogButtonBox::accepted, `result`, &QDialog::accept);
    QObject::connect(_bldBb, &QDialogButtonBox::rejected, `result`, &QDialog::reject);
    _bldVl->addWidget(_bldBb);
    `result`->setLayout(_bldVl);
  """.}

proc buildGridDialog*(parent: W, title: string,
                      rows: openArray[tuple[label: string, widget: W]],
                      buttons: cint = DBBOk.cint or DBBCancel.cint): CDlg =
  ## Создать диалог с сеткой label-виджет (QFormLayout).
  ## Пример:
  ##   let nameEdit = newLineEdit(nil)
  ##   let ageEdit  = newSpinBox(nil)
  ##   let dlg = buildGridDialog(nil, "Новый пользователь", [
  ##     ("Имя:", nameEdit.asW), ("Возраст:", ageEdit.asW)])
  let t = title.cstring; let b = buttons.cint; let n = rows.len.cint
  {.emit: """
    `result` = new QDialog(`parent`);
    `result`->setWindowTitle(QString::fromUtf8(`t`));
    auto* _bgdVl = new QVBoxLayout(`result`);
    auto* _bgdFl = new QFormLayout();
  """.}
  for row in rows:
    let lcs = row.label.cstring; let wgt = row.widget
    {.emit: "_bgdFl->addRow(QString::fromUtf8(`lcs`), `wgt`);".}
  {.emit: """
    _bgdVl->addLayout(_bgdFl);
    auto* _bgdBb = new QDialogButtonBox(
      (QDialogButtonBox::StandardButtons)`b`, `result`);
    QObject::connect(_bgdBb, &QDialogButtonBox::accepted, `result`, &QDialog::accept);
    QObject::connect(_bgdBb, &QDialogButtonBox::rejected, `result`, &QDialog::reject);
    _bgdVl->addWidget(_bgdBb);
    `result`->setLayout(_bgdVl);
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 13. QWizard — мастер (wizard)
# ═══════════════════════════════════════════════════════════════════════════════

proc newWizard*(parent: W = nil): Wiz {.importcpp: "new QWizard(#)".}
  ## Создать новый QWizard.

proc wizAddPage*(w: Wiz, page: WizPage): int =
  ## Добавить страницу. Возвращает автоматически назначенный ID.
  var v: cint
  {.emit: "`v` = `w`->addPage(`page`);".}
  result = v.int

proc wizSetPage*(w: Wiz, id: int, page: WizPage) =
  ## Добавить страницу с заданным ID.
  let i = id.cint
  {.emit: "`w`->setPage(`i`, `page`);".}

proc wizRemovePage*(w: Wiz, id: int) =
  ## Удалить страницу по ID.
  let i = id.cint
  {.emit: "`w`->removePage(`i`);".}

proc wizCurrentId*(w: Wiz): int =
  var v: cint
  {.emit: "`v` = `w`->currentId();".}
  result = v.int

proc wizCurrentPage*(w: Wiz): WizPage {.importcpp: "#->currentPage()".}
proc wizNextId*(w: Wiz): int =
  var v: cint
  {.emit: "`v` = `w`->nextId();".}
  result = v.int

proc wizSetStartId*(w: Wiz, id: int) =
  let i = id.cint
  {.emit: "`w`->setStartId(`i`);".}

proc wizStartId*(w: Wiz): int =
  var v: cint
  {.emit: "`v` = `w`->startId();".}
  result = v.int

proc wizRestart*(w: Wiz) {.importcpp: "#->restart()".}
proc wizBack*(w: Wiz)    {.importcpp: "#->back()".}
proc wizNext*(w: Wiz)    {.importcpp: "#->next()".}

proc wizSetWindowTitle*(w: Wiz, s: string) =
  let cs = s.cstring
  {.emit: "`w`->setWindowTitle(QString::fromUtf8(`cs`));".}

proc wizSetWizardStyle*(w: Wiz, style: WizardStyle) =
  let s = style.cint
  {.emit: "`w`->setWizardStyle((QWizard::WizardStyle)`s`);".}

proc wizSetOption*(w: Wiz, opt: WizardOption, on: bool = true) =
  let o = opt.cint; let v = on.cint
  {.emit: "`w`->setOption((QWizard::WizardOption)`o`, (bool)`v`);".}

proc wizTestOption*(w: Wiz, opt: WizardOption): bool =
  let o = opt.cint; var r: cint
  {.emit: "`r` = `w`->testOption((QWizard::WizardOption)`o`) ? 1 : 0;".}
  result = r == 1

proc wizSetButtonText*(w: Wiz, which: WizardButton, text: string) =
  ## Изменить текст стандартной кнопки мастера.
  let bv = which.cint; let cs = text.cstring
  {.emit: "`w`->setButtonText((QWizard::WizardButton)`bv`, QString::fromUtf8(`cs`));".}

proc wizButtonText*(w: Wiz, which: WizardButton): string =
  let bv = which.cint; var p: cstring
  {.emit: "static QByteArray _bWBT; _bWBT = `w`->buttonText((QWizard::WizardButton)`bv`).toUtf8(); `p` = _bWBT.constData();".}
  result = $p

proc wizSetButton*(w: Wiz, which: WizardButton, btn: AbsBtn) =
  ## Заменить стандартную кнопку кастомной.
  let bv = which.cint
  {.emit: "`w`->setButton((QWizard::WizardButton)`bv`, `btn`);".}

# Поля (регистрируются на страницах, читаются с мастера)
proc wizSetField*(w: Wiz, name: string, value: string) =
  let cn = name.cstring; let cv = value.cstring
  {.emit: "`w`->setField(QString::fromUtf8(`cn`), QVariant(QString::fromUtf8(`cv`)));".}

proc wizFieldStr*(w: Wiz, name: string): string =
  let cn = name.cstring; var p: cstring
  {.emit: "static QByteArray _bWFS; _bWFS = `w`->field(QString::fromUtf8(`cn`)).toString().toUtf8(); `p` = _bWFS.constData();".}
  result = $p

proc wizFieldInt*(w: Wiz, name: string): int =
  let cn = name.cstring; var v: cint
  {.emit: "`v` = `w`->field(QString::fromUtf8(`cn`)).toInt();".}
  result = v.int

proc wizFieldBool*(w: Wiz, name: string): bool =
  let cn = name.cstring; var r: cint
  {.emit: "`r` = `w`->field(QString::fromUtf8(`cn`)).toBool() ? 1 : 0;".}
  result = r == 1

proc wizHasVisitedPage*(w: Wiz, id: int): bool =
  let i = id.cint; var r: cint
  {.emit: "`r` = `w`->hasVisitedPage(`i`) ? 1 : 0;".}
  result = r == 1

proc wizVisitedIds*(w: Wiz): seq[int] =
  var n: cint
  {.emit: "static QList<int> _wvi = `w`->visitedIds(); `n` = _wvi.size();".}
  result = newSeq[int](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var v: cint
    {.emit: "`v` = _wvi.at(`idx`);".}
    result[i] = v.int

proc wizSetTitleFormat*(w: Wiz, fmt: cint) =
  ## Формат заголовков страниц (0=PlainText, 1=RichText).
  {.emit: "`w`->setTitleFormat((Qt::TextFormat)`fmt`);".}

proc wizSetSubTitleFormat*(w: Wiz, fmt: cint) =
  {.emit: "`w`->setSubTitleFormat((Qt::TextFormat)`fmt`);".}

proc wizExec*(w: Wiz): DlgResult =
  var v: cint
  {.emit: "`v` = `w`->exec();".}
  result = cast[DlgResult](v)

proc wizShow*(w: Wiz)    {.importcpp: "#->show()".}
proc wizResize*(w: Wiz, ww, h: cint) {.importcpp: "#->resize(#, #)".}
proc wizSetStyleSheet*(w: Wiz, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc wizAsW*(w: Wiz): W  {.importcpp: "(QWidget*)#".}

# ── Сигналы QWizard ───────────────────────────────────────────────────────────

proc onWizCurrentIdChanged*(w: Wiz, cb: CBInt, ud: pointer) =
  ## Сигнал: перешли на другую страницу.
  {.emit: "QObject::connect(`w`, &QWizard::currentIdChanged, [=](int _id){ `cb`(_id, `ud`); });".}

proc onWizPageAdded*(w: Wiz, cb: CBInt, ud: pointer) =
  {.emit: "QObject::connect(`w`, &QWizard::pageAdded, [=](int _id){ `cb`(_id, `ud`); });".}

proc onWizPageRemoved*(w: Wiz, cb: CBInt, ud: pointer) =
  {.emit: "QObject::connect(`w`, &QWizard::pageRemoved, [=](int _id){ `cb`(_id, `ud`); });".}

proc onWizAccepted*(w: Wiz, cb: CB, ud: pointer) =
  ## Сигнал: пользователь завершил мастер (Finish).
  {.emit: "QObject::connect(`w`, &QWizard::accepted, [=](){ `cb`(`ud`); });".}

proc onWizRejected*(w: Wiz, cb: CB, ud: pointer) =
  ## Сигнал: пользователь отменил мастер.
  {.emit: "QObject::connect(`w`, &QWizard::rejected, [=](){ `cb`(`ud`); });".}

proc onWizFinished*(w: Wiz, cb: CBInt, ud: pointer) =
  ## Сигнал: мастер закрыт (result: 1=Accepted, 0=Rejected).
  {.emit: "QObject::connect(`w`, &QWizard::finished, [=](int _r){ `cb`(_r, `ud`); });".}

proc onWizHelpRequested*(w: Wiz, cb: CB, ud: pointer) =
  ## Сигнал: нажата кнопка Help.
  {.emit: "QObject::connect(`w`, &QWizard::helpRequested, [=](){ `cb`(`ud`); });".}

proc onWizCustomButtonClicked*(w: Wiz, cb: CBInt, ud: pointer) =
  ## Сигнал: нажата кастомная кнопка (1, 2 или 3).
  {.emit: "QObject::connect(`w`, &QWizard::customButtonClicked, [=](int _which){ `cb`(_which, `ud`); });".}

# ── QWizardPage ───────────────────────────────────────────────────────────────

proc newWizardPage*(parent: W = nil): WizPage {.importcpp: "new QWizardPage(#)".}
  ## Создать новую страницу мастера.

proc wpSetTitle*(p: WizPage, s: string) =
  ## Заголовок страницы.
  let cs = s.cstring
  {.emit: "`p`->setTitle(QString::fromUtf8(`cs`));".}

proc wpTitle*(p: WizPage): string =
  var c: cstring
  {.emit: "static QByteArray _bWPT; _bWPT = `p`->title().toUtf8(); `c` = _bWPT.constData();".}
  result = $c

proc wpSetSubTitle*(p: WizPage, s: string) =
  ## Подзаголовок страницы (показывается под заголовком).
  let cs = s.cstring
  {.emit: "`p`->setSubTitle(QString::fromUtf8(`cs`));".}

proc wpSubTitle*(p: WizPage): string =
  var c: cstring
  {.emit: "static QByteArray _bWPST; _bWPST = `p`->subTitle().toUtf8(); `c` = _bWPST.constData();".}
  result = $c

# Перегрузки setLayout для страниц мастера
proc wpSetLayout*(p: WizPage, l: VBox) {.importcpp: "#->setLayout(#)".}
proc wpSetLayout*(p: WizPage, l: HBox) {.importcpp: "#->setLayout(#)".}
proc wpSetLayout*(p: WizPage, l: Grid) {.importcpp: "#->setLayout(#)".}
proc wpSetLayout*(p: WizPage, l: Form) {.importcpp: "#->setLayout(#)".}

proc wpSetFinalPage*(p: WizPage, b: bool) {.importcpp: "#->setFinalPage(#)".}
  ## Пометить страницу как финальную (показывает кнопку Finish).
proc wpIsFinalPage*(p: WizPage): bool =
  var r: cint
  {.emit: "`r` = `p`->isFinalPage() ? 1 : 0;".}
  result = r == 1

proc wpSetCommitPage*(p: WizPage, b: bool) {.importcpp: "#->setCommitPage(#)".}
  ## Пометить как «без возврата» (кнопка Back недоступна после неё).
proc wpIsCommitPage*(p: WizPage): bool =
  var r: cint
  {.emit: "`r` = `p`->isCommitPage() ? 1 : 0;".}
  result = r == 1

proc wpIsComplete*(p: WizPage): bool =
  ## true если страница завершена (кнопка Next/Finish доступна).
  var r: cint
  {.emit: "`r` = `p`->isComplete() ? 1 : 0;".}
  result = r == 1

proc wpNextId*(p: WizPage): int =
  ## ID следующей страницы (-1 = автовыбор).
  var v: cint
  {.emit: "`v` = `p`->nextId();".}
  result = v.int

proc wpRegisterField*(p: WizPage, name: string, widget: W,
                      prop: cstring = nil, changedSig: cstring = nil) =
  ## Регистрирует именованное поле страницы.
  ## Значение читается через wizFieldStr/Int/Bool на уровне QWizard.
  ## prop и changedSig можно опустить (Qt подберёт автоматически).
  let cn = name.cstring
  if prop == nil:
    {.emit: "`p`->registerField(QString::fromUtf8(`cn`), `widget`);".}
  elif changedSig == nil:
    {.emit: "`p`->registerField(QString::fromUtf8(`cn`), `widget`, `prop`);".}
  else:
    {.emit: "`p`->registerField(QString::fromUtf8(`cn`), `widget`, `prop`, `changedSig`);".}

proc wpSetStyleSheet*(p: WizPage, css: QString) {.importcpp: "#->setStyleSheet(#)".}
proc wpAsW*(p: WizPage): W {.importcpp: "(QWidget*)#".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 14. Высокоуровневые Nim-утилиты
# ═══════════════════════════════════════════════════════════════════════════════

# ── Быстрые диалоги подтверждения ────────────────────────────────────────────

proc confirmDelete*(parent: W, itemName: string): bool =
  ## Спросить подтверждение удаления.
  ## Пример: if confirmDelete(win.asW, "файл notes.txt"): deleteFile(path)
  msgYesNo(parent, "Подтверждение удаления",
    "Вы уверены, что хотите удалить «" & itemName & "»?")

proc confirmDiscard*(parent: W): bool =
  ## Спросить разрешение на отмену несохранённых изменений.
  msgYesNo(parent, "Несохранённые изменения",
    "Имеются несохранённые изменения. Отменить их?")

proc confirmOverwrite*(parent: W, path: string): bool =
  ## Спросить разрешение на перезапись существующего файла.
  msgYesNo(parent, "Файл уже существует",
    "Файл «" & path & "» уже существует. Перезаписать?")

proc confirmAction*(parent: W, title, question: string): bool =
  ## Общий диалог подтверждения действия.
  msgYesNo(parent, title, question)

proc confirmSaveChanges*(parent: W): MsgBoxStdBtn =
  ## Диалог «Сохранить/Отменить/Отмена» при закрытии документа.
  ## Возвращает MBBtnSave, MBBtnDiscard или MBBtnCancel.
  msgSaveDiscardCancel(parent, "Несохранённые изменения",
    "У вас есть несохранённые изменения. Сохранить их перед выходом?")

# ── Диалоги ввода данных ──────────────────────────────────────────────────────

proc showValidationError*(parent: W, field, reason: string) =
  ## Показать ошибку валидации поля.
  msgWarning(parent, "Ошибка ввода",
    "Поле «" & field & "»:\n" & reason)

proc askTextRequired*(parent: W, title, prompt: string,
                      maxLen: int = 0): string =
  ## Запросить непустую строку. Повторяет до получения.
  ## Возвращает "" если пользователь нажал «Отмена».
  while true:
    let res = inputText(parent, title, prompt)
    if not res.ok: return ""
    if maxLen > 0 and res.value.len > maxLen:
      msgWarning(parent, title,
        "Строка не должна превышать " & $maxLen & " символов.")
      continue
    if res.value.len > 0: return res.value
    msgWarning(parent, title, "Поле не может быть пустым.")

proc askInt*(parent: W, title, prompt: string,
             default: int = 0,
             min: int = low(cint).int,
             max: int = high(cint).int): tuple[ok: bool, value: int] =
  ## Запросить целое число.
  result = inputInt(parent, title, prompt, default, min, max)

proc askFloat*(parent: W, title, prompt: string,
               default: float64 = 0.0,
               min: float64 = -1e18,
               max: float64 = 1e18): tuple[ok: bool, value: float64] =
  ## Запросить вещественное число.
  result = inputFloat(parent, title, prompt, default, min, max)

proc askChoice*(parent: W, title, prompt: string,
                choices: openArray[string],
                currentIdx: int = 0): string =
  ## Показать список и вернуть выбранный элемент (или "" при отмене).
  let res = inputItem(parent, title, prompt, choices, currentIdx)
  result = if res.ok: res.item else: ""

# ── Диалоги файловой системы ──────────────────────────────────────────────────

proc pickOpenFile*(parent: W,
                   title: string = "Открыть файл",
                   filter: string = "Все файлы (*)",
                   dir: string = ""): string =
  ## Открыть диалог выбора файла. Возвращает путь или "".
  let res = fileOpen(parent, title, dir, filter)
  result = if res.ok: res.path else: ""

proc pickSaveFile*(parent: W,
                   title: string = "Сохранить файл",
                   filter: string = "Все файлы (*)",
                   dir: string = ""): string =
  ## Открыть диалог сохранения. Возвращает путь или "".
  let res = fileSave(parent, title, dir, filter)
  result = if res.ok: res.path else: ""

proc pickDirectory*(parent: W,
                    title: string = "Выбрать директорию",
                    dir: string = ""): string =
  ## Открыть диалог выбора директории. Возвращает путь или "".
  let res = dirSelect(parent, title, dir)
  result = if res.ok: res.path else: ""

proc pickOpenFiles*(parent: W,
                    title: string = "Открыть файлы",
                    filter: string = "Все файлы (*)",
                    dir: string = ""): seq[string] =
  ## Открыть диалог выбора нескольких файлов.
  let res = fileOpenMany(parent, title, dir, filter)
  result = if res.ok: res.paths else: @[]

proc pickImageFile*(parent: W, title: string = "Выбрать изображение"): string =
  ## Специализированный диалог открытия изображения.
  pickOpenFile(parent, title,
    "Изображения (*.png *.jpg *.jpeg *.bmp *.gif *.webp *.tiff *.ico);;" &
    "Все файлы (*)")

proc pickVideoFile*(parent: W, title: string = "Выбрать видео"): string =
  ## Специализированный диалог открытия видеофайла.
  pickOpenFile(parent, title,
    "Видео (*.mp4 *.mkv *.avi *.mov *.wmv *.flv *.webm);;" &
    "Все файлы (*)")

proc pickAudioFile*(parent: W, title: string = "Выбрать аудио"): string =
  ## Специализированный диалог открытия аудиофайла.
  pickOpenFile(parent, title,
    "Аудио (*.mp3 *.wav *.ogg *.flac *.aac *.m4a);;" &
    "Все файлы (*)")

# ── Диалоги цвета и шрифта ────────────────────────────────────────────────────

proc pickColorHex*(parent: W,
                   title: string = "Выбрать цвет",
                   init: string = "#ffffff"): string =
  ## Открыть диалог цвета. Возвращает "#rrggbb" или "".
  let res = colorGetHex(parent, title, init)
  result = if res.ok: res.hex else: ""

proc pickColorHexAlpha*(parent: W,
                        title: string = "Выбрать цвет (с прозрачностью)",
                        init: string = "#ffffffff"): string =
  ## Открыть диалог цвета с альфа-каналом. Возвращает "#aarrggbb" или "".
  let res = colorGetHexAlpha(parent, title, init)
  result = if res.ok: res.hex else: ""

proc pickColorRgba*(parent: W,
                    title: string = "Выбрать цвет",
                    showAlpha: bool = false): tuple[ok: bool, r, g, b, a: int] =
  ## Открыть диалог цвета и вернуть RGBA-компоненты (0..255).
  let res = colorGet(parent, title, showAlpha = showAlpha)
  result = (res.ok, res.r, res.g, res.b, res.a)

proc pickFontStr*(parent: W,
                  title: string = "Выбрать шрифт",
                  initFamily: string = "Arial",
                  initSize: int = 12): string =
  ## Открыть диалог шрифта. Возвращает "family,size" или "".
  let res = fontGet(parent, title, initFamily, initSize)
  result = if res.ok: res.family & "," & $res.pointSize else: ""

proc pickFontFull*(parent: W,
                   title: string = "Выбрать шрифт",
                   initFamily: string = "Arial",
                   initSize: int = 12): FontPickResult =
  ## Открыть диалог шрифта. Возвращает полное описание.
  result = fontGet(parent, title, initFamily, initSize)

# ── Прогресс-утилиты ──────────────────────────────────────────────────────────

proc withProgress*(parent: W, title, label: string,
                   total: int, minDuration: int = 500,
                   body: proc(pd: ProgDlg) {.closure.}) =
  ## Запустить операцию с прогресс-диалогом.
  ## body получает диалог и должна вызывать pdStep(pd) или pdSetValue(pd, n)
  ## для обновления прогресса.
  ## Пример:
  ##   withProgress(win.asW, "Обработка", "Обрабатываю файлы...", 100):
  ##     proc(pd: ProgDlg) =
  ##       for i in 1..100:
  ##         processFile(i)
  ##         pd.pdSetValue(i)
  let pd = newProgressDialogNoCancel(parent, label, 0, total)
  pd.pdSetWindowTitle(title)
  pd.pdSetMinimumDuration(minDuration)
  pd.pdShow()
  body(pd)
  pd.pdSetValue(total)
  pd.pdClose()

proc withProgressCancellable*(parent: W, title, label: string,
                               total: int,
                               minDuration: int = 500,
                               body: proc(pd: ProgDlg): bool {.closure.}): bool =
  ## Запустить операцию с отменяемым прогресс-диалогом.
  ## body должна возвращать false при отмене или ошибке.
  ## Возвращает true если операция завершена, false если отменена.
  ## Пример:
  ##   let ok = withProgressCancellable(win.asW, "Загрузка", "Загружаю...", 100):
  ##     proc(pd: ProgDlg): bool =
  ##       for i in 1..100:
  ##         if pd.pdWasCanceled: return false
  ##         downloadChunk(i)
  ##         pd.pdSetValue(i)
  ##       true
  let pd = newProgressDialog(parent, label, "Отмена", 0, total)
  pd.pdSetWindowTitle(title)
  pd.pdSetMinimumDuration(minDuration)
  pd.pdShow()
  result = body(pd)
  if not pd.pdWasCanceled():
    pd.pdSetValue(total)
  pd.pdClose()

## ── Конец nimQtDialogs.nim ───────────────────────────────────────────────────
