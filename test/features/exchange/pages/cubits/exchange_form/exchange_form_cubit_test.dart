import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/exchange_form/exchange_form_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyExchangeRepository extends Mock
    implements CurrencyExchangeRepository {}

void main() {
  late MockCurrencyExchangeRepository mockCurrencyExchangeRepository;
  late ExchangeFormCubit cubit;

  setUp(() {
    mockCurrencyExchangeRepository = MockCurrencyExchangeRepository();
    cubit = ExchangeFormCubit(mockCurrencyExchangeRepository);
  });

  group('setBaseCurrency', () {
    const tCurrency = Currency(
      code: 'USD',
      name: 'United States Dollar',
      symbol: '\$',
    );

    blocTest(
      'should emit [ExchangeFormState] when the call to setBaseCurrency is successful',
      build: () => cubit,
      act: (cubit) => cubit.setBaseCurrency(tCurrency),
      expect: () => [
        const ExchangeFormState(baseCurrency: tCurrency),
      ],
    );

    blocTest(
      'should call getExchangeRate when targetCurrency is not null',
      build: () => cubit,
      seed: () => const ExchangeFormState(targetCurrency: tCurrency),
      setUp: () {
        when(
          () => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: tCurrency.code,
            toCurrencyCode: tCurrency.code,
          ),
        ).thenAnswer((_) async => const Right(1.0));
      },
      act: (cubit) {
        cubit.setBaseCurrency(tCurrency);
      },
      verify: (_) {
        verify(
          () => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: tCurrency.code,
            toCurrencyCode: tCurrency.code,
          ),
        ).called(1);
      },
    );
  });

  group('setTargetCurrency', () {
    const tCurrency = Currency(
      code: 'USD',
      name: 'United States Dollar',
      symbol: '\$',
    );

    blocTest(
      'should emit [ExchangeFormState] when the call to setTargetCurrency is successful',
      build: () => cubit,
      act: (cubit) => cubit.setTargetCurrency(tCurrency),
      expect: () => [
        const ExchangeFormState(targetCurrency: tCurrency),
      ],
    );

    blocTest(
      'should call getExchangeRate when baseCurrency is not null',
      build: () => cubit,
      seed: () => const ExchangeFormState(baseCurrency: tCurrency),
      setUp: () {
        when(
          () => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: tCurrency.code,
            toCurrencyCode: tCurrency.code,
          ),
        ).thenAnswer((_) async => const Right(1.0));
      },
      act: (cubit) {
        cubit.setTargetCurrency(tCurrency);
      },
      verify: (_) {
        verify(
          () => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: tCurrency.code,
            toCurrencyCode: tCurrency.code,
          ),
        ).called(1);
      },
    );
  });

  group('setBaseAmount', () {
    const tAmount = 1.0;

    const tCurrency = Currency(
      code: 'USD',
      name: 'United States Dollar',
      symbol: '\$',
    );

    blocTest(
      'should emit [ExchangeFormState] with new baseAmount and targetAmount should be updated if targetCurrency is not null',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        targetCurrency: tCurrency,
        rate: 2,
      ),
      act: (cubit) => cubit.setBaseAmount(tAmount),
      expect: () => [
        const ExchangeFormState(
          baseAmount: tAmount,
          targetCurrency: tCurrency,
          targetAmount: 2,
          rate: 2,
        ),
      ],
    );

    blocTest(
      'should emit [ExchangeFormState] with new baseAmount and targetAmount should be null if targetCurrency is null',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        rate: 2,
      ),
      act: (cubit) => cubit.setBaseAmount(tAmount),
      expect: () => [
        const ExchangeFormState(
          baseAmount: tAmount,
          rate: 2,
        ),
      ],
    );
  });

  group('setTargetAmount', () {
    const tAmount = 1.0;

    const tCurrency = Currency(
      code: 'USD',
      name: 'United States Dollar',
      symbol: '\$',
    );

    blocTest(
      'should emit [ExchangeFormState] with new targetAmount and baseAmount should be updated if baseCurrency is not null',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        baseCurrency: tCurrency,
        rate: 2,
      ),
      act: (cubit) => cubit.setTargetAmount(tAmount),
      expect: () => [
        const ExchangeFormState(
          targetAmount: tAmount,
          baseCurrency: tCurrency,
          baseAmount: 0.5,
          rate: 2,
        ),
      ],
    );

    blocTest(
      'should emit [ExchangeFormState] with new targetAmount and baseAmount should be null if baseCurrency is null',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        rate: 2,
      ),
      act: (cubit) => cubit.setTargetAmount(tAmount),
      expect: () => [
        const ExchangeFormState(
          targetAmount: tAmount,
          rate: 2,
        ),
      ],
    );
  });

  group('swapCurrencies', () {
    const tBaseCurrency = Currency(
      code: 'USD',
      name: 'United States Dollar',
      symbol: '\$',
    );

    const tTargetCurrency = Currency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
    );

    blocTest(
      'should emit [ExchangeFormState] with swapped currencies and amounts',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        baseCurrency: tBaseCurrency,
        targetCurrency: tTargetCurrency,
        baseAmount: 1,
        targetAmount: 2,
        rate: 2,
      ),
      act: (cubit) => cubit.swapCurrencies(),
      expect: () => [
        const ExchangeFormState(
          baseCurrency: tTargetCurrency,
          targetCurrency: tBaseCurrency,
          baseAmount: 2,
          targetAmount: 1,
          rate: 0.5,
        ),
      ],
    );

    blocTest(
      'should emit [ExchangeFormState] with swapped currencies and amounts when rate is null',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        baseCurrency: tBaseCurrency,
        targetCurrency: tTargetCurrency,
        baseAmount: 1,
        targetAmount: 2,
      ),
      act: (cubit) => cubit.swapCurrencies(),
      expect: () => [
        const ExchangeFormState(
          baseCurrency: tTargetCurrency,
          targetCurrency: tBaseCurrency,
          baseAmount: 2,
          targetAmount: 1,
        ),
      ],
    );
  });

  group('getExchangeRate', () {
    const tBaseCurrency = Currency(
      code: 'USD',
      name: 'United States Dollar',
      symbol: '\$',
    );

    const tTargetCurrency = Currency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
    );

    void setUpSuccessfulRepositoryCall() {
      when(
        () => mockCurrencyExchangeRepository.getExchangeRate(
          fromCurrencyCode: any(named: 'fromCurrencyCode'),
          toCurrencyCode: any(named: 'toCurrencyCode'),
        ),
      ).thenAnswer((_) async => const Right(2.0));
    }

    blocTest(
      'should call getExchangeRate from the repository',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        baseCurrency: tBaseCurrency,
        targetCurrency: tTargetCurrency,
      ),
      setUp: setUpSuccessfulRepositoryCall,
      act: (cubit) {
        cubit.getExchangeRate();
      },
      verify: (_) {
        verify(
          () => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: tBaseCurrency.code,
            toCurrencyCode: tTargetCurrency.code,
          ),
        ).called(1);
      },
    );

    blocTest(
      'should emit [ExchangeFormState(isLoading: true), ExchangeFormState(isLoading:false, rate: 1.0)] when the call to getExchangeRate is successful',
      build: () => cubit,
      seed: () => ExchangeFormState(
        baseCurrency: tBaseCurrency,
        targetCurrency: tTargetCurrency,
        failure: GetExchangeRateFailure(),
      ),
      setUp: setUpSuccessfulRepositoryCall,
      act: (cubit) {
        cubit.getExchangeRate();
      },
      expect: () => [
        ExchangeFormState(
          isLoading: true,
          baseCurrency: tBaseCurrency,
          targetCurrency: tTargetCurrency,
          failure: GetExchangeRateFailure(),
        ),
        const ExchangeFormState(
          isLoading: false,
          baseCurrency: tBaseCurrency,
          targetCurrency: tTargetCurrency,
          baseAmount: 1,
          targetAmount: 2,
          rate: 2.0,
        ),
      ],
    );

    blocTest(
      'should emit [ExchangeFormState(isLoading: true), ExchangeFormState(isLoading:false, failure: Failure)] when the call to getExchangeRate is unsuccessful',
      build: () => cubit,
      seed: () => const ExchangeFormState(
        baseCurrency: tBaseCurrency,
        targetCurrency: tTargetCurrency,
      ),
      setUp: () {
        when(
          () => mockCurrencyExchangeRepository.getExchangeRate(
            fromCurrencyCode: tBaseCurrency.code,
            toCurrencyCode: tTargetCurrency.code,
          ),
        ).thenAnswer((_) async => Left(GetExchangeRateFailure()));
      },
      act: (cubit) {
        cubit.getExchangeRate();
      },
      expect: () => [
        const ExchangeFormState(
          isLoading: true,
          baseCurrency: tBaseCurrency,
          targetCurrency: tTargetCurrency,
        ),
        ExchangeFormState(
          isLoading: false,
          baseCurrency: tBaseCurrency,
          targetCurrency: tTargetCurrency,
          failure: GetExchangeRateFailure(),
        ),
      ],
    );
  });
}
