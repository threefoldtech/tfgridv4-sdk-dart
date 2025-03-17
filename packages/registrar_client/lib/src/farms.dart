import 'package:registrar_client/models/farm.dart';
import 'utils.dart';

import 'client.dart';

class Farms {
  final RegistrarClient _client;
  final String path = '/farms';

  Farms(this._client);

  Future<int> create(
      String farmName, bool dedicated, String stellarAddress) async {
    final twinId = _client.twinId!;
    final header = await createAuthHeader(
        twinId, _client.mnemonicOrSeed, _client.keypairType);
    final farm = Farm(
        dedicated: dedicated,
        farmName: farmName,
        stellarAddress: stellarAddress,
        twinID: twinId);
    final response = await _client.post(
        path: '$path/', body: farm.toJson(), headers: header);
    return response['farm_id'];
  }

  Future<Farm> get(int farmID) async {
    final response = await _client.get(path: '$path/$farmID');
    return Farm.fromJson(response);
  }

  Future<List<Farm>> list(FarmFilter filter) async {
    final response = await _client.get(path: '$path/', query: filter.toJson());
    return List<Farm>.from(response.map((farm) => Farm.fromJson(farm)));
  }

  Future<dynamic> update(int farmID,
      {String? farmName, String? stellarAddress}) async {
    if (farmName == null && stellarAddress == null) {
      return;
    }

    final twinId = _client.twinId!;
    final header = await createAuthHeader(
        twinId, _client.mnemonicOrSeed, _client.keypairType);
    final body = {
      if (farmName != null) 'farm_name': farmName,
      if (stellarAddress != null) 'stellar_address': stellarAddress
    };
    final response =
        await _client.patch(path: '$path/$farmID', body: body, headers: header);
    return response;
  }
}
