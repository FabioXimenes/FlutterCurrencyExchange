import 'package:dio/dio.dart';
import 'package:flutter_currency_exchange/app/core/clients/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late APIClient apiClient;

  setUp(() {
    mockDio = MockDio();
    apiClient = MainAPIClient(dio: mockDio);
  });

  group('MainAPIClient', () {
    group('get', () {
      final tResponseJson = {
        'code': 'USD',
        'name': 'United States Dollar',
        'symbol': '\$'
      };

      void setUpSuccessfulDioCall() {
        when(() => mockDio.get(any(),
            queryParameters: any(named: 'queryParameters'))).thenAnswer(
          (_) async => Response(
            data: tResponseJson,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );
      }

      test(
        'should call Dio.get with the correct parameters',
        () async {
          // arrange
          setUpSuccessfulDioCall();

          // act
          await apiClient.get('path', queryParameters: {'key': 'value'});

          // assert
          verify(() => mockDio.get('path', queryParameters: {'key': 'value'}))
              .called(1);
        },
      );

      test(
        'should return the json when the call is successful',
        () async {
          // arrange
          setUpSuccessfulDioCall();

          // act
          final result = await apiClient.get('path');

          // assert
          expect(result, tResponseJson);
        },
      );

      test(
        'should throw an exception when the call is unsuccessful',
        () async {
          // arrange
          when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters'))).thenThrow(
            DioException(requestOptions: RequestOptions(path: '')),
          );

          // act
          final call = apiClient.get('path');

          // assert
          expect(call, throwsA(isA<DioException>()));
        },
      );
    });
  });
}
