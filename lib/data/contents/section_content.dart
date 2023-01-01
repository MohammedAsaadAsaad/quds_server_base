import '../../imports.dart';

abstract class SectionContent extends ContentModel {
  Future<bool> userHasPermission(UserBase user, String permission);
}
