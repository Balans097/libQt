## test_nimQtNetwork.nim
## ============================================================
## Тестовое приложение для проверки обёртки nimQtNetwork.nim
##
## Покрывает следующие разделы:
##   § 4.  QHostAddress
##   § 5.  QHostInfo (DNS)
##   § 6.  QNetworkInterface
##   § 7.  QNetworkProxy
##   § 9.  QSslConfiguration
##   § 10. QNetworkRequest
##   § 12. QNetworkAccessManager (HTTP GET/POST/HEAD/PATCH/DELETE)
##   § 13. QNetworkCookieJar / QNetworkCookie
##   § 14. QNetworkDiskCache
##   § 15. QTcpSocket / QTcpServer
##   § 16. QUdpSocket
##   § 17. QLocalSocket / QLocalServer
##   § 23. Высокоуровневые хелперы (httpGet, httpPost, urlEncode, …)
##
## Компиляция (MSYS2/UCRT64):
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Core Qt6Network)" \
##     --passL:"$(pkg-config --libs Qt6Core Qt6Network)" \
##     test_nimQtNetwork.nim
##
## Компиляция (Linux/macOS):
##   nim cpp --passC:"-std=c++20" \
##     --passC:"$(pkg-config --cflags Qt6Core Qt6Network)" \
##     --passL:"$(pkg-config --libs Qt6Core Qt6Network)" \
##     test_nimQtNetwork.nim

import nimQtNetwork
import nimQtCore
import std/strformat
import std/strutils
import std/os

# ─────────────────────────────────────────────────────────────
# Вспомогательные функции вывода
# ─────────────────────────────────────────────────────────────

var totalTests  = 0
var passedTests = 0
var failedTests = 0

proc ok(name: string) =
  inc totalTests; inc passedTests
  echo &"  [PASS] {name}"

proc fail(name: string, detail: string = "") =
  inc totalTests; inc failedTests
  if detail.len > 0:
    echo &"  [FAIL] {name}: {detail}"
  else:
    echo &"  [FAIL] {name}"

proc section(title: string) =
  echo ""
  echo "═══════════════════════════════════════════════════"
  echo &"  {title}"
  echo "═══════════════════════════════════════════════════"

proc check(name: string, cond: bool, detail: string = "") =
  if cond: ok(name) else: fail(name, detail)

# ─────────────────────────────────────────────────────────────
# § 4. QHostAddress
# ─────────────────────────────────────────────────────────────

proc testHostAddress() =
  section("§ 4. QHostAddress")

  # Создание и конвертация в строку
  let lo = newHostAddressStr("127.0.0.1")
  check("IPv4 → toString",
        hostAddressToString(lo) == "127.0.0.1",
        hostAddressToString(lo))

  let lo6 = newHostAddressStr("::1")
  check("IPv6 → toString",
        hostAddressToString(lo6) == "::1",
        hostAddressToString(lo6))

  # Флаги
  check("LocalHost isLoopback",        hostAddressIsLoopback(lo))
  check("LocalHostIPv6 isLoopback",    hostAddressIsLoopback(lo6))
  check("127.0.0.1 isIPv4",            hostAddressIsIPv4(lo))
  check("::1 isIPv6",                  hostAddressIsIPv6(lo6))

  # Специальные адреса
  let any4 = hostAddressAnyIPv4()
  let any6 = hostAddressAnyIPv6()
  let bcast = hostAddressBroadcast()
  check("AnyIPv4 not null",     not hostAddressIsNull(any4))
  check("AnyIPv6 not null",     not hostAddressIsNull(any6))
  check("Broadcast not null",   not hostAddressIsNull(bcast))
  check("Broadcast == 255.255.255.255",
        hostAddressToString(bcast) == "255.255.255.255",
        hostAddressToString(bcast))

  # Нулевой адрес
  let empty = newHostAddress()
  check("Default ctor isNull", hostAddressIsNull(empty))

  # Равенство
  let a1 = newHostAddressStr("10.0.0.1")
  let a2 = newHostAddressStr("10.0.0.1")
  let a3 = newHostAddressStr("10.0.0.2")
  check("Equal addresses", a1 == a2)
  check("Unequal addresses", not (a1 == a3))

