import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/entities/order.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart' hide Order;

class GetOrders implements UseCase<List<Order>, NoParams> {
  const GetOrders(this.repository);

  final BnplRepository repository;

  @override
  Future<Either<AppException, List<Order>>> call(NoParams params) {
    return repository.getOrders();
  }
}
