import 'package:dartz/dartz.dart';
import '../network/app_exception.dart';

abstract class UseCase<T, Params> {
  Future<Either<AppException, T>> call(Params params);
}

class NoParams {}
