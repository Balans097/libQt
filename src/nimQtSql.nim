## nimQtSql.nim — Полная обёртка Qt6Sql для Nim
## ============================================================================
## Содержит:
##   § 1.  Типы и перечисления (QSql::*)
##   § 2.  QSqlDatabase    — управление соединениями с БД
##   § 3.  QSqlQuery       — выполнение SQL-запросов
##   § 4.  QSqlRecord      — одна строка результата
##   § 5.  QSqlField       — одно поле записи
##   § 6.  QSqlError       — информация об ошибке
##   § 7.  QSqlIndex       — индекс таблицы
##   § 8.  QSqlDriver      — низкоуровневый драйвер
##   § 9.  QSqlDriverCreator — регистрация пользовательских драйверов
##   § 10. QSqlTableModel  — модель таблицы (QAbstractTableModel)
##   § 11. QSqlQueryModel  — модель произвольного SELECT
##   § 12. QSqlRelationalTableModel — модель с внешними ключами
##   § 13. QSqlRelation    — описание внешнего ключа
##   § 14. Nim-хелперы     — удобные proc поверх низкого уровня
##
## Зависимости: nimQtUtils, nimQtFFI, nimQtCore
##
## Компиляция:
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Sql)" \
##     --passL:"$(pkg-config --libs Qt6Sql)" app.nim
##
## Установка Qt6Sql:
##   Fedora/RHEL  : dnf install qt6-qtbase-devel
##   Debian/Ubuntu: apt install libqt6sql6 qt6-base-dev
##   MSYS2 UCRT64 : pacman -S mingw-w64-ucrt-x86_64-qt6-base
##
## Встроенные драйверы Qt6:
##   QSQLITE   — SQLite 3 (всегда доступен в статической сборке)
##   QPSQL     — PostgreSQL
##   QMYSQL    — MySQL / MariaDB
##   QODBC     — ODBC (Windows/Linux unixODBC)
##   QDB2      — IBM DB2
##   QIBASE    — Firebird / InterBase
##   QOCI      — Oracle (OCI)
##   QTDS      — Sybase (устарел)
##
## Совместимость: Qt 6.2 – Qt 6.11

import nimQtUtils
import nimQtFFI
import nimQtCore
import strutils

