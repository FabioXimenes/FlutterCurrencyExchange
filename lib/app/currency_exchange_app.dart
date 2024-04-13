import 'package:flutter/material.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/currency_exchange_page.dart';

class CurrencyExchangeApp extends StatelessWidget {
  const CurrencyExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CurrencyExchangePage(),
    );
  }
}
