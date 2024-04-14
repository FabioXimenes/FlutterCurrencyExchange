import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/latest_exchanges/latest_exchanges_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyExchangeRepository extends Mock
    implements CurrencyExchangeRepository {}

void main() {
  late MockCurrencyExchangeRepository mockCurrencyExchangeRepository;
  late LatestExchangesCubit cubit;

  setUp(() {
    mockCurrencyExchangeRepository = MockCurrencyExchangeRepository();
    cubit = LatestExchangesCubit(mockCurrencyExchangeRepository);
  });

  group('getLatestExchanges', () {
    const tExchanges = [
      Exchange(
        fromCurrency: Currency(
          code: 'USD',
          name: 'United States Dollar',
          symbol: '\$',
        ),
        toCurrency: Currency(
          code: 'BRL',
          name: 'Brazilian Real',
          symbol: 'R\$',
        ),
        rate: 5.13,
        fromAmount: 1,
        toAmount: 5.13,
      ),
    ];

    blocTest(
      'should call CurrencyExchangeRepository.getLatestCurrencyExchanges',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.getLatestCurrencyExchanges())
            .thenAnswer((_) async => const Right(tExchanges));
      },
      build: () => cubit,
      act: (cubit) => cubit.getLatestExchanges(),
      verify: (_) {
        verify(() =>
                mockCurrencyExchangeRepository.getLatestCurrencyExchanges())
            .called(1);
      },
    );

    blocTest(
      'should emit [LatestExchangesLoading, LatestExchangesLoaded] when the call to CurrencyExchangeRepository.getLatestCurrencyExchanges is successful',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.getLatestCurrencyExchanges())
            .thenAnswer((_) async => const Right(tExchanges));
      },
      build: () => cubit,
      act: (cubit) => cubit.getLatestExchanges(),
      expect: () =>
          [LatestExchangesLoading(), const LatestExchangesLoaded(tExchanges)],
    );

    blocTest(
      'should emit [LatestExchangesLoading, LatestExchangesFailed] when the call to CurrencyExchangeRepository.getLatestCurrencyExchanges is unsuccessful',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.getLatestCurrencyExchanges())
            .thenAnswer((_) async => Left(GetLatestCurrencyExchangesFailure()));
      },
      build: () => cubit,
      act: (cubit) => cubit.getLatestExchanges(),
      expect: () => [
        LatestExchangesLoading(),
        LatestExchangesFailed(GetLatestCurrencyExchangesFailure())
      ],
    );
  });

  group('cacheExchange', () {
    const tExchange = Exchange(
      fromCurrency: Currency(
        code: 'USD',
        name: 'United States Dollar',
        symbol: '\$',
      ),
      toCurrency: Currency(
        code: 'BRL',
        name: 'Brazilian Real',
        symbol: 'R\$',
      ),
      rate: 5.13,
      fromAmount: 1,
      toAmount: 5.13,
    );

    blocTest(
      'should not cache exchange when state is not LatestExchangesLoaded',
      build: () => cubit,
      act: (cubit) => cubit.cacheExchange(tExchange),
      verify: (_) {
        verifyZeroInteractions(mockCurrencyExchangeRepository);
      },
    );

    blocTest<LatestExchangesCubit, LatestExchangesState>(
      'should cache exchange when state is LatestExchangesLoaded',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.cacheCurrencyExchanges(
              [tExchange],
            )).thenAnswer((_) async => const Right(true));
      },
      build: () => cubit,
      seed: () => const LatestExchangesLoaded([]),
      act: (cubit) => cubit.cacheExchange(tExchange),
      verify: (_) {
        verify(() => mockCurrencyExchangeRepository.cacheCurrencyExchanges(
              [tExchange],
            )).called(1);
      },
      expect: () => [
        const LatestExchangesLoaded([tExchange]),
      ],
    );

    blocTest<LatestExchangesCubit, LatestExchangesState>(
      'should not cache exchange when CurrencyExchangeRepository.cacheCurrencyExchanges fails',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.cacheCurrencyExchanges(
              [tExchange],
            )).thenAnswer((_) async => Left(CacheCurrencyExchangesFailure()));
      },
      build: () => cubit,
      seed: () => const LatestExchangesLoaded([]),
      act: (cubit) => cubit.cacheExchange(tExchange),
      verify: (_) {
        verify(() => mockCurrencyExchangeRepository.cacheCurrencyExchanges(
              [tExchange],
            )).called(1);
      },
      expect: () => [],
    );
  });
}
