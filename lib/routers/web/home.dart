import '../../imports.dart';

class HomeRouter extends QudsRouter<WebController> {
  HomeRouter() : super(controller: WebController());

  @override
  String get prefix => '/';

  @override
  List<QudsRouterHandler> get routes => [
        QudsRouterHandler(
            routePath: '', method: RouteMethod.get, handler: controller!.home)
      ];
}
