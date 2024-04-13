import 'package:flutter_currency_exchange/app/core/errors/failures.dart';

class GetAPIQuotaFailure implements Failure {
  @override
  String get message => 'Failed to get API quota.';
}

class GetCurrenciesFailure implements Failure {
  @override
  String get message => 'Failed to get currencies.';
}

class GetExchangeRateFailure implements Failure {
  @override
  String get message => 'Failed to get exchange rate.';
}
