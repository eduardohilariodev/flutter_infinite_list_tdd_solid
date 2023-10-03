import 'package:flutter_infinite_list_tdd_solid/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfo;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();

    /// Calling NetworkInfo().isConnected is really only a nickname for calling
    /// DataConnectionChecker().hasConnection. We're simply hiding the 3rd party
    /// library behind an interface of our own class.
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('is Connected | ', () {
    test('SHOULD forward the call to InternetConnectionChecker.hasConnection',
        () async {
      // Arrange
      final tHasConnectionFuture = Future.value(true);

      when(() => mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      // Act
      // NOTICE: We're NOT awaiting the result
      final result = networkInfo.isConnected;
      // Assert
      verify(() => mockInternetConnectionChecker.hasConnection);
      // Utilizing Dart's default referential equality.
      // Only references to the same object are equal.
      expect(result, tHasConnectionFuture);
    });
  });
}
