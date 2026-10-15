import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class WishlistService {
  static Future<Map<String, dynamic>> getWishlist() async {
    try {
      final response = await ApiClient.get(
        '/wishlist',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> addToWishlist({
    required String plantId,
  }) async {
    try {
      final response = await ApiClient.post(
        '/wishlist',
        body: {
          'plantId': plantId,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> removeFromWishlist(String plantId) async {
    try {
      final response = await ApiClient.delete(
        '/wishlist/$plantId',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> checkInWishlist(String plantId) async {
    try {
      final response = await ApiClient.get(
        '/wishlist/check/$plantId',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> clearWishlist() async {
    try {
      final response = await ApiClient.delete(
        '/wishlist',
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