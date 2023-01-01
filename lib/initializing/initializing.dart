import '../imports.dart';

Future<void> initializeApp() async {
  setServerJsonEncoder();
  await initializePermissions();
}
