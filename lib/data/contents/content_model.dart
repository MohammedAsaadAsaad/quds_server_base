import '../../imports.dart';

abstract class ContentModel extends DbModel {
  var content = JsonField(columnName: 'content');
  var title = StringField(columnName: 'title');
  @override
  List<FieldWithValue?> getAllFields() =>
      [title, content, ...super.getAllFields()];
}
