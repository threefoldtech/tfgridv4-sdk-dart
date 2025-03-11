# Registrar Client

This package provides a client for interacting with the TFGrid v4 Node Registrar.

## Install Dependencies

```bash
dart pub get
```

## Usage

- Example usage:

```dart
import 'package:registrar_client/registrar_client.dart';

void main() async{

     final client = RegistrarClient(
        baseUrl: 'https://registrar.dev4.grid.tf/v1',
        mnemonicOrSeed: 'your mnemonic or hex seed');

    final account = await client.account.create(relays: ['relay1', 'relay2'] , rmbEncKey: 'rmb_enc_key');

    final farmIDCreated = await client.farms
          .create(Farm(dedicated: true, farmName: 'farm', twinID: account.twinID));
}
```
