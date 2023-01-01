import '../../imports.dart';

class UserLoginDetails extends DbModel {
  var userId = IntField(columnName: 'user_id');
  var loginDateTime = DateTimeField(columnName: 'login_datetime');
  var token = StringField(columnName: 'token');
  var refreshToken = StringField(columnName: 'refresh_token');

  @override
  List<FieldWithValue>? getFields() =>
      [token, refreshToken, userId, loginDateTime];
}

class UserLoginDetailsRepository extends DbRepository<UserLoginDetails> {
  UserLoginDetailsRepository._()
      : super(() => UserLoginDetails(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final _instance = UserLoginDetailsRepository._();
  factory UserLoginDetailsRepository() => _instance;
  @override
  String get tableName => 'UserLoginsDetails';

  Future<TokenPair> setUserNewTokens(UserBase user) async {
    var salt = user.salt.value!;
    String token = await UserUtilities.generateToken(salt);
    String refreshToken = await UserUtilities.generateRefreshToken(salt);

    UserLoginDetails loginDetails = UserLoginDetails()
      ..token.value = token
      ..userId.value = user.id.value
      ..refreshToken.value = refreshToken
      ..loginDateTime.value = DateTime.now().toUtc();
    await insertEntry(loginDetails);

    return TokenPair(token, refreshToken);
  }

  Future<UserBase?> getUserByToken(String token) async {
    var loginDetails = await UserLoginDetailsRepository().selectFirstWhere(
        (model) => model.token.equals(token),
        desiredFields: (s) => [s.userId]);

    if (loginDetails == null) return null;
    return UserBasesRepository().loadEntryById(loginDetails.userId.value ?? 0);
  }

  Future<void> removeLoginByToken(int userId, String token) async {
    var loginDetails = await selectFirstWhere(
        (model) => model.userId.equals(userId) & model.token.equals(token));

    if (loginDetails != null) deleteEntry(loginDetails);
  }
}
