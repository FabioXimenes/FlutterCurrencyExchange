import 'package:dio/dio.dart';
import 'package:flutter_currency_exchange/app/core/clients/api_client.dart';
import 'package:flutter_currency_exchange/app/core/clients/local_storage_client.dart';
import 'package:flutter_currency_exchange/app/core/resources_startup/resources_startup.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreResourcesStartup extends ResourcesStartup {
  @override
  void init(GetIt sl) async {
    sl.registerSingleton(
      Dio(
        BaseOptions(
          baseUrl: dotenv.env['API_HOST']!,
          headers: {'apikey': dotenv.env['API_KEY']!},
        ),
      ),
    );

    sl.registerSingleton<APIClient>(MainAPIClient(dio: sl.get()));

    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<LocalStorageClient>(
        SharedPreferencesStorageClient(sharedPreferences));
  }
}
