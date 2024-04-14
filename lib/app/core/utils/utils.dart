import 'package:equatable/equatable.dart';

class Optional<T> extends Equatable {
  final bool isSome;
  final T? _value;

  /// Used for default value
  const Optional()
      : isSome = false,
        _value = null;

  const Optional.value(this._value) : isSome = true;

  T? valueOrElse(T? elseValue) => isSome ? _value : elseValue;

  @override
  List<Object?> get props => [isSome, _value];
}
