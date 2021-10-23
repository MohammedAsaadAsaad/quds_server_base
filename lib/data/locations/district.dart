import '../../imports.dart';

class District extends ServerModel {
  var nameEnglish = StringField(columnName: 'nameEnglish');
  var nameNative = StringField(columnName: 'nameNative');
  var countryTextId = StringField(columnName: 'countryTextId');
  var provinceTextId = StringField(columnName: 'provinceTextId');
  var stateTextId = StringField(columnName: 'stateTextId');
  var cityTextId = StringField(columnName: 'cityTextId');
  var cityAreaTextId = StringField(columnName: 'cityAreaTextId');
  var creatorTextId = StringField(columnName: 'creatorTextId', notNull: true);
  @override
  List<FieldWithValue>? getFields() => [
        nameEnglish,
        nameNative,
        countryTextId,
        provinceTextId,
        stateTextId,
        cityTextId,
        cityAreaTextId,
        creatorTextId
      ];
}

class DistrictsRepository extends ServerRepository<District> {
  DistrictsRepository._() : super(() => District());
  static final _instance = DistrictsRepository._();
  factory DistrictsRepository() => _instance;

  @override
  String get tableName => 'Districts';

  Future<District?> createDistrict({
    required String areaTextId,
    required String creatorTextId,
    required String nameEnglish,
    required String nameNative,
  }) async {
    var area = await CityAreasRepository().getItemByTextId(areaTextId);
    if (area == null) return null;

    var item = await createNewInstance();
    item.nameEnglish.value = nameEnglish;
    item.nameNative.value = nameNative;
    item.cityAreaTextId.value = area.textId.value;
    item.cityTextId.value = area.cityTextId.value;
    item.stateTextId.value = area.stateTextId.value;
    item.provinceTextId.value = area.provinceTextId.value;
    item.countryTextId.value = area.countryTextId.value;
    item.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<District?> editDistrict({
    required String districtTextId,
    String? cityAreaTextId,
    String? nameEnglish,
    String? nameNative,
  }) async {
    var item = await getItemByTextId(districtTextId);
    if (item == null) return null;

    if (cityAreaTextId != null) {
      var area = await CityAreasRepository().getItemByTextId(cityAreaTextId);
      if (area == null) return null;
      item.cityAreaTextId.value = area.textId.value;
      item.cityTextId.value = area.cityTextId.value;
      item.stateTextId.value = area.stateTextId.value;
      item.provinceTextId.value = area.provinceTextId.value;
      item.countryTextId.value = area.countryTextId.value;
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
