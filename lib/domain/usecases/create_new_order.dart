import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart';

class CreateOrderParams {
  CreateOrderParams({required this.productId, required this.planId});

  final int productId;
  final int planId;
}

class CreateNewOrder implements UseCase<int, CreateOrderParams> {
  CreateNewOrder(this.repository);

  final BnplRepository repository;

  @override
  Future<Either<AppException, int>> call(CreateOrderParams params) {
    return repository.createOrder(params.productId, params.planId);
  }
}
