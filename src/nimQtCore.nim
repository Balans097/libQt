## nimQtCore.nim — Полная обёртка Qt6Core для Nim (nim cpp --passC:"-std=c++20")
##
## Включает:
##   QCoreApplication, QObject, QThread, QMutex, QMutexLocker,
##   QReadWriteLock, QSemaphore, QWaitCondition,
##   QTimer, QElapsedTimer,
##   QSettings, QCommandLineParser, QCommandLineOption,
##   QEventLoop, QEvent,
##   QFile, QDir, QFileInfo, QTemporaryFile, QTemporaryDir,
##   QTextStream, QDataStream,
##   QProcess,
##   QTranslator, QLibraryInfo,
##   QCryptographicHash,
##   QRunnable, QThreadPool,
##   QMimeDatabase, QMimeType,
##   QStandardPaths,
##   QSortFilterProxyModel (базовые),
##   QAbstractItemModel (типы),
##   QModelIndex,
##   QLockFile, QSaveFile,
##   QRegularExpression,
##   QLocale,
##   QTimeZone,
##   QBitArray, QLine, QLineF,
##   QMargins, QMarginsF
##
## Импортирует: nimQtUtils (типы), nimQtFFI (константы)

when defined(windows):
  {.passC: "-IC:/msys64/ucrt64/include".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
  {.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
  {.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
# На Linux пути передаются снаружи через pkg-config


import nimQtFFI
import strutils

{.emit: """
#include <QCoreApplication>
#include <QObject>
#include <QThread>
#include <QMutex>
#include <QMutexLocker>
#include <QReadWriteLock>
#include <QSemaphore>
#include <QWaitCondition>
#include <QTimer>
#include <QElapsedTimer>
#include <QSettings>
#include <QCommandLineParser>
#include <QCommandLineOption>
#include <QEventLoop>
#include <QEvent>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <QTemporaryFile>
#include <QTemporaryDir>
#include <QTextStream>
#include <QDataStream>
#include <QProcess>
#include <QTranslator>
#include <QLibraryInfo>
#include <QCryptographicHash>
#include <QRunnable>
#include <QThreadPool>
#include <QMimeDatabase>
#include <QMimeType>
#include <QStandardPaths>
#include <QAbstractItemModel>
#include <QSortFilterProxyModel>
#include <QModelIndex>
#include <QLockFile>
#include <QSaveFile>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QLocale>
#include <QTimeZone>
#include <QBitArray>
#include <QLine>
#include <QLineF>
#include <QMargins>
#include <QMarginsF>
#include <QBuffer>
#include <QIODevice>
#include <QDebug>
#include <QLoggingCategory>
#include <QMetaObject>
#include <functional>
#include <cstring>

// Синглтон QCoreApplication
static int   _nim_core_argc = 0;
static char* _nim_core_argv[] = {nullptr};
static QCoreApplication* _nim_core_app = nullptr;
""".}

# ── Opaque типы ───────────────────────────────────────────────────────────────
type
  QCoreApplication*      {.importcpp: "QCoreApplication",      header: "<QCoreApplication>".}      = object
  QObject*               {.importcpp: "QObject",               header: "<QObject>".}               = object
  QThread*               {.importcpp: "QThread",               header: "<QThread>".}               = object
  QMutex*                {.importcpp: "QMutex",                header: "<QMutex>".}                = object
  QReadWriteLock*        {.importcpp: "QReadWriteLock",        header: "<QReadWriteLock>".}        = object
  QSemaphore*            {.importcpp: "QSemaphore",            header: "<QSemaphore>".}            = object
  QWaitCondition*        {.importcpp: "QWaitCondition",        header: "<QWaitCondition>".}        = object
  QTimer*                {.importcpp: "QTimer",                header: "<QTimer>".}                = object
  QElapsedTimer*         {.importcpp: "QElapsedTimer",         header: "<QElapsedTimer>".}         = object
  QSettings*             {.importcpp: "QSettings",             header: "<QSettings>".}             = object
  QCommandLineParser*    {.importcpp: "QCommandLineParser",    header: "<QCommandLineParser>".}    = object
  QCommandLineOption*    {.importcpp: "QCommandLineOption",    header: "<QCommandLineOption>".}    = object
  QEventLoop*            {.importcpp: "QEventLoop",            header: "<QEventLoop>".}            = object
  QEvent*                {.importcpp: "QEvent",                header: "<QEvent>".}                = object
  QFile*                 {.importcpp: "QFile",                 header: "<QFile>".}                 = object
  QDir*                  {.importcpp: "QDir",                  header: "<QDir>".}                  = object
  QFileInfo*             {.importcpp: "QFileInfo",             header: "<QFileInfo>".}             = object
  QTemporaryFile*        {.importcpp: "QTemporaryFile",        header: "<QTemporaryFile>".}        = object
  QTemporaryDir*         {.importcpp: "QTemporaryDir",         header: "<QTemporaryDir>".}         = object
  QTextStream*           {.importcpp: "QTextStream",           header: "<QTextStream>".}           = object
  QDataStream*           {.importcpp: "QDataStream",           header: "<QDataStream>".}           = object
  QProcess*              {.importcpp: "QProcess",              header: "<QProcess>".}              = object
  QTranslator*           {.importcpp: "QTranslator",           header: "<QTranslator>".}           = object
  QCryptographicHash*    {.importcpp: "QCryptographicHash",    header: "<QCryptographicHash>".}    = object
  QThreadPool*           {.importcpp: "QThreadPool",           header: "<QThreadPool>".}           = object
  QMimeDatabase*         {.importcpp: "QMimeDatabase",         header: "<QMimeDatabase>".}         = object
  QMimeType*             {.importcpp: "QMimeType",             header: "<QMimeType>".}             = object
  QAbstractItemModel*    {.importcpp: "QAbstractItemModel",    header: "<QAbstractItemModel>".}    = object
  QSortFilterProxyModel* {.importcpp: "QSortFilterProxyModel", header: "<QSortFilterProxyModel>".} = object
  QModelIndex*           {.importcpp: "QModelIndex",           header: "<QAbstractItemModel>".}    = object
  QLockFile*             {.importcpp: "QLockFile",             header: "<QLockFile>".}             = object
  QSaveFile*             {.importcpp: "QSaveFile",             header: "<QSaveFile>".}             = object
  QRegularExpression*    {.importcpp: "QRegularExpression",    header: "<QRegularExpression>".}    = object
  QRegularExpressionMatch* {.importcpp: "QRegularExpressionMatch", header: "<QRegularExpression>".} = object
  QLocale*               {.importcpp: "QLocale",               header: "<QLocale>".}               = object
  QTimeZone*             {.importcpp: "QTimeZone",             header: "<QTimeZone>".}             = object
  QBitArray*             {.importcpp: "QBitArray",             header: "<QBitArray>".}             = object
  QLine*                 {.importcpp: "QLine",                 header: "<QLine>".}                 = object
  QLineF*                {.importcpp: "QLineF",                header: "<QLineF>".}                = object
  QMargins*              {.importcpp: "QMargins",              header: "<QMargins>".}              = object
  QMarginsF*             {.importcpp: "QMarginsF",             header: "<QMarginsF>".}             = object
  QBuffer*               {.importcpp: "QBuffer",               header: "<QBuffer>".}               = object
  QIODevice*             {.importcpp: "QIODevice",             header: "<QIODevice>".}             = object
  QString*               {.importcpp: "QString",               header: "<QString>".}               = object
  QStringList*           {.importcpp: "QStringList",           header: "<QStringList>".}           = object
  QDate*                 {.importcpp: "QDate",                 header: "<QDate>".}                 = object
  QDateTime*             {.importcpp: "QDateTime",             header: "<QDateTime>".}             = object
  QVariant*              {.importcpp: "QVariant",              header: "<QVariant>".}              = object

# Удобные псевдонимы указателей
type
  CoreApp* = ptr QCoreApplication
  Obj*     = ptr QObject
  Thr*     = ptr QThread
  Mtx*     = ptr QMutex
  RWLock*  = ptr QReadWriteLock
  Sem*     = ptr QSemaphore
  ELoop*   = ptr QEventLoop
  Proc*    = ptr QProcess
  TPool*   = ptr QThreadPool
  SFPM*    = ptr QSortFilterProxyModel
  AIM*     = ptr QAbstractItemModel
  RegExp*  = ptr QRegularExpression

# ── QCoreApplication ─────────────────────────────────────────────────────────

proc newCoreApp*(): CoreApp =
  {.emit: "_nim_core_app = new QCoreApplication(_nim_core_argc, _nim_core_argv); `result` = _nim_core_app;".}

proc coreAppInstance*(): CoreApp =
  {.emit: "`result` = static_cast<QCoreApplication*>(QCoreApplication::instance());".}

proc exec*(a: CoreApp): cint {.importcpp: "#->exec()".}
proc quit*(a: CoreApp) {.importcpp: "#->quit()".}
proc exit*(a: CoreApp, code: cint = 0) {.importcpp: "#->exit(#)".}
proc processEvents*(a: CoreApp) {.importcpp: "QCoreApplication::processEvents()".}
proc setAppName*(a: CoreApp, s: QString) {.importcpp: "#->setApplicationName(#)".}
proc setOrgName*(a: CoreApp, s: QString) {.importcpp: "#->setOrganizationName(#)".}
proc setOrgDomain*(a: CoreApp, s: QString) {.importcpp: "#->setOrganizationDomain(#)".}
proc setAppVersion*(a: CoreApp, s: QString) {.importcpp: "#->setApplicationVersion(#)".}
proc appName*(): string =
  var p: cstring
  {.emit: "static QByteArray _bcan; _bcan = QCoreApplication::applicationName().toUtf8(); `p` = _bcan.constData();".}
  result = $p
proc appVersion*(): string =
  var p: cstring
  {.emit: "static QByteArray _bcav; _bcav = QCoreApplication::applicationVersion().toUtf8(); `p` = _bcav.constData();".}
  result = $p
proc appDirPath*(): string =
  var p: cstring
  {.emit: "static QByteArray _bcad; _bcad = QCoreApplication::applicationDirPath().toUtf8(); `p` = _bcad.constData();".}
  result = $p
proc appFilePath*(): string =
  var p: cstring
  {.emit: "static QByteArray _bcaf; _bcaf = QCoreApplication::applicationFilePath().toUtf8(); `p` = _bcaf.constData();".}
  result = $p
proc appPid*(): int64 =
  var v: clonglong
  {.emit: "`v` = QCoreApplication::applicationPid();".}
  result = v.int64

proc installTranslator*(t: ptr QTranslator): bool =
  var r: cint
  {.emit: "`r` = QCoreApplication::installTranslator(`t`) ? 1 : 0;".}
  result = r == 1

proc removeTranslator*(t: ptr QTranslator): bool =
  var r: cint
  {.emit: "`r` = QCoreApplication::removeTranslator(`t`) ? 1 : 0;".}
  result = r == 1

# ── QObject ───────────────────────────────────────────────────────────────────

proc newQObject*(parent: Obj = nil): Obj {.importcpp: "new QObject(#)".}
proc objParent*(o: Obj): Obj {.importcpp: "#->parent()".}
proc objSetParent*(o: Obj, p: Obj) {.importcpp: "#->setParent(#)".}
proc objChildren*(o: Obj): QStringList =
  ## Возвращает имена дочерних объектов
  {.emit: """
    QStringList _ocl;
    for (auto* c : `o`->children())
      _ocl << c->objectName();
    `result` = _ocl;
  """.}
proc objName*(o: Obj): string =
  var p: cstring
  {.emit: "static QByteArray _bon; _bon = `o`->objectName().toUtf8(); `p` = _bon.constData();".}
  result = $p
proc objSetName*(o: Obj, name: QString) {.importcpp: "#->setObjectName(#)".}
proc objIsA*(o: Obj, className: cstring): bool =
  var r: cint
  {.emit: "`r` = `o`->inherits(`className`) ? 1 : 0;".}
  result = r == 1
proc objBlockSignals*(o: Obj, doBlock: bool): bool =
  let bv = doBlock.cint; var r: cint
  {.emit: "`r` = `o`->blockSignals(`bv`) ? 1 : 0;".}
  result = r == 1
proc objSignalsBlocked*(o: Obj): bool =
  var r: cint
  {.emit: "`r` = `o`->signalsBlocked() ? 1 : 0;".}
  result = r == 1
proc objDump*(o: Obj) {.importcpp: "#->dumpObjectInfo()".}
proc objDumpTree*(o: Obj) {.importcpp: "#->dumpObjectTree()".}
proc objDelete*(o: Obj) {.importcpp: "delete #".}
proc objDeleteLater*(o: Obj) {.importcpp: "#->deleteLater()".}

proc objConnect*(sender: Obj, signal: cstring, receiver: Obj, slot: cstring): bool =
  var r: cint
  {.emit: "`r` = QObject::connect(`sender`, `signal`, `receiver`, `slot`) ? 1 : 0;".}
  result = r == 1

proc objDisconnect*(sender: Obj, signal: cstring, receiver: Obj, slot: cstring): bool =
  var r: cint
  {.emit: "`r` = QObject::disconnect(`sender`, `signal`, `receiver`, `slot`) ? 1 : 0;".}
  result = r == 1

# ── QTimer ────────────────────────────────────────────────────────────────────

proc newTimer*(parent: Obj = nil): ptr QTimer =
  {.emit: "`result` = new QTimer(`parent`);".}
proc timerStart*(t: ptr QTimer, ms: cint) {.importcpp: "#->start(#)".}
proc timerStop*(t: ptr QTimer) {.importcpp: "#->stop()".}
proc timerIsActive*(t: ptr QTimer): bool =
  var r: cint
  {.emit: "`r` = `t`->isActive() ? 1 : 0;".}
  result = r == 1
proc timerInterval*(t: ptr QTimer): int =
  var v: cint
  {.emit: "`v` = `t`->interval();".}
  result = v.int
proc timerSetInterval*(t: ptr QTimer, ms: cint) {.importcpp: "#->setInterval(#)".}
proc timerSetSingleShot*(t: ptr QTimer, b: bool) =
  let bv = b.cint
  {.emit: "`t`->setSingleShot(`bv`);".}
proc timerIsSingleShot*(t: ptr QTimer): bool =
  var r: cint
  {.emit: "`r` = `t`->isSingleShot() ? 1 : 0;".}
  result = r == 1
proc timerRemainingTime*(t: ptr QTimer): int =
  var v: cint
  {.emit: "`v` = `t`->remainingTime();".}
  result = v.int

proc timerOnTimeout*(t: ptr QTimer, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`t`, &QTimer::timeout, [=]() {
      `cb`(`ud`);
    });
  """.}

proc timerSingleShot*(ms: cint, cb: CB, ud: pointer) =
  {.emit: """
    QTimer::singleShot(`ms`, [=]() { `cb`(`ud`); });
  """.}

# Псевдонимы совместимости с qt6.nim
# newTimer() removed - use newTimer(nil) directly
proc start*(t: ptr QTimer, ms: cint) = timerStart(t, ms)
proc stop*(t: ptr QTimer) = timerStop(t)
proc onTimeout*(t: ptr QTimer, cb: CB, ud: pointer) = timerOnTimeout(t, cb, ud)

# ── QElapsedTimer ─────────────────────────────────────────────────────────────

proc newElapsedTimer*(): ptr QElapsedTimer {.importcpp: "new QElapsedTimer()".}
proc etStart*(t: ptr QElapsedTimer) {.importcpp: "#->start()".}
proc etElapsed*(t: ptr QElapsedTimer): int64 =
  var v: clonglong
  {.emit: "`v` = `t`->elapsed();".}
  result = v.int64
proc etNsecsElapsed*(t: ptr QElapsedTimer): int64 =
  var v: clonglong
  {.emit: "`v` = `t`->nsecsElapsed();".}
  result = v.int64
proc etRestart*(t: ptr QElapsedTimer): int64 =
  var v: clonglong
  {.emit: "`v` = `t`->restart();".}
  result = v.int64
proc etIsValid*(t: ptr QElapsedTimer): bool =
  var r: cint
  {.emit: "`r` = `t`->isValid() ? 1 : 0;".}
  result = r == 1
proc etHasExpired*(t: ptr QElapsedTimer, timeout: int64): bool =
  let ms = timeout.clonglong; var r: cint
  {.emit: "`r` = `t`->hasExpired(`ms`) ? 1 : 0;".}
  result = r == 1

# ── QEventLoop ────────────────────────────────────────────────────────────────

proc newEventLoop*(parent: Obj = nil): ELoop {.importcpp: "new QEventLoop(#)".}
proc elExec*(l: ELoop): cint {.importcpp: "#->exec()".}
proc elQuit*(l: ELoop) {.importcpp: "#->quit()".}
proc elExit*(l: ELoop, code: cint = 0) {.importcpp: "#->exit(#)".}
proc elIsRunning*(l: ELoop): bool =
  var r: cint
  {.emit: "`r` = `l`->isRunning() ? 1 : 0;".}
  result = r == 1
proc elProcessEvents*(l: ELoop) {.importcpp: "#->processEvents()".}

# ── QThread ───────────────────────────────────────────────────────────────────

proc newQThread*(parent: Obj = nil): Thr {.importcpp: "new QThread(#)".}
proc thrStart*(t: Thr) {.importcpp: "#->start()".}
proc thrQuit*(t: Thr) {.importcpp: "#->quit()".}
proc thrWait*(t: Thr): bool =
  var r: cint
  {.emit: "`r` = `t`->wait() ? 1 : 0;".}
  result = r == 1
proc thrWaitMs*(t: Thr, ms: culong): bool =
  var r: cint
  {.emit: "`r` = `t`->wait(`ms`) ? 1 : 0;".}
  result = r == 1
proc thrIsRunning*(t: Thr): bool =
  var r: cint
  {.emit: "`r` = `t`->isRunning() ? 1 : 0;".}
  result = r == 1
proc thrIsFinished*(t: Thr): bool =
  var r: cint
  {.emit: "`r` = `t`->isFinished() ? 1 : 0;".}
  result = r == 1
proc thrTerminate*(t: Thr) {.importcpp: "#->terminate()".}
proc thrSetPriority*(t: Thr, p: cint) {.importcpp: "#->setPriority((QThread::Priority)#)".}
proc thrPriority*(t: Thr): cint {.importcpp: "(int)#->priority()".}
proc thrStackSize*(t: Thr): int =
  var v: cuint
  {.emit: "`v` = `t`->stackSize();".}
  result = v.int
proc thrSetStackSize*(t: Thr, sz: uint) =
  let s = sz.cuint
  {.emit: "`t`->setStackSize(`s`);".}

proc thrCurrentThread*(): Thr =
  {.emit: "`result` = QThread::currentThread();".}
proc thrMainThread*(): Thr =
  {.emit: "`result` = QCoreApplication::instance() ? QCoreApplication::instance()->thread() : nullptr;".}
proc thrSleepMs*(ms: culong) =
  {.emit: "QThread::msleep(`ms`);".}
proc thrSleepUs*(us: culong) =
  {.emit: "QThread::usleep(`us`);".}
proc thrSleep*(s: culong) =
  {.emit: "QThread::sleep(`s`);".}
proc thrYield*() =
  {.emit: "QThread::yieldCurrentThread();".}
proc thrIdealCount*(): int =
  var v: cint
  {.emit: "`v` = QThread::idealThreadCount();".}
  result = v.int

proc thrOnStarted*(t: Thr, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`t`, &QThread::started, [=](){ `cb`(`ud`); });".}
proc thrOnFinished*(t: Thr, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`t`, &QThread::finished, [=](){ `cb`(`ud`); });".}

# ── QMutex ────────────────────────────────────────────────────────────────────

proc newMutex*(): Mtx {.importcpp: "new QMutex()".}
proc mtxLock*(m: Mtx) {.importcpp: "#->lock()".}
proc mtxUnlock*(m: Mtx) {.importcpp: "#->unlock()".}
proc mtxTryLock*(m: Mtx): bool =
  var r: cint
  {.emit: "`r` = `m`->tryLock() ? 1 : 0;".}
  result = r == 1
proc mtxTryLockMs*(m: Mtx, ms: cint): bool =
  var r: cint
  {.emit: "`r` = `m`->tryLock(`ms`) ? 1 : 0;".}
  result = r == 1

# ── QReadWriteLock ────────────────────────────────────────────────────────────

proc newRWLock*(): RWLock {.importcpp: "new QReadWriteLock()".}
proc rwLockRead*(l: RWLock) {.importcpp: "#->lockForRead()".}
proc rwLockWrite*(l: RWLock) {.importcpp: "#->lockForWrite()".}
proc rwTryLockRead*(l: RWLock): bool =
  var r: cint
  {.emit: "`r` = `l`->tryLockForRead() ? 1 : 0;".}
  result = r == 1
proc rwTryLockWrite*(l: RWLock): bool =
  var r: cint
  {.emit: "`r` = `l`->tryLockForWrite() ? 1 : 0;".}
  result = r == 1
proc rwUnlock*(l: RWLock) {.importcpp: "#->unlock()".}

# ── QSemaphore ────────────────────────────────────────────────────────────────

proc newSemaphore*(n: cint = 0): Sem {.importcpp: "new QSemaphore(#)".}
proc semAcquire*(s: Sem, n: cint = 1) {.importcpp: "#->acquire(#)".}
proc semRelease*(s: Sem, n: cint = 1) {.importcpp: "#->release(#)".}
proc semTryAcquire*(s: Sem, n: cint = 1): bool =
  var r: cint
  {.emit: "`r` = `s`->tryAcquire(`n`) ? 1 : 0;".}
  result = r == 1
proc semAvailable*(s: Sem): int =
  var v: cint
  {.emit: "`v` = `s`->available();".}
  result = v.int

# ── QSettings ─────────────────────────────────────────────────────────────────

proc newSettings*(org, app: string): ptr QSettings =
  let o = org.cstring; let a = app.cstring
  {.emit: "`result` = new QSettings(QString::fromUtf8(`o`), QString::fromUtf8(`a`));".}

proc newSettingsFile*(path: string): ptr QSettings =
  let cs = path.cstring
  {.emit: "`result` = new QSettings(QString::fromUtf8(`cs`), QSettings::IniFormat);".}

proc setVal*(s: ptr QSettings, key: string, val: string) =
  let k = key.cstring; let v = val.cstring
  {.emit: "`s`->setValue(QString::fromUtf8(`k`), QVariant(QString::fromUtf8(`v`)));".}

proc setValInt*(s: ptr QSettings, key: string, val: int64) =
  let k = key.cstring; let v = val.clonglong
  {.emit: "`s`->setValue(QString::fromUtf8(`k`), QVariant((long long)`v`));".}

proc setValBool*(s: ptr QSettings, key: string, val: bool) =
  let k = key.cstring; let bv = val.cint
  {.emit: "`s`->setValue(QString::fromUtf8(`k`), QVariant((bool)`bv`));".}

proc getVal*(s: ptr QSettings, key: string, def: string = ""): string =
  let k = key.cstring; let d = def.cstring; var p: cstring
  {.emit: """
    static QByteArray _bsv;
    _bsv = `s`->value(QString::fromUtf8(`k`), QString::fromUtf8(`d`)).toString().toUtf8();
    `p` = _bsv.constData();
  """.}
  result = $p

proc getValInt*(s: ptr QSettings, key: string, def: int64 = 0): int64 =
  let k = key.cstring; let d = def.clonglong; var v: clonglong
  {.emit: "`v` = `s`->value(QString::fromUtf8(`k`), QVariant((long long)`d`)).toLongLong();".}
  result = v.int64

proc getValBool*(s: ptr QSettings, key: string, def: bool = false): bool =
  let k = key.cstring; let bv = def.cint; var r: cint
  {.emit: "`r` = `s`->value(QString::fromUtf8(`k`), QVariant((bool)`bv`)).toBool() ? 1 : 0;".}
  result = r == 1

proc settingsContains*(s: ptr QSettings, key: string): bool =
  let k = key.cstring; var r: cint
  {.emit: "`r` = `s`->contains(QString::fromUtf8(`k`)) ? 1 : 0;".}
  result = r == 1

proc settingsRemove*(s: ptr QSettings, key: string) =
  let k = key.cstring
  {.emit: "`s`->remove(QString::fromUtf8(`k`));".}

proc settingsSync*(s: ptr QSettings) {.importcpp: "#->sync()".}

proc settingsAllKeys*(s: ptr QSettings): seq[string] =
  var n: cint
  {.emit: "QStringList _skl = `s`->allKeys(); `n` = _skl.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bsk; _bsk = _skl.at(`idx`).toUtf8(); `p` = _bsk.constData();".}
    result[i] = $p

proc settingsBeginGroup*(s: ptr QSettings, prefix: string) =
  let cs = prefix.cstring
  {.emit: "`s`->beginGroup(QString::fromUtf8(`cs`));".}
proc settingsEndGroup*(s: ptr QSettings) {.importcpp: "#->endGroup()".}
proc settingsChildGroups*(s: ptr QSettings): seq[string] =
  var n: cint
  {.emit: "QStringList _scg = `s`->childGroups(); `n` = _scg.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bscg; _bscg = _scg.at(`idx`).toUtf8(); `p` = _bscg.constData();".}
    result[i] = $p
proc settingsFileName*(s: ptr QSettings): string =
  var p: cstring
  {.emit: "static QByteArray _bsfn; _bsfn = `s`->fileName().toUtf8(); `p` = _bsfn.constData();".}
  result = $p

# ── QFile / QDir / QFileInfo ──────────────────────────────────────────────────

proc newFile*(path: string): ptr QFile =
  let cs = path.cstring
  {.emit: "`result` = new QFile(QString::fromUtf8(`cs`));".}

proc fileOpen*(f: ptr QFile, mode: cint): bool =
  var r: cint
  {.emit: "`r` = `f`->open((QIODevice::OpenMode)`mode`) ? 1 : 0;".}
  result = r == 1

proc fileOpenRead*(f: ptr QFile): bool = fileOpen(f, 0x0001)   # ReadOnly
proc fileOpenWrite*(f: ptr QFile): bool = fileOpen(f, 0x0002)  # WriteOnly
proc fileOpenAppend*(f: ptr QFile): bool = fileOpen(f, 0x0006) # WriteOnly|Append
proc fileOpenRW*(f: ptr QFile): bool = fileOpen(f, 0x0003)     # ReadWrite

proc fileClose*(f: ptr QFile) {.importcpp: "#->close()".}
proc fileFlush*(f: ptr QFile): bool =
  var r: cint
  {.emit: "`r` = `f`->flush() ? 1 : 0;".}
  result = r == 1
proc fileIsOpen*(f: ptr QFile): bool =
  var r: cint
  {.emit: "`r` = `f`->isOpen() ? 1 : 0;".}
  result = r == 1
proc fileSize*(f: ptr QFile): int64 =
  var v: clonglong
  {.emit: "`v` = `f`->size();".}
  result = v.int64
proc filePos*(f: ptr QFile): int64 =
  var v: clonglong
  {.emit: "`v` = `f`->pos();".}
  result = v.int64
proc fileSeek*(f: ptr QFile, pos: int64): bool =
  let p = pos.clonglong; var r: cint
  {.emit: "`r` = `f`->seek(`p`) ? 1 : 0;".}
  result = r == 1
proc fileAtEnd*(f: ptr QFile): bool =
  var r: cint
  {.emit: "`r` = `f`->atEnd() ? 1 : 0;".}
  result = r == 1
proc fileExists*(f: ptr QFile): bool =
  var r: cint
  {.emit: "`r` = `f`->exists() ? 1 : 0;".}
  result = r == 1
proc fileRemove*(f: ptr QFile): bool =
  var r: cint
  {.emit: "`r` = `f`->remove() ? 1 : 0;".}
  result = r == 1
proc fileRename*(f: ptr QFile, newName: string): bool =
  let cs = newName.cstring; var r: cint
  {.emit: "`r` = `f`->rename(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1
proc fileCopy*(f: ptr QFile, dest: string): bool =
  let cs = dest.cstring; var r: cint
  {.emit: "`r` = `f`->copy(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc fileReadAll*(f: ptr QFile): string =
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _bra = `f`->readAll();
    static QByteArray _bra_s = _bra;
    `p` = _bra_s.constData();
    `n` = _bra_s.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc fileReadLine*(f: ptr QFile): string =
  var p: cstring; var n: cint
  {.emit: """
    static QByteArray _brl = `f`->readLine();
    `p` = _brl.constData();
    `n` = _brl.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc fileWrite*(f: ptr QFile, data: string): int64 =
  let cs = data.cstring; let n = data.len.cint; var written: clonglong
  {.emit: "`written` = `f`->write(`cs`, `n`);".}
  result = written.int64

proc fileError*(f: ptr QFile): string =
  var p: cstring
  {.emit: "static QByteArray _bfe; _bfe = `f`->errorString().toUtf8(); `p` = _bfe.constData();".}
  result = $p

proc fileSetPermissions*(f: ptr QFile, perms: cint): bool =
  var r: cint
  {.emit: "`r` = `f`->setPermissions((QFileDevice::Permissions)`perms`) ? 1 : 0;".}
  result = r == 1

## Static helpers
proc fileExistsPath*(path: string): bool =
  let cs = path.cstring; var r: cint
  {.emit: "`r` = QFile::exists(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc fileRemovePath*(path: string): bool =
  let cs = path.cstring; var r: cint
  {.emit: "`r` = QFile::remove(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc fileCopyPath*(src, dst: string): bool =
  let s = src.cstring; let d = dst.cstring; var r: cint
  {.emit: "`r` = QFile::copy(QString::fromUtf8(`s`), QString::fromUtf8(`d`)) ? 1 : 0;".}
  result = r == 1

## Quick read/write utilities
proc readTextFile*(path: string): tuple[ok: bool, data: string] =
  let cs = path.cstring; var ok: cint; var p: cstring; var n: cint
  {.emit: """
    QFile _qf(QString::fromUtf8(`cs`));
    `ok` = _qf.open(QIODevice::ReadOnly | QIODevice::Text) ? 1 : 0;
    static QByteArray _rbt;
    if (`ok`) { _rbt = _qf.readAll(); `p` = _rbt.constData(); `n` = _rbt.size(); }
    else { `p` = ""; `n` = 0; }
  """.}
  result.ok = ok == 1
  result.data = newString(n.int)
  if n > 0: copyMem(addr result.data[0], p, n.int)

proc writeTextFile*(path: string, data: string): bool =
  let cs = path.cstring; let ds = data.cstring; let dn = data.len.cint; var ok: cint
  {.emit: """
    QFile _qfw(QString::fromUtf8(`cs`));
    `ok` = _qfw.open(QIODevice::WriteOnly | QIODevice::Text) ? 1 : 0;
    if (`ok`) _qfw.write(`ds`, `dn`);
  """.}
  result = ok == 1

proc appendTextFile*(path: string, data: string): bool =
  let cs = path.cstring; let ds = data.cstring; let dn = data.len.cint; var ok: cint
  {.emit: """
    QFile _qfa(QString::fromUtf8(`cs`));
    `ok` = _qfa.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text) ? 1 : 0;
    if (`ok`) _qfa.write(`ds`, `dn`);
  """.}
  result = ok == 1

# ── QDir ─────────────────────────────────────────────────────────────────────

proc newDir*(path: string): ptr QDir =
  let cs = path.cstring
  {.emit: "`result` = new QDir(QString::fromUtf8(`cs`));".}

proc dirPath*(d: ptr QDir): string =
  var p: cstring
  {.emit: "static QByteArray _bdp; _bdp = `d`->path().toUtf8(); `p` = _bdp.constData();".}
  result = $p

proc dirAbsPath*(d: ptr QDir): string =
  var p: cstring
  {.emit: "static QByteArray _bdap; _bdap = `d`->absolutePath().toUtf8(); `p` = _bdap.constData();".}
  result = $p

proc dirExists*(d: ptr QDir): bool =
  var r: cint
  {.emit: "`r` = `d`->exists() ? 1 : 0;".}
  result = r == 1

proc dirMkdir*(d: ptr QDir, name: string): bool =
  let cs = name.cstring; var r: cint
  {.emit: "`r` = `d`->mkdir(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc dirMkpath*(d: ptr QDir, path: string): bool =
  let cs = path.cstring; var r: cint
  {.emit: "`r` = `d`->mkpath(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc dirRmdir*(d: ptr QDir, name: string): bool =
  let cs = name.cstring; var r: cint
  {.emit: "`r` = `d`->rmdir(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc dirCd*(d: ptr QDir, sub: string): bool =
  let cs = sub.cstring; var r: cint
  {.emit: "`r` = `d`->cd(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc dirCdUp*(d: ptr QDir): bool =
  var r: cint
  {.emit: "`r` = `d`->cdUp() ? 1 : 0;".}
  result = r == 1

proc dirEntryList*(d: ptr QDir, filter: string = "*"): seq[string] =
  let cs = filter.cstring; var n: cint
  {.emit: """
    QStringList _del = `d`->entryList(QStringList() << QString::fromUtf8(`cs`),
      QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);
    `n` = _del.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bdel; _bdel = _del.at(`idx`).toUtf8(); `p` = _bdel.constData();".}
    result[i] = $p

proc dirEntryFiles*(d: ptr QDir, filter: string = "*"): seq[string] =
  let cs = filter.cstring; var n: cint
  {.emit: """
    QStringList _def = `d`->entryList(QStringList() << QString::fromUtf8(`cs`), QDir::Files);
    `n` = _def.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bdef; _bdef = _def.at(`idx`).toUtf8(); `p` = _bdef.constData();".}
    result[i] = $p

proc dirFilePath*(d: ptr QDir, fn: string): string =
  let cs = fn.cstring; var p: cstring
  {.emit: "static QByteArray _bdfp; _bdfp = `d`->filePath(QString::fromUtf8(`cs`)).toUtf8(); `p` = _bdfp.constData();".}
  result = $p

proc dirAbsFilePath*(d: ptr QDir, fn: string): string =
  let cs = fn.cstring; var p: cstring
  {.emit: "static QByteArray _bdafp; _bdafp = `d`->absoluteFilePath(QString::fromUtf8(`cs`)).toUtf8(); `p` = _bdafp.constData();".}
  result = $p

proc dirHomePath*(): string =
  var p: cstring
  {.emit: "static QByteArray _bdhome; _bdhome = QDir::homePath().toUtf8(); `p` = _bdhome.constData();".}
  result = $p

proc dirTempPath*(): string =
  var p: cstring
  {.emit: "static QByteArray _bdtmp; _bdtmp = QDir::tempPath().toUtf8(); `p` = _bdtmp.constData();".}
  result = $p

proc dirCurrentPath*(): string =
  var p: cstring
  {.emit: "static QByteArray _bdcur; _bdcur = QDir::currentPath().toUtf8(); `p` = _bdcur.constData();".}
  result = $p

proc dirSetCurrent*(path: string): bool =
  let cs = path.cstring; var r: cint
  {.emit: "`r` = QDir::setCurrent(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc dirRootPath*(): string =
  var p: cstring
  {.emit: "static QByteArray _bdroot; _bdroot = QDir::rootPath().toUtf8(); `p` = _bdroot.constData();".}
  result = $p

proc dirSeparator*(): char =
  var c: char
  {.emit: "`c` = QDir::separator().toLatin1();".}
  result = c

proc dirIsAbsPath*(path: string): bool =
  let cs = path.cstring; var r: cint
  {.emit: "`r` = QDir::isAbsolutePath(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc dirCleanPath*(path: string): string =
  let cs = path.cstring; var p: cstring
  {.emit: "static QByteArray _bdclean; _bdclean = QDir::cleanPath(QString::fromUtf8(`cs`)).toUtf8(); `p` = _bdclean.constData();".}
  result = $p

proc dirDrives*(): seq[string] =
  var n: cint
  {.emit: """
    auto _drives = QDir::drives();
    `n` = _drives.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bddrv; _bddrv = QDir::drives().at(`idx`).absolutePath().toUtf8(); `p` = _bddrv.constData();".}
    result[i] = $p

# ── QFileInfo ─────────────────────────────────────────────────────────────────

proc newFileInfo*(path: string): ptr QFileInfo =
  let cs = path.cstring
  {.emit: "`result` = new QFileInfo(QString::fromUtf8(`cs`));".}

proc fiExists*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->exists() ? 1 : 0;".}
  result = r == 1
proc fiIsFile*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isFile() ? 1 : 0;".}
  result = r == 1
proc fiIsDir*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isDir() ? 1 : 0;".}
  result = r == 1
proc fiIsSymLink*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isSymLink() ? 1 : 0;".}
  result = r == 1
proc fiIsReadable*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isReadable() ? 1 : 0;".}
  result = r == 1
proc fiIsWritable*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isWritable() ? 1 : 0;".}
  result = r == 1
proc fiIsExecutable*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isExecutable() ? 1 : 0;".}
  result = r == 1
proc fiIsHidden*(fi: ptr QFileInfo): bool =
  var r: cint
  {.emit: "`r` = `fi`->isHidden() ? 1 : 0;".}
  result = r == 1
proc fiSize*(fi: ptr QFileInfo): int64 =
  var v: clonglong
  {.emit: "`v` = `fi`->size();".}
  result = v.int64
proc fiFileName*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfifn; _bfifn = `fi`->fileName().toUtf8(); `p` = _bfifn.constData();".}
  result = $p
proc fiBaseName*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfibn; _bfibn = `fi`->baseName().toUtf8(); `p` = _bfibn.constData();".}
  result = $p
proc fiCompleteBaseName*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bficbn; _bficbn = `fi`->completeBaseName().toUtf8(); `p` = _bficbn.constData();".}
  result = $p
proc fiSuffix*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfisuf; _bfisuf = `fi`->suffix().toUtf8(); `p` = _bfisuf.constData();".}
  result = $p
proc fiCompleteSuffix*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bficsuf; _bficsuf = `fi`->completeSuffix().toUtf8(); `p` = _bficsuf.constData();".}
  result = $p
proc fiAbsFilePath*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfiafp; _bfiafp = `fi`->absoluteFilePath().toUtf8(); `p` = _bfiafp.constData();".}
  result = $p
proc fiAbsDir*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfiad; _bfiad = `fi`->absoluteDir().path().toUtf8(); `p` = _bfiad.constData();".}
  result = $p
proc fiSymLinkTarget*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfislt; _bfislt = `fi`->symLinkTarget().toUtf8(); `p` = _bfislt.constData();".}
  result = $p
proc fiOwner*(fi: ptr QFileInfo): string =
  var p: cstring
  {.emit: "static QByteArray _bfio; _bfio = `fi`->owner().toUtf8(); `p` = _bfio.constData();".}
  result = $p
proc fiLastModified*(fi: ptr QFileInfo): QDateTime =
  {.emit: "`result` = `fi`->lastModified();".}
proc fiCreated*(fi: ptr QFileInfo): QDateTime =
  {.emit: "`result` = `fi`->birthTime();".}

# ── QCryptographicHash ────────────────────────────────────────────────────────

type QHashAlgorithm* {.size: sizeof(cint).} = enum
  Md4     = 0
  Md5     = 1
  Sha1    = 2
  Sha224  = 3
  Sha256  = 4
  Sha384  = 5
  Sha512  = 6
  Sha3_224= 7
  Sha3_256= 8
  Sha3_384= 9
  Sha3_512= 10
  Keccak_224 = 11
  Keccak_256 = 12
  Keccak_384 = 13
  Keccak_512 = 14
  Blake2b_160= 15
  Blake2b_256= 16
  Blake2b_384= 17
  Blake2b_512= 18
  Blake2s_128= 19
  Blake2s_160= 20
  Blake2s_224= 21
  Blake2s_256= 22

proc hashData*(algo: QHashAlgorithm, data: string): string =
  ## Вычислить хэш строки, вернуть hex-строку
  let cs = data.cstring; let n = data.len.cint; let a = algo.cint
  var p: cstring
  {.emit: """
    static QByteArray _bhhex;
    _bhhex = QCryptographicHash::hash(
      QByteArray(`cs`, `n`),
      (QCryptographicHash::Algorithm)`a`).toHex();
    `p` = _bhhex.constData();
  """.}
  result = $p

proc hashFile*(algo: QHashAlgorithm, path: string): tuple[ok: bool, hash: string] =
  let cs = path.cstring; let a = algo.cint; var ok: cint; var p: cstring
  {.emit: """
    QFile _hf(QString::fromUtf8(`cs`));
    `ok` = _hf.open(QIODevice::ReadOnly) ? 1 : 0;
    static QByteArray _bhfh;
    if (`ok`) {
      QCryptographicHash _h((QCryptographicHash::Algorithm)`a`);
      _h.addData(&_hf);
      _bhfh = _h.result().toHex();
    } else { _bhfh = ""; }
    `p` = _bhfh.constData();
  """.}
  result = (ok: ok == 1, hash: $p)

# ── QProcess ──────────────────────────────────────────────────────────────────

proc newProcess*(parent: Obj = nil): Proc {.importcpp: "new QProcess(#)".}
proc procStart*(p: Proc, program: string, args: seq[string]) =
  let prog = program.cstring
  var argJoined = ""
  for i, a in args:
    if i > 0: argJoined.add('\0')
    argJoined.add(a)
  let data = argJoined.cstring; let n = args.len.cint
  {.emit: """
    QStringList _pargs;
    const char* _pp = `data`;
    for (int i = 0; i < `n`; i++) {
      _pargs << QString::fromUtf8(_pp);
      _pp += strlen(_pp) + 1;
    }
    `p`->start(QString::fromUtf8(`prog`), _pargs);
  """.}
proc procStartCmd*(pr: Proc, cmd: string) =
  let cs = cmd.cstring
  {.emit: "`pr`->startCommand(QString::fromUtf8(`cs`));".}
proc procWaitForStarted*(p: Proc, ms: cint = 30000): bool =
  var r: cint
  {.emit: "`r` = `p`->waitForStarted(`ms`) ? 1 : 0;".}
  result = r == 1
proc procWaitForFinished*(p: Proc, ms: cint = 30000): bool =
  var r: cint
  {.emit: "`r` = `p`->waitForFinished(`ms`) ? 1 : 0;".}
  result = r == 1
proc procReadStdout*(p: Proc): string =
  var pp: cstring; var n: cint
  {.emit: "static QByteArray _bpso = `p`->readAllStandardOutput(); `pp` = _bpso.constData(); `n` = _bpso.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], pp, n.int)
proc procReadStderr*(p: Proc): string =
  var pp: cstring; var n: cint
  {.emit: "static QByteArray _bpse = `p`->readAllStandardError(); `pp` = _bpse.constData(); `n` = _bpse.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], pp, n.int)
proc procExitCode*(p: Proc): int =
  var v: cint
  {.emit: "`v` = `p`->exitCode();".}
  result = v.int
proc procKill*(p: Proc) {.importcpp: "#->kill()".}
proc procTerminate*(p: Proc) {.importcpp: "#->terminate()".}
proc procIsRunning*(p: Proc): bool =
  var r: cint
  {.emit: "`r` = (`p`->state() == QProcess::Running) ? 1 : 0;".}
  result = r == 1
proc procSetWorkDir*(p: Proc, dir: string) =
  let cs = dir.cstring
  {.emit: "`p`->setWorkingDirectory(QString::fromUtf8(`cs`));".}
proc procWrite*(p: Proc, data: string): int64 =
  let cs = data.cstring; let n = data.len.cint; var v: clonglong
  {.emit: "`v` = `p`->write(`cs`, `n`);".}
  result = v.int64

proc execCmd*(cmd: string, args: seq[string] = @[]): tuple[ok: bool, code: int, stdout: string, stderr: string] =
  var ok: cint; var code: cint
  var op: cstring; var on2: cint
  var ep: cstring; var en: cint
  let prog = cmd.cstring
  var argJoined = ""
  for i, a in args:
    if i > 0: argJoined.add('\0')
    argJoined.add(a)
  let data = argJoined.cstring; let n = args.len.cint
  {.emit: """
    QProcess _xp;
    QStringList _xargs;
    const char* _xp2 = `data`;
    for (int i = 0; i < `n`; i++) {
      _xargs << QString::fromUtf8(_xp2);
      _xp2 += strlen(_xp2) + 1;
    }
    _xp.start(QString::fromUtf8(`prog`), _xargs);
    `ok` = _xp.waitForFinished(30000) ? 1 : 0;
    `code` = _xp.exitCode();
    static QByteArray _xso = _xp.readAllStandardOutput();
    static QByteArray _xse = _xp.readAllStandardError();
    `op` = _xso.constData(); `on2` = _xso.size();
    `ep` = _xse.constData(); `en` = _xse.size();
  """.}
  result.ok = ok == 1; result.code = code.int
  result.stdout = newString(on2.int)
  if on2 > 0: copyMem(addr result.stdout[0], op, on2.int)
  result.stderr = newString(en.int)
  if en > 0: copyMem(addr result.stderr[0], ep, en.int)

# ── QRegularExpression ────────────────────────────────────────────────────────

proc newRegExp*(pattern: string, flags: cint = 0): RegExp =
  let cs = pattern.cstring
  {.emit: "`result` = new QRegularExpression(QString::fromUtf8(`cs`), (QRegularExpression::PatternOptions)`flags`);".}

proc rxMatch*(rx: RegExp, subject: string): tuple[ok: bool, captured: seq[string]] =
  let cs = subject.cstring; var ok: cint; var n: cint
  {.emit: """
    QRegularExpressionMatch _rm = `rx`->match(QString::fromUtf8(`cs`));
    `ok` = _rm.hasMatch() ? 1 : 0;
    `n` = _rm.lastCapturedIndex() + 1;
  """.}
  result.ok = ok == 1
  result.captured = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _brxc; _brxc = _rm.captured(`idx`).toUtf8(); `p` = _brxc.constData();".}
    result.captured[i] = $p

proc rxIsValid*(rx: RegExp): bool =
  var r: cint
  {.emit: "`r` = `rx`->isValid() ? 1 : 0;".}
  result = r == 1

proc rxReplace*(rx: RegExp, subject, replacement: string): string =
  let cs = subject.cstring; let rs = replacement.cstring; var p: cstring
  {.emit: """
    static QByteArray _brxr;
    _brxr = QString::fromUtf8(`cs`)
      .replace(*`rx`, QString::fromUtf8(`rs`)).toUtf8();
    `p` = _brxr.constData();
  """.}
  result = $p

proc rxGlobalMatch*(rx: RegExp, subject: string): seq[string] =
  let cs = subject.cstring; var n: cint
  {.emit: """
    auto _rgm = `rx`->globalMatch(QString::fromUtf8(`cs`));
    QStringList _rgl;
    while (_rgm.hasNext()) _rgl << _rgm.next().captured(0);
    `n` = _rgl.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _brgm; _brgm = _rgl.at(`idx`).toUtf8(); `p` = _brgm.constData();".}
    result[i] = $p

# ── QLocale ───────────────────────────────────────────────────────────────────

proc defaultLocale*(): ptr QLocale =
  {.emit: "`result` = new QLocale();".}

proc localeByName*(name: string): ptr QLocale =
  let cs = name.cstring
  {.emit: "`result` = new QLocale(QString::fromUtf8(`cs`));".}

proc localeSystem*(): ptr QLocale =
  {.emit: "`result` = new QLocale(QLocale::system());".}

proc localeName*(l: ptr QLocale): string =
  var p: cstring
  {.emit: "static QByteArray _bln; _bln = `l`->name().toUtf8(); `p` = _bln.constData();".}
  result = $p

proc localeBcp47*(l: ptr QLocale): string =
  var p: cstring
  {.emit: "static QByteArray _blb; _blb = `l`->bcp47Name().toUtf8(); `p` = _blb.constData();".}
  result = $p

proc localeFormatInt*(l: ptr QLocale, n: int64): string =
  let v = n.clonglong; var p: cstring
  {.emit: "static QByteArray _blfi; _blfi = `l`->toString(`v`).toUtf8(); `p` = _blfi.constData();".}
  result = $p

proc localeFormatFloat*(l: ptr QLocale, f: float64, prec: int = -1): string =
  let pr = prec.cint; var p: cstring
  {.emit: "static QByteArray _blff; _blff = `l`->toString(`f`, 'g', `pr`).toUtf8(); `p` = _blff.constData();".}
  result = $p

proc localeFormatDate*(l: ptr QLocale, d: QDate): string =
  var p: cstring
  {.emit: "static QByteArray _blfd; _blfd = `l`->toString(`d`).toUtf8(); `p` = _blfd.constData();".}
  result = $p

proc localeDecimalPoint*(l: ptr QLocale): char =
  var c: char
  {.emit: "`c` = `l`->decimalPoint().toLatin1();".}
  result = c

proc localeGroupSeparator*(l: ptr QLocale): char =
  var c: char
  {.emit: "`c` = `l`->groupSeparator().toLatin1();".}
  result = c

proc localeCurrencySymbol*(l: ptr QLocale): string =
  var p: cstring
  {.emit: "static QByteArray _blcs; _blcs = `l`->currencySymbol().toUtf8(); `p` = _blcs.constData();".}
  result = $p

# ── QThreadPool ───────────────────────────────────────────────────────────────

proc threadPoolGlobal*(): TPool =
  {.emit: "`result` = QThreadPool::globalInstance();".}

proc tpMaxThreadCount*(tp: TPool): int =
  var v: cint
  {.emit: "`v` = `tp`->maxThreadCount();".}
  result = v.int

proc tpSetMaxThreadCount*(tp: TPool, n: int) =
  let ni = n.cint
  {.emit: "`tp`->setMaxThreadCount(`ni`);".}

proc tpActiveThreadCount*(tp: TPool): int =
  var v: cint
  {.emit: "`v` = `tp`->activeThreadCount();".}
  result = v.int

proc tpWaitForDone*(tp: TPool, ms: int = -1): bool =
  let mi = ms.cint; var r: cint
  {.emit: "`r` = `tp`->waitForDone(`mi`) ? 1 : 0;".}
  result = r == 1

proc tpClear*(tp: TPool) {.importcpp: "#->clear()".}
proc tpReleaseThread*(tp: TPool) {.importcpp: "#->releaseThread()".}
proc tpReserveThread*(tp: TPool) {.importcpp: "#->reserveThread()".}

## Запуск lambda через QRunnable (cdecl callback)
proc tpRun*(tp: TPool, cb: CB, ud: pointer) =
  {.emit: """
    struct _NimRunnable : public QRunnable {
      CB _cb; void* _ud;
      _NimRunnable(CB c, void* u) : _cb(c), _ud(u) {}
      void run() override { _cb(_ud); }
    };
    auto* _r = new _NimRunnable(`cb`, `ud`);
    _r->setAutoDelete(true);
    `tp`->start(_r);
  """.}

# ── QMimeDatabase / QMimeType ─────────────────────────────────────────────────

proc newMimeDatabase*(): ptr QMimeDatabase {.importcpp: "new QMimeDatabase()".}

proc mimeForFile*(db: ptr QMimeDatabase, path: string): QMimeType =
  let cs = path.cstring
  {.emit: "`result` = `db`->mimeTypeForFile(QString::fromUtf8(`cs`));".}

proc mimeForData*(db: ptr QMimeDatabase, data: string): QMimeType =
  let cs = data.cstring; let n = data.len.cint
  {.emit: "`result` = `db`->mimeTypeForData(QByteArray(`cs`, `n`));".}

proc mimeName*(m: QMimeType): string =
  var p: cstring
  {.emit: "static QByteArray _bmn; _bmn = `m`.name().toUtf8(); `p` = _bmn.constData();".}
  result = $p

proc mimeComment*(m: QMimeType): string =
  var p: cstring
  {.emit: "static QByteArray _bmc; _bmc = `m`.comment().toUtf8(); `p` = _bmc.constData();".}
  result = $p

proc mimeIsValid*(m: QMimeType): bool =
  var r: cint
  {.emit: "`r` = `m`.isValid() ? 1 : 0;".}
  result = r == 1

proc mimeSuffixes*(m: QMimeType): seq[string] =
  var n: cint
  {.emit: "QStringList _ms = `m`.suffixes(); `n` = _ms.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint; var p: cstring
    {.emit: "static QByteArray _bms; _bms = _ms.at(`idx`).toUtf8(); `p` = _bms.constData();".}
    result[i] = $p

proc mimeInherits*(m: QMimeType, parent: string): bool =
  let cs = parent.cstring; var r: cint
  {.emit: "`r` = `m`.inherits(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

# ── QLine / QLineF ────────────────────────────────────────────────────────────

proc makeLine*(x1, y1, x2, y2: int): QLine =
  let a=x1.cint; let b=y1.cint; let c=x2.cint; let d=y2.cint
  {.emit: "`result` = QLine(`a`, `b`, `c`, `d`);".}

proc makeLineF*(x1, y1, x2, y2: float64): QLineF =
  {.emit: "`result` = QLineF(`x1`, `y1`, `x2`, `y2`);".}

proc lineX1*(l: QLine): int =
  var v:cint
  {.emit:"`v`=`l`.x1();".}
  result=v.int
proc lineY1*(l: QLine): int =
  var v:cint
  {.emit:"`v`=`l`.y1();".}
  result=v.int
proc lineX2*(l: QLine): int =
  var v:cint
  {.emit:"`v`=`l`.x2();".}
  result=v.int
proc lineY2*(l: QLine): int =
  var v:cint
  {.emit:"`v`=`l`.y2();".}
  result=v.int
proc lineLength*(l: QLineF): float64 =
  var v:cdouble
  {.emit:"`v`=`l`.length();".}
  result=v.float64
proc lineAngle*(l: QLineF): float64 =
  var v:cdouble
  {.emit:"`v`=`l`.angle();".}
  result=v.float64
proc lineIsNull*(l: QLine): bool =
  var v:cint
  {.emit:"`v`=`l`.isNull()?1:0;".}
  result=v==1

# ── QMargins ─────────────────────────────────────────────────────────────────

proc makeMargins*(left, top, right, bottom: int): QMargins =
  let l=left.cint; let t=top.cint; let r=right.cint; let b=bottom.cint
  {.emit: "`result` = QMargins(`l`, `t`, `r`, `b`);".}

proc marginsLeft*(m: QMargins): int   =
  var v:cint
  {.emit:"`v`=`m`.left();".}
  result=v.int
proc marginsTop*(m: QMargins): int    =
  var v:cint
  {.emit:"`v`=`m`.top();".}
  result=v.int
proc marginsRight*(m: QMargins): int  =
  var v:cint
  {.emit:"`v`=`m`.right();".}
  result=v.int
proc marginsBottom*(m: QMargins): int =
  var v:cint
  {.emit:"`v`=`m`.bottom();".}
  result=v.int
proc marginsIsNull*(m: QMargins): bool =
  var v:cint
  {.emit:"`v`=`m`.isNull()?1:0;".}
  result=v==1

proc makeMarginsF*(left, top, right, bottom: float64): QMarginsF =
  {.emit: "`result` = QMarginsF(`left`, `top`, `right`, `bottom`);".}

# ── QSortFilterProxyModel ─────────────────────────────────────────────────────

proc newSFPM*(parent: Obj = nil): SFPM {.importcpp: "new QSortFilterProxyModel(#)".}
proc sfpmSetSource*(m: SFPM, src: AIM) {.importcpp: "#->setSourceModel(#)".}
proc sfpmSetFilterStr*(m: SFPM, s: QString) {.importcpp: "#->setFilterRegularExpression(#)".}
proc sfpmSetFilterCol*(m: SFPM, col: cint) {.importcpp: "#->setFilterKeyColumn(#)".}
proc sfpmSetSortCol*(m: SFPM, col: cint, order: cint) =
  {.emit: "`m`->sort(`col`, (Qt::SortOrder)`order`);".}
proc sfpmSetCaseSensitive*(m: SFPM, b: bool) =
  let bv = b.cint
  {.emit: "`m`->setFilterCaseSensitivity(`bv` ? Qt::CaseSensitive : Qt::CaseInsensitive);".}
proc sfpmRowCount*(m: SFPM): int =
  var v: cint
  {.emit: "`v` = `m`->rowCount();".}
  result = v.int
proc sfpmColCount*(m: SFPM): int =
  var v: cint
  {.emit: "`v` = `m`->columnCount();".}
  result = v.int
proc sfpmInvalidate*(m: SFPM) {.importcpp: "#->invalidate()".}

# ── QModelIndex ───────────────────────────────────────────────────────────────

proc miRow*(idx: QModelIndex): int =
  var v: cint
  {.emit: "`v` = `idx`.row();".}
  result = v.int
proc miCol*(idx: QModelIndex): int =
  var v: cint
  {.emit: "`v` = `idx`.column();".}
  result = v.int
proc miIsValid*(idx: QModelIndex): bool =
  var r: cint
  {.emit: "`r` = `idx`.isValid() ? 1 : 0;".}
  result = r == 1
proc miData*(idx: QModelIndex, role: cint = 0): QVariant =
  {.emit: "`result` = `idx`.data(`role`);".}

# ── QTranslator ───────────────────────────────────────────────────────────────

proc newTranslator*(parent: Obj = nil): ptr QTranslator {.importcpp: "new QTranslator(#)".}
proc trLoad*(t: ptr QTranslator, file: string): bool =
  let cs = file.cstring; var r: cint
  {.emit: "`r` = `t`->load(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1
proc trLoadLocale*(t: ptr QTranslator, file: string, dir: string): bool =
  let cf = file.cstring; let cd = dir.cstring; var r: cint
  {.emit: "`r` = `t`->load(QLocale::system(), QString::fromUtf8(`cf`), \"_\", QString::fromUtf8(`cd`)) ? 1 : 0;".}
  result = r == 1
proc trIsEmpty*(t: ptr QTranslator): bool =
  var r: cint
  {.emit: "`r` = `t`->isEmpty() ? 1 : 0;".}
  result = r == 1





