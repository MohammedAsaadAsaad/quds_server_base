import '../../imports.dart';

class StoreCategory extends DbModel {
  var nameEnglish = StringField(columnName: 'nameEnglish');
  var parentCategoryId = StringField(columnName: 'parentCategoryId');
  @override
  List<FieldWithValue>? getFields() => [nameEnglish, parentCategoryId];
}

class StoreCategoriesRepository extends DbRepository<StoreCategory> {
  StoreCategoriesRepository._() : super(() => StoreCategory());
  static final _instance = StoreCategoriesRepository._();
  factory StoreCategoriesRepository() => _instance;

  @override
  String get tableName => 'StoreCategories';
}
