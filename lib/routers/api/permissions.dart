import '../../../../imports.dart';

class PermissionsRouter extends QudsRouter<PermissionsController> {
  PermissionsRouter() : super(controller: PermissionsController());

  @override
  String get prefix => 'permissions';

  @override
  List<QudsRouterHandler> get routes => [
        QudsRouterHandler(
            routePath: 'my_system_permissions',
            method: RouteMethod.post,
            handler: controller!.getMySystemPermissions),
        QudsRouterHandler(
            routePath: 'my_location_permissions',
            method: RouteMethod.post,
            handler: controller!.getMyLocationPermissions),
      ];
}
