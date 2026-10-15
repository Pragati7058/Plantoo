import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class PromoService {
  static Future<Map<String, dynamic>> validatePromoCode({
    required String code,
    required double orderAmount,
  }) async {
    try {
      final response = await ApiClient.post(
        '/promo/validate',
        body: {
          'code': code,
          'orderAmount': orderAmount,
        },
        includeAuth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return data;
      } else {
        throw data['message'] ?? 'Failed to validate promo code';
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
