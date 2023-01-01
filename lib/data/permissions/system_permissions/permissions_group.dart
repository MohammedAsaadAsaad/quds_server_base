import '../../../imports.dart';

class PermissionsGroup extends DbModel {
  var name = StringField(columnName: 'name');
  var displayName = StringField(columnName: 'display_name');
  var permissions = ListField(columnName: 'permissions');
  @override
  List<FieldWithValue>? getFields() => [name, displayName, permissions];
}

class PermissionsGroupsRepository extends DbRepository<PermissionsGroup> {
  PermissionsGroupsRepository._()
      : super(() => PermissionsGroup(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final _instance = PermissionsGroupsRepository._();
  factory PermissionsGroupsRepository() => _instance;

  @override
  String get tableName => 'permissions_groups';

  Future<void> checkPermissionsGroups() async {
    for (var k in _initials.keys) {
      var name = k.split('|')[0];
      var group = await selectFirstWhere((model) => model.name.equals(name));
      if (group == null) {
        await insertEntry(PermissionsGroup()
          ..name.value = name
          ..displayName.value = k.split('|')[1]
          ..permissions.value = await PermissionsRepository()
              .getPermissionIdsByNames(_initials[k]!));
      }
    }
  }
}

var _initials = {
  'admin|Admin': Permissions.allPermissions.keys.toList(),
  'users_manager|Users Manager': [
    Permissions.user_create,
    Permissions.user_edit
  ]
};
