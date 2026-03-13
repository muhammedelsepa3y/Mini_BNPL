import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositiories/bnpl_repository.dart';
import '../datasources/bnpl_remote_data_source.dart';
import '../datasources/bnpl_local_data_source.dart';

class BnplRepositoryImpl implements BnplRepository {
  final BnplRemoteDataSource remoteDataSource;
  final BnplLocalDataSource localDataSource;

  BnplRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<AppException, List<Product>>> getAllProducts() async {
    try {
      final remoteProducts = await remoteDataSource.getAllProducts();
      await localDataSource.cacheProducts(remoteProducts);
      return Right(remoteProducts);
    } catch (e) {
      try {
        final localProducts = await localDataSource.getLastProducts();
        return Right(localProducts);
      } catch (localError) {
        if (e is AppException) return Left(e);
        return Left(AppException.unknown(e));
      }
    }
  }

  @override
  Future<Either<AppException, List<AvailablePlanModel>>> getAllInstallments() async{
    try {
      final remoteInstallments = await remoteDataSource.getAllInstallments();
      await localDataSource.cacheInstallments(remoteInstallments);
      return Right(remoteInstallments);
    } catch (e) {
      try {
        final localInstallments = await localDataSource.getLastInstallments();
        return Right(localInstallments);
      } catch (localError) {
        if (e is AppException) return Left(e);
        return Left(AppException.unknown(e));
      }
    }
  }

}
