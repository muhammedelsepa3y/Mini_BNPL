import 'package:bnpl_app/data/models/available_plan_model.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/network/network_service.dart';
import '../models/product_model.dart';

abstract class BnplRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductDetails(int id);
  Future<List<AvailablePlanModel>> getAllInstallments();
  Future<int> createOrder(int productId, int planId);
  Future<bool> checkCard(Map<String, dynamic> cardDetails);
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

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await networkService.get(ApiEndpoints.productDetails(id));
    final data = response is Map ? response['data'] ?? response : response;
    return ProductModel.fromJson(data);
  }

  @override
  Future<int> createOrder(int productId, int planId) async {
    final response = await networkService.post(
      ApiEndpoints.orders,
      data: {
        "product": productId,
        "installment_plan": planId,
      },
    );
    final data = response is Map ? response['data'] ?? response : response;
    return data['id'] as int;
  }

  @override
  Future<bool> checkCard(Map<String, dynamic> cardDetails) async {
    final response = await networkService.post(
      ApiEndpoints.checkCard,
      data: cardDetails,
    );
    if (response is bool) {
      return response;
    } else if (response is Map && response.containsKey('data')) {
      return response['data'] == true;
    }
    
    return false;
  }
}
