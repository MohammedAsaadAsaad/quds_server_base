import '../imports.dart';

class ErrorsLoggerMiddleware extends QudsMiddleware {
  ErrorsLoggerMiddleware()
      : super(middleware: createMiddleware(
          errorHandler: (object, StackTrace trace) async {
            //Maybe, you need to log errors
            return responseApiInternalServerError(
                message: 'Unkown error occured!',
                data: !server.configurations.isDebugMode
                    ? null
                    : {'object': '$object', 'stack_trace': trace.toString()});
          },
        ));
}
