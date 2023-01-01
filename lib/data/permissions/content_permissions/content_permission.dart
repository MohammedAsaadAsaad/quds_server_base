import '../../../imports.dart';

class ContentPermissoin extends DbModel {
  var contentType = StringField(columnName: 'content_type');
  var contentId = IntField(columnName: 'content_id');
  var permission = IntField(columnName: 'permission');
  var allowed = BoolField(columnName: 'allowed');
  var userId = IntField(columnName: 'user_id');
  @override
  List<FieldWithValue>? getFields() =>
      [contentType, contentId, permission, allowed, userId];
}

class ContentPermissionsRepository extends DbRepository<ContentPermissoin> {
  ContentPermissionsRepository._()
      : super(() => ContentPermissoin(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);

  static final ContentPermissionsRepository _instance =
      ContentPermissionsRepository._();
  static ContentPermissionsRepository instance = _instance;
  factory ContentPermissionsRepository() => _instance;

  @override
  String get tableName => 'content_permissions';

  Future<bool> hasPermissionOn(UserBase user, String contentType, int contentId,
      String permission) async {
    var r = await selectFirstWhere((m) =>
        m.contentType.equals(contentType) &
        m.contentId.equals(contentId) &
        m.permission.equals(permission));
    if (r != null) return r.allowed.value == true;

    if (contentType == TrainingScope.contentType) return false;

    return await _hasPermissionOnParent(
        user, contentType, contentId, permission);
  }

  Future<bool> _hasPermissionOnParent(UserBase user, String contentType,
      int contentId, String permission) async {
    if (await user.isAdmin) return true;

    // Get permission
    switch (contentType) {
      case SubjectBranch.contentType:
        var branch = await SubjectBranchesRepository().loadEntryById(contentId);
        if (branch == null) return false;
        return await hasPermissionOn(user, ScopeSubject.contentType,
            branch.subjectId.value!, permission);

      case ScopeSubject.contentType:
        var subject = await ScopeSubjectsRepository().loadEntryById(contentId);
        if (subject == null) return false;
        return await hasPermissionOn(user, TrainingScope.contentType,
            subject.scopeId.value!, permission);
    }
    return false;
  }

  Future<ContentPermissoin> setUserContentPermission(
      int userId,
      String contentType,
      int contentId,
      String permission,
      bool allowed) async {
    var conPerm = await selectFirstWhere((m) =>
        m.userId.equals(userId) &
        m.contentType.equals(
          contentType,
        ) &
        m.contentId.equals(contentId) &
        m.permission.equals(permission));

    conPerm ??= ContentPermissoin()
      ..userId.value = userId
      ..contentId.value = contentId
      ..contentType.value = contentType
      ..permission.value
      ..allowed.value = allowed;

    await updateEntry(conPerm);

    return conPerm;
  }
}
