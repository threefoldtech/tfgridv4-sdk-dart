import 'dart:convert';

import 'package:pinenacl/ed25519.dart';
import 'package:test/test.dart';
import 'package:registrar_client/registrar_client.dart';

void main() {
  group('Test Farm', () {
    int farmID = 0;
    int twinID = 0;
    final client = RegistrarClient(
        baseUrl: 'http://registrar/v1',
        privateKey: base64Encode(SigningKey.generate().seed));
    test('Create Farm', () async {
      final account = await client.accounts.create();
      twinID = account.twinID;
      final farmName = '${DateTime.now()} - farm';
      final farmIDCreated = await client.farms
          .create(Farm(dedicated: true, farmName: farmName, twinID: twinID));
      expect(farmID, isNotNull);
      expect(farmID, isA<int>());
      farmID = farmIDCreated;
    });

    test('Get Farm', () async {
      final farm = await client.farms.get(farmID);
      expect(farm, isNotNull);
      expect(farm.farmID, farmID);
    });

    test('List Farm with twinID', () async {
      final filter = FarmFilter(twinID: twinID);
      final farms = await client.farms.list(filter);
      expect(farms, isNotNull);
      expect(farms, isA<List<Farm>>());
    });

    test('List Farm with size', () async {
      final filter = FarmFilter(size: 20);
      final farms = await client.farms.list(filter);
      expect(farms, isNotNull);
      expect(farms, isA<List<Farm>>());
      expect(farms.length, lessThanOrEqualTo(20));
    });

    test('Update Farm', () async {
      final farmName = '${DateTime.now()} - farm';
      final response = await client.farms.update(twinID, farmID, farmName);
      expect(response, isNotNull);

      final farm = await client.farms.get(farmID);
      expect(farm, isNotNull);
      expect(farm.farmName, farmName);
    });
  });
}
