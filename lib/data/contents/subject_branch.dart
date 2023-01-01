import '../../imports.dart';

class SubjectBranch extends SectionContent {
  var scopeId = IntField(columnName: 'scopid');
  var subjectId = IntField(columnName: 'subjectid');

  @override
  List<FieldWithValue>? getFields() => [scopeId, subjectId];
  static const String contentType = 'subject_branch';

  @override
  Future<bool> userHasPermission(UserBase user, String permission) async =>
      await ContentPermissionsRepository.instance
          .hasPermissionOn(user, contentType, id.value!, permission);

  Future<void> changeChildrenParents({int? scopeId, int? subjectId}) async {
    var repo = QuestionsRepository.instance;
    var questions = await repo.selectWhere((e) => e.branchId.equals(id.value));
    for (var q in questions) {
      if ((scopeId != null && q.scopeId.value != scopeId) ||
          (subjectId != null && q.subjectId.value != subjectId)) {
        await repo.updateEntry(q);
      }
    }
  }
}

class SubjectBranchesRepository extends DbRepository<SubjectBranch> {
  SubjectBranchesRepository._() : super(() => SubjectBranch());
  static final SubjectBranchesRepository _instance =
      SubjectBranchesRepository._();
  static SubjectBranchesRepository instance = _instance;
  factory SubjectBranchesRepository() => _instance;

  @override
  String get tableName => 'subject_branches';
}
