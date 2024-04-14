import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/api_quota/api_quota_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/currencies/currencies_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/exchange_form/exchange_form_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/latest_exchanges/latest_exchanges_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/currency_exchange_input_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/latest_rates_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/request_limits_widget.dart';
import 'package:get_it/get_it.dart';

class CurrencyExchangePage extends StatefulWidget {
  const CurrencyExchangePage({super.key});

  @override
  State<CurrencyExchangePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CurrencyExchangePage> {
  Currency? baseCurrency;
  Currency? targetCurrency;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CurrenciesCubit(GetIt.instance.get())..loadCurrencies(),
        ),
        BlocProvider(
            create: (context) => ExchangeFormCubit(GetIt.instance.get())),
        BlocProvider(
          create: (context) =>
              APIQuotaCubit(GetIt.instance.get())..getApiQuota(),
        ),
        BlocProvider(
          create: (context) =>
              LatestExchangesCubit(GetIt.instance.get())..getLatestExchanges(),
        )
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Currency Exchange'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: BlocBuilder<CurrenciesCubit, CurrenciesState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 16),
                    const RequestLimitsWidget(),
                    const SizedBox(height: 16),
                    switch (state) {
                      CurrenciesInitial() => const SizedBox(),
                      CurrenciesLoading() => const SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      CurrenciesFailed() =>
                        const Text('Failed to load currencies'),
                      CurrenciesLoaded() => const CurrencyExchangeInputWidget(),
                    },
                    const SizedBox(height: 16),
                    const LatestExchangesWidget(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
