import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.product,
    required this.installmentPlan,
    required this.status,
    required this.createdAt,
  });

  final int id;
  final Product product;
  final AvailablePlan installmentPlan;
  final String status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    product,
    installmentPlan,
    status,
    createdAt,
  ];
}
