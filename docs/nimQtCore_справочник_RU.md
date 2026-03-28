# nimQtCore — Полный справочник библиотеки

> **Версия:** Qt6Core · **Компилятор:** `nim cpp --passC:"-std=c++20"`  
> **Зависимости:** `nimQtUtils` (типы), `nimQtFFI` (константы)  
> **Платформа:** MSYS2/UCRT64 (Windows), Qt 6.x

---

## Содержание

1. [Конфигурация компилятора](#конфигурация-компилятора)
2. [Типы и псевдонимы](#типы-и-псевдонимы)
3. [QCoreApplication](#qcoreapplication)
4. [QObject](#qobject)
5. [QTimer](#qtimer)
6. [QElapsedTimer](#qelapsedtimer)
7. [QEventLoop](#qeventloop)
8. [QThread](#qthread)
9. [QMutex](#qmutex)
10. [QReadWriteLock](#qreadwritelock)
11. [QSemaphore](#qsemaphore)
12. [QSettings](#qsettings)
13. [QFile](#qfile)
14. [QDir](#qdir)
15. [QFileInfo](#qfileinfo)
16. [QCryptographicHash](#qcryptographichash)
17. [QProcess](#qprocess)
18. [QRegularExpression](#qregularexpression)
19. [QLocale](#qlocale)
20. [QThreadPool](#qthreadpool)
21. [QMimeDatabase / QMimeType](#qmimedatabase--qmimetype)
22. [QLine / QLineF](#qline--qlinef)
23. [QMargins / QMarginsF](#qmargins--qmarginsf)
24. [QSortFilterProxyModel](#qsortfilterproxymodel)
25. [QModelIndex](#qmodelindex)
26. [QTranslator](#qtranslator)
27. [Утилиты быстрого ввода-вывода](#утилиты-быстрого-ввода-вывода)

---

## Конфигурация компилятора

Библиотека автоматически передаёт все необходимые флаги компилятору при импорте:

```nim
{.passC: "-IC:/msys64/ucrt64/include".}
{.passC: "-IC:/msys64/ucrt64/include/qt6".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtWidgets".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtGui".}
{.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
{.passC: "-DQT_WIDGETS_LIB -DQT_GUI_LIB -DQT_CORE_LIB".}
{.passL: "-LC:/msys64/ucrt64/lib -lQt6Widgets -lQt6Gui -lQt6Core".}
```

---

## Типы и псевдонимы

### Opaque-типы Qt

Все типы Qt экспортируются как opaque C++-объекты. Работа с ними ведётся **через указатели**.

| Nim-тип | Qt-класс | Заголовок |
|---|---|---|
| `QCoreApplication` | `QCoreApplication` | `<QCoreApplication>` |
| `QObject` | `QObject` | `<QObject>` |
| `QThread` | `QThread` | `<QThread>` |
| `QMutex` | `QMutex` | `<QMutex>` |
| `QReadWriteLock` | `QReadWriteLock` | `<QReadWriteLock>` |
| `QSemaphore` | `QSemaphore` | `<QSemaphore>` |
| `QWaitCondition` | `QWaitCondition` | `<QWaitCondition>` |
| `QTimer` | `QTimer` | `<QTimer>` |
| `QElapsedTimer` | `QElapsedTimer` | `<QElapsedTimer>` |
| `QSettings` | `QSettings` | `<QSettings>` |
| `QCommandLineParser` | `QCommandLineParser` | `<QCommandLineParser>` |
| `QCommandLineOption` | `QCommandLineOption` | `<QCommandLineOption>` |
| `QEventLoop` | `QEventLoop` | `<QEventLoop>` |
| `QEvent` | `QEvent` | `<QEvent>` |
| `QFile` | `QFile` | `<QFile>` |
| `QDir` | `QDir` | `<QDir>` |
| `QFileInfo` | `QFileInfo` | `<QFileInfo>` |
| `QTemporaryFile` | `QTemporaryFile` | `<QTemporaryFile>` |
| `QTemporaryDir` | `QTemporaryDir` | `<QTemporaryDir>` |
| `QTextStream` | `QTextStream` | `<QTextStream>` |
| `QDataStream` | `QDataStream` | `<QDataStream>` |
| `QProcess` | `QProcess` | `<QProcess>` |
| `QTranslator` | `QTranslator` | `<QTranslator>` |
| `QCryptographicHash` | `QCryptographicHash` | `<QCryptographicHash>` |
| `QThreadPool` | `QThreadPool` | `<QThreadPool>` |
| `QMimeDatabase` | `QMimeDatabase` | `<QMimeDatabase>` |
| `QMimeType` | `QMimeType` | `<QMimeType>` |
| `QAbstractItemModel` | `QAbstractItemModel` | `<QAbstractItemModel>` |
| `QSortFilterProxyModel` | `QSortFilterProxyModel` | `<QSortFilterProxyModel>` |
| `QModelIndex` | `QModelIndex` | `<QAbstractItemModel>` |
| `QLockFile` | `QLockFile` | `<QLockFile>` |
| `QSaveFile` | `QSaveFile` | `<QSaveFile>` |
| `QRegularExpression` | `QRegularExpression` | `<QRegularExpression>` |
| `QRegularExpressionMatch` | `QRegularExpressionMatch` | `<QRegularExpression>` |
| `QLocale` | `QLocale` | `<QLocale>` |
| `QTimeZone` | `QTimeZone` | `<QTimeZone>` |
| `QBitArray` | `QBitArray` | `<QBitArray>` |
| `QLine` | `QLine` | `<QLine>` |
| `QLineF` | `QLineF` | `<QLineF>` |
| `QMargins` | `QMargins` | `<QMargins>` |
| `QMarginsF` | `QMarginsF` | `<QMarginsF>` |
| `QBuffer` | `QBuffer` | `<QBuffer>` |
| `QIODevice` | `QIODevice` | `<QIODevice>` |

### Псевдонимы указателей

Короткие псевдонимы для часто используемых указателей:

```nim
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
```

---

## QCoreApplication

Синглтон приложения. Внутри библиотеки хранит статический экземпляр `QCoreApplication*`.

### Создание и получение экземпляра

```nim
proc newCoreApp*(): CoreApp
```
Создаёт новый экземпляр `QCoreApplication` (вызывать один раз).

```nim
proc coreAppInstance*(): CoreApp
```
Возвращает текущий экземпляр приложения (может вернуть `nil`).

### Цикл событий

```nim
proc exec*(a: CoreApp): cint
```
Запускает главный цикл событий. Возвращает код выхода.

```nim
proc quit*(a: CoreApp)
```
Завершает цикл событий (код выхода 0).

```nim
proc exit*(a: CoreApp, code: cint = 0)
```
Завершает цикл событий с заданным кодом.

```nim
proc processEvents*(a: CoreApp)
```
Обрабатывает все ожидающие события.

### Метаданные приложения

```nim
proc setAppName*(a: CoreApp, s: QString)
proc setOrgName*(a: CoreApp, s: QString)
proc setOrgDomain*(a: CoreApp, s: QString)
proc setAppVersion*(a: CoreApp, s: QString)
```

```nim
proc appName*(): string
proc appVersion*(): string
proc appDirPath*(): string   # Директория исполняемого файла
proc appFilePath*(): string  # Полный путь к исполняемому файлу
proc appPid*(): int64        # PID текущего процесса
```

### Переводы

```nim
proc installTranslator*(t: ptr QTranslator): bool
proc removeTranslator*(t: ptr QTranslator): bool
```

**Пример:**
```nim
let app = newCoreApp()
app.setAppName(qs"MyApp")
app.setAppVersion(qs"1.0.0")
echo appName()   # "MyApp"
let code = app.exec()
```

---

## QObject

Базовый класс всех Qt-объектов. Поддерживает иерархию родитель/потомок, сигналы и слоты.

### Создание

```nim
proc newQObject*(parent: Obj = nil): Obj
```

### Иерархия объектов

```nim
proc objParent*(o: Obj): Obj
proc objSetParent*(o: Obj, p: Obj)
proc objChildren*(o: Obj): QStringList   # Имена дочерних объектов
```

### Имена объектов

```nim
proc objName*(o: Obj): string
proc objSetName*(o: Obj, name: QString)
```

### Интроспекция

```nim
proc objIsA*(o: Obj, className: cstring): bool
# Проверяет, является ли объект экземпляром класса (через QObject::inherits)
```

### Управление сигналами

```nim
proc objBlockSignals*(o: Obj, doBlock: bool): bool
# Блокирует/разблокирует сигналы. Возвращает предыдущее состояние.

proc objSignalsBlocked*(o: Obj): bool
```

### Отладка

```nim
proc objDump*(o: Obj)       # dumpObjectInfo()
proc objDumpTree*(o: Obj)   # dumpObjectTree()
```

### Уничтожение

```nim
proc objDelete*(o: Obj)        # Немедленное удаление (delete)
proc objDeleteLater*(o: Obj)   # Безопасное удаление через цикл событий
```

### Сигналы и слоты

```nim
proc objConnect*(sender: Obj, signal: cstring,
                 receiver: Obj, slot: cstring): bool

proc objDisconnect*(sender: Obj, signal: cstring,
                    receiver: Obj, slot: cstring): bool
```

**Пример:**
```nim
let btn = newQObject()
btn.objSetName(qs"myButton")
echo btn.objName()  # "myButton"
```

---

## QTimer

Периодический или одиночный таймер.

### Создание

```nim
proc newTimer*(parent: Obj = nil): ptr QTimer
```

### Управление

```nim
proc timerStart*(t: ptr QTimer, ms: cint)
proc timerStop*(t: ptr QTimer)
```

Псевдонимы для совместимости:
```nim
proc start*(t: ptr QTimer, ms: cint)
proc stop*(t: ptr QTimer)
```

### Свойства

```nim
proc timerIsActive*(t: ptr QTimer): bool
proc timerInterval*(t: ptr QTimer): int
proc timerSetInterval*(t: ptr QTimer, ms: cint)
proc timerSetSingleShot*(t: ptr QTimer, b: bool)
proc timerIsSingleShot*(t: ptr QTimer): bool
proc timerRemainingTime*(t: ptr QTimer): int
# Возвращает оставшееся время в мс. -1 если таймер неактивен.
```

### Коллбэки

```nim
proc timerOnTimeout*(t: ptr QTimer, cb: CB, ud: pointer)
# Подключает callback к сигналу timeout.

proc onTimeout*(t: ptr QTimer, cb: CB, ud: pointer)
# Псевдоним для timerOnTimeout.
```

```nim
proc timerSingleShot*(ms: cint, cb: CB, ud: pointer)
# Статический метод: запустить callback один раз через ms миллисекунд.
```

**Пример:**
```nim
let t = newTimer()
t.timerSetSingleShot(true)
t.timerStart(1000)
t.timerOnTimeout(proc(ud: pointer) {.cdecl.} =
  echo "Таймер сработал!"
, nil)
```

---

## QElapsedTimer

Высокоточный таймер для измерения времени выполнения.

### Создание

```nim
proc newElapsedTimer*(): ptr QElapsedTimer
```

### Методы

```nim
proc etStart*(t: ptr QElapsedTimer)
# Запускает (или перезапускает) таймер.

proc etElapsed*(t: ptr QElapsedTimer): int64
# Миллисекунды с момента запуска.

proc etNsecsElapsed*(t: ptr QElapsedTimer): int64
# Наносекунды с момента запуска.

proc etRestart*(t: ptr QElapsedTimer): int64
# Перезапускает таймер. Возвращает прошедшее время (мс).

proc etIsValid*(t: ptr QElapsedTimer): bool
# Проверяет, был ли таймер запущен.

proc etHasExpired*(t: ptr QElapsedTimer, timeout: int64): bool
# Проверяет, прошло ли timeout миллисекунд.
```

**Пример:**
```nim
let et = newElapsedTimer()
et.etStart()
# ... выполнение кода ...
echo "Прошло: ", et.etElapsed(), " мс"
```

---

## QEventLoop

Локальный цикл событий. Полезен для ожидания асинхронных операций внутри функции.

### Создание

```nim
proc newEventLoop*(parent: Obj = nil): ELoop
```

### Методы

```nim
proc elExec*(l: ELoop): cint        # Запускает цикл. Возвращает код выхода.
proc elQuit*(l: ELoop)              # Выход с кодом 0.
proc elExit*(l: ELoop, code: cint = 0)
proc elIsRunning*(l: ELoop): bool
proc elProcessEvents*(l: ELoop)     # Обработать ожидающие события.
```

**Пример:**
```nim
let loop = newEventLoop()
timerSingleShot(2000, proc(ud: pointer) {.cdecl.} =
  cast[ELoop](ud).elQuit()
, cast[pointer](loop))
discard loop.elExec()
echo "Ждали 2 секунды"
```

---

## QThread

Управление потоками выполнения.

### Создание

```nim
proc newQThread*(parent: Obj = nil): Thr
```

### Управление потоком

```nim
proc thrStart*(t: Thr)
proc thrQuit*(t: Thr)               # Запрашивает выход из цикла событий потока.
proc thrWait*(t: Thr): bool         # Ожидает завершения (бесконечно).
proc thrWaitMs*(t: Thr, ms: culong): bool  # Ожидает завершения с таймаутом.
proc thrTerminate*(t: Thr)          # Принудительное завершение (небезопасно!).
```

### Состояние

```nim
proc thrIsRunning*(t: Thr): bool
proc thrIsFinished*(t: Thr): bool
```

### Приоритет и стек

```nim
proc thrSetPriority*(t: Thr, p: cint)
# Значения приоритета соответствуют QThread::Priority.

proc thrPriority*(t: Thr): cint

proc thrStackSize*(t: Thr): int
proc thrSetStackSize*(t: Thr, sz: uint)
```

### Статические методы

```nim
proc thrCurrentThread*(): Thr      # Текущий поток.
proc thrMainThread*(): Thr         # Главный поток приложения.
proc thrSleepMs*(ms: culong)       # Приостановить на ms миллисекунд.
proc thrSleepUs*(us: culong)       # Приостановить на us микросекунд.
proc thrSleep*(s: culong)          # Приостановить на s секунд.
proc thrYield*()                   # Передать управление планировщику.
proc thrIdealCount*(): int         # Оптимальное число потоков для данного CPU.
```

### Сигналы

```nim
proc thrOnStarted*(t: Thr, cb: CB, ud: pointer)
proc thrOnFinished*(t: Thr, cb: CB, ud: pointer)
```

**Пример:**
```nim
let thr = newQThread()
thr.thrOnStarted(proc(ud: pointer) {.cdecl.} =
  echo "Поток запущен"
, nil)
thr.thrStart()
discard thr.thrWaitMs(5000)
```

---

## QMutex

Взаимное исключение для защиты разделяемых данных.

### Создание

```nim
proc newMutex*(): Mtx
```

### Методы

```nim
proc mtxLock*(m: Mtx)
# Блокирует мьютекс. Если занят — ожидает.

proc mtxUnlock*(m: Mtx)
# Освобождает мьютекс.

proc mtxTryLock*(m: Mtx): bool
# Пытается захватить без ожидания. Возвращает false если занят.

proc mtxTryLockMs*(m: Mtx, ms: cint): bool
# Пытается захватить в течение ms миллисекунд.
```

**Пример:**
```nim
let mtx = newMutex()
mtx.mtxLock()
# критическая секция
mtx.mtxUnlock()
```

---

## QReadWriteLock

Блокировка для чтения/записи. Допускает одновременное чтение несколькими потоками.

### Создание

```nim
proc newRWLock*(): RWLock
```

### Методы

```nim
proc rwLockRead*(l: RWLock)
proc rwLockWrite*(l: RWLock)
proc rwTryLockRead*(l: RWLock): bool
proc rwTryLockWrite*(l: RWLock): bool
proc rwUnlock*(l: RWLock)
```

---

## QSemaphore

Семафор для контроля доступа к ограниченным ресурсам.

### Создание

```nim
proc newSemaphore*(n: cint = 0): Sem
# n — начальное количество доступных ресурсов.
```

### Методы

```nim
proc semAcquire*(s: Sem, n: cint = 1)
# Захватывает n ресурсов. Блокирует, если недостаточно.

proc semRelease*(s: Sem, n: cint = 1)
# Освобождает n ресурсов.

proc semTryAcquire*(s: Sem, n: cint = 1): bool
# Пытается захватить без блокировки.

proc semAvailable*(s: Sem): int
# Количество доступных ресурсов.
```

**Пример:**
```nim
let sem = newSemaphore(3)  # Не более 3 одновременных доступов
sem.semAcquire()
# ... работа с ресурсом ...
sem.semRelease()
```

---

## QSettings

Хранение настроек приложения (реестр Windows, INI-файлы).

### Создание

```nim
proc newSettings*(org, app: string): ptr QSettings
# Использует нативное хранилище (реестр на Windows).

proc newSettingsFile*(path: string): ptr QSettings
# Открывает/создаёт INI-файл по указанному пути.
```

### Запись значений

```nim
proc setVal*(s: ptr QSettings, key: string, val: string)
proc setValInt*(s: ptr QSettings, key: string, val: int64)
proc setValBool*(s: ptr QSettings, key: string, val: bool)
```

### Чтение значений

```nim
proc getVal*(s: ptr QSettings, key: string, def: string = ""): string
proc getValInt*(s: ptr QSettings, key: string, def: int64 = 0): int64
proc getValBool*(s: ptr QSettings, key: string, def: bool = false): bool
```

### Управление ключами

```nim
proc settingsContains*(s: ptr QSettings, key: string): bool
proc settingsRemove*(s: ptr QSettings, key: string)
proc settingsSync*(s: ptr QSettings)       # Принудительная запись на диск.
proc settingsAllKeys*(s: ptr QSettings): seq[string]
```

### Группы

```nim
proc settingsBeginGroup*(s: ptr QSettings, prefix: string)
proc settingsEndGroup*(s: ptr QSettings)
proc settingsChildGroups*(s: ptr QSettings): seq[string]
```

### Информация о файле

```nim
proc settingsFileName*(s: ptr QSettings): string
```

**Пример:**
```nim
let cfg = newSettings("MyOrg", "MyApp")
cfg.setVal("window/width", "1024")
cfg.setValInt("window/height", 768)
echo cfg.getVal("window/width")   # "1024"
cfg.settingsSync()
```

---

## QFile

Работа с файлами: чтение, запись, управление.

### Создание

```nim
proc newFile*(path: string): ptr QFile
```

### Открытие файла

```nim
proc fileOpen*(f: ptr QFile, mode: cint): bool
proc fileOpenRead*(f: ptr QFile): bool     # ReadOnly
proc fileOpenWrite*(f: ptr QFile): bool    # WriteOnly (перезаписать)
proc fileOpenAppend*(f: ptr QFile): bool   # WriteOnly | Append
proc fileOpenRW*(f: ptr QFile): bool       # ReadWrite
```

| Константа | Значение |
|---|---|
| ReadOnly | `0x0001` |
| WriteOnly | `0x0002` |
| ReadWrite | `0x0003` |
| Append | `0x0006` |

### Операции с файлом

```nim
proc fileClose*(f: ptr QFile)
proc fileFlush*(f: ptr QFile): bool
proc fileIsOpen*(f: ptr QFile): bool
proc fileSize*(f: ptr QFile): int64
proc filePos*(f: ptr QFile): int64
proc fileSeek*(f: ptr QFile, pos: int64): bool
proc fileAtEnd*(f: ptr QFile): bool
```

### Чтение и запись

```nim
proc fileReadAll*(f: ptr QFile): string
proc fileReadLine*(f: ptr QFile): string
proc fileWrite*(f: ptr QFile, data: string): int64
# Возвращает количество записанных байт (-1 при ошибке).
```

### Управление файлом

```nim
proc fileExists*(f: ptr QFile): bool
proc fileRemove*(f: ptr QFile): bool
proc fileRename*(f: ptr QFile, newName: string): bool
proc fileCopy*(f: ptr QFile, dest: string): bool
proc fileSetPermissions*(f: ptr QFile, perms: cint): bool
proc fileError*(f: ptr QFile): string
```

### Статические вспомогательные функции

```nim
proc fileExistsPath*(path: string): bool
proc fileRemovePath*(path: string): bool
proc fileCopyPath*(src, dst: string): bool
```

**Пример:**
```nim
let f = newFile("/tmp/test.txt")
if f.fileOpenWrite():
  discard f.fileWrite("Hello, World!\n")
  f.fileClose()
```

---

## Утилиты быстрого ввода-вывода

Высокоуровневые функции для работы с файлами без создания объектов.

```nim
proc readTextFile*(path: string): tuple[ok: bool, data: string]
# Читает файл целиком. Возвращает (ok, содержимое).

proc writeTextFile*(path: string, data: string): bool
# Создаёт/перезаписывает файл с указанным содержимым.

proc appendTextFile*(path: string, data: string): bool
# Дополняет файл данными.
```

**Пример:**
```nim
let (ok, text) = readTextFile("/etc/hosts")
if ok:
  echo text

discard writeTextFile("/tmp/output.txt", "Результат\n")
discard appendTextFile("/tmp/output.txt", "Дополнение\n")
```

---

## QDir

Работа с директориями файловой системы.

### Создание

```nim
proc newDir*(path: string): ptr QDir
```

### Информация о директории

```nim
proc dirPath*(d: ptr QDir): string
proc dirAbsPath*(d: ptr QDir): string
proc dirExists*(d: ptr QDir): bool
```

### Создание и удаление

```nim
proc dirMkdir*(d: ptr QDir, name: string): bool
# Создаёт одну поддиректорию.

proc dirMkpath*(d: ptr QDir, path: string): bool
# Создаёт вложенный путь (аналог mkdir -p).

proc dirRmdir*(d: ptr QDir, name: string): bool
```

### Навигация

```nim
proc dirCd*(d: ptr QDir, sub: string): bool
proc dirCdUp*(d: ptr QDir): bool
```

### Содержимое директории

```nim
proc dirEntryList*(d: ptr QDir, filter: string = "*"): seq[string]
# Файлы И папки (без . и ..).

proc dirEntryFiles*(d: ptr QDir, filter: string = "*"): seq[string]
# Только файлы.

proc dirFilePath*(d: ptr QDir, fn: string): string
proc dirAbsFilePath*(d: ptr QDir, fn: string): string
```

### Статические методы

```nim
proc dirHomePath*(): string
proc dirTempPath*(): string
proc dirCurrentPath*(): string
proc dirSetCurrent*(path: string): bool
proc dirRootPath*(): string
proc dirSeparator*(): char
proc dirIsAbsPath*(path: string): bool
proc dirCleanPath*(path: string): string
proc dirDrives*(): seq[string]
```

**Пример:**
```nim
let d = newDir(dirHomePath())
let files = d.dirEntryFiles("*.nim")
for f in files:
  echo f
```

---

## QFileInfo

Получение метаданных о файле или директории.

### Создание

```nim
proc newFileInfo*(path: string): ptr QFileInfo
```

### Проверки типа

```nim
proc fiExists*(fi: ptr QFileInfo): bool
proc fiIsFile*(fi: ptr QFileInfo): bool
proc fiIsDir*(fi: ptr QFileInfo): bool
proc fiIsSymLink*(fi: ptr QFileInfo): bool
```

### Права доступа

```nim
proc fiIsReadable*(fi: ptr QFileInfo): bool
proc fiIsWritable*(fi: ptr QFileInfo): bool
proc fiIsExecutable*(fi: ptr QFileInfo): bool
proc fiIsHidden*(fi: ptr QFileInfo): bool
```

### Размер и имя

```nim
proc fiSize*(fi: ptr QFileInfo): int64
proc fiFileName*(fi: ptr QFileInfo): string        # "document.tar.gz"
proc fiBaseName*(fi: ptr QFileInfo): string        # "document"
proc fiCompleteBaseName*(fi: ptr QFileInfo): string # "document.tar"
proc fiSuffix*(fi: ptr QFileInfo): string          # "gz"
proc fiCompleteSuffix*(fi: ptr QFileInfo): string  # "tar.gz"
```

### Пути

```nim
proc fiAbsFilePath*(fi: ptr QFileInfo): string
proc fiAbsDir*(fi: ptr QFileInfo): string
proc fiSymLinkTarget*(fi: ptr QFileInfo): string
```

### Владелец и время

```nim
proc fiOwner*(fi: ptr QFileInfo): string
proc fiLastModified*(fi: ptr QFileInfo): QDateTime
proc fiCreated*(fi: ptr QFileInfo): QDateTime
```

**Пример:**
```nim
let fi = newFileInfo("/home/user/file.tar.gz")
echo fi.fiBaseName()        # "file"
echo fi.fiCompleteSuffix()  # "tar.gz"
echo fi.fiSize()            # размер в байтах
```

---

## QCryptographicHash

Вычисление хэш-сумм данных и файлов.

### Перечисление алгоритмов

```nim
type QHashAlgorithm* = enum
  Md4      = 0
  Md5      = 1
  Sha1     = 2
  Sha224   = 3
  Sha256   = 4
  Sha384   = 5
  Sha512   = 6
  Sha3_224 = 7
  Sha3_256 = 8
  Sha3_384 = 9
  Sha3_512 = 10
  Keccak_224 = 11
  Keccak_256 = 12
  Keccak_384 = 13
  Keccak_512 = 14
  Blake2b_160 = 15
  Blake2b_256 = 16
  Blake2b_384 = 17
  Blake2b_512 = 18
  Blake2s_128 = 19
  Blake2s_160 = 20
  Blake2s_224 = 21
  Blake2s_256 = 22
```

### Функции

```nim
proc hashData*(algo: QHashAlgorithm, data: string): string
# Вычисляет хэш строки. Возвращает hex-строку.

proc hashFile*(algo: QHashAlgorithm, path: string): tuple[ok: bool, hash: string]
# Вычисляет хэш файла. ok=false если файл недоступен.
```

**Пример:**
```nim
let h = hashData(Sha256, "Hello, World!")
echo h  # "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986d"

let (ok, fh) = hashFile(Md5, "/tmp/test.txt")
if ok: echo "MD5: ", fh
```

---

## QProcess

Запуск внешних процессов и управление ими.

### Создание

```nim
proc newProcess*(parent: Obj = nil): Proc
```

### Запуск процесса

```nim
proc procStart*(p: Proc, program: string, args: seq[string])
proc procStartCmd*(pr: Proc, cmd: string)
# Запускает команду через системную оболочку.
```

### Ожидание

```nim
proc procWaitForStarted*(p: Proc, ms: cint = 30000): bool
proc procWaitForFinished*(p: Proc, ms: cint = 30000): bool
```

### Ввод-вывод

```nim
proc procReadStdout*(p: Proc): string
proc procReadStderr*(p: Proc): string
proc procWrite*(p: Proc, data: string): int64
# Записывает данные в stdin процесса.
```

### Управление и состояние

```nim
proc procExitCode*(p: Proc): int
proc procKill*(p: Proc)         # SIGKILL
proc procTerminate*(p: Proc)    # SIGTERM
proc procIsRunning*(p: Proc): bool
proc procSetWorkDir*(p: Proc, dir: string)
```

### Быстрый запуск

```nim
proc execCmd*(cmd: string, args: seq[string] = @[]):
    tuple[ok: bool, code: int, stdout: string, stderr: string]
# Синхронный запуск. Ожидает до 30 секунд.
```

**Пример:**
```nim
let (ok, code, out, err) = execCmd("git", @["status"])
if ok:
  echo "Код выхода: ", code
  echo out
```

---

## QRegularExpression

Регулярные выражения (Perl-совместимые через PCRE).

### Создание

```nim
proc newRegExp*(pattern: string, flags: cint = 0): RegExp
# flags — битовая маска QRegularExpression::PatternOptions.
```

### Поиск совпадений

```nim
proc rxMatch*(rx: RegExp, subject: string): tuple[ok: bool, captured: seq[string]]
# ok=true если найдено совпадение.
# captured[0] — полное совпадение, captured[1..] — группы захвата.

proc rxGlobalMatch*(rx: RegExp, subject: string): seq[string]
# Все совпадения (только полные совпадения, без групп).
```

### Замена

```nim
proc rxReplace*(rx: RegExp, subject, replacement: string): string
# Заменяет все совпадения.
```

### Валидация

```nim
proc rxIsValid*(rx: RegExp): bool
# Проверяет корректность паттерна.
```

**Пример:**
```nim
let rx = newRegExp(r"(\d{4})-(\d{2})-(\d{2})")
let (ok, caps) = rx.rxMatch("Дата: 2024-03-15")
if ok:
  echo caps[1]  # "2024"
  echo caps[2]  # "03"
  echo caps[3]  # "15"
```

---

## QLocale

Форматирование чисел, дат и строк в зависимости от региональных настроек.

### Создание

```nim
proc defaultLocale*(): ptr QLocale    # Локаль по умолчанию ("C")
proc localeByName*(name: string): ptr QLocale  # Например: "ru_RU"
proc localeSystem*(): ptr QLocale     # Системная локаль
```

### Информация о локали

```nim
proc localeName*(l: ptr QLocale): string      # "ru_RU"
proc localeBcp47*(l: ptr QLocale): string     # "ru-RU"
proc localeDecimalPoint*(l: ptr QLocale): char
proc localeGroupSeparator*(l: ptr QLocale): char
proc localeCurrencySymbol*(l: ptr QLocale): string
```

### Форматирование

```nim
proc localeFormatInt*(l: ptr QLocale, n: int64): string
proc localeFormatFloat*(l: ptr QLocale, f: float64, prec: int = -1): string
proc localeFormatDate*(l: ptr QLocale, d: QDate): string
```

**Пример:**
```nim
let loc = localeByName("de_DE")
echo loc.localeFormatFloat(1234567.89, 2)  # "1.234.567,89"
echo loc.localeCurrencySymbol()            # "€"
```

---

## QThreadPool

Пул потоков для параллельного выполнения задач.

### Получение глобального пула

```nim
proc threadPoolGlobal*(): TPool
```

### Управление пулом

```nim
proc tpMaxThreadCount*(tp: TPool): int
proc tpSetMaxThreadCount*(tp: TPool, n: int)
proc tpActiveThreadCount*(tp: TPool): int
proc tpWaitForDone*(tp: TPool, ms: int = -1): bool
# ms = -1 — ожидать бесконечно.

proc tpClear*(tp: TPool)
proc tpReleaseThread*(tp: TPool)
proc tpReserveThread*(tp: TPool)
```

### Запуск задач

```nim
proc tpRun*(tp: TPool, cb: CB, ud: pointer)
# Запускает callback в потоке пула через QRunnable.
# Объект QRunnable удаляется автоматически после выполнения.
```

**Пример:**
```nim
let pool = threadPoolGlobal()
pool.tpSetMaxThreadCount(4)

proc task(ud: pointer) {.cdecl.} =
  echo "Задача выполняется в потоке пула"

pool.tpRun(task, nil)
discard pool.tpWaitForDone()
```

---

## QMimeDatabase / QMimeType

Определение MIME-типов файлов.

### QMimeDatabase

```nim
proc newMimeDatabase*(): ptr QMimeDatabase

proc mimeForFile*(db: ptr QMimeDatabase, path: string): QMimeType
# Определяет MIME-тип по имени/содержимому файла.

proc mimeForData*(db: ptr QMimeDatabase, data: string): QMimeType
# Определяет MIME-тип по содержимому (magic bytes).
```

### QMimeType

```nim
proc mimeName*(m: QMimeType): string        # "image/png"
proc mimeComment*(m: QMimeType): string     # "PNG Image"
proc mimeIsValid*(m: QMimeType): bool
proc mimeSuffixes*(m: QMimeType): seq[string]  # ["png"]
proc mimeInherits*(m: QMimeType, parent: string): bool
# Проверяет, наследует ли тип указанный родительский тип.
```

**Пример:**
```nim
let db = newMimeDatabase()
let mime = db.mimeForFile("/home/user/photo.png")
echo mime.mimeName()     # "image/png"
echo mime.mimeComment()  # "PNG image"
```

---

## QLine / QLineF

Геометрические примитивы: линия с целочисленными или вещественными координатами.

### QLine (целые числа)

```nim
proc makeLine*(x1, y1, x2, y2: int): QLine

proc lineX1*(l: QLine): int
proc lineY1*(l: QLine): int
proc lineX2*(l: QLine): int
proc lineY2*(l: QLine): int
proc lineIsNull*(l: QLine): bool
# true если начало и конец совпадают.
```

### QLineF (числа с плавающей точкой)

```nim
proc makeLineF*(x1, y1, x2, y2: float64): QLineF

proc lineLength*(l: QLineF): float64
# Длина линии.

proc lineAngle*(l: QLineF): float64
# Угол в градусах (от положительной оси X против часовой стрелки).
```

**Пример:**
```nim
let l = makeLine(0, 0, 100, 100)
echo l.lineX2()  # 100

let lf = makeLineF(0.0, 0.0, 1.0, 1.0)
echo lf.lineLength()  # 1.4142135623730951
```

---

## QMargins / QMarginsF

Отступы (поля) прямоугольника.

### QMargins (целые числа)

```nim
proc makeMargins*(left, top, right, bottom: int): QMargins

proc marginsLeft*(m: QMargins): int
proc marginsTop*(m: QMargins): int
proc marginsRight*(m: QMargins): int
proc marginsBottom*(m: QMargins): int
proc marginsIsNull*(m: QMargins): bool
# true если все поля равны нулю.
```

### QMarginsF (числа с плавающей точкой)

```nim
proc makeMarginsF*(left, top, right, bottom: float64): QMarginsF
```

**Пример:**
```nim
let m = makeMargins(10, 20, 10, 20)
echo m.marginsLeft()    # 10
echo m.marginsIsNull()  # false
```

---

## QSortFilterProxyModel

Прокси-модель для сортировки и фильтрации данных в представлениях.

### Создание

```nim
proc newSFPM*(parent: Obj = nil): SFPM
```

### Настройка

```nim
proc sfpmSetSource*(m: SFPM, src: AIM)
# Устанавливает исходную модель данных.

proc sfpmSetFilterStr*(m: SFPM, s: QString)
# Фильтрует по регулярному выражению.

proc sfpmSetFilterCol*(m: SFPM, col: cint)
# Колонка для фильтрации (-1 = все колонки).

proc sfpmSetSortCol*(m: SFPM, col: cint, order: cint)
# order: 0 = Qt::AscendingOrder, 1 = Qt::DescendingOrder.

proc sfpmSetCaseSensitive*(m: SFPM, b: bool)
```

### Информация

```nim
proc sfpmRowCount*(m: SFPM): int
proc sfpmColCount*(m: SFPM): int
proc sfpmInvalidate*(m: SFPM)
# Сбрасывает кэш фильтра/сортировки.
```

---

## QModelIndex

Индекс элемента в модели данных Qt.

```nim
proc miRow*(idx: QModelIndex): int
proc miCol*(idx: QModelIndex): int
proc miIsValid*(idx: QModelIndex): bool
proc miData*(idx: QModelIndex, role: cint = 0): QVariant
# role: 0 = Qt::DisplayRole
```

---

## QTranslator

Загрузка и установка переводов для интернационализации.

### Создание

```nim
proc newTranslator*(parent: Obj = nil): ptr QTranslator
```

### Загрузка переводов

```nim
proc trLoad*(t: ptr QTranslator, file: string): bool
# Загружает .qm файл по полному пути.

proc trLoadLocale*(t: ptr QTranslator, file: string, dir: string): bool
# Загружает файл перевода с учётом системной локали.
# Ищет: dir/file_ru_RU.qm, dir/file_ru.qm и т.д.

proc trIsEmpty*(t: ptr QTranslator): bool
```

**Пример:**
```nim
let app = newCoreApp()
let tr = newTranslator()
if tr.trLoad("/path/to/myapp_ru.qm"):
  discard app.installTranslator(tr)
```

---

## Полный пример использования

```nim
import nimQtCore

# Инициализация приложения
let app = newCoreApp()
app.setAppName(qs"ExampleApp")
app.setAppVersion(qs"1.0.0")

# Настройки
let cfg = newSettings("MyOrg", "ExampleApp")
cfg.setVal("lang", "ru")
cfg.settingsSync()

# Работа с файлами
let (ok, content) = readTextFile("/etc/hostname")
if ok:
  echo "Хост: ", content.strip()

# Хэш
let h = hashData(Sha256, content)
echo "SHA256: ", h

# Поиск по регулярному выражению
let rx = newRegExp(r"\w+")
let words = rx.rxGlobalMatch("Hello World Nim")
echo "Слова: ", words

# Информация о директории
let home = dirHomePath()
let d = newDir(home)
echo "Файлы .nim: ", d.dirEntryFiles("*.nim")

# Параллельное выполнение
let pool = threadPoolGlobal()
proc worker(ud: pointer) {.cdecl.} =
  thrSleepMs(100)
  echo "Готово"
pool.tpRun(worker, nil)
discard pool.tpWaitForDone()

# Запуск главного цикла
discard app.exec()
```

---

## Совместимость и особенности

- Все строки передаются через `cstring` и конвертируются в `QString` через `QString::fromUtf8()`.
- Типы возвращаемых логических значений `bool` внутри `{.emit.}` представлены как `cint` (0/1) для совместимости с ABI.
- Библиотека использует статические `QByteArray` для возврата строк — это **не потокобезопасно** при одновременных вызовах.
- Указатели на Qt-объекты **не управляются GC Nim**. Используйте `objDelete` или `objDeleteLater` для освобождения памяти.
- Коллбэки (`CB`) должны иметь соглашение вызова `{.cdecl.}`.
- Сборка: `nim cpp --passC:"-std=c++20" your_file.nim`
