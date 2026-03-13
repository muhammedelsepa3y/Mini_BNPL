import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/network_service.dart';
import '../data/datasources/bnpl_local_data_source.dart';
import '../data/datasources/bnpl_remote_data_source.dart';
import '../data/repositories/bnpl_repository_impl.dart';
import '../domain/repositiories/bnpl_repository.dart';
import '../domain/usecases/get_all_installments.dart';
import '../domain/usecases/get_all_products.dart';
import '../domain/usecases/get_product_details.dart';
import '../presentation/products/bloc/products_bloc.dart';
import '../presentation/product_details/bloc/product_details_bloc.dart';
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => ProductsBloc(
      getAllProducts: sl(),
      getAllInstallments: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductDetailsBloc(
      getProductDetails: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetAllProducts(sl()));
  sl.registerLazySingleton(() => GetAllInstallments(sl()));
  sl.registerLazySingleton(() => GetProductDetails(sl()));

  sl.registerLazySingleton<BnplRepository>(
    () => BnplRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<BnplRemoteDataSource>(
    () => BnplRemoteDataSourceImpl(networkService: sl()),
  );

  sl.registerLazySingleton<BnplLocalDataSource>(
    () => BnplLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton(() => NetworkService());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
