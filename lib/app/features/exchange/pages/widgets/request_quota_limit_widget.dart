import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubit/api_quota/api_quota_cubit.dart';

class RequestQuotaLimit extends StatelessWidget {
  const RequestQuotaLimit({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<APIQuotaCubit, APIQuotaState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Request Quota'),
                const SizedBox(height: 8),
                switch (state) {
                  APIQuotaInitial() => const SizedBox(),
                  APIQuotaLoading() => const CircularProgressIndicator(),
                  APIQuotaLoaded() => _QuotaLoaded(quota: state.quota),
                  APIQuotaFailed() => const Text('Failed to load quota'),
                }
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuotaLoaded extends StatelessWidget {
  final CurrencyExchangeAPIQuota quota;

  const _QuotaLoaded({required this.quota});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total: '),
            Text('${quota.total}'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: quota.used / quota.total,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Used'),
                Text('${quota.used}'),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Remaining'),
                Text('${quota.remaining}'),
              ],
            ),
          ],
        )
      ],
    );
  }
}
