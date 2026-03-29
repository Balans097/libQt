# nimQtUtils — Справочник библиотеки

> **Версия:** Qt6 / Nim  
> **Файл:** `nimQtUtils.nim`  
> **Компиляция:** `nim cpp --passC:"-std=c++20" app.nim`  
> **Зависимости:** только `strutils` из стандартной библиотеки Nim; находится на самом нижнем уровне после `nimQtFFI`.

---

## Содержание

1. [Базовые opaque типы Qt](#1-базовые-opaque-типы-qt)
2. [Nim-side структуры](#2-nim-side-структуры)
3. [QString ↔ Nim string](#3-qstring--nim-string)
4. [QStringList ↔ seq\[string\]](#4-qstringlist--seqstring)
5. [QByteArray ↔ string / seq\[byte\]](#5-qbytearray--string--seqbyte)
6. [QVariant ↔ Nim типы](#6-qvariant--nim-типы)
7. [QColor ↔ NimColor / hex / HSV / HSL / CMYK](#7-qcolor--nimcolor--hex--hsv--hsl--cmyk)
8. [QPoint / QPointF ↔ NimPoint / NimPointF](#8-qpoint--qpointf--nimpoint--nimpointf)
9. [QSize / QSizeF ↔ NimSize / NimSizeF](#9-qsize--qsizef--nimsize--nimsizef)
10. [QRect / QRectF ↔ NimRect / NimRectF](#10-qrect--qrectf--nimrect--nimrectf)
11. [QDate / QTime / QDateTime](#11-qdate--qtime--qdatetime)
12. [QUrl ↔ string](#12-qurl--string)
13. [QUuid ↔ string](#13-quuid--string)
14. [QJsonDocument / QJsonObject / QJsonArray / QJsonValue](#14-qjsondocument--qjsonobject--qjsonarray--qjsonvalue)
15. [Общие утилиты](#15-общие-утилиты)

---

## Принципы реализации

- Все функции, возвращающие строки, используют **локальные** `QByteArray` (не `static`), что обеспечивает **thread-safety**.
- Нулевой байт в качестве разделителя применяется при передаче массивов строк через `QByteArray`/`QStringList` без промежуточного буфера.
- API максимально идиоматичен для Nim: перегрузки, `result`, кортежи.

---

## 1. Базовые opaque типы Qt

Все типы импортированы через `{.importcpp.}` и хранятся по значению (value semantics, COW где применимо).

| Тип | C++ класс | Описание |
|-----|-----------|----------|
| `QString` | `QString` | Строка Qt (UTF-16 внутри, Copy-On-Write). Основной строковый тип всех виджет-API. |
| `QStringList` | `QStringList` | Список строк Qt (`QList<QString>`). |
| `QByteArray` | `QByteArray` | Массив байтов. Эффективен для бинарных данных и UTF-8. |
| `QVariant` | `QVariant` | Универсальный тип-значение. Хранит `QString`, `int`, `double`, `bool`, `QColor`, `QDateTime`, `QList<QVariant>` и другие. |
| `QColor` | `QColor` | Цвет Qt (RGBA + поддержка HSV, HSL, CMYK). |
| `QPoint` | `QPoint` | Точка с целыми координатами. |
| `QPointF` | `QPointF` | Точка с вещественными координатами (`double`). |
| `QSize` | `QSize` | Размер с целыми компонентами (ширина × высота). |
| `QSizeF` | `QSizeF` | Размер с вещественными компонентами. |
| `QRect` | `QRect` | Прямоугольник с целыми координатами. |
| `QRectF` | `QRectF` | Прямоугольник с вещественными координатами. |
| `QDate` | `QDate` | Дата (без времени). |
| `QTime` | `QTime` | Время суток (без даты). |
| `QDateTime` | `QDateTime` | Дата и время с опциональным часовым поясом. |
| `QUrl` | `QUrl` | URL (веб-адрес, файловый путь, ресурс Qt). |
| `QUuid` | `QUuid` | 128-битный UUID. |
| `QJsonDocument` | `QJsonDocument` | JSON-документ (объект или массив верхнего уровня). |
| `QJsonObject` | `QJsonObject` | JSON-объект (словарь ключ→значение). |
| `QJsonArray` | `QJsonArray` | JSON-массив. |
| `QJsonValue` | `QJsonValue` | JSON-значение (`null` / `bool` / `double` / `string` / `array` / `object`). |
| `QTimeZone` | `QTimeZone` | Часовой пояс Qt. |

---

## 2. Nim-side структуры

Лёгкие структуры на стороне Nim — альтернатива Qt value-types без накладных расходов FFI.

| Тип | Определение | Описание |
|-----|-------------|----------|
| `NimPoint` | `tuple[x, y: int]` | Точка с целыми координатами. |
| `NimPointF` | `tuple[x, y: float64]` | Точка с вещественными координатами. |
| `NimSize` | `tuple[w, h: int]` | Размер с целыми компонентами. |
| `NimSizeF` | `tuple[w, h: float64]` | Размер с вещественными компонентами. |
| `NimRect` | `tuple[x, y, w, h: int]` | Прямоугольник с целыми координатами. |
| `NimRectF` | `tuple[x, y, w, h: float64]` | Прямоугольник с вещественными координатами. |
| `NimColor` | `tuple[r, g, b, a: uint8]` | Цвет RGBA (каждый канал 0..255). |
| `NimColorF` | `tuple[r, g, b, a: float64]` | Цвет RGBA с вещественными компонентами (0.0..1.0). |
| `NimColorHSV` | `tuple[h, s, v, a: int]` | Цвет HSV (h: 0..359, s/v: 0..255, a: 0..255). |
| `NimColorHSL` | `tuple[h, s, l, a: int]` | Цвет HSL (h: 0..359, s/l: 0..255, a: 0..255). |

---

## 3. QString ↔ Nim string

### Конструкторы и конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toQString` | `(s: string): QString` | Nim string (UTF-8) → QString. **Основной способ передачи строк в Qt-API.** |
| `toQString` | `(cs: cstring): QString` | C-строка (UTF-8) → QString. |
| `toQStringLatin1` | `(s: string): QString` | Latin-1 строка → QString. Только для Latin-1 источников. |
| `toQStringUtf16` | `(data: seq[uint16]): QString` | UTF-16 данные → QString. |
| `nimStr` | `(q: QString): string` | QString → Nim string (UTF-8). Thread-safe. |
| `nimStrLatin1` | `(q: QString): string` | QString → Latin-1 строка. |
| `qs` | `(s: string): QString` | Короткий конструктор. **Пример:** `widget.setText(qs("Привет"))` |
| `qs` | `(cs: cstring): QString` | Короткий конструктор из C-строки. |
| `$` | `(q: QString): string` | Оператор `$` — для `echo`, форматирования и т.п. |

### Свойства строки

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsLen` | `(q: QString): int` | Длина строки в символах UTF-16 (не в байтах). |
| `qsIsEmpty` | `(q: QString): bool` | Строка пуста? |
| `qsIsNull` | `(q: QString): bool` | Строка `null`? (отличается от пустой). |

### Модификации строки

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsTrimmed` | `(q: QString): QString` | Убрать пробелы в начале и конце. |
| `qsSimplified` | `(q: QString): QString` | Убрать ведущие/ведомые пробелы; внутренние серии → один пробел. |
| `qsUpper` | `(q: QString): QString` | Верхний регистр (с учётом локали). |
| `qsLower` | `(q: QString): QString` | Нижний регистр (с учётом локали). |
| `qsTrimmed` | `(q: QString): QString` | Убрать пробелы по краям. |
| `qsReplace` | `(q, before, after: QString): QString` | Заменить все вхождения `before` на `after`. |
| `qsReplaceStr` | `(q: QString, before, after: string): QString` | То же, но с Nim-строками. |
| `qsRepeat` | `(q: QString, n: int): QString` | Повторить строку `n` раз. |
| `qsMid` | `(q: QString, pos: int, len: int = -1): QString` | Подстрока от `pos` длиной `len` (-1 = до конца). |
| `qsLeft` | `(q: QString, n: int): QString` | Первые `n` символов. |
| `qsRight` | `(q: QString, n: int): QString` | Последние `n` символов. |
| `qsAt` | `(q: QString, i: int): char` | Символ на позиции `i` (как Latin-1 `char`). |

### Поиск

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsContains` | `(q, sub: QString, caseSensitive: bool = true): bool` | Содержит ли строка подстроку. |
| `qsContainsStr` | `(q: QString, sub: string, caseSensitive: bool = true): bool` | То же, с Nim-строкой. |
| `qsStartsWith` | `(q, pre: QString, caseSensitive: bool = true): bool` | Начинается ли с `pre`. |
| `qsEndsWith` | `(q, suf: QString, caseSensitive: bool = true): bool` | Оканчивается ли на `suf`. |
| `qsIndexOf` | `(q, sub: QString, from: int = 0, caseSensitive: bool = true): int` | Первое вхождение `sub`, начиная с `from`. Возвращает -1 если нет. |
| `qsLastIndexOf` | `(q, sub: QString, from: int = -1): int` | Последнее вхождение `sub`. |

### Разбиение и объединение

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsSplit` | `(q, sep: QString, skipEmpty: bool = false): QStringList` | Разбить строку по разделителю. |
| `qsSplitStr` | `(q: QString, sep: string, skipEmpty: bool = false): QStringList` | То же, с Nim-строкой. |
| `qsJoin` | `(sl: QStringList, sep: QString): QString` | Объединить список строк разделителем. |
| `qsJoinStr` | `(sl: QStringList, sep: string): QString` | То же, с Nim-строкой. |

### Числовые конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsNumber` | `(n: int64): QString` | Целое → QString. |
| `qsNumber` | `(n: int): QString` | Целое → QString. |
| `qsNumberF` | `(f: float64, format: char = 'g', precision: int = -1): QString` | Вещественное → QString. `format`: `'e'`=экспоненциальный, `'f'`=фиксированный, `'g'`=короткий. |
| `qsToInt` | `(q: QString, base: int = 10): tuple[ok: bool, val: int64]` | Разобрать как целое с проверкой. |
| `qsToFloat` | `(q: QString): tuple[ok: bool, val: float64]` | Разобрать как вещественное с проверкой. |

### Форматирование (arg-шаблоны)

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsArgInt` | `(tmpl: QString, n: int64): QString` | Заменить первый `%1` на целое. |
| `qsArgStr` | `(tmpl: QString, s: QString): QString` | Заменить первый `%1` на строку. |
| `qsArgF` | `(tmpl: QString, f: float64, fieldWidth: int = 0, fmt: char = 'g', precision: int = -1): QString` | Заменить первый `%1` на вещественное. |

### Сравнение и операторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsCompare` | `(a, b: QString, caseSensitive: bool = true): int` | Лексикографическое сравнение. `< 0` если `a < b`, `0` если равны, `> 0` если `a > b`. |
| `==` | `(a, b: QString): bool` | Равенство строк. |
| `!=` | `(a, b: QString): bool` | Неравенство строк. |
| `&` | `(a, b: QString): QString` | Конкатенация. |
| `&` | `(a: QString, b: string): QString` | Конкатенация с Nim-строкой. |
| `&` | `(a: string, b: QString): QString` | Конкатенация с Nim-строкой. |

### Base64

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsToBase64` | `(q: QString): string` | Строка → Base64 (UTF-8 → base64). |
| `qsFromBase64` | `(b64: string): QString` | Base64 → QString. |

---

## 4. QStringList ↔ seq[string]

### Конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toQStringList` | `(ss: openArray[string]): QStringList` | `seq[string]` → `QStringList`. |
| `toNimSeq` | `(sl: QStringList): seq[string]` | `QStringList` → `seq[string]`. Thread-safe. |

### Модификация списка

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qslAdd` | `(sl: var QStringList, s: QString)` | Добавить строку в список. |
| `qslAdd` | `(sl: var QStringList, s: string)` | Добавить Nim-строку в список. |
| `qslRemoveAt` | `(sl: var QStringList, i: int)` | Удалить элемент по индексу. |
| `qslSort` | `(sl: var QStringList, caseSensitive: bool = true)` | Сортировать список. |
| `qslRemoveDuplicates` | `(sl: var QStringList): int` | Удалить дубликаты. Возвращает количество удалённых. |

### Доступ к элементам

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qslSize` | `(sl: QStringList): int` | Количество элементов. |
| `qslAt` | `(sl: QStringList, i: int): QString` | Элемент по индексу как `QString`. |
| `qslAtStr` | `(sl: QStringList, i: int): string` | Элемент по индексу как Nim `string`. |
| `qslIndexOf` | `(sl: QStringList, s: QString): int` | Индекс строки (-1 если не найдено). |

### Поиск и фильтрация

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qslContains` | `(sl: QStringList, s: QString, caseSensitive: bool = true): bool` | Наличие строки в списке. |
| `qslFilter` | `(sl: QStringList, rx: QString, caseSensitive: bool = true): QStringList` | Отфильтровать по подстроке. |

### Объединение

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qslJoin` | `(sl: QStringList, sep: string): string` | Объединить список в Nim-строку. |

---

## 5. QByteArray ↔ string / seq[byte]

### Конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toQByteArray` | `(s: string): QByteArray` | Nim string → QByteArray (побайтово, без перекодировки). |
| `toQByteArray` | `(data: openArray[byte]): QByteArray` | `seq[byte]` / `array[byte]` → QByteArray. |

### Конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toNimString` | `(ba: QByteArray): string` | QByteArray → Nim string. Thread-safe. |
| `toNimBytes` | `(ba: QByteArray): seq[byte]` | QByteArray → `seq[byte]`. |

### Свойства

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qbaSize` | `(ba: QByteArray): int` | Размер в байтах. |
| `qbaIsEmpty` | `(ba: QByteArray): bool` | Массив пуст? |
| `qbaAt` | `(ba: QByteArray, i: int): byte` | Байт по индексу. |
| `qbaIndexOf` | `(ba: QByteArray, needle: string): int` | Найти подстроку. |

### Модификация

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qbaAppend` | `(ba: var QByteArray, other: QByteArray)` | Добавить в конец. |
| `qbaPrepend` | `(ba: var QByteArray, other: QByteArray)` | Добавить в начало. |
| `qbaMid` | `(ba: QByteArray, pos: int, len: int = -1): QByteArray` | Подмассив от `pos` длиной `len`. |
| `qbaTrimmed` | `(ba: QByteArray): QByteArray` | Убрать пробелы по краям. |

### Кодирование

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qbaToBase64` | `(ba: QByteArray): string` | Кодировать в Base64. |
| `qbaFromBase64` | `(b64: string): QByteArray` | Декодировать из Base64. |
| `qbaToHex` | `(ba: QByteArray, separator: char = '\0'): string` | В hex-строку. `separator=':'` → `"aa:bb:cc"`. |
| `qbaFromHex` | `(hex: string): QByteArray` | Из hex-строки. |
| `qbaCompressed` | `(ba: QByteArray, level: int = -1): QByteArray` | Сжать (zlib). `level`: -1=авто, 0..9. |
| `qbaUncompressed` | `(ba: QByteArray): QByteArray` | Распаковать (zlib). |

---

## 6. QVariant ↔ Nim типы

### Создание QVariant

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `varFromInt` | `(n: int64): QVariant` | Из `int64`. |
| `varFromInt` | `(n: int): QVariant` | Из `int`. |
| `varFromUInt` | `(n: uint64): QVariant` | Из `uint64`. |
| `varFromFloat` | `(f: float64): QVariant` | Из `float64`. |
| `varFromFloat` | `(f: float32): QVariant` | Из `float32`. |
| `varFromString` | `(s: string): QVariant` | Из Nim string. |
| `varFromQString` | `(q: QString): QVariant` | Из `QString`. |
| `varFromBool` | `(b: bool): QVariant` | Из `bool`. |
| `varFromBytes` | `(data: string): QVariant` | Из бинарных данных (`QByteArray`). |

### Извлечение из QVariant

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `varToInt` | `(v: QVariant): int64` | Извлечь как `int64`. |
| `varToUInt` | `(v: QVariant): uint64` | Извлечь как `uint64`. |
| `varToFloat` | `(v: QVariant): float64` | Извлечь как `float64`. |
| `varToString` | `(v: QVariant): string` | Извлечь как Nim string. Thread-safe. |
| `varToBool` | `(v: QVariant): bool` | Извлечь как `bool`. |

### Инспекция QVariant

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `varIsNull` | `(v: QVariant): bool` | Значение `null`? |
| `varIsValid` | `(v: QVariant): bool` | Значение валидно? |
| `varTypeName` | `(v: QVariant): string` | Имя хранимого типа (`"QString"`, `"int"`, `"QColor"`, …). |
| `varCanConvertToString` | `(v: QVariant): bool` | Можно ли конвертировать в строку? |

---

## 7. QColor ↔ NimColor / hex / HSV / HSL / CMYK

### Конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makeColor` | `(r, g, b: uint8, a: uint8 = 255): QColor` | Из RGBA (uint8, 0..255). |
| `makeColorI` | `(r, g, b: int, a: int = 255): QColor` | Из RGBA (int, удобнее при вычислениях). |
| `makeColorF` | `(r, g, b: float64, a: float64 = 1.0): QColor` | Из RGBA float (0.0..1.0). |
| `colorFromHex` | `(hex: string): QColor` | Из hex-строки: `"#rgb"`, `"#rrggbb"`, `"#aarrggbb"`, `"red"`, `"transparent"`. |
| `colorFromHsv` | `(h, s, v: int, a: int = 255): QColor` | Из HSV (h: 0..359, s/v: 0..255, a: 0..255). |
| `colorFromHsvF` | `(h, s, v: float64, a: float64 = 1.0): QColor` | Из HSV float (0.0..1.0). |
| `colorFromHsl` | `(h, s, l: int, a: int = 255): QColor` | Из HSL (h: 0..359, s/l: 0..255, a: 0..255). |
| `colorFromHslF` | `(h, s, l: float64, a: float64 = 1.0): QColor` | Из HSL float. |
| `colorFromCmyk` | `(c, m, y, k: int, a: int = 255): QColor` | Из CMYK (0..255). |
| `colorFromTuple` | `(nc: NimColor): QColor` | Из `NimColor`. |
| `colorFromTupleF` | `(nc: NimColorF): QColor` | Из `NimColorF`. |
| `colorFromRgb32` | `(rgba: uint32): QColor` | Из 32-битного `0xAARRGGBB`. |

### Геттеры компонентов (RGB)

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `colorRed` | `(c: QColor): uint8` | Красный канал (0..255). |
| `colorGreen` | `(c: QColor): uint8` | Зелёный канал (0..255). |
| `colorBlue` | `(c: QColor): uint8` | Синий канал (0..255). |
| `colorAlpha` | `(c: QColor): uint8` | Альфа-канал (0..255). |
| `colorRedF` | `(c: QColor): float64` | Красный (0.0..1.0). |
| `colorGreenF` | `(c: QColor): float64` | Зелёный (0.0..1.0). |
| `colorBlueF` | `(c: QColor): float64` | Синий (0.0..1.0). |
| `colorAlphaF` | `(c: QColor): float64` | Альфа (0.0..1.0). |

### Геттеры компонентов (HSV/HSL)

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `colorHue` | `(c: QColor): int` | Оттенок HSV (0..359; -1 если ахроматический). |
| `colorSaturation` | `(c: QColor): int` | Насыщенность HSV (0..255). |
| `colorValue` | `(c: QColor): int` | Яркость HSV (0..255). |
| `colorHsv` | `(c: QColor): NimColorHSV` | Получить цвет как HSV-кортеж. |
| `colorHsl` | `(c: QColor): NimColorHSL` | Получить цвет как HSL-кортеж. |

### Конвертации и операции

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `colorToHex` | `(c: QColor): string` | В `"#rrggbb"`. |
| `colorToHexA` | `(c: QColor): string` | В `"#aarrggbb"` (с альфа-каналом). |
| `colorToTuple` | `(c: QColor): NimColor` | В `NimColor` (RGBA uint8). |
| `colorToTupleF` | `(c: QColor): NimColorF` | В `NimColorF` (RGBA float64). |
| `colorToRgb32` | `(c: QColor): uint32` | В 32-битное `0xAARRGGBB`. |
| `isValidColor` | `(c: QColor): bool` | Цвет допустим? (`false` для `QColor()` по умолчанию). |
| `lighter` | `(c: QColor, factor: int = 150): QColor` | Осветлить. `factor=150` → +50% яркости. |
| `darker` | `(c: QColor, factor: int = 200): QColor` | Затемнить. `factor=200` → -50% яркости. |
| `colorSetAlpha` | `(c: QColor, a: int): QColor` | Новый цвет с изменённой прозрачностью (0..255). |
| `colorSetAlphaF` | `(c: QColor, a: float64): QColor` | Новый цвет с изменённой прозрачностью (0.0..1.0). |
| `colorInterpolate` | `(c1, c2: QColor, t: float64): QColor` | Линейная интерполяция. `t=0.0` → c1, `t=1.0` → c2. |

---

## 8. QPoint / QPointF ↔ NimPoint / NimPointF

### Конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makePoint` | `(x, y: int): QPoint` | Создать `QPoint`. |
| `makePointF` | `(x, y: float64): QPointF` | Создать `QPointF`. |

### Геттеры

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `pointX` | `(p: QPoint): int` | Координата X. |
| `pointY` | `(p: QPoint): int` | Координата Y. |
| `pointFX` | `(p: QPointF): float64` | Координата X (float). |
| `pointFY` | `(p: QPointF): float64` | Координата Y (float). |

### Метрики

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `pointManhattan` | `(p: QPoint): int` | Манхэттенское расстояние (\|x\| + \|y\|). |
| `pointFLengthSq` | `(p: QPointF): float64` | Квадрат длины вектора (без `sqrt`). |
| `pointFLength` | `(p: QPointF): float64` | Длина вектора от начала координат. |
| `pointFDot` | `(a, b: QPointF): float64` | Скалярное произведение двух векторов. |

### Конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toNimPoint` | `(p: QPoint): NimPoint` | QPoint → NimPoint. |
| `toNimPointF` | `(p: QPointF): NimPointF` | QPointF → NimPointF. |
| `toQPoint` | `(p: NimPoint): QPoint` | NimPoint → QPoint. |
| `toQPointF` | `(p: NimPointF): QPointF` | NimPointF → QPointF. |
| `pointFToPoint` | `(p: QPointF): QPoint` | Округлить QPointF до QPoint. |
| `pointToPointF` | `(p: QPoint): QPointF` | QPoint → QPointF. |

### Арифметика

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `pointAdd` | `(a, b: QPoint): QPoint` | Сложение точек. |
| `pointSub` | `(a, b: QPoint): QPoint` | Вычитание точек. |
| `pointFAdd` | `(a, b: QPointF): QPointF` | Сложение float-точек. |
| `pointFSub` | `(a, b: QPointF): QPointF` | Вычитание float-точек. |

---

## 9. QSize / QSizeF ↔ NimSize / NimSizeF

### Конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makeSize` | `(w, h: int): QSize` | Создать `QSize`. |
| `makeSizeF` | `(w, h: float64): QSizeF` | Создать `QSizeF`. |

### Геттеры

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `sizeW` | `(s: QSize): int` | Ширина. |
| `sizeH` | `(s: QSize): int` | Высота. |
| `sizeFW` | `(s: QSizeF): float64` | Ширина (float). |
| `sizeFH` | `(s: QSizeF): float64` | Высота (float). |
| `sizeArea` | `(s: QSize): int` | Площадь (`w * h`). |

### Состояние

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `sizeIsEmpty` | `(s: QSize): bool` | Хоть одна сторона ≤ 0? |
| `sizeIsNull` | `(s: QSize): bool` | Обе стороны == 0? |
| `sizeIsValid` | `(s: QSize): bool` | Обе стороны > 0? |

### Операции

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `sizeTransposed` | `(s: QSize): QSize` | Поменять местами ширину и высоту. |
| `sizeExpanded` | `(a, b: QSize): QSize` | Поэлементный максимум (наибольшие стороны). |
| `sizeBounded` | `(a, b: QSize): QSize` | Поэлементный минимум (наименьшие стороны). |
| `sizeScaled` | `(s: QSize, targetW, targetH: int, mode: cint): QSize` | Масштабирование с режимом пропорций. `mode`: 0=IgnoreAspectRatio, 1=KeepAspectRatio, 2=KeepAspectRatioByExpanding. |

### Конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toNimSize` | `(s: QSize): NimSize` | QSize → NimSize. |
| `toNimSizeF` | `(s: QSizeF): NimSizeF` | QSizeF → NimSizeF. |
| `toQSize` | `(s: NimSize): QSize` | NimSize → QSize. |
| `toQSizeF` | `(s: NimSizeF): QSizeF` | NimSizeF → QSizeF. |
| `sizeFToSize` | `(s: QSizeF): QSize` | QSizeF → QSize (округление). |
| `sizeToSizeF` | `(s: QSize): QSizeF` | QSize → QSizeF. |

---

## 10. QRect / QRectF ↔ NimRect / NimRectF

### Конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makeRect` | `(x, y, w, h: int): QRect` | Создать `QRect`. |
| `makeRectF` | `(x, y, w, h: float64): QRectF` | Создать `QRectF`. |

### Геттеры QRect

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `rectX` | `(r: QRect): int` | Координата X левого края. |
| `rectY` | `(r: QRect): int` | Координата Y верхнего края. |
| `rectW` | `(r: QRect): int` | Ширина. |
| `rectH` | `(r: QRect): int` | Высота. |
| `rectLeft` | `(r: QRect): int` | Левый край. |
| `rectRight` | `(r: QRect): int` | Правый край. |
| `rectTop` | `(r: QRect): int` | Верхний край. |
| `rectBottom` | `(r: QRect): int` | Нижний край. |

### Состояние QRect

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `rectIsEmpty` | `(r: QRect): bool` | Пустой прямоугольник? |
| `rectIsNull` | `(r: QRect): bool` | Нулевой прямоугольник? |
| `rectIsValid` | `(r: QRect): bool` | Валидный прямоугольник? |

### Операции QRect

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `rectContainsPoint` | `(r: QRect, x, y: int): bool` | Содержит точку (x, y)? |
| `rectContains` | `(r: QRect, p: QPoint): bool` | Содержит `QPoint`? |
| `rectContainsRect` | `(r, other: QRect): bool` | Содержит другой прямоугольник? |
| `rectIntersects` | `(a, b: QRect): bool` | Пересекаются ли прямоугольники? |
| `rectUnited` | `(a, b: QRect): QRect` | Наименьший охватывающий прямоугольник. |
| `rectIntersected` | `(a, b: QRect): QRect` | Пересечение двух прямоугольников. |
| `rectCenter` | `(r: QRect): QPoint` | Центральная точка. |
| `rectNormalized` | `(r: QRect): QRect` | Нормализовать (сделать w и h положительными). |
| `rectAdjusted` | `(r: QRect, dx1, dy1, dx2, dy2: int): QRect` | Расширить/сжать стороны. |
| `rectTranslated` | `(r: QRect, dx, dy: int): QRect` | Сдвинуть прямоугольник. |
| `rectMovedTo` | `(r: QRect, x, y: int): QRect` | Переместить в точку (x, y), сохранив размер. |

### Конвертации QRect / QRectF

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toNimRect` | `(r: QRect): NimRect` | QRect → NimRect. |
| `toQRect` | `(r: NimRect): QRect` | NimRect → QRect. |
| `toNimRectF` | `(r: QRectF): NimRectF` | QRectF → NimRectF. |
| `toQRectF` | `(r: NimRectF): QRectF` | NimRectF → QRectF. |
| `rectToRectF` | `(r: QRect): QRectF` | QRect → QRectF. |
| `rectFToRect` | `(r: QRectF): QRect` | QRectF → QRect (округление). |
| `rectFToAlignedRect` | `(r: QRectF): QRect` | QRectF → QRect (выравнивание). |

### Геттеры и операции QRectF

Аналогичны QRect с суффиксом `F`: `rectFX`, `rectFY`, `rectFW`, `rectFH`, `rectFLeft`, `rectFRight`, `rectFTop`, `rectFBottom`, `rectFContainsPoint`, `rectFIntersects`, `rectFUnited`, `rectFIntersected`, `rectFAdjusted`.

---

## 11. QDate / QTime / QDateTime

### Текущие значения

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `currentDate` | `(): QDate` | Текущая дата (локальный ч/п). |
| `currentTime` | `(): QTime` | Текущее время (локальный ч/п). |
| `currentDateTime` | `(): QDateTime` | Текущие дата и время (локальный ч/п). |
| `currentDateTimeUtc` | `(): QDateTime` | Текущие дата и время в UTC. |
| `currentMsecsSinceEpoch` | `(): int64` | Мс с начала Unix epoch (01.01.1970 UTC). |
| `currentSecsSinceEpoch` | `(): int64` | Секунды с начала Unix epoch. |
| `currentTimeStr` | `(fmt: string = "dd.MM.yyyy  HH:mm:ss"): string` | Текущее время как строка. По умолчанию: `"24.03.2025  14:30:15"`. |

### QDate — конструктор и парсинг

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makeDate` | `(year, month, day: int): QDate` | Создать из компонентов. |
| `dateFromString` | `(s: string, fmt: string = "yyyy-MM-dd"): QDate` | Разобрать строку по формату. |
| `dateIsLeapYear` | `(year: int): bool` | Является ли год високосным? |

### QDate — форматирование и компоненты

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `dateToString` | `(d: QDate, fmt: string = "yyyy-MM-dd"): string` | Форматировать дату. Маски: `yyyy`/`yy`, `MM`/`M`, `dd`/`d`, `ddd`/`dddd`. |
| `dateYMD` | `(d: QDate): tuple[y, m, day: int]` | Год, месяц, день одним вызовом. |
| `dateYear` | `(d: QDate): int` | Год. |
| `dateMonth` | `(d: QDate): int` | Месяц (1..12). |
| `dateDay` | `(d: QDate): int` | День месяца. |
| `dateDayOfWeek` | `(d: QDate): int` | День недели (1=Пн, 7=Вс, ISO 8601). |
| `dateDayOfYear` | `(d: QDate): int` | День года. |
| `dateDaysInMonth` | `(d: QDate): int` | Дней в месяце. |
| `dateDaysInYear` | `(d: QDate): int` | Дней в году. |
| `dateIsValid` | `(d: QDate): bool` | Дата допустима? |

### QDate — арифметика

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `dateDaysTo` | `(a, b: QDate): int` | Количество дней от a до b. |
| `dateAddDays` | `(d: QDate, n: int): QDate` | Добавить дни. |
| `dateAddMonths` | `(d: QDate, n: int): QDate` | Добавить месяцы. |
| `dateAddYears` | `(d: QDate, n: int): QDate` | Добавить годы. |

### QTime — конструктор и парсинг

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makeTime` | `(h, m, s: int, ms: int = 0): QTime` | Создать из компонентов. |
| `timeFromString` | `(s: string, fmt: string = "HH:mm:ss"): QTime` | Разобрать строку по формату. |

### QTime — компоненты и арифметика

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `timeToString` | `(t: QTime, fmt: string = "HH:mm:ss"): string` | Форматировать время. |
| `timeHour` | `(t: QTime): int` | Часы (0..23). |
| `timeMin` | `(t: QTime): int` | Минуты (0..59). |
| `timeSec` | `(t: QTime): int` | Секунды (0..59). |
| `timeMsec` | `(t: QTime): int` | Миллисекунды (0..999). |
| `timeMsecDay` | `(t: QTime): int` | Мс от начала суток. |
| `timeSecsTo` | `(a, b: QTime): int` | Секунд от a до b. |
| `timeMsecsTo` | `(a, b: QTime): int` | Мс от a до b. |
| `timeAddSecs` | `(t: QTime, s: int): QTime` | Добавить секунды. |
| `timeAddMsecs` | `(t: QTime, ms: int): QTime` | Добавить миллисекунды. |
| `timeIsValid` | `(t: QTime): bool` | Время допустимо? |

### QDateTime — конструктор и парсинг

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `makeDateTime` | `(year, month, day: int, h: int = 0, m: int = 0, s: int = 0, ms: int = 0): QDateTime` | Создать из компонентов (локальный ч/п). |
| `dateTimeFromString` | `(s: string, fmt: string = "yyyy-MM-dd HH:mm:ss"): QDateTime` | Разобрать строку. |
| `dateTimeFromIso` | `(s: string): QDateTime` | Разобрать ISO 8601. |
| `dateTimeFromMsec` | `(ms: int64): QDateTime` | Из Unix timestamp (мс). |
| `dateTimeFromSec` | `(s: int64): QDateTime` | Из Unix timestamp (с). |

### QDateTime — форматирование

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `dateTimeToString` | `(dt: QDateTime, fmt: string = "yyyy-MM-dd HH:mm:ss"): string` | Форматировать по шаблону. |
| `dateTimeToIso` | `(dt: QDateTime): string` | ISO 8601 без мс (`"yyyy-MM-ddTHH:mm:ss"`). |
| `dateTimeToIsoMs` | `(dt: QDateTime): string` | ISO 8601 с мс (`"yyyy-MM-ddTHH:mm:ss.zzz"`). |
| `dateTimeToMsec` | `(dt: QDateTime): int64` | Unix timestamp в мс. |
| `dateTimeToSec` | `(dt: QDateTime): int64` | Unix timestamp в с. |
| `dateTimeOffset` | `(dt: QDateTime): int` | Смещение от UTC в секундах. |

### QDateTime — операции

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `dateTimeDate` | `(dt: QDateTime): QDate` | Извлечь дату. |
| `dateTimeTime` | `(dt: QDateTime): QTime` | Извлечь время. |
| `dateTimeAddSecs` | `(dt: QDateTime, s: int64): QDateTime` | Добавить секунды. |
| `dateTimeAddMsecs` | `(dt: QDateTime, ms: int64): QDateTime` | Добавить миллисекунды. |
| `dateTimeAddDays` | `(dt: QDateTime, d: int64): QDateTime` | Добавить дни. |
| `dateTimeAddMonths` | `(dt: QDateTime, m: int): QDateTime` | Добавить месяцы. |
| `dateTimeAddYears` | `(dt: QDateTime, y: int): QDateTime` | Добавить годы. |
| `dateTimeSecsTo` | `(a, b: QDateTime): int64` | Секунд от a до b. |
| `dateTimeMsecsTo` | `(a, b: QDateTime): int64` | Мс от a до b. |
| `dateTimeIsValid` | `(dt: QDateTime): bool` | Дата/время допустимо? |
| `dateTimeIsNull` | `(dt: QDateTime): bool` | Дата/время `null`? |
| `dateTimeToUtc` | `(dt: QDateTime): QDateTime` | Конвертировать в UTC. |
| `dateTimeToLocalTime` | `(dt: QDateTime): QDateTime` | Конвертировать в локальный ч/п. |

---

## 12. QUrl ↔ string

### Конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toQUrl` | `(s: string): QUrl` | Из строки. Формат определяется автоматически. |
| `toQUrlStrict` | `(s: string): QUrl` | Из строки со строгой проверкой. |
| `urlFromLocalFile` | `(path: string): QUrl` | `file://` URL из пути к файлу. |

### Конвертации и компоненты

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `urlToString` | `(u: QUrl, options: cint = 0): string` | URL → строка. `options`: `QUrl::FormattingOptions`. |
| `urlToLocalFile` | `(u: QUrl): string` | `file://` URL → путь к файлу. |
| `urlScheme` | `(u: QUrl): string` | Схема (напр. `"https"`, `"file"`). |
| `urlHost` | `(u: QUrl): string` | Хост (напр. `"example.com"`). |
| `urlPath` | `(u: QUrl): string` | Путь (напр. `"/index.html"`). |
| `urlPort` | `(u: QUrl, default: int = -1): int` | Порт (-1 если не задан). |
| `urlQuery` | `(u: QUrl): string` | Query-строка (без `?`). |
| `urlFragment` | `(u: QUrl): string` | Фрагмент (без `#`). |
| `urlUserName` | `(u: QUrl): string` | Имя пользователя. |
| `urlPassword` | `(u: QUrl): string` | Пароль. |

### Проверки

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `urlIsValid` | `(u: QUrl): bool` | URL валиден? |
| `urlIsEmpty` | `(u: QUrl): bool` | URL пуст? |
| `urlIsLocalFile` | `(u: QUrl): bool` | `file://` URL? |
| `urlIsRelative` | `(u: QUrl): bool` | Относительный URL? |
| `urlErrorString` | `(u: QUrl): string` | Описание ошибки (если URL невалиден). |

### Операции

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `urlResolved` | `(base, relative: QUrl): QUrl` | Разрешить относительный URL относительно base. |
| `urlEncoded` | `(s: string): string` | Percent-encoding. `"hello world"` → `"hello%20world"`. |
| `urlDecoded` | `(s: string): string` | Декодировать percent-encoded строку. |
| `urlQueryParam` | `(u: QUrl, key: string): string` | Получить параметр query-строки по ключу. |
| `urlWithQueryParam` | `(u: QUrl, key, value: string): QUrl` | Вернуть URL с добавленным/заменённым параметром. |

---

## 13. QUuid ↔ string

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `newUuid` | `(): QUuid` | Сгенерировать UUID v4 (случайный). |
| `newUuidStr` | `(): string` | Сгенерировать UUID и сразу вернуть как строку без скобок. |
| `uuidToString` | `(u: QUuid): string` | UUID → `"{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}"`. |
| `uuidToStringNoBraces` | `(u: QUuid): string` | UUID без фигурных скобок. |
| `uuidToId128` | `(u: QUuid): string` | UUID как 32-символьная hex-строка без разделителей. |
| `uuidFromString` | `(s: string): QUuid` | Из строки (с фигурными скобками или без). |
| `uuidIsNull` | `(u: QUuid): bool` | Нулевой UUID? |
| `uuidVersion` | `(u: QUuid): int` | Версия UUID (1..5, или 0 если неизвестна). |

---

## 14. QJsonDocument / QJsonObject / QJsonArray / QJsonValue

### QJsonDocument

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonParse` | `(s: string): tuple[ok: bool, err: string, doc: QJsonDocument]` | Разобрать JSON-строку. При ошибке `ok=false` и `err` содержит описание. |
| `jsonToString` | `(doc: QJsonDocument, compact: bool = true): string` | Документ → строка. `compact=false` — с отступами. |
| `jsonToBytes` | `(doc: QJsonDocument): seq[byte]` | Документ → байты. |
| `jsonIsObject` | `(doc: QJsonDocument): bool` | Документ содержит объект? |
| `jsonIsArray` | `(doc: QJsonDocument): bool` | Документ содержит массив? |
| `jsonIsNull` | `(doc: QJsonDocument): bool` | Документ null? |
| `jsonObject` | `(doc: QJsonDocument): QJsonObject` | Получить корневой объект. |
| `jsonArray` | `(doc: QJsonDocument): QJsonArray` | Получить корневой массив. |
| `jsonDocFromObject` | `(obj: QJsonObject): QJsonDocument` | Обернуть объект в документ. |
| `jsonDocFromArray` | `(arr: QJsonArray): QJsonDocument` | Обернуть массив в документ. |

### QJsonObject

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonObjGet` | `(obj: QJsonObject, key: string): QJsonValue` | Получить значение по ключу. |
| `jsonObjSet` | `(obj: var QJsonObject, key: string, val: QJsonValue)` | Установить значение по ключу. |
| `jsonObjRemove` | `(obj: var QJsonObject, key: string)` | Удалить ключ. |
| `jsonObjContains` | `(obj: QJsonObject, key: string): bool` | Ключ существует? |
| `jsonObjSize` | `(obj: QJsonObject): int` | Количество ключей. |
| `jsonObjIsEmpty` | `(obj: QJsonObject): bool` | Объект пуст? |
| `jsonObjKeys` | `(obj: QJsonObject): seq[string]` | Все ключи объекта. |
| `jsonObjGetStr` | `(obj: QJsonObject, key: string, default: string = ""): string` | Строковое значение с fallback. |
| `jsonObjGetFloat` | `(obj: QJsonObject, key: string, default: float64 = 0.0): float64` | Float значение с fallback. |
| `jsonObjGetInt` | `(obj: QJsonObject, key: string, default: int = 0): int` | Int значение с fallback. |
| `jsonObjGetBool` | `(obj: QJsonObject, key: string, default: bool = false): bool` | Bool значение с fallback. |

### QJsonArray

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonArrSize` | `(arr: QJsonArray): int` | Количество элементов. |
| `jsonArrIsEmpty` | `(arr: QJsonArray): bool` | Массив пуст? |
| `jsonArrAt` | `(arr: QJsonArray, i: int): QJsonValue` | Элемент по индексу. |
| `jsonArrAppend` | `(arr: var QJsonArray, val: QJsonValue)` | Добавить в конец. |
| `jsonArrPrepend` | `(arr: var QJsonArray, val: QJsonValue)` | Добавить в начало. |
| `jsonArrRemoveAt` | `(arr: var QJsonArray, i: int)` | Удалить по индексу. |
| `jsonArrFirst` | `(arr: QJsonArray): QJsonValue` | Первый элемент. |
| `jsonArrLast` | `(arr: QJsonArray): QJsonValue` | Последний элемент. |

### QJsonValue — проверка типа

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonValIsString` | `(v: QJsonValue): bool` | Строка? |
| `jsonValIsDouble` | `(v: QJsonValue): bool` | Число? |
| `jsonValIsBool` | `(v: QJsonValue): bool` | Булево? |
| `jsonValIsNull` | `(v: QJsonValue): bool` | null? |
| `jsonValIsObject` | `(v: QJsonValue): bool` | Объект? |
| `jsonValIsArray` | `(v: QJsonValue): bool` | Массив? |
| `jsonValIsUndefined` | `(v: QJsonValue): bool` | Undefined? |

### QJsonValue — извлечение

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonValToString` | `(v: QJsonValue, default: string = ""): string` | → Nim string. |
| `jsonValToFloat` | `(v: QJsonValue, default: float64 = 0.0): float64` | → float64. |
| `jsonValToInt` | `(v: QJsonValue, default: int = 0): int` | → int. |
| `jsonValToInt64` | `(v: QJsonValue, default: int64 = 0): int64` | → int64. |
| `jsonValToBool` | `(v: QJsonValue, default: bool = false): bool` | → bool. |
| `jsonValToObject` | `(v: QJsonValue): QJsonObject` | → QJsonObject. |
| `jsonValToArray` | `(v: QJsonValue): QJsonArray` | → QJsonArray. |

### QJsonValue — конструкторы

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonValFromString` | `(s: string): QJsonValue` | Из string. |
| `jsonValFromFloat` | `(f: float64): QJsonValue` | Из float64. |
| `jsonValFromInt` | `(n: int64): QJsonValue` | Из int64. |
| `jsonValFromBool` | `(b: bool): QJsonValue` | Из bool. |
| `jsonValNull` | `(): QJsonValue` | JSON null. |
| `jsonValFromObject` | `(obj: QJsonObject): QJsonValue` | Из QJsonObject. |
| `jsonValFromArray` | `(arr: QJsonArray): QJsonValue` | Из QJsonArray. |

### Высокоуровневые JSON утилиты

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `jsonMakeObject` | `(kvPairs: openArray[tuple[key: string, val: string]]): string` | Быстро создать JSON-объект из пар ключ-строка. Возвращает компактную JSON-строку. |

**Пример:**
```nim
let json = jsonMakeObject([("name", "Alice"), ("age", "30")])
# → {"name":"Alice","age":"30"}
```

---

## 15. Общие утилиты

### Конвертации bool ↔ cint

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `nimBoolToQt` | `(b: bool): cint` | Nim `bool` → `cint` для `emit`-блоков. |
| `qtBoolToNim` | `(v: cint): bool` | `cint` из Qt → Nim `bool`. |

### Ограничение диапазона (clamp)

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `clampByte` | `(n: int): uint8` | Ограничить в [0, 255] → uint8. |
| `clampF` | `(v, lo, hi: float64): float64` | Ограничить float64 в [lo, hi]. |
| `clampI` | `(v, lo, hi: int): int` | Ограничить int в [lo, hi]. |

### Форматирование строк

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `qsFormat` | `(tmpl: string, args: varargs[string]): string` | Подстановка `%1`, `%2`, … → args[0], args[1], … |

**Пример:**
```nim
qsFormat("%1 из %2", "5", "10")  # → "5 из 10"
```

### Hex-конвертации

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `toHex` | `(n: int, digits: int = 0): string` | Int → hex-строка с префиксом `"0x"`. `digits` задаёт минимальную длину. |
| `hexToInt` | `(s: string): int` | Hex-строка (с/без `"0x"`) → int. |

### Интерполяция

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `lerp` | `(a, b, t: float64): float64` | Линейная интерполяция: `a + (b - a) * clamp(t, 0, 1)`. |
| `lerpI` | `(a, b: int, t: float64): int` | Линейная интерполяция для целых. |

### Степени двойки

| Функция | Сигнатура | Описание |
|---------|-----------|----------|
| `isPowerOf2` | `(n: int): bool` | Является ли `n` степенью двойки? |
| `nextPowerOf2` | `(n: int): int` | Следующая степень двойки ≥ n. |

---

## Примеры использования

### Работа со строками

```nim
import nimQtUtils

# Создание и конвертация
let q = qs("Привет, мир!")
echo $q                         # "Привет, мир!"
echo qsLen(q)                   # 12

# Операции
let upper = qsUpper(q)
let parts = qsSplitStr(q, ", ")
let joined = qslJoin(parts, " | ")

# Числа
let numStr = qsNumber(42)
let floatStr = qsNumberF(3.14159, 'f', 2)  # "3.14"

# Шаблоны
let tmpl = qs("Файл %1 из %2")
let result = qsArgInt(qsArgInt(tmpl, 5), 10)  # "Файл 5 из 10"
```

### Работа с цветом

```nim
# Создание цвета
let red = makeColor(255, 0, 0)
let blue = colorFromHex("#0000FF")
let mid = colorInterpolate(red, blue, 0.5)  # Фиолетовый

# Конвертации
echo colorToHex(red)              # "#ff0000"
let nc: NimColor = colorToTuple(blue)
let lighter = lighter(red, 150)
```

### Работа с JSON

```nim
let (ok, err, doc) = jsonParse("""{"name":"Alice","age":30}""")
if ok:
  let obj = jsonObject(doc)
  echo jsonObjGetStr(obj, "name")         # "Alice"
  echo jsonObjGetInt(obj, "age")          # 30
  echo jsonObjKeys(obj)                   # @["name", "age"]
```

### Работа с датой и временем

```nim
let now = currentDateTime()
echo dateTimeToIso(now)           # "2025-03-24T14:30:15"
echo currentTimeStr()             # "24.03.2025  14:30:15"

let tomorrow = dateAddDays(currentDate(), 1)
echo dateToString(tomorrow)       # "2025-03-25"
```

### Работа с URL

```nim
let url = toQUrl("https://example.com/api?key=value&page=1")
echo urlHost(url)               # "example.com"
echo urlPath(url)               # "/api"
echo urlQueryParam(url, "key") # "value"

let encoded = urlEncoded("hello world!")  # "hello%20world%21"
```

### Утилиты

```nim
echo lerp(0.0, 100.0, 0.25)   # 25.0
echo clampI(300, 0, 255)       # 255
echo isPowerOf2(64)            # true
echo nextPowerOf2(100)         # 128
echo newUuidStr()              # "550e8400-e29b-41d4-a716-446655440000"
```

---

## Настройка компилятора

Библиотека настроена для Windows/MSYS2 UCRT64. При необходимости адаптируйте пути:

```nim
# Заголовки Qt (Windows/MSYS2 UCRT64)
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

**Команда компиляции:**
```bash
nim cpp --passC:"-std=c++20" app.nim
```

---

*Конец справочника nimQtUtils (RU)*
