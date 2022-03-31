import 'package:quds_server_base/imports.dart';

class UserPermission extends DbModel {
  var permissionId = StringField(columnName: 'permission_id');
  var userId = StringField(columnName: 'user_id');
  var level = IntField(columnName: 'level'); //Allowed, Prevented, AsGlobal
  @override
  List<FieldWithValue>? getFields() => [permissionId, userId, level];
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
}
