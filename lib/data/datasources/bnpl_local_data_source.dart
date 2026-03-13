import 'dart:convert';
import 'package:bnpl_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/app_exception.dart';
import '../models/available_plan_model.dart';
import '../models/product_model.dart';

abstract class BnplLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<ProductModel> getProductDetails(int id);
  Future<void> cacheProducts(List<ProductModel> productsToCache);
  Future<List<AvailablePlanModel>> getLastInstallments();
  Future<void> cacheInstallments(List<AvailablePlanModel> installmentsToCache);

}


class BnplLocalDataSourceImpl implements BnplLocalDataSource {
  final SharedPreferences sharedPreferences;

  BnplLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) {
    return sharedPreferences.setString(
      AppConstants.productsCacheKey,
      json.encode(productsToCache.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(AppConstants.productsCacheKey);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return Future.value(decodedJson.map((e) => ProductModel.fromJson(e)).toList());
    } else {
      throw AppException(message: 'No cached data present');
    }
  }

  @override
  Future<ProductModel> getProductDetails(int id) async {
    final products = await getLastProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      throw AppException(message: 'Product not found locally');
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
    final jsonString = sharedPreferences.getString(AppConstants.installmentPlansCacheKey);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return Future.value(decodedJson.map((e) => AvailablePlanModel.fromJson(e)).toList());
    } else {
      throw AppException(message: 'No cached data present');
    }
  }





}

