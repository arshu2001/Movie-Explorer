import 'package:dio/dio.dart';
import 'package:the_movie_database/core/constants/api_constants.dart';

class NetworkClient {
  late final Dio _dio;

  NetworkClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final Map<String, dynamic> params = queryParameters ?? {};
      params['apikey'] = ApiConstants.apiKey; // Automatically add API key
      
      final response = await _dio.get(
        '', // Base URL is set, OMDb uses query params on root usually
        queryParameters: params,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    String msg = 'Unknown error occurred';
    if (e.type == DioExceptionType.connectionTimeout || 
        e.type == DioExceptionType.receiveTimeout) {
      msg = 'Connection timed out';
    } else if (e.response != null) {
      msg = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
    }
    return Exception(msg);
  }
}
