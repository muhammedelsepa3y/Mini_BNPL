import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static String baseUrl = dotenv.get('BASE_URL', fallback: 'http://16.170.208.60/api/v1');
  static const String products = '/products/';
  static const String installmentPlans = '/installment-plans/';
  static String productDetails(int id) => '/products/$id/';
  static const String checkCard = '/payments/check-card/';
  static const String orders = '/orders/';
  static String orderDetails(int id) => '/orders/$id/';
}
