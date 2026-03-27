## nimQtUtils.nim — Вспомогательные типы и конвертации Nim ↔ Qt6
## ============================================================================
## Содержит:
##   § 1.  Базовые opaque типы Qt (QString, QByteArray, QVariant, …)
##   § 2.  Nim-side структуры (NimPoint, NimRect, NimColor, …)
##   § 3.  QString ↔ Nim string (UTF-8, Latin-1, UTF-16, Base64)
##   § 4.  QStringList ↔ seq[string]
##   § 5.  QByteArray ↔ string / seq[byte]
##   § 6.  QVariant ↔ Nim типы
##   § 7.  QColor ↔ NimColor / hex / HSV / HSL / CMYK
##   § 8.  QPoint / QPointF ↔ NimPoint / NimPointF
##   § 9.  QSize / QSizeF ↔ NimSize / NimSizeF
##   § 10. QRect / QRectF ↔ NimRect / NimRectF
##   § 11. QDate / QTime / QDateTime ↔ string / int64
##   § 12. QUrl ↔ string (encode/decode, query)
##   § 13. QUuid ↔ string
##   § 14. QJsonDocument / QJsonObject / QJsonArray / QJsonValue
##   § 15. QList<int/double/string> ↔ seq
##   § 16. Общие утилиты (clamp, format, bool↔cint)
##
## Принципы реализации:
##   - Все функции, возвращающие строки, используют ЛОКАЛЬНЫЕ QByteArray
##     (не static), что обеспечивает thread-safety
##   - Нулевой байт как разделитель в строковых массивах заменён передачей
##     указателей через QByteArray/QStringList без промежуточного буфера
##   - Все API максимально идиоматичны для Nim (перегрузки, result, tuples)
##
## Зависимости: нет (самый нижний уровень после nimQtFFI)
##
## Компиляция:
##   nim cpp --passC:"-std=c++20" app.nim

import strutils

# ── Пути заголовков (Windows/MSYS2 UCRT64) ───────────────────────────────────
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}