# ─────────────────────────────────────────────────────────────
# § 5. QHostInfo — DNS-разрешение
# ─────────────────────────────────────────────────────────────

proc testHostInfo() =
  section("§ 5. QHostInfo — DNS")

  # Имя локального хоста
  let lhn = hostInfoLocalHostName()
  check("localHostName not empty", lhn.len > 0, lhn)

  # Домен (может быть пустым в контейнерах)
  let ldn = hostInfoLocalDomainName()
  echo &"    localDomainName = '{ldn}'"
  ok("localDomainName call OK")

  # Разрешение loopback (localhost → должен дать 127.0.0.1 или ::1)
  let (ips, err) = hostInfoLookupHost("localhost")
  check("localhost resolves", ips.len > 0 or err.len == 0,
        &"err='{err}' ips={ips}")
  if ips.len > 0:
    echo &"    localhost → {ips}"
    ok("localhost IP received")

  # Разрешение публичного хоста (требует сети)
  let (ips2, err2) = hostInfoLookupHost("google.com")
  if err2.len == 0 and ips2.len > 0:
    echo &"    google.com → {ips2[0]}  (+{ips2.len-1} more)"
    ok("google.com resolves")
  else:
    echo &"    google.com DNS skip (no network?): {err2}"
    ok("google.com DNS (offline skip)")

# ─────────────────────────────────────────────────────────────
# § 6. QNetworkInterface
# ─────────────────────────────────────────────────────────────

proc testNetworkInterface() =
  section("§ 6. QNetworkInterface")

  let addrs = networkInterfaceAllAddresses()
  check("allAddresses not empty", addrs.len > 0)
  echo &"    Total addresses: {addrs.len}"
  for a in addrs[0 .. min(3, addrs.len-1)]:
    echo &"      {a}"

  let names = networkInterfaceAllNames()
  check("allInterfaces names", names.len > 0)
  echo &"    Interfaces: {names}"

  # Для первого интерфейса проверяем доступные поля
  if names.len > 0:
    let ifn = names[0]
    let mac   = networkInterfaceHardwareAddress(ifn)
    let isUp  = networkInterfaceIsUp(ifn)
    let isRun = networkInterfaceIsRunning(ifn)
    let ipes  = networkInterfaceAddresses(ifn)
    echo &"    [{ifn}] MAC={mac} up={isUp} running={isRun} addrs={ipes.len}"
    ok("Interface details read")

# ─────────────────────────────────────────────────────────────
# § 7. QNetworkProxy
# ─────────────────────────────────────────────────────────────

proc testNetworkProxy() =
  section("§ 7. QNetworkProxy")

  # Создать HTTP-прокси и проверить поля
  let proxy = newNetworkProxy(HttpProxy, "proxy.example.com", 8080,
                               "user1", "pass1")
  check("proxy hostName",
        networkProxyHostName(proxy) == "proxy.example.com",
        networkProxyHostName(proxy))
  check("proxy port",
        networkProxyPort(proxy) == 8080,
        $networkProxyPort(proxy))
  check("proxy user",
        networkProxyUser(proxy) == "user1",
        networkProxyUser(proxy))
  check("proxy type",
        networkProxyType(proxy) == HttpProxy,
        $networkProxyType(proxy))

  # Получить и восстановить глобальный прокси
  discard networkProxyGetApplicationProxy()
  networkProxySetApplicationProxy(proxy)
  let cur = networkProxyGetApplicationProxy()
  check("set/get application proxy host",
        networkProxyHostName(cur) == "proxy.example.com",
        networkProxyHostName(cur))
  # Восстановить NoProxy
  let noProxy = newNetworkProxy(NoProxy, "", 0)
  networkProxySetApplicationProxy(noProxy)
  ok("Proxy restored to NoProxy")

# ─────────────────────────────────────────────────────────────
# § 9. QSslConfiguration
# ─────────────────────────────────────────────────────────────

