import 'package:edebt_server/imports.dart';

class UserHunterMiddleware extends QudsMiddleware {
  UserHunterMiddleware()
      : super(middleware: createMiddleware(requestHandler: (request) async {
          var user = await request.currentUserBase;
          if (user != null) {
            await UserLastSeenRepository().setUserLastSeen(user.id.value!);
          }
        }));
}
