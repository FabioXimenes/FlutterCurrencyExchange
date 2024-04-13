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
