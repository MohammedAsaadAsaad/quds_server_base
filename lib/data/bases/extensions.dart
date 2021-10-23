import 'package:edebt_server/imports.dart';

extension DbExtensionMethods on DbModel {
  Map<String, dynamic> get asJsonMap {
    return {
      for (var g in getAllFields())
        if (g != id) g!.columnName!: valueToMapValue(g.value)
    };
  }
}

dynamic valueToMapValue(dynamic d) {
  if (d is DateTime) return d.toString();
  return d;
}
