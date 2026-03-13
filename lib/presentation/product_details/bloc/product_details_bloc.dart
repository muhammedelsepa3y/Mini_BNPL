import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/product.dart';
import '../../../../domain/usecases/get_product_details.dart';

part 'product_details_event.dart';
part 'product_details_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final GetProductDetails getProductDetails;

  ProductDetailsBloc({
    required this.getProductDetails,
  }) : super(ProductDetailsInitial()) {
    on<FetchProductDetailsEvent>(_onFetchProductDetails);
  }

  Future<void> _onFetchProductDetails(
    FetchProductDetailsEvent event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());

    final productResult = await getProductDetails(event.id);

    productResult.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) {
        emit(ProductDetailsLoaded(
          product: product,
        ));
      },
    );
  }
}
