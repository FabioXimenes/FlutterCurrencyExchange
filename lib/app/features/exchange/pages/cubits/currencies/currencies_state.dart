part of 'currencies_cubit.dart';

sealed class CurrenciesState extends Equatable {
  const CurrenciesState();

  @override
  List<Object> get props => [];
}

final class CurrenciesInitial extends CurrenciesState {}

final class CurrenciesLoading extends CurrenciesState {}

final class CurrenciesLoaded extends CurrenciesState {
  final List<Currency> currencies;

  const CurrenciesLoaded(this.currencies);

  @override
  List<Object> get props => [currencies];
}

final class CurrenciesFailed extends CurrenciesState {
  final Failure failure;

  const CurrenciesFailed(this.failure);

  @override
  List<Object> get props => [failure];
}
