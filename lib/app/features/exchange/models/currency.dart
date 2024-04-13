import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable(createToJson: false)
class Currency extends Equatable {
  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  final String code;
  final String name;
  final String symbol;

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  @override
  List<Object?> get props => [code, name, symbol];
}
