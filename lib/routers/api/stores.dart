import '../../../../imports.dart';

class StoresRouter extends QudsRouter<StoresController> {
  StoresRouter() : super(controller: StoresController());

  @override
  String get prefix => 'stores';

  @override
  List<QudsRouterHandler> get routes => [
        QudsRouterHandler(
            routePath: 'createStore',
            method: RouteMethod.post,
            handler: controller!.createStore),
        QudsRouterHandler(
            routePath: 'updateStore',
            method: RouteMethod.post,
            handler: controller!.updateStore),
      ];
}
