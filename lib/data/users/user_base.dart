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
}
