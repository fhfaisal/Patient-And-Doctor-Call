import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:untitled1/app/data/TOKEN_RESPONSE.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        "X-Requested-With": "XMLHttpRequest",
      },
    ),
  );

  // Method to create a token for a given channel
  Future<TokenResponse?> createToken({
    required String channelName,
    required String uid,
  }) async {
    final String url =
        'http://192.168.0.108:3000/createToken?channelName=$channelName&uid=$uid';

    try {
      // Sending POST request
      final response = await _dio.post(url);

      if (response.statusCode == 200) {
        final data = response.data;
        String token = data['token'];
        String channel = data['channelName'];
        print('Token: $token');
        print('Channel: $channel');
        return TokenResponse.fromJson(data);
      } else {
        print('Failed to create token: ${response.statusCode}');
        print('Response: ${response.data}');
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      print('Unexpected error: $e');
      throw e;
    }
    return null;
  }

  // Method to get the token by channel name
  Future<TokenResponse?> getToken({required String channelName}) async {
    final String url = 'http://192.168.0.108:3000/getToken?channelName=$channelName';

    try {
      // Sending GET request
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        return TokenResponse.fromJson(data);
      } else {
        print('Channel not found: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      print('Unexpected error: $e');
      throw e;
    }
    return null;
  }

  // Helper method to handle Dio-specific exceptions
  void _handleDioError(DioException e) {
    if (kDebugMode) {
      print('DioException: ${e.type}, ${e.response}');
    }

    if (e.type == DioExceptionType.connectionError) {
      throw Exception(
          "Your internet connection is unstable. Please try again later.");
    } else if (e.response != null) {
      throw Exception(e.response?.data["status"] ?? 'Unknown error');
    } else {
      throw Exception('Something went wrong. Please try again.');
    }
  }
}
