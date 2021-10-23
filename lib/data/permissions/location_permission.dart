import 'package:edebt_server/imports.dart';

class LocationPermission extends DbModel {
  static String createSubLocations = 'create-sub-locations';
  static String editLocationDetails = 'edit-location-Details';
  static String viewReports = 'view-reports';
  static String createStores = 'create-stores';
  static String moveToAnotherLocation = 'move-to-another-location';
  static String setStoreOwner = 'set-store-owner';

  var userTextId = StringField(columnName: 'userTextId');
  var locationTextId = StringField(columnName: 'locationTextId');
  var locationType = StringField(columnName: 'locationType');

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
  List<FieldWithValue>? getFields() =>
      [userTextId, locationTextId, locationType];
}

class LocationPermissionsRepository extends DbRepository<LocationPermission> {
  LocationPermissionsRepository._() : super(() => LocationPermission());
  static final _instance = LocationPermissionsRepository._();
  factory LocationPermissionsRepository() => _instance;

  @override
  String get tableName => 'LocationPermissions';

  Future<bool?> hasDirectActionPermissionOn(
      {required String locationType,
      required String locationTextId,
      required String action,
      required String userTextId,
      required UserType userType}) async {
    if (userType == UserType.admin) return true;

    var result = await selectFirstWhere((p) =>
        p.userTextId.equals(userTextId) &
        p.locationTextId.equals(locationTextId) &
        p.locationType.equals(locationType));
    if (result != null) {
      return result.permissions.value?[action];
    }
    return null;
  }

  Future<bool> canDoActionOnCountry(
      {required String countryId,
      required String action,
      required String userId,
      required UserType userType}) async {
    var result = await hasDirectActionPermissionOn(
        locationType: 'country',
        locationTextId: countryId,
        action: action,
        userTextId: userId,
        userType: userType);
    return result == true;
  }

  Future<bool> canDoActionOnProvince(
      {required String provinceId,
      required String action,
      required String userId,
      required UserType userType}) async {
    var result = await hasDirectActionPermissionOn(
        locationType: 'province',
        locationTextId: provinceId,
        action: action,
        userTextId: userId,
        userType: userType);
    return result == true ||
        await canDoActionOnCountry(
            countryId: (await ProvincesRepository()
                    .selectFirstWhere((p) => p.textId.equals(provinceId)))!
                .countryTextId
                .value!,
            action: action,
            userId: userId,
            userType: userType);
  }

  Future<bool> canDoActionOnState(
      {required String stateId,
      required String action,
      required String userId,
      required UserType userType}) async {
    var result = await hasDirectActionPermissionOn(
        locationType: 'state',
        locationTextId: stateId,
        action: action,
        userTextId: userId,
        userType: userType);
    return result == true ||
        await canDoActionOnProvince(
            provinceId:
                (await CountryStatesRepository().getItemByTextId(stateId))!
                    .provinceTextId
                    .value!,
            action: action,
            userId: userId,
            userType: userType);
  }

  Future<bool> canDoActionOnCity(
      {required String cityId,
      required String action,
      required String userId,
      required UserType userType}) async {
    var result = await hasDirectActionPermissionOn(
        locationType: 'city',
        locationTextId: cityId,
        action: action,
        userTextId: userId,
        userType: userType);
    return result == true ||
        await canDoActionOnState(
            stateId: (await CitiesRepository()
                    .selectFirstWhere((p) => p.id.equals(cityId)))!
                .stateTextId
                .value!,
            action: action,
            userId: userId,
            userType: userType);
  }

  Future<bool> canDoActionOnCityArea(
      {required String areaId,
      required String action,
      required String userId,
      required UserType userType}) async {
    var result = await hasDirectActionPermissionOn(
        locationType: 'area',
        locationTextId: areaId,
        action: action,
        userTextId: userId,
        userType: userType);
    return result == true ||
        await canDoActionOnCity(
            cityId: (await CityAreasRepository()
                    .selectFirstWhere((p) => p.id.equals(areaId)))!
                .cityTextId
                .value!,
            action: action,
            userId: userId,
            userType: userType);
  }

  Future<bool> canDoActionOnDistrict(
      {required String districtId,
      required String action,
      required String userId,
      required UserType userType}) async {
    var result = await hasDirectActionPermissionOn(
        locationType: 'district',
        locationTextId: districtId,
        action: action,
        userTextId: userId,
        userType: userType);
    return result == true ||
        await canDoActionOnCityArea(
            areaId: (await DistrictsRepository()
                    .selectFirstWhere((p) => p.id.equals(districtId)))!
                .cityAreaTextId
                .value!,
            action: action,
            userId: userId,
            userType: userType);
  }

  Future<List<LocationPermission>> getUserPermissions(int userBaseId) async {
    return await select(where: (p) => p.userTextId.equals(userBaseId));
  }
}
