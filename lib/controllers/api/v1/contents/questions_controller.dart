import 'package:quds_server_base/imports.dart';

class QuestionsController extends QudsController {
  Future<Response> addQuestion(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    var body = await request.bodyAsJson;
    var vr = body.validate({
      'branch_id': Required().isPositiveInteger(),
      'title': IsString(),
      'content': Required()
    });
    if (vr != null) return vr;
    int branchId = body['branch_id'];
    var branch =
        await SubjectBranchesRepository.instance.loadEntryById(branchId);
    if (branch == null) {
      return responseApiNotFound(message: 'branch not found!');
    }
    bool isAllowed = await user.hasPermissionOn(SubjectBranch.contentType,
        branchId, ContentPermissions.manage_child_contents);
    if (!isAllowed) return responseApiForbidden();

    Question item = Question()
      ..title.value = body['title']
      ..scopeId.value = branch.scopeId.value
      ..subjectId.value = branch.subjectId.value
      ..branchId.value = branch.id.value
      ..content.value = body['content'];

    await QuestionsRepository.instance.insertEntry(item);

    return responseApiOk(data: {'question': item});
  }

  Future<Response> editQuestion(Request request) async {
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();
    var body = await request.bodyAsJson;
    var vr = body.validate({
      'question_id': Required().isPositiveInteger(),
      'branch_id': IsPositiveInteger(),
      'title': IsString(),
    });
    if (vr != null) return vr;

    var repo = QuestionsRepository();

    var questionId = body['question_id'];
    var question = await repo.loadEntryById(questionId);
    if (question == null) return responseApiNotFound();

    // Check if the scope, subject changed
    var oldBranchId = question.branchId.value;
    var newBranchId = body['branch_id'] ?? oldBranchId;
    if (oldBranchId != newBranchId) {
      if (!await user.hasPermissionOn(SubjectBranch.contentType, newBranchId,
          ContentPermissions.manage_child_contents)) {
        return responseApiForbidden();
      }
    }

    question.title.value = body['title'] ?? question.title.value;
    question.content.value = body['content'] ?? question.content.value;
    question.scopeId.value = body['scope_id'] ?? question.scopeId.value;
    question.subjectId.value = body['subject_id'] ?? question.subjectId.value;
    question.branchId.value = body['branch_id'] ?? question.branchId.value;

    await repo.updateEntry(question);

    return responseApiOk(data: {'question': question});
  }

  Future<Response> getQuestions(Request request) async {
    var body = await request.bodyAsJson;
    var user = await request.currentUserBase;
    if (user == null) return responseApiForbidden();

    var vr = body.validate({
      'page': IsPositiveInteger(),
      'limit': IsPositiveInteger(),
      'scope_id': IsPositiveInteger(),
      'subject_id': IsPositiveInteger(),
      'branch_id': IsPositiveInteger(),
    });

    if (vr != null) return vr;

    int? scopeId = body['scope_id'];
    int? subjectId = body['subject_id'];
    int? branchId = body['branch_id'];
    if (scopeId == null && subjectId == null && branchId == null) {
      return responseApiBadRequest(
          message:
              'One of `scope id` or `subject id` or `branch id` must be provided');
    }

    int page = body['page'] ?? 1;
    int limit = body['limit'] ?? 10;
    var afterDateTime = DateTime.tryParse(body['after']?.toString() ?? '');

    var result = await QuestionsRepository.instance.loadAllEntriesByPaging(
        pageQuery: DataPageQuery<Question>(page: page, resultsPerPage: limit),
        where: (e) {
          var q = e.deletedAt.isNull;
          if (scopeId != null) q &= e.scopeId.equals(scopeId);
          if (subjectId != null) q &= e.subjectId.equals(subjectId);
          if (branchId != null) q &= e.branchId.equals(branchId);
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
        'questions': result.results
      },
    );
  }
}
