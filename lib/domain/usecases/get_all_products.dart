import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:dartz/dartz.dart';
import '../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositiories/bnpl_repository.dart';

class GetAllProducts implements UseCase<List<Product>, NoParams> {
  final BnplRepository repository;

  GetAllProducts(this.repository);

  @override
  Future<Either<AppException, List<Product>>> call(NoParams params) {
    return repository.getAllProducts();
  }
}
