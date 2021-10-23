import 'package:edebt_server/imports.dart';

class LocationsController extends QudsController {
  Future<Response> getCountry(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'id': Required().isString()});

    if (validationResponse != null) return validationResponse;

    var country = await CountriesRepository().getItemByTextId(body['id']);

    if (country == null) return responseApiNotFound();

    return responseApiOk(data: {'country': country.asJsonMap});
  }

  Future<Response> getProvince(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'id': Required().isString()});

    if (validationResponse != null) return validationResponse;

    var province = await ProvincesRepository().getItemByTextId(body['id']);

    if (province == null) return responseApiNotFound();

    return responseApiOk(data: {'province': province.asJsonMap});
  }

  Future<Response> getState(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'id': Required().isString()});

    if (validationResponse != null) return validationResponse;

    var item = await CountryStatesRepository().getItemByTextId(body['id']);

    if (item == null) return responseApiNotFound();

    return responseApiOk(data: {'state': item.asJsonMap});
  }

  Future<Response> getCity(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'id': Required().isString()});

    if (validationResponse != null) return validationResponse;

    var item = await CitiesRepository().getItemByTextId(body['id']);

    if (item == null) return responseApiNotFound();

    return responseApiOk(data: {'city': item.asJsonMap});
  }

  Future<Response> getCityArea(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'id': Required().isString()});

    if (validationResponse != null) return validationResponse;

    var item = await CityAreasRepository().getItemByTextId(body['id']);

    if (item == null) return responseApiNotFound();

    return responseApiOk(data: {'city-area': item.asJsonMap});
  }

  Future<Response> getDistrict(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'id': Required().isString()});

    if (validationResponse != null) return validationResponse;

    var item = await DistrictsRepository().getItemByTextId(body['id']);

    if (item == null) return responseApiNotFound();

    return responseApiOk(data: {'district': item.asJsonMap});
  }

  Future<Response> getCountries(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(
        <String, ApiValidator>{'limit': IsInteger(), 'after': IsDateTime()});

    if (validationResponse != null) return validationResponse;

    var afterDate = body['after'];
    int? limit = body['limit'];
    var countries = await CountriesRepository().select(
        orderBy: (c) => [c.modificationTime.earlierOrder],
        limit: limit,
        where: (c) {
          var q = c.id.isNotNull;
          if (afterDate != null) {
            q &= c.modificationTime > afterDate;
          }
          return q;
        });

    return responseApiOk(data: {
      'countries': [for (var c in countries) c.asJsonMap]
    });
  }

  Future<Response> createCountry(Request req) async {
    //Just admins can do it.
    var user = await req.currentUserBase;
    if (user == null ||
        user.userType.value!.correspondingUserType != UserType.admin) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'name-english': Required().isString().min(3).max(32),
      'name-native': Required().isString().min(3).max(32),
      'code': Required().isString().min(1).max(16),
      'code-2': Required().isString().min(2).max(2).matchRegex(r'[\w]+'),
      'code-3': Required().isString().min(3).max(3).matchRegex(r'[\w]+'),
    });

    if (validationResponse != null) return validationResponse;

    var repo = CountriesRepository();
    var item = await repo.createCountry(
        creatorTextId: await user.textId,
        nameEnglish: body['name-english'],
        nameNative: body['name-native'],
        code: body['code'],
        code2: body['code-2'],
        code3: body['code-3']);

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateCountry(Request req) async {
    //Just admins can do it.
    var user = await req.currentUserBase;
    if (user == null ||
        user.userType.value!.correspondingUserType != UserType.admin) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'name-english': IsString().min(3).max(32),
      'name-native': IsString().min(3).max(32),
      'code': IsString().min(1).max(16),
      'code-2': IsString().min(2).max(2).matchRegex(r'[\w]+'),
      'code-3': IsString().min(3).max(3).matchRegex(r'[\w]+'),
    });

    if (validationResponse != null) return validationResponse;

    var repo = CountriesRepository();
    var item = await repo.editCountry(
        countryTextId: body['id'],
        nameEnglish: body['name-english'],
        nameNative: body['name-native'],
        code: body['code'],
        code2: body['code-2'],
        code3: body['code-3']);

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> getCountryProvinces(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'country-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await ProvincesRepository()
        .selectWhere((model) => model.countryTextId.equals(body['country-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getProvincesByIds(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse =
        body.validate(<String, ApiValidator>{'ids': Required()});

    if (validationResponse != null) return validationResponse;

    if (body['ids'] is! List<int>) return responseApiBadRequest();

    var items = await ProvincesRepository()
        .selectWhere((model) => model.id.inCollection(body['ids']));

    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getCountryStates(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'country-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await CountryStatesRepository()
        .selectWhere((model) => model.countryTextId.equals(body['country-id']));

    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getCountryCities(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'country-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await CitiesRepository()
        .selectWhere((model) => model.countryTextId.equals(body['country-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getCountryCityAreas(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'country-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await CityAreasRepository()
        .selectWhere((model) => model.countryTextId.equals(body['country-id']));

    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getCountryDistricts(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'country-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await DistrictsRepository()
        .selectWhere((model) => model.countryTextId.equals(body['country-id']));

    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> createProvince(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'country-id': Required().isString(),
      'name-english': Required().isString().min(3).max(32),
      'name-native': Required().isString().min(3).max(32),
    });

    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnCountry(
            countryId: body['country-id'],
            action: LocationPermission.createSubLocations,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = ProvincesRepository();
    var item = await repo.createProvince(
      countryTextId: body['country-id'],
      creatorTextId: await user.textId,
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateProvince(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'country-id': IsString(),
      'name-english': IsString().min(3).max(32),
      'name-native': IsString().min(3).max(32),
    });
    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnProvince(
            provinceId: body['id'],
            action: LocationPermission.editLocationDetails,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = ProvincesRepository();
    var item = await repo.editProvince(
      provinceTextId: body['id'],
      countryTextId: body['country-id'],
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> getProvinceStates(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'province-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await CountryStatesRepository().selectWhere(
        (model) => model.provinceTextId.equals(body['province-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getProvinceCities(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'province-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await CitiesRepository().selectWhere(
        (model) => model.provinceTextId.equals(body['province-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getProvinceCityAreas(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'province-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await CityAreasRepository().selectWhere(
        (model) => model.provinceTextId.equals(body['province-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getProvinceDistricts(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'province-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await DistrictsRepository().selectWhere(
        (model) => model.provinceTextId.equals(body['province-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> createState(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'province-id': Required().isString(),
      'name-english': Required().isString().min(3).max(32),
      'name-native': Required().isString().min(3).max(32),
    });

    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnProvince(
            provinceId: body['province-id'],
            action: LocationPermission.createSubLocations,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = CountryStatesRepository();
    var item = await repo.createState(
      provinceTextId: body['province-id'],
      creatorTextId: await user.textId,
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateState(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'province-id': IsString(),
      'name-english': IsString().min(3).max(32),
      'name-native': IsString().min(3).max(32),
    });
    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnState(
            stateId: body['id'],
            action: LocationPermission.editLocationDetails,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = CountryStatesRepository();
    var item = await repo.editState(
      stateTextId: body['id'],
      provinceTextId: body['province-id'],
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> getStateCities(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'state-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await CitiesRepository()
        .selectWhere((model) => model.stateTextId.equals(body['state-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getStateCityAreas(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'state-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await CityAreasRepository()
        .selectWhere((model) => model.stateTextId.equals(body['state-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getStateDistricts(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'state-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await DistrictsRepository()
        .selectWhere((model) => model.stateTextId.equals(body['state-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> createCity(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'state-id': Required().isString(),
      'name-english': Required().isString().min(3).max(32),
      'name-native': Required().isString().min(3).max(32),
    });

    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnState(
            stateId: body['state-id'],
            action: LocationPermission.createSubLocations,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = CitiesRepository();
    var item = await repo.createCity(
      stateTextId: body['state-id'],
      creatorTextId: await user.textId,
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateCity(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'state-id': IsString(),
      'name-english': IsString().min(3).max(32),
      'name-native': IsString().min(3).max(32),
    });
    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnCity(
            cityId: body['id'],
            action: LocationPermission.editLocationDetails,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = CitiesRepository();
    var item = await repo.editCity(
      stateTextId: body['state-id'],
      cityTextId: body['id'],
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> getCityAreas(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'city-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await CityAreasRepository()
        .selectWhere((model) => model.cityTextId.equals(body['city-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> getCityDistricts(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'city-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;
    var items = await DistrictsRepository()
        .selectWhere((model) => model.cityTextId.equals(body['city-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> createCityArea(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'city-id': Required().isString(),
      'name-english': Required().isString().min(3).max(32),
      'name-native': Required().isString().min(3).max(32),
    });

    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnCity(
            cityId: body['city-id'],
            action: LocationPermission.createSubLocations,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = CityAreasRepository();
    var item = await repo.createCityArea(
      cityTextId: body['city-id'],
      creatorTextId: await user.textId,
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateCityArea(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'city-id': IsString(),
      'name-english': IsString().min(3).max(32),
      'name-native': IsString().min(3).max(32),
    });
    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnCityArea(
            areaId: body['id'],
            action: LocationPermission.editLocationDetails,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = CityAreasRepository();
    var item = await repo.editCityArea(
      cityAreaTextId: body['id'],
      cityTextId: body['city-id'],
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> getCityAreaDistricts(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden();
    }

    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'city-area-id': Required().isString(),
    });

    if (validationResponse != null) return validationResponse;

    var items = await DistrictsRepository().selectWhere(
        (model) => model.cityAreaTextId.equals(body['city-area-id']));
    return responseApiOk(data: {
      'items': [for (var i in items) i.asJsonMap]
    });
  }

  Future<Response> createDistrict(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'city-area-id': Required().isString(),
      'name-english': Required().isString().min(3).max(32),
      'name-native': Required().isString().min(3).max(32),
    });

    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnCityArea(
            areaId: body['city-area-id'],
            action: LocationPermission.createSubLocations,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = DistrictsRepository();
    var item = await repo.createDistrict(
      areaTextId: body['city-area-id'],
      creatorTextId: await user.textId,
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }

  Future<Response> updateDistrict(Request req) async {
    var body = await req.bodyAsJson;
    var validationResponse = body.validate(<String, ApiValidator>{
      'id': Required().isString(),
      'city-area-id': IsString(),
      'name-english': IsString().min(3).max(32),
      'name-native': IsString().min(3).max(32),
    });
    if (validationResponse != null) return validationResponse;

    var user = await req.currentUserBase;
    if (user == null ||
        !await LocationPermissionsRepository().canDoActionOnDistrict(
            districtId: body['id'],
            action: LocationPermission.editLocationDetails,
            userId: await user.textId,
            userType: user.userType.value!.correspondingUserType)) {
      return responseApiForbidden();
    }

    var repo = DistrictsRepository();
    var item = await repo.editDistrict(
      cityAreaTextId: body['city-area-id'],
      districtTextId: body['id'],
      nameEnglish: body['name-english'],
      nameNative: body['name-native'],
    );

    if (item == null) return responseApiInternalServerError();
    return responseApiOk(data: {'item': item.asJsonMap});
  }
}
