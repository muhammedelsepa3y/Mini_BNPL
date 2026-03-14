import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/data/models/product_model.dart';
import 'package:bnpl_app/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.product,
    required super.installmentPlan,
    required super.status,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int? ?? 0,
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
      installmentPlan: AvailablePlanModel.fromJson(
        json['installment_plan'] as Map<String, dynamic>? ?? {},
      ),
      status: json['status'] as String? ?? 'PENDING',
      createdAt:
          DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': (product as ProductModel).toJson(),
      'installment_plan': (installmentPlan as AvailablePlanModel).toJson(),
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
