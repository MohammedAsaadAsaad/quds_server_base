import 'package:edebt_server/imports.dart';

abstract class SecureUtilities {
  static String generateTextId(int sectionsCount, int sectionLength) {
    String result = '';
    for (int i = 0; i < sectionsCount; i++) {
      result += randomAlphaNumeric(sectionLength) +
          (i == sectionsCount - 1 ? '' : '-');
    }
    return result.toLowerCase();
  }
}
