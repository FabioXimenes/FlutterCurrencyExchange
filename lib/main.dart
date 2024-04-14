import 'package:flutter/material.dart';
import 'package:flutter_currency_exchange/app/core/core_resources_startup.dart';
import 'package:flutter_currency_exchange/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_currency_exchange/app/currency_exchange_app.dart';
import 'package:flutter_currency_exchange/app/features/exchange/currency_exchange_resources_startup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await dotenv.load(fileName: 'assets/env/.env');

  for (final resource in Resources.resources) {
    resource.init(GetIt.instance);
  }

  runApp(const CurrencyExchangeApp());
}

class Resources {
  static final List<ResourcesStartup> resources = [
    CoreResourcesStartup(),
    CurrencyExchangeResourcesStartup(),
  ];
}
