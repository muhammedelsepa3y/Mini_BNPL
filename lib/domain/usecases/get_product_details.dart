import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:dartz/dartz.dart';
import '../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositiories/bnpl_repository.dart';

class GetProductDetails implements UseCase<Product, int> {
  final BnplRepository repository;

  GetProductDetails(this.repository);

  @override
  Future<Either<AppException, Product>> call(int id) {
    return repository.getProductDetails(id);
  }
}
