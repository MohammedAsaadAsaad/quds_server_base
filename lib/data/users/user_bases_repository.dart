import 'package:edebt_server/imports.dart';

class UserBasesRepository extends DbRepository<UserBase> {
  UserBasesRepository._() : super(() => UserBase());
  static final _instance = UserBasesRepository._();
  factory UserBasesRepository() => _instance;

  @override
  String get tableName => 'UserBases';

  Future<UserBase?> getUserByEmail(String email) async =>
      await selectFirstWhere((model) => model.email.equals(email));

  Future<String?> changeUserPassword(
      int userId, String oldPassword, String newPassword) async {
    try {
      var user = await loadEntryById(userId);

      if (user == null) return 'User not exist!';

      if (user.password.value != user.hashNewPassword(oldPassword)) {
        return 'Old password is incorrect!';
      }
      user.password.value = user.hashNewPassword(newPassword);
      await updateEntry(user);

      return null;
    } catch (e) {
      return 'Error while changing password!';
    }
  }

  Future<bool> isEmailReservedForAnother(int userId, String email) async {
    var user = await selectFirst(where: (u) => u.email.equals(email));

    if (user != null && user.id.value != userId) return true;

    return false;
  }
}

extension RequestExtensions on Request {
  Future<UserBase?> get currentUserBase async {
    var context = this.context;
    var authDetails = context['authDetails'];
    if (authDetails != null && authDetails is JWT) {
      var id = int.tryParse((authDetails.subject ?? '').split(':').last);
      if (id != null) return UserBasesRepository().loadEntryById(id);
    }
  }
}
