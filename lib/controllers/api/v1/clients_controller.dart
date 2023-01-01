import 'package:quds_server_base/imports.dart';

class ClientsController extends QudsController {
  Future<Response> getClientSubscription(Request request) async {
    var body = await request.bodyAsJson;
    var vr = body.validate(
        {'code': Required().isString(), 'password': Required().isString()});
    if (vr != null) return vr;

    //TODO: get the client details
    var client = await ClientsRepository.instance
        .getClientByCodeAndPassword(body['code'], body['password']);

//TODO: get the latest subscription
    var sub = ClientSubscription();
    sub.subcriptionEndDateTime.value = DateTime(2025);
    return responseApiOk(
        data: {'technical_support_mobile': '0597270180', 'subscription': sub});
  }

  Future<Response> getClientHost(Request request) async {
    var body = await request.bodyAsJson;
    var vr = body.validate({'code': Required().isString()});
    if (vr != null) return vr;

    //TODO: get the client details
    var client = await ClientsRepository.instance.getClientByCode(body['code']);

    if (client == null) return responseApiNotFound();
    return responseApiOk(data: {'host_address': client.usersServerHost.value});
  }
}
