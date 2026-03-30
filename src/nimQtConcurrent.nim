## nimQtConcurrent.nim — Полная обёртка Qt6Concurrent для Nim
## ============================================================================
## Содержит:
##   § 1.  QFuture<T>          — хранение результата асинхронной операции
##   § 2.  QFutureWatcher<T>   — мониторинг QFuture через сигналы Qt
##   § 3.  QPromise<T>         — публикация результата из потока
##   § 4.  QtConcurrent::run   — запуск функции в пуле потоков QThreadPool
##   § 5.  QtConcurrent::map / mapped / mappedReduced
##   § 6.  QtConcurrent::filter / filtered / filteredReduced
##   § 7.  QtConcurrent::blockingMap / blockingMapped / …
##   § 8.  QFutureInterface<T> — низкоуровневый контроль прогресса
##   § 9.  QtConcurrent::task  — построитель задач (Qt ≥ 6.2)
##   § 10. Удобные Nim-обёртки (runFn, mapSeq, filterSeq, …)
##
## Зависимости: nimQtUtils, nimQtFFI, nimQtCore
##
## Компиляция:
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Concurrent)" \
##     --passL:"$(pkg-config --libs Qt6Concurrent)" app.nim
##
## Установка Qt6Concurrent:
##   Fedora/RHEL : dnf install qt6-qtbase-devel qt6-qtconcurrent-devel
##   Debian/Ubuntu: apt install libqt6concurrent6 qt6-base-dev
##   MSYS2 UCRT64: pacman -S mingw-w64-ucrt-x86_64-qt6-base
##
## Совместимость: Qt 6.2 – Qt 6.11

import nimQtUtils
import nimQtFFI
import nimQtCore

