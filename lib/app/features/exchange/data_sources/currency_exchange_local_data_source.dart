import 'dart:convert';

import 'package:flutter_currency_exchange/app/core/clients/local_storage_client.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';

abstract class CurrencyExchangeLocalDataSource {
  Future<List<Exchange>> getLatestCurrencyExchanges();
  Future<bool> cacheCurrencyExchanges(List<Exchange> currencyExchanges);
}

class CurrencyExchangeLocalDataSourceImpl
    implements CurrencyExchangeLocalDataSource {
  final LocalStorageClient localStorageClient;

  CurrencyExchangeLocalDataSourceImpl(this.localStorageClient);

  final key = 'latest_currency_exchanges';

  @override
  Future<List<Exchange>> getLatestCurrencyExchanges() async {
    final exchangesString = await localStorageClient.get(key);

    if (exchangesString == null) return [];

    return (jsonDecode(exchangesString) as List)
        .map((e) => Exchange.fromJson(e))
        .toList();
  }

  @override
  Future<bool> cacheCurrencyExchanges(List<Exchange> currencyExchanges) {
    final exchangesString = jsonEncode(currencyExchanges);

    return localStorageClient.set(key, exchangesString);
  }
}
