import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_currency_exchange/app/features/exchange/errors/exchange_failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/pages/cubits/api_quota/api_quota_cubit.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCurrencyExchangeRepository extends Mock
    implements CurrencyExchangeRepository {}

void main() {
  late MockCurrencyExchangeRepository mockCurrencyExchangeRepository;
  late APIQuotaCubit cubit;

  setUp(() {
    mockCurrencyExchangeRepository = MockCurrencyExchangeRepository();
    cubit = APIQuotaCubit(mockCurrencyExchangeRepository);
  });

  test('initial state should be APIQuotaInitial', () {
    expect(cubit.state, APIQuotaInitial());
  });

  group('getApiQuota', () {
    const tCurrencyExchangeAPIQuota = CurrencyExchangeAPIQuota(
      total: 300,
      used: 21,
      remaining: 279,
    );

    void setUpSuccessfulRepositoryCall() {
      when(() => mockCurrencyExchangeRepository.getAPIQuota())
          .thenAnswer((_) async => const Right(tCurrencyExchangeAPIQuota));
    }

    blocTest(
      'should call CurrencyExchangeRepository.getAPIQuota',
      setUp: setUpSuccessfulRepositoryCall,
      build: () => cubit,
      act: (cubit) => cubit.getApiQuota(),
      verify: (_) {
        verify(() => mockCurrencyExchangeRepository.getAPIQuota()).called(1);
      },
    );

    blocTest(
      'should emit [APIQuotaLoading, APIQuotaLoaded] when the call to repository is successful',
      setUp: setUpSuccessfulRepositoryCall,
      build: () => cubit,
      act: (cubit) => cubit.getApiQuota(),
      expect: () => [
        APIQuotaLoading(),
        const APIQuotaLoaded(tCurrencyExchangeAPIQuota),
      ],
    );

    blocTest(
      'should emit [APIQuotaLoading, APIQuotaFailed] when the call to repository is unsuccessful',
      setUp: () {
        when(() => mockCurrencyExchangeRepository.getAPIQuota())
            .thenAnswer((_) async => Left(GetAPIQuotaFailure()));
      },
      build: () => cubit,
      act: (cubit) => cubit.getApiQuota(),
      expect: () => [
        APIQuotaLoading(),
        APIQuotaFailed(GetAPIQuotaFailure()),
      ],
    );
  });

  group('incrementUsage', () {
    const tCurrencyExchangeAPIQuota = CurrencyExchangeAPIQuota(
      total: 300,
      used: 21,
      remaining: 279,
    );

    blocTest<APIQuotaCubit, APIQuotaState>(
      'should emit [APIQuotaLoaded] with updated quota when state is APIQuotaLoaded',
      build: () => cubit,
      seed: () => const APIQuotaLoaded(tCurrencyExchangeAPIQuota),
      act: (cubit) => cubit.incrementUsage(),
      expect: () => [
        APIQuotaLoaded(
          CurrencyExchangeAPIQuota(
            total: tCurrencyExchangeAPIQuota.total,
            used: tCurrencyExchangeAPIQuota.used + 1,
            remaining: tCurrencyExchangeAPIQuota.remaining - 1,
          ),
        ),
      ],
    );

    blocTest<APIQuotaCubit, APIQuotaState>(
      'should not emit any state when state is not APIQuotaLoaded',
      build: () => cubit,
      seed: () => APIQuotaInitial(),
      act: (cubit) => cubit.incrementUsage(),
      expect: () => [],
    );
  });
}
