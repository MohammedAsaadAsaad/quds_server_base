import '../../imports.dart';

class LocationInfo extends ServerModel {
  var objectType =
      IntField(columnName: 'objectType'); // 1: user, 2: store, ..etc
  var countryTextId = StringField(columnName: 'countryTextId');
  var provinceTextId = StringField(columnName: 'provinceTextId');
  var stateTextId = StringField(columnName: 'stateTextId');
  var cityTextId = StringField(columnName: 'cityTextId');
  var cityAreaTextId = StringField(columnName: 'cityAreaTextId');
  var address = StringField(columnName: 'address');
  var latitude = DoubleField(columnName: 'latitude');
  var longitude = DoubleField(columnName: 'longitude');
  @override
  List<FieldWithValue>? getFields() => [
        objectType,
        countryTextId,
        provinceTextId,
        stateTextId,
        cityTextId,
        cityAreaTextId,
        address,
        latitude,
        longitude
      ];
}

class LocationInfosRepository extends DbRepository<LocationInfo> {
  LocationInfosRepository._() : super(() => LocationInfo());
  static final _instance = LocationInfosRepository._();
  factory LocationInfosRepository() => _instance;

  @override
  String get tableName => 'LocationInfos';
}
