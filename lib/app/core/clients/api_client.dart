import 'package:dio/dio.dart';

abstract class APIClient {
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  });
}

class MainAPIClient implements APIClient {
  final Dio _dio;

  MainAPIClient({required Dio dio}) : _dio = dio;

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic> queryParameters = const {},
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data;
  }
}
