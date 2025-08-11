import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:mahshekels/main.dart';

import '../screens/login_screen.dart';

class JwtHttpClient {
  final BuildContext context;
  final FlutterSecureStorage _secureStorage;

  JwtHttpClient(this.context, this._secureStorage);

  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    final token = await _secureStorage.read(key: 'token');

    final authHeaders = {
      ...?headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.get(url, headers: authHeaders);
    _handle401(response);
    return response;
  }

  Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final token = await _secureStorage.read(key: 'token');
    final authHeaders = {
      ...?headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.post(url, headers: authHeaders, body: body);
    _handle401(response);
    return response;
  }

  Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final token = await _secureStorage.read(key: 'token');
    final authHeaders = {
      ...?headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final response = await http.put(url, headers: authHeaders, body: body);
    _handle401(response);
    return response;
  }

  void _handle401(http.Response response) {
    if (response.statusCode == 401) {
      _secureStorage.delete(key: 'token');
      navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
