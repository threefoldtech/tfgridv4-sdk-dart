import 'package:http/http.dart' as http;
import 'dart:convert';

import 'nodes.dart';
import 'zos.dart';
import 'farms.dart';
import 'accounts.dart';

class RegistrarClient {
  final String baseUrl;
  final String privateKey;

  late final Zos zos;
  late final Nodes nodes;
  late final Farms farms;
  late final Accounts accounts;

  RegistrarClient({
    required this.baseUrl,
    required this.privateKey,
  }) {
    zos = Zos(this);
    nodes = Nodes(this);
    farms = Farms(this);
    accounts = Accounts(this);
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
      Uri.parse(_buildUrl(path, query ?? {})),
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

  String _buildUrl(String path, Map<String, dynamic> query) {
    final uri = Uri.parse('$baseUrl$path');
    final updatedUri = uri.replace(queryParameters: query);
    return updatedUri.toString();
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      final errorMessage = errorBody['error'] ??
          errorBody['message'] ??
          'Unknown error occurred';
      throw Exception(
        'Request failed with status: ${response.statusCode}, error: $errorMessage',
      );
    }
  }
}
