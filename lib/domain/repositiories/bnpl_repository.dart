import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/available_plan_model.dart';
import '../entities/product.dart';


abstract class BnplRepository {
  Future<Either<AppException, List<Product>>> getAllProducts();
  Future<Either<AppException, Product>> getProductDetails(int id);
  Future<Either<AppException, List<AvailablePlanModel>>> getAllInstallments();
  Future<Either<AppException, int>> createOrder(int productId, int planId);
  Future<Either<AppException, bool>> checkCard(Map<String, dynamic> cardDetails);
}
