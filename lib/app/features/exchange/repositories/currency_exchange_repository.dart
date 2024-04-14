import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/core/errors/failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_local_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_remote_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';

abstract class CurrencyExchangeRepository {
  Future<Either<Failure, CurrencyExchangeAPIQuota>> getAPIQuota();
  Future<Either<Failure, List<Currency>>> getCurrencies();
  Future<Either<Failure, double>> getExchangeRate({
    required String fromCurrencyCode,
    required String toCurrencyCode,
  });
  Future<Either<Failure, List<Exchange>>> getLatestCurrencyExchanges();
  Future<Either<Failure, bool>> cacheCurrencyExchanges(
    List<Exchange> currencyExchanges,
  );
}

class CurrencyExchangeRepositoryImpl implements CurrencyExchangeRepository {
  final CurrencyExchangeRemoteDataSource remoteDataSource;
  final CurrencyExchangeLocalDataSource localDataSource;

  CurrencyExchangeRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, CurrencyExchangeAPIQuota>> getAPIQuota() async {
    try {
      final result = await remoteDataSource.getAPIQuota();
      return Right(result);
    } catch (e) {
      return Left(GetAPIQuotaFailure());
    }
  }

  @override
  Future<Either<Failure, List<Currency>>> getCurrencies() async {
    try {
      final result = await remoteDataSource.getCurrencies();
      return Right(result);
    } catch (e) {
      return Left(GetCurrenciesFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getExchangeRate({
    required String fromCurrencyCode,
    required String toCurrencyCode,
  }) async {
    try {
      final result = await remoteDataSource.getExchangeRate(
        fromCurrencyCode: fromCurrencyCode,
        toCurrencyCode: toCurrencyCode,
      );
      return Right(result);
    } catch (e) {
      return Left(GetExchangeRateFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> cacheCurrencyExchanges(
    List<Exchange> currencyExchanges,
  ) async {
    try {
      final result =
          await localDataSource.cacheCurrencyExchanges(currencyExchanges);
      return Right(result);
    } catch (e) {
      return Left(CacheCurrencyExchangesFailure());
    }
  }

  @override
  Future<Either<Failure, List<Exchange>>> getLatestCurrencyExchanges() async {
    try {
      final result = await localDataSource.getLatestCurrencyExchanges();
      return Right(result);
    } catch (e) {
      return Left(GetLatestCurrencyExchangesFailure());
    }
  }
}
