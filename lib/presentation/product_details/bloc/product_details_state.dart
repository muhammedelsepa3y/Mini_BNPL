part of 'product_details_bloc.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  const ProductDetailsLoaded({
    required this.product,
  });

  final Product product;

  @override
  List<Object> get props => [product];
}

class ProductDetailsError extends ProductDetailsState {
  const ProductDetailsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
