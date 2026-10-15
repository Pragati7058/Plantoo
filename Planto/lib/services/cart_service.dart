import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class CartService {
  static Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await ApiClient.get(
        '/cart',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> addToCart({
    required String plantId,
    int quantity = 1,
  }) async {
    try {
      final response = await ApiClient.post(
        '/cart',
        body: {
          'plantId': plantId,
          'quantity': quantity,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateCartItem({
    required String itemId,
    required int quantity,
  }) async {
    try {
      final response = await ApiClient.put(
        '/cart/$itemId',
        body: {
          'quantity': quantity,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> removeFromCart(String itemId) async {
    try {
      final response = await ApiClient.delete(
        '/cart/$itemId',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> clearCart() async {
    try {
      final response = await ApiClient.delete(
        '/cart',
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