import 'package:flutter_currency_exchange/app/core/clients/api_client.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_remote_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAPIClient extends Mock implements APIClient {}

void main() {
  late APIClient mockAPIClient;
  late CurrencyExchangeRemoteDataSource dataSource;

  setUp(() {
    mockAPIClient = MockAPIClient();
    dataSource = CurrencyExchangeRemoteDataSourceImpl(apiClient: mockAPIClient);
  });

  group('getAPIQuota', () {
    void setUpSuccessfulAPICall() {
      when(() => mockAPIClient.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => {
                'quotas': {
                  'month': {'total': 300, 'used': 21, 'remaining': 279}
                },
              });
    }

    test(
      'should perform a GET request on /v1/status with the correct parameters',
      () async {
        // arrange
        setUpSuccessfulAPICall();

        // act
        await dataSource.getAPIQuota();

        // assert
        verify(() => mockAPIClient.get('/v1/status')).called(1);
      },
    );

    test(
      'should return a CurrencyExchangeAPIQuota when the request is successful',
      () async {
        // arrange
        setUpSuccessfulAPICall();

        // act
        final result = await dataSource.getAPIQuota();

        // assert
        expect(
            result,
            const CurrencyExchangeAPIQuota(
                total: 300, used: 21, remaining: 279));
      },
    );

    test(
      'should throw an exception when the request is unsuccessful',
      () async {
        // arrange
        when(() => mockAPIClient.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(Exception());

        // act
        final call = dataSource.getAPIQuota;

        // assert
        expect(call(), throwsA(isA<Exception>()));
      },
    );
  });

  group('getCurrencies', () {
    void setUpSuccessfulAPICall() {
      when(() => mockAPIClient.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => {
                'data': {
                  'USD': {
                    'name': 'United States Dollar',
                    'symbol': '\$',
                    'code': 'USD'
                  },
                  'EUR': {'name': 'Euro', 'symbol': '€', 'code': 'EUR'}
                },
              });
    }

    test(
      'should perform a GET request on /v1/currencies with the correct parameters',
      () async {
        // arrange
        setUpSuccessfulAPICall();

        // act
        await dataSource.getCurrencies();

        // assert
        verify(() => mockAPIClient.get('/v1/currencies')).called(1);
      },
    );

    test(
      'should return a list of Currency when the request is successful',
      () async {
        // arrange
        setUpSuccessfulAPICall();

        // act
        final result = await dataSource.getCurrencies();

        // assert
        expect(
          result,
          [
            const Currency(
                code: 'USD', name: 'United States Dollar', symbol: '\$'),
            const Currency(code: 'EUR', name: 'Euro', symbol: '€'),
          ],
        );
      },
    );

    test(
      'should throw an exception when the request is unsuccessful',
      () async {
        // arrange
        when(() => mockAPIClient.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(Exception());

        // act
        final call = dataSource.getCurrencies;

        // assert
        expect(call(), throwsA(isA<Exception>()));
      },
    );
  });

  group('getExchangeRate', () {
    void setUpSuccessfulAPICall() {
      when(() => mockAPIClient.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => {
                'data': {'EUR': 0.85},
              });
    }

    test(
      'should perform a GET request on /v1/latest with the correct parameters',
      () async {
        // arrange
        setUpSuccessfulAPICall();

        // act
        await dataSource.getExchangeRate(
          fromCurrencyCode: 'USD',
          toCurrencyCode: 'EUR',
        );

        // assert
        verify(() => mockAPIClient.get(
              '/v1/latest',
              queryParameters: {
                'base_currency': 'USD',
                'currencies': ['EUR'],
              },
            )).called(1);
      },
    );

    test(
      'should return a double when the request is successful',
      () async {
        // arrange
        setUpSuccessfulAPICall();

        // act
        final result = await dataSource.getExchangeRate(
          fromCurrencyCode: 'USD',
          toCurrencyCode: 'EUR',
        );

        // assert
        expect(result, 0.85);
      },
    );

    test(
      'should throw an exception when the request is unsuccessful',
      () async {
        // arrange
        when(() => mockAPIClient.get(any(),
                queryParameters: any(named: 'queryParameters')))
            .thenThrow(Exception());

        // act
        final call = dataSource.getExchangeRate;

        // assert
        expect(
          call(fromCurrencyCode: 'USD', toCurrencyCode: 'EUR'),
          throwsA(isA<Exception>()),
        );
      },
    );
  });
}
