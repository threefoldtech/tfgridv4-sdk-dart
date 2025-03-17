import 'package:registrar_client/models/node.dart';

import 'client.dart';
import 'utils.dart';

class Nodes {
  final RegistrarClient _client;
  final String path = '/nodes';

  Nodes(this._client);

  Future<int> create(NodeRegistrationRequest node) async {
    node.twinID = _client.twinId!;
    final header = await createAuthHeader(
        node.twinID, _client.mnemonicOrSeed, _client.keypairType);
    final response = await _client.post(
        path: '$path/', body: node.toJson(), headers: header);
    return response['node_id'];
  }

  Future<Node> get(int nodeID) async {
    final response = await _client.get(path: '$path/$nodeID');
    return Node.fromJson(response);
  }

  Future<List<Node>> list(NodeFilter filter) async {
    final response = await _client.get(path: path, query: filter.toJson());
    return List<Node>.from(response.map((node) => Node.fromJson(node)));
  }

  Future<dynamic> update(int nodeID, UpdateNodeRequest node) async {
    final twinId = _client.twinId!;
    final header = await createAuthHeader(
        twinId, _client.mnemonicOrSeed, _client.keypairType);
    final response = await _client.patch(
        path: '$path/$nodeID', body: node.toJson(), headers: header);
    return response;
  }

  Future<dynamic> reportNodeUptime(int nodeID, ReportUptimeRequest uptime) async {
    final twinId = _client.twinId!;
    final header = await createAuthHeader(
        twinId, _client.mnemonicOrSeed, _client.keypairType);
    final response = await _client.post(
        path: '$path/$nodeID/uptime', body: uptime.toJson(), headers: header);
    return response;
  }
}
