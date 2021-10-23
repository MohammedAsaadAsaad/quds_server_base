import 'dart:io';
import '../imports.dart';

String appName = 'eDebt Server';
bool isDebugMode = true;

///Should generate  a unique secret key and put it here
/// Use this website
/// https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx
String secretKey = r'few642werwer5we2r4423223';
String serverHost = InternetAddress.loopbackIPv4.host;
// String serverHost = InternetAddress.anyIPv4.host;
int get serverPort => int.parse(Platform.environment['PORT'] ?? '8080');

TokenServiceConfigurations tokenServiceConfigurations =
    TokenServiceConfigurations(
        secretKey: secretKey, prefix: 'token', host: 'localhost', port: 6379);

var securityContext = SecurityContext()..setTrustedCertificates('file');

ServerConfigurations serverConfigurations = ServerConfigurations(
    secretKey: secretKey,
    host: serverHost,
    port: serverPort,
    enableAuthorization: true,
    enableLogging: true,
    enableRequestsLogging: false,
    tokenServiceConfigurations: tokenServiceConfigurations,
    isDebugMode: isDebugMode);

// mysql server configurations (main database)
String? mySqlDb = 'edebt';
String? mySqlUser = 'root';
String? mySqlPassword;
int? mySqlPort = 3306;
