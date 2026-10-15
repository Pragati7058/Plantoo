import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class AuthService {
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
        },
        includeAuth: false,
      );

      final data = _handleResponse(response);

      if (data['success'] == true && data['token'] != null) {
        await ApiClient.setToken(data['token']);
      }

      return data;
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('AuthService: Attempting login for $email');
      final response = await ApiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      final data = _handleResponse(response);
      print('AuthService: Login response - success: ${data['success']}, has token: ${data['token'] != null}');

      if (data['success'] == true && data['token'] != null) {
        await ApiClient.setToken(data['token']);
        print('AuthService: Token saved successfully');
      }

      return data;
    } catch (e) {
      print('AuthService: Login error - $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      print('AuthService: Fetching current user');
      final response = await ApiClient.get('/auth/me');
      print('AuthService: Get user response status: ${response.statusCode}');
      print('AuthService: Get user response body: ${response.body}');
      return _handleResponse(response);
    } catch (e) {
      print('AuthService: Get user error - $e');
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<void> logout() async {
    await ApiClient.clearToken();
  }

  static Future<bool> isAuthenticated() async {
    final token = await ApiClient.getToken();
    return token != null;
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw data['message'] ?? 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      if (e is FormatException) {
        throw 'Invalid response from server';
      }
      rethrow;
    }
  }
}
