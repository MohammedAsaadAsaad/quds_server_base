import '../../imports.dart';

class WebController extends QudsController {
  Future<Response> home(Request request) async {
    return responseApiOk(message: 'Welcome to $appName');
  }
}
