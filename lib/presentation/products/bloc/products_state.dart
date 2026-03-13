part of 'products_bloc.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<AvailablePlanModel> installments;

  ProductsLoaded({
    required this.products,
    required this.installments,
  });
}

class ProductsError extends ProductsState {
  final String message;

  ProductsError(this.message);
}
