import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '/services/constants.dart';

class APIHandler {
  static final client = LoggingHttpClient();

  static Future<http.Response> response({
    required RestAPI api,
    Map<String, String>? queryParams,
    Object? body,
    Map<String, String>? headers,
  }) async {
    final String token = await _getAuthToken();

    // Only add x-auth-token if Authorization header is not already provided
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      if (headers == null || !headers.containsKey('Authorization'))
        'x-auth-token': token,
    };

    final finalHeaders = {...defaultHeaders, ...?headers};

    final String url = '${Constants.uri}/api${api.url}';

    switch (api.method) {
      case RESTURIConstants.post:
        return await postRequest(url, body, finalHeaders);
      case RESTURIConstants.put:
        return await putRequest(url, body, finalHeaders);
      case RESTURIConstants.delete:
        return await deleteRequest(url, finalHeaders);
      default: // GET request
        return await getRequest(url, queryParams, finalHeaders);
    }
  }

  static Future<http.Response> getRequest(
      String url,
      Map<String, String>? queryParams,
      Map<String, String> header,
      ) async {
    return await client.get(
      Uri.parse(url).replace(queryParameters: queryParams),
      headers: header,
    );
  }

  static Future<http.Response> postRequest(
      String url,
      Object? body,
      Map<String, String> header,
      ) async {
    return await client.post(
      Uri.parse(url),
      headers: header,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> putRequest(
      String url,
      Object? body,
      Map<String, String> header,
      ) async {
    return await client.put(
      Uri.parse(url),
      headers: header,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> deleteRequest(
      String url,
      Map<String, String> header,
      ) async {
    return await client.delete(Uri.parse(url), headers: header);
  }

  // Helper method to retrieve the x-auth-token from SharedPreferences
  static Future<String> _getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('x-auth-token') ?? "";
  }
}

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    debugPrint('--- HTTP Request ---');
    debugPrint('URL: ${request.url}');
    debugPrint('Method: ${request.method}');
    debugPrint('Headers: ${request.headers}');
    debugPrint('Auth Used: ${request.headers['Authorization'] ?? request.headers['x-auth-token']}');

    if (request is http.Request && request.body.isNotEmpty) {
      debugPrint('Body: ${request.body}');
    }

    final response = await _inner.send(request);

    debugPrint('--- HTTP Response ---');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Headers: ${response.headers}');

    final responseBody = await response.stream.bytesToString();
    debugPrint('Body: $responseBody');

    return http.StreamedResponse(
      Stream.value(utf8.encode(responseBody)),
      response.statusCode,
      headers: response.headers,
      request: response.request,
    );
  }
}
