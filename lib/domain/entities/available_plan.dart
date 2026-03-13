import 'package:equatable/equatable.dart';

class AvailablePlan extends Equatable {
  final int id;
  final String name;
  final int durationMonths;
  final double interestRate;

  const AvailablePlan({
    required this.id,
    required this.name,
    required this.durationMonths,
    required this.interestRate,
  });

  @override
  List<Object?> get props => [id, name, durationMonths, interestRate];
}
