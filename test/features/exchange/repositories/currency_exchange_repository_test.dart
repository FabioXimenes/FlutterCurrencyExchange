import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_remote_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyExchangeRemoteDataSource extends Mock
    implements CurrencyExchangeRemoteDataSource {}

void main() {
  late MockCurrencyExchangeRemoteDataSource mockRemoteDataSource;
  late CurrencyExchangeRepository repository;

  setUp(() {
    mockRemoteDataSource = MockCurrencyExchangeRemoteDataSource();
    repository =
        CurrencyExchangeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('getAPIQuota', () {
    const tCurrencyExchangeAPIQuota =
        CurrencyExchangeAPIQuota(total: 300, used: 21, remaining: 279);

    void setUpSuccessfulRemoteDataSourceCall() {
      when(() => mockRemoteDataSource.getAPIQuota())
          .thenAnswer((_) async => tCurrencyExchangeAPIQuota);
    }

    test(
      'should call CurrencyExchangeRemoteDataSource.getAPIQuota',
      () {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        repository.getAPIQuota();

        // assert
        verify(() => mockRemoteDataSource.getAPIQuota()).called(1);
      },
    );

    test(
      'should return the Right(CurrencyExchangeAPIQuota) when the call to '
      'remote data source is successful',
      () async {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        final result = await repository.getAPIQuota();

        // assert
        expect(result, const Right(tCurrencyExchangeAPIQuota));
      },
    );

    test(
      'should return a Left(GetAPIQuotaFailure) when the call to remote data '
      'source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getAPIQuota()).thenThrow(Exception());

        // act
        final result = await repository.getAPIQuota();

        // assert
        expect(result, Left(GetAPIQuotaFailure()));
      },
    );
  });

  group('getCurrencies', () {
    const tCurrencies = [
      Currency(code: 'USD', name: 'United States Dollar', symbol: '\$'),
      Currency(code: 'EUR', name: 'Euro', symbol: '€'),
    ];

    void setUpSuccessfulRemoteDataSourceCall() {
      when(() => mockRemoteDataSource.getCurrencies())
          .thenAnswer((_) async => tCurrencies);
    }

    test(
      'should call CurrencyExchangeRemoteDataSource.getCurrencies',
      () {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        repository.getCurrencies();

        // assert
        verify(() => mockRemoteDataSource.getCurrencies()).called(1);
      },
    );

    test(
      'should return the Right(List<Currency>) when the call to remote data '
      'source is successful',
      () async {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        final result = await repository.getCurrencies();

        // assert
        expect(result, const Right(tCurrencies));
      },
    );

    test(
      'should return a Left(GetCurrenciesFailure) when the call to remote data '
      'source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getCurrencies()).thenThrow(Exception());

        // act
        final result = await repository.getCurrencies();

        // assert
        expect(result, Left(GetCurrenciesFailure()));
      },
    );
  });

  group('getExchangeRate', () {
    const tFromCurrencyCode = 'USD';
    const tToCurrencyCode = 'EUR';
    const tExchangeRate = 0.85;

    void setUpSuccessfulRemoteDataSourceCall() {
      when(() => mockRemoteDataSource.getExchangeRate(
            fromCurrencyCode: any(named: 'fromCurrencyCode'),
            toCurrencyCode: any(named: 'toCurrencyCode'),
          )).thenAnswer((_) async => tExchangeRate);
    }

    test(
      'should call CurrencyExchangeRemoteDataSource.getExchangeRate',
      () {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        repository.getExchangeRate(
          fromCurrencyCode: tFromCurrencyCode,
          toCurrencyCode: tToCurrencyCode,
        );

        // assert
        verify(() => mockRemoteDataSource.getExchangeRate(
              fromCurrencyCode: tFromCurrencyCode,
              toCurrencyCode: tToCurrencyCode,
            )).called(1);
      },
    );

    test(
      'should return the Right(double) when the call to remote data source is '
      'successful',
      () async {
        // arrange
        setUpSuccessfulRemoteDataSourceCall();

        // act
        final result = await repository.getExchangeRate(
          fromCurrencyCode: tFromCurrencyCode,
          toCurrencyCode: tToCurrencyCode,
        );

        // assert
        expect(result, const Right(tExchangeRate));
      },
    );

    test(
      'should return a Left(GetExchangeRateFailure) when the call to remote '
      'data source is unsuccessful',
      () async {
        // arrange
        when(() => mockRemoteDataSource.getExchangeRate(
              fromCurrencyCode: any(named: 'fromCurrencyCode'),
              toCurrencyCode: any(named: 'toCurrencyCode'),
            )).thenThrow(Exception());

        // act
        final result = await repository.getExchangeRate(
          fromCurrencyCode: tFromCurrencyCode,
          toCurrencyCode: tToCurrencyCode,
        );

        // assert
        expect(result, Left(GetExchangeRateFailure()));
      },
    );
  });
}
