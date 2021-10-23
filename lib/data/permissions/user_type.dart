enum UserType { admin, normalUser }

Map _userTypes = <int, UserType>{1: UserType.admin, 2: UserType.normalUser};

extension UserTypeExtensionOnInt on int {
  UserType get correspondingUserType => _userTypes[this];
}
