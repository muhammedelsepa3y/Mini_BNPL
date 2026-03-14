import 'package:bnpl_app/core/constants/api_endpoints.dart';
import 'package:bnpl_app/core/network/network_service.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/data/models/order_model.dart';
import 'package:bnpl_app/data/models/product_model.dart';

abstract class BnplRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductDetails(int id);
  Future<List<AvailablePlanModel>> getAllInstallments();
  Future<int> createOrder(int productId, int planId);
  Future<bool> checkCard(Map<String, dynamic> cardDetails);
  Future<List<OrderModel>> getOrders();
}

class BnplRemoteDataSourceImpl implements BnplRemoteDataSource {
  BnplRemoteDataSourceImpl({required this.networkService});

  final NetworkService networkService;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    final response = await networkService.get<dynamic>(ApiEndpoints.products);
    final dataList = response is List
        ? response
        : ((response as Map<String, dynamic>)['data'] as List<dynamic>?) ?? [];
    return dataList
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<AvailablePlanModel>> getAllInstallments() async {
    final response = await networkService.get<dynamic>(
      ApiEndpoints.installmentPlans,
    );
    final dataList = response is List
        ? response
        : ((response as Map<String, dynamic>)['data'] as List<dynamic>?) ?? [];
    return dataList
        .map(
          (json) => AvailablePlanModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final response = await networkService.get<dynamic>(
      ApiEndpoints.productDetails(id),
    );
    final data = response is Map
        ? (response as Map<String, dynamic>)['data'] ?? response
        : response;
    return ProductModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<int> createOrder(int productId, int planId) async {
    final response = await networkService.post<dynamic>(
      ApiEndpoints.orders,
      data: {
        'product': productId,
        'installment_plan': planId,
      },
    );
    final data = response is Map
        ? (response as Map<String, dynamic>)['data'] ?? response
        : response;
    return (data as Map<String, dynamic>)['id'] as int;
  }

  @override
  Future<bool> checkCard(Map<String, dynamic> cardDetails) async {
    final response = await networkService.post<dynamic>(
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

  @override
  Future<List<OrderModel>> getOrders() async {
    final response = await networkService.get<dynamic>(ApiEndpoints.orders);
    final dataList = response is List
        ? response
        : ((response as Map<String, dynamic>)['data'] as List<dynamic>?) ?? [];
    return dataList
        .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
