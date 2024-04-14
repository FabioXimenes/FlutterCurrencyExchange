import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/core/styles/text_styles.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/api_quota/api_quota_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/exchange_form/exchange_form_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/latest_exchanges/latest_exchanges_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/currency_text_field_widget.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Currencies',
              style: TextStyles.titleLarge(context),
            ),
            const SizedBox(height: 8),
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
                onPressed: state.isLoading
                    ? null
                    : () {
                        if (state.baseCurrency == null &&
                            state.targetCurrency == null) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select the currencies first.',
                              ),
                            ),
                          );
                          return;
                        }
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
            Row(
              children: [
                const Text('Rate: '),
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 3),
                    ),
                  ),
                if (state.rate != null) Text(state.rate!.toStringAsFixed(4)),
              ],
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  if (state.isLoading ||
                      state.baseCurrency == null ||
                      state.targetCurrency == null ||
                      state.baseAmount == null ||
                      state.targetAmount == null) {
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields.'),
                      ),
                    );
                    return;
                  }

                  context.read<LatestExchangesCubit>().cacheExchange(
                        Exchange(
                          fromCurrency: state.baseCurrency!,
                          toCurrency: state.targetCurrency!,
                          fromAmount: state.baseAmount!,
                          toAmount: state.targetAmount!,
                          rate: state.rate!,
                        ),
                      );
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
