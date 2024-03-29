import '../imports.dart';

void setServerJsonEncoder() {
  // Set the default json encoder function
  serverDefaultJsonEncoder = (Object? obj) {
    if (obj is ServerStatusCode) return obj.code;
    if (obj is DateTime) return obj.toString();
    if (obj is FieldWithValue) return obj.value;
    if (obj is DbModel) return obj.toJsonMap();
    if (obj is Map) {
      return <String, dynamic>{for (var k in obj.keys) k.toString(): obj[k]};
    }
    if (obj is DateTime) return obj.toString();
    if (obj is FieldWithValue) return obj.value;
    if (obj is DbModel) return obj.toJsonMap();

    return obj;
  };
}

dynamic decodeJsonWithoutException(String source) {
  try {
    return jsonDecode(source);
  } catch (e) {
    return null;
  }
}
