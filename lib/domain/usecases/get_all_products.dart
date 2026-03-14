import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllProducts implements UseCase<List<Product>, NoParams> {
  GetAllProducts(this.repository);

  final BnplRepository repository;

  @override
  Future<Either<AppException, List<Product>>> call(NoParams params) {
    return repository.getAllProducts();
  }
}
