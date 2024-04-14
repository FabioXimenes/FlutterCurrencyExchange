import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/core/errors/failures.dart';
import 'package:flutter_currency_exchange/app/core/utils/utils.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';

part 'exchange_form_state.dart';

class ExchangeFormCubit extends Cubit<ExchangeFormState> {
  final CurrencyExchangeRepository currencyRepository;

  ExchangeFormCubit(this.currencyRepository) : super(const ExchangeFormState());

  void setBaseCurrency(Currency currency) {
    emit(state.copyWith(
      baseCurrency: currency,
    ));

    if (state.targetCurrency != null) {
      getExchangeRate();
    }
  }

  void setTargetCurrency(Currency currency) {
    emit(state.copyWith(
      targetCurrency: currency,
    ));

    if (state.baseCurrency != null) {
      getExchangeRate();
    }
  }

  void setBaseAmount(double amount) {
    emit(state.copyWith(
      baseAmount: amount,
      targetAmount:
          state.targetCurrency != null ? amount * (state.rate ?? 1) : null,
    ));
  }

  void setTargetAmount(double amount) {
    emit(state.copyWith(
      targetAmount: amount,
      baseAmount:
          state.baseCurrency != null ? amount / (state.rate ?? 1) : null,
    ));
  }

  void swapCurrencies() {
    emit(
      state.copyWith(
        baseCurrency: state.targetCurrency,
        targetCurrency: state.baseCurrency,
        baseAmount: state.targetAmount,
        targetAmount: state.baseAmount,
        rate: state.rate == null ? null : 1 / (state.rate!),
      ),
    );
  }

  Future<void> getExchangeRate() async {
    emit(state.copyWith(isLoading: true));

    final result = await currencyRepository.getExchangeRate(
      fromCurrencyCode: state.baseCurrency!.code,
      toCurrencyCode: state.targetCurrency!.code,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          failure: Optional.value(failure),
        ),
      ),
      (rate) {
        emit(
          state.copyWith(
            isLoading: false,
            rate: rate,
            baseAmount: state.baseAmount ?? 1,
            targetAmount: (state.baseAmount ?? 1) * rate,
            failure: const Optional.value(null),
          ),
        );
      },
    );
  }
}
