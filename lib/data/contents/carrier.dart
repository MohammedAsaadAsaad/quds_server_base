import '../../imports.dart';

class Carrier extends ContentModel {
  @override
  List<FieldWithValue>? getFields() => [];
}

class CarriersRepository extends DbRepository<Carrier> {
  CarriersRepository._() : super(() => Carrier());
  static final CarriersRepository _instance = CarriersRepository._();
  static CarriersRepository instance = _instance;
  factory CarriersRepository() => _instance;

  @override
  String get tableName => 'carriers';
}
