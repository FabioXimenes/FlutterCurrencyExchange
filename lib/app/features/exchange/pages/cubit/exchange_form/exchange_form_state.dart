part of 'exchange_form_cubit.dart';

final class ExchangeFormState {
  final Currency? baseCurrency;
  final Currency? targetCurrency;
  final double? rate;
  final double? baseAmount;
  final double? targetAmount;
  final bool isLoading;
  final Failure? failure;

  const ExchangeFormState({
    this.baseCurrency,
    this.targetCurrency,
    this.rate,
    this.baseAmount,
    this.targetAmount,
    this.isLoading = false,
    this.failure,
  });

  ExchangeFormState copyWith({
    Currency? baseCurrency,
    Currency? targetCurrency,
    double? rate,
    double? baseAmount,
    double? targetAmount,
    bool? isLoading,
    Optional<Failure?> failure = const Optional(),
  }) {
    return ExchangeFormState(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      rate: rate ?? this.rate,
      baseAmount: baseAmount ?? this.baseAmount,
      targetAmount: targetAmount ?? this.targetAmount,
      isLoading: isLoading ?? this.isLoading,
      failure: failure.valueOrElse(this.failure),
    );
  }
}
