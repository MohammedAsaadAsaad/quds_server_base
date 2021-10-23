import '../../imports.dart';

class PermissionsController extends QudsController {
  Future<Response> getMySystemPermissions(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden(
          message: 'You are not authorized to perform this action');
    }

    var perms =
        await SystemPermissionsRepository().getUserPermissions(user.id.value!);

    return responseApiOk(data: {
      'permissions': [for (var p in perms) p.asJsonMap]
    });
  }

  Future<Response> getMyLocationPermissions(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden(
          message: 'You are not authorized to perform this action');
    }

    var perms = await LocationPermissionsRepository()
        .getUserPermissions(user.id.value!);

    return responseApiOk(data: {
      'permissions': [for (var p in perms) p.asJsonMap]
    });
  }
}