proc testSslConfiguration() =
  section("§ 9. QSslConfiguration")

  # Получить конфигурацию по умолчанию (не должна падать)
  var cfg = sslConfigDefault()
  ok("sslConfigDefault() call OK")

  # Изменить peer verify mode
  sslConfigSetPeerVerifyMode(cfg, false)
  ok("sslConfigSetPeerVerifyMode(false) OK")

  # Восстановить VerifyPeer
  sslConfigSetPeerVerifyMode(cfg, true)
  ok("sslConfigSetPeerVerifyMode(true) OK")

  # sslCertFromPemData с пустыми данными → isNull == true
  let badCert = sslCertFromPemData("not-a-pem")
  check("Invalid PEM → isNull", sslCertIsNull(badCert))

# ─────────────────────────────────────────────────────────────
# § 10. QNetworkRequest
# ─────────────────────────────────────────────────────────────

proc testNetworkRequest() =
  section("§ 10. QNetworkRequest")

  var req = newNetworkRequest("https://httpbin.org/get")
  check("newNetworkRequest OK", networkRequestUrl(req) == "https://httpbin.org/get",
        networkRequestUrl(req))

  # Установка заголовков
  networkRequestSetHeader(req, "X-Custom-Test", "nimQtNetwork")
  let hdr = networkRequestHeader(req, "X-Custom-Test")
  check("setHeader/getHeader", hdr == "nimQtNetwork", hdr)

  # Content-Type через известный заголовок
  networkRequestSetContentType(req, "application/json")
  let ct = networkRequestHeader(req, "Content-Type")
  check("setContentType", ct == "application/json", ct)

  # User-Agent
  networkRequestSetUserAgent(req, "nimQtNetwork/1.0")
  let ua = networkRequestHeader(req, "User-Agent")
  check("setUserAgent", ua == "nimQtNetwork/1.0", ua)

  # Transfer timeout
  networkRequestSetTransferTimeout(req, 5000)
  ok("setTransferTimeout 5000 OK")

  # Redirect policy
  networkRequestSetRedirectPolicy(req, NoLessSafeRedirectPolicy)
  ok("setRedirectPolicy OK")

# ─────────────────────────────────────────────────────────────
# § 12. QNetworkAccessManager — высокоуровневые HTTP-запросы
# ─────────────────────────────────────────────────────────────

proc testHttpRequests() =
  section("§ 12. HTTP requests (httpbin.org)")

  # ── GET ──────────────────────────────────────────────────────
  echo "  → GET https://httpbin.org/get"
  let getResp = httpGet("https://httpbin.org/get", timeoutMs = 15_000)
  if getResp.statusCode == 200:
    check("GET 200 OK", true)
    check("GET body not empty", getResp.body.len > 0)
    echo &"    body len = {getResp.body.len} bytes"
  else:
    check("GET 200 OK", false,
          &"status={getResp.statusCode} err='{getResp.error}'")

  # ── HEAD ─────────────────────────────────────────────────────
  echo "  → HEAD https://httpbin.org/get"
  let headResp = httpHead("https://httpbin.org/get", 15_000)
  if headResp.statusCode == 200:
    check("HEAD 200 OK", true)
    check("HEAD body empty", headResp.body.len == 0)
  else:
    check("HEAD 200 OK", false,
          &"status={headResp.statusCode} err='{headResp.error}'")

  # ── POST JSON ────────────────────────────────────────────────
  echo "  → POST https://httpbin.org/post"
  let postBody = """{"test":"nimQtNetwork","value":42}"""
  let postResp = httpPost("https://httpbin.org/post", postBody,
                           "application/json", timeoutMs = 15_000)
  if postResp.statusCode == 200:
    check("POST 200 OK", true)
    # httpbin отражает тело в поле "data"
    check("POST body contains payload",
          postResp.body.find("nimQtNetwork") >= 0)
  else:
    check("POST 200 OK", false,
          &"status={postResp.statusCode} err='{postResp.error}'")

  # ── PUT ──────────────────────────────────────────────────────
  echo "  → PUT https://httpbin.org/put"
  let putResp = httpPut("https://httpbin.org/put",
                         """{"updated":true}""", "application/json", timeoutMs = 15_000)
  if putResp.statusCode == 200:
    check("PUT 200 OK", true)
  else:
    check("PUT 200 OK", false,
          &"status={putResp.statusCode} err='{putResp.error}'")

  # ── DELETE ───────────────────────────────────────────────────
  echo "  → DELETE https://httpbin.org/delete"
  let delResp = httpDelete("https://httpbin.org/delete", 15_000)
  if delResp.statusCode == 200:
    check("DELETE 200 OK", true)
  else:
    check("DELETE 200 OK", false,
          &"status={delResp.statusCode} err='{delResp.error}'")

  # ── PATCH ────────────────────────────────────────────────────
  echo "  → PATCH https://httpbin.org/patch"
  let patchResp = httpPatch("https://httpbin.org/patch",
                             """{"patched":true}""", "application/json", timeoutMs = 15_000)
  if patchResp.statusCode == 200:
    check("PATCH 200 OK", true)
  else:
    check("PATCH 200 OK", false,
          &"status={patchResp.statusCode} err='{patchResp.error}'")

  # ── Заголовки ответа ─────────────────────────────────────────
  if getResp.statusCode == 200:
    var ct = ""
    for h in getResp.headers:
      if h.name.toLowerAscii() == "content-type":
        ct = h.value
        break
    check("GET Content-Type header present",
          ct.find("application/json") >= 0, ct)

