## nimQtNetwork.nim — Полная обёртка Qt6Network для Nim (nim cpp --passC:"-std=c++20")
## ============================================================================
##
## Покрывает весь публичный API QtNetwork Qt 6.2–6.11:
##
##   § 1.  Заголовки, линковка, emit-блок
##   § 2.  Opaque типы и псевдонимы указателей
##   § 3.  Enums (NetworkError, Operation, SslError, ProxyType, …)
##   § 4.  QHostAddress — IPv4/IPv6/Special
##   § 5.  QHostInfo   — асинхронное/синхронное DNS-разрешение
##   § 6.  QNetworkInterface / QNetworkAddressEntry
##   § 7.  QNetworkProxy / QNetworkProxyFactory / QNetworkProxyQuery
##   § 8.  QAuthenticator
##   § 9.  QSslCertificate / QSslKey / QSslCipher / QSslConfiguration / QSslError
##   § 10. QNetworkRequest  — заголовки, атрибуты, SSL, redirect
##   § 11. QNetworkReply    — чтение данных, сигналы, аборт
##   § 12. QNetworkAccessManager — HTTP GET/POST/PUT/DELETE/HEAD/PATCH/sendCustom
##   § 13. QNetworkCookieJar / QNetworkCookie
##   § 14. QNetworkDiskCache / QAbstractNetworkCache
##   § 15. QAbstractSocket / QTcpSocket / QTcpServer
##   § 16. QUdpSocket / QUdpDatagram
##   § 17. QLocalSocket / QLocalServer (IPC)
##   § 18. QSslSocket
##   § 19. QNetworkDatagram (DTLS helper)
##   § 20. QDtls / QDtlsClientVerifier (Qt 5.12+/6.x)
##   § 21. QOcspResponse / QOcspCertificateIndex (Qt 6.x)
##   § 22. QHttp2Configuration (Qt 6.0+)
##   § 23. Высокоуровневые Nim-хелперы (httpGet, httpPost, download, …)
##
## Зависимости: nimQtFFI, nimQtUtils, nimQtCore
##
## Компиляция (MSYS2/UCRT64):
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Core Qt6Network)" \
##     --passL:"$(pkg-config --libs Qt6Core Qt6Network)" \
##     app.nim
##
## Совместимость: Qt 6.2 – Qt 6.11

# ─────────────────────────────────────────────────────────────────────────────
# § 1. Пути заголовков и линковка
# ─────────────────────────────────────────────────────────────────────────────

