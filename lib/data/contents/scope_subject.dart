import '../../imports.dart';

class ScopeSubject extends SectionContent {
  var scopeId = IntField(columnName: 'scopeid');
  @override
  List<FieldWithValue>? getFields() => [scopeId];
  static const String contentType = 'scope_subject';

  @override
  Future<bool> userHasPermission(UserBase user, String permission) async =>
      await ContentPermissionsRepository.instance
          .hasPermissionOn(user, contentType, id.value!, permission);

  Future<void> changeChildrenParents({int? scopeId}) async {
    var repo = SubjectBranchesRepository.instance;
    var branches = await repo.selectWhere((e) => e.subjectId.equals(id.value));
    for (var b in branches) {
      if ((scopeId != null && b.scopeId.value != scopeId)) {
        await repo.updateEntry(b);
        await b.changeChildrenParents(scopeId: scopeId, subjectId: id.value);
      }
    }
  }
}

class ScopeSubjectsRepository extends DbRepository<ScopeSubject> {
  ScopeSubjectsRepository._() : super(() => ScopeSubject());
  static final ScopeSubjectsRepository _instance = ScopeSubjectsRepository._();
  static ScopeSubjectsRepository instance = _instance;
  factory ScopeSubjectsRepository() => _instance;

  @override
  String get tableName => 'scope_subject';
}
