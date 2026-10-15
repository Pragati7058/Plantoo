import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class NotificationService {
  static Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await ApiClient.get(
        '/notifications',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> markAsRead(String id) async {
    try {
      final response = await ApiClient.put(
        '/notifications/$id',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> markAllAsRead() async {
    try {
      final response = await ApiClient.put(
        '/notifications/read-all',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteNotification(String id) async {
    try {
      final response = await ApiClient.delete(
        '/notifications/$id',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> clearNotifications() async {
    try {
      final response = await ApiClient.delete(
        '/notifications',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createNotification({
    required String userId,
    required String title,
    required String message,
    String type = 'general',
  }) async {
    try {
      final response = await ApiClient.post(
        '/notifications',
        body: {
          'userId': userId,
          'title': title,
          'message': message,
          'type': type,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw data['message'] ?? 'An error occurred';
    }
  }
}