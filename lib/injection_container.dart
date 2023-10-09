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

const bool isTesting = false;

/// # sl = Service Locator
final GetIt sl = GetIt.instance;

Future<void> init() async {
  await core();
  await posts();
}

Future<void> core() async {
  sl
    ..registerLazySingleton<HttpService>(() => HttpServiceDioImpl(sl()))
    ..registerLazySingleton<NetworkInfo>(
      () => NetworkInfoInternetConnectionCheckerImpl(sl()),
    )
    ..registerLazySingleton<LocalPersistentStorage>(
      () => LocalPersistentStorageSharedPreferencesImpl(sl()),
    );
}

Future<void> posts() async {
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
    ..registerLazySingleton(() => PostBloc(getPostsUseCase: sl()));
}
