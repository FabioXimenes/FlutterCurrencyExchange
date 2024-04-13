import 'package:flutter_currency_exchange/app/core/clients/api_client.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';

abstract class CurrencyExchangeRemoteDataSource {
  Future<CurrencyExchangeAPIQuota> getAPIQuota();
  Future<List<Currency>> getCurrencies();
  Future<double> getExchangeRate({
    required String fromCurrencyCode,
    required String toCurrencyCode,
  });
}

class CurrencyExchangeRemoteDataSourceImpl
    implements CurrencyExchangeRemoteDataSource {
  final APIClient apiClient;

  CurrencyExchangeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CurrencyExchangeAPIQuota> getAPIQuota() async {
    final response = await apiClient.get('/v1/status');
    return CurrencyExchangeAPIQuota.fromJson(
      response['quotas']['month'] as Map<String, dynamic>,
    );
  }

  @override
  Future<List<Currency>> getCurrencies() async {
    final response = await apiClient.get('/v1/currencies');
    final currencies = response['data'] as Map<String, dynamic>;
    return currencies.entries
        .map((entry) => Currency.fromJson(entry.value as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<double> getExchangeRate({
    required String fromCurrencyCode,
    required String toCurrencyCode,
  }) async {
    final response = await apiClient.get(
      '/v1/latest',
      queryParameters: {
        'base_currency': fromCurrencyCode,
        'currencies': [toCurrencyCode],
      },
    );
    return response['data'][toCurrencyCode] as double;
  }
}
