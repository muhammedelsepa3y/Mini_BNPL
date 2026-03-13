import '../../domain/entities/available_plan.dart';

class AvailablePlanModel extends AvailablePlan {
  const AvailablePlanModel({
    required super.id,
    required super.name,
    required super.durationMonths,
    required super.interestRate,
  });

  factory AvailablePlanModel.fromJson(Map<String, dynamic> json) {
    return AvailablePlanModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? '',
      durationMonths: json['duration_months'] is int ? json['duration_months'] as int : int.tryParse(json['duration_months'].toString()) ?? 0,
      interestRate: double.tryParse(json['interest_rate'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration_months': durationMonths,
      'interest_rate': interestRate.toStringAsFixed(2),
    };
  }
}
