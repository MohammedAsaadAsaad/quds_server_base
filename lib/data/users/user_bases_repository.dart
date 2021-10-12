import 'package:quds_server_base/imports.dart';

class UserBasesRepository extends DbRepository<UserBase> {
  UserBasesRepository._() : super(() => UserBase());
  static final _instance = UserBasesRepository._();
  factory UserBasesRepository() => _instance;

  Future<UserBase?> getUserByUsername(String username) async =>
      await selectFirstWhere((model) => model.username.equals(username));

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

  @override
  String get tableName => 'UserBases';
}

extension RequestExtensions on Request {
  Future<UserBase?> get currentUserBase async {
    var authDetails = context['authDetails'];
    if (authDetails != null && authDetails is JWT) {
      var id = int.tryParse((authDetails.subject ?? '').split(':').last);
      if (id != null) return UserBasesRepository().loadEntryById(id);
    }
  }
}