# ── Пути к заголовкам (только Windows/MSYS2) ──────────────────────────────────
when defined(windows):
  {.passC: "-IC:/msys64/ucrt64/include".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtConcurrent".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
  {.passC: "-DQT_CONCURRENT_LIB -DQT_CORE_LIB".}
  {.passL: "-LC:/msys64/ucrt64/lib -lQt6Concurrent -lQt6Core".}
# На Linux/macOS — через pkg-config снаружи

# ── Заголовки C++ ─────────────────────────────────────────────────────────────
{.emit: """
#include <QFuture>
#include <QFutureWatcher>
#include <QFutureSynchronizer>
#include <QPromise>
#include <QFutureInterface>
#include <QtConcurrent/QtConcurrent>
#include <QtConcurrent/QtConcurrentMap>
#include <QtConcurrent/QtConcurrentFilter>
#include <QtConcurrent/QtConcurrentRun>
#include <QtConcurrent/QtConcurrentTask>
#include <QThreadPool>
#include <QThread>
#include <QRunnable>
#include <QMutex>
#include <QMutexLocker>
#include <QVariant>
#include <QList>
#include <QVector>
#include <QStringList>
#include <functional>
#include <type_traits>

// ── Вспомогательные типы для Nim-callback-ов ─────────────────────────────────

// Тип функции без аргументов, возвращает void
typedef void (*NimTaskCB)(void* ud);
// Тип функции, принимает void*, возвращает void
typedef void (*NimMapCB)(void* item, void* ud);
// Тип функции, принимает void*, возвращает bool (для filter)
typedef bool (*NimFilterCB)(const void* item, void* ud);
// Тип функции для reduce: (accum*, item*, ud*)
typedef void (*NimReduceCB)(void* accum, const void* item, void* ud);

// ── Конкретные специализации QFuture для Nim ──────────────────────────────────
// QFuture<void>   — задача без возврата значения
// QFuture<int>    — задача, возвращающая int
// QFuture<double> — задача, возвращающая double
// QFuture<QString>— задача, возвращающая строку
// QFuture<QVariant>— универсальный контейнер
""".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 1. Opaque типы
# ═══════════════════════════════════════════════════════════════════════════════

type
  QFutureVoid*        {.importcpp: "QFuture<void>",     header: "<QFuture>".}    = object
  QFutureInt*         {.importcpp: "QFuture<int>",      header: "<QFuture>".}    = object
  QFutureDouble*      {.importcpp: "QFuture<double>",   header: "<QFuture>".}    = object
  QFutureQString*     {.importcpp: "QFuture<QString>",  header: "<QFuture>".}    = object
  QFutureQVariant*    {.importcpp: "QFuture<QVariant>", header: "<QFuture>".}    = object

  QFutureWatcherVoid*    {.importcpp: "QFutureWatcher<void>",    header: "<QFutureWatcher>".} = object
  QFutureWatcherInt*     {.importcpp: "QFutureWatcher<int>",     header: "<QFutureWatcher>".} = object
  QFutureWatcherDouble*  {.importcpp: "QFutureWatcher<double>",  header: "<QFutureWatcher>".} = object
  QFutureWatcherQString* {.importcpp: "QFutureWatcher<QString>", header: "<QFutureWatcher>".} = object
  QFutureWatcherQVariant*{.importcpp: "QFutureWatcher<QVariant>",header: "<QFutureWatcher>".} = object

  QPromiseVoid*    {.importcpp: "QPromise<void>",    header: "<QPromise>".} = object
  QPromiseInt*     {.importcpp: "QPromise<int>",     header: "<QPromise>".} = object
  QPromiseDouble*  {.importcpp: "QPromise<double>",  header: "<QPromise>".} = object
  QPromiseQString* {.importcpp: "QPromise<QString>", header: "<QPromise>".} = object
  QPromiseQVariant*{.importcpp: "QPromise<QVariant>",header: "<QPromise>".} = object

  QFutureSynchronizer* {.importcpp: "QFutureSynchronizer<void>",
                         header: "<QFutureSynchronizer>".} = object

# Удобные псевдонимы указателей
type
  FutV*   = ptr QFutureVoid
  FutI*   = ptr QFutureInt
  FutD*   = ptr QFutureDouble
  FutS*   = ptr QFutureQString
  FutVar* = ptr QFutureQVariant

  WatchV*   = ptr QFutureWatcherVoid
  WatchI*   = ptr QFutureWatcherInt
  WatchD*   = ptr QFutureWatcherDouble
  WatchS*   = ptr QFutureWatcherQString
  WatchVar* = ptr QFutureWatcherQVariant

  PromV*   = ptr QPromiseVoid
  PromI*   = ptr QPromiseInt
  PromD*   = ptr QPromiseDouble
  PromS*   = ptr QPromiseQString
  PromVar* = ptr QPromiseQVariant

  FutSync* = ptr QFutureSynchronizer

# ═══════════════════════════════════════════════════════════════════════════════
# § 2. QFuture<void> — базовые операции (общие для всех специализаций)
# ═══════════════════════════════════════════════════════════════════════════════

# ── Состояние ─────────────────────────────────────────────────────────────────

proc isStarted*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isStarted() ? 1 : 0;".}
  result = r == 1

proc isRunning*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isRunning() ? 1 : 0;".}
  result = r == 1

proc isFinished*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isFinished() ? 1 : 0;".}
  result = r == 1

proc isSuspended*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isSuspended() ? 1 : 0;".}
  result = r == 1

proc isSuspending*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isSuspending() ? 1 : 0;".}
  result = r == 1

proc isCanceled*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isCanceled() ? 1 : 0;".}
  result = r == 1

proc isValid*(f: QFutureVoid): bool =
  var r: cint
  {.emit: "`r` = `f`.isValid() ? 1 : 0;".}
  result = r == 1

# ── Управление ────────────────────────────────────────────────────────────────

proc waitForFinished*(f: var QFutureVoid) {.importcpp: "#.waitForFinished()".}
proc cancel*(f: var QFutureVoid)          {.importcpp: "#.cancel()".}
proc suspend*(f: var QFutureVoid)         {.importcpp: "#.suspend()".}
proc resume*(f: var QFutureVoid)          {.importcpp: "#.resume()".}
proc toggleSuspended*(f: var QFutureVoid) {.importcpp: "#.toggleSuspended()".}

# ── Прогресс ──────────────────────────────────────────────────────────────────

proc progressValue*(f: QFutureVoid): int =
  var v: cint
  {.emit: "`v` = `f`.progressValue();".}
  result = v.int

proc progressMinimum*(f: QFutureVoid): int =
  var v: cint
  {.emit: "`v` = `f`.progressMinimum();".}
  result = v.int

proc progressMaximum*(f: QFutureVoid): int =
  var v: cint
  {.emit: "`v` = `f`.progressMaximum();".}
  result = v.int

proc progressText*(f: QFutureVoid): string =
  var p: cstring
  {.emit: "QByteArray _fpb = `f`.progressText().toUtf8(); `p` = _fpb.constData();".}
  result = $p

proc resultCount*(f: QFutureVoid): int =
  var v: cint
  {.emit: "`v` = `f`.resultCount();".}
  result = v.int

# ── Аналогичные операции для QFuture<int> ────────────────────────────────────

proc isStarted*(f: QFutureInt): bool =
  var r: cint; {.emit: "`r` = `f`.isStarted() ? 1 : 0;".}; result = r == 1
proc isRunning*(f: QFutureInt): bool =
  var r: cint; {.emit: "`r` = `f`.isRunning() ? 1 : 0;".}; result = r == 1
proc isFinished*(f: QFutureInt): bool =
  var r: cint; {.emit: "`r` = `f`.isFinished() ? 1 : 0;".}; result = r == 1
proc isCanceled*(f: QFutureInt): bool =
  var r: cint; {.emit: "`r` = `f`.isCanceled() ? 1 : 0;".}; result = r == 1
proc isSuspended*(f: QFutureInt): bool =
  var r: cint; {.emit: "`r` = `f`.isSuspended() ? 1 : 0;".}; result = r == 1
proc waitForFinished*(f: var QFutureInt) {.importcpp: "#.waitForFinished()".}
proc cancel*(f: var QFutureInt)          {.importcpp: "#.cancel()".}
proc suspend*(f: var QFutureInt)         {.importcpp: "#.suspend()".}
proc resume*(f: var QFutureInt)          {.importcpp: "#.resume()".}
proc progressValue*(f: QFutureInt): int =
  var v: cint; {.emit: "`v` = `f`.progressValue();".}; result = v.int
proc progressMaximum*(f: QFutureInt): int =
  var v: cint; {.emit: "`v` = `f`.progressMaximum();".}; result = v.int

proc result*(f: QFutureInt): int =
  ## Получить результат (блокирует до готовности).
  var v: cint
  {.emit: "`v` = `f`.result();".}
  result = v.int

proc resultAt*(f: QFutureInt, idx: int): int =
  let i = idx.cint; var v: cint
  {.emit: "`v` = `f`.resultAt(`i`);".}
  result = v.int

proc results*(f: QFutureInt): seq[int] =
  ## Все результаты как seq[int].
  var n: cint
  {.emit: "QList<int> _rl = `f`.results(); `n` = _rl.size();".}
  result = newSeq[int](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var v: cint
    {.emit: "`v` = _rl.at(`ii`);".}
    result[i] = v.int

# ── QFuture<double> ───────────────────────────────────────────────────────────

proc isStarted*(f: QFutureDouble): bool =
  var r: cint; {.emit: "`r` = `f`.isStarted() ? 1 : 0;".}; result = r == 1
proc isRunning*(f: QFutureDouble): bool =
  var r: cint; {.emit: "`r` = `f`.isRunning() ? 1 : 0;".}; result = r == 1
proc isFinished*(f: QFutureDouble): bool =
  var r: cint; {.emit: "`r` = `f`.isFinished() ? 1 : 0;".}; result = r == 1
proc isCanceled*(f: QFutureDouble): bool =
  var r: cint; {.emit: "`r` = `f`.isCanceled() ? 1 : 0;".}; result = r == 1
proc waitForFinished*(f: var QFutureDouble) {.importcpp: "#.waitForFinished()".}
proc cancel*(f: var QFutureDouble)          {.importcpp: "#.cancel()".}
proc resume*(f: var QFutureDouble)          {.importcpp: "#.resume()".}

proc result*(f: QFutureDouble): float64 =
  var v: cdouble
  {.emit: "`v` = `f`.result();".}
  result = v.float64

proc results*(f: QFutureDouble): seq[float64] =
  var n: cint
  {.emit: "QList<double> _rdl = `f`.results(); `n` = _rdl.size();".}
  result = newSeq[float64](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var v: cdouble
    {.emit: "`v` = _rdl.at(`ii`);".}
    result[i] = v.float64

# ── QFuture<QString> ──────────────────────────────────────────────────────────

proc isStarted*(f: QFutureQString): bool =
  var r: cint; {.emit: "`r` = `f`.isStarted() ? 1 : 0;".}; result = r == 1
proc isRunning*(f: QFutureQString): bool =
  var r: cint; {.emit: "`r` = `f`.isRunning() ? 1 : 0;".}; result = r == 1
proc isFinished*(f: QFutureQString): bool =
  var r: cint; {.emit: "`r` = `f`.isFinished() ? 1 : 0;".}; result = r == 1
proc isCanceled*(f: QFutureQString): bool =
  var r: cint; {.emit: "`r` = `f`.isCanceled() ? 1 : 0;".}; result = r == 1
proc waitForFinished*(f: var QFutureQString) {.importcpp: "#.waitForFinished()".}
proc cancel*(f: var QFutureQString)          {.importcpp: "#.cancel()".}
proc resume*(f: var QFutureQString)          {.importcpp: "#.resume()".}

proc result*(f: QFutureQString): string =
  var p: cstring
  {.emit: "QByteArray _rsb = `f`.result().toUtf8(); `p` = _rsb.constData();".}
  result = $p

proc results*(f: QFutureQString): seq[string] =
  var n: cint
  {.emit: "QList<QString> _rsl = `f`.results(); `n` = _rsl.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _rsbi = _rsl.at(`ii`).toUtf8(); `p` = _rsbi.constData();".}
    result[i] = $p

# ── QFuture<QVariant> ─────────────────────────────────────────────────────────

proc isFinished*(f: QFutureQVariant): bool =
  var r: cint; {.emit: "`r` = `f`.isFinished() ? 1 : 0;".}; result = r == 1
proc isCanceled*(f: QFutureQVariant): bool =
  var r: cint; {.emit: "`r` = `f`.isCanceled() ? 1 : 0;".}; result = r == 1
proc isRunning*(f: QFutureQVariant): bool =
  var r: cint; {.emit: "`r` = `f`.isRunning() ? 1 : 0;".}; result = r == 1
proc waitForFinished*(f: var QFutureQVariant) {.importcpp: "#.waitForFinished()".}
proc cancel*(f: var QFutureQVariant)          {.importcpp: "#.cancel()".}
proc result*(f: QFutureQVariant): QVariant    {.importcpp: "#.result()".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 3. QFutureWatcher — мониторинг QFuture через сигналы Qt
# ═══════════════════════════════════════════════════════════════════════════════

# ── Создание ──────────────────────────────────────────────────────────────────

proc newFutureWatcherVoid*(parent: Obj = nil): WatchV =
  {.emit: "`result` = new QFutureWatcher<void>(`parent`);".}

proc newFutureWatcherInt*(parent: Obj = nil): WatchI =
  {.emit: "`result` = new QFutureWatcher<int>(`parent`);".}

proc newFutureWatcherDouble*(parent: Obj = nil): WatchD =
  {.emit: "`result` = new QFutureWatcher<double>(`parent`);".}

proc newFutureWatcherQString*(parent: Obj = nil): WatchS =
  {.emit: "`result` = new QFutureWatcher<QString>(`parent`);".}

proc newFutureWatcherQVariant*(parent: Obj = nil): WatchVar =
  {.emit: "`result` = new QFutureWatcher<QVariant>(`parent`);".}

# ── Привязка future ───────────────────────────────────────────────────────────

proc setFuture*(w: WatchV, f: QFutureVoid) =
  {.emit: "`w`->setFuture(`f`);".}

proc setFuture*(w: WatchI, f: QFutureInt) =
  {.emit: "`w`->setFuture(`f`);".}

proc setFuture*(w: WatchD, f: QFutureDouble) =
  {.emit: "`w`->setFuture(`f`);".}

proc setFuture*(w: WatchS, f: QFutureQString) =
  {.emit: "`w`->setFuture(`f`);".}

proc setFuture*(w: WatchVar, f: QFutureQVariant) =
  {.emit: "`w`->setFuture(`f`);".}

# ── Состояние через watcher ───────────────────────────────────────────────────

proc isStarted*(w: WatchV): bool =
  var r: cint; {.emit: "`r` = `w`->isStarted() ? 1 : 0;".}; result = r == 1
proc isRunning*(w: WatchV): bool =
  var r: cint; {.emit: "`r` = `w`->isRunning() ? 1 : 0;".}; result = r == 1
proc isFinished*(w: WatchV): bool =
  var r: cint; {.emit: "`r` = `w`->isFinished() ? 1 : 0;".}; result = r == 1
proc isCanceled*(w: WatchV): bool =
  var r: cint; {.emit: "`r` = `w`->isCanceled() ? 1 : 0;".}; result = r == 1
proc isSuspended*(w: WatchV): bool =
  var r: cint; {.emit: "`r` = `w`->isSuspended() ? 1 : 0;".}; result = r == 1

proc progressValue*(w: WatchV): int =
  var v: cint; {.emit: "`v` = `w`->progressValue();".}; result = v.int
proc progressMinimum*(w: WatchV): int =
  var v: cint; {.emit: "`v` = `w`->progressMinimum();".}; result = v.int
proc progressMaximum*(w: WatchV): int =
  var v: cint; {.emit: "`v` = `w`->progressMaximum();".}; result = v.int
proc progressText*(w: WatchV): string =
  var p: cstring
  {.emit: "QByteArray _wpb = `w`->progressText().toUtf8(); `p` = _wpb.constData();".}
  result = $p

proc cancel*(w: WatchV)          {.importcpp: "#->cancel()".}
proc suspend*(w: WatchV)         {.importcpp: "#->suspend()".}
proc resume*(w: WatchV)          {.importcpp: "#->resume()".}
proc toggleSuspended*(w: WatchV) {.importcpp: "#->toggleSuspended()".}
proc waitForFinished*(w: WatchV) {.importcpp: "#->waitForFinished()".}

proc cancel*(w: WatchI)          {.importcpp: "#->cancel()".}
proc waitForFinished*(w: WatchI) {.importcpp: "#->waitForFinished()".}
proc progressValue*(w: WatchI): int =
  var v: cint; {.emit: "`v` = `w`->progressValue();".}; result = v.int
proc progressMaximum*(w: WatchI): int =
  var v: cint; {.emit: "`v` = `w`->progressMaximum();".}; result = v.int

# ── Подключение сигналов watcher к Nim-callback-ам ────────────────────────────
# Используется паттерн QObject::connect с лямбдой, принимающей Nim cdecl CB.

proc onFinished*(w: WatchV, cb: CB, ud: pointer) =
  ## Вызывается, когда задача завершена (успешно или с отменой).
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::finished,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onStarted*(w: WatchV, cb: CB, ud: pointer) =
  ## Вызывается при старте задачи.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::started,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onCanceled*(w: WatchV, cb: CB, ud: pointer) =
  ## Вызывается при отмене.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::canceled,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onSuspended*(w: WatchV, cb: CB, ud: pointer) =
  ## Вызывается при приостановке.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::suspended,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onResumed*(w: WatchV, cb: CB, ud: pointer) =
  ## Вызывается при возобновлении.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::resumed,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onProgressChanged*(w: WatchV, cb: CBInt, ud: pointer) =
  ## Вызывается при изменении прогресса; передаёт текущее значение.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::progressValueChanged,
      `w`, [=](int _pv) { `cb`(_pv, `ud`); });
  """.}

proc onProgressRangeChanged*(w: WatchV, cb: CBInt, ud: pointer) =
  ## Вызывается при изменении диапазона прогресса; передаёт максимум.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::progressRangeChanged,
      `w`, [=](int _min, int _max) { `cb`(_max, `ud`); });
  """.}

proc onProgressTextChanged*(w: WatchV, cb: CBStr, ud: pointer) =
  ## Вызывается при изменении текста прогресса.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<void>::progressTextChanged,
      `w`, [=](const QString& _pt) {
        QByteArray _ba = _pt.toUtf8();
        `cb`(_ba.constData(), `ud`);
      });
  """.}

proc onResultReadyAt*(w: WatchI, cb: CBInt, ud: pointer) =
  ## Вызывается, когда готов результат с индексом idx.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<int>::resultReadyAt,
      `w`, [=](int _idx) { `cb`(_idx, `ud`); });
  """.}

proc onResultsReadyAt*(w: WatchI, cb: CBInt, ud: pointer) =
  ## Вызывается при готовности диапазона результатов; передаёт beginIndex.
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<int>::resultsReadyAt,
      `w`, [=](int _b, int _e) { `cb`(_b, `ud`); });
  """.}

proc onFinished*(w: WatchI, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<int>::finished,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onCanceled*(w: WatchI, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<int>::canceled,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onFinished*(w: WatchD, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<double>::finished,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onFinished*(w: WatchS, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<QString>::finished,
      `w`, [=]() { `cb`(`ud`); });
  """.}

