import 'package:quds_server_base/imports.dart';

class CarriersController extends QudsController {
  Future<Response> addCarrier(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    if (!await user.hasPermission(Permissions.manage_carriers)) {
      return responseApiForbidden();
    }

    var body = await request.bodyAsJson;
    var vr =
        body.validate({'title': Required().isString(), 'content': Required()});
    if (vr != null) return vr;

    Carrier carrier = Carrier()
      ..title.value = body['title']
      ..content.value = body['content'];

    await CarriersRepository.instance.insertEntry(carrier);

    return responseApiOk(data: {'carrier': carrier});
  }

  Future<Response> editCarrier(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    if (!await user.hasPermission(Permissions.manage_carriers)) {
      return responseApiForbidden();
    }

    var body = await request.bodyAsJson;
    var vr = body.validate(
        {'title': IsString(), 'carrier_id': Required().isPositiveInteger()});
    if (vr != null) return vr;

    var carrierId = body['carrier_id'];
    var repo = CarriersRepository();

    var carrier = await repo.loadEntryById(carrierId);
    if (carrier == null) return responseApiNotFound();

    carrier
      ..title.value = body['title']
      ..content.value = body['content'];

    await repo.updateEntry(carrier);

    return responseApiOk(data: {'carrier': carrier});
  }

  Future<Response> getCarriers(Request request) async {
    var body = await request.bodyAsJson;
    var vr = body.validate({'after': IsString(), 'limit': IsPositiveInteger()});
    if (vr != null) return vr;

    var afterDateTime = DateTime.tryParse(body['after']?.toString() ?? '');
    int? limit = body['limit'];
    var carriers = await CarriersRepository().select(
        limit: limit,
        where: afterDateTime == null
            ? null
            : (e) => e.updatedAt.moreThan(afterDateTime),
        orderBy: (s) => [s.updatedAt.earlierOrder]);
    return responseApiOk(data: {'carriers': carriers});
  }
}
