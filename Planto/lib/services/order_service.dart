import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class OrderService {
  static Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> shippingAddress,
  }) async {
    try {
      final response = await ApiClient.post(
        '/orders',
        body: {
          'shippingAddress': shippingAddress,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getUserOrders() async {
    try {
      final response = await ApiClient.get(
        '/orders',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getOrderById(String id) async {
    try {
      final response = await ApiClient.get(
        '/orders/$id',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateOrderStatus({
    required String id,
    required String status,
  }) async {
    try {
      final response = await ApiClient.put(
        '/orders/$id/status',
        body: {
          'status': status,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getAllOrders() async {
    try {
      final response = await ApiClient.get(
        '/orders/all',
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