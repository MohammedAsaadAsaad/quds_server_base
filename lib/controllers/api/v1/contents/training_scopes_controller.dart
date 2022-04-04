import 'package:quds_server_base/imports.dart';

class TrainingScopesController extends QudsController {
  Future<Response> addTrainingScope(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    if (!await user.hasPermission(Permissions.manage_scopes)) {
      return responseApiForbidden();
    }

    var body = await request.bodyAsJson;
    var vr =
        body.validate({'title': Required().isString(), 'content': Required()});
    if (vr != null) return vr;

    TrainingScope scope = TrainingScope()
      ..title.value = body['title']
      ..content.value = body['content'];

    await TrainingScopesRepository.instance.insertEntry(scope);

    return responseApiOk(data: {'scope': scope});
  }

  Future<Response> editTrainingScope(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    if (!await user.hasPermission(Permissions.manage_scopes)) {
      return responseApiForbidden();
    }

    var body = await request.bodyAsJson;
    var vr = body.validate(
        {'title': IsString(), 'scope_id': Required().isPositiveInteger()});
    if (vr != null) return vr;

    var scopeId = body['scope_id'];
    var repo = TrainingScopesRepository();

    var scope = await repo.loadEntryById(scopeId);
    if (scope == null) return responseApiNotFound();

    scope
      ..title.value = body['title']
      ..content.value = body['content'];

    await repo.updateEntry(scope);

    return responseApiOk(data: {'scope': scope});
  }

  Future<Response> getScopes(Request request) async {
    var body = await request.bodyAsJson;
    var vr = body.validate({'after': IsString(), 'limit': IsPositiveInteger()});
    if (vr != null) return vr;

    var afterDateTime = DateTime.tryParse(body['after']?.toString() ?? '');
    int? limit = body['limit'];
    var scopes = await TrainingScopesRepository().select(
        limit: limit,
        where: afterDateTime == null
            ? null
            : (e) => e.updatedAt.moreThan(afterDateTime),
        orderBy: (s) => [s.updatedAt.earlierOrder]);
    return responseApiOk(data: {'scopes': scopes});
  }
}
