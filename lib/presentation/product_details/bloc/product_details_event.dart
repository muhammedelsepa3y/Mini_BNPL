part of 'product_details_bloc.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();
  @override
  List<Object> get props => [];
}

class FetchProductDetailsEvent extends ProductDetailsEvent {
  const FetchProductDetailsEvent(this.id);

  final int id;
  @override
  List<Object> get props => [id];
}
