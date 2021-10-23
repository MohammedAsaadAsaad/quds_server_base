import 'package:edebt_server/data/users/user_details.dart';
import 'package:edebt_server/imports.dart';

class UsersDetailsRepository extends ServerRepository<UserDetails> {
  UsersDetailsRepository._() : super(() => UserDetails());
  static final _internal = UsersDetailsRepository._();
  factory UsersDetailsRepository() => _internal;

  Future<UserDetails?> getUserDetailsByBaseId(int baseId) async {
    return await selectFirstWhere((model) => model.baseId.equals(baseId));
  }

  @override
  String get tableName => 'UsersDetails';

  Future<UserDetails?> getUserDetailsByUserBaseId(int userBaseId) async =>
      await selectFirstWhere((model) => model.baseId.equals(userBaseId));

  // Future<String> getNewUserId() async {
  //   String result = '';
  //   bool found = false;
  //   do {
  //     result = SecureUtilities.generateTextId(3, 5);
  //     found = await selectFirstWhere((model) => model.textId.equals(result)) !=
  //         null;
  //   } while (found);
  //   return result;
  // }
}
