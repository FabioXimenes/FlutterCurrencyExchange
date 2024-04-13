import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_exchange_api_quota.g.dart';

@JsonSerializable(createToJson: false)
class CurrencyExchangeAPIQuota extends Equatable {
  const CurrencyExchangeAPIQuota({
    required this.total,
    required this.used,
    required this.remaining,
  });

  final int total;
  final int used;
  final int remaining;

  factory CurrencyExchangeAPIQuota.fromJson(Map<String, dynamic> json) =>
      _$CurrencyExchangeAPIQuotaFromJson(json);

  @override
  List<Object?> get props => [total, used, remaining];
}
