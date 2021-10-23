import '../../imports.dart';

class Store extends ServerModel {
  var name = StringField(columnName: 'name');
  var description = StringField(columnName: 'description');
  var countryTextId = StringField(columnName: 'countryTextId');
  var provinceTextId = StringField(columnName: 'provinceTextId');
  var stateTextId = StringField(columnName: 'stateTextId');
  var cityTextId = StringField(columnName: 'cityTextId');
  var cityAreaTextId = StringField(columnName: 'cityAreaTextId');
  var districtTextId = StringField(columnName: 'districtTextId');
  var creatorTextId = StringField(columnName: 'creatorTextId', notNull: true);
  var scopes = ListField(columnName: 'scopes');
  @override
  List<FieldWithValue>? getFields() => [
        name,
        description,
        countryTextId,
        provinceTextId,
        stateTextId,
        cityTextId,
        cityAreaTextId,
        districtTextId,
        creatorTextId,
        scopes
      ];
}

class StoresRepository extends ServerRepository<Store> {
  StoresRepository._() : super(() => Store());
  static final _instance = StoresRepository._();
  factory StoresRepository() => _instance;

  @override
  String get tableName => 'Stores';

  Future<Store?> createStore(
      {required String districtTextId,
      required String name,
      required String description,
      List<int>? scopes,
      required String creatorTextId}) async {
    var item = await createNewInstance();
    item.name.value = name;
    item.description.value = description;

    var district = await DistrictsRepository().getItemByTextId(districtTextId);
    if (district == null) return null;
    item.districtTextId.value = districtTextId;
    item.cityAreaTextId.value = district.cityAreaTextId.value;
    item.cityTextId.value = district.cityTextId.value;
    item.stateTextId.value = district.stateTextId.value;
    item.provinceTextId.value = district.provinceTextId.value;
    item.countryTextId.value = district.countryTextId.value;

    item.scopes.value = scopes;
    item.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<Store?> updateStore({
    required String storeId,
    String? districtTextId,
    String? name,
    String? description,
    List<int>? scopes,
  }) async {
    var item = await getItemByTextId(storeId);
    if (item == null) return null;

    if (name != null) item.name.value = name;
    if (description != null) item.description.value = description;

    if (districtTextId != null) {
      var district =
          await DistrictsRepository().getItemByTextId(districtTextId);
      if (district == null) return null;
      item.districtTextId.value = districtTextId;
      item.cityAreaTextId.value = district.cityAreaTextId.value;
      item.cityTextId.value = district.cityTextId.value;
      item.stateTextId.value = district.stateTextId.value;
      item.provinceTextId.value = district.provinceTextId.value;
      item.countryTextId.value = district.countryTextId.value;
    }

    if (scopes != null) item.scopes.value = scopes;

    try {
      await updateEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }
}
