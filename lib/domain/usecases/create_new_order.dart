import 'package:dartz/dartz.dart';

import '../../core/network/app_exception.dart';
import '../../core/usecases/usecase.dart';
import '../repositiories/bnpl_repository.dart';

class CreateOrderParams {
  final int productId;
  final int planId;
  CreateOrderParams({required this.productId, required this.planId});
}

class CreateOrder implements UseCase<int, CreateOrderParams> {
  final BnplRepository repository;

  CreateOrder(this.repository);

  @override
  Future<Either<AppException, int>> call(CreateOrderParams params) async {
    return await repository.createOrder(params.productId, params.planId);
  }
}
