import 'package:edebt_server/imports.dart';

class Country extends ServerModel {
  ///Country name in English language
  ///
  /// Palestine: Palestine
  var nameEnglish = StringField(columnName: 'nameEnglish');

  ///Country name in the country native language
  ///
  /// Palestine: فلسطين
  var nameNative = StringField(columnName: 'nameNative');

  ///Country ISO 2 letters code
  ///
  /// Palestine: PS
  var codeISO2 = StringField(columnName: 'codeISO2');

  ///Country ISO 3 letters code
  ///
  /// Palestine: PSE
  var codeISO3 = StringField(columnName: 'codeISO3');

  /// Country code (Dialing code)
  ///
  /// Palestine: 970
  ///
  /// American Samoa: 1-684
  ///
  /// Dominican Republic: 1-809, 1-829, 1-849
  ///
  var code = StringField(columnName: 'code');
  var creatorTextId = StringField(columnName: 'creatorTextId', notNull: true);
  @override
  List<FieldWithValue>? getFields() =>
      [nameEnglish, nameNative, code, codeISO2, codeISO3, creatorTextId];
}

class CountriesRepository extends ServerRepository<Country> {
  CountriesRepository._() : super(() => Country());
  static final _instance = CountriesRepository._();
  factory CountriesRepository() => _instance;

  Future<Country?> createCountry(
      {required String creatorTextId,
      required String nameEnglish,
      required String nameNative,
      required String code,
      required String code2,
      required String code3}) async {
    var country = await createNewInstance();
    country.nameEnglish.value = nameEnglish;
    country.nameNative.value = nameNative;
    country.code.value = code;
    country.codeISO2.value = code2;
    country.codeISO3.value = code3;
    country.creatorTextId.value = creatorTextId;

    try {
      await insertEntry(country);
      return country;
    } catch (e) {
      return null;
    }
  }

  Future<Country?> editCountry(
      {required String countryTextId,
      String? nameEnglish,
      String? nameNative,
      String? code,
      String? code2,
      String? code3}) async {
    var country = await getItemByTextId(countryTextId);

    if (country == null) return null;

    if (nameEnglish != null) country.nameEnglish.value = nameEnglish;

    if (nameNative != null) country.nameNative.value = nameNative;

    if (code != null) country.code.value = code;

    if (code2 != null) country.codeISO2.value = code2;

    if (code3 != null) country.codeISO3.value = code3;

    try {
      await updateEntry(country);
      return country;
    } catch (e) {
      return null;
    }
  }

  @override
  String get tableName => 'Countries';
}
