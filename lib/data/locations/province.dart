import 'package:edebt_server/imports.dart';

class Province extends ServerModel {
  var nameEnglish = StringField(columnName: 'nameEnglish');
  var nameNative = StringField(columnName: 'nameNative');
  var countryTextId = StringField(columnName: 'countryTextId');
  var creatorTextId = StringField(columnName: 'creatorTextId', notNull: true);
  @override
  List<FieldWithValue>? getFields() =>
      [nameEnglish, nameNative, countryTextId, creatorTextId];
}

class ProvincesRepository extends ServerRepository<Province> {
  ProvincesRepository._() : super(() => Province());
  static final _instance = ProvincesRepository._();
  factory ProvincesRepository() => _instance;

  @override
  String get tableName => 'Provinces';

  Future<Province?> createProvince({
    required String creatorTextId,
    required String countryTextId,
    required String nameEnglish,
    required String nameNative,
  }) async {
    var item = await createNewInstance();
    item.nameEnglish.value = nameEnglish;
    item.nameNative.value = nameNative;
    item.countryTextId.value = countryTextId;
    item.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<Province?> editProvince({
    required String provinceTextId,
    String? countryTextId,
    String? nameEnglish,
    String? nameNative,
  }) async {
    var item = await getItemByTextId(provinceTextId);

    if (item == null) return null;

    if (countryTextId != null) {
      var country = await CountriesRepository().getItemByTextId(countryTextId);
      if (country == null) return null;
      item.countryTextId.value = country.textId.value;
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
