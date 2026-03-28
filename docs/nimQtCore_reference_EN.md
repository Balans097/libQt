# nimQtCore — Complete Library Reference

> **Version:** Qt6Core · **Compiler:** `nim cpp --passC:"-std=c++20"`  
> **Dependencies:** `nimQtUtils` (types), `nimQtFFI` (constants)  
> **Platform:** MSYS2/UCRT64 (Windows), Qt 6.x

---

## Table of Contents

1. [Compiler Configuration](#compiler-configuration)
2. [Types and Aliases](#types-and-aliases)
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
27. [Quick I/O Utilities](#quick-io-utilities)

---

## Compiler Configuration

The library automatically passes all required flags to the compiler on import:

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

## Types and Aliases

### Opaque Qt Types

All Qt types are exported as opaque C++ objects. They must be accessed **via pointers**.

| Nim Type | Qt Class | Header |
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

### Pointer Aliases

Short aliases for frequently used pointer types:

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

Application singleton. Internally holds a static `QCoreApplication*` instance.

### Creating and Getting the Instance

```nim
proc newCoreApp*(): CoreApp
```
Creates a new `QCoreApplication` instance (call only once).

```nim
proc coreAppInstance*(): CoreApp
```
Returns the current application instance (may return `nil`).

### Event Loop

```nim
proc exec*(a: CoreApp): cint
```
Starts the main event loop. Returns the exit code.

```nim
proc quit*(a: CoreApp)
```
Exits the event loop with code 0.

```nim
proc exit*(a: CoreApp, code: cint = 0)
```
Exits the event loop with the given code.

```nim
proc processEvents*(a: CoreApp)
```
Processes all pending events.

### Application Metadata

```nim
proc setAppName*(a: CoreApp, s: QString)
proc setOrgName*(a: CoreApp, s: QString)
proc setOrgDomain*(a: CoreApp, s: QString)
proc setAppVersion*(a: CoreApp, s: QString)
```

```nim
proc appName*(): string
proc appVersion*(): string
proc appDirPath*(): string    # Directory of the executable
proc appFilePath*(): string   # Full path to the executable
proc appPid*(): int64         # PID of the current process
```

### Translations

```nim
proc installTranslator*(t: ptr QTranslator): bool
proc removeTranslator*(t: ptr QTranslator): bool
```

**Example:**
```nim
let app = newCoreApp()
app.setAppName(qs"MyApp")
app.setAppVersion(qs"1.0.0")
echo appName()   # "MyApp"
let code = app.exec()
```

---

## QObject

Base class of all Qt objects. Supports parent/child hierarchy, signals and slots.

### Creation

```nim
proc newQObject*(parent: Obj = nil): Obj
```

### Object Hierarchy

```nim
proc objParent*(o: Obj): Obj
proc objSetParent*(o: Obj, p: Obj)
proc objChildren*(o: Obj): QStringList   # Names of child objects
```

### Object Names

```nim
proc objName*(o: Obj): string
proc objSetName*(o: Obj, name: QString)
```

### Introspection

```nim
proc objIsA*(o: Obj, className: cstring): bool
# Checks if the object is an instance of the class (via QObject::inherits).
```

### Signal Management

```nim
proc objBlockSignals*(o: Obj, doBlock: bool): bool
# Blocks/unblocks signals. Returns the previous state.

proc objSignalsBlocked*(o: Obj): bool
```

### Debugging

```nim
proc objDump*(o: Obj)       # dumpObjectInfo()
proc objDumpTree*(o: Obj)   # dumpObjectTree()
```

### Destruction

```nim
proc objDelete*(o: Obj)        # Immediate deletion (delete)
proc objDeleteLater*(o: Obj)   # Safe deferred deletion via event loop
```

### Signals and Slots

```nim
proc objConnect*(sender: Obj, signal: cstring,
                 receiver: Obj, slot: cstring): bool

proc objDisconnect*(sender: Obj, signal: cstring,
                    receiver: Obj, slot: cstring): bool
```

**Example:**
```nim
let btn = newQObject()
btn.objSetName(qs"myButton")
echo btn.objName()  # "myButton"
```

---

## QTimer

Periodic or one-shot timer.

### Creation

```nim
proc newTimer*(parent: Obj = nil): ptr QTimer
```

### Control

```nim
proc timerStart*(t: ptr QTimer, ms: cint)
proc timerStop*(t: ptr QTimer)
```

Compatibility aliases:
```nim
proc start*(t: ptr QTimer, ms: cint)
proc stop*(t: ptr QTimer)
```

### Properties

```nim
proc timerIsActive*(t: ptr QTimer): bool
proc timerInterval*(t: ptr QTimer): int
proc timerSetInterval*(t: ptr QTimer, ms: cint)
proc timerSetSingleShot*(t: ptr QTimer, b: bool)
proc timerIsSingleShot*(t: ptr QTimer): bool
proc timerRemainingTime*(t: ptr QTimer): int
# Returns remaining time in ms. -1 if the timer is inactive.
```

### Callbacks

```nim
proc timerOnTimeout*(t: ptr QTimer, cb: CB, ud: pointer)
# Connects a callback to the timeout signal.

proc onTimeout*(t: ptr QTimer, cb: CB, ud: pointer)
# Alias for timerOnTimeout.
```

```nim
proc timerSingleShot*(ms: cint, cb: CB, ud: pointer)
# Static: fires callback once after ms milliseconds.
```

**Example:**
```nim
let t = newTimer()
t.timerSetSingleShot(true)
t.timerStart(1000)
t.timerOnTimeout(proc(ud: pointer) {.cdecl.} =
  echo "Timer fired!"
, nil)
```

---

## QElapsedTimer

High-resolution timer for measuring execution time.

### Creation

```nim
proc newElapsedTimer*(): ptr QElapsedTimer
```

### Methods

```nim
proc etStart*(t: ptr QElapsedTimer)
# Starts (or restarts) the timer.

proc etElapsed*(t: ptr QElapsedTimer): int64
# Milliseconds since start.

proc etNsecsElapsed*(t: ptr QElapsedTimer): int64
# Nanoseconds since start.

proc etRestart*(t: ptr QElapsedTimer): int64
# Restarts the timer. Returns elapsed time (ms).

proc etIsValid*(t: ptr QElapsedTimer): bool
# Checks whether the timer has been started.

proc etHasExpired*(t: ptr QElapsedTimer, timeout: int64): bool
# Checks whether timeout milliseconds have elapsed.
```

**Example:**
```nim
let et = newElapsedTimer()
et.etStart()
# ... code execution ...
echo "Elapsed: ", et.etElapsed(), " ms"
```

---

## QEventLoop

Local event loop. Useful for waiting for async operations inside a function.

### Creation

```nim
proc newEventLoop*(parent: Obj = nil): ELoop
```

### Methods

```nim
proc elExec*(l: ELoop): cint        # Starts the loop. Returns exit code.
proc elQuit*(l: ELoop)              # Exit with code 0.
proc elExit*(l: ELoop, code: cint = 0)
proc elIsRunning*(l: ELoop): bool
proc elProcessEvents*(l: ELoop)     # Process pending events.
```

**Example:**
```nim
let loop = newEventLoop()
timerSingleShot(2000, proc(ud: pointer) {.cdecl.} =
  cast[ELoop](ud).elQuit()
, cast[pointer](loop))
discard loop.elExec()
echo "Waited 2 seconds"
```

---

## QThread

Thread of execution management.

### Creation

```nim
proc newQThread*(parent: Obj = nil): Thr
```

### Thread Control

```nim
proc thrStart*(t: Thr)
proc thrQuit*(t: Thr)                       # Requests exit from the thread's event loop.
proc thrWait*(t: Thr): bool                 # Waits for completion (indefinitely).
proc thrWaitMs*(t: Thr, ms: culong): bool   # Waits with a timeout.
proc thrTerminate*(t: Thr)                  # Forceful termination (unsafe!).
```

### State

```nim
proc thrIsRunning*(t: Thr): bool
proc thrIsFinished*(t: Thr): bool
```

### Priority and Stack

```nim
proc thrSetPriority*(t: Thr, p: cint)
# Priority values correspond to QThread::Priority.

proc thrPriority*(t: Thr): cint

proc thrStackSize*(t: Thr): int
proc thrSetStackSize*(t: Thr, sz: uint)
```

### Static Methods

```nim
proc thrCurrentThread*(): Thr       # Current thread.
proc thrMainThread*(): Thr          # Main application thread.
proc thrSleepMs*(ms: culong)        # Sleep for ms milliseconds.
proc thrSleepUs*(us: culong)        # Sleep for us microseconds.
proc thrSleep*(s: culong)           # Sleep for s seconds.
proc thrYield*()                    # Yield to the scheduler.
proc thrIdealCount*(): int          # Optimal thread count for the CPU.
```

### Signals

```nim
proc thrOnStarted*(t: Thr, cb: CB, ud: pointer)
proc thrOnFinished*(t: Thr, cb: CB, ud: pointer)
```

**Example:**
```nim
let thr = newQThread()
thr.thrOnStarted(proc(ud: pointer) {.cdecl.} =
  echo "Thread started"
, nil)
thr.thrStart()
discard thr.thrWaitMs(5000)
```

---

## QMutex

Mutual exclusion for protecting shared data.

### Creation

```nim
proc newMutex*(): Mtx
```

### Methods

```nim
proc mtxLock*(m: Mtx)
# Locks the mutex. Blocks if already locked.

proc mtxUnlock*(m: Mtx)
# Unlocks the mutex.

proc mtxTryLock*(m: Mtx): bool
# Tries to lock without blocking. Returns false if already locked.

proc mtxTryLockMs*(m: Mtx, ms: cint): bool
# Tries to lock within ms milliseconds.
```

**Example:**
```nim
let mtx = newMutex()
mtx.mtxLock()
# critical section
mtx.mtxUnlock()
```

---

## QReadWriteLock

Read/write lock. Allows simultaneous reading by multiple threads.

### Creation

```nim
proc newRWLock*(): RWLock
```

### Methods

```nim
proc rwLockRead*(l: RWLock)
proc rwLockWrite*(l: RWLock)
proc rwTryLockRead*(l: RWLock): bool
proc rwTryLockWrite*(l: RWLock): bool
proc rwUnlock*(l: RWLock)
```

---

## QSemaphore

Semaphore for controlling access to limited resources.

### Creation

```nim
proc newSemaphore*(n: cint = 0): Sem
# n — initial number of available resources.
```

### Methods

```nim
proc semAcquire*(s: Sem, n: cint = 1)
# Acquires n resources. Blocks if insufficient.

proc semRelease*(s: Sem, n: cint = 1)
# Releases n resources.

proc semTryAcquire*(s: Sem, n: cint = 1): bool
# Tries to acquire without blocking.

proc semAvailable*(s: Sem): int
# Number of available resources.
```

**Example:**
```nim
let sem = newSemaphore(3)  # At most 3 concurrent accesses
sem.semAcquire()
# ... use the resource ...
sem.semRelease()
```

---

## QSettings

Application settings storage (Windows registry, INI files).

### Creation

```nim
proc newSettings*(org, app: string): ptr QSettings
# Uses the native backend (registry on Windows).

proc newSettingsFile*(path: string): ptr QSettings
# Opens/creates an INI file at the given path.
```

### Writing Values

```nim
proc setVal*(s: ptr QSettings, key: string, val: string)
proc setValInt*(s: ptr QSettings, key: string, val: int64)
proc setValBool*(s: ptr QSettings, key: string, val: bool)
```

### Reading Values

```nim
proc getVal*(s: ptr QSettings, key: string, def: string = ""): string
proc getValInt*(s: ptr QSettings, key: string, def: int64 = 0): int64
proc getValBool*(s: ptr QSettings, key: string, def: bool = false): bool
```

### Key Management

```nim
proc settingsContains*(s: ptr QSettings, key: string): bool
proc settingsRemove*(s: ptr QSettings, key: string)
proc settingsSync*(s: ptr QSettings)       # Force write to disk.
proc settingsAllKeys*(s: ptr QSettings): seq[string]
```

### Groups

```nim
proc settingsBeginGroup*(s: ptr QSettings, prefix: string)
proc settingsEndGroup*(s: ptr QSettings)
proc settingsChildGroups*(s: ptr QSettings): seq[string]
```

### File Information

```nim
proc settingsFileName*(s: ptr QSettings): string
```

**Example:**
```nim
let cfg = newSettings("MyOrg", "MyApp")
cfg.setVal("window/width", "1024")
cfg.setValInt("window/height", 768)
echo cfg.getVal("window/width")   # "1024"
cfg.settingsSync()
```

---

## QFile

File operations: reading, writing, and management.

### Creation

```nim
proc newFile*(path: string): ptr QFile
```

### Opening Files

```nim
proc fileOpen*(f: ptr QFile, mode: cint): bool
proc fileOpenRead*(f: ptr QFile): bool     # ReadOnly
proc fileOpenWrite*(f: ptr QFile): bool    # WriteOnly (overwrite)
proc fileOpenAppend*(f: ptr QFile): bool   # WriteOnly | Append
proc fileOpenRW*(f: ptr QFile): bool       # ReadWrite
```

| Constant | Value |
|---|---|
| ReadOnly | `0x0001` |
| WriteOnly | `0x0002` |
| ReadWrite | `0x0003` |
| Append | `0x0006` |

### File Operations

```nim
proc fileClose*(f: ptr QFile)
proc fileFlush*(f: ptr QFile): bool
proc fileIsOpen*(f: ptr QFile): bool
proc fileSize*(f: ptr QFile): int64
proc filePos*(f: ptr QFile): int64
proc fileSeek*(f: ptr QFile, pos: int64): bool
proc fileAtEnd*(f: ptr QFile): bool
```

### Reading and Writing

```nim
proc fileReadAll*(f: ptr QFile): string
proc fileReadLine*(f: ptr QFile): string
proc fileWrite*(f: ptr QFile, data: string): int64
# Returns the number of bytes written (-1 on error).
```

### File Management

```nim
proc fileExists*(f: ptr QFile): bool
proc fileRemove*(f: ptr QFile): bool
proc fileRename*(f: ptr QFile, newName: string): bool
proc fileCopy*(f: ptr QFile, dest: string): bool
proc fileSetPermissions*(f: ptr QFile, perms: cint): bool
proc fileError*(f: ptr QFile): string
```

### Static Helper Functions

```nim
proc fileExistsPath*(path: string): bool
proc fileRemovePath*(path: string): bool
proc fileCopyPath*(src, dst: string): bool
```

**Example:**
```nim
let f = newFile("/tmp/test.txt")
if f.fileOpenWrite():
  discard f.fileWrite("Hello, World!\n")
  f.fileClose()
```

---

## Quick I/O Utilities

High-level file functions without creating objects.

```nim
proc readTextFile*(path: string): tuple[ok: bool, data: string]
# Reads a file entirely. Returns (ok, content).

proc writeTextFile*(path: string, data: string): bool
# Creates/overwrites a file with the given content.

proc appendTextFile*(path: string, data: string): bool
# Appends data to a file.
```

**Example:**
```nim
let (ok, text) = readTextFile("/etc/hosts")
if ok:
  echo text

discard writeTextFile("/tmp/output.txt", "Result\n")
discard appendTextFile("/tmp/output.txt", "More data\n")
```

---

## QDir

Directory navigation and management.

### Creation

```nim
proc newDir*(path: string): ptr QDir
```

### Directory Information

```nim
proc dirPath*(d: ptr QDir): string
proc dirAbsPath*(d: ptr QDir): string
proc dirExists*(d: ptr QDir): bool
```

### Creating and Removing

```nim
proc dirMkdir*(d: ptr QDir, name: string): bool
# Creates a single subdirectory.

proc dirMkpath*(d: ptr QDir, path: string): bool
# Creates a nested path (like mkdir -p).

proc dirRmdir*(d: ptr QDir, name: string): bool
```

### Navigation

```nim
proc dirCd*(d: ptr QDir, sub: string): bool
proc dirCdUp*(d: ptr QDir): bool
```

### Directory Contents

```nim
proc dirEntryList*(d: ptr QDir, filter: string = "*"): seq[string]
# Files AND directories (excluding . and ..).

proc dirEntryFiles*(d: ptr QDir, filter: string = "*"): seq[string]
# Files only.

proc dirFilePath*(d: ptr QDir, fn: string): string
proc dirAbsFilePath*(d: ptr QDir, fn: string): string
```

### Static Methods

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

**Example:**
```nim
let d = newDir(dirHomePath())
let files = d.dirEntryFiles("*.nim")
for f in files:
  echo f
```

---

## QFileInfo

Retrieving metadata about a file or directory.

### Creation

```nim
proc newFileInfo*(path: string): ptr QFileInfo
```

### Type Checks

```nim
proc fiExists*(fi: ptr QFileInfo): bool
proc fiIsFile*(fi: ptr QFileInfo): bool
proc fiIsDir*(fi: ptr QFileInfo): bool
proc fiIsSymLink*(fi: ptr QFileInfo): bool
```

### Permissions

```nim
proc fiIsReadable*(fi: ptr QFileInfo): bool
proc fiIsWritable*(fi: ptr QFileInfo): bool
proc fiIsExecutable*(fi: ptr QFileInfo): bool
proc fiIsHidden*(fi: ptr QFileInfo): bool
```

### Size and Name

```nim
proc fiSize*(fi: ptr QFileInfo): int64
proc fiFileName*(fi: ptr QFileInfo): string         # "document.tar.gz"
proc fiBaseName*(fi: ptr QFileInfo): string         # "document"
proc fiCompleteBaseName*(fi: ptr QFileInfo): string # "document.tar"
proc fiSuffix*(fi: ptr QFileInfo): string           # "gz"
proc fiCompleteSuffix*(fi: ptr QFileInfo): string   # "tar.gz"
```

### Paths

```nim
proc fiAbsFilePath*(fi: ptr QFileInfo): string
proc fiAbsDir*(fi: ptr QFileInfo): string
proc fiSymLinkTarget*(fi: ptr QFileInfo): string
```

### Owner and Time

```nim
proc fiOwner*(fi: ptr QFileInfo): string
proc fiLastModified*(fi: ptr QFileInfo): QDateTime
proc fiCreated*(fi: ptr QFileInfo): QDateTime
```

**Example:**
```nim
let fi = newFileInfo("/home/user/archive.tar.gz")
echo fi.fiBaseName()        # "archive"
echo fi.fiCompleteSuffix()  # "tar.gz"
echo fi.fiSize()            # size in bytes
```

---

## QCryptographicHash

Computing hash sums for data and files.

### Algorithm Enumeration

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

### Functions

```nim
proc hashData*(algo: QHashAlgorithm, data: string): string
# Computes hash of a string. Returns a hex string.

proc hashFile*(algo: QHashAlgorithm, path: string): tuple[ok: bool, hash: string]
# Computes hash of a file. ok=false if the file is inaccessible.
```

**Example:**
```nim
let h = hashData(Sha256, "Hello, World!")
echo h  # "dffd6021bb2bd5b0af676290809ec3a53191dd81c7f70a4b28688a362182986d"

let (ok, fh) = hashFile(Md5, "/tmp/test.txt")
if ok: echo "MD5: ", fh
```

---

## QProcess

Launching and managing external processes.

### Creation

```nim
proc newProcess*(parent: Obj = nil): Proc
```

### Starting Processes

```nim
proc procStart*(p: Proc, program: string, args: seq[string])
proc procStartCmd*(pr: Proc, cmd: string)
# Starts a command via the system shell.
```

### Waiting

```nim
proc procWaitForStarted*(p: Proc, ms: cint = 30000): bool
proc procWaitForFinished*(p: Proc, ms: cint = 30000): bool
```

### I/O

```nim
proc procReadStdout*(p: Proc): string
proc procReadStderr*(p: Proc): string
proc procWrite*(p: Proc, data: string): int64
# Writes data to the process stdin.
```

### Control and State

```nim
proc procExitCode*(p: Proc): int
proc procKill*(p: Proc)         # SIGKILL
proc procTerminate*(p: Proc)    # SIGTERM
proc procIsRunning*(p: Proc): bool
proc procSetWorkDir*(p: Proc, dir: string)
```

### Quick Launch

```nim
proc execCmd*(cmd: string, args: seq[string] = @[]):
    tuple[ok: bool, code: int, stdout: string, stderr: string]
# Synchronous launch. Waits up to 30 seconds.
```

**Example:**
```nim
let (ok, code, out, err) = execCmd("git", @["status"])
if ok:
  echo "Exit code: ", code
  echo out
```

---

## QRegularExpression

Regular expressions (Perl-compatible via PCRE).

### Creation

```nim
proc newRegExp*(pattern: string, flags: cint = 0): RegExp
# flags — bitmask of QRegularExpression::PatternOptions.
```

### Matching

```nim
proc rxMatch*(rx: RegExp, subject: string): tuple[ok: bool, captured: seq[string]]
# ok=true if a match was found.
# captured[0] — full match, captured[1..] — capture groups.

proc rxGlobalMatch*(rx: RegExp, subject: string): seq[string]
# All matches (full matches only, no groups).
```

### Replacement

```nim
proc rxReplace*(rx: RegExp, subject, replacement: string): string
# Replaces all occurrences.
```

### Validation

```nim
proc rxIsValid*(rx: RegExp): bool
# Checks whether the pattern is valid.
```

**Example:**
```nim
let rx = newRegExp(r"(\d{4})-(\d{2})-(\d{2})")
let (ok, caps) = rx.rxMatch("Date: 2024-03-15")
if ok:
  echo caps[1]  # "2024"
  echo caps[2]  # "03"
  echo caps[3]  # "15"
```

---

## QLocale

Locale-aware formatting of numbers, dates, and strings.

### Creation

```nim
proc defaultLocale*(): ptr QLocale     # Default locale ("C")
proc localeByName*(name: string): ptr QLocale  # e.g. "en_US"
proc localeSystem*(): ptr QLocale      # System locale
```

### Locale Information

```nim
proc localeName*(l: ptr QLocale): string       # "en_US"
proc localeBcp47*(l: ptr QLocale): string      # "en-US"
proc localeDecimalPoint*(l: ptr QLocale): char
proc localeGroupSeparator*(l: ptr QLocale): char
proc localeCurrencySymbol*(l: ptr QLocale): string
```

### Formatting

```nim
proc localeFormatInt*(l: ptr QLocale, n: int64): string
proc localeFormatFloat*(l: ptr QLocale, f: float64, prec: int = -1): string
proc localeFormatDate*(l: ptr QLocale, d: QDate): string
```

**Example:**
```nim
let loc = localeByName("de_DE")
echo loc.localeFormatFloat(1234567.89, 2)  # "1.234.567,89"
echo loc.localeCurrencySymbol()            # "€"
```

---

## QThreadPool

Thread pool for parallel task execution.

### Getting the Global Pool

```nim
proc threadPoolGlobal*(): TPool
```

### Pool Management

```nim
proc tpMaxThreadCount*(tp: TPool): int
proc tpSetMaxThreadCount*(tp: TPool, n: int)
proc tpActiveThreadCount*(tp: TPool): int
proc tpWaitForDone*(tp: TPool, ms: int = -1): bool
# ms = -1 — wait indefinitely.

proc tpClear*(tp: TPool)
proc tpReleaseThread*(tp: TPool)
proc tpReserveThread*(tp: TPool)
```

### Running Tasks

```nim
proc tpRun*(tp: TPool, cb: CB, ud: pointer)
# Runs a callback in a pool thread via QRunnable.
# The QRunnable object is deleted automatically after execution.
```

**Example:**
```nim
let pool = threadPoolGlobal()
pool.tpSetMaxThreadCount(4)

proc task(ud: pointer) {.cdecl.} =
  echo "Task running in pool thread"

pool.tpRun(task, nil)
discard pool.tpWaitForDone()
```

---

## QMimeDatabase / QMimeType

Detecting MIME types of files.

### QMimeDatabase

```nim
proc newMimeDatabase*(): ptr QMimeDatabase

proc mimeForFile*(db: ptr QMimeDatabase, path: string): QMimeType
# Detects the MIME type from the file name/content.

proc mimeForData*(db: ptr QMimeDatabase, data: string): QMimeType
# Detects the MIME type from content (magic bytes).
```

### QMimeType

```nim
proc mimeName*(m: QMimeType): string        # "image/png"
proc mimeComment*(m: QMimeType): string     # "PNG Image"
proc mimeIsValid*(m: QMimeType): bool
proc mimeSuffixes*(m: QMimeType): seq[string]  # ["png"]
proc mimeInherits*(m: QMimeType, parent: string): bool
# Checks whether the type inherits the given parent type.
```

**Example:**
```nim
let db = newMimeDatabase()
let mime = db.mimeForFile("/home/user/photo.png")
echo mime.mimeName()     # "image/png"
echo mime.mimeComment()  # "PNG image"
```

---

## QLine / QLineF

Geometric primitives: lines with integer or floating-point coordinates.

### QLine (integer)

```nim
proc makeLine*(x1, y1, x2, y2: int): QLine

proc lineX1*(l: QLine): int
proc lineY1*(l: QLine): int
proc lineX2*(l: QLine): int
proc lineY2*(l: QLine): int
proc lineIsNull*(l: QLine): bool
# true if start and end points are the same.
```

### QLineF (floating-point)

```nim
proc makeLineF*(x1, y1, x2, y2: float64): QLineF

proc lineLength*(l: QLineF): float64
# Length of the line.

proc lineAngle*(l: QLineF): float64
# Angle in degrees (from the positive X axis, counter-clockwise).
```

**Example:**
```nim
let l = makeLine(0, 0, 100, 100)
echo l.lineX2()  # 100

let lf = makeLineF(0.0, 0.0, 1.0, 1.0)
echo lf.lineLength()  # 1.4142135623730951
```

---

## QMargins / QMarginsF

Margins (padding) of a rectangle.

### QMargins (integer)

```nim
proc makeMargins*(left, top, right, bottom: int): QMargins

proc marginsLeft*(m: QMargins): int
proc marginsTop*(m: QMargins): int
proc marginsRight*(m: QMargins): int
proc marginsBottom*(m: QMargins): int
proc marginsIsNull*(m: QMargins): bool
# true if all margins are zero.
```

### QMarginsF (floating-point)

```nim
proc makeMarginsF*(left, top, right, bottom: float64): QMarginsF
```

**Example:**
```nim
let m = makeMargins(10, 20, 10, 20)
echo m.marginsLeft()    # 10
echo m.marginsIsNull()  # false
```

---

## QSortFilterProxyModel

Proxy model for sorting and filtering data in views.

### Creation

```nim
proc newSFPM*(parent: Obj = nil): SFPM
```

### Setup

```nim
proc sfpmSetSource*(m: SFPM, src: AIM)
# Sets the source data model.

proc sfpmSetFilterStr*(m: SFPM, s: QString)
# Filters by a regular expression.

proc sfpmSetFilterCol*(m: SFPM, col: cint)
# Column to filter on (-1 = all columns).

proc sfpmSetSortCol*(m: SFPM, col: cint, order: cint)
# order: 0 = Qt::AscendingOrder, 1 = Qt::DescendingOrder.

proc sfpmSetCaseSensitive*(m: SFPM, b: bool)
```

### Information

```nim
proc sfpmRowCount*(m: SFPM): int
proc sfpmColCount*(m: SFPM): int
proc sfpmInvalidate*(m: SFPM)
# Resets the filter/sort cache.
```

---

## QModelIndex

Index of an item in a Qt data model.

```nim
proc miRow*(idx: QModelIndex): int
proc miCol*(idx: QModelIndex): int
proc miIsValid*(idx: QModelIndex): bool
proc miData*(idx: QModelIndex, role: cint = 0): QVariant
# role: 0 = Qt::DisplayRole
```

---

## QTranslator

Loading and installing translations for internationalization.

### Creation

```nim
proc newTranslator*(parent: Obj = nil): ptr QTranslator
```

### Loading Translations

```nim
proc trLoad*(t: ptr QTranslator, file: string): bool
# Loads a .qm file from the full path.

proc trLoadLocale*(t: ptr QTranslator, file: string, dir: string): bool
# Loads a translation file respecting the system locale.
# Searches: dir/file_en_US.qm, dir/file_en.qm, etc.

proc trIsEmpty*(t: ptr QTranslator): bool
```

**Example:**
```nim
let app = newCoreApp()
let tr = newTranslator()
if tr.trLoad("/path/to/myapp_en.qm"):
  discard app.installTranslator(tr)
```

---

## Full Usage Example

```nim
import nimQtCore

# Initialize the application
let app = newCoreApp()
app.setAppName(qs"ExampleApp")
app.setAppVersion(qs"1.0.0")

# Settings
let cfg = newSettings("MyOrg", "ExampleApp")
cfg.setVal("lang", "en")
cfg.settingsSync()

# File I/O
let (ok, content) = readTextFile("/etc/hostname")
if ok:
  echo "Host: ", content.strip()

# Hashing
let h = hashData(Sha256, content)
echo "SHA256: ", h

# Regular expressions
let rx = newRegExp(r"\w+")
let words = rx.rxGlobalMatch("Hello World Nim")
echo "Words: ", words

# Directory info
let home = dirHomePath()
let d = newDir(home)
echo ".nim files: ", d.dirEntryFiles("*.nim")

# Parallel execution
let pool = threadPoolGlobal()
proc worker(ud: pointer) {.cdecl.} =
  thrSleepMs(100)
  echo "Done"
pool.tpRun(worker, nil)
discard pool.tpWaitForDone()

# Start the main event loop
discard app.exec()
```

---

## Compatibility Notes and Caveats

- All strings are passed via `cstring` and converted to `QString` using `QString::fromUtf8()`.
- Boolean return values inside `{.emit.}` blocks use `cint` (0/1) for ABI compatibility.
- The library uses static `QByteArray` instances for returning strings — this is **not thread-safe** under concurrent calls.
- Pointers to Qt objects are **not managed by Nim's GC**. Use `objDelete` or `objDeleteLater` to free memory.
- Callbacks (`CB`) must use the `{.cdecl.}` calling convention.
- Build command: `nim cpp --passC:"-std=c++20" your_file.nim`