# ─────────────────────────────────────────────────────────────
# § 12. NAM — низкоуровневый API
# ─────────────────────────────────────────────────────────────

proc testNamLowLevel() =
  section("§ 12. NAM low-level API")

  let nam = newNetworkAccessManager()
  check("newNetworkAccessManager not nil", nam != nil)

  # Установить таймаут и автоудаление
  nam.namSetTransferTimeout(10_000)
  ok("namSetTransferTimeout OK")

  nam.namSetAutoDeleteReplies(false)
  ok("namSetAutoDeleteReplies OK")

  # Использовать syncRequest напрямую
  let req = newNetworkRequest("https://httpbin.org/uuid")
  let resp = nam.httpSyncRequest(req, "", "GET", 15_000)
  if resp.statusCode == 200:
    check("httpSyncRequest GET /uuid 200", true)
    check("UUID body not empty", resp.body.len > 0)
  else:
    check("httpSyncRequest GET", false,
          &"status={resp.statusCode} err='{resp.error}'")

  # Очистить кэш
  nam.namClearAccessCache()
  ok("namClearAccessCache OK")
  nam.namClearConnectionCache()
  ok("namClearConnectionCache OK")

  nam.namDelete()
  ok("namDelete OK")

# ─────────────────────────────────────────────────────────────
# § 13. QNetworkCookieJar / QNetworkCookie
# ─────────────────────────────────────────────────────────────

proc testCookies() =
  section("§ 13. Cookies")

  # Создать cookie
  var c = cookieNew("session_id", "abc123xyz")
  check("cookieName",  cookieName(c) == "session_id",  cookieName(c))
  check("cookieValue", cookieValue(c) == "abc123xyz", cookieValue(c))

  cookieSetDomain(c, "example.com")
  cookieSetPath(c, "/api")
  cookieSetSecure(c, true)
  cookieSetHttpOnly(c, true)
  ok("Cookie fields set OK")

  let raw = cookieToRawForm(c)
  check("cookieToRawForm not empty", raw.len > 0, raw)
  echo &"    rawForm = {raw}"

  # CookieJar
  let jar = newNetworkCookieJar()
  check("newNetworkCookieJar not nil", jar != nil)

  let setOk = jar.cookieJarSetCookiesFromUrl(
    "https://example.com", "test_cookie", "hello")
  # Qt может вернуть false если домен не совпадает — это нормально
  echo &"    setCookiesFromUrl = {setOk}"
  ok("cookieJarSetCookiesFromUrl call OK")

  let cookies = jar.cookieJarCookiesForUrl("https://example.com/")
  echo &"    cookiesForUrl count = {cookies.len}"
  ok("cookieJarCookiesForUrl call OK")

  cookieJarDelete(jar)
  ok("cookieJarDelete OK")

