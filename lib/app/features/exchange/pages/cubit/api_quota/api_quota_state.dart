part of 'api_quota_cubit.dart';

sealed class APIQuotaState extends Equatable {
  const APIQuotaState();

  @override
  List<Object> get props => [];
}

final class APIQuotaInitial extends APIQuotaState {}

final class APIQuotaLoading extends APIQuotaState {}

final class APIQuotaLoaded extends APIQuotaState {
  final CurrencyExchangeAPIQuota quota;

  const APIQuotaLoaded(this.quota);

  @override
  List<Object> get props => [quota];
}

final class APIQuotaFailed extends APIQuotaState {
  final Failure failure;

  const APIQuotaFailed(this.failure);

  @override
  List<Object> get props => [failure];
}
