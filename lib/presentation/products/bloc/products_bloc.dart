import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/data/models/available_plan_model.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/domain/usecases/get_all_installments.dart';
import 'package:bnpl_app/domain/usecases/get_all_products.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({
    required this.getAllProducts,
    required this.getAllInstallments,
  }) : super(const ProductsInitial()) {
    on<FetchProductsDataEvent>(_onFetchProductsData);
  }

  final GetAllProducts getAllProducts;
  final GetAllInstallments getAllInstallments;

  Future<void> _onFetchProductsData(
    FetchProductsDataEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(const ProductsLoading());
    final productsResult = await getAllProducts(NoParams());
    await productsResult.fold(
      (failure) async {
        emit(ProductsError(failure.message));
      },
      (products) async {
        final installmentsResult = await getAllInstallments(NoParams());
        installmentsResult.fold(
          (failure) {
            if (!emit.isDone) emit(ProductsError(failure.message));
          },
          (installments) {
            if (!emit.isDone) {
              emit(
                ProductsLoaded(
                  products: products,
                  installments: installments,
                ),
              );
            }
          },
        );
      },
    );
  }
}
