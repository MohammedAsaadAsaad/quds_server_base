import '../../../imports.dart';

class UsersController extends QudsController {
  Future<Response> login(Request req) async {
    final userInfo = await req.bodyAsJson;

    var validationResponse = userInfo.validate({
      'email': Required().min(6).max(64),
      'password': Required().min(8).max(64).matchRegex('[\\d]+')
    });

    if (validationResponse != null) return validationResponse;

    var email = userInfo['email'];
    var password = userInfo['password'];

    email = email.trim();
    var usersRepository = UserBasesRepository();
    final user = await usersRepository.getUserByEmail(email);
    if (user == null) {
      return responseApiBadRequest(message: 'Incorrect login details');
    }

    final salt = user.salt.value!;
    final hashedPassword = hashPassword(password, salt);

    if (hashedPassword != user.password.value) {
      return responseApiBadRequest(message: 'Incorrect login details');
    }

    var details = await UsersDetailsRepository()
        .selectFirstWhere((model) => model.baseId.equals(user.id.value));
//Generate JWT and send with response
    try {
      final tokenPair = await server.tokenService!.createTokenPair(
          user.id.value!.toString(), server.tokenService!.configurations);
      return responseApiOk(
          message: 'Login successful!',
          data: tokenPair.toJson()
            ..addAll({'user_id': user.id.value})
            ..addAll({'user_details': details!.asJsonMap}));
    } catch (e) {
      return responseApiInternalServerError(
          message: 'There was a problem logging you in. Please try again!');
    }
  }

  Future<Response> register(Request request) async {
    var body = await request.bodyAsJson;

    var validationResponse = body.validate({
      'email': Required().isEmail(),
      'password': Required().isString().min(8).max(64),
      'firstname': Required().isString().min(2).max(64),
      'familyname': Required().isString().min(2).max(64),
      'mobile': Required(),
    });

    if (validationResponse != null) return validationResponse;

    var email = body['email'];
    var password = body['password'];
    email = email.trim();

    var usersRepository = UserBasesRepository();
    var user = await usersRepository.getUserByEmail(email);

    if (user != null) {
      return responseApiBadRequest(message: 'User is already exists!');
    }

    final salt = generateSalt();
    final hashedPassword = hashPassword(password, salt);

    user = UserBase()
      ..email.value = email
      ..password.value = hashedPassword
      ..salt.value = salt;
    await usersRepository.insertEntry(user);

    var detailsRepo = UsersDetailsRepository();
    // create user details
    var userDetails = (await detailsRepo.createNewInstance())
      ..baseId.value = user.id.value
      ..email.value = body['email']
      ..familyName.value = body['familyname']
      ..firstName.value = body['firstname']
      ..mobile.value = body['mobile'];
    // ..textId.value = await detailsRepo.getNewUserId();
    await detailsRepo.insertEntry(userDetails);

//Generate JWT and send with response
    try {
      final tokenPair = await server.tokenService!.createTokenPair(
          user.id.value!.toString(), server.tokenService!.configurations);
      return responseApiOk(message: 'User created successfully!', data: {
        'token': tokenPair.idToken,
        'refresh_token': tokenPair.refreshToken,
        'details': userDetails.asJsonMap
      });
    } catch (e) {
      return responseApiInternalServerError(
          message: 'There was a problem in register. Please try again!');
    }
  }

  Future<Response> logout(Request req) async {
    var auth = req.context['authDetails'];
    if (auth == null) {
      return responseApiForbidden(
          message: 'Not authorized to perform this operation');
    }

    try {
      await server.tokenService!.removeRefreshToken((auth as JWT).jwtId!);
    } catch (e) {
      return responseApiInternalServerError(
          message: 'There was an issue loggin out');
    }
    return responseApiOk(message: 'logged out successfully');
  }

