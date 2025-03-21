import 'package:bip39/bip39.dart';
import 'package:http/http.dart' as http;
import 'package:registrar_client/src/utils.dart';
import 'package:signer/signer.dart';
import 'dart:convert';

import 'nodes.dart';
import 'zos.dart';
import 'farms.dart';
import 'accounts.dart';

class RegistrarClient {
  final String baseUrl;
  final String mnemonicOrSeed;
  final KPType keypairType;

  late final Zos zos;
  late final Nodes nodes;
  late final Farms farms;
  late Accounts accounts;

  RegistrarClient({
    required String baseUrl,
    required String mnemonicOrSeed,
    this.keypairType = KPType.sr25519,
  })  : baseUrl = _validateBaseUrl(baseUrl),
        mnemonicOrSeed = _validateSecret(mnemonicOrSeed) {
    zos = Zos(this);
    nodes = Nodes(this);
    farms = Farms(this);
    accounts = Accounts(this);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 400) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Request failed with status: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<dynamic> post(
      {required String path,
      required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> get(
      {required String path,
      Map<String, dynamic>? query,
      Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse(_buildUrl(this.baseUrl, path, query ?? {})),
      headers: headers,
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
      {required String path,
      required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> patch(
      {required String path,
      required Map<String, dynamic> body,
      Map<String, String>? headers}) async {
    final response = await http.patch(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static String _buildUrl(String url, String path, Map<String, dynamic> query) {
    final uri = Uri.parse('$url$path');
    final updatedUri = uri.replace(
      queryParameters:
          query.map((key, value) => MapEntry(key, value?.toString()))
            ..removeWhere((key, value) => value == null),
    );
    return updatedUri.toString();
  }

  static String _validateBaseUrl(String baseUrl) {
    if (baseUrl.isEmpty || !Uri.tryParse(baseUrl)!.isAbsolute) {
      throw ArgumentError('Base URL must be a valid URL');
    }
    return baseUrl;
  }

  static String _validateSecret(String mnemonicOrSeed) {
    if (mnemonicOrSeed.isEmpty) {
      throw ArgumentError("Mnemonic or secret should be provided");
    } else if (!validateMnemonic(mnemonicOrSeed)) {
      if (mnemonicOrSeed.contains(" ")) {
        throw FormatException("Invalid mnemonic! Must be bip39 compliant");
      }
      if (!mnemonicOrSeed.startsWith("0x")) {
        mnemonicOrSeed = '0x$mnemonicOrSeed';
      }

      if (!isValidSeed(mnemonicOrSeed)) {
        throw FormatException("Invalid secret seed");
      }
    }
    return mnemonicOrSeed;
  }
}
