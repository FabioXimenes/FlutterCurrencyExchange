import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/core/errors/failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/exchange.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';

part 'latest_exchanges_state.dart';

class LatestExchangesCubit extends Cubit<LatestExchangesState> {
  final CurrencyExchangeRepository currencyRepository;

  LatestExchangesCubit(this.currencyRepository)
      : super(LatestExchangesInitial());

  Future<void> getLatestExchanges() async {
    emit(LatestExchangesLoading());

    final result = await currencyRepository.getLatestCurrencyExchanges();

    result.fold(
      (failure) => emit(LatestExchangesFailed(failure)),
      (exchanges) => emit(LatestExchangesLoaded(exchanges)),
    );
  }

  Future<void> cacheExchange(Exchange exchange) async {
    if (state is! LatestExchangesLoaded) return;

    List<Exchange> cachedExchanges =
        List.from((state as LatestExchangesLoaded).exchanges);
    cachedExchanges.add(exchange);
    cachedExchanges = cachedExchanges.length > 10
        ? cachedExchanges.sublist(1)
        : cachedExchanges;

    final result = await currencyRepository.cacheCurrencyExchanges(
      cachedExchanges,
    );

    result.fold(
      (l) => null,
      (_) => emit(LatestExchangesLoaded(cachedExchanges)),
    );
  }
}
