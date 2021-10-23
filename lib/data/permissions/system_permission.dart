import 'package:edebt_server/imports.dart';

class SystemPermission extends DbModel {
  static var setPermissions = 'set-permissions';
  static var createStoreCategories = 'create-store-categories';

  var userId = IntField(columnName: 'userId');

  /// The permission name
  ///
  /// as example:
  ///
  /// countries.can_create
  ///
  var permissionName = StringField(columnName: 'permissionName');

  /// The permission value
  ///
  /// as example:
  ///
  /// 0: false
  ///
  /// 1: true
  ///
  /// 2: .....
  var permissionValue = IntField(columnName: 'permissionValue');
  var creatorId = IntField(columnName: 'creatorId', notNull: true);
  @override
  List<FieldWithValue>? getFields() =>
      [permissionName, permissionValue, creatorId, userId];
}

class SystemPermissionsRepository extends DbRepository<SystemPermission> {
  SystemPermissionsRepository._() : super(() => SystemPermission());
  static final _instance = SystemPermissionsRepository._();
  factory SystemPermissionsRepository() => _instance;

  @override
  String get tableName => 'SystemPermissions';

  Future<int?> getPermission(
      {required int userId, required String permission}) async {
    var perm = await selectFirstWhere((model) =>
        model.userId.equals(userId) & model.permissionName.equals(permission));
    return perm?.permissionValue.value;
  }

  Future<SystemPermission?> setPermission(
      {required int userId,
      required String permission,
      required int? value}) async {
    var perm = await selectFirstWhere((model) =>
        model.userId.equals(userId) & model.permissionName.equals(permission));
    perm ??= SystemPermission();
    perm.userId.value = userId;
    perm.permissionName.value = permission;
    perm.permissionValue.value = value;
    try {
      await updateEntry(perm);
      return perm;
    } catch (e) {
      return null;
    }
  }

  Future<List<SystemPermission>> getUserPermissions(int userBaseId) async {
    return await select(where: (p) => p.userId.equals(userBaseId));
  }
}
