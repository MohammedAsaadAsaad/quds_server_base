import '../../imports.dart';

class Question extends ContentModel {
  var branchId = IntField(columnName: 'branchid');
  var subjectId = IntField(columnName: 'subjectid');
  var scopeId = IntField(columnName: 'scopeid');
  @override
  List<FieldWithValue>? getFields() => [branchId, subjectId, scopeId];
}

class QuestionsRepository extends DbRepository<Question> {
  QuestionsRepository._() : super(() => Question());
  static final QuestionsRepository _instance = QuestionsRepository._();
  static QuestionsRepository instance = _instance;
  factory QuestionsRepository() => _instance;

  @override
  String get tableName => 'questions';
}