# ── Пути к заголовкам (только Windows/MSYS2) ──────────────────────────────────
when defined(windows):
  {.passC: "-IC:/msys64/ucrt64/include".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtSql".}
  {.passC: "-IC:/msys64/ucrt64/include/qt6/QtCore".}
  {.passC: "-DQT_SQL_LIB -DQT_CORE_LIB".}
  {.passL: "-LC:/msys64/ucrt64/lib -lQt6Sql -lQt6Core".}
# На Linux/macOS — через pkg-config снаружи

import nimQtFFI
import nimQtCore

{.emit: """
// ── Qt Core ──────────────────────────────────────────────────────────────────
#include <QCoreApplication>
#include <QObject>
#include <QEventLoop>
#include <QTimer>
#include <QUrl>
#include <QUrlQuery>
#include <QString>
#include <QStringList>
#include <QByteArray>
#include <QList>
#include <QMap>
#include <QPair>
#include <QIODevice>
#include <QFile>
#include <QBuffer>
#include <QDateTime>
#include <QVariant>

// ── Qt Network ───────────────────────────────────────────────────────────────
#include <QHostAddress>
#include <QHostInfo>
#include <QNetworkInterface>
#include <QNetworkAddressEntry>
#include <QNetworkProxy>
#include <QNetworkProxyFactory>
#include <QNetworkProxyQuery>
#include <QAuthenticator>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QNetworkCookieJar>
#include <QNetworkCookie>
#include <QNetworkDiskCache>
#include <QAbstractNetworkCache>
#include <QNetworkCacheMetaData>
#include <QAbstractSocket>
#include <QTcpSocket>
#include <QTcpServer>
#include <QUdpSocket>
#include <QNetworkDatagram>
#include <QLocalSocket>
#include <QLocalServer>
#include <QSslCertificate>
#include <QSslCertificateExtension>
#include <QSslKey>
#include <QSslCipher>
#include <QSslConfiguration>
#include <QSslError>
#include <QSslSocket>
#include <QSslPreSharedKeyAuthenticator>
#include <QDtls>
#include <QDtlsClientVerifier>
#include <QOcspResponse>
#include <QHttp2Configuration>
#include <functional>
#include <cstring>
""".}

# ═════════════════════════════════════════════════════════════════════════════
# § 2. Opaque типы Qt и псевдонимы указателей
# ═════════════════════════════════════════════════════════════════════════════

type
  # ── Адресация / DNS ─────────────────────────────────────────────────────────
  QHostAddress*         {.importcpp: "QHostAddress",         header: "<QHostAddress>".}         = object
  QHostInfo*            {.importcpp: "QHostInfo",            header: "<QHostInfo>".}            = object

  # ── Сетевые интерфейсы ───────────────────────────────────────────────────────
  QNetworkInterface*    {.importcpp: "QNetworkInterface",    header: "<QNetworkInterface>".}    = object
  QNetworkAddressEntry* {.importcpp: "QNetworkAddressEntry", header: "<QNetworkInterface>".}    = object

  # ── Прокси ───────────────────────────────────────────────────────────────────
  QNetworkProxy*        {.importcpp: "QNetworkProxy",        header: "<QNetworkProxy>".}        = object
  QNetworkProxyQuery*   {.importcpp: "QNetworkProxyQuery",   header: "<QNetworkProxyQuery>".}   = object

  # ── Авторизация ─────────────────────────────────────────────────────────────
  QAuthenticator*       {.importcpp: "QAuthenticator",       header: "<QAuthenticator>".}       = object

  # ── HTTP ─────────────────────────────────────────────────────────────────────
  QNetworkRequest*      {.importcpp: "QNetworkRequest",      header: "<QNetworkRequest>".}      = object
  QNetworkReply*        {.importcpp: "QNetworkReply",        header: "<QNetworkReply>".}        = object
  QNetworkAccessManager* {.importcpp: "QNetworkAccessManager", header: "<QNetworkAccessManager>".} = object

  # ── Cookies / Cache ─────────────────────────────────────────────────────────
  QNetworkCookieJar*    {.importcpp: "QNetworkCookieJar",    header: "<QNetworkCookieJar>".}    = object
  QNetworkCookie*       {.importcpp: "QNetworkCookie",       header: "<QNetworkCookie>".}       = object
  QNetworkDiskCache*    {.importcpp: "QNetworkDiskCache",    header: "<QNetworkDiskCache>".}    = object
  QAbstractNetworkCache* {.importcpp: "QAbstractNetworkCache", header: "<QAbstractNetworkCache>".} = object
  QNetworkCacheMetaData* {.importcpp: "QNetworkCacheMetaData", header: "<QNetworkDiskCache>".}  = object

  # ── Сокеты ───────────────────────────────────────────────────────────────────
  QAbstractSocket*      {.importcpp: "QAbstractSocket",      header: "<QAbstractSocket>".}      = object
  QTcpSocket*           {.importcpp: "QTcpSocket",           header: "<QTcpSocket>".}           = object
  QTcpServer*           {.importcpp: "QTcpServer",           header: "<QTcpServer>".}           = object
  QUdpSocket*           {.importcpp: "QUdpSocket",           header: "<QUdpSocket>".}           = object
  QNetworkDatagram*     {.importcpp: "QNetworkDatagram",     header: "<QNetworkDatagram>".}     = object
  QLocalSocket*         {.importcpp: "QLocalSocket",         header: "<QLocalSocket>".}         = object
  QLocalServer*         {.importcpp: "QLocalServer",         header: "<QLocalServer>".}         = object

  # ── SSL / TLS ────────────────────────────────────────────────────────────────
  QSslCertificate*      {.importcpp: "QSslCertificate",      header: "<QSslCertificate>".}      = object
  QSslCertificateExtension* {.importcpp: "QSslCertificateExtension", header: "<QSslCertificate>".} = object
  QSslKey*              {.importcpp: "QSslKey",              header: "<QSslKey>".}              = object
  QSslCipher*           {.importcpp: "QSslCipher",           header: "<QSslCipher>".}           = object
  QSslConfiguration*    {.importcpp: "QSslConfiguration",    header: "<QSslConfiguration>".}    = object
  QSslError*            {.importcpp: "QSslError",            header: "<QSslError>".}            = object
  QSslSocket*           {.importcpp: "QSslSocket",           header: "<QSslSocket>".}           = object
  QSslPreSharedKeyAuthenticator* {.importcpp: "QSslPreSharedKeyAuthenticator",
                                   header: "<QSslPreSharedKeyAuthenticator>".}                   = object

  # ── DTLS (UDP over TLS) ──────────────────────────────────────────────────────
  QDtls*                {.importcpp: "QDtls",                header: "<QDtls>".}                = object
  QDtlsClientVerifier*  {.importcpp: "QDtlsClientVerifier",  header: "<QDtlsClientVerifier>".}  = object

  # ── OCSP / HTTP2 ─────────────────────────────────────────────────────────────
  QOcspResponse*        {.importcpp: "QOcspResponse",        header: "<QOcspResponse>".}        = object
  QHttp2Configuration*  {.importcpp: "QHttp2Configuration",  header: "<QHttp2Configuration>".}  = object

# ── Псевдонимы указателей ────────────────────────────────────────────────────
type
  NetMgr*    = ptr QNetworkAccessManager  ## Менеджер HTTP-запросов
  NetReply*  = ptr QNetworkReply          ## Ответ на HTTP-запрос
  NetReq*    = ptr QNetworkRequest        ## HTTP-запрос (value-type, обычно не ptr)
  TcpSock*   = ptr QTcpSocket             ## TCP-сокет
  TcpSrv*    = ptr QTcpServer             ## TCP-сервер
  UdpSock*   = ptr QUdpSocket             ## UDP-сокет
  SslSock*   = ptr QSslSocket             ## SSL/TLS-сокет
  LocSock*   = ptr QLocalSocket           ## Unix domain / named pipe сокет
  LocSrv*    = ptr QLocalServer           ## Unix domain / named pipe сервер
  DiskCache* = ptr QNetworkDiskCache      ## Дисковый кэш HTTP

# ═════════════════════════════════════════════════════════════════════════════
# § 3. Enums
# ═════════════════════════════════════════════════════════════════════════════

# ── QNetworkReply::NetworkError ───────────────────────────────────────────────
type
  NetworkError* {.size: sizeof(cint).} = enum
    ## Операция выполнена успешно
    NoError                           = 0
    ## Ошибка соединения
    ConnectionRefusedError            = 1
    ## Удалённый узел закрыл соединение
    RemoteHostClosedError             = 2
    ## Узел не найден
    HostNotFoundError                 = 3
    ## Таймаут соединения
    TimeoutError                      = 4
    ## Операция отменена (abort())
    OperationCanceledError            = 5
    ## SSL-рукопожатие провалилось
    SslHandshakeFailedError           = 6
    ## Временный сетевой сбой
    TemporaryNetworkFailureError      = 7
    ## Сеть недоступна (нет маршрута)
    NetworkSessionFailedError         = 8
    ## Истёк срок действия фонового доступа
    BackgroundRequestNotAllowedError  = 9
    ## TooManyRedirectsError (Qt 5.6+)
    TooManyRedirectsError             = 10
    ## Небезопасное перенаправление (Qt 5.9+)
    InsecureRedirectError             = 11
    ## Ошибка прокси-соединения
    ProxyConnectionRefusedError       = 101
    ## Прокси закрыл соединение
    ProxyConnectionClosedError        = 102
    ## Прокси не найден
    ProxyNotFoundError                = 103
    ## Таймаут прокси
    ProxyTimeoutError                 = 104
    ## Требуется аутентификация прокси
    ProxyAuthenticationRequiredError  = 105
    ## Ошибка содержимого ответа
    ContentAccessDenied               = 201
    ## Требуется аутентификация
    ContentOperationNotPermittedError = 202
    ## Ресурс не найден (404)
    ContentNotFoundError              = 203
    ## Требуется аутентификация (401)
    AuthenticationRequiredError       = 204
    ## Ресурс повторно отправлен (409)
    ContentReSendError                = 205
    ## Конфликт содержимого
    ContentConflictError              = 206
    ## Ресурс удалён (410)
    ContentGoneError                  = 207
    ## Ошибка протокола
    InternalServerError               = 401
    ## Операция не поддерживается
    OperationNotImplementedError      = 402
    ## Ошибка сервиса недоступна
    ServiceUnavailableError           = 403
    ## Неизвестная ошибка протокола
    ProtocolUnknownError              = 301
    ## Некорректный URL
    ProtocolInvalidOperationError     = 302
    ## Ошибка при загрузке
    UnknownNetworkError               = 99
    ## Неизвестная ошибка прокси
    UnknownProxyError                 = 199
    ## Неизвестная ошибка содержимого
    UnknownContentError               = 299
    ## Неизвестная ошибка протокола
    ProtocolFailure                   = 399
    ## Неизвестная ошибка сервера
    UnknownServerError                = 499

# ── QNetworkAccessManager::Operation ─────────────────────────────────────────
type
  NetworkOperation* {.size: sizeof(cint).} = enum
    ## HEAD
    HeadOperation   = 1
    ## GET
    GetOperation    = 2
    ## PUT
    PutOperation    = 3
    ## POST
    PostOperation   = 4
    ## DELETE
    DeleteOperation = 5
    ## CUSTOM (PATCH и т.п.)
    CustomOperation = 6

# ── QNetworkRequest::KnownHeaders ─────────────────────────────────────────────
type
  KnownHeader* {.size: sizeof(cint).} = enum
    ## Content-Type
    ContentTypeHeader         = 0
    ## Content-Length
    ContentLengthHeader       = 1
    ## Location (redirect)
    LocationHeader            = 2
    ## Last-Modified
    LastModifiedHeader        = 3
    ## Cookie
    CookieHeader              = 4
    ## Set-Cookie
    SetCookieHeader           = 5
    ## Content-Disposition
    ContentDispositionHeader  = 6
    ## User-Agent
    UserAgentHeader           = 7
    ## Server
    ServerHeader              = 8
    ## If-Modified-Since
    IfModifiedSinceHeader     = 9
    ## ETag
    ETagHeader                = 10
    ## If-Match
    IfMatchHeader             = 11
    ## If-None-Match
    IfNoneMatchHeader         = 12

# ── QNetworkRequest::Attribute ────────────────────────────────────────────────
type
  RequestAttribute* {.size: sizeof(cint).} = enum
    ## HTTP-код ответа (int)
    HttpStatusCodeAttribute          = 0
    ## HTTP Reason-Phrase (string)
    HttpReasonPhraseAttribute        = 1
    ## URL редиректа
    RedirectionTargetAttribute       = 2
    ## Соединение было "живым" (keep-alive)
    ConnectionEncryptedAttribute     = 3
    ## Политика кэширования
    CacheLoadControlAttribute        = 4
    ## Сохранить в кэше
    CacheSaveControlAttribute        = 5
    ## Источник данных (из сети/кэша)
    SourceIsFromCacheAttribute       = 6
    ## Метаданные кэша
    DoNotBufferUploadDataAttribute   = 7
    ## Таймаут HTTP-запроса
    HttpPipeliningAllowedAttribute   = 8
    ## HTTP pipelining был использован
    HttpPipeliningWasUsedAttribute   = 9
    ## CustomVerb (PATCH, MERGE, …)
    CustomVerbAttribute              = 10
    ## Политика cookie
    CookieLoadControlAttribute       = 11
    ## AuthenticationReuseAttribute
    AuthenticationReuseAttribute     = 12
    ## Сохранение cookies
    CookieSaveControlAttribute       = 13
    ## Версия HTTP (Http2, Http1)
    Http2AllowedAttribute            = 14
    ## HTTP/2 был использован
    Http2WasUsedAttribute            = 15
    ## Политика редиректов
    RedirectPolicyAttribute          = 18
    ## Конфигурация HTTP/2
    Http2DirectAttribute             = 19
    ## Автоматические редиректы разрешены
    AutoDeleteReplyOnFinishAttribute = 20
    ## Таймаут передачи
    TransferTimeoutAttribute         = 21

# ── QNetworkRequest::RedirectPolicy ──────────────────────────────────────────
type
  RedirectPolicy* {.size: sizeof(cint).} = enum
    ## Не следовать редиректам (по умолчанию до Qt 5.9)
    ManualRedirectPolicy          = 0
    ## Следовать, без изменения метода
    NoLessSafeRedirectPolicy      = 1
    ## Использовать метод из исходного запроса
    SameOriginRedirectPolicy      = 2
    ## Разрешить любые редиректы (Qt 5.9+)
    UserVerifiedRedirectPolicy    = 3

# ── QNetworkProxy::ProxyType ──────────────────────────────────────────────────
type
  ProxyType* {.size: sizeof(cint).} = enum
    ## Нет прокси
    NoProxy            = 2
    ## SOCKS4
    Socks5Proxy        = 3
    ## HTTP-прокси
    HttpProxy          = 4
    ## HTTP-кэширующий прокси
    HttpCachingProxy   = 5
    ## FTP-кэширующий прокси
    FtpCachingProxy    = 6
    ## Использовать системный прокси
    DefaultProxy       = 0
    ## Прокси не задан явно (fallback)
    ApplicationProxy   = 1

# ── QAbstractSocket::SocketError ─────────────────────────────────────────────
type
  SocketError* {.size: sizeof(cint).} = enum
    ## Отказ в соединении
    SockConnectionRefusedError         = 0
    ## Удалённый хост закрыл соединение
    SockRemoteHostClosedError          = 1
    ## Хост не найден
    SockHostNotFoundError              = 2
    ## Недостаточно ресурсов
    SockSocketAccessError              = 3
    ## Ресурс уже используется
    SockSocketResourceError            = 4
    ## Таймаут
    SockSocketTimeoutError             = 5
    ## Ошибка датаграммы (слишком большая)
    SockDatagramTooLargeError          = 6
    ## Ошибка сети
    SockNetworkError                   = 7
    ## Адрес уже используется
    SockAddressInUseError              = 8
    ## Адрес недоступен
    SockSocketAddressNotAvailableError = 9
    ## Неподдерживаемая операция
    SockUnsupportedSocketOperationError= 10
    ## Прокси не найден
    SockProxyAuthenticationRequiredError = 12
    ## Ошибка SSL
    SockSslHandshakeFailedError        = 13
    ## Разорвано ненормально
    SockUnfinishedSocketOperationError = 11
    ## Прокси соединение отклонено
    SockProxyConnectionRefusedError    = 14
    ## Прокси закрыл соединение
    SockProxyConnectionClosedError     = 15
    ## Таймаут прокси
    SockProxyConnectionTimeoutError    = 16
    ## Не найден прокси
    SockProxyNotFoundError             = 17
    ## Ошибка протокола прокси
    SockProxyProtocolError             = 18
    ## Ошибка операции
    SockOperationError                 = 19
    ## Ошибка SSL
    SockSslInternalError               = 20
    ## Некорректный SSL-сертификат
    SockSslInvalidUserDataError        = 21
    ## Временная ошибка
    SockTemporaryError                 = 22
    ## Неизвестная ошибка
    SockUnknownSocketError             = -1

# ── QAbstractSocket::SocketState ─────────────────────────────────────────────
type
  SocketState* {.size: sizeof(cint).} = enum
    ## Не подключён
    UnconnectedState = 0
    ## Поиск хоста
    HostLookupState  = 1
    ## Подключается
    ConnectingState  = 2
    ## Подключён
    ConnectedState   = 3
    ## Привязан (bind)
    BoundState       = 4
    ## Прослушивает (только сервер)
    ListeningState   = 5
    ## Закрывается
    ClosingState     = 6

# ── QSslError::SslError ───────────────────────────────────────────────────────
type
  SslErrorCode* {.size: sizeof(cint).} = enum
    ## Нет ошибки
    SslNoError                          = 0
    ## Сертификат просрочен
    SslCertificateExpired               = 7
    ## Сертификат ещё не действителен
    SslCertificateNotYetValid           = 9
    ## Неизвестный CA
    SslCertificateUntrusted             = 27
    ## Имя хоста не совпадает
    SslHostNameMismatch                 = 12
    ## Самоподписанный сертификат
    SslSelfSignedCertificate            = 18
    ## Самоподписанный в цепочке
    SslSelfSignedCertificateInChain     = 19
    ## Не удалось получить локальный издатель
    SslUnableToGetLocalIssuerCertificate = 20
    ## Не удалось верифицировать первый сертификат
    SslUnableToVerifyFirstCertificate   = 21
    ## Цепочка сертификатов слишком длинная
    SslCertificateChainTooLong          = 22
    ## Ошибка приложения сертификата
    SslInvalidCaCertificate             = 24
    ## Подпись не может быть проверена
    SslPathLengthExceeded               = 25
    ## Недействительный назначение сертификата
    SslInvalidPurpose                   = 26
    ## Отозванный сертификат
    SslCertificateRejected              = 28
    ## Ненадёжный сертификат
    SslNoCertificates                   = 2
    ## Неизвестная ошибка
    SslUnspecifiedError                 = -1

# ── QNetworkCookie::SameSite ──────────────────────────────────────────────────
type
  CookieSameSite* {.size: sizeof(cint).} = enum
    ## Не задан
    SameSiteDefault = 0
    ## Нет ограничений
    SameSiteNone    = 1
    ## Только тот же сайт
    SameSiteStrict  = 2
    ## Слабое ограничение
    SameSiteLax     = 3

# ── QLocalSocket::LocalSocketState ───────────────────────────────────────────
type
  LocalSocketState* {.size: sizeof(cint).} = enum
    ## Не подключён
    LocalUnconnectedState    = 0
    ## Подключается
    LocalConnectingState     = 2
    ## Подключён
    LocalConnectedState      = 3
    ## Закрывается
    LocalClosingState        = 4

# ── QSslSocket::SslMode ───────────────────────────────────────────────────────
type
  SslMode* {.size: sizeof(cint).} = enum
    ## Нет шифрования
    UnencryptedMode = 0
    ## Режим сервера TLS
    SslServerMode   = 1
    ## Режим клиента TLS
    SslClientMode   = 2

# ── QSsl::SslProtocol ─────────────────────────────────────────────────────────
type
  SslProtocol* {.size: sizeof(cint).} = enum
    ## TLS v1.0 (устарел)
    TlsV1_0             = 0
    ## TLS v1.1 (устарел)
    TlsV1_1             = 1
    ## TLS v1.2
    TlsV1_2             = 2
    ## TLS v1.3
    TlsV1_3             = 5
    ## Любой поддерживаемый TLS
    AnyProtocol         = 4
    ## Совместимый TLS
    SecureProtocols     = 3
    ## TLS v1.2+ (Qt 5.12+)
    TlsV1_2OrLater      = 6
    ## TLS v1.3+ (Qt 5.12+)
    TlsV1_3OrLater      = 7
    ## DTLS v1.0
    DtlsV1_0            = 8
    ## DTLS v1.0+ (Qt 5.12+)
    DtlsV1_0OrLater     = 9
    ## DTLS v1.2
    DtlsV1_2            = 10
    ## DTLS v1.2+ (Qt 5.12+)
    DtlsV1_2OrLater     = 11
    ## Неизвестный протокол
    UnknownProtocol     = -1

# ── QSsl::KeyType ─────────────────────────────────────────────────────────────
type
  SslKeyType* {.size: sizeof(cint).} = enum
    ## Приватный ключ
    PrivateKey = 0
    ## Публичный ключ
    PublicKey  = 1

# ── QSsl::KeyAlgorithm ────────────────────────────────────────────────────────
type
  SslKeyAlgorithm* {.size: sizeof(cint).} = enum
    ## Непрозрачный ключ (OpenSSL)
    Opaque = 0
    ## RSA
    Rsa    = 1
    ## DSA
    Dsa    = 2
    ## Elliptic Curve
    Ec     = 3
    ## Diffie-Hellman
    Dh     = 4

# ── QSsl::EncodingFormat ──────────────────────────────────────────────────────
type
  SslEncoding* {.size: sizeof(cint).} = enum
    ## PEM (Base64 с заголовком)
    Pem = 0
    ## DER (бинарный)
    Der = 1

# ═════════════════════════════════════════════════════════════════════════════
# § 4. QHostAddress
# ═════════════════════════════════════════════════════════════════════════════

proc newHostAddress*(): QHostAddress {.importcpp: "QHostAddress()".}

proc newHostAddressStr*(ip: string): QHostAddress =
  ## Создать QHostAddress из строки "192.168.1.1" или "::1"
  let cs = ip.cstring
  {.emit: "`result` = QHostAddress(QString::fromUtf8(`cs`));".}

proc hostAddressToString*(a: QHostAddress): string =
  ## Получить IP-адрес в виде строки
  var p: cstring
  {.emit: "QByteArray _ha = `a`.toString().toUtf8(); `p` = _ha.constData();".}
  result = $p

proc hostAddressIsNull*(a: QHostAddress): bool =
  ## true если адрес не задан
  var r: cint
  {.emit: "`r` = `a`.isNull() ? 1 : 0;".}
  result = r == 1

proc hostAddressIsLoopback*(a: QHostAddress): bool =
  ## true если адрес является петлевым (127.0.0.1, ::1)
  var r: cint
  {.emit: "`r` = `a`.isLoopback() ? 1 : 0;".}
  result = r == 1

proc hostAddressIsMulticast*(a: QHostAddress): bool =
  ## true если адрес является мультикастовым
  var r: cint
  {.emit: "`r` = `a`.isMulticast() ? 1 : 0;".}
  result = r == 1

proc hostAddressIsGlobal*(a: QHostAddress): bool =
  ## true если адрес является глобально маршрутизируемым
  var r: cint
  {.emit: "`r` = `a`.isGlobal() ? 1 : 0;".}
  result = r == 1

proc hostAddressIsIPv4*(a: QHostAddress): bool =
  ## true если адрес является IPv4
  var r: cint
  {.emit: "`r` = (`a`.protocol() == QAbstractSocket::IPv4Protocol) ? 1 : 0;".}
  result = r == 1

proc hostAddressIsIPv6*(a: QHostAddress): bool =
  ## true если адрес является IPv6
  var r: cint
  {.emit: "`r` = (`a`.protocol() == QAbstractSocket::IPv6Protocol) ? 1 : 0;".}
  result = r == 1

proc hostAddressAny*(): QHostAddress =
  ## Адрес QHostAddress::Any (0.0.0.0)
  {.emit: "`result` = QHostAddress(QHostAddress::Any);".}

proc hostAddressLocalHost*(): QHostAddress =
  ## Адрес QHostAddress::LocalHost (127.0.0.1)
  {.emit: "`result` = QHostAddress(QHostAddress::LocalHost);".}

proc hostAddressLocalHostIPv6*(): QHostAddress =
  ## Адрес QHostAddress::LocalHostIPv6 (::1)
  {.emit: "`result` = QHostAddress(QHostAddress::LocalHostIPv6);".}

proc hostAddressBroadcast*(): QHostAddress =
  ## Адрес QHostAddress::Broadcast (255.255.255.255)
  {.emit: "`result` = QHostAddress(QHostAddress::Broadcast);".}

proc hostAddressAnyIPv4*(): QHostAddress =
  ## Адрес QHostAddress::AnyIPv4
  {.emit: "`result` = QHostAddress(QHostAddress::AnyIPv4);".}

proc hostAddressAnyIPv6*(): QHostAddress =
  ## Адрес QHostAddress::AnyIPv6 (::)
  {.emit: "`result` = QHostAddress(QHostAddress::AnyIPv6);".}

proc `==`*(a, b: QHostAddress): bool =
  ## Сравнение двух адресов
  var r: cint
  {.emit: "`r` = (`a` == `b`) ? 1 : 0;".}
  result = r == 1

# ═════════════════════════════════════════════════════════════════════════════
# § 5. QHostInfo — DNS-разрешение
# ═════════════════════════════════════════════════════════════════════════════

proc hostInfoLookupHost*(hostName: string): tuple[addresses: seq[string], error: string] =
  ## Синхронное DNS-разрешение (блокирующее). Возвращает список IP и строку ошибки.
  ## Для асинхронного — используйте hostInfoLookupAsync.
  let cs = hostName.cstring
  var count: cint
  var err: cstring
  var ips: seq[string] = @[]
  {.emit: """
    QHostInfo _hi = QHostInfo::fromName(QString::fromUtf8(`cs`));
    QByteArray _errba = _hi.errorString().toUtf8();
    `err` = _errba.constData();
    `count` = _hi.addresses().size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var p: cstring
    {.emit: """
      QByteArray _ipba = _hi.addresses().at(`idx`).toString().toUtf8();
      `p` = _ipba.constData();
    """.}
    ips.add($p)
  result = (ips, $err)

proc hostInfoLocalHostName*(): string =
  ## Возвращает имя локального хоста
  var p: cstring
  {.emit: "QByteArray _lhn = QHostInfo::localHostName().toUtf8(); `p` = _lhn.constData();".}
  result = $p

proc hostInfoLocalDomainName*(): string =
  ## Возвращает домен локального хоста
  var p: cstring
  {.emit: "QByteArray _ldn = QHostInfo::localDomainName().toUtf8(); `p` = _ldn.constData();".}
  result = $p

## Callback тип для асинхронного DNS (hostName, список IP через '\n', ошибка)
type HostInfoCB* = proc(hostName: cstring, ips: cstring, err: cstring, ud: pointer) {.cdecl.}

proc hostInfoLookupAsync*(hostName: string, cb: HostInfoCB, ud: pointer) =
  ## Асинхронное DNS-разрешение. cb вызывается из event loop когда разрешение завершено.
  let cs = hostName.cstring
  {.emit: """
    QString _hn = QString::fromUtf8(`cs`);
    QHostInfo::lookupHost(_hn, [=](const QHostInfo &info){
      QByteArray _ipList;
      for (const auto &a : info.addresses()) {
        if (!_ipList.isEmpty()) _ipList += '\n';
        _ipList += a.toString().toUtf8();
      }
      QByteArray _errba = info.errorString().toUtf8();
      QByteArray _hnba  = _hn.toUtf8();
      `cb`(_hnba.constData(), _ipList.constData(), _errba.constData(), `ud`);
    });
  """.}

proc hostInfoAbortHostLookup*(lookupId: cint) =
  ## Отменить асинхронный поиск по идентификатору
  {.emit: "QHostInfo::abortHostLookup(`lookupId`);".}

# ═════════════════════════════════════════════════════════════════════════════
# § 6. QNetworkInterface / QNetworkAddressEntry
# ═════════════════════════════════════════════════════════════════════════════

proc networkInterfaceAllAddresses*(): seq[string] =
  ## Список всех IP-адресов всех сетевых интерфейсов
  result = @[]
  var count: cint
  {.emit: """
    static QList<QHostAddress> _allAddr = QNetworkInterface::allAddresses();
    `count` = _allAddr.size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var p: cstring
    {.emit: "QByteArray _aba = _allAddr.at(`idx`).toString().toUtf8(); `p` = _aba.constData();".}
    result.add($p)

proc networkInterfaceAllNames*(): seq[string] =
  ## Список имён всех сетевых интерфейсов
  result = @[]
  var count: cint
  {.emit: """
    QList<QNetworkInterface> _ifaces = QNetworkInterface::allInterfaces();
    `count` = _ifaces.size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var p: cstring
    {.emit: "QByteArray _iba = _ifaces.at(`idx`).name().toUtf8(); `p` = _iba.constData();".}
    result.add($p)

proc networkInterfaceHardwareAddress*(ifaceName: string): string =
  ## MAC-адрес интерфейса в формате "AA:BB:CC:DD:EE:FF"
  let cs = ifaceName.cstring
  var p: cstring
  {.emit: """
    QNetworkInterface _if = QNetworkInterface::interfaceFromName(QString::fromUtf8(`cs`));
    QByteArray _mac = _if.hardwareAddress().toUtf8();
    `p` = _mac.constData();
  """.}
  result = $p

proc networkInterfaceIsUp*(ifaceName: string): bool =
  ## true если интерфейс находится в состоянии UP
  let cs = ifaceName.cstring
  var r: cint
  {.emit: """
    QNetworkInterface _if2 = QNetworkInterface::interfaceFromName(QString::fromUtf8(`cs`));
    `r` = _if2.flags().testFlag(QNetworkInterface::IsUp) ? 1 : 0;
  """.}
  result = r == 1

proc networkInterfaceIsRunning*(ifaceName: string): bool =
  ## true если интерфейс работает (IsRunning)
  let cs = ifaceName.cstring
  var r: cint
  {.emit: """
    QNetworkInterface _if3 = QNetworkInterface::interfaceFromName(QString::fromUtf8(`cs`));
    `r` = _if3.flags().testFlag(QNetworkInterface::IsRunning) ? 1 : 0;
  """.}
  result = r == 1

proc networkInterfaceAddresses*(ifaceName: string): seq[tuple[ip: string, prefix: int]] =
  ## IP-адреса и длины префиксов для интерфейса
  let cs = ifaceName.cstring
  var count: cint
  result = @[]
  {.emit: """
    QNetworkInterface _if4 = QNetworkInterface::interfaceFromName(QString::fromUtf8(`cs`));
    static QList<QNetworkAddressEntry> _entries = _if4.addressEntries();
    `count` = _entries.size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var ip: cstring
    var pfx: cint
    {.emit: """
      QByteArray _eip = _entries.at(`idx`).ip().toString().toUtf8();
      `ip` = _eip.constData();
      `pfx` = _entries.at(`idx`).prefixLength();
    """.}
    result.add(($ip, pfx.int))

# ═════════════════════════════════════════════════════════════════════════════
# § 7. QNetworkProxy
# ═════════════════════════════════════════════════════════════════════════════

proc newNetworkProxy*(ptype: ProxyType, hostName: string,
                      port: uint16, user: string = "",
                      password: string = ""): QNetworkProxy =
  ## Создать прокси (HTTP, SOCKS5 и т.п.)
  let cs = hostName.cstring
  let cu = user.cstring
  let cp = password.cstring
  let pt = ptype.cint
  let po = port.cint
  {.emit: """
    `result` = QNetworkProxy(
      static_cast<QNetworkProxy::ProxyType>(`pt`),
      QString::fromUtf8(`cs`), `po`,
      QString::fromUtf8(`cu`),
      QString::fromUtf8(`cp`));
  """.}

proc networkProxySetApplicationProxy*(proxy: QNetworkProxy) =
  ## Установить глобальный прокси для всего приложения
  {.emit: "QNetworkProxy::setApplicationProxy(`proxy`);".}

proc networkProxyGetApplicationProxy*(): QNetworkProxy =
  ## Получить текущий глобальный прокси приложения
  {.emit: "`result` = QNetworkProxy::applicationProxy();".}

proc networkProxyHostName*(proxy: QNetworkProxy): string =
  var p: cstring
  {.emit: "QByteArray _phn = `proxy`.hostName().toUtf8(); `p` = _phn.constData();".}
  result = $p

proc networkProxyPort*(proxy: QNetworkProxy): int =
  var v: cint
  {.emit: "`v` = `proxy`.port();".}
  result = v.int

proc networkProxyUser*(proxy: QNetworkProxy): string =
  var p: cstring
  {.emit: "QByteArray _pun = `proxy`.user().toUtf8(); `p` = _pun.constData();".}
  result = $p

proc networkProxyType*(proxy: QNetworkProxy): ProxyType =
  var v: cint
  {.emit: "`v` = static_cast<int>(`proxy`.type());".}
  result = ProxyType(v)

# ═════════════════════════════════════════════════════════════════════════════
# § 8. QAuthenticator
# ═════════════════════════════════════════════════════════════════════════════

proc authenticatorUser*(a: ptr QAuthenticator): string =
  ## Имя пользователя из запроса аутентификации
  var p: cstring
  {.emit: "QByteArray _au = `a`->user().toUtf8(); `p` = _au.constData();".}
  result = $p

proc authenticatorRealm*(a: ptr QAuthenticator): string =
  ## Realm из запроса аутентификации
  var p: cstring
  {.emit: "QByteArray _ar = `a`->realm().toUtf8(); `p` = _ar.constData();".}
  result = $p

proc authenticatorSetUser*(a: ptr QAuthenticator, user: string) =
  ## Установить имя пользователя
  let cs = user.cstring
  {.emit: "`a`->setUser(QString::fromUtf8(`cs`));".}

proc authenticatorSetPassword*(a: ptr QAuthenticator, password: string) =
  ## Установить пароль
  let cs = password.cstring
  {.emit: "`a`->setPassword(QString::fromUtf8(`cs`));".}

# ═════════════════════════════════════════════════════════════════════════════
# § 9. QSslCertificate / QSslKey / QSslCipher / QSslConfiguration / QSslError
# ═════════════════════════════════════════════════════════════════════════════

proc sslCertFromPemFile*(path: string): QSslCertificate =
  ## Загрузить сертификат из PEM-файла
  let cs = path.cstring
  {.emit: """
    QFile _certFile(QString::fromUtf8(`cs`));
    _certFile.open(QIODevice::ReadOnly);
    QList<QSslCertificate> _certs = QSslCertificate::fromDevice(&_certFile, QSsl::Pem);
    if (!_certs.isEmpty()) `result` = _certs.first();
  """.}

proc sslCertFromPemData*(pem: string): QSslCertificate =
  ## Загрузить сертификат из PEM-строки
  let cs = pem.cstring
  {.emit: """
    QList<QSslCertificate> _certs2 = QSslCertificate::fromData(
      QByteArray::fromRawData(`cs`, (int)strlen(`cs`)), QSsl::Pem);
    if (!_certs2.isEmpty()) `result` = _certs2.first();
  """.}

proc sslCertIsNull*(cert: QSslCertificate): bool =
  var r: cint
  {.emit: "`r` = `cert`.isNull() ? 1 : 0;".}
  result = r == 1

proc sslCertIsValid*(cert: QSslCertificate): bool =
  var r: cint
  {.emit: "`r` = !`cert`.isNull() && `cert`.effectiveDate() <= QDateTime::currentDateTimeUtc() "  &
           "&& `cert`.expiryDate() >= QDateTime::currentDateTimeUtc() ? 1 : 0;".}
  result = r == 1

proc sslCertIssuerOrganization*(cert: QSslCertificate): string =
  var p: cstring
  {.emit: """
    QStringList _io = `cert`.issuerInfo(QSslCertificate::Organization);
    QByteArray _ioba = _io.isEmpty() ? QByteArray() : _io.first().toUtf8();
    `p` = _ioba.constData();
  """.}
  result = $p

proc sslCertSubjectCommonName*(cert: QSslCertificate): string =
  var p: cstring
  {.emit: """
    QStringList _scn = `cert`.subjectInfo(QSslCertificate::CommonName);
    QByteArray _scnba = _scn.isEmpty() ? QByteArray() : _scn.first().toUtf8();
    `p` = _scnba.constData();
  """.}
  result = $p

proc sslCertEffectiveDate*(cert: QSslCertificate): string =
  var p: cstring
  {.emit: """
    QByteArray _ced = `cert`.effectiveDate().toString(Qt::ISODate).toUtf8();
    `p` = _ced.constData();
  """.}
  result = $p

proc sslCertExpiryDate*(cert: QSslCertificate): string =
  var p: cstring
  {.emit: """
    QByteArray _cexp = `cert`.expiryDate().toString(Qt::ISODate).toUtf8();
    `p` = _cexp.constData();
  """.}
  result = $p

proc sslCertToPem*(cert: QSslCertificate): string =
  var p: cstring
  {.emit: "QByteArray _cpem = `cert`.toPem(); `p` = _cpem.constData();".}
  result = $p

proc sslCertSerialNumber*(cert: QSslCertificate): string =
  var p: cstring
  {.emit: "QByteArray _csn = `cert`.serialNumber(); `p` = _csn.constData();".}
  result = $p

proc sslKeyFromPemFile*(path: string, keyType: SslKeyType = PrivateKey,
                         algo: SslKeyAlgorithm = Rsa, passPhrase: string = ""): QSslKey =
  ## Загрузить ключ из PEM-файла
  let cs = path.cstring; let cp = passPhrase.cstring
  let kt = keyType.cint; let al = algo.cint
  {.emit: """
    QFile _kf(QString::fromUtf8(`cs`));
    _kf.open(QIODevice::ReadOnly);
    `result` = QSslKey(&_kf,
      static_cast<QSsl::KeyAlgorithm>(`al`),
      QSsl::Pem,
      static_cast<QSsl::KeyType>(`kt`),
      QByteArray::fromRawData(`cp`, (int)strlen(`cp`)));
  """.}

proc sslKeyIsNull*(key: QSslKey): bool =
  var r: cint
  {.emit: "`r` = `key`.isNull() ? 1 : 0;".}
  result = r == 1

proc sslConfigDefault*(): QSslConfiguration =
  ## Вернуть конфигурацию TLS по умолчанию
  {.emit: "`result` = QSslConfiguration::defaultConfiguration();".}

proc sslConfigSetProtocol*(cfg: var QSslConfiguration, proto: SslProtocol) =
  let pv = proto.cint
  {.emit: "`cfg`.setProtocol(static_cast<QSsl::SslProtocol>(`pv`));".}

proc sslConfigSetPeerVerifyMode*(cfg: var QSslConfiguration, verify: bool) =
  ## true = VerifyPeer, false = VerifyNone
  {.emit: "`cfg`.setPeerVerifyMode(`verify` ? QSslSocket::VerifyPeer : QSslSocket::VerifyNone);".}

proc sslConfigAddCaCertificate*(cfg: var QSslConfiguration, cert: QSslCertificate) =
  {.emit: "`cfg`.addCaCertificate(`cert`);".}

proc sslConfigSetLocalCertificate*(cfg: var QSslConfiguration, cert: QSslCertificate) =
  {.emit: "`cfg`.setLocalCertificate(`cert`);".}

proc sslConfigSetPrivateKey*(cfg: var QSslConfiguration, key: QSslKey) =
  {.emit: "`cfg`.setPrivateKey(`key`);".}

proc sslConfigSetDefaultConfiguration*(cfg: QSslConfiguration) =
  ## Установить конфигурацию TLS по умолчанию глобально
  {.emit: "QSslConfiguration::setDefaultConfiguration(`cfg`);".}

proc sslErrorDescription*(err: QSslError): string =
  var p: cstring
  {.emit: "QByteArray _sed = `err`.errorString().toUtf8(); `p` = _sed.constData();".}
  result = $p

proc sslErrorCode*(err: QSslError): SslErrorCode =
  var v: cint
  {.emit: "`v` = static_cast<int>(`err`.error());".}
  result = SslErrorCode(v)

# ═════════════════════════════════════════════════════════════════════════════
# § 10. QNetworkRequest
# ═════════════════════════════════════════════════════════════════════════════

proc newNetworkRequest*(url: string): QNetworkRequest =
  ## Создать HTTP-запрос по URL-строке
  let cs = url.cstring
  {.emit: "`result` = QNetworkRequest(QUrl(QString::fromUtf8(`cs`)));".}

proc networkRequestSetHeader*(req: var QNetworkRequest, name: string, value: string) =
  ## Установить произвольный HTTP-заголовок (raw)
  let cn = name.cstring; let cv = value.cstring
  {.emit: """
    `req`.setRawHeader(
      QByteArray::fromRawData(`cn`, (int)strlen(`cn`)),
      QByteArray::fromRawData(`cv`, (int)strlen(`cv`)));
  """.}

proc networkRequestSetKnownHeader*(req: var QNetworkRequest,
                                    h: KnownHeader, value: string) =
  ## Установить известный HTTP-заголовок (Content-Type, User-Agent, …)
  let hv = h.cint; let cs = value.cstring
  {.emit: """
    `req`.setHeader(
      static_cast<QNetworkRequest::KnownHeaders>(`hv`),
      QVariant(QString::fromUtf8(`cs`)));
  """.}

proc networkRequestHeader*(req: QNetworkRequest, name: string): string =
  ## Получить значение raw-заголовка
  let cn = name.cstring
  var p: cstring
  {.emit: """
    QByteArray _rhv = `req`.rawHeader(
      QByteArray::fromRawData(`cn`, (int)strlen(`cn`)));
    `p` = _rhv.constData();
  """.}
  result = $p

proc networkRequestUrl*(req: QNetworkRequest): string =
  var p: cstring
  {.emit: "QByteArray _rurl = `req`.url().toString().toUtf8(); `p` = _rurl.constData();".}
  result = $p

proc networkRequestSetSslConfig*(req: var QNetworkRequest, cfg: QSslConfiguration) =
  ## Применить TLS-конфигурацию к запросу
  {.emit: "`req`.setSslConfiguration(`cfg`);".}

proc networkRequestSetRedirectPolicy*(req: var QNetworkRequest, policy: RedirectPolicy) =
  ## Политика следования редиректам
  let pv = policy.cint
  {.emit: "`req`.setAttribute(QNetworkRequest::RedirectPolicyAttribute, `pv`);".}

proc networkRequestSetTransferTimeout*(req: var QNetworkRequest, ms: int) =
  ## Таймаут передачи в миллисекундах (Qt 5.15+/6.0+)
  let msv = ms.cint
  {.emit: "`req`.setTransferTimeout(`msv`);".}

proc networkRequestSetMaxRedirectsAllowed*(req: var QNetworkRequest, n: int) =
  ## Максимальное число редиректов
  let nv = n.cint
  {.emit: "`req`.setMaximumRedirectsAllowed(`nv`);".}

proc networkRequestSetUserAgent*(req: var QNetworkRequest, ua: string) =
  ## Удобный метод: установить User-Agent
  req.networkRequestSetKnownHeader(UserAgentHeader, ua)

proc networkRequestSetContentType*(req: var QNetworkRequest, ct: string) =
  ## Удобный метод: установить Content-Type
  req.networkRequestSetKnownHeader(ContentTypeHeader, ct)

proc networkRequestSetBearerToken*(req: var QNetworkRequest, token: string) =
  ## Установить Authorization: Bearer <token>
  req.networkRequestSetHeader("Authorization", "Bearer " & token)

# ═════════════════════════════════════════════════════════════════════════════
# § 11. QNetworkReply
# ═════════════════════════════════════════════════════════════════════════════

proc replyReadAll*(reply: NetReply): string =
  ## Прочитать все доступные данные из ответа
  var p: cstring
  var sz: cint
  {.emit: """
    QByteArray _rba = `reply`->readAll();
    `sz` = _rba.size();
    `p` = _rba.constData();
  """.}
  result = newString(sz.int)
  if sz > 0:
    copyMem(result[0].addr, p, sz.int)

proc replyReadBytes*(reply: NetReply, maxBytes: int): string =
  ## Прочитать до maxBytes байт
  let mv = maxBytes.cint
  var p: cstring; var sz: cint
  {.emit: """
    QByteArray _rbab = `reply`->read(`mv`);
    `sz` = _rbab.size();
    `p` = _rbab.constData();
  """.}
  result = newString(sz.int)
  if sz > 0:
    copyMem(result[0].addr, p, sz.int)

proc replyStatusCode*(reply: NetReply): int =
  ## HTTP-код ответа (200, 404, …)
  var v: cint
  {.emit: """
    `v` = `reply`->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
  """.}
  result = v.int

proc replyReasonPhrase*(reply: NetReply): string =
  ## HTTP Reason-Phrase ("OK", "Not Found", …)
  var p: cstring
  {.emit: """
    QByteArray _rph = `reply`->attribute(
      QNetworkRequest::HttpReasonPhraseAttribute).toByteArray();
    `p` = _rph.constData();
  """.}
  result = $p

proc replyHeader*(reply: NetReply, name: string): string =
  ## Получить HTTP-заголовок ответа по имени
  let cn = name.cstring
  var p: cstring
  {.emit: """
    QByteArray _rhdr = `reply`->rawHeader(
      QByteArray::fromRawData(`cn`, (int)strlen(`cn`)));
    `p` = _rhdr.constData();
  """.}
  result = $p

proc replyContentType*(reply: NetReply): string =
  ## Content-Type из ответа
  result = reply.replyHeader("Content-Type")

proc replyContentLength*(reply: NetReply): int64 =
  ## Content-Length из ответа (-1 если неизвестен)
  var v: clonglong
  {.emit: """
    `v` = `reply`->header(QNetworkRequest::ContentLengthHeader).toLongLong();
  """.}
  result = v.int64

proc replyUrl*(reply: NetReply): string =
  ## URL из ответа (после редиректов — финальный)
  var p: cstring
  {.emit: "QByteArray _rurl2 = `reply`->url().toString().toUtf8(); `p` = _rurl2.constData();".}
  result = $p

proc replyRedirectUrl*(reply: NetReply): string =
  ## URL редиректа (если есть)
  var p: cstring
  {.emit: """
    QByteArray _rredurl = `reply`->attribute(
      QNetworkRequest::RedirectionTargetAttribute).toUrl().toString().toUtf8();
    `p` = _rredurl.constData();
  """.}
  result = $p

proc replyError*(reply: NetReply): NetworkError =
  var v: cint
  {.emit: "`v` = static_cast<int>(`reply`->error());".}
  result = NetworkError(v)

proc replyErrorString*(reply: NetReply): string =
  var p: cstring
  {.emit: "QByteArray _res = `reply`->errorString().toUtf8(); `p` = _res.constData();".}
  result = $p

proc replyIsFinished*(reply: NetReply): bool =
  var r: cint
  {.emit: "`r` = `reply`->isFinished() ? 1 : 0;".}
  result = r == 1

proc replyBytesAvailable*(reply: NetReply): int64 =
  var v: clonglong
  {.emit: "`v` = `reply`->bytesAvailable();".}
  result = v.int64

proc replyBytesReceived*(reply: NetReply): int64 =
  var v: clonglong
  {.emit: "`v` = `reply`->bytesReceived();".}
  result = v.int64

proc replyAbort*(reply: NetReply) =
  ## Прервать текущую операцию
  {.emit: "`reply`->abort();".}

proc replyClose*(reply: NetReply) =
  ## Закрыть поток ответа
  {.emit: "`reply`->close();".}

proc replyDelete*(reply: NetReply) =
  ## Удалить объект ответа (освободить память)
  {.emit: "delete `reply`;".}

proc replyDeleteLater*(reply: NetReply) =
  ## Безопасное удаление через deleteLater()
  {.emit: "`reply`->deleteLater();".}

proc replyAllHeaders*(reply: NetReply): seq[tuple[name: string, value: string]] =
  ## Все HTTP-заголовки ответа как список пар ключ-значение
  result = @[]
  var count: cint
  {.emit: """
    static QList<QByteArray> _hnames = `reply`->rawHeaderList();
    `count` = _hnames.size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var n, v: cstring
    {.emit: """
      QByteArray _hn = _hnames.at(`idx`);
      QByteArray _hv = `reply`->rawHeader(_hn);
      `n` = _hn.constData();
      `v` = _hv.constData();
    """.}
    result.add(($n, $v))

# ── Сигналы QNetworkReply ─────────────────────────────────────────────────────

proc replyOnFinished*(reply: NetReply, cb: CB, ud: pointer) =
  ## Сигнал finished() — вызывается когда запрос завершён
  {.emit: """
    QObject::connect(`reply`, &QNetworkReply::finished, [=](){
      `cb`(`ud`);
    });
  """.}

proc replyOnReadyRead*(reply: NetReply, cb: CB, ud: pointer) =
  ## Сигнал readyRead() — данные доступны для чтения
  {.emit: """
    QObject::connect(`reply`, &QNetworkReply::readyRead, [=](){
      `cb`(`ud`);
    });
  """.}

type ReplyErrorCB* = proc(err: cint, ud: pointer) {.cdecl.}

proc replyOnError*(reply: NetReply, cb: ReplyErrorCB, ud: pointer) =
  ## Сигнал errorOccurred() — ошибка сети
  {.emit: """
    QObject::connect(`reply`, &QNetworkReply::errorOccurred,
      [=](QNetworkReply::NetworkError e){
        `cb`(static_cast<int>(e), `ud`);
      });
  """.}

type ProgressCB* = proc(received, total: clonglong, ud: pointer) {.cdecl.}

proc replyOnDownloadProgress*(reply: NetReply, cb: ProgressCB, ud: pointer) =
  ## Сигнал downloadProgress(received, total)
  {.emit: """
    QObject::connect(`reply`, &QNetworkReply::downloadProgress,
      [=](qint64 r, qint64 t){
        `cb`(r, t, `ud`);
      });
  """.}

proc replyOnUploadProgress*(reply: NetReply, cb: ProgressCB, ud: pointer) =
  ## Сигнал uploadProgress(sent, total)
  {.emit: """
    QObject::connect(`reply`, &QNetworkReply::uploadProgress,
      [=](qint64 r, qint64 t){
        `cb`(r, t, `ud`);
      });
  """.}

type SslErrorsCB* = proc(errCount: cint, ud: pointer) {.cdecl.}

proc replyOnSslErrors*(reply: NetReply, cb: SslErrorsCB, ud: pointer) =
  ## Сигнал sslErrors() — SSL-ошибки (можно вызвать ignoreSslErrors)
  {.emit: """
    QObject::connect(`reply`, &QNetworkReply::sslErrors,
      [=](const QList<QSslError> &errs){
        `cb`(errs.size(), `ud`);
      });
  """.}

proc replyIgnoreSslErrors*(reply: NetReply) =
  ## Игнорировать SSL-ошибки (небезопасно! только для отладки)
  {.emit: "`reply`->ignoreSslErrors();".}

proc replySetReadBufferSize*(reply: NetReply, size: int64) =
  ## Установить размер буфера чтения
  let sv = size.clonglong
  {.emit: "`reply`->setReadBufferSize(`sv`);".}

# ═════════════════════════════════════════════════════════════════════════════
# § 12. QNetworkAccessManager
# ═════════════════════════════════════════════════════════════════════════════

proc newNetworkAccessManager*(parent: Obj = nil): NetMgr =
  ## Создать менеджер HTTP-запросов
  {.emit: "`result` = new QNetworkAccessManager(`parent`);".}

proc namDelete*(nam: NetMgr) =
  ## Удалить менеджер
  {.emit: "delete `nam`;".}

proc namGet*(nam: NetMgr, req: QNetworkRequest): NetReply =
  ## HTTP GET
  {.emit: "`result` = `nam`->get(`req`);".}

proc namPost*(nam: NetMgr, req: QNetworkRequest, data: string): NetReply =
  ## HTTP POST с телом из строки (данные копируются)
  let cs = data.cstring; let sz = data.len.cint
  {.emit: """
    `result` = `nam`->post(`req`,
      QByteArray::fromRawData(`cs`, `sz`));
  """.}

proc namPostBytes*(nam: NetMgr, req: QNetworkRequest,
                   data: openArray[byte]): NetReply =
  ## HTTP POST с бинарными данными
  let cs = cast[cstring](data[0].addr); let sz = data.len.cint
  {.emit: """
    `result` = `nam`->post(`req`,
      QByteArray::fromRawData(`cs`, `sz`));
  """.}

proc namPut*(nam: NetMgr, req: QNetworkRequest, data: string): NetReply =
  ## HTTP PUT
  let cs = data.cstring; let sz = data.len.cint
  {.emit: """
    `result` = `nam`->put(`req`,
      QByteArray::fromRawData(`cs`, `sz`));
  """.}

proc namDelete*(nam: NetMgr, req: QNetworkRequest): NetReply =
  ## HTTP DELETE
  {.emit: "`result` = `nam`->deleteResource(`req`);".}

proc namHead*(nam: NetMgr, req: QNetworkRequest): NetReply =
  ## HTTP HEAD
  {.emit: "`result` = `nam`->head(`req`);".}

proc namSendCustomRequest*(nam: NetMgr, req: QNetworkRequest,
                            verb: string, data: string = ""): NetReply =
  ## Отправить произвольный HTTP-запрос (PATCH, OPTIONS, …)
  let cv = verb.cstring; let cd = data.cstring; let sz = data.len.cint
  {.emit: """
    QByteArray _verb = QByteArray::fromRawData(`cv`, (int)strlen(`cv`));
    QByteArray _body = QByteArray::fromRawData(`cd`, `sz`);
    `result` = `nam`->sendCustomRequest(`req`, _verb, _body);
  """.}

proc namPatch*(nam: NetMgr, req: QNetworkRequest, data: string): NetReply =
  ## HTTP PATCH (удобная обёртка)
  result = nam.namSendCustomRequest(req, "PATCH", data)

proc namSetProxy*(nam: NetMgr, proxy: QNetworkProxy) =
  ## Установить прокси для данного менеджера
  {.emit: "`nam`->setProxy(`proxy`);".}

proc namSetCookieJar*(nam: NetMgr, jar: ptr QNetworkCookieJar) =
  ## Установить хранилище cookies
  {.emit: "`nam`->setCookieJar(`jar`);".}

proc namCookieJar*(nam: NetMgr): ptr QNetworkCookieJar =
  ## Получить текущий jar cookies
  {.emit: "`result` = `nam`->cookieJar();".}

proc namSetCache*(nam: NetMgr, cache: ptr QAbstractNetworkCache) =
  ## Подключить кэш к менеджеру
  {.emit: "`nam`->setCache(`cache`);".}

proc namCache*(nam: NetMgr): ptr QAbstractNetworkCache =
  {.emit: "`result` = `nam`->cache();".}

proc namSetAutoDeleteReplies*(nam: NetMgr, enabled: bool) =
  ## Автоматически удалять ответы после завершения (Qt 5.14+)
  let bv = enabled.cint
  {.emit: "`nam`->setAutoDeleteReplies(`bv`);".}

proc namSetTransferTimeout*(nam: NetMgr, ms: int) =
  ## Глобальный таймаут передачи для всего менеджера (Qt 5.15+/6.0+)
  let msv = ms.cint
  {.emit: "`nam`->setTransferTimeout(`msv`);".}

proc namClearAccessCache*(nam: NetMgr) =
  ## Очистить кэш доступа (соединения, авторизацию)
  {.emit: "`nam`->clearAccessCache();".}

proc namClearConnectionCache*(nam: NetMgr) =
  ## Очистить кэш соединений (Qt 5.9+/6.0+)
  {.emit: "`nam`->clearConnectionCache();".}

# ── Сигналы QNetworkAccessManager ────────────────────────────────────────────

type AuthCB* = proc(user: cstring, realm: cstring, ud: pointer) {.cdecl.}

proc namOnAuthenticationRequired*(nam: NetMgr, cb: AuthCB, ud: pointer) =
  ## Сигнал authenticationRequired — запрос логина/пароля
  {.emit: """
    QObject::connect(`nam`, &QNetworkAccessManager::authenticationRequired,
      [=](QNetworkReply*, QAuthenticator* auth){
        QByteArray _auba = auth->user().toUtf8();
        QByteArray _arba = auth->realm().toUtf8();
        `cb`(_auba.constData(), _arba.constData(), `ud`);
      });
  """.}

type ReplyFinishedCB* = proc(reply: pointer, ud: pointer) {.cdecl.}

proc namOnFinished*(nam: NetMgr, cb: ReplyFinishedCB, ud: pointer) =
  ## Сигнал finished(QNetworkReply*) — любой запрос завершён
  {.emit: """
    QObject::connect(`nam`, &QNetworkAccessManager::finished,
      [=](QNetworkReply* r){
        `cb`(r, `ud`);
      });
  """.}

type SslErrorsWithReplyCB* = proc(reply: pointer, errCount: cint, ud: pointer) {.cdecl.}

proc namOnSslErrors*(nam: NetMgr, cb: SslErrorsWithReplyCB, ud: pointer) =
  ## Сигнал sslErrors(reply, errors)
  {.emit: """
    QObject::connect(`nam`, &QNetworkAccessManager::sslErrors,
      [=](QNetworkReply* r, const QList<QSslError>& errs){
        `cb`(r, errs.size(), `ud`);
      });
  """.}

proc namOnProxyAuthenticationRequired*(nam: NetMgr, cb: AuthCB, ud: pointer) =
  ## Сигнал proxyAuthenticationRequired
  {.emit: """
    QObject::connect(`nam`, &QNetworkAccessManager::proxyAuthenticationRequired,
      [=](const QNetworkProxy&, QAuthenticator* auth){
        QByteArray _puba = auth->user().toUtf8();
        QByteArray _prba = auth->realm().toUtf8();
        `cb`(_puba.constData(), _prba.constData(), `ud`);
      });
  """.}

# ═════════════════════════════════════════════════════════════════════════════
# § 13. QNetworkCookieJar / QNetworkCookie
# ═════════════════════════════════════════════════════════════════════════════

proc newNetworkCookieJar*(parent: Obj = nil): ptr QNetworkCookieJar =
  {.emit: "`result` = new QNetworkCookieJar(`parent`);".}

proc cookieJarDelete*(jar: ptr QNetworkCookieJar) =
  {.emit: "delete `jar`;".}

proc cookieJarCookiesForUrl*(jar: ptr QNetworkCookieJar,
                              url: string): seq[tuple[name: string, value: string]] =
  ## Cookies для данного URL
  let cs = url.cstring
  var count: cint
  result = @[]
  {.emit: """
    static QList<QNetworkCookie> _cookies =
      `jar`->cookiesForUrl(QUrl(QString::fromUtf8(`cs`)));
    `count` = _cookies.size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var n, v: cstring
    {.emit: """
      QByteArray _cn = _cookies.at(`idx`).name();
      QByteArray _cv = _cookies.at(`idx`).value();
      `n` = _cn.constData();
      `v` = _cv.constData();
    """.}
    result.add(($n, $v))

proc cookieJarSetCookiesFromUrl*(jar: ptr QNetworkCookieJar,
                                  url: string,
                                  name: string, value: string): bool =
  ## Установить cookie для URL
  let cu = url.cstring; let cn = name.cstring; let cv = value.cstring
  var r: cint
  {.emit: """
    QNetworkCookie _nc(
      QByteArray::fromRawData(`cn`, (int)strlen(`cn`)),
      QByteArray::fromRawData(`cv`, (int)strlen(`cv`)));
    QList<QNetworkCookie> _ncl; _ncl << _nc;
    `r` = `jar`->setCookiesFromUrl(_ncl, QUrl(QString::fromUtf8(`cu`))) ? 1 : 0;
  """.}
  result = r == 1

proc cookieJarDeleteCookie*(jar: ptr QNetworkCookieJar, name: string) =
  ## Удалить cookie по имени (из всех URL)
  let cn = name.cstring
  {.emit: """
    QNetworkCookie _dnc(QByteArray::fromRawData(`cn`, (int)strlen(`cn`)));
    `jar`->deleteCookie(_dnc);
  """.}

proc cookieNew*(name: string, value: string): QNetworkCookie =
  ## Создать QNetworkCookie с именем и значением
  let cn = name.cstring; let cv = value.cstring
  {.emit: """
    `result` = QNetworkCookie(
      QByteArray::fromRawData(`cn`, (int)strlen(`cn`)),
      QByteArray::fromRawData(`cv`, (int)strlen(`cv`)));
  """.}

proc cookieSetDomain*(c: var QNetworkCookie, domain: string) =
  let cs = domain.cstring
  {.emit: "`c`.setDomain(QString::fromUtf8(`cs`));".}

proc cookieSetPath*(c: var QNetworkCookie, path: string) =
  let cs = path.cstring
  {.emit: "`c`.setPath(QString::fromUtf8(`cs`));".}

proc cookieSetSecure*(c: var QNetworkCookie, secure: bool) =
  {.emit: "`c`.setSecure(`secure`);".}

proc cookieSetHttpOnly*(c: var QNetworkCookie, httpOnly: bool) =
  {.emit: "`c`.setHttpOnly(`httpOnly`);".}

proc cookieSetSameSitePolicy*(c: var QNetworkCookie, policy: CookieSameSite) =
  let pv = policy.cint
  {.emit: "`c`.setSameSitePolicy(static_cast<QNetworkCookie::SameSite>(`pv`));".}

proc cookieToRawForm*(c: QNetworkCookie): string =
  ## Сериализовать cookie в заголовочный формат
  var p: cstring
  {.emit: "QByteArray _craw = `c`.toRawForm(); `p` = _craw.constData();".}
  result = $p

proc cookieName*(c: QNetworkCookie): string =
  var p: cstring
  {.emit: "QByteArray _cname = `c`.name(); `p` = _cname.constData();".}
  result = $p

proc cookieValue*(c: QNetworkCookie): string =
  var p: cstring
  {.emit: "QByteArray _cval = `c`.value(); `p` = _cval.constData();".}
  result = $p

# ═════════════════════════════════════════════════════════════════════════════
# § 14. QNetworkDiskCache
# ═════════════════════════════════════════════════════════════════════════════

proc newNetworkDiskCache*(parent: Obj = nil): DiskCache =
  {.emit: "`result` = new QNetworkDiskCache(`parent`);".}

proc diskCacheSetCacheDirectory*(cache: DiskCache, path: string) =
  ## Установить директорию кэша
  let cs = path.cstring
  {.emit: "`cache`->setCacheDirectory(QString::fromUtf8(`cs`));".}

proc diskCacheCacheDirectory*(cache: DiskCache): string =
  var p: cstring
  {.emit: "QByteArray _dcd = `cache`->cacheDirectory().toUtf8(); `p` = _dcd.constData();".}
  result = $p

proc diskCacheSetMaximumCacheSize*(cache: DiskCache, bytes: int64) =
  ## Максимальный размер кэша в байтах
  let sv = bytes.clonglong
  {.emit: "`cache`->setMaximumCacheSize(`sv`);".}

proc diskCacheMaximumCacheSize*(cache: DiskCache): int64 =
  var v: clonglong
  {.emit: "`v` = `cache`->maximumCacheSize();".}
  result = v.int64

proc diskCacheCurrentCacheSize*(cache: DiskCache): int64 =
  var v: clonglong
  {.emit: "`v` = `cache`->cacheSize();".}
  result = v.int64

proc diskCacheClear*(cache: DiskCache) =
  ## Очистить весь кэш
  {.emit: "`cache`->clear();".}

proc diskCacheDelete*(cache: DiskCache) =
  {.emit: "delete `cache`;".}

# ═════════════════════════════════════════════════════════════════════════════
# § 15. QAbstractSocket / QTcpSocket / QTcpServer
# ═════════════════════════════════════════════════════════════════════════════

# ── QTcpSocket ────────────────────────────────────────────────────────────────

proc newTcpSocket*(parent: Obj = nil): TcpSock =
  {.emit: "`result` = new QTcpSocket(`parent`);".}

proc tcpSocketDelete*(s: TcpSock) =
  {.emit: "delete `s`;".}

proc tcpSocketConnectToHost*(s: TcpSock, host: string, port: uint16) =
  ## Подключиться к хосту (асинхронно)
  let cs = host.cstring; let pv = port.cint
  {.emit: "`s`->connectToHost(QString::fromUtf8(`cs`), `pv`);".}

proc tcpSocketConnectToHostSync*(s: TcpSock, host: string,
                                  port: uint16, timeoutMs: int = 30000): bool =
  ## Синхронное подключение с таймаутом
  let cs = host.cstring; let pv = port.cint; let tv = timeoutMs.cint
  var r: cint
  {.emit: """
    `s`->connectToHost(QString::fromUtf8(`cs`), `pv`);
    `r` = `s`->waitForConnected(`tv`) ? 1 : 0;
  """.}
  result = r == 1

proc tcpSocketDisconnect*(s: TcpSock) =
  {.emit: "`s`->disconnectFromHost();".}

proc tcpSocketClose*(s: TcpSock) =
  {.emit: "`s`->close();".}

proc tcpSocketState*(s: TcpSock): SocketState =
  var v: cint
  {.emit: "`v` = static_cast<int>(`s`->state());".}
  result = SocketState(v)

proc tcpSocketIsConnected*(s: TcpSock): bool =
  result = s.tcpSocketState() == ConnectedState

proc tcpSocketWrite*(s: TcpSock, data: string): int64 =
  ## Записать строку в сокет, вернуть количество записанных байт
  let cs = data.cstring; let sz = data.len.cint
  var v: clonglong
  {.emit: """
    `v` = `s`->write(QByteArray::fromRawData(`cs`, `sz`));
  """.}
  result = v.int64

proc tcpSocketWriteBytes*(s: TcpSock, data: openArray[byte]): int64 =
  ## Записать бинарные данные
  let cs = cast[cstring](data[0].addr); let sz = data.len.cint
  var v: clonglong
  {.emit: "`v` = `s`->write(QByteArray::fromRawData(`cs`, `sz`));".}
  result = v.int64

proc tcpSocketFlush*(s: TcpSock): bool =
  var r: cint
  {.emit: "`r` = `s`->flush() ? 1 : 0;".}
  result = r == 1

proc tcpSocketWaitForBytesWritten*(s: TcpSock, ms: int = 30000): bool =
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForBytesWritten(`tv`) ? 1 : 0;".}
  result = r == 1

proc tcpSocketReadAll*(s: TcpSock): string =
  var p: cstring; var sz: cint
  {.emit: """
    QByteArray _tba = `s`->readAll();
    `sz` = _tba.size(); `p` = _tba.constData();
  """.}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc tcpSocketReadLine*(s: TcpSock, maxLen: int = 65536): string =
  let mv = maxLen.cint; var p: cstring; var sz: cint
  {.emit: """
    QByteArray _trl = `s`->readLine(`mv`);
    `sz` = _trl.size(); `p` = _trl.constData();
  """.}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc tcpSocketRead*(s: TcpSock, maxBytes: int): string =
  ## Прочитать до maxBytes байт из сокета (QIODevice::read(n))
  let mv = maxBytes.cint; var p: cstring; var sz: cint
  {.emit: """
    QByteArray _trd = `s`->read(`mv`);
    `sz` = _trd.size(); `p` = _trd.constData();
  """.}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc tcpSocketDisconnectFromHost*(s: TcpSock) =
  ## Закрыть соединение (disconnectFromHost)
  {.emit: "`s`->disconnectFromHost();".}

proc tcpSocketBytesAvailable*(s: TcpSock): int64 =
  var v: clonglong
  {.emit: "`v` = `s`->bytesAvailable();".}
  result = v.int64

proc tcpSocketWaitForReadyRead*(s: TcpSock, ms: int = 30000): bool =
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForReadyRead(`tv`) ? 1 : 0;".}
  result = r == 1

proc tcpSocketLocalAddress*(s: TcpSock): string =
  var p: cstring
  {.emit: "QByteArray _tla = `s`->localAddress().toString().toUtf8(); `p` = _tla.constData();".}
  result = $p

proc tcpSocketLocalPort*(s: TcpSock): int =
  var v: cint
  {.emit: "`v` = `s`->localPort();".}
  result = v.int

proc tcpSocketPeerAddress*(s: TcpSock): string =
  var p: cstring
  {.emit: "QByteArray _tpa = `s`->peerAddress().toString().toUtf8(); `p` = _tpa.constData();".}
  result = $p

proc tcpSocketPeerPort*(s: TcpSock): int =
  var v: cint
  {.emit: "`v` = `s`->peerPort();".}
  result = v.int

proc tcpSocketSetNoDelay*(s: TcpSock, noDelay: bool) =
  ## Установить TCP_NODELAY (Nagle)
  let bv = noDelay.cint
  {.emit: "`s`->setSocketOption(QAbstractSocket::LowDelayOption, `bv`);".}

proc tcpSocketSetKeepAlive*(s: TcpSock, keepAlive: bool) =
  ## Включить/выключить SO_KEEPALIVE
  let bv = keepAlive.cint
  {.emit: "`s`->setSocketOption(QAbstractSocket::KeepAliveOption, `bv`);".}

proc tcpSocketSetReadBufferSize*(s: TcpSock, size: int64) =
  let sv = size.clonglong
  {.emit: "`s`->setReadBufferSize(`sv`);".}

proc tcpSocketError*(s: TcpSock): SocketError =
  var v: cint
  {.emit: "`v` = static_cast<int>(`s`->error());".}
  result = SocketError(v)

proc tcpSocketErrorString*(s: TcpSock): string =
  var p: cstring
  {.emit: "QByteArray _tes = `s`->errorString().toUtf8(); `p` = _tes.constData();".}
  result = $p

# ── Сигналы QTcpSocket ────────────────────────────────────────────────────────

proc tcpSocketOnConnected*(s: TcpSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QTcpSocket::connected, [=](){ `cb`(`ud`); });".}

proc tcpSocketOnDisconnected*(s: TcpSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QTcpSocket::disconnected, [=](){ `cb`(`ud`); });".}

proc tcpSocketOnReadyRead*(s: TcpSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QTcpSocket::readyRead, [=](){ `cb`(`ud`); });".}

type TcpSocketErrorCB* = proc(err: cint, ud: pointer) {.cdecl.}

proc tcpSocketOnError*(s: TcpSock, cb: TcpSocketErrorCB, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QAbstractSocket::errorOccurred,
      [=](QAbstractSocket::SocketError e){
        `cb`(static_cast<int>(e), `ud`);
      });
  """.}

proc tcpSocketOnBytesWritten*(s: TcpSock, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QTcpSocket::bytesWritten,
      [=](qint64 n){ `cb`((int)n, `ud`); });
  """.}

proc tcpSocketOnStateChanged*(s: TcpSock, cb: CBInt, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QAbstractSocket::stateChanged,
      [=](QAbstractSocket::SocketState st){
        `cb`(static_cast<int>(st), `ud`);
      });
  """.}

# ── QTcpServer ────────────────────────────────────────────────────────────────

proc newTcpServer*(parent: Obj = nil): TcpSrv =
  {.emit: "`result` = new QTcpServer(`parent`);".}

proc tcpServerDelete*(srv: TcpSrv) =
  {.emit: "delete `srv`;".}

proc tcpServerListen*(srv: TcpSrv, address: string = "", port: uint16 = 0): bool =
  ## Начать прослушивание. address="" → QHostAddress::Any
  var r: cint
  if address.len == 0:
    let pv = port.cint
    {.emit: "`r` = `srv`->listen(QHostAddress::Any, `pv`) ? 1 : 0;".}
  else:
    let cs = address.cstring; let pv = port.cint
    {.emit: "`r` = `srv`->listen(QHostAddress(QString::fromUtf8(`cs`)), `pv`) ? 1 : 0;".}
  result = r == 1

proc tcpServerClose*(srv: TcpSrv) =
  {.emit: "`srv`->close();".}

proc tcpServerIsListening*(srv: TcpSrv): bool =
  var r: cint
  {.emit: "`r` = `srv`->isListening() ? 1 : 0;".}
  result = r == 1

proc tcpServerServerPort*(srv: TcpSrv): int =
  var v: cint
  {.emit: "`v` = `srv`->serverPort();".}
  result = v.int

proc tcpServerServerAddress*(srv: TcpSrv): string =
  var p: cstring
  {.emit: "QByteArray _ssa = `srv`->serverAddress().toString().toUtf8(); `p` = _ssa.constData();".}
  result = $p

proc tcpServerNextPendingConnection*(srv: TcpSrv): TcpSock =
  ## Принять ожидающее соединение (вернуть новый TcpSocket)
  {.emit: "`result` = `srv`->nextPendingConnection();".}

proc tcpServerHasPendingConnections*(srv: TcpSrv): bool =
  var r: cint
  {.emit: "`r` = `srv`->hasPendingConnections() ? 1 : 0;".}
  result = r == 1

proc tcpServerMaxPendingConnections*(srv: TcpSrv): int =
  var v: cint
  {.emit: "`v` = `srv`->maxPendingConnections();".}
  result = v.int

proc tcpServerSetMaxPendingConnections*(srv: TcpSrv, n: int) =
  let nv = n.cint
  {.emit: "`srv`->setMaxPendingConnections(`nv`);".}

proc tcpServerErrorString*(srv: TcpSrv): string =
  var p: cstring
  {.emit: "QByteArray _srverr = `srv`->errorString().toUtf8(); `p` = _srverr.constData();".}
  result = $p

proc tcpServerOnNewConnection*(srv: TcpSrv, cb: CB, ud: pointer) =
  ## Сигнал newConnection() — новое входящее соединение доступно
  {.emit: """
    QObject::connect(`srv`, &QTcpServer::newConnection,
      [=](){ `cb`(`ud`); });
  """.}

type NewConnectionCB* = proc(socketPtr: pointer, ud: pointer) {.cdecl.}

proc tcpServerOnNewConnectionSocket*(srv: TcpSrv, cb: NewConnectionCB, ud: pointer) =
  ## Вариант с передачей указателя на новый QTcpSocket в callback
  {.emit: """
    QObject::connect(`srv`, &QTcpServer::pendingConnectionAvailable,
      [=](){
        QTcpSocket* _ns = `srv`->nextPendingConnection();
        if (_ns) `cb`(_ns, `ud`);
      });
  """.}

proc tcpServerWaitForNewConnection*(srv: TcpSrv, ms: int = 30000): bool =
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `srv`->waitForNewConnection(`tv`) ? 1 : 0;".}
  result = r == 1

# ═════════════════════════════════════════════════════════════════════════════
# § 16. QUdpSocket / QNetworkDatagram
# ═════════════════════════════════════════════════════════════════════════════

proc newUdpSocket*(parent: Obj = nil): UdpSock =
  {.emit: "`result` = new QUdpSocket(`parent`);".}

proc udpSocketDelete*(s: UdpSock) =
  {.emit: "delete `s`;".}

proc udpSocketBind*(s: UdpSock, address: string = "",
                    port: uint16 = 0, reuseAddr: bool = false): bool =
  ## Привязать сокет к адресу/порту
  var r: cint
  let pv = port.cint
  if address.len == 0:
    if reuseAddr:
      {.emit: """
        `r` = `s`->bind(QHostAddress::Any, `pv`,
          QAbstractSocket::ReuseAddressHint | QAbstractSocket::ShareAddress) ? 1 : 0;
      """.}
    else:
      {.emit: "`r` = `s`->bind(QHostAddress::Any, `pv`) ? 1 : 0;".}
  else:
    let cs = address.cstring
    {.emit: """
      `r` = `s`->bind(QHostAddress(QString::fromUtf8(`cs`)), `pv`) ? 1 : 0;
    """.}
  result = r == 1

proc udpSocketClose*(s: UdpSock) =
  {.emit: "`s`->close();".}

proc udpSocketWriteDatagram*(s: UdpSock, data: string,
                              host: string, port: uint16): int64 =
  ## Отправить датаграмму на host:port
  let cd = data.cstring; let sz = data.len.cint
  let ch = host.cstring; let pv = port.cint
  var v: clonglong
  {.emit: """
    `v` = `s`->writeDatagram(
      QByteArray::fromRawData(`cd`, `sz`),
      QHostAddress(QString::fromUtf8(`ch`)), `pv`);
  """.}
  result = v.int64

proc udpSocketWriteDatagramBytes*(s: UdpSock, data: openArray[byte],
                                   host: string, port: uint16): int64 =
  let cd = cast[cstring](data[0].addr); let sz = data.len.cint
  let ch = host.cstring; let pv = port.cint
  var v: clonglong
  {.emit: """
    `v` = `s`->writeDatagram(
      QByteArray::fromRawData(`cd`, `sz`),
      QHostAddress(QString::fromUtf8(`ch`)), `pv`);
  """.}
  result = v.int64

proc udpSocketHasPendingDatagrams*(s: UdpSock): bool =
  var r: cint
  {.emit: "`r` = `s`->hasPendingDatagrams() ? 1 : 0;".}
  result = r == 1

proc udpSocketPendingDatagramSize*(s: UdpSock): int64 =
  var v: clonglong
  {.emit: "`v` = `s`->pendingDatagramSize();".}
  result = v.int64

proc udpSocketReceiveDatagram*(s: UdpSock): tuple[data: string, sender: string, port: int] =
  ## Принять датаграмму, вернуть данные, адрес и порт отправителя
  var p: cstring; var sz: cint
  var sender: cstring; var senderPort: cint
  {.emit: """
    QNetworkDatagram _dgram = `s`->receiveDatagram();
    QByteArray _ddata = _dgram.data();
    `sz` = _ddata.size();
    `p` = _ddata.constData();
    QByteArray _dsba = _dgram.senderAddress().toString().toUtf8();
    `sender` = _dsba.constData();
    `senderPort` = _dgram.senderPort();
  """.}
  var d = newString(sz.int)
  if sz > 0: copyMem(d[0].addr, p, sz.int)
  result = (d, $sender, senderPort.int)

proc udpSocketReadDatagram*(s: UdpSock,
                             maxSize: int = 65507): tuple[data: string, sender: string, port: int] =
  ## Альтернативный способ через readDatagram()
  let mv = maxSize.cint
  var p: cstring; var sz: cint
  var sender: cstring; var senderPort: cint
  {.emit: """
    QByteArray _buf(`mv`, 0);
    QHostAddress _rsa; quint16 _rsp = 0;
    qint64 _rsz = `s`->readDatagram(_buf.data(), `mv`, &_rsa, &_rsp);
    _buf.resize((int)_rsz);
    `sz` = _buf.size();
    `p` = _buf.constData();
    QByteArray _rsaba = _rsa.toString().toUtf8();
    `sender` = _rsaba.constData();
    `senderPort` = _rsp;
  """.}
  var d = newString(sz.int)
  if sz > 0: copyMem(d[0].addr, p, sz.int)
  result = (d, $sender, senderPort.int)

proc udpSocketJoinMulticastGroup*(s: UdpSock, groupAddress: string): bool =
  ## Присоединиться к мультикастовой группе
  let cs = groupAddress.cstring; var r: cint
  {.emit: """
    `r` = `s`->joinMulticastGroup(
      QHostAddress(QString::fromUtf8(`cs`))) ? 1 : 0;
  """.}
  result = r == 1

proc udpSocketLeaveMulticastGroup*(s: UdpSock, groupAddress: string): bool =
  ## Покинуть мультикастовую группу
  let cs = groupAddress.cstring; var r: cint
  {.emit: """
    `r` = `s`->leaveMulticastGroup(
      QHostAddress(QString::fromUtf8(`cs`))) ? 1 : 0;
  """.}
  result = r == 1

proc udpSocketLocalPort*(s: UdpSock): int =
  var v: cint
  {.emit: "`v` = `s`->localPort();".}
  result = v.int

proc udpSocketOnReadyRead*(s: UdpSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QUdpSocket::readyRead, [=](){ `cb`(`ud`); });".}

# ═════════════════════════════════════════════════════════════════════════════
# § 17. QLocalSocket / QLocalServer
# ═════════════════════════════════════════════════════════════════════════════

proc newLocalSocket*(parent: Obj = nil): LocSock =
  {.emit: "`result` = new QLocalSocket(`parent`);".}

proc localSocketDelete*(s: LocSock) =
  {.emit: "delete `s`;".}

proc localSocketConnectToServer*(s: LocSock, name: string) =
  ## Подключиться к именованному сокету/pipe
  let cs = name.cstring
  {.emit: "`s`->connectToServer(QString::fromUtf8(`cs`));".}

proc localSocketConnectToServerSync*(s: LocSock, name: string,
                                      ms: int = 5000): bool =
  let cs = name.cstring; let tv = ms.cint; var r: cint
  {.emit: """
    `s`->connectToServer(QString::fromUtf8(`cs`));
    `r` = `s`->waitForConnected(`tv`) ? 1 : 0;
  """.}
  result = r == 1

proc localSocketWaitForConnected*(s: LocSock, ms: int = 5000): bool =
  ## Ждать установки соединения после connectToServer
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForConnected(`tv`) ? 1 : 0;".}
  result = r == 1

proc localSocketDisconnect*(s: LocSock) =
  {.emit: "`s`->disconnectFromServer();".}

proc localSocketClose*(s: LocSock) =
  {.emit: "`s`->close();".}

proc localSocketState*(s: LocSock): LocalSocketState =
  var v: cint
  {.emit: "`v` = static_cast<int>(`s`->state());".}
  result = LocalSocketState(v)

proc localSocketIsConnected*(s: LocSock): bool =
  result = s.localSocketState() == LocalConnectedState

proc localSocketWrite*(s: LocSock, data: string): int64 =
  let cs = data.cstring; let sz = data.len.cint; var v: clonglong
  {.emit: "`v` = `s`->write(QByteArray::fromRawData(`cs`, `sz`));".}
  result = v.int64

proc localSocketFlush*(s: LocSock): bool =
  var r: cint
  {.emit: "`r` = `s`->flush() ? 1 : 0;".}
  result = r == 1

proc localSocketReadAll*(s: LocSock): string =
  var p: cstring; var sz: cint
  {.emit: "QByteArray _lra = `s`->readAll(); `sz` = _lra.size(); `p` = _lra.constData();".}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc localSocketRead*(s: LocSock, maxBytes: int): string =
  ## Прочитать до maxBytes байт из локального сокета (QIODevice::read(n))
  let mv = maxBytes.cint; var p: cstring; var sz: cint
  {.emit: """
    QByteArray _lrd = `s`->read(`mv`);
    `sz` = _lrd.size(); `p` = _lrd.constData();
  """.}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc localSocketDisconnectFromServer*(s: LocSock) =
  ## Закрыть соединение с сервером (disconnectFromServer)
  {.emit: "`s`->disconnectFromServer();".}

proc localSocketWaitForBytesWritten*(s: LocSock, ms: int = 5000): bool =
  ## Ждать завершения записи
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForBytesWritten(`tv`) ? 1 : 0;".}
  result = r == 1

proc localSocketErrorString*(s: LocSock): string =
  ## Строка последней ошибки
  var p: cstring
  {.emit: """
    static QByteArray _les = `s`->errorString().toUtf8();
    `p` = _les.constData();
  """.}
  result = $p

proc localSocketWaitForReadyRead*(s: LocSock, ms: int = 5000): bool =
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForReadyRead(`tv`) ? 1 : 0;".}
  result = r == 1

proc localSocketOnConnected*(s: LocSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QLocalSocket::connected, [=](){ `cb`(`ud`); });".}

proc localSocketOnDisconnected*(s: LocSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QLocalSocket::disconnected, [=](){ `cb`(`ud`); });".}

proc localSocketOnReadyRead*(s: LocSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QLocalSocket::readyRead, [=](){ `cb`(`ud`); });".}

proc localSocketOnError*(s: LocSock, cb: TcpSocketErrorCB, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QLocalSocket::errorOccurred,
      [=](QLocalSocket::LocalSocketError e){
        `cb`(static_cast<int>(e), `ud`);
      });
  """.}

proc newLocalServer*(parent: Obj = nil): LocSrv =
  {.emit: "`result` = new QLocalServer(`parent`);".}

proc localServerDelete*(srv: LocSrv) =
  {.emit: "delete `srv`;".}

proc localServerListen*(srv: LocSrv, name: string): bool =
  ## Начать прослушивание именованного сокета/pipe
  let cs = name.cstring; var r: cint
  {.emit: "`r` = `srv`->listen(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc localServerClose*(srv: LocSrv) =
  {.emit: "`srv`->close();".}

proc localServerIsListening*(srv: LocSrv): bool =
  var r: cint
  {.emit: "`r` = `srv`->isListening() ? 1 : 0;".}
  result = r == 1

proc localServerFullServerName*(srv: LocSrv): string =
  var p: cstring
  {.emit: "QByteArray _lsfn = `srv`->fullServerName().toUtf8(); `p` = _lsfn.constData();".}
  result = $p

proc localServerNextPendingConnection*(srv: LocSrv): LocSock =
  {.emit: "`result` = `srv`->nextPendingConnection();".}

proc localServerHasPendingConnections*(srv: LocSrv): bool =
  var r: cint
  {.emit: "`r` = `srv`->hasPendingConnections() ? 1 : 0;".}
  result = r == 1

proc localServerOnNewConnection*(srv: LocSrv, cb: CB, ud: pointer) =
  {.emit: """
    QObject::connect(`srv`, &QLocalServer::newConnection,
      [=](){ `cb`(`ud`); });
  """.}

proc localServerRemoveServer*(name: string): bool =
  ## Удалить существующий server socket (вызывать перед повторным listen)
  let cs = name.cstring; var r: cint
  {.emit: "`r` = QLocalServer::removeServer(QString::fromUtf8(`cs`)) ? 1 : 0;".}
  result = r == 1

proc localServerErrorString*(srv: LocSrv): string =
  ## Строка последней ошибки сервера
  var p: cstring
  {.emit: """
    static QByteArray _lses = `srv`->errorString().toUtf8();
    `p` = _lses.constData();
  """.}
  result = $p

proc localServerWaitForNewConnection*(srv: LocSrv, ms: int = 30000): bool =
  ## Ждать входящего соединения (блокирующий вызов)
  let tv = ms.cint; var r: cint
  {.emit: """
    int _msec = `tv`;
    `r` = `srv`->waitForNewConnection(_msec) ? 1 : 0;
  """.}
  result = r == 1

# ═════════════════════════════════════════════════════════════════════════════
# § 18. QSslSocket
# ═════════════════════════════════════════════════════════════════════════════

proc newSslSocket*(parent: Obj = nil): SslSock =
  {.emit: "`result` = new QSslSocket(`parent`);".}

proc sslSocketDelete*(s: SslSock) =
  {.emit: "delete `s`;".}

proc sslSocketConnectToHostEncrypted*(s: SslSock, host: string,
                                       port: uint16,
                                       serverName: string = "") =
  ## Установить TLS-соединение с хостом
  let ch = host.cstring; let pv = port.cint
  if serverName.len == 0:
    {.emit: "`s`->connectToHostEncrypted(QString::fromUtf8(`ch`), `pv`);".}
  else:
    let csn = serverName.cstring
    {.emit: """
      `s`->connectToHostEncrypted(
        QString::fromUtf8(`ch`), `pv`, QString::fromUtf8(`csn`));
    """.}

proc sslSocketWaitForEncrypted*(s: SslSock, ms: int = 30000): bool =
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForEncrypted(`tv`) ? 1 : 0;".}
  result = r == 1

proc sslSocketIsEncrypted*(s: SslSock): bool =
  var r: cint
  {.emit: "`r` = `s`->isEncrypted() ? 1 : 0;".}
  result = r == 1

proc sslSocketMode*(s: SslSock): SslMode =
  var v: cint
  {.emit: "`v` = static_cast<int>(`s`->mode());".}
  result = SslMode(v)

proc sslSocketSetSslConfiguration*(s: SslSock, cfg: QSslConfiguration) =
  {.emit: "`s`->setSslConfiguration(`cfg`);".}

proc sslSocketSslConfiguration*(s: SslSock): QSslConfiguration =
  {.emit: "`result` = `s`->sslConfiguration();".}

proc sslSocketPeerCertificate*(s: SslSock): QSslCertificate =
  ## Сертификат сервера
  {.emit: "`result` = `s`->peerCertificate();".}

proc sslSocketIgnoreSslErrors*(s: SslSock) =
  ## Игнорировать SSL-ошибки (только для отладки!)
  {.emit: "`s`->ignoreSslErrors();".}

proc sslSocketSetLocalCertificate*(s: SslSock, cert: QSslCertificate) =
  {.emit: "`s`->setLocalCertificate(`cert`);".}

proc sslSocketSetPrivateKey*(s: SslSock, key: QSslKey) =
  {.emit: "`s`->setPrivateKey(`key`);".}

proc sslSocketWrite*(s: SslSock, data: string): int64 =
  let cs = data.cstring; let sz = data.len.cint; var v: clonglong
  {.emit: "`v` = `s`->write(QByteArray::fromRawData(`cs`, `sz`));".}
  result = v.int64

proc sslSocketReadAll*(s: SslSock): string =
  var p: cstring; var sz: cint
  {.emit: "QByteArray _sra = `s`->readAll(); `sz` = _sra.size(); `p` = _sra.constData();".}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc sslSocketWaitForReadyRead*(s: SslSock, ms: int = 30000): bool =
  let tv = ms.cint; var r: cint
  {.emit: "`r` = `s`->waitForReadyRead(`tv`) ? 1 : 0;".}
  result = r == 1

proc sslSocketClose*(s: SslSock) =
  {.emit: "`s`->close();".}

proc sslSocketFlush*(s: SslSock): bool =
  var r: cint
  {.emit: "`r` = `s`->flush() ? 1 : 0;".}
  result = r == 1

proc sslSocketDisconnect*(s: SslSock) =
  {.emit: "`s`->disconnectFromHost();".}

# ── Сигналы QSslSocket ────────────────────────────────────────────────────────

proc sslSocketOnEncrypted*(s: SslSock, cb: CB, ud: pointer) =
  ## Сигнал encrypted() — TLS-рукопожатие завершено
  {.emit: "QObject::connect(`s`, &QSslSocket::encrypted, [=](){ `cb`(`ud`); });".}

proc sslSocketOnSslErrors*(s: SslSock, cb: SslErrorsCB, ud: pointer) =
  {.emit: """
    QObject::connect(`s`, &QSslSocket::sslErrors,
      [=](const QList<QSslError> &errs){
        `cb`(errs.size(), `ud`);
      });
  """.}

proc sslSocketOnConnected*(s: SslSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QSslSocket::connected, [=](){ `cb`(`ud`); });".}

proc sslSocketOnDisconnected*(s: SslSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QSslSocket::disconnected, [=](){ `cb`(`ud`); });".}

proc sslSocketOnReadyRead*(s: SslSock, cb: CB, ud: pointer) =
  {.emit: "QObject::connect(`s`, &QSslSocket::readyRead, [=](){ `cb`(`ud`); });".}

# ── Проверка поддержки SSL ────────────────────────────────────────────────────

proc sslSocketSupportsSsl*(): bool =
  ## true если OpenSSL (или другой backend) доступен в runtime
  var r: cint
  {.emit: "`r` = QSslSocket::supportsSsl() ? 1 : 0;".}
  result = r == 1

proc sslSocketSslLibraryVersionString*(): string =
  var p: cstring
  {.emit: "QByteArray _slvs = QSslSocket::sslLibraryVersionString().toUtf8(); `p` = _slvs.constData();".}
  result = $p

proc sslSocketSslLibraryBuildVersionString*(): string =
  var p: cstring
  {.emit: "QByteArray _slbvs = QSslSocket::sslLibraryBuildVersionString().toUtf8(); `p` = _slbvs.constData();".}
  result = $p

# ═════════════════════════════════════════════════════════════════════════════
# § 19. QNetworkDatagram (вспомогательные конструкторы)
# ═════════════════════════════════════════════════════════════════════════════

proc newNetworkDatagram*(data: string, destHost: string,
                          destPort: uint16): QNetworkDatagram =
  ## Создать датаграмму с данными и адресом назначения
  let cd = data.cstring; let sz = data.len.cint
  let ch = destHost.cstring; let pv = destPort.cint
  {.emit: """
    `result` = QNetworkDatagram(
      QByteArray::fromRawData(`cd`, `sz`),
      QHostAddress(QString::fromUtf8(`ch`)), `pv`);
  """.}

proc networkDatagramData*(dg: QNetworkDatagram): string =
  var p: cstring; var sz: cint
  {.emit: "QByteArray _dgd = `dg`.data(); `sz` = _dgd.size(); `p` = _dgd.constData();".}
  result = newString(sz.int)
  if sz > 0: copyMem(result[0].addr, p, sz.int)

proc networkDatagramSenderAddress*(dg: QNetworkDatagram): string =
  var p: cstring
  {.emit: "QByteArray _dgsa = `dg`.senderAddress().toString().toUtf8(); `p` = _dgsa.constData();".}
  result = $p

proc networkDatagramSenderPort*(dg: QNetworkDatagram): int =
  var v: cint
  {.emit: "`v` = `dg`.senderPort();".}
  result = v.int

proc networkDatagramDestinationAddress*(dg: QNetworkDatagram): string =
  var p: cstring
  {.emit: "QByteArray _dgda = `dg`.destinationAddress().toString().toUtf8(); `p` = _dgda.constData();".}
  result = $p

proc networkDatagramDestinationPort*(dg: QNetworkDatagram): int =
  var v: cint
  {.emit: "`v` = `dg`.destinationPort();".}
  result = v.int

# ═════════════════════════════════════════════════════════════════════════════
# § 20. QDtls / QDtlsClientVerifier
# ═════════════════════════════════════════════════════════════════════════════

proc newDtlsClient*(parent: Obj = nil): ptr QDtls =
  ## Создать DTLS-клиент
  {.emit: "`result` = new QDtls(QSslSocket::SslClientMode, `parent`);".}

proc newDtlsServer*(parent: Obj = nil): ptr QDtls =
  ## Создать DTLS-сервер
  {.emit: "`result` = new QDtls(QSslSocket::SslServerMode, `parent`);".}

proc dtlsDelete*(d: ptr QDtls) =
  {.emit: "delete `d`;".}

proc dtlsSetRemote*(d: ptr QDtls, host: string, port: uint16) =
  ## Установить удалённый адрес (для клиента)
  let cs = host.cstring; let pv = port.cint
  {.emit: "`d`->setPeer(QHostAddress(QString::fromUtf8(`cs`)), `pv`);".}

proc dtlsSetDtlsConfiguration*(d: ptr QDtls, cfg: QSslConfiguration) =
  {.emit: "`d`->setDtlsConfiguration(`cfg`);".}

proc dtlsDoHandshake*(d: ptr QDtls, sock: UdpSock, dgram: string = ""): bool =
  ## Выполнить DTLS-рукопожатие (передать датаграмму если получена)
  let cd = dgram.cstring; let sz = dgram.len.cint; var r: cint
  {.emit: """
    QByteArray _dhDgram = QByteArray::fromRawData(`cd`, `sz`);
    `r` = `d`->doHandshake(`sock`, _dhDgram) ? 1 : 0;
  """.}
  result = r == 1

proc dtlsIsConnectionEncrypted*(d: ptr QDtls): bool =
  var r: cint
  {.emit: "`r` = `d`->isConnectionEncrypted() ? 1 : 0;".}
  result = r == 1

proc dtlsWriteDatagram*(d: ptr QDtls, sock: UdpSock, data: string): int64 =
  let cs = data.cstring; let sz = data.len.cint; var v: clonglong
  {.emit: "`v` = `d`->writeDatagramEncrypted(`sock`, QByteArray::fromRawData(`cs`, `sz`));".}
  result = v.int64

proc dtlsDecryptDatagram*(d: ptr QDtls, sock: UdpSock, dgram: string): string =
  let cs = dgram.cstring; let sz = dgram.len.cint
  var p: cstring; var rsz: cint
  {.emit: """
    QByteArray _dec = `d`->decryptDatagram(`sock`,
      QByteArray::fromRawData(`cs`, `sz`));
    `rsz` = _dec.size(); `p` = _dec.constData();
  """.}
  result = newString(rsz.int)
  if rsz > 0: copyMem(result[0].addr, p, rsz.int)

proc dtlsShutdown*(d: ptr QDtls, sock: UdpSock): bool =
  var r: cint
  {.emit: "`r` = `d`->shutdown(`sock`) ? 1 : 0;".}
  result = r == 1

proc dtlsIgnoreSslErrors*(d: ptr QDtls) =
  {.emit: "`d`->ignoreVerificationErrors({});".}

proc dtlsClientVerifierNew*(parent: Obj = nil): ptr QDtlsClientVerifier =
  {.emit: "`result` = new QDtlsClientVerifier(`parent`);".}

proc dtlsClientVerifierDelete*(v: ptr QDtlsClientVerifier) =
  {.emit: "delete `v`;".}

proc dtlsClientVerifierVerifyClient*(v: ptr QDtlsClientVerifier,
                                      sock: UdpSock, dgram: string,
                                      sender: string, port: uint16): bool =
  let cs = dgram.cstring; let sz = dgram.len.cint
  let ch = sender.cstring; let pv = port.cint
  var r: cint
  {.emit: """
    `r` = `v`->verifyClient(`sock`,
      QByteArray::fromRawData(`cs`, `sz`),
      QHostAddress(QString::fromUtf8(`ch`)), `pv`) ? 1 : 0;
  """.}
  result = r == 1

# ═════════════════════════════════════════════════════════════════════════════
# § 21. QOcspResponse
# ═════════════════════════════════════════════════════════════════════════════

proc ocspResponseIsGood*(resp: QOcspResponse): bool =
  ## true если статус сертификата Good по OCSP
  var r: cint
  {.emit: "`r` = (`resp`.certificateStatus() == QOcspCertificateStatus::Good) ? 1 : 0;".}
  result = r == 1

proc ocspResponseIsRevoked*(resp: QOcspResponse): bool =
  var r: cint
  {.emit: "`r` = (`resp`.certificateStatus() == QOcspCertificateStatus::Revoked) ? 1 : 0;".}
  result = r == 1

proc ocspResponseRevocationReason*(resp: QOcspResponse): int =
  ## Причина отзыва (OcspRevocationReason enum value)
  var v: cint
  {.emit: "`v` = static_cast<int>(`resp`.revocationReason());".}
  result = v.int

# ═════════════════════════════════════════════════════════════════════════════
# § 22. QHttp2Configuration (Qt 6.0+)
# ═════════════════════════════════════════════════════════════════════════════

proc newHttp2Configuration*(): QHttp2Configuration =
  {.emit: "`result` = QHttp2Configuration();".}

proc http2ConfigSetSessionReceiveWindowSize*(cfg: var QHttp2Configuration, size: uint32) =
  ## Размер окна приёма HTTP/2 сессии
  let sv = size.cuint
  {.emit: "`cfg`.setSessionReceiveWindowSize(`sv`);".}

proc http2ConfigSetStreamReceiveWindowSize*(cfg: var QHttp2Configuration, size: uint32) =
  let sv = size.cuint
  {.emit: "`cfg`.setStreamReceiveWindowSize(`sv`);".}

proc http2ConfigSetServerPushEnabled*(cfg: var QHttp2Configuration, enabled: bool) =
  ## Разрешить server push (HTTP/2 push promise)
  {.emit: "`cfg`.setServerPushEnabled(`enabled`);".}

proc http2ConfigSetHuffmanCompressionEnabled*(cfg: var QHttp2Configuration, enabled: bool) =
  ## HPACK Huffman-сжатие заголовков
  {.emit: "`cfg`.setHuffmanCompressionEnabled(`enabled`);".}

proc http2ConfigSessionReceiveWindowSize*(cfg: QHttp2Configuration): uint32 =
  var v: cuint
  {.emit: "`v` = `cfg`.sessionReceiveWindowSize();".}
  result = v.uint32

proc http2ConfigStreamReceiveWindowSize*(cfg: QHttp2Configuration): uint32 =
  var v: cuint
  {.emit: "`v` = `cfg`.streamReceiveWindowSize();".}
  result = v.uint32

proc http2ConfigServerPushEnabled*(cfg: QHttp2Configuration): bool =
  var r: cint
  {.emit: "`r` = `cfg`.serverPushEnabled() ? 1 : 0;".}
  result = r == 1

proc http2ConfigHuffmanCompressionEnabled*(cfg: QHttp2Configuration): bool =
  var r: cint
  {.emit: "`r` = `cfg`.huffmanCompressionEnabled() ? 1 : 0;".}
  result = r == 1

proc namSetHttp2Configuration*(nam: NetMgr, cfg: QHttp2Configuration) =
  ## Применить конфигурацию HTTP/2 к менеджеру (Qt 6.x)
  {.emit: "`nam`->setHttp2Configuration(`cfg`);".}

proc namHttp2Configuration*(nam: NetMgr): QHttp2Configuration =
  {.emit: "`result` = `nam`->http2Configuration();".}

# ═════════════════════════════════════════════════════════════════════════════
# § 23. Высокоуровневые Nim-хелперы
# ═════════════════════════════════════════════════════════════════════════════

type
  HttpResponse* = object
    ## Структура HTTP-ответа для синхронных хелперов
    statusCode*  : int       ## HTTP-код (200, 404, …)
    body*        : string    ## Тело ответа
    contentType* : string    ## Content-Type
    error*       : string    ## Строка ошибки (пуста если успех)
    headers*     : seq[tuple[name: string, value: string]]

proc httpSyncRequest*(nam: NetMgr, req: QNetworkRequest,
                      body: string = "", verb: string = "GET",
                      timeoutMs: int = 30_000): HttpResponse =
  ## Синхронный HTTP-запрос с блокирующим event loop.
  ## Использует QEventLoop внутри — НЕ вызывать из основного UI потока!
  var reply: NetReply
  if verb == "GET":
    {.emit: "`reply` = `nam`->get(`req`);".}
  elif verb == "POST":
    let cs = body.cstring; let sz = body.len.cint
    {.emit: "`reply` = `nam`->post(`req`, QByteArray::fromRawData(`cs`, `sz`));".}
  elif verb == "PUT":
    let cs = body.cstring; let sz = body.len.cint
    {.emit: "`reply` = `nam`->put(`req`, QByteArray::fromRawData(`cs`, `sz`));".}
  elif verb == "DELETE":
    {.emit: "`reply` = `nam`->deleteResource(`req`);".}
  elif verb == "HEAD":
    {.emit: "`reply` = `nam`->head(`req`);".}
  else:
    let cv = verb.cstring; let cs = body.cstring; let sz = body.len.cint
    {.emit: """
      `reply` = `nam`->sendCustomRequest(`req`,
        QByteArray::fromRawData(`cv`, (int)strlen(`cv`)),
        QByteArray::fromRawData(`cs`, `sz`));
    """.}

  # Ждём завершения с таймаутом
  let tv = timeoutMs.cint
  var timedOut: cint = 0
  {.emit: """
    QEventLoop _loop;
    QTimer _tmo;
    _tmo.setSingleShot(true);
    QObject::connect(`reply`, &QNetworkReply::finished, &_loop, &QEventLoop::quit);
    QObject::connect(&_tmo, &QTimer::timeout, [&](){
      `timedOut` = 1;
      _loop.quit();
    });
    _tmo.start(`tv`);
    _loop.exec();
    _tmo.stop();
  """.}

  if timedOut == 1:
    reply.replyAbort()
    result.error = "Request timed out after " & $timeoutMs & " ms"
    result.statusCode = -1
    reply.replyDeleteLater()
    return

  result.statusCode  = reply.replyStatusCode()
  result.body        = reply.replyReadAll()
  result.contentType = reply.replyContentType()
  result.error       = if reply.replyError() == NoError: "" else: reply.replyErrorString()
  result.headers     = reply.replyAllHeaders()
  reply.replyDeleteLater()

proc httpGet*(url: string,
              headers: openArray[tuple[name: string, value: string]] = [],
              timeoutMs: int = 30_000): HttpResponse =
  ## Выполнить HTTP GET запрос.
  ## Создаёт временный QNetworkAccessManager — для частых запросов
  ## используйте httpSyncRequest с переиспользуемым NAM.
  let nam = newNetworkAccessManager()
  var req = newNetworkRequest(url)
  for h in headers:
    req.networkRequestSetHeader(h.name, h.value)
  result = nam.httpSyncRequest(req, "", "GET", timeoutMs)
  nam.namDelete()

proc httpPost*(url: string, body: string,
               contentType: string = "application/json",
               headers: openArray[tuple[name: string, value: string]] = [],
               timeoutMs: int = 30_000): HttpResponse =
  ## Выполнить HTTP POST запрос.
  let nam = newNetworkAccessManager()
  var req = newNetworkRequest(url)
  req.networkRequestSetContentType(contentType)
  for h in headers:
    req.networkRequestSetHeader(h.name, h.value)
  result = nam.httpSyncRequest(req, body, "POST", timeoutMs)
  nam.namDelete()

proc httpPut*(url: string, body: string,
              contentType: string = "application/json",
              timeoutMs: int = 30_000): HttpResponse =
  ## Выполнить HTTP PUT запрос.
  let nam = newNetworkAccessManager()
  var req = newNetworkRequest(url)
  req.networkRequestSetContentType(contentType)
  result = nam.httpSyncRequest(req, body, "PUT", timeoutMs)
  nam.namDelete()

proc httpDelete*(url: string, timeoutMs: int = 30_000): HttpResponse =
  ## Выполнить HTTP DELETE запрос.
  let nam = newNetworkAccessManager()
  let req = newNetworkRequest(url)
  result = nam.httpSyncRequest(req, "", "DELETE", timeoutMs)
  nam.namDelete()

proc httpPatch*(url: string, body: string,
                contentType: string = "application/json",
                timeoutMs: int = 30_000): HttpResponse =
  ## Выполнить HTTP PATCH запрос.
  let nam = newNetworkAccessManager()
  var req = newNetworkRequest(url)
  req.networkRequestSetContentType(contentType)
  result = nam.httpSyncRequest(req, body, "PATCH", timeoutMs)
  nam.namDelete()

proc httpHead*(url: string, timeoutMs: int = 30_000): HttpResponse =
  ## Выполнить HTTP HEAD запрос.
  let nam = newNetworkAccessManager()
  let req = newNetworkRequest(url)
  result = nam.httpSyncRequest(req, "", "HEAD", timeoutMs)
  nam.namDelete()

proc downloadFile*(url: string, destPath: string,
                   timeoutMs: int = 120_000,
                   progressCb: ProgressCB = nil,
                   progressUd: pointer = nil): tuple[ok: bool, error: string] =
  ## Скачать файл по URL в destPath. Возвращает (true, "") при успехе.
  ## progressCb(received, total, ud) вызывается по ходу загрузки.
  let nam = newNetworkAccessManager()
  let req = newNetworkRequest(url)
  var reply: NetReply
  {.emit: "`reply` = `nam`->get(`req`);".}

  if progressCb != nil:
    reply.replyOnDownloadProgress(progressCb, progressUd)

  # Блокируемся на event loop
  let tv = timeoutMs.cint
  var timedOut: cint = 0
  {.emit: """
    QEventLoop _dloop;
    QTimer _dtmo;
    _dtmo.setSingleShot(true);
    QObject::connect(`reply`, &QNetworkReply::finished, &_dloop, &QEventLoop::quit);
    QObject::connect(&_dtmo, &QTimer::timeout, [&](){ `timedOut` = 1; _dloop.quit(); });
    _dtmo.start(`tv`);
    _dloop.exec();
    _dtmo.stop();
  """.}

  if timedOut == 1:
    reply.replyAbort()
    reply.replyDeleteLater()
    nam.namDelete()
    return (false, "Download timed out")

  let err = reply.replyError()
  if err != NoError:
    let msg = reply.replyErrorString()
    reply.replyDeleteLater()
    nam.namDelete()
    return (false, msg)

  # Записываем данные
  let data = reply.replyReadAll()
  let dp = destPath.cstring
  let ds = data.cstring
  let dsz = data.len.cint
  var writeOk: cint
  {.emit: """
    QFile _df(QString::fromUtf8(`dp`));
    if (_df.open(QIODevice::WriteOnly)) {
      _df.write(QByteArray::fromRawData(`ds`, `dsz`));
      _df.close();
      `writeOk` = 1;
    } else {
      `writeOk` = 0;
    }
  """.}

  reply.replyDeleteLater()
  nam.namDelete()
  if writeOk == 1:
    return (true, "")
  else:
    return (false, "Failed to write file: " & destPath)

proc urlEncode*(s: string): string =
  ## URL-кодирование строки (percent-encoding)
  let cs = s.cstring
  var p: cstring
  {.emit: """
    QByteArray _ue = QUrl::toPercentEncoding(QString::fromUtf8(`cs`));
    `p` = _ue.constData();
  """.}
  result = $p

proc urlDecode*(s: string): string =
  ## URL-декодирование строки
  let cs = s.cstring
  var p: cstring
  {.emit: """
    QByteArray _ud = QUrl::fromPercentEncoding(
      QByteArray::fromRawData(`cs`, (int)strlen(`cs`))).toUtf8();
    `p` = _ud.constData();
  """.}
  result = $p

proc buildQueryString*(params: openArray[tuple[key: string, value: string]]): string =
  ## Построить query string: "key1=val1&key2=val2" (значения percent-encoded)
  result = ""
  for i, p in params:
    if i > 0: result.add('&')
    result.add(urlEncode(p.key))
    result.add('=')
    result.add(urlEncode(p.value))

proc parseQueryString*(query: string): seq[tuple[key: string, value: string]] =
  ## Разобрать query string в список пар ключ-значение
  result = @[]
  let cs = query.cstring
  var count: cint
  {.emit: """
    QUrlQuery _uq(QString::fromUtf8(`cs`));
    static QList<QPair<QString,QString>> _qitems = _uq.queryItems();
    `count` = _qitems.size();
  """.}
  for i in 0 ..< count.int:
    let idx = i.cint
    var k, v: cstring
    {.emit: """
      QByteArray _qkba = _qitems.at(`idx`).first.toUtf8();
      QByteArray _qvba = _qitems.at(`idx`).second.toUtf8();
      `k` = _qkba.constData();
      `v` = _qvba.constData();
    """.}
    result.add(($k, $v))

proc isValidUrl*(url: string): bool =
  ## Проверить корректность URL (должен быть валидным и иметь схему)
  let cs = url.cstring
  var r: cint
  {.emit: """
    QUrl _u(QString::fromUtf8(`cs`));
    `r` = (_u.isValid() && !_u.scheme().isEmpty()) ? 1 : 0;
  """.}
  result = r == 1

proc urlScheme*(url: string): string =
  ## Извлечь схему URL ("https", "ftp", …)
  let cs = url.cstring
  var p: cstring
  {.emit: "QByteArray _sch = QUrl(QString::fromUtf8(`cs`)).scheme().toUtf8(); `p` = _sch.constData();".}
  result = $p

proc urlHost*(url: string): string =
  ## Извлечь хост из URL
  let cs = url.cstring
  var p: cstring
  {.emit: "QByteArray _uh = QUrl(QString::fromUtf8(`cs`)).host().toUtf8(); `p` = _uh.constData();".}
  result = $p

proc urlPort*(url: string, defaultPort: int = -1): int =
  ## Извлечь порт из URL (defaultPort если не указан)
  let cs = url.cstring; let dv = defaultPort.cint
  var v: cint
  {.emit: "`v` = QUrl(QString::fromUtf8(`cs`)).port(`dv`);".}
  result = v.int

proc urlPath*(url: string): string =
  ## Извлечь путь из URL
  let cs = url.cstring
  var p: cstring
  {.emit: "QByteArray _up = QUrl(QString::fromUtf8(`cs`)).path().toUtf8(); `p` = _up.constData();".}
  result = $p

proc buildUrl*(scheme: string, host: string, path: string = "/",
               port: int = -1, query: string = "",
               fragment: string = ""): string =
  ## Собрать URL из компонентов
  let csc = scheme.cstring; let ch = host.cstring
  let cp = path.cstring; let pv = port.cint
  let cq = query.cstring; let cf = fragment.cstring
  var res: cstring
  {.emit: """
    QUrl _burl;
    _burl.setScheme(QString::fromUtf8(`csc`));
    _burl.setHost(QString::fromUtf8(`ch`));
    _burl.setPath(QString::fromUtf8(`cp`));
    if (`pv` >= 0) _burl.setPort(`pv`);
    if (strlen(`cq`) > 0) _burl.setQuery(QString::fromUtf8(`cq`));
    if (strlen(`cf`) > 0) _burl.setFragment(QString::fromUtf8(`cf`));
    QByteArray _buba = _burl.toString().toUtf8();
    `res` = _buba.constData();
  """.}
  result = $res

# ── Конец nimQtNetwork.nim ────────────────────────────────────────────────────
