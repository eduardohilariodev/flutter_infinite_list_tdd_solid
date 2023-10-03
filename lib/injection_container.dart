import 'package:get_it/get_it.dart';

const bool isTesting = false;

/// # sl = Service Locator
final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Core
  // sl.registerLazySingleton<HttpService>(
  //   () => isTesting ? MockHttpService() : HttpServiceImpl(),
  // );
}