proc onFinished*(w: WatchVar, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`w`, &QFutureWatcher<QVariant>::finished,
      `w`, [=]() { `cb`(`ud`); });
  """.}

# ── Удаление watcher ──────────────────────────────────────────────────────────

proc deleteFutureWatcher*(w: WatchV)   {.importcpp: "delete #".}
proc deleteFutureWatcher*(w: WatchI)   {.importcpp: "delete #".}
proc deleteFutureWatcher*(w: WatchD)   {.importcpp: "delete #".}
proc deleteFutureWatcher*(w: WatchS)   {.importcpp: "delete #".}
proc deleteFutureWatcher*(w: WatchVar) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 4. QPromise — публикация результата из потока исполнителя
# ═══════════════════════════════════════════════════════════════════════════════

proc newPromiseVoid*(): PromV =
  {.emit: "`result` = new QPromise<void>();".}

proc newPromiseInt*(): PromI =
  {.emit: "`result` = new QPromise<int>();".}

proc newPromiseDouble*(): PromD =
  {.emit: "`result` = new QPromise<double>();".}

proc newPromiseQString*(): PromS =
  {.emit: "`result` = new QPromise<QString>();".}

proc newPromiseQVariant*(): PromVar =
  {.emit: "`result` = new QPromise<QVariant>();".}

# ── Жизненный цикл ────────────────────────────────────────────────────────────

proc start*(p: PromV)  {.importcpp: "#->start()".}
proc start*(p: PromI)  {.importcpp: "#->start()".}
proc start*(p: PromD)  {.importcpp: "#->start()".}
proc start*(p: PromS)  {.importcpp: "#->start()".}
proc start*(p: PromVar){.importcpp: "#->start()".}

proc finish*(p: PromV)  {.importcpp: "#->finish()".}
proc finish*(p: PromI)  {.importcpp: "#->finish()".}
proc finish*(p: PromD)  {.importcpp: "#->finish()".}
proc finish*(p: PromS)  {.importcpp: "#->finish()".}
proc finish*(p: PromVar){.importcpp: "#->finish()".}

proc cancel*(p: PromV)  {.importcpp: "#->future().cancel()".}
proc cancel*(p: PromI)  {.importcpp: "#->future().cancel()".}

proc isCanceled*(p: PromV): bool =
  var r: cint; {.emit: "`r` = `p`->isCanceled() ? 1 : 0;".}; result = r == 1
proc isCanceled*(p: PromI): bool =
  var r: cint; {.emit: "`r` = `p`->isCanceled() ? 1 : 0;".}; result = r == 1

# ── Добавление результатов ────────────────────────────────────────────────────

proc addResult*(p: PromI, val: int) =
  let v = val.cint
  {.emit: "`p`->addResult(`v`);".}

proc addResult*(p: PromD, val: float64) =
  let v = val.cdouble
  {.emit: "`p`->addResult(`v`);".}

proc addResult*(p: PromS, val: string) =
  let cs = val.cstring
  {.emit: "`p`->addResult(QString::fromUtf8(`cs`));".}

proc addResult*(p: PromVar, val: QVariant) =
  {.emit: "`p`->addResult(`val`);".}

proc addResults*(p: PromI, vals: seq[int]) =
  ## Добавить несколько int-результатов за раз.
  {.emit: "QList<int> _pi;".}
  for v in vals:
    let cv = v.cint
    {.emit: "_pi.append(`cv`);".}
  {.emit: "`p`->addResults(_pi);".}

# ── Прогресс ──────────────────────────────────────────────────────────────────

proc setProgressValue*(p: PromV, v: int) =
  let cv = v.cint; {.emit: "`p`->setProgressValue(`cv`);".}
proc setProgressValue*(p: PromI, v: int) =
  let cv = v.cint; {.emit: "`p`->setProgressValue(`cv`);".}

proc setProgressRange*(p: PromV, minV, maxV: int) =
  let cmin = minV.cint; let cmax = maxV.cint
  {.emit: "`p`->setProgressRange(`cmin`, `cmax`);".}
proc setProgressRange*(p: PromI, minV, maxV: int) =
  let cmin = minV.cint; let cmax = maxV.cint
  {.emit: "`p`->setProgressRange(`cmin`, `cmax`);".}

proc setProgressValueAndText*(p: PromV, v: int, text: string) =
  let cv = v.cint; let cs = text.cstring
  {.emit: "`p`->setProgressValueAndText(`cv`, QString::fromUtf8(`cs`));".}

# ── Получение QFuture из QPromise ─────────────────────────────────────────────

proc future*(p: PromV): QFutureVoid =
  {.emit: "`result` = `p`->future();".}

proc future*(p: PromI): QFutureInt =
  {.emit: "`result` = `p`->future();".}

proc future*(p: PromD): QFutureDouble =
  {.emit: "`result` = `p`->future();".}

proc future*(p: PromS): QFutureQString =
  {.emit: "`result` = `p`->future();".}

proc future*(p: PromVar): QFutureQVariant =
  {.emit: "`result` = `p`->future();".}

# ── Удаление ──────────────────────────────────────────────────────────────────

proc deletePromise*(p: PromV)   {.importcpp: "delete #".}
proc deletePromise*(p: PromI)   {.importcpp: "delete #".}
proc deletePromise*(p: PromD)   {.importcpp: "delete #".}
proc deletePromise*(p: PromS)   {.importcpp: "delete #".}
proc deletePromise*(p: PromVar) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 5. QtConcurrent::run — запуск функции в пуле потоков
# ═══════════════════════════════════════════════════════════════════════════════

proc concurrentRun*(cb: CB, ud: pointer): QFutureVoid =
  ## Запустить void-функцию `cb(ud)` в глобальном QThreadPool.
  {.emit: """
    `result` = QtConcurrent::run([=]() {
      `cb`(`ud`);
    });
  """.}

proc concurrentRunOnPool*(pool: TPool, cb: CB, ud: pointer): QFutureVoid =
  ## Запустить void-функцию в указанном QThreadPool.
  {.emit: """
    `result` = QtConcurrent::run(`pool`, [=]() {
      `cb`(`ud`);
    });
  """.}

proc concurrentRunInt*(cb: pointer, ud: pointer): QFutureInt =
  ## Запустить функцию, возвращающую int.
  ## cb должен иметь тип: proc(ud: pointer): cint {.cdecl.}
  {.emit: """
    typedef int (*_NimIntCB)(void*);
    `result` = QtConcurrent::run([=]() -> int {
      return ((_NimIntCB)`cb`)(`ud`);
    });
  """.}

proc concurrentRunDouble*(cb: pointer, ud: pointer): QFutureDouble =
  ## Запустить функцию, возвращающую double.
  ## cb должен иметь тип: proc(ud: pointer): cdouble {.cdecl.}
  {.emit: """
    typedef double (*_NimDblCB)(void*);
    `result` = QtConcurrent::run([=]() -> double {
      return ((_NimDblCB)`cb`)(`ud`);
    });
  """.}

proc concurrentRunString*(cb: pointer, ud: pointer): QFutureQString =
  ## Запустить функцию, возвращающую string (через cstring).
  ## cb должен иметь тип: proc(ud: pointer): cstring {.cdecl.}
  {.emit: """
    typedef const char* (*_NimStrCB)(void*);
    `result` = QtConcurrent::run([=]() -> QString {
      const char* _r = ((_NimStrCB)`cb`)(`ud`);
      return _r ? QString::fromUtf8(_r) : QString{};
    });
  """.}

# ── Запуск с аргументом (передача одного значения через int64) ─────────────────

proc concurrentRunWithArg*(cb: CBInt, arg: int, ud: pointer): QFutureVoid =
  ## Запустить `cb(arg, ud)` асинхронно.
  let carg = arg.cint
  {.emit: """
    `result` = QtConcurrent::run([=]() {
      `cb`(`carg`, `ud`);
    });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 6. QtConcurrent::map / mapped / mappedReduced
