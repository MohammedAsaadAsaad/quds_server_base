import '../../imports.dart';

class UserBasesRepository extends DbRepository<UserBase> {
  UserBasesRepository._()
      : super(() => UserBase(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final _instance = UserBasesRepository._();
  factory UserBasesRepository() => _instance;

  Future<UserBase> createUser(
      String username, String password, int? roleId) async {
    final salt = generateSalt();
    final hashedPassword = hashPassword(password, salt);
    var user = UserBase()
      ..username.value = username
      ..password.value = hashedPassword
      ..roleId.value = roleId
      ..salt.value = salt;
    await insertEntry(user);
    return user;
  }

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
    var authHeader = headers['authorization'];
    if (authHeader != null) {
      return await UserLoginDetailsRepository().getUserByToken(authHeader);
    }
    return null;
  }
}
