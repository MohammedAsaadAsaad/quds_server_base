import '../../imports.dart';

class UserBase extends DbModel {
  var username = StringField(columnName: 'username');
  var password = StringField(columnName: 'password');
  var salt = StringField(columnName: 'salt');
  var roleId = IntField(columnName: 'role_id');

  @override
  List<FieldWithValue>? getFields() => [username, password, salt, roleId];

  String hashNewPassword(String password) =>
      hashPassword(password, salt.value!);

  Future<bool> get isAdmin async => roleId.value == await UserRole.adminRoleId;
  Future<bool> hasPermission(String permission) async {
    if (await isAdmin) return true;

    var perm = await UserPermissionRepository()
        .getUserPermission(id.value!, permission);

    return perm?.isAllowed == true;
  }

  Future<bool> hasPermissionOn(
      String contentType, int contentId, String permission) async {
    if (await isAdmin) return true;

    return await ContentPermissionsRepository.instance
        .hasPermissionOn(this, contentType, contentId, permission);
  }
}
