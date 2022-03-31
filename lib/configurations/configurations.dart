import '../imports.dart';

String appName = 'Quds Server [Beta]';
bool isDebugMode = true;

///Should generate  a unique secret key and put it here
/// Use this website
/// https://www.allkeysgenerator.com/Random/Security-Encryption-Key-Generator.aspx
String secretKey = r'3s6v9y$B&E)H@McQfTjWmZq4t7w!z%C*';
String serverHost = InternetAddress.anyIPv4.host;
int get serverPort => int.parse(Platform.environment['PORT'] ?? '6666');

// TokenServiceConfigurations tokenServiceConfigurations =
//     TokenServiceConfigurations(
//         secretKey: secretKey, prefix: 'token', host: 'localhost', port: 6379);

ServerConfigurations serverConfigurations = ServerConfigurations(
    secretKey: secretKey,
    host: serverHost,
    port: serverPort,
    enableAuthorization: false,
    enableLogging: true,
    enableRequestsLogging: true,
    // tokenServiceConfigurations: tokenServiceConfigurations,
    isDebugMode: isDebugMode);

String? mySqlDb = 'derribni';
String? mySqlUser = 'root';
String? mySqlPassword = '0';
int? mySqlPort = 2020;

// Users db
// String? usersDb = 'derribni_users';
// ConnectionSettings usersDbConnection = ConnectionSettings(
//     port: 2020, host: 'localhost', user: 'root', password: '0');
