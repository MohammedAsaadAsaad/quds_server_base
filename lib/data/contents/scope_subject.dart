import '../../imports.dart';

class ScopeSubject extends SectionContent {
  var branchId = IntField(columnName: 'branchid');
  var scopeId = IntField(columnName: 'scopeid');
  @override
  List<FieldWithValue>? getFields() => [branchId, scopeId];
  static const String contentType = 'scope_subject';

  @override
  Future<bool> userHasPermission(UserBase user, String permission) async =>
      await ContentPermissionsRepository.instance
          .hasPermissionOn(user, contentType, id.value!, permission);
}

class ScopeSubjectsRepository extends DbRepository<ScopeSubject> {
  ScopeSubjectsRepository._() : super(() => ScopeSubject());
  static final ScopeSubjectsRepository _instance = ScopeSubjectsRepository._();
  static ScopeSubjectsRepository instance = _instance;
  factory ScopeSubjectsRepository() => _instance;

  @override
  String get tableName => 'scope_subject';
}
