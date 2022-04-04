import '../../../imports.dart';

class UserPermission extends DbModel {
  var permissionId = IntField(columnName: 'permission_id');
  var userId = StringField(columnName: 'user_id');
  var level = IntField(
      columnName: 'level'); //1: Allowed, -1: Prevented, 0/null: AsGlobal
  @override
  List<FieldWithValue>? getFields() => [permissionId, userId, level];

  bool get isAllowed => level.value == 1;
  bool get isPrevented => level.value == -1;
}

class UserPermissionRepository extends DbRepository<UserPermission> {
  UserPermissionRepository._()
      : super(() => UserPermission(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final _instance = UserPermissionRepository._();
  factory UserPermissionRepository() => _instance;

  @override
  String get tableName => 'user_permissions';

  Future<UserPermission?> getUserPermission(
      int userId, String permission) async {
    var permissionId = await PermissionsRepository()
        .selectFirstWhere((model) => model.name.equals(permission));
    if (permissionId == null) return null;

    return await selectFirstWhere((model) =>
        model.userId.equals(userId) & model.permissionId.equals(permissionId));
  }
}
