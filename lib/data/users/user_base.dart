import '../../imports.dart';

class UserBase extends DbModel {
  var email = StringField(columnName: 'email');
  var password = StringField(columnName: 'password');
  var salt = StringField(columnName: 'salt');
  var userTextId = StringField(columnName: 'userTextId');

  /// 1: The whole system admin
  ///
  /// 2: normal user
  var userType = IntField(columnName: 'userType');
  @override
  List<FieldWithValue>? getFields() =>
      [email, password, salt, userType, userTextId];

  String hashNewPassword(String password) =>
      hashPassword(password, salt.value!);

  Future<UserDetails> get details async =>
      (await UsersDetailsRepository().getUserDetailsByBaseId(id.value!))!;

  Future<String> get textId async {
    if (userTextId.value == null) {
      String result = (await details).textId.value!;
      userTextId.value = result;
      await UserBasesRepository().updateEntry(this);
    }
    return userTextId.value!;
  }
}
