import 'package:bnpl_app/core/network/network_service.dart';
import 'package:bnpl_app/data/datasources/bnpl_local_data_source.dart';
import 'package:bnpl_app/data/datasources/bnpl_remote_data_source.dart';
import 'package:bnpl_app/data/repositories/bnpl_repository_impl.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:bnpl_app/domain/usecases/check_payment_card.dart';
import 'package:bnpl_app/domain/usecases/create_new_order.dart';
import 'package:bnpl_app/domain/usecases/get_all_installments.dart';
import 'package:bnpl_app/domain/usecases/get_all_products.dart';
import 'package:bnpl_app/domain/usecases/get_orders.dart';
import 'package:bnpl_app/domain/usecases/get_product_details.dart';
import 'package:bnpl_app/presentation/order_flow/bloc/order_flow_bloc.dart';
import 'package:bnpl_app/presentation/orders/bloc/orders_bloc.dart';
import 'package:bnpl_app/presentation/product_details/bloc/product_details_bloc.dart';
import 'package:bnpl_app/presentation/products/bloc/products_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory(
      () => ProductsBloc(
        getAllProducts: sl(),
        getAllInstallments: sl(),
      ),
    )
    ..registerFactory(
      () => ProductDetailsBloc(
        getProductDetails: sl(),
      ),
    )
    ..registerFactory(
      () => OrderFlowBloc(
        createOrder: sl(),
        checkCard: sl(),
      ),
    )
    ..registerLazySingleton(
      () => OrdersBloc(
        getOrders: sl(),
      ),
    )
    ..registerLazySingleton(() => GetAllProducts(sl()))
    ..registerLazySingleton(() => GetAllInstallments(sl()))
    ..registerLazySingleton(() => GetProductDetails(sl()))
    ..registerLazySingleton(() => CreateNewOrder(sl()))
    ..registerLazySingleton(() => CheckPaymentCard(sl()))
    ..registerLazySingleton(() => GetOrders(sl()))
    ..registerLazySingleton<BnplRepository>(
      () => BnplRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<BnplRemoteDataSource>(
      () => BnplRemoteDataSourceImpl(networkService: sl()),
    )
    ..registerLazySingleton<BnplLocalDataSource>(
      () => BnplLocalDataSourceImpl(sharedPreferences: sl()),
    )
    ..registerLazySingleton(NetworkService.new);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
