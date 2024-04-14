import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubit/api_quota/api_quota_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubit/currencies/currencies_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubit/exchange_form/exchange_form_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/currency_text_field_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/request_quota_limit_widget.dart';
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
                    const RequestQuotaLimit(),
                    const SizedBox(height: 16),
                    switch (state) {
                      CurrenciesInitial() => const SizedBox(),
                      CurrenciesLoading() => const CircularProgressIndicator(),
                      CurrenciesFailed() =>
                        const Text('Failed to load currencies'),
                      CurrenciesLoaded() => const CurrencyExchangeInputWidget(),
                    },
                    const SizedBox(height: 16),
                    const Text('Latest Rates'),
                    // TODO: Create the latest rates widget
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

class CurrencyExchangeInputWidget extends StatelessWidget {
  const CurrencyExchangeInputWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExchangeFormCubit, ExchangeFormState>(
      builder: (context, state) {
        final cubit = context.read<ExchangeFormCubit>();
        return Column(
          children: [
            CurrencyTextFieldWidget(
              key: const Key('baseCurrency'),
              hintText: 'Select base currency',
              initialCurrency: state.baseCurrency,
              initialAmount: state.baseAmount,
              onCurrencySelected: (currency) {
                cubit.setBaseCurrency(currency);
                if (state.targetCurrency != null) {
                  context.read<APIQuotaCubit>().incrementUsage();
                }
              },
              onValueChanged: (value) {
                cubit.setBaseAmount(value);
              },
              enabled: !state.isLoading,
            ),
            Center(
              child: IconButton(
                iconSize: 32,
                padding: EdgeInsets.zero,
                onPressed: () {
                  cubit.swapCurrencies();
                },
                icon: const Icon(Icons.swap_vertical_circle_rounded),
              ),
            ),
            CurrencyTextFieldWidget(
              key: const Key('targetCurrency'),
              hintText: 'Select target currency',
              initialCurrency: state.targetCurrency,
              initialAmount: state.targetAmount,
              onCurrencySelected: (currency) {
                cubit.setTargetCurrency(currency);
                if (state.baseCurrency != null) {
                  context.read<APIQuotaCubit>().incrementUsage();
                }
              },
              onValueChanged: (value) {
                cubit.setTargetAmount(value);
              },
              enabled: !state.isLoading,
            ),
            const SizedBox(height: 16),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // TODO: Implement the accept quote logic
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 3),
                        ),
                      ),
                    const Text('Accept quote'),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