  Future<Response> refreshToken(Request req) async {
    var tokenService = server.tokenService!;
    final payloadMap = await req.bodyAsJson;

    var validationResponse = payloadMap.validate({
      'refresh_token': Required().isString(),
    });
    if (validationResponse != null) return validationResponse;

    var token =
        verifyJwt(payloadMap['refresh_token'], server.configurations.secretKey);
    if (token == null) {
      return responseApiBadRequest(message: 'refresh token is not valid');
    }
    final dbToken = await tokenService.getRefreshToken((token as JWT).jwtId!);

    if (dbToken == null) {
      return responseApiBadRequest(message: 'refresh token is not valid');
    }

    //Generate new token pair
    final oldJwt = token;
    try {
      await tokenService.removeRefreshToken((token).jwtId!);

      final tokenPair = await tokenService.createTokenPair(
          oldJwt.subject!, server.tokenService!.configurations);
      return responseApiOk(
          data: tokenPair.toJson(),
          headers: {HttpHeaders.contentTypeHeader: ContentType.json.mimeType});
    } catch (e) {
      return responseApiInternalServerError(
          message:
              'There was a problem creating a new token. Please try again later');
    }
  }

  Future<Response> getUserDetails(Request req, dynamic userId) async {
    var caller = await req.currentUserBase;
    if (caller == null) {
      return responseApiForbidden(
          message:
              'You are not authorized to perform this operation, login first');
    }

    if (userId is String) userId = int.tryParse(userId);

    if (userId is! int) {
      return responseApiBadRequest(message: 'Invalid user id');
    }

    var user = await UserBasesRepository().loadEntryById(userId);
    if (user == null) return responseApiNotFound(message: 'User is not found');

    var details =
        (await UsersDetailsRepository().getUserDetailsByBaseId(userId))!;
    return responseApiOk(data: {
      'user_id': user.id.value,
      'details': details.asJsonMap..addAll({'userType': user.userType.value})
    });
  }

  Future<Response> changeMyPassword(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden(
          message: 'You are not authorized to perform this action');
    }

    var body = await req.bodyAsJson;

    var validationResponse = body.validate({
      'old_password': Required().isString(),
      'new_password': Required().isString().min(8).max(64),
    });
    if (validationResponse != null) return validationResponse;

    if (body['new_password'] == null) {
      return responseApiBadRequest(message: 'The new password is missing!');
    }
    var result = await UserBasesRepository().changeUserPassword(
        user.id.value!, body['old_password'], body['new_password']);

    if (result != null) return responseApiBadRequest(message: result);

    return responseApiOk(message: 'Password is changed successfully');
  }

  Future<Response> changeMyDetails(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden(
          message: 'You are not authorized to perform this action');
    }

    var body = await req.bodyAsJson;

    var validationResponse = body.validate({
      'firstname': Required().isString().min(2).max(64),
      'familyname': Required().isString().min(2).max(64),
      'mobile': Required(),
      'email': Required().isEmail(),
    });
    if (validationResponse != null) return validationResponse;

    var detailsRepo = UsersDetailsRepository();
    var userDetails = await detailsRepo.getUserDetailsByBaseId(user.id.value!);
    userDetails ??= UserDetails()
      ..baseId.value = user.id.value
      ..email.value = user.email.value;

    var firstName = body['firstname'];
    var familyName = body['familyname'];
    var mobile = body['familyname'];
    var email = body['email'];
    if (firstName != null) {
      userDetails.firstName.value = firstName;
    }
    if (familyName != null) {
      userDetails.familyName.value = familyName;
    }
    if (mobile != null) {
      userDetails.mobile.value = mobile;
    }

    if (email != null) {
      var usersRepo = UserBasesRepository();
      if (await usersRepo.isEmailReservedForAnother(user.id.value!, email)) {
        return responseApiBadRequest(
            message: 'The email is used by another user!');
      }
      user.email.value = email;
      userDetails.email.value = email;
      await usersRepo.updateEntry(user);
    }
    await detailsRepo.updateEntry(userDetails);

    return responseApiOk(data: {
      'details': userDetails.asJsonMap
        ..addAll({'userType': user.userType.value})
    });
  }

  Future<Response> getMyDetails(Request req) async {
    var user = await req.currentUserBase;
    if (user == null) {
      return responseApiForbidden(
          message: 'You are not authorized to perform this action');
    }

    var details = (await UsersDetailsRepository()
        .getUserDetailsByBaseId(user.id.value!))!;

    return responseApiOk(data: {
      'details': details.asJsonMap..addAll({'userType': user.userType.value})
    });
  }
}
