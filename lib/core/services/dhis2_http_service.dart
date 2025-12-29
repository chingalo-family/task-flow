import 'dart:convert';

import 'package:http/http.dart' as http;

class Dhis2HttpService {
  final String username;
  final String password;
  final Uri baseUri;

  Dhis2HttpService({
    required this.username,
    required this.password,
    required this.baseUri,
  });

  Map<String, String> _authHeaders() {
    final creds = base64.encode(utf8.encode('$username:$password'));
    return {
      'Authorization': 'Basic $creds',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  Future<http.Response> httpGet(String path) async {
    final uri = baseUri.resolve(path);
    return http.get(uri, headers: _authHeaders());
  }

  Future<http.Response> httpPost(String path, {Object? body}) async {
    final uri = baseUri.resolve(path);
    return http.post(
      uri,
      headers: _authHeaders(),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> httpPut(String path, {Object? body}) async {
    final uri = baseUri.resolve(path);
    return http.put(
      uri,
      headers: _authHeaders(),
      body: body == null ? null : jsonEncode(body),
    );
  }
}
