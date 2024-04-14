import 'dart:convert';

import 'package:flutter_currency_exchange/app/core/clients/local_storage_client.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_local_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalStorageClient extends Mock implements LocalStorageClient {}

void main() {
  late MockLocalStorageClient mockLocalStorageClient;
  late CurrencyExchangeLocalDataSource dataSource;

  setUp(() {
    mockLocalStorageClient = MockLocalStorageClient();
    dataSource = CurrencyExchangeLocalDataSourceImpl(mockLocalStorageClient);
  });

  group('getLatestCurrencyExchanges', () {
    const tExchange = Exchange(
      fromCurrency: Currency(
        code: 'USD',
        name: 'United States Dollar',
        symbol: '\$',
      ),
      toCurrency: Currency(
        code: 'BRL',
        name: 'Brazilian Real',
        symbol: 'R\$',
      ),
      rate: 5.13,
      fromAmount: 1,
      toAmount: 5.13,
    );

    test(
      'should return a list of Exchange from LocalStorageClient when the key is found',
      () async {
        // arrange
        when(() => mockLocalStorageClient.get('latest_currency_exchanges'))
            .thenAnswer((_) async => jsonEncode([tExchange]));

        // act
        final result = await dataSource.getLatestCurrencyExchanges();

        // assert
        expect(result, [tExchange]);
        verify(() => mockLocalStorageClient.get('latest_currency_exchanges'))
            .called(1);
      },
    );

    test(
      'should return an empty list if the key is not found',
      () async {
        // arrange
        when(() => mockLocalStorageClient.get('latest_currency_exchanges'))
            .thenAnswer((_) async => null);

        // act
        final result = await dataSource.getLatestCurrencyExchanges();

        // assert
        expect(result, []);
        verify(() => mockLocalStorageClient.get('latest_currency_exchanges'))
            .called(1);
      },
    );

    test(
      'should throw an exception when LocalStorageClient throws an exception',
      () async {
        // arrange
        when(() => mockLocalStorageClient.get('latest_currency_exchanges'))
            .thenThrow(Exception());

        // act
        final call = dataSource.getLatestCurrencyExchanges;

        // assert
        expect(() => call(), throwsException);
      },
    );
  });

  group('cacheCurrencyExchanges', () {
    const tExchange = Exchange(
      fromCurrency: Currency(
        code: 'USD',
        name: 'United States Dollar',
        symbol: '\$',
      ),
      toCurrency: Currency(
        code: 'BRL',
        name: 'Brazilian Real',
        symbol: 'R\$',
      ),
      rate: 5.13,
      fromAmount: 1,
      toAmount: 5.13,
    );

    test(
      'should return true when LocalStorageClient sets the value',
      () async {
        // arrange
        when(() => mockLocalStorageClient.set(
                'latest_currency_exchanges', jsonEncode([tExchange])))
            .thenAnswer((_) async => true);

        // act
        final result = await dataSource.cacheCurrencyExchanges([tExchange]);

        // assert
        expect(result, true);
        verify(() => mockLocalStorageClient.set(
            'latest_currency_exchanges', jsonEncode([tExchange]))).called(1);
      },
    );

    test(
      'should return false when LocalStorageClient fails to set the value',
      () async {
        // arrange
        when(() => mockLocalStorageClient.set(
                'latest_currency_exchanges', jsonEncode([tExchange])))
            .thenAnswer((_) async => false);

        // act
        final result = await dataSource.cacheCurrencyExchanges([tExchange]);

        // assert
        expect(result, false);
        verify(() => mockLocalStorageClient.set(
            'latest_currency_exchanges', jsonEncode([tExchange]))).called(1);
      },
    );

    test(
      'should throw an exception when LocalStorageClient throws an exception',
      () async {
        // arrange
        when(() => mockLocalStorageClient.set(
                'latest_currency_exchanges', jsonEncode([tExchange])))
            .thenThrow(Exception());

        // act
        final call = dataSource.cacheCurrencyExchanges;

        // assert
        expect(() => call([tExchange]), throwsException);
      },
    );
  });
}
