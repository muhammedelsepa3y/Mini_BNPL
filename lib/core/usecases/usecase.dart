import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<T, Params> {
  Future<Either<AppException, T>> call(Params params);
}

class NoParams {}
