import '../../imports.dart';

class TrainingScope extends SectionContent {
  @override
  List<FieldWithValue>? getFields() => [];

  static const String contentType = 'training_scope';

  @override
  Future<bool> userHasPermission(UserBase user, String permission) async =>
      await ContentPermissionsRepository.instance
          .hasPermissionOn(user, contentType, id.value!, permission);
}

class TrainingScopesRepository extends DbRepository<TrainingScope> {
  TrainingScopesRepository._() : super(() => TrainingScope());
  static final TrainingScopesRepository _instance =
      TrainingScopesRepository._();
  static TrainingScopesRepository instance = _instance;
  factory TrainingScopesRepository() => _instance;

  @override
  String get tableName => 'training_scopes';
}
