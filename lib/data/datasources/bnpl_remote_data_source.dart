import 'package:bnpl_app/data/models/available_plan_model.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/network_service.dart';
import '../models/product_model.dart';

abstract class BnplRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<List<AvailablePlanModel>> getAllInstallments();
}

class BnplRemoteDataSourceImpl implements BnplRemoteDataSource {
  final NetworkService networkService;

  BnplRemoteDataSourceImpl({required this.networkService});

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await networkService.get(ApiEndpoints.products);
    final List<dynamic> dataList = response is List ? response : (response['data'] ?? []);
    return dataList.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<List<AvailablePlanModel>> getAllInstallments() async{
    final response = await networkService.get(ApiEndpoints.installmentPlans);
    final List<dynamic> dataList = response is List ? response : (response['data'] ?? []);
    return dataList.map((json) => AvailablePlanModel.fromJson(json)).toList();
  }
}
