import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/network_service.dart';
import '../data/datasources/bnpl_local_data_source.dart';
import '../data/datasources/bnpl_remote_data_source.dart';
import '../data/repositories/bnpl_repository_impl.dart';
import '../domain/repositiories/bnpl_repository.dart';
import '../domain/usecases/get_all_installments.dart';
import '../domain/usecases/get_all_products.dart';
import '../presentation/products/bloc/products_bloc.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // Features - Products
  // Bloc
  sl.registerFactory(
    () => ProductsBloc(
      getAllProducts: sl(),
      getAllInstallments: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetAllInstallments(sl()));

  // Repository
  sl.registerLazySingleton<BnplRepository>(
    () => BnplRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<BnplRemoteDataSource>(
    () => BnplRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<BnplLocalDataSource>(
    () => BnplLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton(() => NetworkService());

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
