import 'package:quds_server_base/imports.dart';

class ScopeSubjectsController extends QudsController {
  Future<Response> addScopeSubject(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    var body = await request.bodyAsJson;
    var vr = body.validate({
      'scope_id': Required().isPositiveInteger(),
      'title': Required().isString(),
      'content': Required()
    });
    if (vr != null) return vr;
    int scopeId = body['scope_id'];
    var scope = await TrainingScopesRepository.instance.loadEntryById(scopeId);
    if (scope == null) return responseApiNotFound(message: 'Scope not found!');
    bool isAllowed = await user.hasPermissionOn(TrainingScope.contentType,
        scopeId, ContentPermissions.manage_child_contents);
    if (!isAllowed) return responseApiForbidden();

    ScopeSubject item = ScopeSubject()
      ..title.value = body['title']
      ..scopeId.value = body['scope_id']
      ..content.value = body['content'];

    await ScopeSubjectsRepository.instance.insertEntry(item);

    return responseApiOk(data: {'subject': item});
  }

  Future<Response> editScopeSubject(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    var body = await request.bodyAsJson;
    var vr = body.validate({
      'subject_id': Required().isPositiveInteger(),
      'scope_id': IsPositiveInteger(),
      'title': IsString(),
    });
    if (vr != null) return vr;

    var repo = ScopeSubjectsRepository();

    var subjectId = body['subject_id'];
    var subject = await repo.loadEntryById(subjectId);
    if (subject == null) return responseApiNotFound();

    // Check if the scope changed
    var oldScopeId = subject.scopeId.value;
    var newScopeId = body['scope_id'] ?? oldScopeId;
    if (oldScopeId != newScopeId) {
      var scope =
          await TrainingScopesRepository.instance.loadEntryById(newScopeId);
      if (scope == null) {
        return responseApiNotFound(message: 'Scope not found!');
      }
      bool isAllowed = await user.hasPermissionOn(TrainingScope.contentType,
          newScopeId, ContentPermissions.manage_child_contents);

      if (!isAllowed) return responseApiForbidden();

      //Change all children scope id
      await subject.changeChildrenParents(scopeId: newScopeId);
    }

    subject.title.value = body['title'] ?? subject.title.value;
    subject.content.value = body['content'] ?? subject.content.value;
    subject.scopeId.value = body['scope_id'] ?? subject.scopeId.value;

    await repo.updateEntry(subject);

    return responseApiOk(data: {'subject': subject});
  }

  Future<Response> getSubjects(Request request) async {
    var body = await request.bodyAsJson;
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();

    var vr = body.validate({
      'page': IsPositiveInteger(),
      'limit': IsPositiveInteger(),
      'scope_id': Required().isPositiveInteger()
    });

    if (vr != null) return vr;

    int page = body['page'] ?? 1;
    int limit = body['limit'] ?? 10;
    int scopeId = body['scope_id'];
    var afterDateTime = DateTime.tryParse(body['after']?.toString() ?? '');

    var result = await ScopeSubjectsRepository().loadAllEntriesByPaging(
        pageQuery:
            DataPageQuery<ScopeSubject>(page: page, resultsPerPage: limit),
        where: (e) {
          var q = e.deletedAt.isNull;
          q &= e.scopeId.equals(scopeId);
          if (afterDateTime != null) q &= e.updatedAt > afterDateTime;
          return q;
        },
        orderBy: (e) => [e.modificationTime.descOrder]);

    return responseApiOk(
      data: {
        'page': result.page,
        'pages': result.pages,
        'total': result.total,
        'limit': limit,
        'subjects': result.results
      },
    );
  }
}
