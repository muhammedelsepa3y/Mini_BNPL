import 'dart:convert';

import 'package:bnpl_app/core/constants/app_constants.dart';
import 'package:bnpl_app/core/network/app_exception.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/data/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BnplLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<ProductModel> getProductDetails(int id);
  Future<void> cacheProducts(List<ProductModel> productsToCache);
  Future<List<AvailablePlanModel>> getLastInstallments();
  Future<void> cacheInstallments(List<AvailablePlanModel> installmentsToCache);
}

class BnplLocalDataSourceImpl implements BnplLocalDataSource {
  BnplLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) {
    return sharedPreferences.setString(
      AppConstants.productsCacheKey,
      json.encode(productsToCache.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(
      AppConstants.productsCacheKey,
    );
    if (jsonString != null) {
      final decodedJson = json.decode(jsonString) as List<dynamic>;
      return Future.value(
        decodedJson
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      throw const AppException(message: 'No cached data present');
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final products = await getLastProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } on Exception catch (_) {
      throw const AppException(message: 'Product not found locally');
    }
  }

  @override
  Future<void> cacheInstallments(List<AvailablePlanModel> installmentsToCache) {
    return sharedPreferences.setString(
      AppConstants.installmentPlansCacheKey,
      json.encode(installmentsToCache.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<AvailablePlanModel>> getLastInstallments() {
    final jsonString = sharedPreferences.getString(
      AppConstants.installmentPlansCacheKey,
    );
    if (jsonString != null) {
      final decodedJson = json.decode(jsonString) as List<dynamic>;
      return Future.value(
        decodedJson
            .map((e) => AvailablePlanModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } else {
      throw const AppException(message: 'No cached data present');
    }
  }
}
