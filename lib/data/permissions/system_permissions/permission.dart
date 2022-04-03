// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:quds_server_base/imports.dart';

class Permission extends DbModel {
  var name = StringField(columnName: 'name');
  var displayName = StringField(columnName: 'display_name');

  @override
  List<FieldWithValue>? getFields() => [name, displayName];
}

class PermissionsRepository extends DbRepository<Permission> {
  PermissionsRepository._()
      : super(() => Permission(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final _instance = PermissionsRepository._();
  factory PermissionsRepository() => _instance;

  @override
  String get tableName => 'permissions';

  Future<void> checkInitialPermissions() async {
    for (var i in _initials.keys) {
      var r = await selectFirstWhere((model) => model.name.equals(i));
      if (r == null) {
        await insertEntry(Permission()
          ..name.value = i
          ..displayName.value = _initials[i]);
      }
    }
  }

  Future<List<int>> getPermissionIdsByNames(List<String> names) async {
    if (names.isEmpty) return [];
    var result = await selectWhere((e) => e.name.inCollection(names));
    return result.map((e) => e.id.value!).toList();
  }

  Future<List<Permission>> getPermissionsByNames(List<String> names) async {
    if (names.isEmpty) return [];
    return await selectWhere((e) => e.name.inCollection(names));
  }
}

var _initials = {
  Permissions.user_create: 'Create User',
  Permissions.user_edit: 'Edit User',
  Permissions.user_set_permissions: 'Edit User',
  Permissions.permission_create: 'Create Permission',
  Permissions.permission_edit: 'Edit Permission',
  Permissions.permissions_group_create: 'Create Permissions Group',
  Permissions.permissions_group_edit: 'Edit Permissions Group',
  Permissions.user_role_create: 'Create User Role',
  Permissions.edit_role_create: 'Edit User Role',
  Permissions.manage_scopes: 'Manage Training Scopes',
};

class Permissions {
  static Map<String, String> get allPermissions => _initials;
  static const String user_create = 'user_create';
  static const String user_edit = 'user_edit';
  static const String user_set_permissions = 'user_set_permissions';
  static const String permission_create = 'permission_create';
  static const String permission_edit = 'permission_edit';
  static const String permissions_group_create = 'permissions_group_create';
  static const String permissions_group_edit = 'permissions_group_edit';
  static const String user_role_create = 'user_role_create';
  static const String edit_role_create = 'edit_role_create';
  static const String manage_scopes = 'manage_scopes';
  static const String manage_carriers = 'manage_carriers';
}
