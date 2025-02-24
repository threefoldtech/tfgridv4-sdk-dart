import 'client.dart';

class Zos {
  final RegistrarClient _client;
  final String path = '/zos';

  Zos(this._client);

  Future<String> getZosVersion() async {
    final response = await _client.get(path: '$path/version');
    return response;
  }
}
