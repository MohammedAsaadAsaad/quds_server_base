import 'package:quds_server_base/data/data.dart';

Future<void> initializePermissions() async {
  await UsersRolesRepository().checkInitialRoles();
  await PermissionsRepository().checkInitialPermissions();
  await PermissionsGroupsRepository().checkPermissionsGroups();
}
