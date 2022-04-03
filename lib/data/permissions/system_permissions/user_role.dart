import '../../../imports.dart';

class UserRole extends DbModel {
  var name = StringField(columnName: 'name');
  var displayName = StringField(columnName: 'display_name');
  @override
  List<FieldWithValue>? getFields() => [name, displayName];

  static int? _adminRoleId;
  static Future<int?> get adminRoleId async {
    _adminRoleId ??= await UsersRolesRepository().getRoleId('admin');
    return _adminRoleId;
  }
}

class UsersRolesRepository extends DbRepository<UserRole> {
  UsersRolesRepository._()
      : super(() => UserRole(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final _instance = UsersRolesRepository._();
  factory UsersRolesRepository() => _instance;

  @override
  String get tableName => 'users_roles';

  Future<int?> getRoleId(String roleTitle) async {
    return (await selectFirstWhere((model) => model.name.equals(roleTitle)))
        ?.id
        .value;
  }

  Future<void> checkInitialRoles() async {
    for (var i in _initials.keys) {
      var r = await selectFirstWhere((model) => model.name.equals(i));
      if (r == null) {
        await insertEntry(UserRole()
          ..name.value = i
          ..displayName.value = _initials[i]);
      }
    }

    adminRoleId =
        (await selectFirstWhere((model) => model.name.equals('admin')))
            ?.id
            .value;

    userRoleId = (await selectFirstWhere((model) => model.name.equals('user')))
        ?.id
        .value;

    //Check if there is an admin
    {
      var usersRepo = UserBasesRepository();
      var admin = await usersRepo
          .selectFirstWhere((model) => model.roleId.equals(adminRoleId));
      admin ??= await usersRepo.createUser(
          'admin@admin.com', 'password', adminRoleId);
    }
  }
}

var _initials = {'admin': 'Admin', 'user': 'User'};

int? adminRoleId;
int? userRoleId;
