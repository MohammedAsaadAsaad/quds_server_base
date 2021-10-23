import '../../../../imports.dart';

class LocationsRouter extends QudsRouter<LocationsController> {
  LocationsRouter() : super(controller: LocationsController());

  @override
  String get prefix => 'locations';

  @override
  List<QudsRouterHandler> get routes => [
        QudsRouterHandler(
            routePath: 'createCountry',
            method: RouteMethod.post,
            handler: controller!.createCountry),
        QudsRouterHandler(
            routePath: 'country',
            method: RouteMethod.post,
            handler: controller!.getCountry),
        QudsRouterHandler(
            routePath: 'countries',
            method: RouteMethod.post,
            handler: controller!.getCountries),
        QudsRouterHandler(
            routePath: 'updateCountry',
            method: RouteMethod.post,
            handler: controller!.updateCountry),
        QudsRouterHandler(
            routePath: 'getCountryProvinces',
            method: RouteMethod.post,
            handler: controller!.getCountryProvinces),
        QudsRouterHandler(
            routePath: 'getCountryStates',
            method: RouteMethod.post,
            handler: controller!.getCountryStates),
        QudsRouterHandler(
            routePath: 'getCountryCities',
            method: RouteMethod.post,
            handler: controller!.getCountryCities),
        QudsRouterHandler(
            routePath: 'getCountryCityAreas',
            method: RouteMethod.post,
            handler: controller!.getCountryCityAreas),
        QudsRouterHandler(
            routePath: 'getCountryDistricts',
            method: RouteMethod.post,
            handler: controller!.getCountryDistricts),
        QudsRouterHandler(
            routePath: 'createProvince',
            method: RouteMethod.post,
            handler: controller!.createProvince),
        QudsRouterHandler(
            routePath: 'updateProvince',
            method: RouteMethod.post,
            handler: controller!.updateProvince),
        QudsRouterHandler(
            routePath: 'province',
            method: RouteMethod.post,
            handler: controller!.getProvince),
        QudsRouterHandler(
            routePath: 'getProvincesByIds',
            method: RouteMethod.post,
            handler: controller!.getProvincesByIds),
        QudsRouterHandler(
            routePath: 'getProvinceStates',
            method: RouteMethod.post,
            handler: controller!.getProvinceStates),
        QudsRouterHandler(
            routePath: 'getProvinceCities',
            method: RouteMethod.post,
            handler: controller!.getProvinceCities),
        QudsRouterHandler(
            routePath: 'getProvinceCityAreas',
            method: RouteMethod.post,
            handler: controller!.getProvinceCityAreas),
        QudsRouterHandler(
            routePath: 'getProvinceDistricts',
            method: RouteMethod.post,
            handler: controller!.getProvinceDistricts),
        QudsRouterHandler(
            routePath: 'createState',
            method: RouteMethod.post,
            handler: controller!.createState),
        QudsRouterHandler(
            routePath: 'updateState',
            method: RouteMethod.post,
            handler: controller!.updateState),
        QudsRouterHandler(
            routePath: 'state',
            method: RouteMethod.post,
            handler: controller!.getState),
        QudsRouterHandler(
            routePath: 'getStateCities',
            method: RouteMethod.post,
            handler: controller!.getStateCities),
        QudsRouterHandler(
            routePath: 'getStateCityAreas',
            method: RouteMethod.post,
            handler: controller!.getStateCityAreas),
        QudsRouterHandler(
            routePath: 'getStateDistricts',
            method: RouteMethod.post,
            handler: controller!.getStateDistricts),
        QudsRouterHandler(
            routePath: 'createCity',
            method: RouteMethod.post,
            handler: controller!.createCity),
        QudsRouterHandler(
            routePath: 'updateCity',
            method: RouteMethod.post,
            handler: controller!.updateCity),
        QudsRouterHandler(
            routePath: 'city',
            method: RouteMethod.post,
            handler: controller!.getCity),
        QudsRouterHandler(
            routePath: 'getCityAreas',
            method: RouteMethod.post,
            handler: controller!.getCityAreas),
        QudsRouterHandler(
            routePath: 'getCityDistricts',
            method: RouteMethod.post,
            handler: controller!.getCityDistricts),
        QudsRouterHandler(
            routePath: 'createCityArea',
            method: RouteMethod.post,
            handler: controller!.createCityArea),
        QudsRouterHandler(
            routePath: 'updateCityArea',
            method: RouteMethod.post,
            handler: controller!.updateCityArea),
        QudsRouterHandler(
            routePath: 'cityArea',
            method: RouteMethod.post,
            handler: controller!.getCityArea),
        QudsRouterHandler(
            routePath: 'getCityAreaDistricts',
            method: RouteMethod.post,
            handler: controller!.getCityAreaDistricts),
        QudsRouterHandler(
            routePath: 'createDistrict',
            method: RouteMethod.post,
            handler: controller!.createDistrict),
        QudsRouterHandler(
            routePath: 'updateDistrict',
            method: RouteMethod.post,
            handler: controller!.updateDistrict),
        QudsRouterHandler(
            routePath: 'district',
            method: RouteMethod.post,
            handler: controller!.getDistrict),
      ];
}
