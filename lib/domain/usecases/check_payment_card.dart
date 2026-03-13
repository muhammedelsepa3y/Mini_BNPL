import 'package:dartz/dartz.dart';

import '../../core/network/app_exception.dart';
import '../../core/usecases/usecase.dart';
import '../repositiories/bnpl_repository.dart';

class CheckCardParams {
  final Map<String, dynamic> cardDetails;
  CheckCardParams({required this.cardDetails});
}

class CheckCard implements UseCase<bool, CheckCardParams> {
  final BnplRepository repository;

  CheckCard(this.repository);

  @override
  Future<Either<AppException, bool>> call(CheckCardParams params) async {
    return await repository.checkCard(params.cardDetails);
  }
}
