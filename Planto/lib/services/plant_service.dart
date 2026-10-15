import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';

class PlantService {
  static Future<Map<String, dynamic>> getPlants({
    String? category,
    String? search,
    double? minPrice,
    double? maxPrice,
    bool? isPetFriendly,
  }) async {
    try {
      final queryParams = <String, String>{};
      
      if (category != null) queryParams['category'] = category;
      if (search != null) queryParams['search'] = search;
      if (minPrice != null) queryParams['minPrice'] = minPrice.toString();
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice.toString();
      if (isPetFriendly != null) queryParams['isPetFriendly'] = isPetFriendly.toString();

      final response = await ApiClient.get(
        '/plants',
        queryParams: queryParams,
        includeAuth: false,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getPlantById(String id) async {
    try {
      final response = await ApiClient.get(
        '/plants/$id',
        includeAuth: false,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> createPlant(Map<String, dynamic> plantData) async {
    try {
      final response = await ApiClient.post(
        '/plants',
        body: plantData,
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updatePlant(String id, Map<String, dynamic> plantData) async {
    try {
      final response = await ApiClient.put(
        '/plants/$id',
        body: plantData,
        includeAuth: true,
      );

      return _handleResponse(response);
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> deletePlant(String id) async {
    try {
      final response = await ApiClient.delete(
        '/plants/$id',
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
