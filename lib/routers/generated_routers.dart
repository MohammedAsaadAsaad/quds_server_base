import 'package:quds_server_base/routers/api/v1/clients/clients_router.dart';

import '../imports.dart';
import 'api/v1/routers.dart';
import 'web/home.dart';

List<QudsRouter> get generateRouters =>
    [HomeRouter(), UsersRouter(), ClientsRouter()];
