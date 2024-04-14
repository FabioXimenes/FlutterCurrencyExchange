import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/currencies/currencies_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyExchangeRepository extends Mock
    implements CurrencyExchangeRepository {}

void main() {
  late MockCurrencyExchangeRepository mockCurrencyExchangeRepository;
  late CurrenciesCubit cubit;

  setUp(() {
    mockCurrencyExchangeRepository = MockCurrencyExchangeRepository();
    cubit = CurrenciesCubit(mockCurrencyExchangeRepository);
  });

  test('initial state should be CurrenciesInitial', () {
    expect(cubit.state, CurrenciesInitial());
  });

  group('loadCurrencies', () {
    const tCurrencies = [
      Currency(code: 'code', name: 'name', symbol: 'symbol')
    ];
    void setUpSuccessfulRepositoryCall() {
      when(() => mockCurrencyExchangeRepository.getCurrencies())
          .thenAnswer((_) async => const Right(tCurrencies));
    }

    blocTest(
      'should call CurrencyExchangeRepository.getCurrencies',
      setUp: setUpSuccessfulRepositoryCall,
      build: () => cubit,
      act: (cubit) => cubit.loadCurrencies(),
      verify: (_) {
        verify(() => mockCurrencyExchangeRepository.getCurrencies()).called(1);
      },
    );

    blocTest(
      'should emit [CurrenciesLoading, CurrenciesLoaded] when the call to repository is successful',
      setUp: setUpSuccessfulRepositoryCall,
      build: () => cubit,
      act: (cubit) => cubit.loadCurrencies(),
      expect: () => [
        CurrenciesLoading(),
        const CurrenciesLoaded(tCurrencies),
      ],
    );

    blocTest(
      'should emit [CurrenciesLoading, CurrenciesFailed] when the call to repository is unsuccessful',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.getCurrencies())
            .thenAnswer((_) async => Left(GetCurrenciesFailure()));
      },
      build: () => cubit,
      act: (cubit) => cubit.loadCurrencies(),
      expect: () => [
        CurrenciesLoading(),
        CurrenciesFailed(GetCurrenciesFailure()),
      ],
    );
  });
}
