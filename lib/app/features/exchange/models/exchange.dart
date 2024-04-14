import 'package:equatable/equatable.dart';
import 'package:flutter_currency_exchange/app/features/exchange/models/currency.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange.g.dart';

@JsonSerializable(explicitToJson: true)
class Exchange extends Equatable {
  final Currency fromCurrency;
  final Currency toCurrency;
  final double fromAmount;
  final double toAmount;
  final double rate;

  const Exchange({
    required this.fromCurrency,
    required this.toCurrency,
    required this.fromAmount,
    required this.toAmount,
    required this.rate,
  });

  factory Exchange.fromJson(Map<String, dynamic> json) =>
      _$ExchangeFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeToJson(this);

  @override
  List<Object?> get props => [
        fromCurrency,
        toCurrency,
        fromAmount,
        toAmount,
        rate,
      ];
}
