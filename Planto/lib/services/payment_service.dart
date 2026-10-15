import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class PaymentService {
  static Future<Map<String, dynamic>> createRazorpayOrder() async {
    try {
      final response = await ApiClient.post(
        '/payment/create-order',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required Map<String, dynamic> shippingAddress,
  }) async {
    try {
      final response = await ApiClient.post(
        '/payment/verify',
        body: {
          'razorpayOrderId': razorpayOrderId,
          'razorpayPaymentId': razorpayPaymentId,
          'razorpaySignature': razorpaySignature,
          'shippingAddress': shippingAddress,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getPaymentDetails(String orderId) async {
    try {
      final response = await ApiClient.get(
        '/payment/$orderId',
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
