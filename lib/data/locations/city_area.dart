import '../../imports.dart';

class CityArea extends ServerModel {
  var nameEnglish = StringField(columnName: 'nameEnglish');
  var nameNative = StringField(columnName: 'nameNative');
  var countryTextId = StringField(columnName: 'countryTextId');
  var provinceTextId = StringField(columnName: 'provinceTextId');
  var stateTextId = StringField(columnName: 'stateTextId');
  var cityTextId = StringField(columnName: 'cityTextId');
  var creatorTextId = StringField(columnName: 'creatorTextId', notNull: true);
  @override
  List<FieldWithValue>? getFields() => [
        nameEnglish,
        nameNative,
        countryTextId,
        provinceTextId,
        stateTextId,
        cityTextId,
        creatorTextId
      ];
}

class CityAreasRepository extends ServerRepository<CityArea> {
  CityAreasRepository._() : super(() => CityArea());
  static final _instance = CityAreasRepository._();
  factory CityAreasRepository() => _instance;

  @override
  String get tableName => 'CityAreas';

  Future<CityArea?> createCityArea({
    required String cityTextId,
    required String creatorTextId,
    required String nameEnglish,
    required String nameNative,
  }) async {
    var city = await CitiesRepository().getItemByTextId(cityTextId);
    if (city == null) return null;

    var item = await createNewInstance();
    item.nameEnglish.value = nameEnglish;
    item.nameNative.value = nameNative;
    item.cityTextId.value = city.textId.value;
    item.stateTextId.value = city.stateTextId.value;
    item.provinceTextId.value = city.provinceTextId.value;
    item.countryTextId.value = city.countryTextId.value;
    item.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<CityArea?> editCityArea({
    required String cityAreaTextId,
    String? cityTextId,
    String? nameEnglish,
    String? nameNative,
  }) async {
    var item =
        await selectFirstWhere((model) => model.id.equals(cityAreaTextId));
    if (item == null) return null;

    if (cityTextId != null) {
      var city = await CitiesRepository().getItemByTextId(cityTextId);
      if (city == null) return null;
      item.cityTextId.value = city.textId.value;
      item.stateTextId.value = city.stateTextId.value;
      item.provinceTextId.value = city.provinceTextId.value;
      item.countryTextId.value = city.countryTextId.value;
    }

    if (nameEnglish != null) item.nameEnglish.value = nameEnglish;
    if (nameNative != null) item.nameNative.value = nameNative;

    try {
      await updateEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }
}
