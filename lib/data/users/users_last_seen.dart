import '../../imports.dart';

class UserLastSeen extends DbModel {
  var userId = IntField(columnName: 'userid');
  var datetime = DateTimeField(columnName: 'datetime');
  @override
  List<FieldWithValue>? getFields() => [userId, datetime];
}

class UserLastSeenRepository extends DbRepository<UserLastSeen> {
  UserLastSeenRepository._()
      : super(() => UserLastSeen(),
            specialDb: UsersDatabaseConfigurations.dbName,
            connectionSettings: UsersDatabaseConfigurations.connectionSettings);
  static final UserLastSeenRepository _instance = UserLastSeenRepository._();
  factory UserLastSeenRepository() => _instance;

  Future<void> setUserLastSeen(int userId) async {
    var lastSeen =
        await selectFirstWhere((model) => model.userId.equals(userId));

    if (lastSeen != null) {
      lastSeen.datetime.value = DateTime.now();
      await updateEntry(lastSeen);
    } else {
      await insertEntry(UserLastSeen()
        ..userId.value = userId
        ..datetime.value = DateTime.now());
    }
  }

  @override
  String get tableName => 'UserLastSeen';
}
