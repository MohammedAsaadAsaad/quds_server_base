import 'package:edebt_server/imports.dart';

abstract class ServerModel extends DbModel {
  var textId = StringField(columnName: 'textId', isUnique: true, notNull: true);
  @override
  List<FieldWithValue?> getAllFields() {
    return super.getAllFields()..addAll([textId]);
  }
}
