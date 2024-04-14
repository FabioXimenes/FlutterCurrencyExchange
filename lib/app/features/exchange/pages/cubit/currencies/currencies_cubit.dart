import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/core/errors/failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';

part 'currencies_state.dart';

class CurrenciesCubit extends Cubit<CurrenciesState> {
  final CurrencyExchangeRepository currencyRepository;

  CurrenciesCubit(this.currencyRepository) : super(CurrenciesInitial());

  Future<void> loadCurrencies() async {
    emit(CurrenciesLoading());

    final result = await currencyRepository.getCurrencies();

    result.fold(
      (failure) => emit(CurrenciesFailed(failure)),
      (currencies) => emit(CurrenciesLoaded(currencies)),
    );
  }
}
