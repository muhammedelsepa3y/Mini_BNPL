part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  const ProductsLoaded({
    required this.products,
    required this.installments,
  });

  final List<Product> products;
  final List<AvailablePlanModel> installments;

  @override
  List<Object?> get props => [products, installments];
}

class ProductsError extends ProductsState {
  const ProductsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
