import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:dartz/dartz.dart';
import '../../core/usecases/usecase.dart';
import '../entities/product.dart';
import '../repositiories/bnpl_repository.dart';

class GetAllInstallments implements UseCase<List<AvailablePlanModel>, NoParams> {
  final BnplRepository repository;

  GetAllInstallments(this.repository);

  @override
  Future<Either<AppException, List<AvailablePlanModel>>> call(NoParams params) {
    return repository.getAllInstallments();
  }
}
