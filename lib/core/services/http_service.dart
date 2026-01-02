import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/constants/dhis2_connection.dart';

class HttpService {
  final String? username;
  final String? password;
  String? basicAuth;

  HttpService({required this.username, required this.password}) {
    basicAuth = base64Encode(utf8.encode('$username:$password'));
  }

  Uri getApiUrl(String url, {Map<String, dynamic>? queryParameters}) {
    return Dhis2Connection.baseUrl.isEmpty
        ? Uri.https(Dhis2Connection.baseUrl, url, queryParameters)
        : Uri.https(
            Dhis2Connection.baseUrl,
            "${Dhis2Connection.subBaseUrl}/$url",
            queryParameters,
          );
  }

  Future<http.Response> httpPost(
    String url,
    body, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    return http.post(
      apiUrl,
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $basicAuth',
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }

  Future<http.Response> httpPut(
    String url,
    body, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    return http.put(
      apiUrl,
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $basicAuth',
        'Content-Type': 'application/json',
      },
      body: body,
    );
  }

  Future<http.Response> httpDelete(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    return await http.delete(
      apiUrl,
      headers: {HttpHeaders.authorizationHeader: 'Basic $basicAuth'},
    );
  }

  Future<http.Response> httpGet(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    apiUrl = sanitizeUrl(apiUrl);
    return await http.get(
      apiUrl,
      headers: {HttpHeaders.authorizationHeader: 'Basic $basicAuth'},
    );
  }

  Uri sanitizeUrl(Uri url) {
    String urlToParse = Uri.decodeFull(url.toString());
    return Uri.parse(urlToParse);
  }

  Future<http.Response> httpGetPagination(
    String url,
    Map<String, dynamic> queryParameters,
  ) async {
    Map<String, String?> dataQueryParameters = {
      'totalPages': 'true',
      'pageSize': '1',
      'fields': 'none',
    };
    if (queryParameters.keys.isNotEmpty) {
      dataQueryParameters.addAll(queryParameters as Map<String, String?>);
    }
    return await httpGet(url, queryParameters: dataQueryParameters);
  }

  @override
  String toString() {
    return '${Dhis2Connection.baseUrl} => $username : $password';
  }
}
