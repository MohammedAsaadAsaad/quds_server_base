import 'package:quds_server_base/imports.dart';

class UserHunterMiddleware extends QudsMiddleware {
  UserHunterMiddleware()
      : super(middleware: createMiddleware(requestHandler: (request) async {
          var user = await request.currentUserBase;
          if (user != null) {
            await UserLastSeenRepository().setUserLastSeen(user.id.value!);
          }
        }));
}
