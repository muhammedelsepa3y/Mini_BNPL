import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.availablePlans = const [],
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<AvailablePlan> availablePlans;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    availablePlans,
  ];
}