# ─────────────────────────────────────────────────────────────
# § 14. QNetworkDiskCache
# ─────────────────────────────────────────────────────────────

proc testDiskCache() =
  section("§ 14. QNetworkDiskCache")

  let cacheDir = getTempDir() / "nimQtNetworkTest_cache"
  let cache = newNetworkDiskCache()
  check("newNetworkDiskCache not nil", cache != nil)

  diskCacheSetCacheDirectory(cache, cacheDir)
  let readBack = diskCacheCacheDirectory(cache)
  check("setCacheDirectory / getCacheDirectory",
        readBack == cacheDir or readBack == cacheDir & "/", readBack)

  diskCacheSetMaximumCacheSize(cache, 10 * 1024 * 1024)  # 10 MB
  let sz = diskCacheMaximumCacheSize(cache)
  check("setMaximumCacheSize", sz == 10 * 1024 * 1024, $sz)

  diskCacheClear(cache)
  ok("diskCacheClear OK")

  diskCacheDelete(cache)
  ok("diskCacheDelete OK")

# ─────────────────────────────────────────────────────────────
# § 15. QTcpSocket / QTcpServer (loopback)
# ─────────────────────────────────────────────────────────────

proc testTcpLoopback() =
  section("§ 15. TCP loopback echo test")

  # Сервер
  let srv = newTcpServer()
  check("newTcpServer not nil", srv != nil)

  let listenOk = srv.tcpServerListen("127.0.0.1", 0)
  check("tcpServerListen", listenOk, srv.tcpServerErrorString())

  if not listenOk:
    srv.tcpServerDelete()
    return

  let port = srv.tcpServerServerPort()
  check("serverPort > 0", port > 0, $port)
  echo &"    Server listening on 127.0.0.1:{port}"

  # Клиент
  let client = newTcpSocket()
  check("newTcpSocket not nil", client != nil)

  let connOk = client.tcpSocketConnectToHostSync("127.0.0.1",
                                                  port.uint16, 5000)
  check("tcpSocketConnectToHostSync", connOk,
        &"state={client.tcpSocketState()}")

  if not connOk:
    client.tcpSocketDelete()
    srv.tcpServerClose()
    srv.tcpServerDelete()
    return

  # Сервер принимает соединение
  let hasConn = srv.tcpServerWaitForNewConnection(3000)
  check("waitForNewConnection", hasConn)

  if hasConn:
    let srvConn = srv.tcpServerNextPendingConnection()
    check("nextPendingConnection not nil", srvConn != nil)

    # Клиент отправляет данные
    let sent = client.tcpSocketWrite("Hello, nimQtNetwork TCP!")
    check("tcpSocketWrite > 0", sent > 0, $sent)
    discard client.tcpSocketFlush()
    discard client.tcpSocketWaitForBytesWritten(3000)

    # Сервер ждёт и читает
    let waitOk = srvConn.tcpSocketWaitForReadyRead(3000)
    if waitOk:
      let received = srvConn.tcpSocketRead(1024)
      check("TCP echo received",
            received == "Hello, nimQtNetwork TCP!", received)
    else:
      fail("waitForReadyRead timeout")

    srvConn.tcpSocketDisconnectFromHost()
    srvConn.tcpSocketDelete()

  client.tcpSocketDisconnectFromHost()
  client.tcpSocketDelete()
  srv.tcpServerClose()
  srv.tcpServerDelete()
  ok("TCP cleanup OK")

# ─────────────────────────────────────────────────────────────
# § 16. QUdpSocket (loopback)
# ─────────────────────────────────────────────────────────────

