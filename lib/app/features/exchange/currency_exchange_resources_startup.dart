import 'package:flutter_currency_exchange/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_currency_exchange/app/features/exchange/data_sources/currency_exchange_remote_data_source.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:get_it/get_it.dart';

class CurrencyExchangeResourcesStartup extends ResourcesStartup {
  @override
  void init(GetIt sl) {
    sl.registerSingleton<CurrencyExchangeRemoteDataSource>(
        CurrencyExchangeRemoteDataSourceImpl(apiClient: sl.get()));

    sl.registerSingleton<CurrencyExchangeRepository>(
        CurrencyExchangeRepositoryImpl(remoteDataSource: sl.get()));
  }
}