# ── Пути к заголовкам (только Windows/MSYS2) ──────────────────────────────────
when defined(windows):
  {.passC: "-IC:/msys64/ucrt64/include".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtSql".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
  {.passC: "-DQT_SQL_LIB -DQT_CORE_LIB".}
  {.passL: "-LC:/msys64/ucrt64/lib -lQt6Sql -lQt6Core".}
# На Linux/macOS — через pkg-config снаружи

# ── Заголовки C++ ─────────────────────────────────────────────────────────────
{.emit: """
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlError>
#include <QSqlIndex>
#include <QSqlDriver>
#include <QSqlDriverPlugin>
#include <QSqlResult>
#include <QSqlTableModel>
#include <QSqlQueryModel>
#include <QSqlRelationalTableModel>
#include <QSqlRelation>
#include <QSqlRelationalDelegate>
#include <QVariant>
#include <QVariantList>
#include <QMap>
#include <QStringList>
#include <QDateTime>
#include <QAbstractTableModel>
#include <QModelIndex>
#include <functional>
#include <cstring>
""".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 1. Перечисления QSql::*
# ═══════════════════════════════════════════════════════════════════════════════

type
  QSqlLocation* {.size: sizeof(cint).} = enum
    ## Позиция курсора в результирующем наборе
    SqlBeforeFirstRow = -1   ## Перед первой строкой
    SqlAfterLastRow   = -2   ## После последней строки

  QSqlParamType* {.size: sizeof(cint).} = enum
    ## Направление параметра хранимой процедуры
    SqlIn    = 1   ## Входной параметр
    SqlOut   = 2   ## Выходной параметр
    SqlInOut = 3   ## Двунаправленный
    SqlBinary = 4  ## Двоичный (BLOB)

  QSqlTableModelEditStrategy* {.size: sizeof(cint).} = enum
    ## Стратегия записи изменений в QSqlTableModel
    OnFieldChange  = 0  ## Немедленно при изменении поля
    OnRowChange    = 1  ## При переходе на другую строку
    OnManualSubmit = 2  ## Только при явном вызове submitAll()

  QSqlTableModelSelectScope* {.size: sizeof(cint).} = enum
    ## Область видимости SELECT при submitAll / revertAll
    AllRows         = 0
    OnlySelectedRows = 1

  QSqlFieldRequired* {.size: sizeof(cint).} = enum
    ## Обязательность поля
    SqlOptional  = 0   ## Необязательное
    SqlRequired  = 1   ## Обязательное (NOT NULL без DEFAULT)
    SqlUnknown   = 2   ## Неизвестно

  QSqlNumericalPrecisionPolicy* {.size: sizeof(cint).} = enum
    ## Политика точности чисел при чтении из БД
    LowPrecisionInt32  = 0x01  ## Конвертировать в int32
    LowPrecisionInt64  = 0x02  ## Конвертировать в int64
    LowPrecisionDouble = 0x04  ## Конвертировать в double
    HighPrecision      = 0     ## Сохранять как строку (максимальная точность)

  QSqlErrorType* {.size: sizeof(cint).} = enum
    ## Тип ошибки QSqlError
    SqlNoError           = 0  ## Ошибок нет
    SqlConnectionError   = 1  ## Ошибка соединения
    SqlStatementError    = 2  ## Ошибка SQL-запроса
    SqlTransactionError  = 3  ## Ошибка транзакции
    SqlUnknownError      = 4  ## Неизвестная ошибка

# ═══════════════════════════════════════════════════════════════════════════════
# § 2. Opaque типы
# ═══════════════════════════════════════════════════════════════════════════════

type
  QSqlDatabase*    {.importcpp: "QSqlDatabase",    header: "<QSqlDatabase>".}    = object
  QSqlQuery*       {.importcpp: "QSqlQuery",        header: "<QSqlQuery>".}       = object
  QSqlRecord*      {.importcpp: "QSqlRecord",       header: "<QSqlRecord>".}      = object
  QSqlField*       {.importcpp: "QSqlField",        header: "<QSqlField>".}       = object
  QSqlError*       {.importcpp: "QSqlError",        header: "<QSqlError>".}       = object
  QSqlIndex*       {.importcpp: "QSqlIndex",        header: "<QSqlIndex>".}       = object
  QSqlDriver*      {.importcpp: "QSqlDriver",       header: "<QSqlDriver>".}      = object
  QSqlResult*      {.importcpp: "QSqlResult",       header: "<QSqlResult>".}      = object
  QSqlRelation*    {.importcpp: "QSqlRelation",     header: "<QSqlRelation>".}    = object
  QSqlTableModel*  {.importcpp: "QSqlTableModel",   header: "<QSqlTableModel>".}  = object
  QSqlQueryModel*  {.importcpp: "QSqlQueryModel",   header: "<QSqlQueryModel>".}  = object
  QSqlRelationalTableModel* {.importcpp: "QSqlRelationalTableModel",
                              header: "<QSqlRelationalTableModel>".} = object

# Удобные псевдонимы
type
  SqlDb*    = ptr QSqlDatabase
  SqlQ*     = ptr QSqlQuery
  SqlRec*   = ptr QSqlRecord
  SqlFld*   = ptr QSqlField
  SqlErr*   = ptr QSqlError
  SqlIdx*   = ptr QSqlIndex
  SqlDrv*   = ptr QSqlDriver
  SqlTbl*   = ptr QSqlTableModel
  SqlQM*    = ptr QSqlQueryModel
  SqlRTbl*  = ptr QSqlRelationalTableModel

# ═══════════════════════════════════════════════════════════════════════════════
# § 3. QSqlDatabase — управление соединениями
# ═══════════════════════════════════════════════════════════════════════════════

# ── Создание и удаление соединений ────────────────────────────────────────────

proc sqlAddDatabase*(driver: string,
                     connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Зарегистрировать новое соединение с указанным драйвером.
  ## Примеры driver: "QSQLITE", "QPSQL", "QMYSQL", "QODBC"
  let cd = driver.cstring; let cn = connName.cstring
  {.emit: """
    `result` = QSqlDatabase::addDatabase(
      QString::fromUtf8(`cd`),
      QString::fromUtf8(`cn`));
  """.}

proc sqlDatabase*(connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Получить существующее соединение по имени.
  let cn = connName.cstring
  {.emit: "`result` = QSqlDatabase::database(QString::fromUtf8(`cn`), false);".}

proc sqlDatabaseOpen*(connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Получить существующее соединение и открыть его, если ещё не открыто.
  let cn = connName.cstring
  {.emit: "`result` = QSqlDatabase::database(QString::fromUtf8(`cn`), true);".}

proc sqlRemoveDatabase*(connName: string) =
  ## Удалить соединение из реестра Qt.
  ## ВАЖНО: вызывать только после уничтожения всех QSqlQuery для этого соединения.
  let cn = connName.cstring
  {.emit: "QSqlDatabase::removeDatabase(QString::fromUtf8(`cn`));".}

proc sqlContainsDatabase*(connName: string): bool =
  ## Проверить, зарегистрировано ли соединение с данным именем.
  let cn = connName.cstring; var r: cint
  {.emit: "`r` = QSqlDatabase::contains(QString::fromUtf8(`cn`)) ? 1 : 0;".}
  result = r == 1

proc sqlConnectionNames*(): seq[string] =
  ## Список всех зарегистрированных имён соединений.
  var n: cint
  {.emit: "QStringList _scn = QSqlDatabase::connectionNames(); `n` = _scn.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _scnb = _scn.at(`ii`).toUtf8(); `p` = _scnb.constData();".}
    result[i] = $p

proc sqlDrivers*(): seq[string] =
  ## Список доступных драйверов.
  var n: cint
  {.emit: "QStringList _sdr = QSqlDatabase::drivers(); `n` = _sdr.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _sdrb = _sdr.at(`ii`).toUtf8(); `p` = _sdrb.constData();".}
    result[i] = $p

proc sqlIsDriverAvailable*(driver: string): bool =
  ## Проверить, доступен ли указанный драйвер.
  let cd = driver.cstring; var r: cint
  {.emit: "`r` = QSqlDatabase::isDriverAvailable(QString::fromUtf8(`cd`)) ? 1 : 0;".}
  result = r == 1

# ── Параметры соединения ──────────────────────────────────────────────────────

proc setHostName*(db: var QSqlDatabase, host: string) =
  let cs = host.cstring
  {.emit: "`db`.setHostName(QString::fromUtf8(`cs`));".}

proc setPort*(db: var QSqlDatabase, port: int) =
  let cp = port.cint
  {.emit: "`db`.setPort(`cp`);".}

proc setDatabaseName*(db: var QSqlDatabase, name: string) =
  ## Имя файла (SQLite) или имя схемы/базы (PSQL, MySQL).
  let cs = name.cstring
  {.emit: "`db`.setDatabaseName(QString::fromUtf8(`cs`));".}

proc setUserName*(db: var QSqlDatabase, user: string) =
  let cs = user.cstring
  {.emit: "`db`.setUserName(QString::fromUtf8(`cs`));".}

proc setPassword*(db: var QSqlDatabase, pass: string) =
  let cs = pass.cstring
  {.emit: "`db`.setPassword(QString::fromUtf8(`cs`));".}

proc setConnectOptions*(db: var QSqlDatabase, opts: string = "") =
  ## Строка дополнительных параметров соединения.
  ## Примеры: "QSQLITE_BUSY_TIMEOUT=5000", "MYSQL_OPT_RECONNECT=1"
  let cs = opts.cstring
  {.emit: "`db`.setConnectOptions(QString::fromUtf8(`cs`));".}

proc setNumericalPrecisionPolicy*(db: var QSqlDatabase,
                                   policy: QSqlNumericalPrecisionPolicy) =
  let cp = policy.cint
  {.emit: "`db`.setNumericalPrecisionPolicy((QSql::NumericalPrecisionPolicy)`cp`);".}

# ── Чтение параметров ─────────────────────────────────────────────────────────

proc hostName*(db: QSqlDatabase): string =
  var p: cstring
  {.emit: "QByteArray _hb = `db`.hostName().toUtf8(); `p` = _hb.constData();".}
  result = $p

proc port*(db: QSqlDatabase): int =
  var v: cint; {.emit: "`v` = `db`.port();".}; result = v.int

proc databaseName*(db: QSqlDatabase): string =
  var p: cstring
  {.emit: "QByteArray _dnb = `db`.databaseName().toUtf8(); `p` = _dnb.constData();".}
  result = $p

proc userName*(db: QSqlDatabase): string =
  var p: cstring
  {.emit: "QByteArray _unb = `db`.userName().toUtf8(); `p` = _unb.constData();".}
  result = $p

proc driverName*(db: QSqlDatabase): string =
  var p: cstring
  {.emit: "QByteArray _drvb = `db`.driverName().toUtf8(); `p` = _drvb.constData();".}
  result = $p

proc connectionName*(db: QSqlDatabase): string =
  var p: cstring
  {.emit: "QByteArray _conb = `db`.connectionName().toUtf8(); `p` = _conb.constData();".}
  result = $p

proc connectOptions*(db: QSqlDatabase): string =
  var p: cstring
  {.emit: "QByteArray _cob = `db`.connectOptions().toUtf8(); `p` = _cob.constData();".}
  result = $p

# ── Управление соединением ────────────────────────────────────────────────────

proc open*(db: var QSqlDatabase): bool =
  ## Открыть соединение. Возвращает true при успехе.
  var r: cint; {.emit: "`r` = `db`.open() ? 1 : 0;".}; result = r == 1

proc openWithCredentials*(db: var QSqlDatabase, user, pass: string): bool =
  ## Открыть соединение с явными учётными данными.
  let cu = user.cstring; let cp = pass.cstring; var r: cint
  {.emit: "`r` = `db`.open(QString::fromUtf8(`cu`), QString::fromUtf8(`cp`)) ? 1 : 0;".}
  result = r == 1

proc close*(db: var QSqlDatabase) =
  {.emit: "`db`.close();".}

proc isOpen*(db: QSqlDatabase): bool =
  var r: cint; {.emit: "`r` = `db`.isOpen() ? 1 : 0;".}; result = r == 1

proc isOpenError*(db: QSqlDatabase): bool =
  ## True, если последняя попытка открыть завершилась ошибкой.
  var r: cint; {.emit: "`r` = `db`.isOpenError() ? 1 : 0;".}; result = r == 1

proc isValid*(db: QSqlDatabase): bool =
  var r: cint; {.emit: "`r` = `db`.isValid() ? 1 : 0;".}; result = r == 1

proc lastError*(db: QSqlDatabase): QSqlError =
  {.emit: "`result` = `db`.lastError();".}

# ── Транзакции ────────────────────────────────────────────────────────────────

proc transaction*(db: var QSqlDatabase): bool =
  ## Начать транзакцию. False если драйвер не поддерживает.
  var r: cint; {.emit: "`r` = `db`.transaction() ? 1 : 0;".}; result = r == 1

proc commit*(db: var QSqlDatabase): bool =
  ## Зафиксировать транзакцию.
  var r: cint; {.emit: "`r` = `db`.commit() ? 1 : 0;".}; result = r == 1

proc rollback*(db: var QSqlDatabase): bool =
  ## Откатить транзакцию.
  var r: cint; {.emit: "`r` = `db`.rollback() ? 1 : 0;".}; result = r == 1

# ── Интроспекция схемы ────────────────────────────────────────────────────────

proc tables*(db: QSqlDatabase): seq[string] =
  ## Список таблиц в текущей схеме.
  var n: cint
  {.emit: "QStringList _tbl = `db`.tables(); `n` = _tbl.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _tblb = _tbl.at(`ii`).toUtf8(); `p` = _tblb.constData();".}
    result[i] = $p

proc views*(db: QSqlDatabase): seq[string] =
  ## Список представлений (VIEW).
  var n: cint
  {.emit: "QStringList _vl = `db`.tables(QSql::Views); `n` = _vl.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _vlb = _vl.at(`ii`).toUtf8(); `p` = _vlb.constData();".}
    result[i] = $p

proc allTables*(db: QSqlDatabase): seq[string] =
  ## Таблицы + представления + системные таблицы.
  var n: cint
  {.emit: "QStringList _at = `db`.tables(QSql::AllTables); `n` = _at.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let ii = i.cint; var p: cstring
    {.emit: "QByteArray _atb = _at.at(`ii`).toUtf8(); `p` = _atb.constData();".}
    result[i] = $p

proc record*(db: QSqlDatabase, tableName: string): QSqlRecord =
  ## Описание полей таблицы (пустые значения, только метаданные).
  let cs = tableName.cstring
  {.emit: "`result` = `db`.record(QString::fromUtf8(`cs`));".}

proc primaryIndex*(db: QSqlDatabase, tableName: string): QSqlIndex =
  ## Первичный индекс таблицы.
  let cs = tableName.cstring
  {.emit: "`result` = `db`.primaryIndex(QString::fromUtf8(`cs`));".}

proc hasFeature*(db: QSqlDatabase, feature: cint): bool =
  ## Проверить наличие функции у текущего драйвера.
  ## feature: QSqlDriver::DriverFeature (Transactions=0, QuerySize=1, BLOB=2, …)
  var r: cint
  {.emit: "`r` = `db`.driver()->hasFeature((QSqlDriver::DriverFeature)`feature`) ? 1 : 0;".}
  result = r == 1

proc driver*(db: QSqlDatabase): SqlDrv =
  {.emit: "`result` = `db`.driver();".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 4. QSqlError — информация об ошибке
# ═══════════════════════════════════════════════════════════════════════════════

proc isValid*(e: QSqlError): bool =
  var r: cint; {.emit: "`r` = `e`.isValid() ? 1 : 0;".}; result = r == 1

proc errorText*(e: QSqlError): string =
  ## Полный текст ошибки (driverText + databaseText).
  var p: cstring
  {.emit: "QByteArray _eb = `e`.text().toUtf8(); `p` = _eb.constData();".}
  result = $p

proc driverText*(e: QSqlError): string =
  ## Сообщение от драйвера Qt.
  var p: cstring
  {.emit: "QByteArray _edb = `e`.driverText().toUtf8(); `p` = _edb.constData();".}
  result = $p

proc databaseText*(e: QSqlError): string =
  ## Сообщение от сервера БД.
  var p: cstring
  {.emit: "QByteArray _edbb = `e`.databaseText().toUtf8(); `p` = _edbb.constData();".}
  result = $p

proc nativeErrorCode*(e: QSqlError): string =
  ## Код ошибки от сервера БД в виде строки.
  var p: cstring
  {.emit: "QByteArray _enb = `e`.nativeErrorCode().toUtf8(); `p` = _enb.constData();".}
  result = $p

proc errorType*(e: QSqlError): QSqlErrorType =
  var v: cint; {.emit: "`v` = (int)`e`.type();".}
  result = QSqlErrorType(v)

# ═══════════════════════════════════════════════════════════════════════════════
# § 5. QSqlField — описание одного поля
# ═══════════════════════════════════════════════════════════════════════════════

proc newSqlField*(name: string = "", typeName: string = ""): QSqlField =
  let cn = name.cstring; let ct = typeName.cstring
  {.emit: "`result` = QSqlField(QString::fromUtf8(`cn`));".}
  discard typeName  # тип устанавливается через QMetaType в Qt6

proc fieldName*(f: QSqlField): string =
  var p: cstring
  {.emit: "QByteArray _fnb = `f`.name().toUtf8(); `p` = _fnb.constData();".}
  result = $p

proc fieldTableName*(f: QSqlField): string =
  var p: cstring
  {.emit: "QByteArray _ftb = `f`.tableName().toUtf8(); `p` = _ftb.constData();".}
  result = $p

proc fieldValue*(f: QSqlField): QVariant =
  {.emit: "`result` = `f`.value();".}

proc setFieldValue*(f: var QSqlField, v: QVariant) =
  {.emit: "`f`.setValue(`v`);".}

proc fieldDefaultValue*(f: QSqlField): QVariant =
  {.emit: "`result` = `f`.defaultValue();".}

proc isNull*(f: QSqlField): bool =
  var r: cint; {.emit: "`r` = `f`.isNull() ? 1 : 0;".}; result = r == 1

proc isAutoValue*(f: QSqlField): bool =
  ## True если поле автоинкрементное (SERIAL, IDENTITY, AUTOINCREMENT).
  var r: cint; {.emit: "`r` = `f`.isAutoValue() ? 1 : 0;".}; result = r == 1

proc isReadOnly*(f: QSqlField): bool =
  var r: cint; {.emit: "`r` = `f`.isReadOnly() ? 1 : 0;".}; result = r == 1

proc isGenerated*(f: QSqlField): bool =
  ## True если поле включается в INSERT/UPDATE.
  var r: cint; {.emit: "`r` = `f`.isGenerated() ? 1 : 0;".}; result = r == 1

proc isValid*(f: QSqlField): bool =
  var r: cint; {.emit: "`r` = `f`.isValid() ? 1 : 0;".}; result = r == 1

proc fieldLength*(f: QSqlField): int =
  ## Максимальная длина поля (-1 если неизвестна).
  var v: cint; {.emit: "`v` = `f`.length();".}; result = v.int

proc fieldPrecision*(f: QSqlField): int =
  ## Точность числа (знаков после запятой), -1 если неизвестна.
  var v: cint; {.emit: "`v` = `f`.precision();".}; result = v.int

proc fieldTypeName*(f: QSqlField): string =
  ## Имя типа из метаданных QMetaType.
  var p: cstring
  {.emit: "QByteArray _ftyb = `f`.metaType().name(); `p` = _ftyb.constData();".}
  result = $p

proc requiredStatus*(f: QSqlField): QSqlFieldRequired =
  var v: cint
  {.emit: "`v` = (int)`f`.requiredStatus();".}
  result = QSqlFieldRequired(v)

proc clearFieldValue*(f: var QSqlField) =
  {.emit: "`f`.clear();".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 6. QSqlRecord — строка результата
# ═══════════════════════════════════════════════════════════════════════════════

proc newSqlRecord*(): QSqlRecord =
  {.emit: "`result` = QSqlRecord();".}

proc fieldCount*(rec: QSqlRecord): int =
  var v: cint; {.emit: "`v` = `rec`.count();".}; result = v.int

proc isEmpty*(rec: QSqlRecord): bool =
  var r: cint; {.emit: "`r` = `rec`.isEmpty() ? 1 : 0;".}; result = r == 1

proc contains*(rec: QSqlRecord, fieldName: string): bool =
  let cs = fieldName.cstring; var r: cint
  {.emit: "`r` = `rec`.contains(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc indexOf*(rec: QSqlRecord, fieldName: string): int =
  ## Индекс поля по имени, -1 если не найдено.
  let cs = fieldName.cstring; var v: cint
  {.emit: "`v` = `rec`.indexOf(QString::fromUtf8(`cs`));".}
  result = v.int

proc fieldName*(rec: QSqlRecord, idx: int): string =
  let ci = idx.cint; var p: cstring
  {.emit: "QByteArray _rfnb = `rec`.fieldName(`ci`).toUtf8(); `p` = _rfnb.constData();".}
  result = $p

proc field*(rec: QSqlRecord, idx: int): QSqlField =
  let ci = idx.cint
  {.emit: "`result` = `rec`.field(`ci`);".}

proc fieldByName*(rec: QSqlRecord, name: string): QSqlField =
  let cs = name.cstring
  {.emit: "`result` = `rec`.field(QString::fromUtf8(`cs`));".}

proc value*(rec: QSqlRecord, idx: int): QVariant =
  ## Значение поля по индексу.
  let ci = idx.cint
  {.emit: "`result` = `rec`.value(`ci`);".}

proc valueByName*(rec: QSqlRecord, fieldName: string): QVariant =
  ## Значение поля по имени.
  let cs = fieldName.cstring
  {.emit: "`result` = `rec`.value(QString::fromUtf8(`cs`));".}

proc setValue*(rec: var QSqlRecord, idx: int, val: QVariant) =
  let ci = idx.cint
  {.emit: "`rec`.setValue(`ci`, `val`);".}

proc setValueByName*(rec: var QSqlRecord, fieldName: string, val: QVariant) =
  let cs = fieldName.cstring
  {.emit: "`rec`.setValue(QString::fromUtf8(`cs`), `val`);".}

proc isNull*(rec: QSqlRecord, idx: int): bool =
  let ci = idx.cint; var r: cint
  {.emit: "`r` = `rec`.isNull(`ci`) ? 1 : 0;".}; result = r == 1

proc isNullByName*(rec: QSqlRecord, fieldName: string): bool =
  let cs = fieldName.cstring; var r: cint
  {.emit: "`r` = `rec`.isNull(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc setNull*(rec: var QSqlRecord, idx: int) =
  let ci = idx.cint; {.emit: "`rec`.setNull(`ci`);".}

proc setNullByName*(rec: var QSqlRecord, fieldName: string) =
  let cs = fieldName.cstring; {.emit: "`rec`.setNull(QString::fromUtf8(`cs`));".}

proc isGenerated*(rec: QSqlRecord, idx: int): bool =
  let ci = idx.cint; var r: cint
  {.emit: "`r` = `rec`.isGenerated(`ci`) ? 1 : 0;".}; result = r == 1

proc append*(rec: var QSqlRecord, field: QSqlField) =
  {.emit: "`rec`.append(`field`);".}

proc replace*(rec: var QSqlRecord, idx: int, field: QSqlField) =
  let ci = idx.cint; {.emit: "`rec`.replace(`ci`, `field`);".}

proc remove*(rec: var QSqlRecord, idx: int) =
  let ci = idx.cint; {.emit: "`rec`.remove(`ci`);".}

proc clearValues*(rec: var QSqlRecord) =
  ## Обнулить значения всех полей (метаданные сохраняются).
  {.emit: "`rec`.clearValues();".}

proc clear*(rec: var QSqlRecord) =
  ## Удалить все поля.
  {.emit: "`rec`.clear();".}

proc keyValues*(rec: QSqlRecord, keyFields: QSqlRecord): QSqlRecord =
  ## Вернуть запись только с полями из keyFields (для WHERE-условий).
  {.emit: "`result` = `rec`.keyValues(`keyFields`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 7. QSqlQuery — выполнение SQL-запросов
# ═══════════════════════════════════════════════════════════════════════════════

# ── Создание ──────────────────────────────────────────────────────────────────

proc newSqlQuery*(db: QSqlDatabase): ptr QSqlQuery =
  ## Создать запрос для указанного соединения.
  {.emit: "`result` = new QSqlQuery(`db`);".}

proc newSqlQueryDefault*(): ptr QSqlQuery =
  ## Создать запрос для соединения по умолчанию.
  {.emit: "`result` = new QSqlQuery();".}

proc newSqlQueryStr*(sql: string, db: QSqlDatabase): ptr QSqlQuery =
  ## Создать запрос и немедленно выполнить sql.
  let cs = sql.cstring
  {.emit: "`result` = new QSqlQuery(QString::fromUtf8(`cs`), `db`);".}

proc deleteSqlQuery*(q: ptr QSqlQuery) {.importcpp: "delete #".}

# ── Выполнение ────────────────────────────────────────────────────────────────

proc exec*(q: ptr QSqlQuery, sql: string): bool =
  ## Выполнить SQL-строку. Возвращает true при успехе.
  let cs = sql.cstring; var r: cint
  {.emit: "`r` = `q`->exec(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc execBatch*(q: ptr QSqlQuery): bool =
  ## Пакетное выполнение после bindValue (для массивов).
  var r: cint; {.emit: "`r` = `q`->execBatch() ? 1 : 0;".}; result = r == 1

proc prepare*(q: ptr QSqlQuery, sql: string): bool =
  ## Подготовить запрос с параметрами (:name или ?).
  let cs = sql.cstring; var r: cint
  {.emit: "`r` = `q`->prepare(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc execPrepared*(q: ptr QSqlQuery): bool =
  ## Выполнить ранее подготовленный запрос.
  var r: cint; {.emit: "`r` = `q`->exec() ? 1 : 0;".}; result = r == 1

proc finish*(q: ptr QSqlQuery) =
  ## Освободить ресурсы запроса (курсор), сохранив объект.
  {.emit: "`q`->finish();".}

proc clear*(q: ptr QSqlQuery) =
  ## Полностью сбросить запрос.
  {.emit: "`q`->clear();".}

# ── Привязка параметров ───────────────────────────────────────────────────────

proc bindString*(q: ptr QSqlQuery, placeholder: string, val: string) =
  ## Привязать строковый параметр по имени (:name).
  let cp = placeholder.cstring; let cv = val.cstring
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QString::fromUtf8(`cv`));".}

proc bindInt*(q: ptr QSqlQuery, placeholder: string, val: int) =
  let cp = placeholder.cstring; let cv = val.cint
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QVariant(`cv`));".}

proc bindInt64*(q: ptr QSqlQuery, placeholder: string, val: int64) =
  let cp = placeholder.cstring; let cv = val.clonglong
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QVariant((qlonglong)`cv`));".}

proc bindDouble*(q: ptr QSqlQuery, placeholder: string, val: float64) =
  let cp = placeholder.cstring; let cv = val.cdouble
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QVariant(`cv`));".}

proc bindBool*(q: ptr QSqlQuery, placeholder: string, val: bool) =
  let cp = placeholder.cstring; let cv = val.cint
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QVariant(`cv` != 0));".}

proc bindNull*(q: ptr QSqlQuery, placeholder: string) =
  let cp = placeholder.cstring
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QVariant());".}

proc bindBytes*(q: ptr QSqlQuery, placeholder: string,
                data: ptr uint8, len: int) =
  ## Привязать бинарные данные (BLOB).
  let cp = placeholder.cstring; let cl = len.cint
  {.emit: "`q`->bindValue(QString::fromUtf8(`cp`), QVariant(QByteArray((const char*)`data`, `cl`)));".}

# Позиционная привязка (?)
proc bindStringAt*(q: ptr QSqlQuery, pos: int, val: string) =
  let ci = pos.cint; let cv = val.cstring
  {.emit: "`q`->bindValue(`ci`, QString::fromUtf8(`cv`));".}

proc bindIntAt*(q: ptr QSqlQuery, pos: int, val: int) =
  let ci = pos.cint; let cv = val.cint
  {.emit: "`q`->bindValue(`ci`, QVariant(`cv`));".}

proc bindDoubleAt*(q: ptr QSqlQuery, pos: int, val: float64) =
  let ci = pos.cint; let cv = val.cdouble
  {.emit: "`q`->bindValue(`ci`, QVariant(`cv`));".}

proc bindNullAt*(q: ptr QSqlQuery, pos: int) =
  let ci = pos.cint
  {.emit: "`q`->bindValue(`ci`, QVariant());".}

proc boundValue*(q: ptr QSqlQuery, placeholder: string): QVariant =
  let cp = placeholder.cstring
  {.emit: "`result` = `q`->boundValue(QString::fromUtf8(`cp`));".}

# ── Навигация по результату ───────────────────────────────────────────────────

proc next*(q: ptr QSqlQuery): bool =
  ## Перейти к следующей строке. Возвращает false при конце.
  var r: cint; {.emit: "`r` = `q`->next() ? 1 : 0;".}; result = r == 1

proc previous*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->previous() ? 1 : 0;".}; result = r == 1

proc first*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->first() ? 1 : 0;".}; result = r == 1

proc last*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->last() ? 1 : 0;".}; result = r == 1

proc seek*(q: ptr QSqlQuery, idx: int): bool =
  let ci = idx.cint; var r: cint
  {.emit: "`r` = `q`->seek(`ci`) ? 1 : 0;".}; result = r == 1

proc at*(q: ptr QSqlQuery): int =
  ## Текущая позиция строки (0-based), или QSql::BeforeFirstRow / AfterLastRow.
  var v: cint; {.emit: "`v` = `q`->at();".}; result = v.int

proc isValid*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->isValid() ? 1 : 0;".}; result = r == 1

proc isActive*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->isActive() ? 1 : 0;".}; result = r == 1

proc isSelect*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->isSelect() ? 1 : 0;".}; result = r == 1

proc isForwardOnly*(q: ptr QSqlQuery): bool =
  var r: cint; {.emit: "`r` = `q`->isForwardOnly() ? 1 : 0;".}; result = r == 1

proc setForwardOnly*(q: ptr QSqlQuery, fwd: bool) =
  ## Только вперёд — меньше памяти, быстрее для больших результатов.
  let cv = fwd.cint; {.emit: "`q`->setForwardOnly(`cv` != 0);".}

# ── Чтение значений текущей строки ────────────────────────────────────────────

proc value*(q: ptr QSqlQuery, idx: int): QVariant =
  let ci = idx.cint; {.emit: "`result` = `q`->value(`ci`);".}

proc valueByName*(q: ptr QSqlQuery, fieldName: string): QVariant =
  let cs = fieldName.cstring
  {.emit: "`result` = `q`->value(QString::fromUtf8(`cs`));".}

proc stringValue*(q: ptr QSqlQuery, idx: int): string =
  ## Удобная обёртка: значение поля как string.
  let ci = idx.cint; var p: cstring
  {.emit: "QByteArray _svb = `q`->value(`ci`).toString().toUtf8(); `p` = _svb.constData();".}
  result = $p

proc stringValueByName*(q: ptr QSqlQuery, fieldName: string): string =
  let cs = fieldName.cstring; var p: cstring
  {.emit: "QByteArray _svnb = `q`->value(QString::fromUtf8(`cs`)).toString().toUtf8(); `p` = _svnb.constData();".}
  result = $p

proc intValue*(q: ptr QSqlQuery, idx: int): int =
  let ci = idx.cint; var v: cint
  {.emit: "`v` = `q`->value(`ci`).toInt();".}; result = v.int

proc intValueByName*(q: ptr QSqlQuery, fieldName: string): int =
  let cs = fieldName.cstring; var v: cint
  {.emit: "`v` = `q`->value(QString::fromUtf8(`cs`)).toInt();".}; result = v.int

proc int64Value*(q: ptr QSqlQuery, idx: int): int64 =
  let ci = idx.cint; var v: clonglong
  {.emit: "`v` = `q`->value(`ci`).toLongLong();".}; result = v.int64

proc int64ValueByName*(q: ptr QSqlQuery, fieldName: string): int64 =
  let cs = fieldName.cstring; var v: clonglong
  {.emit: "`v` = `q`->value(QString::fromUtf8(`cs`)).toLongLong();".}; result = v.int64

proc doubleValue*(q: ptr QSqlQuery, idx: int): float64 =
  let ci = idx.cint; var v: cdouble
  {.emit: "`v` = `q`->value(`ci`).toDouble();".}; result = v.float64

proc doubleValueByName*(q: ptr QSqlQuery, fieldName: string): float64 =
  let cs = fieldName.cstring; var v: cdouble
  {.emit: "`v` = `q`->value(QString::fromUtf8(`cs`)).toDouble();".}; result = v.float64

proc boolValue*(q: ptr QSqlQuery, idx: int): bool =
  let ci = idx.cint; var v: cint
  {.emit: "`v` = `q`->value(`ci`).toBool() ? 1 : 0;".}; result = v == 1

proc boolValueByName*(q: ptr QSqlQuery, fieldName: string): bool =
  let cs = fieldName.cstring; var v: cint
  {.emit: "`v` = `q`->value(QString::fromUtf8(`cs`)).toBool() ? 1 : 0;".}; result = v == 1

proc isNullValue*(q: ptr QSqlQuery, idx: int): bool =
  let ci = idx.cint; var v: cint
  {.emit: "`v` = `q`->value(`ci`).isNull() ? 1 : 0;".}; result = v == 1

proc isNullValueByName*(q: ptr QSqlQuery, fieldName: string): bool =
  let cs = fieldName.cstring; var v: cint
  {.emit: "`v` = `q`->value(QString::fromUtf8(`cs`)).isNull() ? 1 : 0;".}; result = v == 1

# ── Метаданные результата ─────────────────────────────────────────────────────

proc numRowsAffected*(q: ptr QSqlQuery): int =
  ## Число затронутых строк после INSERT/UPDATE/DELETE.
  var v: cint; {.emit: "`v` = `q`->numRowsAffected();".}; result = v.int

proc size*(q: ptr QSqlQuery): int =
  ## Число строк результата SELECT (-1 если драйвер не поддерживает QuerySize).
  var v: cint; {.emit: "`v` = `q`->size();".}; result = v.int

proc lastInsertId*(q: ptr QSqlQuery): QVariant =
  ## Последний автогенерированный ключ после INSERT.
  {.emit: "`result` = `q`->lastInsertId();".}

proc lastInsertIdInt*(q: ptr QSqlQuery): int64 =
  ## Последний автогенерированный ключ как int64.
  var v: clonglong
  {.emit: "`v` = `q`->lastInsertId().toLongLong();".}
  result = v.int64

proc lastQuery*(q: ptr QSqlQuery): string =
  ## Последний выполненный SQL.
  var p: cstring
  {.emit: "QByteArray _lqb = `q`->lastQuery().toUtf8(); `p` = _lqb.constData();".}
  result = $p

proc executedQuery*(q: ptr QSqlQuery): string =
  ## Реально выполненный SQL после замены параметров (если драйвер поддерживает).
  var p: cstring
  {.emit: "QByteArray _eqb = `q`->executedQuery().toUtf8(); `p` = _eqb.constData();".}
  result = $p

proc lastError*(q: ptr QSqlQuery): QSqlError =
  {.emit: "`result` = `q`->lastError();".}

proc record*(q: ptr QSqlQuery): QSqlRecord =
  ## Описание полей текущей строки.
  {.emit: "`result` = `q`->record();".}

proc setNumericalPrecisionPolicy*(q: ptr QSqlQuery,
                                   policy: QSqlNumericalPrecisionPolicy) =
  let cp = policy.cint
  {.emit: "`q`->setNumericalPrecisionPolicy((QSql::NumericalPrecisionPolicy)`cp`);".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 8. QSqlIndex — индекс таблицы
# ═══════════════════════════════════════════════════════════════════════════════

proc indexName*(idx: QSqlIndex): string =
  var p: cstring
  {.emit: "QByteArray _inb = `idx`.name().toUtf8(); `p` = _inb.constData();".}
  result = $p

proc indexCursorName*(idx: QSqlIndex): string =
  var p: cstring
  {.emit: "QByteArray _icnb = `idx`.cursorName().toUtf8(); `p` = _icnb.constData();".}
  result = $p

proc indexFieldCount*(idx: QSqlIndex): int =
  var v: cint; {.emit: "`v` = `idx`.count();".}; result = v.int

proc indexFieldName*(idx: QSqlIndex, i: int): string =
  let ci = i.cint; var p: cstring
  {.emit: "QByteArray _ifnb = `idx`.fieldName(`ci`).toUtf8(); `p` = _ifnb.constData();".}
  result = $p

proc isDescending*(idx: QSqlIndex, i: int): bool =
  let ci = i.cint; var r: cint
  {.emit: "`r` = `idx`.isDescending(`ci`) ? 1 : 0;".}; result = r == 1

proc isValid*(idx: QSqlIndex): bool =
  var r: cint; {.emit: "`r` = !`idx`.isEmpty() ? 1 : 0;".}; result = r == 1

# ═══════════════════════════════════════════════════════════════════════════════
# § 9. QSqlDriver — низкоуровневый доступ к драйверу
# ═══════════════════════════════════════════════════════════════════════════════

proc driverIsOpen*(d: SqlDrv): bool =
  var r: cint; {.emit: "`r` = `d`->isOpen() ? 1 : 0;".}; result = r == 1

proc driverIsOpenError*(d: SqlDrv): bool =
  var r: cint; {.emit: "`r` = `d`->isOpenError() ? 1 : 0;".}; result = r == 1

proc driverLastError*(d: SqlDrv): QSqlError =
  {.emit: "`result` = `d`->lastError();".}

proc driverEscapeIdentifier*(d: SqlDrv, identifier: string): string =
  ## Экранировать имя таблицы/поля согласно диалекту БД.
  let cs = identifier.cstring; var p: cstring
  {.emit: """
    QByteArray _deb = `d`->escapeIdentifier(
      QString::fromUtf8(`cs`),
      QSqlDriver::TableName).toUtf8();
    `p` = _deb.constData();
  """.}
  result = $p

proc driverEscapeFieldName*(d: SqlDrv, fieldName: string): string =
  let cs = fieldName.cstring; var p: cstring
  {.emit: """
    QByteArray _defb = `d`->escapeIdentifier(
      QString::fromUtf8(`cs`),
      QSqlDriver::FieldName).toUtf8();
    `p` = _defb.constData();
  """.}
  result = $p

proc driverSqlStatement*(d: SqlDrv, stmtType: cint,
                          tableName: string, rec: QSqlRecord,
                          preparedStatement: bool): string =
  ## Сгенерировать SQL-строку для заданного типа операции.
  ## stmtType: QSqlDriver::SelectStatement=0, InsertStatement=1,
  ##           UpdateStatement=2, DeleteStatement=3
  let ct = tableName.cstring; let cp = preparedStatement.cint; var p: cstring
  {.emit: """
    QByteArray _ssb = `d`->sqlStatement(
      (QSqlDriver::StatementType)`stmtType`,
      QString::fromUtf8(`ct`), `rec`, `cp` != 0).toUtf8();
    `p` = _ssb.constData();
  """.}
  result = $p

proc driverFormatValue*(d: SqlDrv, field: QSqlField): string =
  ## Форматировать значение поля в строку для SQL (с кавычками/экранированием).
  var p: cstring
  {.emit: "QByteArray _fvb = `d`->formatValue(`field`).toUtf8(); `p` = _fvb.constData();".}
  result = $p

proc driverHasFeature*(d: SqlDrv, feature: cint): bool =
  var r: cint
  {.emit: "`r` = `d`->hasFeature((QSqlDriver::DriverFeature)`feature`) ? 1 : 0;".}
  result = r == 1

# Константы QSqlDriver::DriverFeature
const
  SqlFeatTransactions*  = 0  ## Транзакции
  SqlFeatQuerySize*     = 1  ## Размер результата SELECT
  SqlFeatBLOB*          = 2  ## Бинарные объекты
  SqlFeatUnicode*       = 3  ## Unicode-имена полей/таблиц
  SqlFeatPreparedQueries* = 4  ## Подготовленные запросы
  SqlFeatNamedPlaceholders* = 5  ## Именованные параметры (:name)
  SqlFeatPositionalPlaceholders* = 6  ## Позиционные параметры (?)
  SqlFeatLastInsertId*  = 7  ## Последний вставленный ключ
  SqlFeatBatchOperations* = 8  ## Пакетные операции
  SqlFeatSimpleLocking* = 9  ## Простая блокировка
  SqlFeatLowPrecisionNumbers* = 10  ## Числа пониженной точности
  SqlFeatEventNotifications* = 11  ## Уведомления от сервера
  SqlFeatFinishQuery*   = 12  ## Метод finish()
  SqlFeatMultipleResultSets* = 13  ## Несколько ResultSet
  SqlFeatCancelQuery*   = 14  ## Отмена выполняемого запроса

# ═══════════════════════════════════════════════════════════════════════════════
# § 10. QSqlRelation — описание внешнего ключа
# ═══════════════════════════════════════════════════════════════════════════════

proc newSqlRelation*(tableName, indexCol, displayCol: string): QSqlRelation =
  let ct = tableName.cstring
  let ci = indexCol.cstring
  let cd = displayCol.cstring
  {.emit: """
    `result` = QSqlRelation(
      QString::fromUtf8(`ct`),
      QString::fromUtf8(`ci`),
      QString::fromUtf8(`cd`));
  """.}

proc relationTableName*(r: QSqlRelation): string =
  var p: cstring
  {.emit: "QByteArray _rtnb = `r`.tableName().toUtf8(); `p` = _rtnb.constData();".}
  result = $p

proc relationIndexColumn*(r: QSqlRelation): string =
  var p: cstring
  {.emit: "QByteArray _ricb = `r`.indexColumn().toUtf8(); `p` = _ricb.constData();".}
  result = $p

proc relationDisplayColumn*(r: QSqlRelation): string =
  var p: cstring
  {.emit: "QByteArray _rdcb = `r`.displayColumn().toUtf8(); `p` = _rdcb.constData();".}
  result = $p

proc isValid*(r: QSqlRelation): bool =
  var v: cint; {.emit: "`v` = `r`.isValid() ? 1 : 0;".}; result = v == 1

# ═══════════════════════════════════════════════════════════════════════════════
# § 11. QSqlQueryModel — модель для SELECT-запроса (только чтение)
# ═══════════════════════════════════════════════════════════════════════════════

proc newSqlQueryModel*(parent: Obj = nil): SqlQM =
  {.emit: "`result` = new QSqlQueryModel(`parent`);".}

proc setQuery*(m: SqlQM, sql: string, db: QSqlDatabase) =
  let cs = sql.cstring
  {.emit: "`m`->setQuery(QString::fromUtf8(`cs`), `db`);".}

proc setQueryDefault*(m: SqlQM, sql: string) =
  let cs = sql.cstring
  {.emit: "`m`->setQuery(QString::fromUtf8(`cs`));".}

proc rowCount*(m: SqlQM): int =
  var v: cint; {.emit: "`v` = `m`->rowCount();".}; result = v.int

proc columnCount*(m: SqlQM): int =
  var v: cint; {.emit: "`v` = `m`->columnCount();".}; result = v.int

proc lastError*(m: SqlQM): QSqlError =
  {.emit: "`result` = `m`->lastError();".}

proc record*(m: SqlQM, row: int): QSqlRecord =
  let cr = row.cint; {.emit: "`result` = `m`->record(`cr`);".}

proc headerData*(m: SqlQM, col: int): string =
  ## Заголовок столбца (имя поля).
  let cc = col.cint; var p: cstring
  {.emit: """
    QByteArray _hdb = `m`->headerData(`cc`, Qt::Horizontal).toString().toUtf8();
    `p` = _hdb.constData();
  """.}
  result = $p

proc setHeaderData*(m: SqlQM, col: int, title: string) =
  let cc = col.cint; let cs = title.cstring
  {.emit: "`m`->setHeaderData(`cc`, Qt::Horizontal, QString::fromUtf8(`cs`));".}

proc clear*(m: SqlQM) {.importcpp: "#->clear()".}

proc queryModelQuery*(m: SqlQM): string =
  ## Текущий SQL запроса модели.
  var p: cstring
  {.emit: "QByteArray _mqb = `m`->query().lastQuery().toUtf8(); `p` = _mqb.constData();".}
  result = $p

proc deleteSqlQueryModel*(m: SqlQM) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 12. QSqlTableModel — редактируемая модель таблицы
# ═══════════════════════════════════════════════════════════════════════════════

proc newSqlTableModel*(parent: Obj = nil): SqlTbl =
  {.emit: "`result` = new QSqlTableModel(`parent`);".}

proc newSqlTableModelDb*(parent: Obj, db: QSqlDatabase): SqlTbl =
  {.emit: "`result` = new QSqlTableModel(`parent`, `db`);".}

proc setTable*(m: SqlTbl, tableName: string) =
  let cs = tableName.cstring
  {.emit: "`m`->setTable(QString::fromUtf8(`cs`));".}

proc tableName*(m: SqlTbl): string =
  var p: cstring
  {.emit: "QByteArray _tnb = `m`->tableName().toUtf8(); `p` = _tnb.constData();".}
  result = $p

proc select*(m: SqlTbl): bool =
  ## Загрузить данные из таблицы (выполнить SELECT).
  var r: cint; {.emit: "`r` = `m`->select() ? 1 : 0;".}; result = r == 1

proc setFilter*(m: SqlTbl, filter: string) =
  ## Установить WHERE-условие (без слова WHERE).
  ## Пример: "age > 18 AND active = 1"
  let cs = filter.cstring
  {.emit: "`m`->setFilter(QString::fromUtf8(`cs`));".}

proc filter*(m: SqlTbl): string =
  var p: cstring
  {.emit: "QByteArray _flb = `m`->filter().toUtf8(); `p` = _flb.constData();".}
  result = $p

proc setSort*(m: SqlTbl, column: int, order: cint) =
  ## order: Qt::AscendingOrder=0, Qt::DescendingOrder=1
  let cc = column.cint
  {.emit: "`m`->setSort(`cc`, (Qt::SortOrder)`order`);".}

proc setEditStrategy*(m: SqlTbl, strategy: QSqlTableModelEditStrategy) =
  let cs = strategy.cint
  {.emit: "`m`->setEditStrategy((QSqlTableModel::EditStrategy)`cs`);".}

proc editStrategy*(m: SqlTbl): QSqlTableModelEditStrategy =
  var v: cint
  {.emit: "`v` = (int)`m`->editStrategy();".}
  result = QSqlTableModelEditStrategy(v)

proc rowCount*(m: SqlTbl): int =
  var v: cint; {.emit: "`v` = `m`->rowCount();".}; result = v.int

proc columnCount*(m: SqlTbl): int =
  var v: cint; {.emit: "`v` = `m`->columnCount();".}; result = v.int

proc record*(m: SqlTbl): QSqlRecord =
  ## Пустая запись-шаблон для таблицы (метаданные полей).
  {.emit: "`result` = `m`->record();".}

proc recordAt*(m: SqlTbl, row: int): QSqlRecord =
  ## Запись с данными из указанной строки.
  let cr = row.cint; {.emit: "`result` = `m`->record(`cr`);".}

proc setRecord*(m: SqlTbl, row: int, rec: QSqlRecord): bool =
  let cr = row.cint; var r: cint
  {.emit: "`r` = `m`->setRecord(`cr`, `rec`) ? 1 : 0;".}; result = r == 1

proc insertRecord*(m: SqlTbl, row: int, rec: QSqlRecord): bool =
  let cr = row.cint; var r: cint
  {.emit: "`r` = `m`->insertRecord(`cr`, `rec`) ? 1 : 0;".}; result = r == 1

proc removeRow*(m: SqlTbl, row: int): bool =
  let cr = row.cint; var r: cint
  {.emit: "`r` = `m`->removeRow(`cr`) ? 1 : 0;".}; result = r == 1

proc removeRows*(m: SqlTbl, startRow, count: int): bool =
  let cs = startRow.cint; let cc = count.cint; var r: cint
  {.emit: "`r` = `m`->removeRows(`cs`, `cc`) ? 1 : 0;".}; result = r == 1

proc insertRows*(m: SqlTbl, startRow, count: int): bool =
  let cs = startRow.cint; let cc = count.cint; var r: cint
  {.emit: "`r` = `m`->insertRows(`cs`, `cc`) ? 1 : 0;".}; result = r == 1

proc submitAll*(m: SqlTbl): bool =
  ## Записать все изменения в БД (OnManualSubmit).
  var r: cint; {.emit: "`r` = `m`->submitAll() ? 1 : 0;".}; result = r == 1

proc revertAll*(m: SqlTbl) {.importcpp: "#->revertAll()".}

proc revertRow*(m: SqlTbl, row: int) =
  let cr = row.cint; {.emit: "`m`->revertRow(`cr`);".}

proc isDirty*(m: SqlTbl): bool =
  var r: cint; {.emit: "`r` = `m`->isDirty() ? 1 : 0;".}; result = r == 1

proc isDirtyAt*(m: SqlTbl, row: int): bool =
  let cr = row.cint; var r: cint
  {.emit: """
    QModelIndex _idx = `m`->index(`cr`, 0);
    `r` = `m`->isDirty(_idx) ? 1 : 0;
  """.}
  result = r == 1

proc lastError*(m: SqlTbl): QSqlError =
  {.emit: "`result` = `m`->lastError();".}

proc primaryKey*(m: SqlTbl): QSqlIndex =
  {.emit: "`result` = `m`->primaryKey();".}

proc setHeaderData*(m: SqlTbl, col: int, title: string) =
  let cc = col.cint; let cs = title.cstring
  {.emit: "`m`->setHeaderData(`cc`, Qt::Horizontal, QString::fromUtf8(`cs`));".}

proc headerData*(m: SqlTbl, col: int): string =
  let cc = col.cint; var p: cstring
  {.emit: """
    QByteArray _stmhb = `m`->headerData(`cc`, Qt::Horizontal).toString().toUtf8();
    `p` = _stmhb.constData();
  """.}
  result = $p

proc data*(m: SqlTbl, row, col: int): QVariant =
  let cr = row.cint; let cc = col.cint
  {.emit: "QModelIndex _di = `m`->index(`cr`, `cc`); `result` = `m`->data(_di);".}

proc setData*(m: SqlTbl, row, col: int, val: QVariant): bool =
  let cr = row.cint; let cc = col.cint; var r: cint
  {.emit: """
    QModelIndex _sdi = `m`->index(`cr`, `cc`);
    `r` = `m`->setData(_sdi, `val`) ? 1 : 0;
  """.}
  result = r == 1

proc setStringData*(m: SqlTbl, row, col: int, val: string): bool =
  let cr = row.cint; let cc = col.cint; let cs = val.cstring; var r: cint
  {.emit: """
    QModelIndex _ssdi = `m`->index(`cr`, `cc`);
    `r` = `m`->setData(_ssdi, QString::fromUtf8(`cs`)) ? 1 : 0;
  """.}
  result = r == 1

proc setIntData*(m: SqlTbl, row, col: int, val: int): bool =
  let cr = row.cint; let cc = col.cint; let cv = val.cint; var r: cint
  {.emit: """
    QModelIndex _sidi = `m`->index(`cr`, `cc`);
    `r` = `m`->setData(_sidi, QVariant(`cv`)) ? 1 : 0;
  """.}
  result = r == 1

proc deleteSqlTableModel*(m: SqlTbl) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 13. QSqlRelationalTableModel — модель с поддержкой внешних ключей
# ═══════════════════════════════════════════════════════════════════════════════

proc newSqlRelationalTableModel*(parent: Obj = nil): SqlRTbl =
  {.emit: "`result` = new QSqlRelationalTableModel(`parent`);".}

proc newSqlRelationalTableModelDb*(parent: Obj, db: QSqlDatabase): SqlRTbl =
  {.emit: "`result` = new QSqlRelationalTableModel(`parent`, `db`);".}

proc setRelation*(m: SqlRTbl, col: int, rel: QSqlRelation) =
  ## Установить внешний ключ для столбца col.
  let cc = col.cint
  {.emit: "`m`->setRelation(`cc`, `rel`);".}

proc relation*(m: SqlRTbl, col: int): QSqlRelation =
  let cc = col.cint; {.emit: "`result` = `m`->relation(`cc`);".}

proc setTable*(m: SqlRTbl, tableName: string) =
  let cs = tableName.cstring
  {.emit: "`m`->setTable(QString::fromUtf8(`cs`));".}

proc select*(m: SqlRTbl): bool =
  var r: cint; {.emit: "`r` = `m`->select() ? 1 : 0;".}; result = r == 1

proc rowCount*(m: SqlRTbl): int =
  var v: cint; {.emit: "`v` = `m`->rowCount();".}; result = v.int

proc columnCount*(m: SqlRTbl): int =
  var v: cint; {.emit: "`v` = `m`->columnCount();".}; result = v.int

proc setFilter*(m: SqlRTbl, filter: string) =
  let cs = filter.cstring; {.emit: "`m`->setFilter(QString::fromUtf8(`cs`));".}

proc submitAll*(m: SqlRTbl): bool =
  var r: cint; {.emit: "`r` = `m`->submitAll() ? 1 : 0;".}; result = r == 1

proc revertAll*(m: SqlRTbl) {.importcpp: "#->revertAll()".}

proc lastError*(m: SqlRTbl): QSqlError =
  {.emit: "`result` = `m`->lastError();".}

proc setEditStrategy*(m: SqlRTbl, strategy: QSqlTableModelEditStrategy) =
  let cs = strategy.cint
  {.emit: "`m`->setEditStrategy((QSqlTableModel::EditStrategy)`cs`);".}

proc deleteSqlRelationalTableModel*(m: SqlRTbl) {.importcpp: "delete #".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 14. Nim-хелперы — удобные высокоуровневые обёртки
# ═══════════════════════════════════════════════════════════════════════════════

type
  SqlRow* = seq[string]
  ## Одна строка результата как seq[string]

  SqlResultSet* = seq[SqlRow]
  ## Полный результат SELECT как seq[seq[string]]

  SqlNamedRow* = seq[tuple[name: string, value: string]]
  ## Строка с именами полей

proc execQuery*(db: var QSqlDatabase, sql: string): bool =
  ## Выполнить SQL без возврата результата (DDL/DML).
  ## Возвращает true при успехе.
  var q = newSqlQuery(db)
  result = q.exec(sql)
  if not result:
    let err = q.lastError()
    if err.isValid():
      discard  # caller checks result
  q.deleteSqlQuery()

proc execQueryGetError*(db: var QSqlDatabase, sql: string): string =
  ## Выполнить SQL; вернуть "" при успехе или текст ошибки.
  var q = newSqlQuery(db)
  if q.exec(sql):
    result = ""
  else:
    result = q.lastError().errorText()
  q.deleteSqlQuery()

proc fetchAll*(db: var QSqlDatabase, sql: string): SqlResultSet =
  ## Выполнить SELECT и вернуть все строки как seq[seq[string]].
  result = @[]
  var q = newSqlQuery(db)
  q.setForwardOnly(true)
  if not q.exec(sql): return
  let rec = q.record()
  let ncols = rec.fieldCount()
  while q.next():
    var row: SqlRow = newSeq[string](ncols)
    for c in 0 ..< ncols:
      row[c] = q.stringValue(c)
    result.add(row)
  q.deleteSqlQuery()

proc fetchAllNamed*(db: var QSqlDatabase, sql: string): seq[SqlNamedRow] =
  ## Выполнить SELECT и вернуть строки с именами полей.
  result = @[]
  var q = newSqlQuery(db)
  q.setForwardOnly(true)
  if not q.exec(sql): return
  let rec = q.record()
  let ncols = rec.fieldCount()
  var colNames = newSeq[string](ncols)
  for c in 0 ..< ncols:
    colNames[c] = rec.fieldName(c)
  while q.next():
    var row: SqlNamedRow = @[]
    for c in 0 ..< ncols:
      row.add((name: colNames[c], value: q.stringValue(c)))
    result.add(row)
  q.deleteSqlQuery()

proc fetchOne*(db: var QSqlDatabase, sql: string): SqlRow =
  ## Выполнить SELECT и вернуть первую строку (или пустой seq).
  result = @[]
  var q = newSqlQuery(db)
  q.setForwardOnly(true)
  if not q.exec(sql): return
  if not q.next(): return
  let ncols = q.record().fieldCount()
  result = newSeq[string](ncols)
  for c in 0 ..< ncols:
    result[c] = q.stringValue(c)
  q.deleteSqlQuery()

proc fetchScalar*(db: var QSqlDatabase, sql: string): string =
  ## Получить первое поле первой строки как string.
  result = ""
  var q = newSqlQuery(db)
  q.setForwardOnly(true)
  if not q.exec(sql): return
  if not q.next(): return
  result = q.stringValue(0)
  q.deleteSqlQuery()

proc fetchScalarInt*(db: var QSqlDatabase, sql: string): int =
  ## Получить первое поле первой строки как int.
  var q = newSqlQuery(db)
  q.setForwardOnly(true)
  if not q.exec(sql): return 0
  if not q.next(): return 0
  result = q.intValue(0)
  q.deleteSqlQuery()

proc fetchScalarInt64*(db: var QSqlDatabase, sql: string): int64 =
  var q = newSqlQuery(db)
  q.setForwardOnly(true)
  if not q.exec(sql): return 0
  if not q.next(): return 0
  result = q.int64Value(0)
  q.deleteSqlQuery()

proc tableExists*(db: var QSqlDatabase, tableName: string): bool =
  ## Проверить, существует ли таблица в текущей схеме.
  let tbls = db.tables()
  for t in tbls:
    if t == tableName: return true
  return false

proc columnExists*(db: var QSqlDatabase, tableName, colName: string): bool =
  ## Проверить, существует ли столбец в таблице.
  let rec = db.record(tableName)
  result = rec.contains(colName)

proc countRows*(db: var QSqlDatabase, tableName: string): int =
  ## Быстро подсчитать число строк в таблице.
  result = fetchScalarInt(db, "SELECT COUNT(*) FROM " & tableName)

proc withTransaction*(db: var QSqlDatabase,
                      body: proc(db: var QSqlDatabase): bool): bool =
  ## Выполнить body внутри транзакции.
  ## Если body возвращает false или выбрасывает исключение — rollback.
  if not db.transaction(): return false
  try:
    if body(db):
      result = db.commit()
    else:
      discard db.rollback()
      result = false
  except:
    discard db.rollback()
    result = false

proc openSQLite*(path: string,
                 connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Открыть SQLite-базу по пути к файлу. ":memory:" для in-memory БД.
  result = sqlAddDatabase("QSQLITE", connName)
  result.setDatabaseName(path)
  discard result.open()

proc openPostgres*(host: string, port: int,
                   dbName, user, pass: string,
                   connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Открыть соединение с PostgreSQL.
  result = sqlAddDatabase("QPSQL", connName)
  result.setHostName(host)
  result.setPort(port)
  result.setDatabaseName(dbName)
  result.setUserName(user)
  result.setPassword(pass)
  discard result.open()

proc openMySQL*(host: string, port: int,
                dbName, user, pass: string,
                connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Открыть соединение с MySQL/MariaDB.
  result = sqlAddDatabase("QMYSQL", connName)
  result.setHostName(host)
  result.setPort(port)
  result.setDatabaseName(dbName)
  result.setUserName(user)
  result.setPassword(pass)
  discard result.open()

proc openODBC*(dsn, user, pass: string,
               connName: string = "qt_sql_default_connection"): QSqlDatabase =
  ## Открыть соединение через ODBC DSN.
  result = sqlAddDatabase("QODBC", connName)
  result.setDatabaseName(dsn)
  result.setUserName(user)
  result.setPassword(pass)
  discard result.open()

proc listColumns*(db: var QSqlDatabase, tableName: string): seq[string] =
  ## Список имён столбцов таблицы.
  let rec = db.record(tableName)
  result = newSeq[string](rec.fieldCount())
  for i in 0 ..< rec.fieldCount():
    result[i] = rec.fieldName(i)

proc describeTable*(db: var QSqlDatabase, tableName: string): seq[tuple[
    name: string, typeName: string, length: int,
    required: bool, autoVal: bool]] =
  ## Подробное описание столбцов таблицы.
  let rec = db.record(tableName)
  for i in 0 ..< rec.fieldCount():
    let f = rec.field(i)
    result.add((
      name:     f.fieldName(),
      typeName: f.fieldTypeName(),
      length:   f.fieldLength(),
      required: f.requiredStatus() == SqlRequired,
      autoVal:  f.isAutoValue()
    ))

proc execPreparedMulti*(db: var QSqlDatabase, sql: string,
                         rows: seq[seq[string]]): bool =
  ## Пакетная вставка/обновление одним подготовленным запросом.
  ## rows — seq строк, каждая строка — seq значений (по порядку ?-параметров).
  var q = newSqlQuery(db)
  if not q.prepare(sql):
    q.deleteSqlQuery()
    return false
  result = true
  for row in rows:
    for i, val in row:
      q.bindStringAt(i, val)
    if not q.execPrepared():
      result = false
      break
  q.deleteSqlQuery()
