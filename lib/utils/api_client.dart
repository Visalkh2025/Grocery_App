import 'package:dio/dio.dart';
import 'package:grocery_app/config/env_config.dart';

class ApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Envconfig.apiBaseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 15),
      sendTimeout: Duration(seconds: 15),
      responseType: ResponseType.json,
      validateStatus: (status) => status! < 500,
    ),
  );

  Future<Response> request({
    required String endpoint,
    required String method,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    try {
      Options options = Options(
        method: method,
        headers: {"Accept": "application/json", if (headers != null) ...headers},
      );

      // JSON Request
      if (data is Map) {
        options.contentType = "application/json";
      }

      // FormData Request
      if (data is FormData) {
        options.contentType = "multipart/form-data";
      }

      final response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: query,
        options: options,
      );

      return response;
    } catch (e) {
      throw Exception("DIO Error: $e");
    }
  }
}
