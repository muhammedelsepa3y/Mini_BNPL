import 'package:equatable/equatable.dart';
import 'available_plan.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<AvailablePlan> availablePlans;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.availablePlans = const [],
  });

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, availablePlans];
}
