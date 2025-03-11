import 'package:registrar_client/registrar_client.dart';

void main() async {
  final client = RegistrarClient(
      baseUrl: 'https://registrar.dev4.grid.tf/v1',
      mnemonicOrSeed: 'your mnemonic or hex seed');
  final account = await client.accounts.create();

  print(account);
}
