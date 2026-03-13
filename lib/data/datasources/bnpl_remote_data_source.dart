import '../../core/constants/api_endpoints.dart';
import '../../core/network/network_service.dart';
import '../models/product_model.dart';

abstract class BnplRemoteDataSource {
  Future<List<ProductModel>> getAllProducts();
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
}
