import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/core/styles/text_styles.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/latest_exchanges/latest_exchanges_cubit.dart';

class LatestExchangesWidget extends StatelessWidget {
  const LatestExchangesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Latest Exchanges',
          style: TextStyles.titleLarge(context),
        ),
        const SizedBox(height: 8),
        BlocBuilder<LatestExchangesCubit, LatestExchangesState>(
          builder: (context, state) {
            return switch (state) {
              LatestExchangesInitial() => const SizedBox(),
              LatestExchangesLoading() => const CircularProgressIndicator(),
              LatestExchangesFailed() =>
                const Text('Failed to load latest rates'),
              LatestExchangesLoaded() => state.exchanges.isEmpty
                  ? const Text('Your latests exchanges will be placed here.')
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final exchange =
                            state.exchanges[state.exchanges.length - 1 - index];
                        return ListTile(
                          title: Text(
                              '${exchange.fromCurrency.code} -> ${exchange.toCurrency.code}'),
                          subtitle: Text(
                            '${exchange.fromCurrency.symbol} ${exchange.fromAmount.toStringAsFixed(2)} -> ${exchange.toCurrency.symbol} ${exchange.toAmount.toStringAsFixed(2)} (Rate: ${exchange.rate.toStringAsFixed(4)})',
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                      itemCount: (state).exchanges.length,
                      separatorBuilder: (context, index) => const Divider(),
                      shrinkWrap: true,
                    ),
            };
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
