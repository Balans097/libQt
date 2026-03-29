# nimQtUtils — Library Reference

> **Version:** Qt6 / Nim  
> **File:** `nimQtUtils.nim`  
> **Compilation:** `nim cpp --passC:"-std=c++20" app.nim`  
> **Dependencies:** only `strutils` from the Nim standard library; sits at the lowest level after `nimQtFFI`.

---

## Table of Contents

1. [Base Opaque Qt Types](#1-base-opaque-qt-types)
2. [Nim-side Structures](#2-nim-side-structures)
3. [QString ↔ Nim string](#3-qstring--nim-string)
4. [QStringList ↔ seq\[string\]](#4-qstringlist--seqstring)
5. [QByteArray ↔ string / seq\[byte\]](#5-qbytearray--string--seqbyte)
6. [QVariant ↔ Nim types](#6-qvariant--nim-types)
7. [QColor ↔ NimColor / hex / HSV / HSL / CMYK](#7-qcolor--nimcolor--hex--hsv--hsl--cmyk)
8. [QPoint / QPointF ↔ NimPoint / NimPointF](#8-qpoint--qpointf--nimpoint--nimpointf)
9. [QSize / QSizeF ↔ NimSize / NimSizeF](#9-qsize--qsizef--nimsize--nimsizef)
10. [QRect / QRectF ↔ NimRect / NimRectF](#10-qrect--qrectf--nimrect--nimrectf)
11. [QDate / QTime / QDateTime](#11-qdate--qtime--qdatetime)
12. [QUrl ↔ string](#12-qurl--string)
13. [QUuid ↔ string](#13-quuid--string)
14. [QJsonDocument / QJsonObject / QJsonArray / QJsonValue](#14-qjsondocument--qjsonobject--qjsonarray--qjsonvalue)
15. [General Utilities](#15-general-utilities)

---

## Design Principles

- All functions returning strings use **local** (non-`static`) `QByteArray` objects — ensuring **thread-safety**.
- The null byte is used as a delimiter when passing string arrays via `QByteArray`/`QStringList` with no intermediate buffer.
- The API is maximally idiomatic for Nim: overloads, `result`, tuples.

---

## 1. Base Opaque Qt Types

All types are imported via `{.importcpp.}` and stored by value (value semantics; COW where applicable).

| Type | C++ Class | Description |
|------|-----------|-------------|
| `QString` | `QString` | Qt string (UTF-16 internally, Copy-On-Write). The primary string type for all widget APIs. |
| `QStringList` | `QStringList` | List of Qt strings (`QList<QString>`). |
| `QByteArray` | `QByteArray` | Byte array. Efficient for binary data and UTF-8. |
| `QVariant` | `QVariant` | Universal value type. Stores `QString`, `int`, `double`, `bool`, `QColor`, `QDateTime`, `QList<QVariant>`, and more. |
| `QColor` | `QColor` | Qt color (RGBA + HSV, HSL, CMYK support). |
| `QPoint` | `QPoint` | Point with integer coordinates. |
| `QPointF` | `QPointF` | Point with floating-point coordinates (`double`). |
| `QSize` | `QSize` | Size with integer components (width × height). |
| `QSizeF` | `QSizeF` | Size with floating-point components. |
| `QRect` | `QRect` | Rectangle with integer coordinates. |
| `QRectF` | `QRectF` | Rectangle with floating-point coordinates. |
| `QDate` | `QDate` | Date (without time). |
| `QTime` | `QTime` | Time of day (without date). |
| `QDateTime` | `QDateTime` | Date and time with optional time zone. |
| `QUrl` | `QUrl` | URL (web address, file path, Qt resource). |
| `QUuid` | `QUuid` | 128-bit UUID. |
| `QJsonDocument` | `QJsonDocument` | JSON document (top-level object or array). |
| `QJsonObject` | `QJsonObject` | JSON object (key→value dictionary). |
| `QJsonArray` | `QJsonArray` | JSON array. |
| `QJsonValue` | `QJsonValue` | JSON value (`null` / `bool` / `double` / `string` / `array` / `object`). |
| `QTimeZone` | `QTimeZone` | Qt time zone. |

---

## 2. Nim-side Structures

Lightweight Nim-side structures — alternatives to Qt value-types with no FFI overhead.

| Type | Definition | Description |
|------|------------|-------------|
| `NimPoint` | `tuple[x, y: int]` | Point with integer coordinates. |
| `NimPointF` | `tuple[x, y: float64]` | Point with floating-point coordinates. |
| `NimSize` | `tuple[w, h: int]` | Size with integer components. |
| `NimSizeF` | `tuple[w, h: float64]` | Size with floating-point components. |
| `NimRect` | `tuple[x, y, w, h: int]` | Rectangle with integer coordinates. |
| `NimRectF` | `tuple[x, y, w, h: float64]` | Rectangle with floating-point coordinates. |
| `NimColor` | `tuple[r, g, b, a: uint8]` | RGBA color (each channel 0..255). |
| `NimColorF` | `tuple[r, g, b, a: float64]` | RGBA color with floating-point components (0.0..1.0). |
| `NimColorHSV` | `tuple[h, s, v, a: int]` | HSV color (h: 0..359, s/v: 0..255, a: 0..255). |
| `NimColorHSL` | `tuple[h, s, l, a: int]` | HSL color (h: 0..359, s/l: 0..255, a: 0..255). |

---

## 3. QString ↔ Nim string

### Constructors and Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toQString` | `(s: string): QString` | Nim string (UTF-8) → QString. **The primary way to pass strings to Qt APIs.** |
| `toQString` | `(cs: cstring): QString` | C-string (UTF-8) → QString. |
| `toQStringLatin1` | `(s: string): QString` | Latin-1 string → QString. Only for Latin-1 sources. |
| `toQStringUtf16` | `(data: seq[uint16]): QString` | UTF-16 data → QString. |
| `nimStr` | `(q: QString): string` | QString → Nim string (UTF-8). Thread-safe. |
| `nimStrLatin1` | `(q: QString): string` | QString → Latin-1 string. |
| `qs` | `(s: string): QString` | Short constructor. **Example:** `widget.setText(qs("Hello"))` |
| `qs` | `(cs: cstring): QString` | Short constructor from C-string. |
| `$` | `(q: QString): string` | Conversion operator — for `echo`, formatting, etc. |

### String Properties

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsLen` | `(q: QString): int` | Length in UTF-16 characters (not bytes). |
| `qsIsEmpty` | `(q: QString): bool` | Is the string empty? |
| `qsIsNull` | `(q: QString): bool` | Is the string null? (different from empty). |

### String Modifications

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsTrimmed` | `(q: QString): QString` | Remove leading and trailing whitespace. |
| `qsSimplified` | `(q: QString): QString` | Remove leading/trailing whitespace; collapse internal runs to one space. |
| `qsUpper` | `(q: QString): QString` | Convert to uppercase (locale-aware). |
| `qsLower` | `(q: QString): QString` | Convert to lowercase (locale-aware). |
| `qsReplace` | `(q, before, after: QString): QString` | Replace all occurrences of `before` with `after`. |
| `qsReplaceStr` | `(q: QString, before, after: string): QString` | Same, with Nim strings. |
| `qsRepeat` | `(q: QString, n: int): QString` | Repeat string `n` times. |
| `qsMid` | `(q: QString, pos: int, len: int = -1): QString` | Substring from `pos` of length `len` (-1 = to end). |
| `qsLeft` | `(q: QString, n: int): QString` | First `n` characters. |
| `qsRight` | `(q: QString, n: int): QString` | Last `n` characters. |
| `qsAt` | `(q: QString, i: int): char` | Character at position `i` (as Latin-1 `char`). |

### Search

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsContains` | `(q, sub: QString, caseSensitive: bool = true): bool` | Does the string contain substring? |
| `qsContainsStr` | `(q: QString, sub: string, caseSensitive: bool = true): bool` | Same, with Nim string. |
| `qsStartsWith` | `(q, pre: QString, caseSensitive: bool = true): bool` | Does the string start with `pre`? |
| `qsEndsWith` | `(q, suf: QString, caseSensitive: bool = true): bool` | Does the string end with `suf`? |
| `qsIndexOf` | `(q, sub: QString, from: int = 0, caseSensitive: bool = true): int` | First occurrence of `sub` starting at `from`. Returns -1 if not found. |
| `qsLastIndexOf` | `(q, sub: QString, from: int = -1): int` | Last occurrence of `sub`. |

### Split and Join

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsSplit` | `(q, sep: QString, skipEmpty: bool = false): QStringList` | Split string by separator. |
| `qsSplitStr` | `(q: QString, sep: string, skipEmpty: bool = false): QStringList` | Same, with Nim string separator. |
| `qsJoin` | `(sl: QStringList, sep: QString): QString` | Join list with separator. |
| `qsJoinStr` | `(sl: QStringList, sep: string): QString` | Same, with Nim string separator. |

### Numeric Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsNumber` | `(n: int64): QString` | Integer → QString. |
| `qsNumber` | `(n: int): QString` | Integer → QString. |
| `qsNumberF` | `(f: float64, format: char = 'g', precision: int = -1): QString` | Float → QString. `format`: `'e'`=exponential, `'f'`=fixed, `'g'`=shortest. |
| `qsToInt` | `(q: QString, base: int = 10): tuple[ok: bool, val: int64]` | Parse as integer with validation. |
| `qsToFloat` | `(q: QString): tuple[ok: bool, val: float64]` | Parse as float with validation. |

### Formatting (arg-templates)

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsArgInt` | `(tmpl: QString, n: int64): QString` | Replace first `%1` with integer. |
| `qsArgStr` | `(tmpl: QString, s: QString): QString` | Replace first `%1` with string. |
| `qsArgF` | `(tmpl: QString, f: float64, fieldWidth: int = 0, fmt: char = 'g', precision: int = -1): QString` | Replace first `%1` with float. |

### Comparison and Operators

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsCompare` | `(a, b: QString, caseSensitive: bool = true): int` | Lexicographic comparison. `< 0` if `a < b`, `0` if equal, `> 0` if `a > b`. |
| `==` | `(a, b: QString): bool` | String equality. |
| `!=` | `(a, b: QString): bool` | String inequality. |
| `&` | `(a, b: QString): QString` | Concatenation. |
| `&` | `(a: QString, b: string): QString` | Concatenation with Nim string. |
| `&` | `(a: string, b: QString): QString` | Concatenation with Nim string. |

### Base64

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsToBase64` | `(q: QString): string` | String → Base64 (UTF-8 → base64). |
| `qsFromBase64` | `(b64: string): QString` | Base64 → QString. |

---

## 4. QStringList ↔ seq[string]

### Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toQStringList` | `(ss: openArray[string]): QStringList` | `seq[string]` → `QStringList`. |
| `toNimSeq` | `(sl: QStringList): seq[string]` | `QStringList` → `seq[string]`. Thread-safe. |

### List Modification

| Function | Signature | Description |
|----------|-----------|-------------|
| `qslAdd` | `(sl: var QStringList, s: QString)` | Append a string. |
| `qslAdd` | `(sl: var QStringList, s: string)` | Append a Nim string. |
| `qslRemoveAt` | `(sl: var QStringList, i: int)` | Remove element at index. |
| `qslSort` | `(sl: var QStringList, caseSensitive: bool = true)` | Sort the list. |
| `qslRemoveDuplicates` | `(sl: var QStringList): int` | Remove duplicates. Returns count removed. |

### Element Access

| Function | Signature | Description |
|----------|-----------|-------------|
| `qslSize` | `(sl: QStringList): int` | Number of elements. |
| `qslAt` | `(sl: QStringList, i: int): QString` | Element at index as `QString`. |
| `qslAtStr` | `(sl: QStringList, i: int): string` | Element at index as Nim `string`. |
| `qslIndexOf` | `(sl: QStringList, s: QString): int` | Index of string (-1 if not found). |

### Search and Filter

| Function | Signature | Description |
|----------|-----------|-------------|
| `qslContains` | `(sl: QStringList, s: QString, caseSensitive: bool = true): bool` | Is string in list? |
| `qslFilter` | `(sl: QStringList, rx: QString, caseSensitive: bool = true): QStringList` | Filter list by substring. |

### Join

| Function | Signature | Description |
|----------|-----------|-------------|
| `qslJoin` | `(sl: QStringList, sep: string): string` | Join list into Nim string. |

---

## 5. QByteArray ↔ string / seq[byte]

### Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `toQByteArray` | `(s: string): QByteArray` | Nim string → QByteArray (byte-for-byte, no re-encoding). |
| `toQByteArray` | `(data: openArray[byte]): QByteArray` | `seq[byte]` / `array[byte]` → QByteArray. |

### Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toNimString` | `(ba: QByteArray): string` | QByteArray → Nim string. Thread-safe. |
| `toNimBytes` | `(ba: QByteArray): seq[byte]` | QByteArray → `seq[byte]`. |

### Properties

| Function | Signature | Description |
|----------|-----------|-------------|
| `qbaSize` | `(ba: QByteArray): int` | Size in bytes. |
| `qbaIsEmpty` | `(ba: QByteArray): bool` | Is the array empty? |
| `qbaAt` | `(ba: QByteArray, i: int): byte` | Byte at index. |
| `qbaIndexOf` | `(ba: QByteArray, needle: string): int` | Find substring. |

### Modification

| Function | Signature | Description |
|----------|-----------|-------------|
| `qbaAppend` | `(ba: var QByteArray, other: QByteArray)` | Append to end. |
| `qbaPrepend` | `(ba: var QByteArray, other: QByteArray)` | Prepend to beginning. |
| `qbaMid` | `(ba: QByteArray, pos: int, len: int = -1): QByteArray` | Sub-array from `pos` of length `len`. |
| `qbaTrimmed` | `(ba: QByteArray): QByteArray` | Remove leading/trailing whitespace. |

### Encoding

| Function | Signature | Description |
|----------|-----------|-------------|
| `qbaToBase64` | `(ba: QByteArray): string` | Encode to Base64. |
| `qbaFromBase64` | `(b64: string): QByteArray` | Decode from Base64. |
| `qbaToHex` | `(ba: QByteArray, separator: char = '\0'): string` | To hex string. `separator=':'` → `"aa:bb:cc"`. |
| `qbaFromHex` | `(hex: string): QByteArray` | From hex string. |
| `qbaCompressed` | `(ba: QByteArray, level: int = -1): QByteArray` | Compress (zlib). `level`: -1=auto, 0..9. |
| `qbaUncompressed` | `(ba: QByteArray): QByteArray` | Decompress (zlib). |

---

## 6. QVariant ↔ Nim types

### Creating QVariant

| Function | Signature | Description |
|----------|-----------|-------------|
| `varFromInt` | `(n: int64): QVariant` | From `int64`. |
| `varFromInt` | `(n: int): QVariant` | From `int`. |
| `varFromUInt` | `(n: uint64): QVariant` | From `uint64`. |
| `varFromFloat` | `(f: float64): QVariant` | From `float64`. |
| `varFromFloat` | `(f: float32): QVariant` | From `float32`. |
| `varFromString` | `(s: string): QVariant` | From Nim string. |
| `varFromQString` | `(q: QString): QVariant` | From `QString`. |
| `varFromBool` | `(b: bool): QVariant` | From `bool`. |
| `varFromBytes` | `(data: string): QVariant` | From binary data (`QByteArray`). |

### Extracting from QVariant

| Function | Signature | Description |
|----------|-----------|-------------|
| `varToInt` | `(v: QVariant): int64` | Extract as `int64`. |
| `varToUInt` | `(v: QVariant): uint64` | Extract as `uint64`. |
| `varToFloat` | `(v: QVariant): float64` | Extract as `float64`. |
| `varToString` | `(v: QVariant): string` | Extract as Nim string. Thread-safe. |
| `varToBool` | `(v: QVariant): bool` | Extract as `bool`. |

### Inspecting QVariant

| Function | Signature | Description |
|----------|-----------|-------------|
| `varIsNull` | `(v: QVariant): bool` | Is the value null? |
| `varIsValid` | `(v: QVariant): bool` | Is the value valid? |
| `varTypeName` | `(v: QVariant): string` | Name of the stored type (e.g. `"QString"`, `"int"`, `"QColor"`). |
| `varCanConvertToString` | `(v: QVariant): bool` | Can the value be converted to string? |

---

## 7. QColor ↔ NimColor / hex / HSV / HSL / CMYK

### Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `makeColor` | `(r, g, b: uint8, a: uint8 = 255): QColor` | From RGBA (uint8, 0..255). |
| `makeColorI` | `(r, g, b: int, a: int = 255): QColor` | From RGBA (int, convenient for arithmetic). |
| `makeColorF` | `(r, g, b: float64, a: float64 = 1.0): QColor` | From RGBA float (0.0..1.0). |
| `colorFromHex` | `(hex: string): QColor` | From hex string: `"#rgb"`, `"#rrggbb"`, `"#aarrggbb"`, `"red"`, `"transparent"`. |
| `colorFromHsv` | `(h, s, v: int, a: int = 255): QColor` | From HSV (h: 0..359, s/v: 0..255, a: 0..255). |
| `colorFromHsvF` | `(h, s, v: float64, a: float64 = 1.0): QColor` | From HSV float (0.0..1.0). |
| `colorFromHsl` | `(h, s, l: int, a: int = 255): QColor` | From HSL (h: 0..359, s/l: 0..255, a: 0..255). |
| `colorFromHslF` | `(h, s, l: float64, a: float64 = 1.0): QColor` | From HSL float. |
| `colorFromCmyk` | `(c, m, y, k: int, a: int = 255): QColor` | From CMYK (0..255). |
| `colorFromTuple` | `(nc: NimColor): QColor` | From `NimColor`. |
| `colorFromTupleF` | `(nc: NimColorF): QColor` | From `NimColorF`. |
| `colorFromRgb32` | `(rgba: uint32): QColor` | From 32-bit `0xAARRGGBB`. |

### Component Getters (RGB)

| Function | Signature | Description |
|----------|-----------|-------------|
| `colorRed` | `(c: QColor): uint8` | Red channel (0..255). |
| `colorGreen` | `(c: QColor): uint8` | Green channel (0..255). |
| `colorBlue` | `(c: QColor): uint8` | Blue channel (0..255). |
| `colorAlpha` | `(c: QColor): uint8` | Alpha channel (0..255). |
| `colorRedF` | `(c: QColor): float64` | Red (0.0..1.0). |
| `colorGreenF` | `(c: QColor): float64` | Green (0.0..1.0). |
| `colorBlueF` | `(c: QColor): float64` | Blue (0.0..1.0). |
| `colorAlphaF` | `(c: QColor): float64` | Alpha (0.0..1.0). |

### Component Getters (HSV/HSL)

| Function | Signature | Description |
|----------|-----------|-------------|
| `colorHue` | `(c: QColor): int` | HSV hue (0..359; -1 if achromatic). |
| `colorSaturation` | `(c: QColor): int` | HSV saturation (0..255). |
| `colorValue` | `(c: QColor): int` | HSV value/brightness (0..255). |
| `colorHsv` | `(c: QColor): NimColorHSV` | Get color as HSV tuple. |
| `colorHsl` | `(c: QColor): NimColorHSL` | Get color as HSL tuple. |

### Conversions and Operations

| Function | Signature | Description |
|----------|-----------|-------------|
| `colorToHex` | `(c: QColor): string` | To `"#rrggbb"`. |
| `colorToHexA` | `(c: QColor): string` | To `"#aarrggbb"` (with alpha). |
| `colorToTuple` | `(c: QColor): NimColor` | To `NimColor` (RGBA uint8). |
| `colorToTupleF` | `(c: QColor): NimColorF` | To `NimColorF` (RGBA float64). |
| `colorToRgb32` | `(c: QColor): uint32` | To 32-bit `0xAARRGGBB`. |
| `isValidColor` | `(c: QColor): bool` | Is the color valid? (`false` for default `QColor()`). |
| `lighter` | `(c: QColor, factor: int = 150): QColor` | Lighten. `factor=150` → +50% brightness. |
| `darker` | `(c: QColor, factor: int = 200): QColor` | Darken. `factor=200` → -50% brightness. |
| `colorSetAlpha` | `(c: QColor, a: int): QColor` | Return color with new alpha (0..255). |
| `colorSetAlphaF` | `(c: QColor, a: float64): QColor` | Return color with new alpha (0.0..1.0). |
| `colorInterpolate` | `(c1, c2: QColor, t: float64): QColor` | Linear interpolation. `t=0.0` → c1, `t=1.0` → c2. |

---

## 8. QPoint / QPointF ↔ NimPoint / NimPointF

### Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `makePoint` | `(x, y: int): QPoint` | Create a `QPoint`. |
| `makePointF` | `(x, y: float64): QPointF` | Create a `QPointF`. |

### Getters

| Function | Signature | Description |
|----------|-----------|-------------|
| `pointX` | `(p: QPoint): int` | X coordinate. |
| `pointY` | `(p: QPoint): int` | Y coordinate. |
| `pointFX` | `(p: QPointF): float64` | X coordinate (float). |
| `pointFY` | `(p: QPointF): float64` | Y coordinate (float). |

### Metrics

| Function | Signature | Description |
|----------|-----------|-------------|
| `pointManhattan` | `(p: QPoint): int` | Manhattan length (\|x\| + \|y\|). |
| `pointFLengthSq` | `(p: QPointF): float64` | Squared distance from origin (no `sqrt`). |
| `pointFLength` | `(p: QPointF): float64` | Distance from origin. |
| `pointFDot` | `(a, b: QPointF): float64` | Dot product of two vectors. |

### Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toNimPoint` | `(p: QPoint): NimPoint` | QPoint → NimPoint. |
| `toNimPointF` | `(p: QPointF): NimPointF` | QPointF → NimPointF. |
| `toQPoint` | `(p: NimPoint): QPoint` | NimPoint → QPoint. |
| `toQPointF` | `(p: NimPointF): QPointF` | NimPointF → QPointF. |
| `pointFToPoint` | `(p: QPointF): QPoint` | Round QPointF to QPoint. |
| `pointToPointF` | `(p: QPoint): QPointF` | QPoint → QPointF. |

### Arithmetic

| Function | Signature | Description |
|----------|-----------|-------------|
| `pointAdd` | `(a, b: QPoint): QPoint` | Add two points. |
| `pointSub` | `(a, b: QPoint): QPoint` | Subtract two points. |
| `pointFAdd` | `(a, b: QPointF): QPointF` | Add two float points. |
| `pointFSub` | `(a, b: QPointF): QPointF` | Subtract two float points. |

---

## 9. QSize / QSizeF ↔ NimSize / NimSizeF

### Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `makeSize` | `(w, h: int): QSize` | Create a `QSize`. |
| `makeSizeF` | `(w, h: float64): QSizeF` | Create a `QSizeF`. |

### Getters

| Function | Signature | Description |
|----------|-----------|-------------|
| `sizeW` | `(s: QSize): int` | Width. |
| `sizeH` | `(s: QSize): int` | Height. |
| `sizeFW` | `(s: QSizeF): float64` | Width (float). |
| `sizeFH` | `(s: QSizeF): float64` | Height (float). |
| `sizeArea` | `(s: QSize): int` | Area (`w * h`). |

### State

| Function | Signature | Description |
|----------|-----------|-------------|
| `sizeIsEmpty` | `(s: QSize): bool` | At least one side ≤ 0? |
| `sizeIsNull` | `(s: QSize): bool` | Both sides == 0? |
| `sizeIsValid` | `(s: QSize): bool` | Both sides > 0? |

### Operations

| Function | Signature | Description |
|----------|-----------|-------------|
| `sizeTransposed` | `(s: QSize): QSize` | Swap width and height. |
| `sizeExpanded` | `(a, b: QSize): QSize` | Element-wise maximum (largest sides). |
| `sizeBounded` | `(a, b: QSize): QSize` | Element-wise minimum (smallest sides). |
| `sizeScaled` | `(s: QSize, targetW, targetH: int, mode: cint): QSize` | Scale with aspect ratio mode. `mode`: 0=IgnoreAspectRatio, 1=KeepAspectRatio, 2=KeepAspectRatioByExpanding. |

### Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toNimSize` | `(s: QSize): NimSize` | QSize → NimSize. |
| `toNimSizeF` | `(s: QSizeF): NimSizeF` | QSizeF → NimSizeF. |
| `toQSize` | `(s: NimSize): QSize` | NimSize → QSize. |
| `toQSizeF` | `(s: NimSizeF): QSizeF` | NimSizeF → QSizeF. |
| `sizeFToSize` | `(s: QSizeF): QSize` | QSizeF → QSize (rounded). |
| `sizeToSizeF` | `(s: QSize): QSizeF` | QSize → QSizeF. |

---

## 10. QRect / QRectF ↔ NimRect / NimRectF

### Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `makeRect` | `(x, y, w, h: int): QRect` | Create a `QRect`. |
| `makeRectF` | `(x, y, w, h: float64): QRectF` | Create a `QRectF`. |

### QRect Getters

| Function | Signature | Description |
|----------|-----------|-------------|
| `rectX` | `(r: QRect): int` | X coordinate of left edge. |
| `rectY` | `(r: QRect): int` | Y coordinate of top edge. |
| `rectW` | `(r: QRect): int` | Width. |
| `rectH` | `(r: QRect): int` | Height. |
| `rectLeft` | `(r: QRect): int` | Left edge. |
| `rectRight` | `(r: QRect): int` | Right edge. |
| `rectTop` | `(r: QRect): int` | Top edge. |
| `rectBottom` | `(r: QRect): int` | Bottom edge. |

### QRect State

| Function | Signature | Description |
|----------|-----------|-------------|
| `rectIsEmpty` | `(r: QRect): bool` | Is the rectangle empty? |
| `rectIsNull` | `(r: QRect): bool` | Is the rectangle null? |
| `rectIsValid` | `(r: QRect): bool` | Is the rectangle valid? |

### QRect Operations

| Function | Signature | Description |
|----------|-----------|-------------|
| `rectContainsPoint` | `(r: QRect, x, y: int): bool` | Does rect contain point (x, y)? |
| `rectContains` | `(r: QRect, p: QPoint): bool` | Does rect contain `QPoint`? |
| `rectContainsRect` | `(r, other: QRect): bool` | Does rect contain another rect? |
| `rectIntersects` | `(a, b: QRect): bool` | Do rects intersect? |
| `rectUnited` | `(a, b: QRect): QRect` | Smallest bounding rectangle containing both. |
| `rectIntersected` | `(a, b: QRect): QRect` | Intersection of two rectangles. |
| `rectCenter` | `(r: QRect): QPoint` | Center point. |
| `rectNormalized` | `(r: QRect): QRect` | Normalize (make w and h positive). |
| `rectAdjusted` | `(r: QRect, dx1, dy1, dx2, dy2: int): QRect` | Expand/shrink sides. |
| `rectTranslated` | `(r: QRect, dx, dy: int): QRect` | Translate the rectangle. |
| `rectMovedTo` | `(r: QRect, x, y: int): QRect` | Move to (x, y) preserving size. |

### QRect / QRectF Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toNimRect` | `(r: QRect): NimRect` | QRect → NimRect. |
| `toQRect` | `(r: NimRect): QRect` | NimRect → QRect. |
| `toNimRectF` | `(r: QRectF): NimRectF` | QRectF → NimRectF. |
| `toQRectF` | `(r: NimRectF): QRectF` | NimRectF → QRectF. |
| `rectToRectF` | `(r: QRect): QRectF` | QRect → QRectF. |
| `rectFToRect` | `(r: QRectF): QRect` | QRectF → QRect (rounded). |
| `rectFToAlignedRect` | `(r: QRectF): QRect` | QRectF → QRect (aligned). |

### QRectF Getters and Operations

Analogous to QRect with the `F` suffix: `rectFX`, `rectFY`, `rectFW`, `rectFH`, `rectFLeft`, `rectFRight`, `rectFTop`, `rectFBottom`, `rectFContainsPoint`, `rectFIntersects`, `rectFUnited`, `rectFIntersected`, `rectFAdjusted`.

---

## 11. QDate / QTime / QDateTime

### Current Values

| Function | Signature | Description |
|----------|-----------|-------------|
| `currentDate` | `(): QDate` | Current date (local time zone). |
| `currentTime` | `(): QTime` | Current time (local time zone). |
| `currentDateTime` | `(): QDateTime` | Current date and time (local time zone). |
| `currentDateTimeUtc` | `(): QDateTime` | Current date and time in UTC. |
| `currentMsecsSinceEpoch` | `(): int64` | Milliseconds since Unix epoch (01 Jan 1970 UTC). |
| `currentSecsSinceEpoch` | `(): int64` | Seconds since Unix epoch. |
| `currentTimeStr` | `(fmt: string = "dd.MM.yyyy  HH:mm:ss"): string` | Current time as a formatted string. |

### QDate — Constructor and Parsing

| Function | Signature | Description |
|----------|-----------|-------------|
| `makeDate` | `(year, month, day: int): QDate` | Create from components. |
| `dateFromString` | `(s: string, fmt: string = "yyyy-MM-dd"): QDate` | Parse from string with format. |
| `dateIsLeapYear` | `(year: int): bool` | Is the year a leap year? |

### QDate — Formatting and Components

| Function | Signature | Description |
|----------|-----------|-------------|
| `dateToString` | `(d: QDate, fmt: string = "yyyy-MM-dd"): string` | Format date. Masks: `yyyy`/`yy`, `MM`/`M`, `dd`/`d`, `ddd`/`dddd`. |
| `dateYMD` | `(d: QDate): tuple[y, m, day: int]` | Get year, month, day in one call. |
| `dateYear` | `(d: QDate): int` | Year. |
| `dateMonth` | `(d: QDate): int` | Month (1..12). |
| `dateDay` | `(d: QDate): int` | Day of month. |
| `dateDayOfWeek` | `(d: QDate): int` | Day of week (1=Mon, 7=Sun, ISO 8601). |
| `dateDayOfYear` | `(d: QDate): int` | Day of year. |
| `dateDaysInMonth` | `(d: QDate): int` | Days in month. |
| `dateDaysInYear` | `(d: QDate): int` | Days in year. |
| `dateIsValid` | `(d: QDate): bool` | Is the date valid? |

### QDate — Arithmetic

| Function | Signature | Description |
|----------|-----------|-------------|
| `dateDaysTo` | `(a, b: QDate): int` | Number of days from a to b. |
| `dateAddDays` | `(d: QDate, n: int): QDate` | Add days. |
| `dateAddMonths` | `(d: QDate, n: int): QDate` | Add months. |
| `dateAddYears` | `(d: QDate, n: int): QDate` | Add years. |

### QTime — Constructor and Parsing

| Function | Signature | Description |
|----------|-----------|-------------|
| `makeTime` | `(h, m, s: int, ms: int = 0): QTime` | Create from components. |
| `timeFromString` | `(s: string, fmt: string = "HH:mm:ss"): QTime` | Parse from string with format. |

### QTime — Components and Arithmetic

| Function | Signature | Description |
|----------|-----------|-------------|
| `timeToString` | `(t: QTime, fmt: string = "HH:mm:ss"): string` | Format time. |
| `timeHour` | `(t: QTime): int` | Hours (0..23). |
| `timeMin` | `(t: QTime): int` | Minutes (0..59). |
| `timeSec` | `(t: QTime): int` | Seconds (0..59). |
| `timeMsec` | `(t: QTime): int` | Milliseconds (0..999). |
| `timeMsecDay` | `(t: QTime): int` | Milliseconds since start of day. |
| `timeSecsTo` | `(a, b: QTime): int` | Seconds from a to b. |
| `timeMsecsTo` | `(a, b: QTime): int` | Milliseconds from a to b. |
| `timeAddSecs` | `(t: QTime, s: int): QTime` | Add seconds. |
| `timeAddMsecs` | `(t: QTime, ms: int): QTime` | Add milliseconds. |
| `timeIsValid` | `(t: QTime): bool` | Is the time valid? |

### QDateTime — Constructor and Parsing

| Function | Signature | Description |
|----------|-----------|-------------|
| `makeDateTime` | `(year, month, day: int, h: int = 0, m: int = 0, s: int = 0, ms: int = 0): QDateTime` | Create from components (local time zone). |
| `dateTimeFromString` | `(s: string, fmt: string = "yyyy-MM-dd HH:mm:ss"): QDateTime` | Parse from string. |
| `dateTimeFromIso` | `(s: string): QDateTime` | Parse ISO 8601 string. |
| `dateTimeFromMsec` | `(ms: int64): QDateTime` | From Unix timestamp (ms). |
| `dateTimeFromSec` | `(s: int64): QDateTime` | From Unix timestamp (s). |

### QDateTime — Formatting

| Function | Signature | Description |
|----------|-----------|-------------|
| `dateTimeToString` | `(dt: QDateTime, fmt: string = "yyyy-MM-dd HH:mm:ss"): string` | Format with pattern. |
| `dateTimeToIso` | `(dt: QDateTime): string` | ISO 8601 without ms (`"yyyy-MM-ddTHH:mm:ss"`). |
| `dateTimeToIsoMs` | `(dt: QDateTime): string` | ISO 8601 with ms (`"yyyy-MM-ddTHH:mm:ss.zzz"`). |
| `dateTimeToMsec` | `(dt: QDateTime): int64` | Unix timestamp in ms. |
| `dateTimeToSec` | `(dt: QDateTime): int64` | Unix timestamp in s. |
| `dateTimeOffset` | `(dt: QDateTime): int` | Offset from UTC in seconds. |

### QDateTime — Operations

| Function | Signature | Description |
|----------|-----------|-------------|
| `dateTimeDate` | `(dt: QDateTime): QDate` | Extract date. |
| `dateTimeTime` | `(dt: QDateTime): QTime` | Extract time. |
| `dateTimeAddSecs` | `(dt: QDateTime, s: int64): QDateTime` | Add seconds. |
| `dateTimeAddMsecs` | `(dt: QDateTime, ms: int64): QDateTime` | Add milliseconds. |
| `dateTimeAddDays` | `(dt: QDateTime, d: int64): QDateTime` | Add days. |
| `dateTimeAddMonths` | `(dt: QDateTime, m: int): QDateTime` | Add months. |
| `dateTimeAddYears` | `(dt: QDateTime, y: int): QDateTime` | Add years. |
| `dateTimeSecsTo` | `(a, b: QDateTime): int64` | Seconds from a to b. |
| `dateTimeMsecsTo` | `(a, b: QDateTime): int64` | Milliseconds from a to b. |
| `dateTimeIsValid` | `(dt: QDateTime): bool` | Is the datetime valid? |
| `dateTimeIsNull` | `(dt: QDateTime): bool` | Is the datetime null? |
| `dateTimeToUtc` | `(dt: QDateTime): QDateTime` | Convert to UTC. |
| `dateTimeToLocalTime` | `(dt: QDateTime): QDateTime` | Convert to local time zone. |

---

## 12. QUrl ↔ string

### Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `toQUrl` | `(s: string): QUrl` | From string. Format auto-detected. |
| `toQUrlStrict` | `(s: string): QUrl` | From string with strict validation. |
| `urlFromLocalFile` | `(path: string): QUrl` | `file://` URL from file path. |

### Conversions and Components

| Function | Signature | Description |
|----------|-----------|-------------|
| `urlToString` | `(u: QUrl, options: cint = 0): string` | URL → string. `options`: `QUrl::FormattingOptions`. |
| `urlToLocalFile` | `(u: QUrl): string` | `file://` URL → file path. |
| `urlScheme` | `(u: QUrl): string` | Scheme (e.g. `"https"`, `"file"`). |
| `urlHost` | `(u: QUrl): string` | Host (e.g. `"example.com"`). |
| `urlPath` | `(u: QUrl): string` | Path (e.g. `"/index.html"`). |
| `urlPort` | `(u: QUrl, default: int = -1): int` | Port (-1 if not set). |
| `urlQuery` | `(u: QUrl): string` | Query string (without `?`). |
| `urlFragment` | `(u: QUrl): string` | Fragment (without `#`). |
| `urlUserName` | `(u: QUrl): string` | User name. |
| `urlPassword` | `(u: QUrl): string` | Password. |

### Validation

| Function | Signature | Description |
|----------|-----------|-------------|
| `urlIsValid` | `(u: QUrl): bool` | Is the URL valid? |
| `urlIsEmpty` | `(u: QUrl): bool` | Is the URL empty? |
| `urlIsLocalFile` | `(u: QUrl): bool` | Is it a `file://` URL? |
| `urlIsRelative` | `(u: QUrl): bool` | Is it a relative URL? |
| `urlErrorString` | `(u: QUrl): string` | Error description (if URL is invalid). |

### Operations

| Function | Signature | Description |
|----------|-----------|-------------|
| `urlResolved` | `(base, relative: QUrl): QUrl` | Resolve relative URL against base. |
| `urlEncoded` | `(s: string): string` | Percent-encoding. `"hello world"` → `"hello%20world"`. |
| `urlDecoded` | `(s: string): string` | Decode percent-encoded string. |
| `urlQueryParam` | `(u: QUrl, key: string): string` | Get query parameter by key. |
| `urlWithQueryParam` | `(u: QUrl, key, value: string): QUrl` | Return URL with added/replaced query parameter. |

---

## 13. QUuid ↔ string

| Function | Signature | Description |
|----------|-----------|-------------|
| `newUuid` | `(): QUuid` | Generate UUID v4 (random). |
| `newUuidStr` | `(): string` | Generate UUID and immediately return as string without braces. |
| `uuidToString` | `(u: QUuid): string` | UUID → `"{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}"`. |
| `uuidToStringNoBraces` | `(u: QUuid): string` | UUID without curly braces. |
| `uuidToId128` | `(u: QUuid): string` | UUID as 32-character hex string without separators. |
| `uuidFromString` | `(s: string): QUuid` | From string (with or without curly braces). |
| `uuidIsNull` | `(u: QUuid): bool` | Is it a null UUID? |
| `uuidVersion` | `(u: QUuid): int` | UUID version (1..5, or 0 if unknown). |

---

## 14. QJsonDocument / QJsonObject / QJsonArray / QJsonValue

### QJsonDocument

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonParse` | `(s: string): tuple[ok: bool, err: string, doc: QJsonDocument]` | Parse JSON string. On error `ok=false` and `err` contains description. |
| `jsonToString` | `(doc: QJsonDocument, compact: bool = true): string` | Document → string. `compact=false` adds indentation. |
| `jsonToBytes` | `(doc: QJsonDocument): seq[byte]` | Document → bytes. |
| `jsonIsObject` | `(doc: QJsonDocument): bool` | Is the document an object? |
| `jsonIsArray` | `(doc: QJsonDocument): bool` | Is the document an array? |
| `jsonIsNull` | `(doc: QJsonDocument): bool` | Is the document null? |
| `jsonObject` | `(doc: QJsonDocument): QJsonObject` | Get root object. |
| `jsonArray` | `(doc: QJsonDocument): QJsonArray` | Get root array. |
| `jsonDocFromObject` | `(obj: QJsonObject): QJsonDocument` | Wrap object in document. |
| `jsonDocFromArray` | `(arr: QJsonArray): QJsonDocument` | Wrap array in document. |

### QJsonObject

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonObjGet` | `(obj: QJsonObject, key: string): QJsonValue` | Get value by key. |
| `jsonObjSet` | `(obj: var QJsonObject, key: string, val: QJsonValue)` | Set value by key. |
| `jsonObjRemove` | `(obj: var QJsonObject, key: string)` | Remove key. |
| `jsonObjContains` | `(obj: QJsonObject, key: string): bool` | Does key exist? |
| `jsonObjSize` | `(obj: QJsonObject): int` | Number of keys. |
| `jsonObjIsEmpty` | `(obj: QJsonObject): bool` | Is the object empty? |
| `jsonObjKeys` | `(obj: QJsonObject): seq[string]` | All keys of the object. |
| `jsonObjGetStr` | `(obj: QJsonObject, key: string, default: string = ""): string` | String value with fallback. |
| `jsonObjGetFloat` | `(obj: QJsonObject, key: string, default: float64 = 0.0): float64` | Float value with fallback. |
| `jsonObjGetInt` | `(obj: QJsonObject, key: string, default: int = 0): int` | Int value with fallback. |
| `jsonObjGetBool` | `(obj: QJsonObject, key: string, default: bool = false): bool` | Bool value with fallback. |

### QJsonArray

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonArrSize` | `(arr: QJsonArray): int` | Number of elements. |
| `jsonArrIsEmpty` | `(arr: QJsonArray): bool` | Is the array empty? |
| `jsonArrAt` | `(arr: QJsonArray, i: int): QJsonValue` | Element at index. |
| `jsonArrAppend` | `(arr: var QJsonArray, val: QJsonValue)` | Append to end. |
| `jsonArrPrepend` | `(arr: var QJsonArray, val: QJsonValue)` | Prepend to beginning. |
| `jsonArrRemoveAt` | `(arr: var QJsonArray, i: int)` | Remove at index. |
| `jsonArrFirst` | `(arr: QJsonArray): QJsonValue` | First element. |
| `jsonArrLast` | `(arr: QJsonArray): QJsonValue` | Last element. |

### QJsonValue — Type Checks

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonValIsString` | `(v: QJsonValue): bool` | Is it a string? |
| `jsonValIsDouble` | `(v: QJsonValue): bool` | Is it a number? |
| `jsonValIsBool` | `(v: QJsonValue): bool` | Is it a boolean? |
| `jsonValIsNull` | `(v: QJsonValue): bool` | Is it null? |
| `jsonValIsObject` | `(v: QJsonValue): bool` | Is it an object? |
| `jsonValIsArray` | `(v: QJsonValue): bool` | Is it an array? |
| `jsonValIsUndefined` | `(v: QJsonValue): bool` | Is it undefined? |

### QJsonValue — Extraction

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonValToString` | `(v: QJsonValue, default: string = ""): string` | → Nim string. |
| `jsonValToFloat` | `(v: QJsonValue, default: float64 = 0.0): float64` | → float64. |
| `jsonValToInt` | `(v: QJsonValue, default: int = 0): int` | → int. |
| `jsonValToInt64` | `(v: QJsonValue, default: int64 = 0): int64` | → int64. |
| `jsonValToBool` | `(v: QJsonValue, default: bool = false): bool` | → bool. |
| `jsonValToObject` | `(v: QJsonValue): QJsonObject` | → QJsonObject. |
| `jsonValToArray` | `(v: QJsonValue): QJsonArray` | → QJsonArray. |

### QJsonValue — Constructors

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonValFromString` | `(s: string): QJsonValue` | From string. |
| `jsonValFromFloat` | `(f: float64): QJsonValue` | From float64. |
| `jsonValFromInt` | `(n: int64): QJsonValue` | From int64. |
| `jsonValFromBool` | `(b: bool): QJsonValue` | From bool. |
| `jsonValNull` | `(): QJsonValue` | JSON null value. |
| `jsonValFromObject` | `(obj: QJsonObject): QJsonValue` | From QJsonObject. |
| `jsonValFromArray` | `(arr: QJsonArray): QJsonValue` | From QJsonArray. |

### High-level JSON Utilities

| Function | Signature | Description |
|----------|-----------|-------------|
| `jsonMakeObject` | `(kvPairs: openArray[tuple[key: string, val: string]]): string` | Quickly create JSON object from key-string pairs. Returns compact JSON string. |

**Example:**
```nim
let json = jsonMakeObject([("name", "Alice"), ("age", "30")])
# → {"name":"Alice","age":"30"}
```

---

## 15. General Utilities

### Bool ↔ cint Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `nimBoolToQt` | `(b: bool): cint` | Nim `bool` → `cint` for use in `emit` blocks. |
| `qtBoolToNim` | `(v: cint): bool` | `cint` from Qt → Nim `bool`. |

### Clamping

| Function | Signature | Description |
|----------|-----------|-------------|
| `clampByte` | `(n: int): uint8` | Clamp to [0, 255] → uint8. |
| `clampF` | `(v, lo, hi: float64): float64` | Clamp float64 to [lo, hi]. |
| `clampI` | `(v, lo, hi: int): int` | Clamp int to [lo, hi]. |

### String Formatting

| Function | Signature | Description |
|----------|-----------|-------------|
| `qsFormat` | `(tmpl: string, args: varargs[string]): string` | Substitute `%1`, `%2`, … with args[0], args[1], … |

**Example:**
```nim
qsFormat("%1 of %2", "5", "10")  # → "5 of 10"
```

### Hex Conversions

| Function | Signature | Description |
|----------|-----------|-------------|
| `toHex` | `(n: int, digits: int = 0): string` | Int → hex string with `"0x"` prefix. `digits` sets minimum length. |
| `hexToInt` | `(s: string): int` | Hex string (with or without `"0x"`) → int. |

### Interpolation

| Function | Signature | Description |
|----------|-----------|-------------|
| `lerp` | `(a, b, t: float64): float64` | Linear interpolation: `a + (b - a) * clamp(t, 0, 1)`. |
| `lerpI` | `(a, b: int, t: float64): int` | Linear interpolation for integers. |

### Powers of Two

| Function | Signature | Description |
|----------|-----------|-------------|
| `isPowerOf2` | `(n: int): bool` | Is `n` a power of two? |
| `nextPowerOf2` | `(n: int): int` | Next power of two ≥ n. |

---

## Usage Examples

### String Operations

```nim
import nimQtUtils

# Creation and conversion
let q = qs("Hello, world!")
echo $q                         # "Hello, world!"
echo qsLen(q)                   # 13

# Operations
let upper = qsUpper(q)
let parts = qsSplitStr(q, ", ")
let joined = qslJoin(parts, " | ")

# Numbers
let numStr = qsNumber(42)
let floatStr = qsNumberF(3.14159, 'f', 2)  # "3.14"

# Templates
let tmpl = qs("File %1 of %2")
let result = qsArgInt(qsArgInt(tmpl, 5), 10)  # "File 5 of 10"
```

### Color Operations

```nim
# Creating colors
let red = makeColor(255, 0, 0)
let blue = colorFromHex("#0000FF")
let mid = colorInterpolate(red, blue, 0.5)  # Purple

# Conversions
echo colorToHex(red)              # "#ff0000"
let nc: NimColor = colorToTuple(blue)
let lighter = lighter(red, 150)
```

### JSON Operations

```nim
let (ok, err, doc) = jsonParse("""{"name":"Alice","age":30}""")
if ok:
  let obj = jsonObject(doc)
  echo jsonObjGetStr(obj, "name")         # "Alice"
  echo jsonObjGetInt(obj, "age")          # 30
  echo jsonObjKeys(obj)                   # @["name", "age"]
```

### Date and Time Operations

```nim
let now = currentDateTime()
echo dateTimeToIso(now)           # "2025-03-24T14:30:15"
echo currentTimeStr()             # "24.03.2025  14:30:15"

let tomorrow = dateAddDays(currentDate(), 1)
echo dateToString(tomorrow)       # "2025-03-25"
```

### URL Operations

```nim
let url = toQUrl("https://example.com/api?key=value&page=1")
echo urlHost(url)               # "example.com"
echo urlPath(url)               # "/api"
echo urlQueryParam(url, "key") # "value"

let encoded = urlEncoded("hello world!")  # "hello%20world%21"
```

### Utilities

```nim
echo lerp(0.0, 100.0, 0.25)   # 25.0
echo clampI(300, 0, 255)       # 255
echo isPowerOf2(64)            # true
echo nextPowerOf2(100)         # 128
echo newUuidStr()              # "550e8400-e29b-41d4-a716-446655440000"
```

---

## Compiler Configuration

The library is configured for Windows/MSYS2 UCRT64. Adjust paths as needed:

```nim
# Qt header paths (Windows/MSYS2 UCRT64)
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

**Compilation command:**
```bash
nim cpp --passC:"-std=c++20" app.nim
```

---

*End of nimQtUtils reference (EN)*
