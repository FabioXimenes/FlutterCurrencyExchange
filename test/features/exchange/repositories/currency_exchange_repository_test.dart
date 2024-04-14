import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_local_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_remote_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyExchangeRemoteDataSource extends Mock
    implements CurrencyExchangeRemoteDataSource {}

class MockCurrencyExchangeLocalDataSource extends Mock
    implements CurrencyExchangeLocalDataSource {}

void main() {
  late MockCurrencyExchangeRemoteDataSource mockRemoteDataSource;
  late MockCurrencyExchangeLocalDataSource mockLocalDataSource;
  late CurrencyExchangeRepository repository;

  setUp(() {
    mockRemoteDataSource = MockCurrencyExchangeRemoteDataSource();
    mockLocalDataSource = MockCurrencyExchangeLocalDataSource();
    repository = CurrencyExchangeRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
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

    void setUpSuccessfulLocalDataSourceCall() {
      when(() => mockLocalDataSource.cacheCurrencyExchanges([tExchange]))
          .thenAnswer((_) async => true);
    }

    test(
      'should call CurrencyExchangeLocalDataSource.cacheCurrencyExchanges',
      () {
        // arrange
        setUpSuccessfulLocalDataSourceCall();

        // act
        repository.cacheCurrencyExchanges([tExchange]);

        // assert
        verify(() => mockLocalDataSource.cacheCurrencyExchanges([tExchange]))
            .called(1);
      },
    );

    test(
      'should return Right(bool) when the call to the data source is successful',
      () async {
        // arrange
        setUpSuccessfulLocalDataSourceCall();

        // act
        final result = await repository.cacheCurrencyExchanges([tExchange]);

        // assert
        expect(result, const Right(true));
      },
    );

    test(
      'should return Left(CacheCurrencyExchangesFailure) when the call to the '
      'data source is unsuccessful',
      () async {
        // arrange
        when(() => mockLocalDataSource.cacheCurrencyExchanges([tExchange]))
            .thenThrow(Exception());

        // act
        final result = await repository.cacheCurrencyExchanges([tExchange]);

        // assert
        expect(result, Left(CacheCurrencyExchangesFailure()));
      },
    );
  });

  group('getLatestCurrencyExchanges', () {
    const tExchanges = [
      Exchange(
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
      ),
    ];

    void setUpSuccessfulLocalDataSourceCall() {
      when(() => mockLocalDataSource.getLatestCurrencyExchanges())
          .thenAnswer((_) async => tExchanges);
    }

    test(
      'should call CurrencyExchangeLocalDataSource.getLatestCurrencyExchanges',
      () {
        // arrange
        setUpSuccessfulLocalDataSourceCall();

        // act
        repository.getLatestCurrencyExchanges();

        // assert
        verify(() => mockLocalDataSource.getLatestCurrencyExchanges())
            .called(1);
      },
    );

    test(
      'should return Right(List<Exchange>) when the call to the data source is successful',
      () async {
        // arrange
        setUpSuccessfulLocalDataSourceCall();

        // act
        final result = await repository.getLatestCurrencyExchanges();

        // assert
        expect(result, const Right(tExchanges));
      },
    );

    test(
      'should return Left(GetLatestCurrencyExchangesFailure) when the call to the '
      'data source is unsuccessful',
      () async {
        // arrange
        when(() => mockLocalDataSource.getLatestCurrencyExchanges())
            .thenThrow(Exception());

        // act
        final result = await repository.getLatestCurrencyExchanges();

        // assert
        expect(result, Left(GetLatestCurrencyExchangesFailure()));
      },
    );
  });
}
