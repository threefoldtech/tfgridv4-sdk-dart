import 'package:bip39/bip39.dart';
import 'package:registrar_client/src/utils.dart';
import 'package:signer/signer.dart';
import 'package:test/test.dart';
import 'package:registrar_client/registrar_client.dart';

void main() {
  group('Test Account', () {
    int twinID = 0;

    final mnemonic = generateMnemonic();

    final client = RegistrarClient(
        baseUrl: 'http://registrar/v1', mnemonicOrSeed: mnemonic);

    test('Create Account', () async {
      final account = await client.accounts.create();

      expect(account, isNotNull);
      expect(account, isA<Account>());
      expect(account.twinID, isNotNull);

      twinID = account.twinID;
    });

    test('Get Account by TwinID', () async {
      final account = await client.accounts.getByTwinID(twinID);

      expect(account, isNotNull);
      expect(account.twinID, twinID);
    });

    test('Get Account by PublicKey', () async {
      final account = await client.accounts
          .getByPublicKey(await derivePublicKey(mnemonic, KPType.sr25519));
      expect(account, isNotNull);
      expect(account.twinID, twinID);
    });

    test('Update Account', () async {
      final body = AccountUpdateRequest(
        relays: ['relay1', 'relay2'],
        rmbEncKey: 'rmbEncKey',
      );

      final response = await client.accounts.update(twinID, body);
      expect(response, isNotNull);

      final account = await client.accounts.getByTwinID(twinID);
      expect(account, isNotNull);
      expect(account.relays, body.relays);
      expect(account.rmbEncKey, body.rmbEncKey);
    });
  });
}