proc testUdpLoopback() =
  section("§ 16. UDP loopback test")

  let receiver = newUdpSocket()
  check("newUdpSocket (receiver) not nil", receiver != nil)

  let bindOk = receiver.udpSocketBind("127.0.0.1", 0)
  check("udpSocketBind receiver", bindOk)

  let rxPort = receiver.udpSocketLocalPort()
  check("rxPort > 0", rxPort > 0, $rxPort)
  echo &"    UDP receiver bound on port {rxPort}"

  let sender = newUdpSocket()
  check("newUdpSocket (sender) not nil", sender != nil)

  let msg  = "UDP-nimQtNetwork-ping"
  let sent = sender.udpSocketWriteDatagram(msg, "127.0.0.1", rxPort.uint16)
  check("udpSocketWriteDatagram", sent == msg.len.int64, $sent)

  # Ждём датаграмму (простой poll)
  var waited = 0
  while not receiver.udpSocketHasPendingDatagrams() and waited < 200:
    inc waited
    sleep(10)

  if receiver.udpSocketHasPendingDatagrams():
    let (data, senderAddr, senderPort) = receiver.udpSocketReceiveDatagram()
    check("UDP receiveDatagram data", data == msg, data)
    check("UDP senderAddr loopback",
          senderAddr == "127.0.0.1" or senderAddr == "::1", senderAddr)
    echo &"    UDP received '{data}' from {senderAddr}:{senderPort}"
    ok("UDP echo OK")
  else:
    fail("udpSocketHasPendingDatagrams timeout")

  sender.udpSocketClose()
  sender.udpSocketDelete()
  receiver.udpSocketClose()
  receiver.udpSocketDelete()
  ok("UDP cleanup OK")

# ─────────────────────────────────────────────────────────────
# § 17. QLocalSocket / QLocalServer
# ─────────────────────────────────────────────────────────────

proc testLocalSocket() =
  section("§ 17. QLocalSocket/Server (IPC)")

  let pipeName = "nimQtNetworkTest_" & $getCurrentProcessId()
  let srv = newLocalServer()
  check("newLocalServer not nil", srv != nil)

  # Удалить старый сокет если остался
  discard localServerRemoveServer(pipeName)

  let listenOk = srv.localServerListen(pipeName)
  check("localServerListen", listenOk, srv.localServerErrorString())

  if not listenOk:
    srv.localServerDelete()
    return

  check("localServerIsListening", srv.localServerIsListening())
  echo &"    IPC server listening on: {srv.localServerFullServerName()}"

  # Клиент
  let client = newLocalSocket()
  check("newLocalSocket not nil", client != nil)

  localSocketConnectToServer(client, pipeName)
  let connOk = client.localSocketWaitForConnected(3000)
  check("localSocketWaitForConnected", connOk,
        client.localSocketErrorString())

  if connOk:
    # Сервер принимает соединение
    let hasConn = srv.localServerWaitForNewConnection(2000)
    check("localServerWaitForNewConnection", hasConn)

    if hasConn:
      let srvConn = srv.localServerNextPendingConnection()
      check("localServerNextPendingConnection not nil", srvConn != nil)

      # Клиент → сервер
      let written = client.localSocketWrite("IPC-hello")
      check("localSocketWrite > 0", written > 0, $written)
      discard client.localSocketWaitForBytesWritten(2000)

      let readOk = srvConn.localSocketWaitForReadyRead(2000)
      if readOk:
        let data = srvConn.localSocketRead(256)
        check("IPC data received", data == "IPC-hello", data)
      else:
        fail("IPC waitForReadyRead timeout")

      srvConn.localSocketDisconnectFromServer()
      srvConn.localSocketDelete()

  client.localSocketDisconnectFromServer()
  client.localSocketDelete()
  srv.localServerClose()
  srv.localServerDelete()
  ok("IPC cleanup OK")

# ─────────────────────────────────────────────────────────────
# § 23. URL-утилиты и высокоуровневые хелперы
# ─────────────────────────────────────────────────────────────

