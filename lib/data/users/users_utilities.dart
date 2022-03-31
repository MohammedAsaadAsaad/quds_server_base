import '../../imports.dart';

abstract class UserUtilities {
  static Future<String> generateToken(String salt) async {
    String newToken = randomString(32);
    var isFound = await UserLoginDetailsRepository()
        .selectFirstWhere((model) => model.token.equals(newToken));

    if (isFound != null) return await generateToken(salt);
    return newToken;
  }

  static Future<String> generateRefreshToken(String salt) async {
    String newToken = randomString(32);
    var isFound = await UserLoginDetailsRepository()
        .selectFirstWhere((model) => model.refreshToken.equals(newToken));

    if (isFound != null) return await generateToken(salt);
    return newToken;
  }
}
