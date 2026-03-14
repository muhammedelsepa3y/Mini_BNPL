import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/data/datasources/bnpl_local_data_source.dart';
import 'package:bnpl_app/data/datasources/bnpl_remote_data_source.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/domain/entities/order.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart' hide Order;

class BnplRepositoryImpl implements BnplRepository {
  BnplRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final BnplRemoteDataSource remoteDataSource;
  final BnplLocalDataSource localDataSource;

  @override
  Future<Either<AppException, List<Product>>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getAllProducts();
      await localDataSource.cacheProducts(remoteProducts);
      return Right(remoteProducts);
    } on Exception catch (e) {
      try {
        final localProducts = await localDataSource.getLastProducts();
        return Right(localProducts);
      } on Exception catch (_) {
        if (e is AppException) return Left(e);
        return Left(AppException.unknown(e));
      }
    }
  }

  @override
  Future<Either<AppException, List<AvailablePlanModel>>>
  getAllInstallments() async {
    try {
      final remoteInstallments = await remoteDataSource.getAllInstallments();
      await localDataSource.cacheInstallments(remoteInstallments);
      return Right(remoteInstallments);
    } on Exception catch (e) {
      try {
        final localInstallments = await localDataSource.getLastInstallments();
        return Right(localInstallments);
      } on Exception catch (_) {
        if (e is AppException) return Left(e);
        return Left(AppException.unknown(e));
      }
    }
  }

  @override
  Future<Either<AppException, Product>> getProductDetails(int id) async {
    try {
      final remoteProduct = await remoteDataSource.getProductDetails(id);
      return Right(remoteProduct);
    } on Exception catch (e) {
      try {
        final localProduct = await localDataSource.getProductDetails(id);
        return Right(localProduct);
      } on Exception catch (_) {
        if (e is AppException) return Left(e);
        return Left(AppException.unknown(e));
      }
    }
  }

  @override
  Future<Either<AppException, int>> createOrder(
    int productId,
    int planId,
  ) async {
    try {
      final orderId = await remoteDataSource.createOrder(productId, planId);
      return Right(orderId);
    } on Exception catch (e) {
      if (e is AppException) return Left(e);
      return Left(AppException.unknown(e));
    }
  }

  @override
  Future<Either<AppException, List<Order>>> getOrders() async {
    try {
      final remoteOrders = await remoteDataSource.getOrders();
      await localDataSource.cacheOrders(remoteOrders);
      return Right(remoteOrders);
    } on Exception catch (e) {
      try {
        final localOrders = await localDataSource.getLastOrders();
        return Right(localOrders);
      } on Exception catch (_) {
        if (e is AppException) return Left(e);
        return Left(AppException.unknown(e));
      }
    }
  }

  @override
  Future<Either<AppException, bool>> checkCard(
    Map<String, dynamic> cardDetails,
  ) async {
    try {
      final result = await remoteDataSource.checkCard(cardDetails);
      return Right(result);
    } on Exception catch (e) {
      if (e is AppException) return Left(e);
      return Left(AppException.unknown(e));
    }
  }
}
