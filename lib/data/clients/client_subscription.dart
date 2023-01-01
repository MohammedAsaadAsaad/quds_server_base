import 'package:quds_server_base/imports.dart';

class ClientSubscription extends DbModel {
  final clientId = IntField(columnName: 'client_id');
  final subscriptionDateTime =
      DateTimeField(columnName: 'subscription_datetime');
  final subcriptionEndDateTime =
      DateTimeField(columnName: 'subscription_end_datetime');

  @override
  List<FieldWithValue>? getFields() =>
      [clientId, subscriptionDateTime, subcriptionEndDateTime];
}
