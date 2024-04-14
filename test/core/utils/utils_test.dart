import 'package:flutter_currency_exchange/app/core/utils/utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Optional', () {
    group('valueOrElse', () {
      test('should return the value if isSome is true', () {
        const optional = Optional.value(1);

        expect(optional.valueOrElse(2), 1);
      });

      test('should return the elseValue if isSome is false', () {
        const optional = Optional<int>();

        expect(optional.valueOrElse(2), 2);
      });
    });
  });
}
