import '../../imports.dart';

abstract class ContentModel extends DbModel {
  var content = JsonField(columnName: 'content');
  @override
  List<FieldWithValue?> getAllFields() => [content, ...super.getAllFields()];
}
