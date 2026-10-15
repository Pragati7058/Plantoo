import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'http://192.168.1.47:5000/api';
  
  static String? _token;

  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> getToken() async {
    if (_token != null) {
      print('ApiClient: Using cached token');
      return _token;
    }
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    print('ApiClient: Retrieved token from storage: ${_token != null ? "exists" : "null"}');
    return _token;
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  static Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    
    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
        print('ApiClient: Authorization header added');
      } else {
        print('ApiClient: No token available for authenticated request');
      }
    }
    
    return headers;
  }

  static Future<http.Response> get(
    String endpoint, {
    bool includeAuth = true,
    Map<String, String>? queryParams,
  }) async {
    var uri = Uri.parse('$baseUrl$endpoint');
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams);
    }

    final response = await http.get(
      uri,
      headers: await _getHeaders(includeAuth: includeAuth),
    );

    return response;
  }

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(includeAuth: includeAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool includeAuth = true,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(includeAuth: includeAuth),
      body: body != null ? jsonEncode(body) : null,
    );

    return response;
  }

  static Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _getHeaders(includeAuth: includeAuth),
    );

    return response;
  }
}
