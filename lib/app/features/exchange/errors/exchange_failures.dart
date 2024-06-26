import 'package:flutter_currency_exchange/app/core/errors/failures.dart';

class GetAPIQuotaFailure extends Failure {
  @override
  String get message => 'Failed to get API quota.';
}

class GetCurrenciesFailure extends Failure {
  @override
  String get message => 'Failed to get currencies.';
}

class GetExchangeRateFailure extends Failure {
  @override
  String get message => 'Failed to get exchange rate.';
}

class CacheCurrencyExchangesFailure extends Failure {
  @override
  String get message => 'Failed to cache currency exchanges.';
}

class GetLatestCurrencyExchangesFailure extends Failure {
  @override
  String get message => 'Failed to get latest currency exchanges.';
}
