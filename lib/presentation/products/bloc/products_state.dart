part of 'products_bloc.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  ProductsLoaded({
    required this.products,
    required this.installments,
  });

  final List<Product> products;
  final List<AvailablePlanModel> installments;
}

class ProductsError extends ProductsState {
  ProductsError(this.message);

  final String message;
}
