import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/app_exception.dart';
import '../models/available_plan_model.dart';
import '../models/product_model.dart';

abstract class BnplLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);
  Future<List<AvailablePlanModel>> getLastInstallmentPlans(double productPrice);
  Future<void> cacheInstallmentPlans(List<AvailablePlanModel> plansToCache, double productPrice);
}

const cachedProductsStr = 'CACHED_PRODUCTS';
const cachedPlansStr = 'CACHED_PLANS';

class BnplLocalDataSourceImpl implements BnplLocalDataSource {
  final SharedPreferences sharedPreferences;

  BnplLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheProducts(List<ProductModel> productsToCache) {
    return sharedPreferences.setString(
      cachedProductsStr,
      json.encode(productsToCache.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<ProductModel>> getLastProducts() {
    final jsonString = sharedPreferences.getString(cachedProductsStr);
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return Future.value(decodedJson.map((e) => ProductModel.fromJson(e)).toList());
    } else {
      throw AppException(message: 'No cached data present');
    }
  }

  @override
  Future<void> cacheInstallmentPlans(
      List<AvailablePlanModel> plansToCache, double productPrice) {
    // Also cache with price key just in case we need multiple products
    return sharedPreferences.setString(
      '\${cachedPlansStr}_$productPrice',
      json.encode(plansToCache.map((e) => e.toJson()).toList()),
    );
  }

  @override
  Future<List<AvailablePlanModel>> getLastInstallmentPlans(double productPrice) {
    final jsonString = sharedPreferences.getString('\${cachedPlansStr}_$productPrice');
    if (jsonString != null) {
      final List decodedJson = json.decode(jsonString);
      return Future.value(
          decodedJson.map((e) => AvailablePlanModel.fromJson(e)).toList());
    } else {
      throw AppException(message: 'No cached data present');
    }
  }
}

