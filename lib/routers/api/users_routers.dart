import '../../../../imports.dart';

class UsersRouter extends QudsRouter<UsersController> {
  UsersRouter() : super(controller: UsersController());

  @override
  String get prefix => 'users';

  @override
  List<QudsRouterHandler> get routes => [
        QudsRouterHandler(
            routePath: 'register',
            method: RouteMethod.post,
            handler: controller!.register),
        QudsRouterHandler(
            routePath: 'login',
            method: RouteMethod.post,
            handler: controller!.login),
        QudsRouterHandler(
            routePath: 'logout',
            method: RouteMethod.post,
            handler: controller!.logout),
        QudsRouterHandler(
            routePath: 'refresh_token',
            method: RouteMethod.post,
            handler: controller!.refreshToken),
        QudsRouterHandler(
            routePath: 'my_details',
            method: RouteMethod.post,
            handler: controller!.getMyDetails),
        QudsRouterHandler(
            routePath: 'user/<id>',
            method: RouteMethod.post,
            handler: controller!.getUserDetails),
        QudsRouterHandler(
            routePath: 'change_my_password',
            method: RouteMethod.post,
            handler: controller!.changeMyPassword),
        QudsRouterHandler(
            routePath: 'change_my_details',
            method: RouteMethod.post,
            handler: controller!.changeMyDetails)
      ];
}
