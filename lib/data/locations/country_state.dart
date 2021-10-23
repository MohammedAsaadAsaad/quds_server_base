import '../../imports.dart';

class CountryState extends ServerModel {
  var nameEnglish = StringField(columnName: 'nameEnglish');
  var nameNative = StringField(columnName: 'nameNative');
  var countryTextId = StringField(columnName: 'countryTextId');
  var provinceTextId = StringField(columnName: 'provinceTextId');
  var creatorTextId = StringField(columnName: 'creatorTextId', notNull: true);
  @override
  List<FieldWithValue>? getFields() =>
      [nameEnglish, nameNative, countryTextId, provinceTextId, creatorTextId];
}

class CountryStatesRepository extends ServerRepository<CountryState> {
  CountryStatesRepository._() : super(() => CountryState());
  static final _instance = CountryStatesRepository._();
  factory CountryStatesRepository() => _instance;

  @override
  String get tableName => 'CountryStates';

  Future<CountryState?> createState({
    required String creatorTextId,
    required String provinceTextId,
    required String nameEnglish,
    required String nameNative,
  }) async {
    var province = await ProvincesRepository().getItemByTextId(provinceTextId);
    if (province == null) return null;

    var item = await createNewInstance();
    item.nameEnglish.value = nameEnglish;
    item.nameNative.value = nameNative;
    item.provinceTextId.value = provinceTextId;
    item.countryTextId.value = province.countryTextId.value;
    item.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(item);
      return item;
    } catch (e) {
      return null;
    }
  }

  Future<CountryState?> editState({
    required String stateTextId,
    String? provinceTextId,
    String? nameEnglish,
    String? nameNative,
  }) async {
    var item = await getItemByTextId(stateTextId);
    if (item == null) return null;

    if (provinceTextId != null) {
      var province =
          await ProvincesRepository().getItemByTextId(provinceTextId);
      if (province == null) return null;
      item.provinceTextId.value = province.textId.value;
      item.countryTextId.value = province.countryTextId.value;
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
