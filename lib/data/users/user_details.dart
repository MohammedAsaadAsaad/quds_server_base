import 'package:edebt_server/imports.dart';

class UserDetails extends ServerModel {
  var firstName = StringField(columnName: 'firstName');
  var familyName = StringField(columnName: 'familyName');
  var email = StringField(columnName: 'email');
  var mobile = StringField(columnName: 'mobile');
  var baseId = IntField(columnName: 'baseId');
  @override
  List<FieldWithValue>? getFields() =>
      [firstName, familyName, email, mobile, baseId];
}
