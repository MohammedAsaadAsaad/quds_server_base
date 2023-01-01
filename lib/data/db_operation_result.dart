import 'package:quds_server_base/imports.dart';

class DbOperationResult<T> {
  final T? result;
  final EntryChangeType operationType;
  final String? message;
  final bool isSuccess;

  const DbOperationResult(
      {required this.operationType,
      this.result,
      this.message,
      required this.isSuccess});
}