#       Работа через QList<QVariant> как универсальный контейнер
# ═══════════════════════════════════════════════════════════════════════════════

proc concurrentMapInPlace*(items: ptr QStringList, cb: CBStr, ud: pointer): QFutureVoid =
  ## Применить `cb` к каждому элементу QStringList на месте (изменяет список).
  ## cb получает (cstring element, ud).
  ## ВНИМАНИЕ: items должен жить до завершения future.
  {.emit: """
    `result` = QtConcurrent::map(*`items`,
      [=](QString& _s) {
        QByteArray _ba = _s.toUtf8();
        // callback может изменить строку через отдельный механизм;
        // здесь передаём только для side-effect уведомления
        `cb`(_ba.constData(), `ud`);
      });
  """.}

proc concurrentMappedInt*(items: ptr QStringList,
                           cb: pointer, ud: pointer): QFutureInt =
  ## Преобразовать QStringList в QFuture<int> через cb(cstring) -> int.
  {.emit: """
    typedef int (*_NimStoICB)(const char*, void*);
    QList<int> _dummy;
    `result` = QtConcurrent::mapped(*`items`,
      [=](const QString& _s) -> int {
        QByteArray _ba = _s.toUtf8();
        return ((_NimStoICB)`cb`)(_ba.constData(), `ud`);
      });
  """.}

