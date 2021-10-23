import '../../imports.dart';

abstract class ServerRepository<T extends ServerModel> extends DbRepository<T> {
  final int? textIdSectionsCount;
  final int? textIdSectionLength;
  final T Function() instanceFactory;
  ServerRepository(this.instanceFactory,
      {this.textIdSectionLength, this.textIdSectionsCount})
      : super(instanceFactory);

  Future<String> getNewTextId() async {
    bool found = false;
    String newId;
    do {
      newId = SecureUtilities.generateTextId(
          textIdSectionsCount ?? 5, textIdSectionLength ?? 5);
      found = (await selectFirstWhere((model) => model.textId.equals(newId)) !=
          null);
    } while (found);

    return newId;
  }

  Future<T> createNewInstance() async =>
      instanceFactory()..textId.value = await getNewTextId();

  Future<T?> getItemByTextId(String textId) async =>
      await selectFirstWhere((model) => model.textId.equals(textId));
}
