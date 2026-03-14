import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart';

class GetProductDetails implements UseCase<Product, int> {
  GetProductDetails(this.repository);

  final BnplRepository repository;

  @override
  Future<Either<AppException, Product>> call(int id) {
    return repository.getProductDetails(id);
  }
}