# ── Все необходимые заголовки Qt ─────────────────────────────────────────────
{.emit: """
#include <QString>
#include <QStringList>
#include <QByteArray>
#include <QVariant>
#include <QColor>
#include <QPoint>
#include <QPointF>
#include <QSize>
#include <QSizeF>
#include <QRect>
#include <QRectF>
#include <QDate>
#include <QTime>
#include <QDateTime>
#include <QUrl>
#include <QUrlQuery>
#include <QUuid>
#include <QList>
#include <QVector>
#include <QMap>
#include <QHash>
#include <QSet>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QJsonParseError>
#include <QTimeZone>
#include <cstring>
""".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 1. Базовые opaque типы Qt (value-types, хранятся по значению)
# ═══════════════════════════════════════════════════════════════════════════════

type
  ## Строка Qt (UTF-16 внутри, умное копирование COW).
  ## Основной строковый тип Qt6 — используется во всех виджет-API.
  QString*       {.importcpp: "QString",
                   header: "<QString>".}       = object

  ## Список строк Qt (QList<QString>).
  QStringList*   {.importcpp: "QStringList",
                   header: "<QStringList>".}   = object

  ## Массив байтов Qt. Эффективен для бинарных данных и UTF-8.
  QByteArray*    {.importcpp: "QByteArray",
                   header: "<QByteArray>".}    = object

  ## Универсальный тип-значение Qt. Хранит QString, int, double, bool,
  ## QColor, QFont, QDateTime, QList<QVariant> и многое другое.
  QVariant*      {.importcpp: "QVariant",
                   header: "<QVariant>".}      = object

  ## Цвет Qt (RGB + alpha, поддерживает HSV, HSL, CMYK).
  QColor*        {.importcpp: "QColor",
                   header: "<QColor>".}        = object

  ## Точка с целыми координатами.
  QPoint*        {.importcpp: "QPoint",
                   header: "<QPoint>".}        = object

  ## Точка с вещественными координатами (double).
  QPointF*       {.importcpp: "QPointF",
                   header: "<QPointF>".}       = object

  ## Размер с целыми компонентами (ширина × высота).
  QSize*         {.importcpp: "QSize",
                   header: "<QSize>".}         = object

  ## Размер с вещественными компонентами.
  QSizeF*        {.importcpp: "QSizeF",
                   header: "<QSizeF>".}        = object

  ## Прямоугольник с целыми координатами.
  QRect*         {.importcpp: "QRect",
                   header: "<QRect>".}         = object

  ## Прямоугольник с вещественными координатами.
  QRectF*        {.importcpp: "QRectF",
                   header: "<QRectF>".}        = object

  ## Дата (без времени).
  QDate*         {.importcpp: "QDate",
                   header: "<QDate>".}         = object

  ## Время (без даты).
  QTime*         {.importcpp: "QTime",
                   header: "<QTime>".}         = object

  ## Дата и время (с опциональным часовым поясом).
  QDateTime*     {.importcpp: "QDateTime",
                   header: "<QDateTime>".}     = object

  ## URL (веб-адрес, файловый путь, ресурс Qt и т.п.).
  QUrl*          {.importcpp: "QUrl",
                   header: "<QUrl>".}          = object

  ## Universally Unique Identifier (128-bit UUID).
  QUuid*         {.importcpp: "QUuid",
                   header: "<QUuid>".}         = object

  ## JSON-документ (объект или массив верхнего уровня).
  QJsonDocument* {.importcpp: "QJsonDocument",
                   header: "<QJsonDocument>".} = object

  ## JSON-объект (словарь ключ→значение).
  QJsonObject*   {.importcpp: "QJsonObject",
                   header: "<QJsonObject>".}   = object

  ## JSON-массив.
  QJsonArray*    {.importcpp: "QJsonArray",
                   header: "<QJsonArray>".}    = object

  ## JSON-значение (null / bool / double / string / array / object).
  QJsonValue*    {.importcpp: "QJsonValue",
                   header: "<QJsonValue>".}    = object

  ## Часовой пояс Qt.
  QTimeZone*     {.importcpp: "QTimeZone",
                   header: "<QTimeZone>".}     = object

# ═══════════════════════════════════════════════════════════════════════════════
# § 2. Nim-side структуры (легковесные альтернативы Qt value-types)
# ═══════════════════════════════════════════════════════════════════════════════

type
  ## Точка с целыми координатами (аналог QPoint, но на стороне Nim).
  NimPoint*  = tuple[x, y: int]

  ## Точка с вещественными координатами (аналог QPointF).
  NimPointF* = tuple[x, y: float64]

  ## Размер с целыми компонентами.
  NimSize*   = tuple[w, h: int]

  ## Размер с вещественными компонентами.
  NimSizeF*  = tuple[w, h: float64]

  ## Прямоугольник с целыми координатами.
  NimRect*   = tuple[x, y, w, h: int]

  ## Прямоугольник с вещественными координатами.
  NimRectF*  = tuple[x, y, w, h: float64]

  ## Цвет RGBA (каждый канал 0..255).
  NimColor*  = tuple[r, g, b, a: uint8]

  ## Цвет RGBA с вещественными компонентами (0.0..1.0).
  NimColorF* = tuple[r, g, b, a: float64]

  ## Цвет в формате HSV (h: 0..359, s/v: 0..255, a: 0..255).
  NimColorHSV* = tuple[h, s, v, a: int]

  ## Цвет в формате HSL (h: 0..359, s/l: 0..255, a: 0..255).
  NimColorHSL* = tuple[h, s, l, a: int]

# ═══════════════════════════════════════════════════════════════════════════════
# § 3. QString ↔ Nim string
# ═══════════════════════════════════════════════════════════════════════════════
#
# Принцип: используем локальные QByteArray (не static!) для thread-safety.
# static-переменные в emit вызывают гонку данных при многопоточности.

proc toQString*(s: string): QString =
  ## Конвертировать Nim string (UTF-8) в QString.
  ## Это главный способ передавать строки в Qt-API.
  let cs = s.cstring
  {.emit: "`result` = QString::fromUtf8(`cs`);".}

proc toQString*(cs: cstring): QString =
  ## Конвертировать C-строку (UTF-8) в QString.
  {.emit: "`result` = QString::fromUtf8(`cs`);".}

proc toQStringLatin1*(s: string): QString =
  ## Конвертировать Latin-1 строку в QString.
  ## Используйте только если источник данных — Latin-1 (ISO 8859-1).
  let cs = s.cstring
  {.emit: "`result` = QString::fromLatin1(`cs`);".}

proc toQStringUtf16*(data: seq[uint16]): QString =
  ## Конвертировать UTF-16 данные в QString.
  let n = data.len.cint
  if n == 0: return
  let p = cast[ptr uint16](unsafeAddr data[0])
  {.emit: "`result` = QString::fromUtf16((const char16_t*)`p`, `n`);".}

proc nimStr*(q: QString): string =
  ## Конвертировать QString в Nim string (UTF-8).
  ## Thread-safe: использует локальный QByteArray.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _ba = `q`.toUtf8();
    `p` = _ba.constData();
    `n` = _ba.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc nimStrLatin1*(q: QString): string =
  ## Конвертировать QString в Latin-1 строку.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _baL = `q`.toLatin1();
    `p` = _baL.constData();
    `n` = _baL.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc `$`*(q: QString): string = nimStr(q)
  ## Оператор преобразования в строку (for echo, $ и т.п.).

proc qs*(s: string): QString = toQString(s)
  ## Короткий конструктор. Пример: widget.setText(qs("Привет"))

proc qs*(cs: cstring): QString = toQString(cs)
  ## Короткий конструктор из C-строки.

# ── Операции со QString ───────────────────────────────────────────────────────

proc qsLen*(q: QString): int =
  ## Длина строки в символах UTF-16 (не байтах!).
  var n: cint
  {.emit: "`n` = `q`.length();".}
  result = n.int

proc qsIsEmpty*(q: QString): bool =
  ## Проверить, пуста ли строка.
  var r: cint
  {.emit: "`r` = `q`.isEmpty() ? 1 : 0;".}
  result = r == 1

proc qsIsNull*(q: QString): bool =
  ## Проверить, является ли строка null (не то же, что пустая).
  var r: cint
  {.emit: "`r` = `q`.isNull() ? 1 : 0;".}
  result = r == 1

proc qsTrimmed*(q: QString): QString =
  ## Убрать пробелы в начале и конце.
  {.emit: "`result` = `q`.trimmed();".}

proc qsSimplified*(q: QString): QString =
  ## Убрать ведущие/ведомые пробелы и заменить внутренние серии пробелов одним.
  {.emit: "`result` = `q`.simplified();".}

proc qsUpper*(q: QString): QString =
  ## В верхний регистр (с учётом локали).
  {.emit: "`result` = `q`.toUpper();".}

proc qsLower*(q: QString): QString =
  ## В нижний регистр (с учётом локали).
  {.emit: "`result` = `q`.toLower();".}

proc qsContains*(q: QString, sub: QString,
                 caseSensitive: bool = true): bool =
  ## Проверить, содержит ли строка подстроку.
  let cs = caseSensitive.cint
  var r: cint
  {.emit: """
    `r` = `q`.contains(`sub`,
      `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive) ? 1 : 0;
  """.}
  result = r == 1

proc qsContainsStr*(q: QString, sub: string,
                    caseSensitive: bool = true): bool =
  ## Проверить, содержит ли строка подстроку (принимает Nim string).
  qsContains(q, toQString(sub), caseSensitive)

proc qsStartsWith*(q, pre: QString, caseSensitive: bool = true): bool =
  let cs = caseSensitive.cint; var r: cint
  {.emit: "`r` = `q`.startsWith(`pre`, `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive) ? 1 : 0;".}
  result = r == 1

proc qsEndsWith*(q, suf: QString, caseSensitive: bool = true): bool =
  let cs = caseSensitive.cint; var r: cint
  {.emit: "`r` = `q`.endsWith(`suf`, `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive) ? 1 : 0;".}
  result = r == 1

proc qsReplace*(q, before, after: QString): QString =
  ## Заменить все вхождения before на after (не изменяет исходную).
  {.emit: "`result` = QString(`q`).replace(`before`, `after`);".}

proc qsReplaceStr*(q: QString, before, after: string): QString =
  ## Замена с Nim-строками (удобный вариант).
  qsReplace(q, toQString(before), toQString(after))

proc qsSplit*(q, sep: QString, skipEmpty: bool = false): QStringList =
  ## Разбить строку по разделителю.
  let sk = skipEmpty.cint
  {.emit: """
    `result` = `q`.split(`sep`,
      `sk` ? Qt::SkipEmptyParts : Qt::KeepEmptyParts);
  """.}

proc qsSplitStr*(q: QString, sep: string,
                 skipEmpty: bool = false): QStringList =
  qsSplit(q, toQString(sep), skipEmpty)

proc qsJoin*(sl: QStringList, sep: QString): QString =
  ## Объединить список строк разделителем.
  {.emit: "`result` = `sl`.join(`sep`);".}

proc qsJoinStr*(sl: QStringList, sep: string): QString =
  qsJoin(sl, toQString(sep))

proc qsNumber*(n: int64): QString =
  ## Конвертировать целое в QString.
  let v = n.clonglong
  {.emit: "`result` = QString::number((long long)`v`);".}

proc qsNumber*(n: int): QString = qsNumber(n.int64)

proc qsNumberF*(f: float64, format: char = 'g', precision: int = -1): QString =
  ## Конвертировать вещественное в QString.
  ## format: 'e' = экспоненциальный, 'f' = фиксированный, 'g' = короткий
  let pr = precision.cint
  {.emit: "`result` = QString::number(`f`, `format`, `pr`);".}

proc qsToInt*(q: QString, base: int = 10): tuple[ok: bool, val: int64] =
  ## Разобрать QString как целое число.
  let b = base.cint; var ok: cint; var v: clonglong
  {.emit: "bool _qiOk; `v` = `q`.toLongLong(&_qiOk, `b`); `ok` = _qiOk ? 1 : 0;".}
  result = (ok: ok == 1, val: v.int64)

proc qsToFloat*(q: QString): tuple[ok: bool, val: float64] =
  ## Разобрать QString как вещественное число.
  var ok: cint; var v: cdouble
  {.emit: "bool _qfOk; `v` = `q`.toDouble(&_qfOk); `ok` = _qfOk ? 1 : 0;".}
  result = (ok: ok == 1, val: v.float64)

proc qsRepeat*(q: QString, n: int): QString =
  ## Повторить строку n раз.
  let ni = n.cint
  {.emit: "`result` = `q`.repeated(`ni`);".}

proc qsIndexOf*(q, sub: QString, from: int = 0,
                caseSensitive: bool = true): int =
  ## Найти первое вхождение sub в q, начиная с позиции from.
  ## Возвращает -1 если не найдено.
  let fi = from.cint; let cs = caseSensitive.cint; var v: cint
  {.emit: "`v` = `q`.indexOf(`sub`, `fi`, `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive);".}
  result = v.int

proc qsLastIndexOf*(q, sub: QString, from: int = -1): int =
  ## Найти последнее вхождение sub в q.
  let fi = from.cint; var v: cint
  {.emit: "`v` = `q`.lastIndexOf(`sub`, `fi`);".}
  result = v.int

proc qsMid*(q: QString, pos: int, len: int = -1): QString =
  ## Подстрока от pos длиной len (-1 = до конца).
  let pi = pos.cint; let li = len.cint
  {.emit: "`result` = `q`.mid(`pi`, `li`);".}

proc qsLeft*(q: QString, n: int): QString =
  ## Первые n символов.
  let ni = n.cint
  {.emit: "`result` = `q`.left(`ni`);".}

proc qsRight*(q: QString, n: int): QString =
  ## Последние n символов.
  let ni = n.cint
  {.emit: "`result` = `q`.right(`ni`);".}

proc qsAt*(q: QString, i: int): char =
  ## Символ на позиции i (как Latin-1 char).
  let ii = i.cint; var c: char
  {.emit: "`c` = `q`.at(`ii`).toLatin1();".}
  result = c

proc qsArgInt*(tmpl: QString, n: int64): QString =
  ## Заменить первый %1 в шаблоне на число.
  let v = n.clonglong
  {.emit: "`result` = `tmpl`.arg((long long)`v`);".}

proc qsArgStr*(tmpl: QString, s: QString): QString =
  ## Заменить первый %1 в шаблоне на строку.
  {.emit: "`result` = `tmpl`.arg(`s`);".}

proc qsArgF*(tmpl: QString, f: float64,
             fieldWidth: int = 0, fmt: char = 'g',
             precision: int = -1): QString =
  ## Заменить первый %1 в шаблоне на вещественное число.
  let fw = fieldWidth.cint; let pr = precision.cint
  {.emit: "`result` = `tmpl`.arg(`f`, `fw`, `fmt`, `pr`);".}

proc qsCompare*(a, b: QString, caseSensitive: bool = true): int =
  ## Лексикографическое сравнение строк.
  ## Возвращает: < 0 если a < b, 0 если равны, > 0 если a > b
  let cs = caseSensitive.cint; var v: cint
  {.emit: "`v` = QString::compare(`a`, `b`, `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive);".}
  result = v.int

proc qsToBase64*(q: QString): string =
  ## Конвертировать строку в Base64-представление (UTF-8 → base64).
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _b64 = `q`.toUtf8().toBase64();
    `p` = _b64.constData();
    `n` = _b64.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc qsFromBase64*(b64: string): QString =
  ## Декодировать Base64 строку обратно в QString.
  let cs = b64.cstring; let n = b64.len.cint
  {.emit: "`result` = QString::fromUtf8(QByteArray::fromBase64(QByteArray(`cs`, `n`)));".}

proc `==`*(a, b: QString): bool =
  ## Сравнение строк на равенство.
  var r: cint
  {.emit: "`r` = (`a` == `b`) ? 1 : 0;".}
  result = r == 1

proc `!=`*(a, b: QString): bool = not (a == b)

proc `&`*(a, b: QString): QString =
  ## Конкатенация строк.
  {.emit: "`result` = `a` + `b`;".}

proc `&`*(a: QString, b: string): QString = a & toQString(b)
proc `&`*(a: string, b: QString): QString = toQString(a) & b

# ═══════════════════════════════════════════════════════════════════════════════
# § 4. QStringList ↔ seq[string]
# ═══════════════════════════════════════════════════════════════════════════════

proc toQStringList*(ss: openArray[string]): QStringList =
  ## Конвертировать seq[string] в QStringList.
  ## Использует нулевой байт как внутренний разделитель для передачи данных.
  if ss.len == 0: return
  var joined = newStringOfCap(ss.len * 32)
  for i, s in ss:
    if i > 0: joined.add('\x00')
    joined.add(s)
  let data = joined.cstring
  let n = ss.len.cint
  {.emit: """
    const char* _qslP = `data`;
    for (int _i = 0; _i < `n`; _i++) {
      `result` << QString::fromUtf8(_qslP);
      _qslP += std::strlen(_qslP) + 1;
    }
  """.}

proc toNimSeq*(sl: QStringList): seq[string] =
  ## Конвертировать QStringList в seq[string].
  ## Thread-safe: каждая строка копируется через локальный QByteArray.
  var n: cint
  {.emit: "`n` = `sl`.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint
    var p: cstring; var len: cint
    {.emit: """
      QByteArray _qslI = `sl`.at(`idx`).toUtf8();
      `p` = _qslI.constData();
      `len` = _qslI.size();
    """.}
    result[i] = newString(len.int)
    if len > 0: copyMem(addr result[i][0], p, len.int)

proc qslAdd*(sl: var QStringList, s: QString) =
  ## Добавить строку в список.
  {.emit: "`sl`.append(`s`);".}

proc qslAdd*(sl: var QStringList, s: string) =
  ## Добавить Nim строку в список.
  let q = toQString(s)
  qslAdd(sl, q)

proc qslSize*(sl: QStringList): int =
  ## Количество элементов.
  var n: cint
  {.emit: "`n` = `sl`.size();".}
  result = n.int

proc qslAt*(sl: QStringList, i: int): QString =
  ## Элемент по индексу.
  let idx = i.cint
  {.emit: "`result` = `sl`.at(`idx`);".}

proc qslAtStr*(sl: QStringList, i: int): string =
  ## Элемент по индексу как Nim string.
  nimStr(qslAt(sl, i))

proc qslContains*(sl: QStringList, s: QString,
                  caseSensitive: bool = true): bool =
  ## Проверить наличие строки в списке.
  let cs = caseSensitive.cint; var r: cint
  {.emit: "`r` = `sl`.contains(`s`, `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive) ? 1 : 0;".}
  result = r == 1

proc qslFilter*(sl: QStringList, rx: QString,
                caseSensitive: bool = true): QStringList =
  ## Отфильтровать список по подстроке.
  let cs = caseSensitive.cint
  {.emit: "`result` = `sl`.filter(`rx`, `cs` ? Qt::CaseSensitive : Qt::CaseInsensitive);".}

proc qslSort*(sl: var QStringList,
              caseSensitive: bool = true) =
  ## Сортировать список строк.
  let cs = caseSensitive.cint
  {.emit: "`sl`.sort(`cs` ? Qt::CaseSensitive : Qt::CaseInsensitive);".}

proc qslRemoveDuplicates*(sl: var QStringList): int =
  ## Удалить дубликаты. Возвращает количество удалённых.
  var n: cint
  {.emit: "`n` = `sl`.removeDuplicates();".}
  result = n.int

proc qslJoin*(sl: QStringList, sep: string): string =
  ## Объединить список в строку (Nim-результат).
  let q = toQString(sep)
  var r: QString
  {.emit: "`r` = `sl`.join(`q`);".}
  result = nimStr(r)

proc qslRemoveAt*(sl: var QStringList, i: int) =
  ## Удалить элемент по индексу.
  let idx = i.cint
  {.emit: "`sl`.removeAt(`idx`);".}

proc qslIndexOf*(sl: QStringList, s: QString): int =
  ## Найти индекс строки (-1 если не найдено).
  var v: cint
  {.emit: "`v` = `sl`.indexOf(`s`);".}
  result = v.int

# ═══════════════════════════════════════════════════════════════════════════════
# § 5. QByteArray ↔ string / seq[byte]
# ═══════════════════════════════════════════════════════════════════════════════

proc toQByteArray*(s: string): QByteArray =
  ## Конвертировать Nim string в QByteArray (побайтово, без перекодировки).
  let cs = s.cstring; let n = s.len.cint
  {.emit: "`result` = QByteArray(`cs`, `n`);".}

proc toQByteArray*(data: openArray[byte]): QByteArray =
  ## Конвертировать seq[byte] / array[byte] в QByteArray.
  if data.len == 0: return
  let p = cast[cstring](unsafeAddr data[0])
  let n = data.len.cint
  {.emit: "`result` = QByteArray(`p`, `n`);".}

proc toNimString*(ba: QByteArray): string =
  ## Конвертировать QByteArray в Nim string (побайтово).
  ## Thread-safe: данные копируются немедленно.
  var p: cstring; var n: cint
  {.emit: "`p` = `ba`.constData(); `n` = `ba`.size();".}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc toNimBytes*(ba: QByteArray): seq[byte] =
  ## Конвертировать QByteArray в seq[byte].
  var p: cstring; var n: cint
  {.emit: "`p` = `ba`.constData(); `n` = `ba`.size();".}
  result = newSeq[byte](n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc qbaSize*(ba: QByteArray): int =
  var n: cint
  {.emit: "`n` = `ba`.size();".}
  result = n.int

proc qbaIsEmpty*(ba: QByteArray): bool =
  var r: cint
  {.emit: "`r` = `ba`.isEmpty() ? 1 : 0;".}
  result = r == 1

proc qbaAppend*(ba: var QByteArray, other: QByteArray) =
  {.emit: "`ba`.append(`other`);".}

proc qbaPrepend*(ba: var QByteArray, other: QByteArray) =
  {.emit: "`ba`.prepend(`other`);".}

proc qbaToBase64*(ba: QByteArray): string =
  ## Кодировать в Base64.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _b64 = `ba`.toBase64();
    `p` = _b64.constData(); `n` = _b64.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc qbaFromBase64*(b64: string): QByteArray =
  ## Декодировать из Base64.
  let cs = b64.cstring; let n = b64.len.cint
  {.emit: "`result` = QByteArray::fromBase64(QByteArray(`cs`, `n`));".}

proc qbaToHex*(ba: QByteArray, separator: char = '\0'): string =
  ## Конвертировать в шестнадцатеричную строку.
  ## separator = ':' для формата "aa:bb:cc"
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _hex;
    if (`separator` != '\0') _hex = `ba`.toHex(`separator`);
    else _hex = `ba`.toHex();
    `p` = _hex.constData(); `n` = _hex.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc qbaFromHex*(hex: string): QByteArray =
  ## Декодировать из шестнадцатеричной строки.
  let cs = hex.cstring; let n = hex.len.cint
  {.emit: "`result` = QByteArray::fromHex(QByteArray(`cs`, `n`));".}

proc qbaCompressed*(ba: QByteArray, level: int = -1): QByteArray =
  ## Сжать данные (zlib).
  let l = level.cint
  {.emit: "`result` = qCompress(`ba`, `l`);".}

proc qbaUncompressed*(ba: QByteArray): QByteArray =
  ## Распаковать данные (zlib).
  {.emit: "`result` = qUncompress(`ba`);".}

proc qbaMid*(ba: QByteArray, pos: int, len: int = -1): QByteArray =
  ## Подмассив начиная с pos длиной len.
  let pi = pos.cint; let li = len.cint
  {.emit: "`result` = `ba`.mid(`pi`, `li`);".}

proc qbaTrimmed*(ba: QByteArray): QByteArray =
  ## Убрать пробелы в начале и конце.
  {.emit: "`result` = `ba`.trimmed();".}

proc qbaAt*(ba: QByteArray, i: int): byte =
  ## Байт по индексу.
  let ii = i.cint; var b: cuchar
  {.emit: "`b` = (unsigned char)`ba`.at(`ii`);".}
  result = b.byte

proc qbaIndexOf*(ba: QByteArray, needle: string): int =
  ## Найти подстроку.
  let cs = needle.cstring; let n = needle.len.cint; var v: cint
  {.emit: "`v` = `ba`.indexOf(QByteArray(`cs`, `n`));".}
  result = v.int

# ═══════════════════════════════════════════════════════════════════════════════
# § 6. QVariant ↔ Nim типы
# ═══════════════════════════════════════════════════════════════════════════════

proc varFromInt*(n: int64): QVariant =
  ## Создать QVariant из int64.
  let v = n.clonglong
  {.emit: "`result` = QVariant((long long)`v`);".}

proc varFromInt*(n: int): QVariant = varFromInt(n.int64)

proc varFromUInt*(n: uint64): QVariant =
  ## Создать QVariant из uint64.
  let v = n.culonglong
  {.emit: "`result` = QVariant((unsigned long long)`v`);".}

proc varFromFloat*(f: float64): QVariant =
  {.emit: "`result` = QVariant(`f`);".}

proc varFromFloat*(f: float32): QVariant =
  {.emit: "`result` = QVariant((float)`f`);".}

proc varFromString*(s: string): QVariant =
  let cs = s.cstring
  {.emit: "`result` = QVariant(QString::fromUtf8(`cs`));".}

proc varFromQString*(q: QString): QVariant =
  {.emit: "`result` = QVariant(`q`);".}

proc varFromBool*(b: bool): QVariant =
  let bv = b.cint
  {.emit: "`result` = QVariant((bool)`bv`);".}

proc varFromBytes*(data: string): QVariant =
  ## Создать QVariant из бинарных данных (QByteArray).
  let cs = data.cstring; let n = data.len.cint
  {.emit: "`result` = QVariant(QByteArray(`cs`, `n`));".}

proc varToInt*(v: QVariant): int64 =
  var r: clonglong
  {.emit: "`r` = `v`.toLongLong();".}
  result = r.int64

proc varToUInt*(v: QVariant): uint64 =
  var r: culonglong
  {.emit: "`r` = `v`.toULongLong();".}
  result = r.uint64

proc varToFloat*(v: QVariant): float64 =
  var r: cdouble
  {.emit: "`r` = `v`.toDouble();".}
  result = r.float64

proc varToString*(v: QVariant): string =
  ## Thread-safe конвертация через локальный QByteArray.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _qvS = `v`.toString().toUtf8();
    `p` = _qvS.constData(); `n` = _qvS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc varToBool*(v: QVariant): bool =
  var r: cint
  {.emit: "`r` = `v`.toBool() ? 1 : 0;".}
  result = r == 1

proc varIsNull*(v: QVariant): bool =
  var r: cint
  {.emit: "`r` = `v`.isNull() ? 1 : 0;".}
  result = r == 1

proc varIsValid*(v: QVariant): bool =
  var r: cint
  {.emit: "`r` = `v`.isValid() ? 1 : 0;".}
  result = r == 1

proc varTypeName*(v: QVariant): string =
  ## Имя типа, хранимого в QVariant (напр. "QString", "int", "QColor").
  var p: cstring
  {.emit: "`p` = `v`.typeName();".}
  result = if p != nil: $p else: "invalid"

proc varCanConvertToString*(v: QVariant): bool =
  var r: cint
  {.emit: "`r` = `v`.canConvert<QString>() ? 1 : 0;".}
  result = r == 1

# ═══════════════════════════════════════════════════════════════════════════════
# § 7. QColor ↔ NimColor / hex / HSV / HSL / CMYK
# ═══════════════════════════════════════════════════════════════════════════════

proc makeColor*(r, g, b: uint8, a: uint8 = 255): QColor =
  ## Создать цвет из RGBA компонентов (0..255).
  let ri = r.cint; let gi = g.cint; let bi = b.cint; let ai = a.cint
  {.emit: "`result` = QColor(`ri`, `gi`, `bi`, `ai`);".}

proc makeColorI*(r, g, b: int, a: int = 255): QColor =
  ## Создать цвет из RGBA (int версия, удобнее при вычислениях).
  let ri = r.cint; let gi = g.cint; let bi = b.cint; let ai = a.cint
  {.emit: "`result` = QColor(`ri`, `gi`, `bi`, `ai`);".}

proc makeColorF*(r, g, b: float64, a: float64 = 1.0): QColor =
  ## Создать цвет из вещественных RGBA (0.0..1.0).
  {.emit: "`result` = QColor::fromRgbF(`r`, `g`, `b`, `a`);".}

proc colorFromHex*(hex: string): QColor =
  ## Создать цвет из hex-строки.
  ## Форматы: "#rgb", "#rrggbb", "#aarrggbb", "red", "transparent"
  let cs = hex.cstring
  {.emit: "`result` = QColor(QString::fromUtf8(`cs`));".}

proc colorFromHsv*(h, s, v: int, a: int = 255): QColor =
  ## Создать цвет из HSV (h: 0..359, s/v: 0..255, a: 0..255).
  let hi = h.cint; let si = s.cint; let vi = v.cint; let ai = a.cint
  {.emit: "`result` = QColor::fromHsv(`hi`, `si`, `vi`, `ai`);".}

proc colorFromHsvF*(h, s, v: float64, a: float64 = 1.0): QColor =
  ## Создать цвет из HSV с вещественными компонентами (0.0..1.0).
  {.emit: "`result` = QColor::fromHsvF(`h`, `s`, `v`, `a`);".}

proc colorFromHsl*(h, s, l: int, a: int = 255): QColor =
  ## Создать цвет из HSL (h: 0..359, s/l: 0..255, a: 0..255).
  let hi = h.cint; let si = s.cint; let li = l.cint; let ai = a.cint
  {.emit: "`result` = QColor::fromHsl(`hi`, `si`, `li`, `ai`);".}

proc colorFromHslF*(h, s, l: float64, a: float64 = 1.0): QColor =
  ## Создать цвет из HSL с вещественными компонентами.
  {.emit: "`result` = QColor::fromHslF(`h`, `s`, `l`, `a`);".}

proc colorFromCmyk*(c, m, y, k: int, a: int = 255): QColor =
  ## Создать цвет из CMYK (0..255).
  let ci = c.cint; let mi = m.cint; let yi = y.cint
  let ki = k.cint; let ai = a.cint
  {.emit: "`result` = QColor::fromCmyk(`ci`, `mi`, `yi`, `ki`, `ai`);".}

# ── Геттеры компонентов ───────────────────────────────────────────────────────

proc colorRed*(c: QColor): uint8 =
  var v: cint
  {.emit: "`v` = `c`.red();".}
  result = v.uint8

proc colorGreen*(c: QColor): uint8 =
  var v: cint
  {.emit: "`v` = `c`.green();".}
  result = v.uint8

proc colorBlue*(c: QColor): uint8 =
  var v: cint
  {.emit: "`v` = `c`.blue();".}
  result = v.uint8

proc colorAlpha*(c: QColor): uint8 =
  var v: cint
  {.emit: "`v` = `c`.alpha();".}
  result = v.uint8

proc colorRedF*(c: QColor): float64 =
  var v: cdouble
  {.emit: "`v` = `c`.redF();".}
  result = v.float64

proc colorGreenF*(c: QColor): float64 =
  var v: cdouble
  {.emit: "`v` = `c`.greenF();".}
  result = v.float64

proc colorBlueF*(c: QColor): float64 =
  var v: cdouble
  {.emit: "`v` = `c`.blueF();".}
  result = v.float64

proc colorAlphaF*(c: QColor): float64 =
  var v: cdouble
  {.emit: "`v` = `c`.alphaF();".}
  result = v.float64

proc colorHue*(c: QColor): int =
  ## Оттенок HSV (0..359, -1 если ахроматический).
  var v: cint
  {.emit: "`v` = `c`.hsvHue();".}
  result = v.int

proc colorSaturation*(c: QColor): int =
  ## Насыщенность HSV (0..255).
  var v: cint
  {.emit: "`v` = `c`.hsvSaturation();".}
  result = v.int

proc colorValue*(c: QColor): int =
  ## Яркость HSV (0..255).
  var v: cint
  {.emit: "`v` = `c`.value();".}
  result = v.int

proc colorHsl*(c: QColor): NimColorHSL =
  ## Получить цвет как HSL-кортеж.
  var h, s, l, a: cint
  {.emit: "`c`.getHsl(&`h`, &`s`, &`l`, &`a`);".}
  result = (h.int, s.int, l.int, a.int)

proc colorHsv*(c: QColor): NimColorHSV =
  ## Получить цвет как HSV-кортеж.
  var h, s, v, a: cint
  {.emit: "`c`.getHsv(&`h`, &`s`, &`v`, &`a`);".}
  result = (h.int, s.int, v.int, a.int)

# ── Конвертации цвета ─────────────────────────────────────────────────────────

proc colorToHex*(c: QColor): string =
  ## Конвертировать цвет в "#rrggbb".
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _cHex = `c`.name().toUtf8();
    `p` = _cHex.constData(); `n` = _cHex.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc colorToHexA*(c: QColor): string =
  ## Конвертировать цвет в "#aarrggbb" (с альфа-каналом).
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _cHexA = `c`.name(QColor::HexArgb).toUtf8();
    `p` = _cHexA.constData(); `n` = _cHexA.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc colorToTuple*(c: QColor): NimColor =
  ## Конвертировать QColor в NimColor (RGBA uint8).
  result = (r: colorRed(c), g: colorGreen(c),
            b: colorBlue(c), a: colorAlpha(c))

proc colorToTupleF*(c: QColor): NimColorF =
  ## Конвертировать QColor в NimColorF (RGBA float64).
  result = (r: colorRedF(c), g: colorGreenF(c),
            b: colorBlueF(c), a: colorAlphaF(c))

proc colorFromTuple*(nc: NimColor): QColor =
  makeColor(nc.r, nc.g, nc.b, nc.a)

proc colorFromTupleF*(nc: NimColorF): QColor =
  makeColorF(nc.r, nc.g, nc.b, nc.a)

proc isValidColor*(c: QColor): bool =
  ## Проверить допустимость цвета (false для QColor() по умолчанию).
  var r: cint
  {.emit: "`r` = `c`.isValid() ? 1 : 0;".}
  result = r == 1

proc lighter*(c: QColor, factor: int = 150): QColor =
  ## Осветлить цвет. factor=150 означает +50% яркости.
  let f = factor.cint
  {.emit: "`result` = `c`.lighter(`f`);".}

proc darker*(c: QColor, factor: int = 200): QColor =
  ## Затемнить цвет. factor=200 означает -50% яркости.
  let f = factor.cint
  {.emit: "`result` = `c`.darker(`f`);".}

proc colorSetAlpha*(c: QColor, a: int): QColor =
  ## Вернуть цвет с изменённой прозрачностью (0=прозрачный, 255=непрозрачный).
  let ai = a.cint
  {.emit: "`result` = `c`; `result`.setAlpha(`ai`);".}

proc colorSetAlphaF*(c: QColor, a: float64): QColor =
  ## Вернуть цвет с изменённой прозрачностью (0.0..1.0).
  {.emit: "`result` = `c`; `result`.setAlphaF(`a`);".}

proc colorInterpolate*(c1, c2: QColor, t: float64): QColor =
  ## Линейная интерполяция между двумя цветами.
  ## t=0.0 → c1, t=1.0 → c2
  let t1 = max(0.0, min(1.0, t))
  let t0 = 1.0 - t1
  let r = int(colorRed(c1).float64 * t0 + colorRed(c2).float64 * t1)
  let g = int(colorGreen(c1).float64 * t0 + colorGreen(c2).float64 * t1)
  let b = int(colorBlue(c1).float64 * t0 + colorBlue(c2).float64 * t1)
  let a = int(colorAlpha(c1).float64 * t0 + colorAlpha(c2).float64 * t1)
  makeColorI(r, g, b, a)

proc colorToRgb32*(c: QColor): uint32 =
  ## Конвертировать в 32-битное значение 0xAARRGGBB.
  let r = colorRed(c).uint32
  let g = colorGreen(c).uint32
  let b = colorBlue(c).uint32
  let a = colorAlpha(c).uint32
  result = (a shl 24) or (r shl 16) or (g shl 8) or b

proc colorFromRgb32*(rgba: uint32): QColor =
  ## Создать цвет из 32-битного 0xAARRGGBB.
  let a = uint8((rgba shr 24) and 0xFF)
  let r = uint8((rgba shr 16) and 0xFF)
  let g = uint8((rgba shr 8) and 0xFF)
  let b = uint8(rgba and 0xFF)
  makeColor(r, g, b, a)

# ═══════════════════════════════════════════════════════════════════════════════
# § 8. QPoint / QPointF ↔ NimPoint / NimPointF
# ═══════════════════════════════════════════════════════════════════════════════

proc makePoint*(x, y: int): QPoint =
  let xi = x.cint; let yi = y.cint
  {.emit: "`result` = QPoint(`xi`, `yi`);".}

proc makePointF*(x, y: float64): QPointF =
  {.emit: "`result` = QPointF(`x`, `y`);".}

proc pointX*(p: QPoint): int =
  var v: cint
  {.emit: "`v` = `p`.x();".}
  result = v.int

proc pointY*(p: QPoint): int =
  var v: cint
  {.emit: "`v` = `p`.y();".}
  result = v.int

proc pointFX*(p: QPointF): float64 =
  var v: cdouble
  {.emit: "`v` = `p`.x();".}
  result = v.float64

proc pointFY*(p: QPointF): float64 =
  var v: cdouble
  {.emit: "`v` = `p`.y();".}
  result = v.float64

proc pointManhattan*(p: QPoint): int =
  ## Манхэттенское расстояние (|x| + |y|) — быстрее чем Евклидово.
  var v: cint
  {.emit: "`v` = `p`.manhattanLength();".}
  result = v.int

proc pointFLengthSq*(p: QPointF): float64 =
  ## Квадрат расстояния от начала координат (без sqrt).
  let x = pointFX(p); let y = pointFY(p)
  result = x * x + y * y

proc pointFLength*(p: QPointF): float64 =
  ## Расстояние от начала координат.
  import math
  result = sqrt(pointFLengthSq(p))

proc toNimPoint*(p: QPoint): NimPoint   = (x: pointX(p), y: pointY(p))
proc toNimPointF*(p: QPointF): NimPointF = (x: pointFX(p), y: pointFY(p))
proc toQPoint*(p: NimPoint): QPoint     = makePoint(p.x, p.y)
proc toQPointF*(p: NimPointF): QPointF  = makePointF(p.x, p.y)

proc pointFToPoint*(p: QPointF): QPoint =
  ## Округлить до QPoint.
  {.emit: "`result` = `p`.toPoint();".}

proc pointToPointF*(p: QPoint): QPointF =
  {.emit: "`result` = QPointF(`p`);".}

proc pointAdd*(a, b: QPoint): QPoint =
  {.emit: "`result` = `a` + `b`;".}

proc pointSub*(a, b: QPoint): QPoint =
  {.emit: "`result` = `a` - `b`;".}

proc pointFAdd*(a, b: QPointF): QPointF =
  {.emit: "`result` = `a` + `b`;".}

proc pointFSub*(a, b: QPointF): QPointF =
  {.emit: "`result` = `a` - `b`;".}

proc pointFDot*(a, b: QPointF): float64 =
  ## Скалярное произведение двух точек/векторов.
  var v: cdouble
  {.emit: "`v` = QPointF::dotProduct(`a`, `b`);".}
  result = v.float64

# ═══════════════════════════════════════════════════════════════════════════════
# § 9. QSize / QSizeF ↔ NimSize / NimSizeF
# ═══════════════════════════════════════════════════════════════════════════════

proc makeSize*(w, h: int): QSize =
  let wi = w.cint; let hi = h.cint
  {.emit: "`result` = QSize(`wi`, `hi`);".}

proc makeSizeF*(w, h: float64): QSizeF =
  {.emit: "`result` = QSizeF(`w`, `h`);".}

proc sizeW*(s: QSize): int =
  var v: cint
  {.emit: "`v` = `s`.width();".}
  result = v.int

proc sizeH*(s: QSize): int =
  var v: cint
  {.emit: "`v` = `s`.height();".}
  result = v.int

proc sizeFW*(s: QSizeF): float64 =
  var v: cdouble
  {.emit: "`v` = `s`.width();".}
  result = v.float64

proc sizeFH*(s: QSizeF): float64 =
  var v: cdouble
  {.emit: "`v` = `s`.height();".}
  result = v.float64

proc sizeIsEmpty*(s: QSize): bool =
  var r: cint
  {.emit: "`r` = `s`.isEmpty() ? 1 : 0;".}
  result = r == 1

proc sizeIsNull*(s: QSize): bool =
  var r: cint
  {.emit: "`r` = `s`.isNull() ? 1 : 0;".}
  result = r == 1

proc sizeIsValid*(s: QSize): bool =
  var r: cint
  {.emit: "`r` = `s`.isValid() ? 1 : 0;".}
  result = r == 1

proc sizeTransposed*(s: QSize): QSize =
  ## Поменять местами ширину и высоту.
  {.emit: "`result` = `s`.transposed();".}

proc sizeExpanded*(a, b: QSize): QSize =
  ## Наибольшая из ширин и высот (поэлементный максимум).
  {.emit: "`result` = `a`.expandedTo(`b`);".}

proc sizeBounded*(a, b: QSize): QSize =
  ## Наименьшая из ширин и высот (поэлементный минимум).
  {.emit: "`result` = `a`.boundedTo(`b`);".}

proc sizeScaled*(s: QSize, targetW, targetH: int, mode: cint): QSize =
  ## Масштабировать с учётом режима пропорций.
  ## mode: 0=IgnoreAspectRatio, 1=KeepAspectRatio, 2=KeepAspectRatioByExpanding
  let wi = targetW.cint; let hi = targetH.cint
  {.emit: "`result` = `s`.scaled(`wi`, `hi`, (Qt::AspectRatioMode)`mode`);".}

proc toNimSize*(s: QSize): NimSize     = (w: sizeW(s), h: sizeH(s))
proc toNimSizeF*(s: QSizeF): NimSizeF  = (w: sizeFW(s), h: sizeFH(s))
proc toQSize*(s: NimSize): QSize       = makeSize(s.w, s.h)
proc toQSizeF*(s: NimSizeF): QSizeF    = makeSizeF(s.w, s.h)

proc sizeFToSize*(s: QSizeF): QSize =
  {.emit: "`result` = `s`.toSize();".}

proc sizeToSizeF*(s: QSize): QSizeF =
  {.emit: "`result` = QSizeF(`s`);".}

proc sizeArea*(s: QSize): int =
  ## Площадь (w * h).
  sizeW(s) * sizeH(s)

# ═══════════════════════════════════════════════════════════════════════════════
# § 10. QRect / QRectF ↔ NimRect / NimRectF
# ═══════════════════════════════════════════════════════════════════════════════

proc makeRect*(x, y, w, h: int): QRect =
  let xi=x.cint; let yi=y.cint; let wi=w.cint; let hi=h.cint
  {.emit: "`result` = QRect(`xi`, `yi`, `wi`, `hi`);".}

proc makeRectF*(x, y, w, h: float64): QRectF =
  {.emit: "`result` = QRectF(`x`, `y`, `w`, `h`);".}

proc rectX*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.x();".}; result=v.int
proc rectY*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.y();".}; result=v.int
proc rectW*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.width();".}; result=v.int
proc rectH*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.height();".}; result=v.int
proc rectLeft*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.left();".}; result=v.int
proc rectRight*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.right();".}; result=v.int
proc rectTop*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.top();".}; result=v.int
proc rectBottom*(r: QRect): int =
  var v: cint; {.emit: "`v`=`r`.bottom();".}; result=v.int

proc rectIsEmpty*(r: QRect): bool =
  var v: cint; {.emit: "`v`=`r`.isEmpty()?1:0;".}; result=v==1
proc rectIsNull*(r: QRect): bool =
  var v: cint; {.emit: "`v`=`r`.isNull()?1:0;".}; result=v==1
proc rectIsValid*(r: QRect): bool =
  var v: cint; {.emit: "`v`=`r`.isValid()?1:0;".}; result=v==1

proc rectContainsPoint*(r: QRect, x, y: int): bool =
  ## Содержит ли прямоугольник точку (x, y).
  let xi = x.cint; let yi = y.cint; var v: cint
  {.emit: "`v`=`r`.contains(QPoint(`xi`,`yi`))?1:0;".}
  result = v == 1

proc rectContains*(r: QRect, p: QPoint): bool =
  var v: cint; {.emit: "`v`=`r`.contains(`p`)?1:0;".}; result=v==1

proc rectContainsRect*(r, other: QRect): bool =
  var v: cint; {.emit: "`v`=`r`.contains(`other`)?1:0;".}; result=v==1

proc rectIntersects*(a, b: QRect): bool =
  var v: cint; {.emit: "`v`=`a`.intersects(`b`)?1:0;".}; result=v==1

proc rectUnited*(a, b: QRect): QRect =
  ## Наименьший прямоугольник, содержащий оба.
  {.emit: "`result`=`a`.united(`b`);".}

proc rectIntersected*(a, b: QRect): QRect =
  ## Пересечение двух прямоугольников.
  {.emit: "`result`=`a`.intersected(`b`);".}

proc rectCenter*(r: QRect): QPoint =
  {.emit: "`result`=`r`.center();".}

proc rectNormalized*(r: QRect): QRect =
  ## Нормализовать (сделать width и height положительными).
  {.emit: "`result`=`r`.normalized();".}

proc rectAdjusted*(r: QRect, dx1,dy1,dx2,dy2: int): QRect =
  ## Расширить/сжать прямоугольник (возвращает новый).
  let a=dx1.cint; let b=dy1.cint; let c=dx2.cint; let d=dy2.cint
  {.emit: "`result`=`r`.adjusted(`a`,`b`,`c`,`d`);".}

proc rectTranslated*(r: QRect, dx, dy: int): QRect =
  ## Сдвинуть прямоугольник.
  let xi=dx.cint; let yi=dy.cint
  {.emit: "`result`=`r`.translated(`xi`,`yi`);".}

proc rectMovedTo*(r: QRect, x, y: int): QRect =
  ## Переместить в точку (x, y), сохранив размер.
  let xi = x.cint; let yi = y.cint
  {.emit: "`result` = `r`; `result`.moveTopLeft(QPoint(`xi`, `yi`));".}

proc toNimRect*(r: QRect): NimRect =
  (x: rectX(r), y: rectY(r), w: rectW(r), h: rectH(r))
proc toQRect*(r: NimRect): QRect = makeRect(r.x, r.y, r.w, r.h)

# ── QRectF ────────────────────────────────────────────────────────────────────
proc rectFX*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.x();".}; result=v.float64
proc rectFY*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.y();".}; result=v.float64
proc rectFW*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.width();".}; result=v.float64
proc rectFH*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.height();".}; result=v.float64
proc rectFLeft*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.left();".}; result=v.float64
proc rectFRight*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.right();".}; result=v.float64
proc rectFTop*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.top();".}; result=v.float64
proc rectFBottom*(r: QRectF): float64 =
  var v:cdouble; {.emit:"`v`=`r`.bottom();".}; result=v.float64

proc rectFContainsPoint*(r: QRectF, x, y: float64): bool =
  var v:cint; {.emit:"`v`=`r`.contains(QPointF(`x`,`y`))?1:0;".}; result=v==1

proc rectFIntersects*(a, b: QRectF): bool =
  var v:cint; {.emit:"`v`=`a`.intersects(`b`)?1:0;".}; result=v==1

proc rectFUnited*(a, b: QRectF): QRectF =
  {.emit:"`result`=`a`.united(`b`);".}

proc rectFIntersected*(a, b: QRectF): QRectF =
  {.emit:"`result`=`a`.intersected(`b`);".}

proc rectFAdjusted*(r: QRectF, dx1,dy1,dx2,dy2: float64): QRectF =
  {.emit:"`result`=`r`.adjusted(`dx1`,`dy1`,`dx2`,`dy2`);".}

proc toNimRectF*(r: QRectF): NimRectF =
  (x:rectFX(r), y:rectFY(r), w:rectFW(r), h:rectFH(r))
proc toQRectF*(r: NimRectF): QRectF = makeRectF(r.x, r.y, r.w, r.h)

proc rectToRectF*(r: QRect): QRectF =
  {.emit:"`result` = QRectF(`r`);".}
proc rectFToRect*(r: QRectF): QRect =
  {.emit:"`result` = `r`.toRect();".}
proc rectFToAlignedRect*(r: QRectF): QRect =
  {.emit:"`result` = `r`.toAlignedRect();".}

# ═══════════════════════════════════════════════════════════════════════════════
# § 11. QDate / QTime / QDateTime
# ═══════════════════════════════════════════════════════════════════════════════

proc currentDate*(): QDate =
  ## Текущая дата (локальный часовой пояс).
  {.emit: "`result` = QDate::currentDate();".}

proc currentTime*(): QTime =
  ## Текущее время (локальный часовой пояс).
  {.emit: "`result` = QTime::currentTime();".}

proc currentDateTime*(): QDateTime =
  ## Текущие дата и время (локальный часовой пояс).
  {.emit: "`result` = QDateTime::currentDateTime();".}

proc currentDateTimeUtc*(): QDateTime =
  ## Текущие дата и время в UTC.
  {.emit: "`result` = QDateTime::currentDateTimeUtc();".}

proc currentMsecsSinceEpoch*(): int64 =
  ## Миллисекунды с начала Unix epoch (01.01.1970 UTC).
  var v: clonglong
  {.emit: "`v` = QDateTime::currentMSecsSinceEpoch();".}
  result = v.int64

proc currentSecsSinceEpoch*(): int64 =
  ## Секунды с начала Unix epoch.
  var v: clonglong
  {.emit: "`v` = QDateTime::currentSecsSinceEpoch();".}
  result = v.int64

# ── QDate ─────────────────────────────────────────────────────────────────────

proc makeDate*(year, month, day: int): QDate =
  ## Создать QDate из компонентов.
  let y=year.cint; let m=month.cint; let d=day.cint
  {.emit: "`result` = QDate(`y`, `m`, `d`);".}

proc dateToString*(d: QDate, fmt: string = "yyyy-MM-dd"): string =
  ## Форматировать дату. Маски: yyyy/yy, MM/M, dd/d, ddd/dddd (день недели).
  let f = fmt.cstring
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _dS = `d`.toString(QString::fromUtf8(`f`)).toUtf8();
    `p` = _dS.constData(); `n` = _dS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc dateFromString*(s: string, fmt: string = "yyyy-MM-dd"): QDate =
  let cs=s.cstring; let f=fmt.cstring
  {.emit: "`result`=QDate::fromString(QString::fromUtf8(`cs`),QString::fromUtf8(`f`));".}

proc dateYMD*(d: QDate): tuple[y, m, day: int] =
  ## Получить год, месяц, день одним вызовом.
  var y, m, day: cint
  {.emit: "`d`.getDate(&`y`, &`m`, &`day`);".}
  result = (y.int, m.int, day.int)

proc dateYear*(d: QDate): int =
  var v: cint; {.emit:"`v`=`d`.year();".}; result=v.int
proc dateMonth*(d: QDate): int =
  var v: cint; {.emit:"`v`=`d`.month();".}; result=v.int
proc dateDay*(d: QDate): int =
  var v: cint; {.emit:"`v`=`d`.day();".}; result=v.int
proc dateDayOfWeek*(d: QDate): int =
  ## День недели (1=Пн, 7=Вс согласно ISO 8601).
  var v: cint; {.emit:"`v`=`d`.dayOfWeek();".}; result=v.int
proc dateDayOfYear*(d: QDate): int =
  var v: cint; {.emit:"`v`=`d`.dayOfYear();".}; result=v.int
proc dateDaysInMonth*(d: QDate): int =
  var v: cint; {.emit:"`v`=`d`.daysInMonth();".}; result=v.int
proc dateDaysInYear*(d: QDate): int =
  var v: cint; {.emit:"`v`=`d`.daysInYear();".}; result=v.int
proc dateDaysTo*(a, b: QDate): int =
  var v: clonglong; {.emit:"`v`=`a`.daysTo(`b`);".}; result=v.int
proc dateAddDays*(d: QDate, n: int): QDate =
  let ni=n.clonglong; {.emit:"`result`=`d`.addDays(`ni`);".}
proc dateAddMonths*(d: QDate, n: int): QDate =
  let ni=n.cint; {.emit:"`result`=`d`.addMonths(`ni`);".}
proc dateAddYears*(d: QDate, n: int): QDate =
  let ni=n.cint; {.emit:"`result`=`d`.addYears(`ni`);".}
proc dateIsValid*(d: QDate): bool =
  var v: cint; {.emit:"`v`=`d`.isValid()?1:0;".}; result=v==1
proc dateIsLeapYear*(year: int): bool =
  let y=year.cint; var v: cint
  {.emit:"`v`=QDate::isLeapYear(`y`)?1:0;".}; result=v==1

# ── QTime ─────────────────────────────────────────────────────────────────────

proc makeTime*(h, m, s: int, ms: int = 0): QTime =
  ## Создать QTime из компонентов.
  let hi=h.cint; let mi=m.cint; let si=s.cint; let msi=ms.cint
  {.emit: "`result` = QTime(`hi`, `mi`, `si`, `msi`);".}

proc timeToString*(t: QTime, fmt: string = "HH:mm:ss"): string =
  let f = fmt.cstring
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _tS = `t`.toString(QString::fromUtf8(`f`)).toUtf8();
    `p` = _tS.constData(); `n` = _tS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc timeFromString*(s: string, fmt: string = "HH:mm:ss"): QTime =
  let cs=s.cstring; let f=fmt.cstring
  {.emit: "`result`=QTime::fromString(QString::fromUtf8(`cs`),QString::fromUtf8(`f`));".}

proc timeHour*(t: QTime): int =
  var v: cint; {.emit:"`v`=`t`.hour();".}; result=v.int
proc timeMin*(t: QTime): int =
  var v: cint; {.emit:"`v`=`t`.minute();".}; result=v.int
proc timeSec*(t: QTime): int =
  var v: cint; {.emit:"`v`=`t`.second();".}; result=v.int
proc timeMsec*(t: QTime): int =
  var v: cint; {.emit:"`v`=`t`.msec();".}; result=v.int
proc timeMsecDay*(t: QTime): int =
  ## Миллисекунды от начала суток.
  var v: cint; {.emit:"`v`=`t`.msecsSinceStartOfDay();".}; result=v.int
proc timeSecsTo*(a, b: QTime): int =
  var v: cint; {.emit:"`v`=`a`.secsTo(`b`);".}; result=v.int
proc timeMsecsTo*(a, b: QTime): int =
  var v: cint; {.emit:"`v`=`a`.msecsTo(`b`);".}; result=v.int
proc timeAddSecs*(t: QTime, s: int): QTime =
  let si=s.cint; {.emit:"`result`=`t`.addSecs(`si`);".}
proc timeAddMsecs*(t: QTime, ms: int): QTime =
  let msi=ms.cint; {.emit:"`result`=`t`.addMSecs(`msi`);".}
proc timeIsValid*(t: QTime): bool =
  var v: cint; {.emit:"`v`=`t`.isValid()?1:0;".}; result=v==1

# ── QDateTime ─────────────────────────────────────────────────────────────────

proc makeDateTime*(year, month, day: int,
                   h: int = 0, m: int = 0, s: int = 0,
                   ms: int = 0): QDateTime =
  ## Создать QDateTime из компонентов (локальный ч/п).
  let yd=year.cint; let mo=month.cint; let dy=day.cint
  let hi=h.cint; let mi=m.cint; let si=s.cint; let msi=ms.cint
  {.emit: "`result`=QDateTime(QDate(`yd`,`mo`,`dy`), QTime(`hi`,`mi`,`si`,`msi`));".}

proc dateTimeToString*(dt: QDateTime,
                       fmt: string = "yyyy-MM-dd HH:mm:ss"): string =
  let f = fmt.cstring
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _dtS = `dt`.toString(QString::fromUtf8(`f`)).toUtf8();
    `p` = _dtS.constData(); `n` = _dtS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc dateTimeToIso*(dt: QDateTime): string =
  ## Форматировать в ISO 8601 без миллисекунд ("yyyy-MM-ddTHH:mm:ss").
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _dtI = `dt`.toString(Qt::ISODate).toUtf8();
    `p` = _dtI.constData(); `n` = _dtI.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc dateTimeToIsoMs*(dt: QDateTime): string =
  ## Форматировать в ISO 8601 с миллисекундами ("yyyy-MM-ddTHH:mm:ss.zzz").
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _dtIms = `dt`.toString(Qt::ISODateWithMs).toUtf8();
    `p` = _dtIms.constData(); `n` = _dtIms.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc dateTimeFromString*(s: string,
                         fmt: string = "yyyy-MM-dd HH:mm:ss"): QDateTime =
  let cs=s.cstring; let f=fmt.cstring
  {.emit: "`result`=QDateTime::fromString(QString::fromUtf8(`cs`),QString::fromUtf8(`f`));".}

proc dateTimeFromIso*(s: string): QDateTime =
  let cs=s.cstring
  {.emit: "`result`=QDateTime::fromString(QString::fromUtf8(`cs`),Qt::ISODate);".}

proc dateTimeToMsec*(dt: QDateTime): int64 =
  var v: clonglong; {.emit:"`v`=`dt`.toMSecsSinceEpoch();".}; result=v.int64
proc dateTimeFromMsec*(ms: int64): QDateTime =
  let v=ms.clonglong; {.emit:"`result`=QDateTime::fromMSecsSinceEpoch(`v`);".}
proc dateTimeToSec*(dt: QDateTime): int64 =
  var v: clonglong; {.emit:"`v`=`dt`.toSecsSinceEpoch();".}; result=v.int64
proc dateTimeFromSec*(s: int64): QDateTime =
  let v=s.clonglong; {.emit:"`result`=QDateTime::fromSecsSinceEpoch(`v`);".}

proc dateTimeDate*(dt: QDateTime): QDate =
  {.emit:"`result`=`dt`.date();".}
proc dateTimeTime*(dt: QDateTime): QTime =
  {.emit:"`result`=`dt`.time();".}
proc dateTimeAddSecs*(dt: QDateTime, s: int64): QDateTime =
  let v=s.clonglong; {.emit:"`result`=`dt`.addSecs(`v`);".}
proc dateTimeAddMsecs*(dt: QDateTime, ms: int64): QDateTime =
  let v=ms.clonglong; {.emit:"`result`=`dt`.addMSecs(`v`);".}
proc dateTimeAddDays*(dt: QDateTime, d: int64): QDateTime =
  let v=d.clonglong; {.emit:"`result`=`dt`.addDays(`v`);".}
proc dateTimeAddMonths*(dt: QDateTime, m: int): QDateTime =
  let v=m.cint; {.emit:"`result`=`dt`.addMonths(`v`);".}
proc dateTimeAddYears*(dt: QDateTime, y: int): QDateTime =
  let v=y.cint; {.emit:"`result`=`dt`.addYears(`v`);".}
proc dateTimeSecsTo*(a, b: QDateTime): int64 =
  var v: clonglong; {.emit:"`v`=`a`.secsTo(`b`);".}; result=v.int64
proc dateTimeMsecsTo*(a, b: QDateTime): int64 =
  var v: clonglong; {.emit:"`v`=`a`.msecsTo(`b`);".}; result=v.int64
proc dateTimeIsValid*(dt: QDateTime): bool =
  var v: cint; {.emit:"`v`=`dt`.isValid()?1:0;".}; result=v==1
proc dateTimeToUtc*(dt: QDateTime): QDateTime =
  {.emit:"`result`=`dt`.toUTC();".}
proc dateTimeToLocalTime*(dt: QDateTime): QDateTime =
  {.emit:"`result`=`dt`.toLocalTime();".}
proc dateTimeIsNull*(dt: QDateTime): bool =
  var v: cint; {.emit:"`v`=`dt`.isNull()?1:0;".}; result=v==1

proc dateTimeOffset*(dt: QDateTime): int =
  ## Смещение от UTC в секундах.
  var v: cint; {.emit:"`v`=`dt`.offsetFromUtc();".}; result=v.int

proc currentTimeStr*(fmt: string = "dd.MM.yyyy  HH:mm:ss"): string =
  ## Текущее время в виде строки с заданным форматом.
  ## По умолчанию: "24.03.2025  14:30:15"
  dateTimeToString(currentDateTime(), fmt)

# ═══════════════════════════════════════════════════════════════════════════════
# § 12. QUrl ↔ string
# ═══════════════════════════════════════════════════════════════════════════════

proc toQUrl*(s: string): QUrl =
  ## Создать QUrl из строки. Формат определяется автоматически.
  let cs = s.cstring
  {.emit: "`result`=QUrl(QString::fromUtf8(`cs`));".}

proc toQUrlStrict*(s: string): QUrl =
  ## Создать QUrl с строгой проверкой (ошибка если невалидный URL).
  let cs = s.cstring
  {.emit: "`result`=QUrl(QString::fromUtf8(`cs`), QUrl::StrictMode);".}

proc urlFromLocalFile*(path: string): QUrl =
  ## Создать file:// URL из пути к файлу.
  let cs = path.cstring
  {.emit: "`result`=QUrl::fromLocalFile(QString::fromUtf8(`cs`));".}

proc urlToString*(u: QUrl, options: cint = 0): string =
  ## Конвертировать URL в строку. options: QUrl::FormattingOptions.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _uS = `u`.toString((QUrl::FormattingOptions)`options`).toUtf8();
    `p` = _uS.constData(); `n` = _uS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc urlToLocalFile*(u: QUrl): string =
  ## Конвертировать file:// URL в путь к файлу.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _uLF = `u`.toLocalFile().toUtf8();
    `p` = _uLF.constData(); `n` = _uLF.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc urlIsValid*(u: QUrl): bool =
  var r: cint; {.emit:"`r`=`u`.isValid()?1:0;".}; result=r==1
proc urlIsEmpty*(u: QUrl): bool =
  var r: cint; {.emit:"`r`=`u`.isEmpty()?1:0;".}; result=r==1
proc urlIsLocalFile*(u: QUrl): bool =
  var r: cint; {.emit:"`r`=`u`.isLocalFile()?1:0;".}; result=r==1
proc urlIsRelative*(u: QUrl): bool =
  var r: cint; {.emit:"`r`=`u`.isRelative()?1:0;".}; result=r==1

proc urlScheme*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uSch=`u`.scheme().toUtf8(); `p`=_uSch.constData(); `n`=_uSch.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlHost*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uH=`u`.host().toUtf8(); `p`=_uH.constData(); `n`=_uH.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlPath*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uP=`u`.path().toUtf8(); `p`=_uP.constData(); `n`=_uP.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlPort*(u: QUrl, default: int = -1): int =
  let d = default.cint; var v: cint
  {.emit: "`v`=`u`.port(`d`);".}; result=v.int

proc urlQuery*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uQ=`u`.query().toUtf8(); `p`=_uQ.constData(); `n`=_uQ.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlFragment*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uFr=`u`.fragment().toUtf8(); `p`=_uFr.constData(); `n`=_uFr.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlUserName*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uUN=`u`.userName().toUtf8(); `p`=_uUN.constData(); `n`=_uUN.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlPassword*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uPW=`u`.password().toUtf8(); `p`=_uPW.constData(); `n`=_uPW.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlResolved*(base, relative: QUrl): QUrl =
  {.emit: "`result`=`base`.resolved(`relative`);".}

proc urlErrorString*(u: QUrl): string =
  var p: cstring; var n: cint
  {.emit: "QByteArray _uErr=`u`.errorString().toUtf8(); `p`=_uErr.constData(); `n`=_uErr.size();".}
  result = newString(n.int); if n > 0: copyMem(addr result[0], p, n.int)

proc urlEncoded*(s: string): string =
  ## Закодировать строку для использования в URL (percent-encoding).
  ## Пример: "hello world" → "hello%20world"
  let cs = s.cstring
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _uEnc = QUrl::toPercentEncoding(QString::fromUtf8(`cs`));
    `p` = _uEnc.constData(); `n` = _uEnc.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc urlDecoded*(s: string): string =
  ## Декодировать percent-encoded строку.
  ## Пример: "hello%20world" → "hello world"
  let cs = s.cstring; let n = s.len.cint
  var p: cstring; var rn: cint
  {.emit: """
    QByteArray _uDec = QUrl::fromPercentEncoding(QByteArray(`cs`, `n`));
    `p` = _uDec.constData(); `rn` = _uDec.size();
  """.}
  result = newString(rn.int)
  if rn > 0: copyMem(addr result[0], p, rn.int)

proc urlQueryParam*(u: QUrl, key: string): string =
  ## Получить параметр query-строки по ключу.
  let ck = key.cstring
  var p: cstring; var n: cint
  {.emit: """
    QUrlQuery _uQQ(`u`);
    QByteArray _uQV = _uQQ.queryItemValue(QString::fromUtf8(`ck`)).toUtf8();
    `p` = _uQV.constData(); `n` = _uQV.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc urlWithQueryParam*(u: QUrl, key, value: string): QUrl =
  ## Вернуть URL с добавленным/заменённым параметром query-строки.
  let ck = key.cstring; let cv = value.cstring
  {.emit: """
    QUrlQuery _uWQ(`u`);
    _uWQ.removeQueryItem(QString::fromUtf8(`ck`));
    _uWQ.addQueryItem(QString::fromUtf8(`ck`), QString::fromUtf8(`cv`));
    `result` = `u`;
    `result`.setQuery(_uWQ);
  """.}

# ═══════════════════════════════════════════════════════════════════════════════
# § 13. QUuid ↔ string
# ═══════════════════════════════════════════════════════════════════════════════

proc newUuid*(): QUuid =
  ## Сгенерировать новый UUID (версия 4, случайный).
  {.emit: "`result` = QUuid::createUuid();".}

proc uuidToString*(u: QUuid): string =
  ## Конвертировать UUID в строку "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}".
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _uuS = `u`.toString().toUtf8();
    `p` = _uuS.constData(); `n` = _uuS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc uuidToStringNoBraces*(u: QUuid): string =
  ## UUID без фигурных скобок: "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx".
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _uuNB = `u`.toString(QUuid::WithoutBraces).toUtf8();
    `p` = _uuNB.constData(); `n` = _uuNB.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc uuidToId128*(u: QUuid): string =
  ## UUID как 32-символьная hex-строка без разделителей.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _uuId = `u`.toString(QUuid::Id128).toUtf8();
    `p` = _uuId.constData(); `n` = _uuId.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc uuidFromString*(s: string): QUuid =
  ## Создать QUuid из строки (с фигурными скобками или без).
  let cs = s.cstring
  {.emit: "`result`=QUuid::fromString(QString::fromUtf8(`cs`));".}

proc uuidIsNull*(u: QUuid): bool =
  ## Проверить, является ли UUID нулевым (пустым).
  var r: cint; {.emit:"`r`=`u`.isNull()?1:0;".}; result=r==1

proc uuidVersion*(u: QUuid): int =
  ## Версия UUID (1..5, или 0 если неизвестна).
  var v: cint; {.emit:"`v`=(int)`u`.version();".}; result=v.int

proc newUuidStr*(): string =
  ## Сгенерировать UUID и сразу вернуть как строку (без скобок).
  uuidToStringNoBraces(newUuid())

# ═══════════════════════════════════════════════════════════════════════════════
# § 14. QJsonDocument / QJsonObject / QJsonArray / QJsonValue
# ═══════════════════════════════════════════════════════════════════════════════

proc jsonParse*(s: string): tuple[ok: bool, err: string, doc: QJsonDocument] =
  ## Разобрать JSON-строку.
  ## Возвращает (ok=true, err="", doc) при успехе.
  ## При ошибке: (ok=false, err="описание ошибки", doc=null).
  let cs = s.cstring
  var ok: cint
  var ep: cstring; var en: cint
  {.emit: """
    QJsonParseError _jErr;
    result.Field2 = QJsonDocument::fromJson(QByteArray(`cs`), &_jErr);
    `ok` = (_jErr.error == QJsonParseError::NoError) ? 1 : 0;
    QByteArray _jErrMsg = _jErr.errorString().toUtf8();
    `ep` = _jErrMsg.constData();
    `en` = _jErrMsg.size();
  """.}
  result.ok = ok == 1
  result.err = newString(en.int)
  if en > 0: copyMem(addr result.err[0], ep, en.int)

proc jsonToString*(doc: QJsonDocument, compact: bool = true): string =
  ## Конвертировать JSON-документ в строку.
  ## compact=true — без отступов; false — с отступами для читаемости.
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _jS = `doc`.toJson(
      `compact` ? QJsonDocument::Compact : QJsonDocument::Indented);
    `p` = _jS.constData(); `n` = _jS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc jsonToBytes*(doc: QJsonDocument): seq[byte] =
  ## Конвертировать JSON-документ в байты (для сохранения в файл).
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _jB = `doc`.toJson(QJsonDocument::Compact);
    `p` = _jB.constData(); `n` = _jB.size();
  """.}
  result = newSeq[byte](n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc jsonIsObject*(doc: QJsonDocument): bool =
  var r: cint; {.emit:"`r`=`doc`.isObject()?1:0;".}; result=r==1
proc jsonIsArray*(doc: QJsonDocument): bool =
  var r: cint; {.emit:"`r`=`doc`.isArray()?1:0;".}; result=r==1
proc jsonIsNull*(doc: QJsonDocument): bool =
  var r: cint; {.emit:"`r`=`doc`.isNull()?1:0;".}; result=r==1

proc jsonObject*(doc: QJsonDocument): QJsonObject =
  {.emit:"`result`=`doc`.object();".}
proc jsonArray*(doc: QJsonDocument): QJsonArray =
  {.emit:"`result`=`doc`.array();".}

proc jsonDocFromObject*(obj: QJsonObject): QJsonDocument =
  {.emit:"`result`=QJsonDocument(`obj`);".}
proc jsonDocFromArray*(arr: QJsonArray): QJsonDocument =
  {.emit:"`result`=QJsonDocument(`arr`);".}

# ── QJsonObject ───────────────────────────────────────────────────────────────

proc jsonObjGet*(obj: QJsonObject, key: string): QJsonValue =
  let cs = key.cstring
  {.emit:"`result`=`obj`[QString::fromUtf8(`cs`)];".}

proc jsonObjSet*(obj: var QJsonObject, key: string, val: QJsonValue) =
  let cs = key.cstring
  {.emit:"`obj`.insert(QString::fromUtf8(`cs`), `val`);".}

proc jsonObjRemove*(obj: var QJsonObject, key: string) =
  let cs = key.cstring
  {.emit:"`obj`.remove(QString::fromUtf8(`cs`));".}

proc jsonObjContains*(obj: QJsonObject, key: string): bool =
  let cs = key.cstring; var r: cint
  {.emit:"`r`=`obj`.contains(QString::fromUtf8(`cs`))?1:0;".}
  result=r==1

proc jsonObjSize*(obj: QJsonObject): int =
  var n: cint; {.emit:"`n`=`obj`.size();".}; result=n.int

proc jsonObjIsEmpty*(obj: QJsonObject): bool =
  var r: cint; {.emit:"`r`=`obj`.isEmpty()?1:0;".}; result=r==1

proc jsonObjKeys*(obj: QJsonObject): seq[string] =
  ## Получить все ключи объекта.
  var n: cint
  {.emit: "QStringList _jOK = `obj`.keys(); `n` = _jOK.size();".}
  result = newSeq[string](n.int)
  for i in 0 ..< n.int:
    let idx = i.cint
    var p: cstring; var kn: cint
    {.emit: "QByteArray _jOKi = _jOK.at(`idx`).toUtf8(); `p`=_jOKi.constData(); `kn`=_jOKi.size();".}
    result[i] = newString(kn.int)
    if kn > 0: copyMem(addr result[i][0], p, kn.int)

proc jsonObjGetStr*(obj: QJsonObject, key: string,
                    default: string = ""): string =
  ## Получить строковое значение по ключу (с default при отсутствии).
  let v = jsonObjGet(obj, key)
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _jOGS = `v`.toString(QString::fromUtf8(`default`)).toUtf8();
    `p` = _jOGS.constData(); `n` = _jOGS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc jsonObjGetFloat*(obj: QJsonObject, key: string,
                      default: float64 = 0.0): float64 =
  let v = jsonObjGet(obj, key); var r: cdouble
  {.emit:"`r`=`v`.toDouble(`default`);".}; result=r.float64

proc jsonObjGetInt*(obj: QJsonObject, key: string, default: int = 0): int =
  let v = jsonObjGet(obj, key); var r: cint
  {.emit:"`r`=(int)`v`.toDouble((double)`default`);".}; result=r.int

proc jsonObjGetBool*(obj: QJsonObject, key: string,
                     default: bool = false): bool =
  let v = jsonObjGet(obj, key); let d = default.cint; var r: cint
  {.emit:"`r`=`v`.toBool((bool)`d`)?1:0;".}; result=r==1

# ── QJsonArray ────────────────────────────────────────────────────────────────

proc jsonArrSize*(arr: QJsonArray): int =
  var n: cint; {.emit:"`n`=`arr`.size();".}; result=n.int

proc jsonArrIsEmpty*(arr: QJsonArray): bool =
  var r: cint; {.emit:"`r`=`arr`.isEmpty()?1:0;".}; result=r==1

proc jsonArrAt*(arr: QJsonArray, i: int): QJsonValue =
  let idx=i.cint; {.emit:"`result`=`arr`.at(`idx`);".}

proc jsonArrAppend*(arr: var QJsonArray, val: QJsonValue) =
  {.emit:"`arr`.append(`val`);".}

proc jsonArrPrepend*(arr: var QJsonArray, val: QJsonValue) =
  {.emit:"`arr`.prepend(`val`);".}

proc jsonArrRemoveAt*(arr: var QJsonArray, i: int) =
  let idx=i.cint; {.emit:"`arr`.removeAt(`idx`);".}

proc jsonArrFirst*(arr: QJsonArray): QJsonValue =
  {.emit:"`result`=`arr`.first();".}

proc jsonArrLast*(arr: QJsonArray): QJsonValue =
  {.emit:"`result`=`arr`.last();".}

# ── QJsonValue ────────────────────────────────────────────────────────────────

proc jsonValIsString*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isString()?1:0;".}; result=r==1
proc jsonValIsDouble*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isDouble()?1:0;".}; result=r==1
proc jsonValIsBool*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isBool()?1:0;".}; result=r==1
proc jsonValIsNull*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isNull()?1:0;".}; result=r==1
proc jsonValIsObject*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isObject()?1:0;".}; result=r==1
proc jsonValIsArray*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isArray()?1:0;".}; result=r==1
proc jsonValIsUndefined*(v: QJsonValue): bool =
  var r: cint; {.emit:"`r`=`v`.isUndefined()?1:0;".}; result=r==1

proc jsonValToString*(v: QJsonValue, default: string = ""): string =
  let ds = default.cstring
  var p: cstring; var n: cint
  {.emit: """
    QByteArray _jVS = `v`.toString(QString::fromUtf8(`ds`)).toUtf8();
    `p` = _jVS.constData(); `n` = _jVS.size();
  """.}
  result = newString(n.int)
  if n > 0: copyMem(addr result[0], p, n.int)

proc jsonValToFloat*(v: QJsonValue, default: float64 = 0.0): float64 =
  var r: cdouble; {.emit:"`r`=`v`.toDouble(`default`);".}; result=r.float64

proc jsonValToInt*(v: QJsonValue, default: int = 0): int =
  let d = default.cdouble; var r: cdouble
  {.emit:"`r`=`v`.toDouble(`d`);".}; result=r.int

proc jsonValToInt64*(v: QJsonValue, default: int64 = 0): int64 =
  var r: cdouble; {.emit:"`r`=`v`.toDouble(0.0);".}; result=r.int64

proc jsonValToBool*(v: QJsonValue, default: bool = false): bool =
  let d = default.cint; var r: cint
  {.emit:"`r`=`v`.toBool((bool)`d`)?1:0;".}; result=r==1

proc jsonValToObject*(v: QJsonValue): QJsonObject =
  {.emit:"`result`=`v`.toObject();".}
proc jsonValToArray*(v: QJsonValue): QJsonArray =
  {.emit:"`result`=`v`.toArray();".}

# ── Конструкторы QJsonValue ───────────────────────────────────────────────────

proc jsonValFromString*(s: string): QJsonValue =
  let cs=s.cstring; {.emit:"`result`=QJsonValue(QString::fromUtf8(`cs`));".}
proc jsonValFromFloat*(f: float64): QJsonValue =
  {.emit:"`result`=QJsonValue(`f`);".}
proc jsonValFromInt*(n: int64): QJsonValue =
  let v=n.cdouble; {.emit:"`result`=QJsonValue(`v`);".}
proc jsonValFromBool*(b: bool): QJsonValue =
  let bv=b.cint; {.emit:"`result`=QJsonValue((bool)`bv`);".}
proc jsonValNull*(): QJsonValue =
  {.emit:"`result`=QJsonValue(QJsonValue::Null);".}
proc jsonValFromObject*(obj: QJsonObject): QJsonValue =
  {.emit:"`result`=QJsonValue(`obj`);".}
proc jsonValFromArray*(arr: QJsonArray): QJsonValue =
  {.emit:"`result`=QJsonValue(`arr`);".}

# ── Высокоуровневые JSON утилиты ──────────────────────────────────────────────

proc jsonMakeObject*(kvPairs: openArray[tuple[key: string, val: string]]): string =
  ## Быстро создать JSON-объект из пар ключ-значение (строки).
  ## Возвращает компактную JSON-строку.
  ## Пример: jsonMakeObject([("name","Alice"),("age","30")])
  var obj: QJsonObject
  for pair in kvPairs:
    let k = pair.key; let v = pair.val
    jsonObjSet(obj, k, jsonValFromString(v))
  let doc = jsonDocFromObject(obj)
  jsonToString(doc, true)

# ═══════════════════════════════════════════════════════════════════════════════
# § 15. QList<int/double/string> ↔ seq
# ═══════════════════════════════════════════════════════════════════════════════

proc seqToQIntList*(s: seq[int]): string =
  ## Вспомогательная функция: упаковать seq[int] для передачи в C++.
  ## Используется внутри emit-блоков.
  discard s  # реализация через emit в вызывающем коде

proc intListFromNimSeq(s: openArray[int]): cstring =
  ## Внутренний хелпер для передачи int-массивов.
  discard

# ═══════════════════════════════════════════════════════════════════════════════
# § 16. Общие утилиты
# ═══════════════════════════════════════════════════════════════════════════════

proc nimBoolToQt*(b: bool): cint =
  ## Конвертировать Nim bool в cint для использования в emit-блоках.
  result = if b: 1.cint else: 0.cint

proc qtBoolToNim*(v: cint): bool =
  ## Конвертировать cint (из Qt) в Nim bool.
  result = v != 0

proc clampByte*(n: int): uint8 =
  ## Ограничить int диапазоном [0, 255] и вернуть uint8.
  if n < 0: 0u8 elif n > 255: 255u8 else: n.uint8

proc clampF*(v, lo, hi: float64): float64 =
  ## Ограничить float64 диапазоном [lo, hi].
  if v < lo: lo elif v > hi: hi else: v

proc clampI*(v, lo, hi: int): int =
  ## Ограничить int диапазоном [lo, hi].
  if v < lo: lo elif v > hi: hi else: v

proc qsFormat*(tmpl: string, args: varargs[string]): string =
  ## Простая подстановка %1, %2, … → args[0], args[1], …
  ## Пример: qsFormat("%1 из %2", "5", "10") → "5 из 10"
  result = tmpl
  for i, a in args:
    result = result.replace("%" & $(i + 1), a)

proc toHex*(n: int, digits: int = 0): string =
  ## Конвертировать целое в hex-строку (с префиксом "0x").
  ## digits задаёт минимальную длину (дополняется нулями).
  result = "0x" & toHex(n, digits)

proc hexToInt*(s: string): int =
  ## Разобрать hex-строку (с или без "0x"/"0X") как целое.
  var clean = s.strip()
  if clean.startsWith("0x") or clean.startsWith("0X"):
    clean = clean[2..^1]
  var v: clonglong
  let cs = clean.cstring
  {.emit: """
    bool _htOk;
    `v` = QString::fromUtf8(`cs`).toLongLong(&_htOk, 16);
  """.}
  result = v.int

proc lerp*(a, b, t: float64): float64 =
  ## Линейная интерполяция: a + (b - a) * t
  a + (b - a) * clampF(t, 0.0, 1.0)

proc lerpI*(a, b: int, t: float64): int =
  ## Линейная интерполяция для целых.
  int(float64(a) + float64(b - a) * clampF(t, 0.0, 1.0))

proc isPowerOf2*(n: int): bool =
  ## Проверить, является ли n степенью двойки.
  n > 0 and (n and (n - 1)) == 0

proc nextPowerOf2*(n: int): int =
  ## Следующая степень двойки, >= n.
  if n <= 0: return 1
  var p = 1
  while p < n: p = p shl 1
  result = p

## ── Конец nimQtUtils.nim ─────────────────────────────────────────────────────
