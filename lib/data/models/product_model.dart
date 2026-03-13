import '../../domain/entities/product.dart';
import 'available_plan_model.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.availablePlans,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      availablePlans: (json['available_plans'] as List<dynamic>?)
              ?.map((e) => AvailablePlanModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price.toStringAsFixed(2),
      'image_url': imageUrl,
      'available_plans': availablePlans.map((e) => (e as AvailablePlanModel).toJson()).toList(),
    };
  }
}
