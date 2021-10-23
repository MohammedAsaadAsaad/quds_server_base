import '../../imports.dart';

// Be created by the owner of the store
class StoreBuyerFile extends DbModel {
  var storeId = IntField(columnName: 'storeId');
  var creatorId = IntField(columnName: 'creatorId');
  @override
  List<FieldWithValue>? getFields() => [storeId, creatorId];
}

class StoreBuyerFilesRepository extends DbRepository<StoreBuyerFile> {
  StoreBuyerFilesRepository._() : super(() => StoreBuyerFile());
  static final _instance = StoreBuyerFilesRepository._();
  factory StoreBuyerFilesRepository() => _instance;

  @override
  String get tableName => 'StoreBuyerFiles';
}
