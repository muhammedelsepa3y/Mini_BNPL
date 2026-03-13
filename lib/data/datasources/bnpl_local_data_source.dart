import 'dart:convert';
import 'package:bnpl_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/app_exception.dart';
import '../models/available_plan_model.dart';
import '../models/product_model.dart';

abstract class BnplLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> productsToCache);

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

}

