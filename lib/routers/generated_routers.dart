import 'web/home.dart';

import '../imports.dart';
import 'api/v1/routers.dart';

List<QudsRouter> get generateRouters => [HomeRouter(), UsersRouter()];
