import 'package:edebt_server/imports.dart';

class StorePermission extends DbModel {
  static String createProducts = 'create-products';
  static String createBuyerFiles = 'create-buyer-files';
  static String linkBuyersToFiles = 'link-buyers-to-files';
  static String adminStore = 'admin-store';

  var userTextId = StringField(columnName: 'userTextId');
  var storeTextId = IntField(columnName: 'storeTextId');

  ///Stored as map with permissions and thier values
  ///
  ///For example
  ///
  ///{
  ///
  ///"create_sub_locations":true,
  ///
  ///"create_stores":false,
  ///
  ///"give_permissions":true
  ///
  ///}
  var permissions = JsonField(columnName: 'permissions');
  @override
  List<FieldWithValue>? getFields() => [
        userTextId,
        storeTextId,
      ];
}

class StorePermissionsRepository extends DbRepository<StorePermission> {
  StorePermissionsRepository._() : super(() => StorePermission());
  static final _instance = StorePermissionsRepository._();
  factory StorePermissionsRepository() => _instance;

  @override
  String get tableName => 'StorePermissions';

  Future<bool?> hasPermissionOnStore(
      {required String storeId,
      required String action,
      required String userId,
      required UserType userType}) async {
    if (userType == UserType.admin) return true;

    var result =
        await getUserPermissions(storeTextId: storeId, userTextId: userId);

    if (result != null) {
      var isStoreAdmin =
          (result.permissions.value?[StorePermission.adminStore] == true);
      if (isStoreAdmin) return true;
      return result.permissions.value?[action];
    }
    return null;
  }

  Future<StorePermission?> getUserPermissions(
      {required String storeTextId, required String userTextId}) async {
    return await selectFirstWhere((p) =>
        p.storeTextId.equals(storeTextId) & p.userTextId.equals(userTextId));
  }
}
