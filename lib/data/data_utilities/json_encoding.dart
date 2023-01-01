import '../../imports.dart';

extension JsonEncoding on DbModel {
  Map<String, dynamic> toJsonMap({List<FieldWithValue>? ignores}) {
    var ignoresList = ignores == null
        ? []
        : ignores.map<String>((e) => e.columnName ?? '').toSet().toList();
    return {
      for (var f in getAllFields())
        if (f != null &&
            f.columnName != null &&
            !ignoresList.contains(f.columnName))
          f.columnName!: encodeToJson(f.value)
    };
  }

  Map<String, dynamic> get asJsonMap {
    return {
      for (var g in getAllFields())
        if (g != id) g!.columnName!: encodeToJson(g.value)
    };
  }
}

dynamic encodeToJson(dynamic value) {
  if (value is DateTime) return value.toString();
  return value;
}
