import 'client.dart';
import '../models/account.dart';
import 'utils.dart';

class Accounts {
  final RegistrarClient _client;
  final String path = '/accounts';
  Accounts(this._client);

  Future<Account> create({List<String>? relays, String? rmbEncKey}) async {
    String publicKey =
        await derivePublicKey(_client.mnemonicOrSeed, _client.keypairType);
    final signer =
        await createSigner(_client.mnemonicOrSeed, _client.keypairType);
    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String signature =
        await createSignatureWithPublicKey(timestamp, publicKey, signer);
    final AccountCreationRequest body = AccountCreationRequest(
      publicKey: publicKey,
      signature: signature,
      timestamp: timestamp,
      relays: relays,
      rmbEncKey: rmbEncKey,
    );

    final response = await _client.post(path: '$path/', body: body.toJson());
    final account = Account.fromJson(response);
    _client.twinId = account.twinID;
    return account;
  }

  Future<Account> getByTwinID(int twinID) async {
    final response =
        await _client.get(path: '$path/', query: {'twin_id': twinID});
    return Account.fromJson(response);
  }

  Future<Account> getByPublicKey(String publicKey) async {
    final response =
        await _client.get(path: '$path/', query: {'public_key': publicKey});
    return Account.fromJson(response);
  }

  Future<dynamic> update(AccountUpdateRequest body) async {
    final twinId = _client.twinId!;
    final header = await createAuthHeader(
        twinId, _client.mnemonicOrSeed, _client.keypairType);
    final response = await _client.patch(
        path: '$path/$twinId', body: body.toJson(), headers: header);
    return response;
  }
}
