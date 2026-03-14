import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:dartz/dartz.dart';

class CheckCardParams {
  CheckCardParams({required this.cardDetails});

  final Map<String, dynamic> cardDetails;
}

class CheckPaymentCard implements UseCase<bool, CheckCardParams> {
  CheckPaymentCard(this.repository);

  final BnplRepository repository;

  @override
  Future<Either<AppException, bool>> call(CheckCardParams params) {
    return repository.checkCard(params.cardDetails);
  }
}
