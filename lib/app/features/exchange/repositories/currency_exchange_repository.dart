import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/core/errors/failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_remote_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';

abstract class CurrencyExchangeRepository {
  Future<Either<Failure, CurrencyExchangeAPIQuota>> getAPIQuota();
  Future<Either<Failure, List<Currency>>> getCurrencies();
  Future<Either<Failure, double>> getExchangeRate({
    required String fromCurrencyCode,
    required String toCurrencyCode,
  });
}

class CurrencyExchangeRepositoryImpl implements CurrencyExchangeRepository {
  final CurrencyExchangeRemoteDataSource remoteDataSource;

  CurrencyExchangeRepositoryImpl({required this.remoteDataSource});

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
}
