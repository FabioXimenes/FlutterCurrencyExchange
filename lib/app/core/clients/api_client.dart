import 'package:dio/dio.dart';

abstract class APIClient {
  Future<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic> queryParameters = const {},
  });
}

class MainAPIClient implements APIClient {
  final Dio _dio;

  MainAPIClient({required Dio dio}) : _dio = dio;

  @override
  Future<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) parser,
    Map<String, dynamic> queryParameters = const {},
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return parser(response.data);
  }
}
