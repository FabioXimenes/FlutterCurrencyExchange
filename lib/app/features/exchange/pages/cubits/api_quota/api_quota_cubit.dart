import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_currency_exchange/app/core/errors/failures.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency_exchange_api_quota.dart';
import 'package:flutter_currency_exchange/app/features/exchange/repositories/currency_exchange_repository.dart';

part 'api_quota_state.dart';

class APIQuotaCubit extends Cubit<APIQuotaState> {
  final CurrencyExchangeRepository currencyRepository;

  APIQuotaCubit(this.currencyRepository) : super(APIQuotaInitial());

  void incrementUsage() {
    if (state is APIQuotaLoaded) {
      final quota = (state as APIQuotaLoaded).quota;
      final updatedQuota = CurrencyExchangeAPIQuota(
        total: quota.total,
        used: quota.used + 1,
        remaining: quota.remaining - 1,
      );
      emit(APIQuotaLoaded(updatedQuota));
    }
  }

  Future<void> getApiQuota() async {
    emit(APIQuotaLoading());

    final result = await currencyRepository.getAPIQuota();

    result.fold(
      (failure) => emit(APIQuotaFailed(failure)),
      (quota) => emit(APIQuotaLoaded(quota)),
    );
  }
}
