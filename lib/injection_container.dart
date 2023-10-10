import 'package:dio/dio.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/http_service_dio_impl.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/network_info.dart';
import 'package:flutter_infinite_list_tdd_solid/core/network/network_info_internet_connection_checker_impl.dart';
import 'package:flutter_infinite_list_tdd_solid/core/storage/local_persistent_storage.dart';
import 'package:flutter_infinite_list_tdd_solid/core/storage/local_persistent_storage_shared_preferences_impl.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_local_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/data/repositories/post_repository_impl.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/repositories/post_repository.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/domain/usecases/get_posts_use_case.dart';
import 'package:flutter_infinite_list_tdd_solid/features/posts/presentation/bloc/post_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

const bool isTesting = false;

/// # sl = Service Locator
final GetIt sl = GetIt.instance;

Future<void> init() async {
  await external();

  core();
  posts();
}

Future<void> external() async {
  sl
    ..registerLazySingletonAsync<SharedPreferences>(
      () async {
        final sh = await SharedPreferences.getInstance();
        return sh;
      },
    )
    ..registerLazySingletonAsync(() async => Dio())
    ..registerLazySingletonAsync<InternetConnectionChecker>(
      () async => InternetConnectionChecker(),
    );
  await sl.isReady<SharedPreferences>();
  await sl.isReady<Dio>();
  await sl.isReady<InternetConnectionChecker>();
}

void core() {
  sl
    ..registerLazySingleton<HttpService>(() => HttpServiceDioImpl(sl()))
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoInternetConnectionCheckerImpl(sl()),
    )
    ..registerLazySingleton<LocalPersistentStorage>(
      () => LocalPersistentStorageSharedPreferencesImpl(sl()),
    );
}

void posts() {
  sl
    // Data
    ..registerLazySingleton<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<PostRepository>(
      () => PostRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
        networkInfo: sl(),
      ),
    )
    // Domain
    ..registerLazySingleton(() => GetPostsUseCase(sl()))
    // Presentation
    ..registerFactory(() => PostBloc(getPostsUseCase: sl()));
}