proc concurrentMappedString*(items: ptr QStringList,
                              cb: pointer, ud: pointer): QFutureQString =
  ## Преобразовать каждый элемент QStringList в новую QString через cb.
  {.emit: """
    typedef const char* (*_NimStoCB)(const char*, void*);
    `result` = QtConcurrent::mapped(*`items`,
      [=](const QString& _s) -> QString {
        QByteArray _ba = _s.toUtf8();
        const char* _r = ((_NimStoCB)`cb`)(_ba.constData(), `ud`);
        return _r ? QString::fromUtf8(_r) : QString{};
      });
  """.}

proc concurrentMappedReducedInt*(items: ptr QStringList,
                                  mapCb:    pointer,
                                  reduceCb: pointer,
                                  ud: pointer): QFutureInt =
  ## map: QString -> int,  reduce: (int& accum, int item) -> void
  {.emit: """
    typedef int  (*_NimMapCB2)(const char*, void*);
    typedef void (*_NimRedCB2)(int*, int, void*);
    `result` = QtConcurrent::mappedReduced<int>(*`items`,
      [=](const QString& _s) -> int {
        QByteArray _ba = _s.toUtf8();
        return ((_NimMapCB2)`mapCb`)(_ba.constData(), `ud`);
      },
      [=](int& _acc, const int& _item) {
        ((_NimRedCB2)`reduceCb`)(&_acc, _item, `ud`);
      });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 7. QtConcurrent::filter / filtered / filteredReduced
# ═══════════════════════════════════════════════════════════════════════════════

proc concurrentFilterInPlace*(items: ptr QStringList,
                               cb: pointer, ud: pointer): QFutureVoid =
  ## Оставить в QStringList только элементы, для которых cb(str, ud) == true.
  {.emit: """
    typedef bool (*_NimFltCB)(const char*, void*);
    `result` = QtConcurrent::filter(*`items`,
      [=](const QString& _s) -> bool {
        QByteArray _ba = _s.toUtf8();
        return ((_NimFltCB)`cb`)(_ba.constData(), `ud`);
      });
  """.}

proc concurrentFiltered*(items: ptr QStringList,
                         cb: pointer, ud: pointer): QFutureQString =
  ## Вернуть новый QFuture<QString> с отфильтрованными элементами.
  {.emit: """
    typedef bool (*_NimFltCB2)(const char*, void*);
    `result` = QtConcurrent::filtered(*`items`,
      [=](const QString& _s) -> bool {
        QByteArray _ba = _s.toUtf8();
        return ((_NimFltCB2)`cb`)(_ba.constData(), `ud`);
      });
  """.}

proc concurrentFilteredReducedInt*(items: ptr QStringList,
                                    filterCb: pointer,
                                    reduceCb: pointer,
                                    ud: pointer): QFutureInt =
  ## filter: bool(str), reduce: (int& accum, str) -> void
  {.emit: """
    typedef bool (*_NimFlt3CB)(const char*, void*);
    typedef void (*_NimRed3CB)(int*, const char*, void*);
    `result` = QtConcurrent::filteredReduced<int>(*`items`,
      [=](const QString& _s) -> bool {
        QByteArray _ba = _s.toUtf8();
        return ((_NimFlt3CB)`filterCb`)(_ba.constData(), `ud`);
      },
      [=](int& _acc, const QString& _s) {
        QByteArray _ba = _s.toUtf8();
        ((_NimRed3CB)`reduceCb`)(&_acc, _ba.constData(), `ud`);
      });
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 8. Блокирующие варианты (blocking*)
# ═══════════════════════════════════════════════════════════════════════════════

proc blockingMappedInt*(items: ptr QStringList,
                        cb: pointer, ud: pointer): seq[int] =
  ## Синхронный mapped: QStringList -> seq[int].
  var n: cint
  {.emit: """
    typedef int (*_NimBMCB)(const char*, void*);
    QList<int> _bml = QtConcurrent::blockingMapped<QList<int>>(*`items`,
      [=](const QString& _s) -> int {
        QByteArray _ba = _s.toUtf8();
        return ((_NimBMCB)`cb`)(_ba.constData(), `ud`);
      });
    `n` = _bml.size();
  """.}
  result = newSeq[int](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var v: cint
    {.emit: "`v` = _bml.at(`ii`);".}
    result[i] = v.int

proc blockingMappedString*(items: ptr QStringList,
                           cb: pointer, ud: pointer): seq[string] =
  ## Синхронный mapped: QStringList -> seq[string].
  var n: cint
  {.emit: """
    typedef const char* (*_NimBMSCB)(const char*, void*);
    QList<QString> _bmsl = QtConcurrent::blockingMapped<QList<QString>>(*`items`,
      [=](const QString& _s) -> QString {
        QByteArray _ba = _s.toUtf8();
        const char* _r = ((_NimBMSCB)`cb`)(_ba.constData(), `ud`);
        return _r ? QString::fromUtf8(_r) : QString{};
      });
    `n` = _bmsl.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _bmbi = _bmsl.at(`ii`).toUtf8(); `p` = _bmbi.constData();".}
    result[i] = $p

proc blockingMappedReducedInt*(items: ptr QStringList,
                                mapCb:    pointer,
                                reduceCb: pointer,
                                ud: pointer): int =
  ## Синхронный mappedReduced -> int.
  var v: cint
  {.emit: """
    typedef int  (*_NimBMRMapCB)(const char*, void*);
    typedef void (*_NimBMRRedCB)(int*, int, void*);
    `v` = QtConcurrent::blockingMappedReduced<int>(*`items`,
      [=](const QString& _s) -> int {
        QByteArray _ba = _s.toUtf8();
        return ((_NimBMRMapCB)`mapCb`)(_ba.constData(), `ud`);
      },
      [=](int& _acc, const int& _item) {
        ((_NimBMRRedCB)`reduceCb`)(&_acc, _item, `ud`);
      });
  """.}
  result = v.int

proc blockingFilteredString*(items: ptr QStringList,
                             cb: pointer, ud: pointer): seq[string] =
  ## Синхронный filtered: вернуть только прошедшие фильтр строки.
  var n: cint
  {.emit: """
    typedef bool (*_NimBFCB)(const char*, void*);
    QStringList _bfl = QtConcurrent::blockingFiltered(*`items`,
      [=](const QString& _s) -> bool {
        QByteArray _ba = _s.toUtf8();
        return ((_NimBFCB)`cb`)(_ba.constData(), `ud`);
      });
    `n` = _bfl.size();
  """.}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _bfbi = _bfl.at(`ii`).toUtf8(); `p` = _bfbi.constData();".}
    result[i] = $p

proc blockingFilteredReducedInt*(items: ptr QStringList,
                                  filterCb: pointer,
                                  reduceCb: pointer,
                                  ud: pointer): int =
  var v: cint
  {.emit: """
    typedef bool (*_NimBFRFlt)(const char*, void*);
    typedef void (*_NimBFRRed)(int*, const char*, void*);
    `v` = QtConcurrent::blockingFilteredReduced<int>(*`items`,
      [=](const QString& _s) -> bool {
        QByteArray _ba = _s.toUtf8();
        return ((_NimBFRFlt)`filterCb`)(_ba.constData(), `ud`);
      },
      [=](int& _acc, const QString& _s) {
        QByteArray _ba = _s.toUtf8();
        ((_NimBFRRed)`reduceCb`)(&_acc, _ba.constData(), `ud`);
      });
  """.}
  result = v.int

# ═══════════════════════════════════════════════════════════════════════════════
# § 9. QFutureSynchronizer — ожидание набора future
# ═══════════════════════════════════════════════════════════════════════════════

proc newFutureSynchronizer*(): FutSync =
  {.emit: "`result` = new QFutureSynchronizer<void>();".}

proc addFuture*(sync: FutSync, f: QFutureVoid) =
  {.emit: "`sync`->addFuture(`f`);".}

proc setFuture*(sync: FutSync, f: QFutureVoid) =
  ## Заменить все futures одним.
  {.emit: "`sync`->setFuture(`f`);".}

proc waitForFinished*(sync: FutSync) {.importcpp: "#->waitForFinished()".}

proc cancelOnWait*(sync: FutSync): bool =
  var r: cint
  {.emit: "`r` = `sync`->cancelOnWait() ? 1 : 0;".}
  result = r == 1

proc setCancelOnWait*(sync: FutSync, cancel: bool) =
  let cv = cancel.cint
  {.emit: "`sync`->setCancelOnWait(`cv` != 0);".}

proc clearFutures*(sync: FutSync) {.importcpp: "#->clearFutures()".}

proc deleteFutureSynchronizer*(sync: FutSync) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 10. QtConcurrent::task — построитель задач (Qt ≥ 6.2)
# ═══════════════════════════════════════════════════════════════════════════════
# QTaskBuilder не имеет стабильного opaque-представления в Nim,
# поэтому предоставляем хелперы через emit.

proc concurrentTask*(cb: CB, ud: pointer): QFutureVoid =
  ## Запустить задачу через QtConcurrent::task (Qt ≥ 6.2).
  ## Эквивалентно concurrentRun, но использует новый API построителя.
  {.emit: """
    `result` = QtConcurrent::task([=]() {
      `cb`(`ud`);
    }).spawn();
  """.}

proc concurrentTaskOnPool*(pool: TPool, cb: CB, ud: pointer): QFutureVoid =
  ## Запустить задачу в заданном пуле через QtConcurrent::task.
  {.emit: """
    `result` = QtConcurrent::task([=]() {
      `cb`(`ud`);
    }).onThreadPool(*`pool`).spawn();
  """.}

proc concurrentTaskWithPriority*(cb: CB, ud: pointer,
                                  priority: int): QFutureVoid =
  ## Запустить задачу с заданным приоритетом (Qt ≥ 6.2).
  let cp = priority.cint
  {.emit: """
    `result` = QtConcurrent::task([=]() {
      `cb`(`ud`);
    }).withPriority(`cp`).spawn();
  """.}

proc concurrentTaskInt*(cb: pointer, ud: pointer): QFutureInt =
  ## Запустить задачу, возвращающую int, через QtConcurrent::task.
  {.emit: """
    typedef int (*_NimTskICB)(void*);
    `result` = QtConcurrent::task([=]() -> int {
      return ((_NimTskICB)`cb`)(`ud`);
    }).spawn();
  """.}

proc concurrentTaskDouble*(cb: pointer, ud: pointer): QFutureDouble =
  ## Запустить задачу, возвращающую double, через QtConcurrent::task.
  {.emit: """
    typedef double (*_NimTskDCB)(void*);
    `result` = QtConcurrent::task([=]() -> double {
      return ((_NimTskDCB)`cb`)(`ud`);
    }).spawn();
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 11. QFutureInterface — низкоуровневый контроль (продвинутые случаи)
# ═══════════════════════════════════════════════════════════════════════════════

type
  QFutureInterfaceVoid* {.importcpp: "QFutureInterface<void>",
                          header: "<QFutureInterface>".} = object
  QFutureInterfaceInt*  {.importcpp: "QFutureInterface<int>",
                          header: "<QFutureInterface>".} = object

type
  FutIfV* = ptr QFutureInterfaceVoid
  FutIfI* = ptr QFutureInterfaceInt

proc newFutureInterface*(): FutIfV =
  {.emit: "`result` = new QFutureInterface<void>();".}

proc newFutureInterfaceInt*(): FutIfI =
  {.emit: "`result` = new QFutureInterface<int>();".}

proc reportStarted*(fi: FutIfV)  {.importcpp: "#->reportStarted()".}
proc reportFinished*(fi: FutIfV) {.importcpp: "#->reportFinished()".}
proc reportCanceled*(fi: FutIfV) {.importcpp: "#->reportCanceled()".}

proc reportStarted*(fi: FutIfI)  {.importcpp: "#->reportStarted()".}
proc reportFinished*(fi: FutIfI) {.importcpp: "#->reportFinished()".}

proc setProgressRange*(fi: FutIfV, minV, maxV: int) =
  let cmin = minV.cint; let cmax = maxV.cint
  {.emit: "`fi`->setProgressRange(`cmin`, `cmax`);".}

proc setProgressValue*(fi: FutIfV, v: int) =
  let cv = v.cint; {.emit: "`fi`->setProgressValue(`cv`);".}

proc setProgressValueAndText*(fi: FutIfV, v: int, text: string) =
  let cv = v.cint; let cs = text.cstring
  {.emit: "`fi`->setProgressValueAndText(`cv`, QString::fromUtf8(`cs`));".}

proc reportResult*(fi: FutIfI, val: int) =
  let cv = val.cint; {.emit: "`fi`->reportResult(`cv`);".}

proc isCanceled*(fi: FutIfV): bool =
  var r: cint; {.emit: "`r` = `fi`->isCanceled() ? 1 : 0;".}; result = r == 1

proc future*(fi: FutIfV): QFutureVoid =
  {.emit: "`result` = `fi`->future();".}

proc future*(fi: FutIfI): QFutureInt =
  {.emit: "`result` = `fi`->future();".}

proc deleteFutureInterface*(fi: FutIfV) {.importcpp: "delete #".}
proc deleteFutureInterface*(fi: FutIfI) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 12. Удобные высокоуровневые Nim-обёртки
# ═══════════════════════════════════════════════════════════════════════════════

proc runAsync*(cb: proc() {.cdecl.}): QFutureVoid =
  ## Запустить proc без аргументов асинхронно.
  ## Пример:
  ##   let f = runAsync(proc() {.cdecl.} = heavyWork())
  ##   f.waitForFinished()
  let rawCb = cast[CB](cb)
  result = concurrentRun(rawCb, nil)

proc runAsyncWithData*[T](cb: proc(data: ptr T) {.cdecl.},
                           data: ptr T): QFutureVoid =
  ## Запустить proc с указателем на данные асинхронно.
  let rawCb = cast[CB](cb)
  result = concurrentRun(rawCb, cast[pointer](data))

proc waitAll*(futures: var openArray[QFutureVoid]) =
  ## Дождаться завершения всех futures.
  for i in 0 ..< futures.len:
    futures[i].waitForFinished()

proc cancelAll*(futures: var openArray[QFutureVoid]) =
  ## Отменить все futures.
  for i in 0 ..< futures.len:
    futures[i].cancel()

proc anyRunning*(futures: openArray[QFutureVoid]): bool =
  ## Проверить, выполняется ли хоть один future.
  for f in futures:
    if f.isRunning(): return true
  return false

proc allFinished*(futures: openArray[QFutureVoid]): bool =
  ## Проверить, завершены ли все futures.
  for f in futures:
    if not f.isFinished(): return false
  return true

proc mapSeqAsync*(strs: seq[string],
                  cb: pointer, ud: pointer): QFutureQString =
  ## Запустить QtConcurrent::mapped по seq[string].
  ## cb: proc(s: cstring, ud: pointer): cstring {.cdecl.}
  let qs = toQStringList(strs)
  var qsl: ptr QStringList
  {.emit: """
    static QStringList _msa_list;
    _msa_list = `qs`;
    `qsl` = &_msa_list;
  """.}
  result = concurrentMappedString(qsl, cb, ud)

proc filterSeqAsync*(strs: seq[string],
                     cb: pointer, ud: pointer): QFutureQString =
  ## Запустить QtConcurrent::filtered по seq[string].
  ## cb: proc(s: cstring, ud: pointer): bool {.cdecl.}
  let qs = toQStringList(strs)
  var qsl: ptr QStringList
  {.emit: """
    static QStringList _fsa_list;
    _fsa_list = `qs`;
    `qsl` = &_fsa_list;
  """.}
  result = concurrentFiltered(qsl, cb, ud)

proc blockingMapSeq*(strs: seq[string],
                     cb: pointer, ud: pointer): seq[string] =
  ## Синхронно отобразить seq[string] -> seq[string].
  let qs = toQStringList(strs)
  var qsl: ptr QStringList
  {.emit: """
    static QStringList _bms_list;
    _bms_list = `qs`;
    `qsl` = &_bms_list;
  """.}
  result = blockingMappedString(qsl, cb, ud)

proc blockingFilterSeq*(strs: seq[string],
                        cb: pointer, ud: pointer): seq[string] =
  ## Синхронно отфильтровать seq[string].
  let qs = toQStringList(strs)
  var qsl: ptr QStringList
  {.emit: """
    static QStringList _bfs_list;
    _bfs_list = `qs`;
    `qsl` = &_bfs_list;
  """.}
  result = blockingFilteredString(qsl, cb, ud)

proc blockingMapReduceSeq*(strs: seq[string],
                            mapCb:    pointer,
                            reduceCb: pointer,
                            ud: pointer): int =
  ## Синхронно выполнить map+reduce по seq[string] -> int.
  let qs = toQStringList(strs)
  var qsl: ptr QStringList
  {.emit: """
    static QStringList _bmr_list;
    _bmr_list = `qs`;
    `qsl` = &_bmr_list;
  """.}
  result = blockingMappedReducedInt(qsl, mapCb, reduceCb, ud)
