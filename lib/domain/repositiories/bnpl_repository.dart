import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:dartz/dartz.dart';

import '../entities/product.dart';


abstract class BnplRepository {
  Future<Either<AppException, List<Product>>> getAllProducts();
}
