import 'package:flutter_currency_exchange/app/core/clients/local_storage_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late SharedPreferencesStorageClient localStorageClient;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localStorageClient = SharedPreferencesStorageClient(mockSharedPreferences);
  });

  group('get', () {
    test(
      'should return a String from SharedPreferences when the key is found',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString('key')).thenReturn('value');

        // act
        final result = await localStorageClient.get('key');

        // assert
        expect(result, 'value');
        verify(() => mockSharedPreferences.getString('key')).called(1);
      },
    );

    test(
      'should return null if the key is not found',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString('key')).thenReturn(null);

        // act
        final result = await localStorageClient.get('key');

        // assert
        expect(result, null);
        verify(() => mockSharedPreferences.getString('key')).called(1);
      },
    );

    test(
      'should throw an exception when SharedPreferences throws an exception',
      () async {
        // arrange
        when(() => mockSharedPreferences.getString('key'))
            .thenThrow(Exception());

        // act
        final call = localStorageClient.get;

        // assert
        expect(() => call('key'), throwsException);
      },
    );
  });

  group('set', () {
    test(
      'should return true when SharedPreferences sets the value',
      () async {
        // arrange
        when(() => mockSharedPreferences.setString('key', 'value'))
            .thenAnswer((_) async => true);

        // act
        final result = await localStorageClient.set('key', 'value');

        // assert
        expect(result, true);
        verify(() => mockSharedPreferences.setString('key', 'value')).called(1);
      },
    );

    test(
      'should return false when SharedPreferences fails to set the value',
      () async {
        // arrange
        when(() => mockSharedPreferences.setString('key', 'value'))
            .thenAnswer((_) async => false);

        // act
        final result = await localStorageClient.set('key', 'value');

        // assert
        expect(result, false);
        verify(() => mockSharedPreferences.setString('key', 'value')).called(1);
      },
    );

    test(
      'should throw an exception when SharedPreferences throws an exception',
      () async {
        // arrange
        when(() => mockSharedPreferences.setString('key', 'value'))
            .thenThrow(Exception());

        // act
        final call = localStorageClient.set;

        // assert
        expect(() => call('key', 'value'), throwsException);
      },
    );
  });
}