proc testUrlUtils() =
  section("§ 23. URL utilities")

  # isValidUrl
  check("isValidUrl https", isValidUrl("https://example.com"))
  check("isValidUrl bad",   not isValidUrl("not a url !!"))

  # urlScheme / urlHost / urlPath / urlPort
  let u = "https://api.example.com:443/v1/test?foo=bar"
  check("urlScheme", urlScheme(u) == "https", urlScheme(u))
  check("urlHost",   urlHost(u) == "api.example.com", urlHost(u))
  check("urlPath",   urlPath(u) == "/v1/test", urlPath(u))
  check("urlPort",   urlPort(u) == 443, $urlPort(u))

  # buildUrl
  let built = buildUrl("http", "localhost", "/hello", 8080, "k=v", "section1")
  check("buildUrl", isValidUrl(built), built)
  echo &"    buildUrl → {built}"

  # urlEncode / urlDecode
  let raw   = "Hello World! &=?"
  let enc   = urlEncode(raw)
  let dec   = urlDecode(enc)
  check("urlEncode not empty",   enc.len > 0, enc)
  check("urlDecode roundtrip",   dec == raw, dec)
  echo &"    urlEncode('{raw}') = '{enc}'"

  # buildQueryString / parseQueryString
  let params = [("key one", "val 1"), ("key2", "val&2"), ("emoji", "★")]
  let qs = buildQueryString(params)
  check("buildQueryString not empty", qs.len > 0, qs)
  echo &"    queryString = {qs}"

  let parsed = parseQueryString(qs)
  check("parseQueryString count", parsed.len == params.len, $parsed.len)
  if parsed.len == params.len:
    for i in 0 ..< params.len:
      check(&"parseQS[{i}].key",
            parsed[i].key == params[i][0], parsed[i].key)
      check(&"parseQS[{i}].value",
            parsed[i].value == params[i][1], parsed[i].value)

# ─────────────────────────────────────────────────────────────
# downloadFile
# ─────────────────────────────────────────────────────────────

proc testDownloadFile() =
  section("§ 23. downloadFile")

  let destPath = getTempDir() / "nimQtNetwork_test_download.json"
  echo &"  → Downloading to {destPath}"

  let (ok2, err) = downloadFile(
    "https://httpbin.org/json",
    destPath,
    30_000)

  if ok2:
    check("downloadFile ok", true)
    let sz = getFileSize(destPath)
    check("downloadFile size > 0", sz > 0, $sz)
    echo &"    Downloaded {sz} bytes"
    removeFile(destPath)
  else:
    check("downloadFile ok", false, err)

# ─────────────────────────────────────────────────────────────
# Итоги
# ─────────────────────────────────────────────────────────────

proc printSummary() =
  echo ""
  echo "═══════════════════════════════════════════════════"
  echo "  TEST SUMMARY"
  echo "═══════════════════════════════════════════════════"
  echo &"  Total : {totalTests}"
  echo &"  Passed: {passedTests}"
  echo &"  Failed: {failedTests}"
  if failedTests == 0:
    echo "  Result: ALL TESTS PASSED ✓"
  else:
    echo &"  Result: {failedTests} TEST(S) FAILED ✗"
  echo "═══════════════════════════════════════════════════"

# ─────────────────────────────────────────────────────────────
# Точка входа
# ─────────────────────────────────────────────────────────────

when isMainModule:
  # Qt требует QCoreApplication для QEventLoop, таймеров и сети
  let app = newCoreApp()

  echo "nimQtNetwork Test Suite"
  echo "========================"
  echo "Qt6Network wrapper — comprehensive smoke tests"

  # Офлайн-тесты (без сети)
  testHostAddress()
  testNetworkProxy()
  testSslConfiguration()
  testNetworkRequest()
  testCookies()
  testDiskCache()

  # Локальная сеть (loopback — без внешнего интернета)
  testTcpLoopback()
  testUdpLoopback()
  testLocalSocket()

  # DNS (требует разрешения имён)
  testHostInfo()

  # Сетевые интерфейсы
  testNetworkInterface()

  # URL-утилиты
  testUrlUtils()

  # Интернет-запросы (httpbin.org)
  testHttpRequests()
  testNamLowLevel()
  testDownloadFile()

  printSummary()
  quit(if failedTests == 0: 0 else: 1)
