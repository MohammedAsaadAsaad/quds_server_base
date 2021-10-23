import '../imports.dart';

List<QudsRouter> get generateRouters => [
      HomeRouter(),
      UsersRouter(),
      StoresRouter(),
      LocationsRouter(),
      PermissionsRouter()
    ];
