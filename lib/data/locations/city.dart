import '../../imports.dart';

class City extends ServerModel {
  var nameEnglish = StringField(columnName: 'nameEnglish');
  var nameNative = StringField(columnName: 'nameNative');
  var countryTextId = StringField(columnName: 'countryId');
  var provinceTextId = StringField(columnName: 'provinceId');
  var stateTextId = StringField(columnName: 'stateId');
  var creatorTextId = StringField(columnName: 'creatorId', notNull: true);

  @override
  List<FieldWithValue>? getFields() => [
        nameEnglish,
        nameNative,
        countryTextId,
        provinceTextId,
        stateTextId,
        creatorTextId,
      ];
}

class CitiesRepository extends ServerRepository<City> {
  CitiesRepository._() : super(() => City());
  static final _instance = CitiesRepository._();
  factory CitiesRepository() => _instance;

  @override
  String get tableName => 'Cities';

  Future<City?> createCity({
    required String creatorTextId,
    required String stateTextId,
    required String nameEnglish,
    required String nameNative,
  }) async {
    var state = await CountryStatesRepository().getItemByTextId(stateTextId);
    if (state == null) return null;

    var item = await createNewInstance();
    item.nameEnglish.value = nameEnglish;
    item.nameNative.value = nameNative;
    item.stateTextId.value = state.textId.value;
    item.provinceTextId.value = state.provinceTextId.value;
    item.countryTextId.value = state.countryTextId.value;
    item.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<City?> editCity({
    required String cityTextId,
    String? stateTextId,
    String? nameEnglish,
    String? nameNative,
  }) async {
    var item = await getItemByTextId(cityTextId);
    if (item == null) return null;

    if (stateTextId != null) {
      var state = await CountryStatesRepository().getItemByTextId(stateTextId);
      if (state == null) return null;
      item.stateTextId.value = state.textId.value;
      item.provinceTextId.value = state.provinceTextId.value;
      item.countryTextId.value = state.countryTextId.value;
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
