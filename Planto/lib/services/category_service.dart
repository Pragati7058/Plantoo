import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class CategoryService {
  static Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await ApiClient.get(
        '/categories',
        includeAuth: false,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getCategoryById(String id) async {
    try {
      final response = await ApiClient.get(
        '/categories/$id',
        includeAuth: false,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await ApiClient.post(
        '/categories',
        body: categoryData,
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateCategory(String id, Map<String, dynamic> categoryData) async {
    try {
      final response = await ApiClient.put(
        '/categories/$id',
        body: categoryData,
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteCategory(String id) async {
    try {
      final response = await ApiClient.delete(
        '/categories/$id',
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