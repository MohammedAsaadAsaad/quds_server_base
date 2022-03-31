import '../imports.dart';
import 'api/v1/routers.dart';
import 'web/home.dart';

List<QudsRouter> get generateRouters => [HomeRouter(), UsersRouter()];
