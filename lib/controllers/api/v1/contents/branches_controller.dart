import 'package:quds_server_base/imports.dart';

class SubjectBranchesController extends QudsController {
  Future<Response> addSubjectBranch(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    var body = await request.bodyAsJson;
    var vr = body.validate({
      'subject_id': Required().isPositiveInteger(),
      'title': Required().isString(),
      'content': Required()
    });
    if (vr != null) return vr;
    int subjectId = body['subject_id'];
    var subject =
        await ScopeSubjectsRepository.instance.loadEntryById(subjectId);
    if (subject == null) {
      return responseApiNotFound(message: 'subject not found!');
    }
    bool isAllowed = await user.hasPermissionOn(ScopeSubject.contentType,
        subjectId, ContentPermissions.manage_child_contents);
    if (!isAllowed) return responseApiForbidden();

    SubjectBranch item = SubjectBranch()
      ..title.value = body['title']
      ..scopeId.value = subject.scopeId.value
      ..subjectId.value = subject.id.value
      ..content.value = body['content'];

    await SubjectBranchesRepository.instance.insertEntry(item);

    return responseApiOk(data: {'branch': item});
  }

  Future<Response> editSubjectBranch(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    var body = await request.bodyAsJson;
    var vr = body.validate({
      'branch_id': Required().isPositiveInteger(),
      'subject_id': IsPositiveInteger(),
      'title': IsString(),
    });
    if (vr != null) return vr;

    var repo = SubjectBranchesRepository();

    var branchId = body['branch_id'];
    var branch = await repo.loadEntryById(branchId);
    if (branch == null) return responseApiNotFound();

    // Check if the subject changed

    var oldSubjectId = branch.subjectId.value;
    var newSubjectId = body['subject_id'] ?? oldSubjectId;
    if (oldSubjectId != newSubjectId) {
      var subject =
          await ScopeSubjectsRepository.instance.loadEntryById(newSubjectId);
      if (subject == null) {
        return responseApiNotFound(message: 'Subject not found!');
      }

      var isAllowed = await user.hasPermissionOn(ScopeSubject.contentType,
          newSubjectId, ContentPermissions.manage_child_contents);

      if (!isAllowed) return responseApiForbidden();

      //Change all children scope id, subject id
      await branch.changeChildrenParents(subjectId: newSubjectId);
    }

    branch.title.value = body['title'] ?? branch.title.value;
    branch.content.value = body['content'] ?? branch.content.value;
    branch.subjectId.value = body['subject_id'] ?? branch.subjectId.value;

    await repo.updateEntry(branch);

    return responseApiOk(data: {'branch': branch});
  }

  Future<Response> getBranches(Request request) async {
    var body = await request.bodyAsJson;
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();

    var vr = body.validate({
      'page': IsPositiveInteger(),
      'limit': IsPositiveInteger(),
      'scope_id': IsPositiveInteger(),
      'subject_id': IsPositiveInteger(),
    });

    if (vr != null) return vr;

    int? scopeId = body['scope_id'];
    int? subjectId = body['subject_id'];
    if (scopeId == null && subjectId == null) {
      return responseApiBadRequest(
          message: 'One of `scope id` or `subject id` must be provided');
    }

    int page = body['page'] ?? 1;
    int limit = body['limit'] ?? 10;
    var afterDateTime = DateTime.tryParse(body['after']?.toString() ?? '');

    var result = await SubjectBranchesRepository.instance
        .loadAllEntriesByPaging(
            pageQuery:
                DataPageQuery<SubjectBranch>(page: page, resultsPerPage: limit),
            where: (e) {
              var q = e.deletedAt.isNull;
              if (scopeId != null) q &= e.scopeId.equals(scopeId);
              if (subjectId != null) q &= e.subjectId.equals(subjectId);
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
        'branches': result.results
      },
    );
  }
}
