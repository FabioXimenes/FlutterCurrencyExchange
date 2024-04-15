import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_currency_exchange/app/currency_exchange_app.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/currency_exchange_input_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/currency_text_field_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/latest_rates_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/widgets/request_limits_widget.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

const mockCurrencies = [
  Currency(code: 'USD', name: 'United States Dollar', symbol: '\$'),
  Currency(code: 'EUR', name: 'Euro', symbol: '€'),
  Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥'),
  Currency(code: 'GBP', name: 'British Pound', symbol: '£'),
  Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$'),
  Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$'),
  Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr'),
  Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥'),
  Currency(code: 'SEK', name: 'Swedish Krona', symbol: 'kr'),
  Currency(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$'),
  Currency(code: 'KRW', name: 'South Korean Won', symbol: '₩'),
  Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$'),
  Currency(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr'),
];

class MockCurrencyExchangeRepository extends Mock
    implements CurrencyExchangeRepository {}

void main() {
  late MockCurrencyExchangeRepository mockCurrencyExchangeRepository;

  setUpAll(() {
    mockCurrencyExchangeRepository = MockCurrencyExchangeRepository();
    GetIt.I.registerSingleton<CurrencyExchangeRepository>(
        mockCurrencyExchangeRepository);

    when(() => mockCurrencyExchangeRepository.getAPIQuota()).thenAnswer(
        (_) async => const Right(
            CurrencyExchangeAPIQuota(total: 300, used: 21, remaining: 279)));

    when(() => mockCurrencyExchangeRepository.getCurrencies())
        .thenAnswer((_) async => const Right(mockCurrencies));

    when(() => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: any(named: 'fromCurrencyCode'),
            toCurrencyCode: any(named: 'toCurrencyCode')))
        .thenAnswer((_) async => const Right(2));

    when(() => mockCurrencyExchangeRepository.getLatestCurrencyExchanges())
        .thenAnswer((_) async => const Right([]));

    when(() => mockCurrencyExchangeRepository.cacheCurrencyExchanges(any()))
        .thenAnswer((_) async => const Right(true));
  });

  group('CurrencyExchangePage', () {
    testWidgets(
      'Basic widgets are rendered correctly',
      (tester) async {
        // Build our app and trigger a frame.
        await tester.pumpWidget(const CurrencyExchangeApp());
        await tester.pumpAndSettle();

        // Verify that the page title is displayed
        expect(find.text('Currency Exchange'), findsOneWidget);

        // Verify that the RequestLimitsWidget is displayed
        expect(find.byType(RequestLimitsWidget), findsOneWidget);

        // Verify that the CurrencyExchangeInputWidget is displayed
        expect(find.byType(CurrencyExchangeInputWidget), findsOneWidget);

        // Verify that the LatestExchangesWidget is displayed
        expect(find.byType(LatestExchangesWidget), findsOneWidget);
      },
    );

    testWidgets(
      'Currency Exchange Input Widget is working correctly',
      (tester) async {
        // Set the screen size
        // const iPhone14Size = Size(390, 844);
        // await tester.binding.setSurfaceSize(iPhone14Size);

        // Build our app and trigger a frame.
        await tester.pumpWidget(const CurrencyExchangeApp());
        await tester.pumpAndSettle();

        // Tap on the base currency dropdown
        await tester.tap(find.byType(DropdownButton<Currency>).first);
        await tester.pumpAndSettle();

        // Select the base currency
        await tester
            .tap(find.textContaining(mockCurrencies[0].code).hitTestable());
        await tester.pumpAndSettle();

        // Tap on the target currency dropdown
        await tester.tap(find.byType(DropdownButton<Currency>).last);
        await tester.pumpAndSettle();

        // Select the target currency
        await tester
            .tap(find.textContaining(mockCurrencies[1].code).hitTestable());
        await tester.pumpAndSettle();

        // Check if the base and target currency texts are displayed
        expect(
          find.text('${mockCurrencies[0].code} - ${mockCurrencies[0].name}'),
          findsOneWidget,
        );
        expect(
          find.text('${mockCurrencies[1].code} - ${mockCurrencies[1].name}'),
          findsOneWidget,
        );

        // Check if the base and target currency symbols are displayed
        expect(find.text(mockCurrencies[0].symbol), findsOneWidget);
        expect(find.text(mockCurrencies[1].symbol), findsOneWidget);

        // Check the current base and target amounts
        expect(
          find.byWidgetPredicate((widget) =>
              widget is CurrencyTextFieldWidget &&
              widget.key == const Key('baseCurrency') &&
              widget.initialAmount == 1),
          findsOneWidget,
        );
        expect(
          find.byWidgetPredicate((widget) =>
              widget is CurrencyTextFieldWidget &&
              widget.key == const Key('targetCurrency') &&
              widget.initialAmount == 2),
          findsOneWidget,
        );

        // Enter the base amount
        final baseAmountTextFormFieldFinder = find.byType(TextFormField).first;
        await tester.tap(baseAmountTextFormFieldFinder);
        await tester.enterText(baseAmountTextFormFieldFinder, '');
        await tester.enterText(
          baseAmountTextFormFieldFinder,
          '1000', // This is equivalent to 10.00 because we are using CurrencyTextInputFormatter
        );
        await tester.pumpAndSettle();

        // Check if the correct base and target amounts are displayed
        expect(find.text('10.00'), findsOneWidget);
        expect(find.text('20.00'), findsOneWidget);

        // Accept the quote
        await tester.ensureVisible(find.text('Accept quote'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Accept quote'));
        await tester.pumpAndSettle();

        // Check if the latest exchange rate is displayed
        expect(find.text('USD -> EUR'), findsOneWidget);
        expect(find.text('\$ 10.00 -> € 20.00 (Rate: 2.0000)'), findsOneWidget);
      },
    );
  });
}
