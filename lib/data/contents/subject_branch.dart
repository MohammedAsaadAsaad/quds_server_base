import '../../imports.dart';

class SubjectBranch extends SectionContent {
  var title = StringField(columnName: 'title');
  var scopeId = IntField(columnName: 'scopid');
  var subjectId = IntField(columnName: 'subjectid');

  @override
  List<FieldWithValue>? getFields() => [title, scopeId, subjectId];
  static const String contentType = 'subject_branch';

  @override
  Future<bool> userHasPermission(UserBase user, String permission) async =>
      await ContentPermissionsRepository.instance
          .hasPermissionOn(user, contentType, id.value!, permission);
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
