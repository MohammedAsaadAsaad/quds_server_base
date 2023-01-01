import 'package:quds_server_base/imports.dart';

class Client extends DbModel {
  final name = StringField(columnName: 'name');
  final code = StringField(columnName: 'code');
  final password = StringField(columnName: 'password');
  final usersServerHost = StringField(columnName: 'server_host');

  @override
  List<FieldWithValue>? getFields() => [name, code, password, usersServerHost];
}

class ClientsRepository extends DbRepository<Client> {
  ClientsRepository._() : super(() => Client());
  static final ClientsRepository _instance = ClientsRepository._();
  static ClientsRepository get instance => _instance;
  factory ClientsRepository() => instance;

  Future<Client?> getClientByCodeAndPassword(
      String code, String password) async {
    code = code.toLowerCase();
    return await selectFirst(
        where: (c) => c.code.equals(code) & c.password.equals(password));
  }

  Future<Client?> getClientByCode(
    String code,
  ) async {
    return Client()
      ..code.value = code
      ..usersServerHost.value = 'http://15.235.146.206:7777';

    //TODO
    code = code.toLowerCase();
    return await selectFirst(where: (c) => c.code.equals(code));
  }

  Future<Client?> addClient(String name, String code, String password,
      String serverHostAddress) async {
    code = code.toLowerCase();

    var client = Client()
      ..name.value = name
      ..code.value = code
      ..password.value = password;

    await insertEntry(client);
    return client;
  }

  @override
  String get tableName => 'clients';
}
