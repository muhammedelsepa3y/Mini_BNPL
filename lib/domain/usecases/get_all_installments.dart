import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllInstallments
    implements UseCase<List<AvailablePlanModel>, NoParams> {
  GetAllInstallments(this.repository);

  final BnplRepository repository;

  @override
  Future<Either<AppException, List<AvailablePlanModel>>> call(NoParams params) {
    return repository.getAllInstallments();
  }
}
