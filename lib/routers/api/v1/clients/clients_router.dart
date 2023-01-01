import 'package:quds_server_base/imports.dart';

class ClientsRouter extends QudsRouter<ClientsController> {
  ClientsRouter() : super(controller: ClientsController());

  @override
  String get prefix => 'clients';

  @override
  List<QudsRouterHandler> get routes => [
        QudsRouterHandler(
            method: RouteMethod.post,
            routePath: 'host_address',
            handler: controller!.getClientHost),
        QudsRouterHandler(
            method: RouteMethod.post,
            routePath: 'subscription',
            handler: controller!.getClientSubscription)
      ];
}
