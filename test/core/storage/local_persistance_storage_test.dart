import 'package:flutter_infinite_list_tdd_solid/core/storage/local_persistent_storage_shared_preferences_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late LocalPersistentStorageSharedPreferencesImpl localPersistentStorage;
  const tKey = 'some_key';
  const tValue = 'some_value';

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localPersistentStorage =
        LocalPersistentStorageSharedPreferencesImpl(mockSharedPreferences);
  });

  group('getString | ', () {
    test(
      'SHOULD return a value WHEN SharedPreferences IS called',
      () async {
        // Arrange
        when(() => mockSharedPreferences.getString(tKey)).thenReturn(tValue);
        // Act
        final result = localPersistentStorage.getString(tKey);
        // Assert
        verify(() => mockSharedPreferences.getString(tKey));
        expect(result, equals(tValue));
      },
    );
  });
  group('setString', () {
    test('SHOULD call SharedPreferences', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(tKey, tValue))
          .thenAnswer((_) async => true);

      // Act
      await localPersistentStorage.setString(tKey, tValue);

      // Assert
      verify(() => mockSharedPreferences.setString(tKey, tValue));
    });
  });
}
