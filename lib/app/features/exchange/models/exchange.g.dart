// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exchange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exchange _$ExchangeFromJson(Map<String, dynamic> json) => Exchange(
      fromCurrency:
          Currency.fromJson(json['fromCurrency'] as Map<String, dynamic>),
      toCurrency: Currency.fromJson(json['toCurrency'] as Map<String, dynamic>),
      fromAmount: (json['fromAmount'] as num).toDouble(),
      toAmount: (json['toAmount'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$ExchangeToJson(Exchange instance) => <String, dynamic>{
      'fromCurrency': instance.fromCurrency.toJson(),
      'toCurrency': instance.toCurrency.toJson(),
      'fromAmount': instance.fromAmount,
      'toAmount': instance.toAmount,
      'rate': instance.rate,
    };
