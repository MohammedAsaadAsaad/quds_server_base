import 'imports.dart';

Future<void> serve() async {
  server = QudsServer(
      appName: appName,
      configurations: serverConfigurations,
      routers: generateRouters,
      middlewares: [UserHunterMiddleware(), ErrorsLoggerMiddleware()]);

  // if (server.configurations.enableAuthorization == true) {
  DbHelper.mainDb = mySqlDb!;
  DbHelper.port = mySqlPort!;
  DbHelper.dbUser = mySqlUser!;
  DbHelper.dbPassword = mySqlPassword;
  // }

  await initializeApp();

  server.start();
  // withHotreload(() => server.start());
}

late QudsServer server;
