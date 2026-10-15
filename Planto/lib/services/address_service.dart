import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class AddressService {
  static Future<Map<String, dynamic>> getAddresses() async {
    try {
      final response = await ApiClient.get(
        '/addresses',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> addAddress({
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required String country,
    required String phone,
    bool isDefault = false,
  }) async {
    try {
      final response = await ApiClient.post(
        '/addresses',
        body: {
          'street': street,
          'city': city,
          'state': state,
          'zipCode': zipCode,
          'country': country,
          'phone': phone,
          'isDefault': isDefault,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateAddress({
    required String addressId,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? phone,
    bool? isDefault,
  }) async {
    try {
      final response = await ApiClient.put(
        '/addresses/$addressId',
        body: {
          if (street != null) 'street': street,
          if (city != null) 'city': city,
          if (state != null) 'state': state,
          if (zipCode != null) 'zipCode': zipCode,
          if (country != null) 'country': country,
          if (phone != null) 'phone': phone,
          if (isDefault != null) 'isDefault': isDefault,
        },
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deleteAddress(String addressId) async {
    try {
      final response = await ApiClient.delete(
        '/addresses/$addressId',
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> setDefaultAddress(String addressId) async {
    try {
      final response = await ApiClient.put(
        '/addresses/$addressId/default',
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
