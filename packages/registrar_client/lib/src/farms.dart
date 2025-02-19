import 'package:registrar_client/models/farm.dart';
import 'utils.dart';

import 'client.dart';

class Farms {
  final RegistrarClient _client;
  final String path = '/farms';

  Farms(this._client);

  Future<int> create(int twinID, Farm farm) async {
    final header = createAuthHeader(farm.twinID, _client.privateKey);
    final response =
        await _client.post(path: path, body: farm.toJson(), headers: header);
    return response['farm_id'];
  }

  Future<Farm> get(int farmID) async {
    final response = await _client.get(path: '$path/$farmID');
    return Farm.fromJson(response);
  }

  Future<List<Farm>> list(FarmFilter filter) async {
    final response = await _client.get(path: path, query: filter.toJson());
    return List<Farm>.from(response.map((farm) => Farm.fromJson(farm)));
  }

  Future<dynamic> update(int twinID, int farmID, String farmName) async {
    final header = createAuthHeader(twinID, _client.privateKey);
    final response = await _client.patch(
        path: '$path/$farmID', body: {'farm_name': farmName}, headers: header);
    return response;
  }
}
