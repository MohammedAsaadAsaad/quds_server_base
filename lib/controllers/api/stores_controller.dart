import 'package:edebt_server/imports.dart';

class StoresController extends QudsController {
  Future<Response> createStore(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'name': Required().isString().min(3).max(32),
      'description': Required().isString().min(3).max(256),
      'district-id': Required().isInteger().min(1),
      'scopes': Max(3)
    });

    var user = await req.currentUserBase;
    if (user == null ||
        user.userType.value!.correspondingUserType == UserType.admin) {
      return responseApiForbidden();
    }
    if (validationResponse != null) return validationResponse;

    var repo = StoresRepository();
    var item = await repo.createStore(
        creatorTextId: (await user.details).textId.value!,
        name: body['name'],
        description: body['description'],
        districtTextId: body['district-id'],
        scopes: body['scopes']);

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateStore(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'name': IsString().min(3).max(32),
      'description': IsString().min(3).max(256),
      'district-id': IsString(),
      'scopes': Max(3)
    });

    var user = await req.currentUserBase;
    if (user == null ||
        user.userType.value!.correspondingUserType == UserType.admin) {
      return responseApiForbidden();
    }
    if (validationResponse != null) return validationResponse;

    var repo = StoresRepository();
    var item = await repo.updateStore(
        storeId: body['id'],
        name: body['name'],
        description: body['description'],
        districtTextId: body['district-id'],
        scopes: body['scopes']);

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }
}
