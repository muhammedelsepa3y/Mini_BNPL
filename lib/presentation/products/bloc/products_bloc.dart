import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../domain/entities/product.dart';
import '../../../../data/models/available_plan_model.dart';
import '../../../../domain/usecases/get_all_products.dart';
import '../../../../domain/usecases/get_all_installments.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetAllProducts getAllProducts;
  final GetAllInstallments getAllInstallments;

  ProductsBloc({
    required this.getAllProducts,
    required this.getAllInstallments,
  }) : super(ProductsInitial()) {
    on<FetchProductsDataEvent>(_onFetchProductsData);
  }

  Future<void> _onFetchProductsData(
    FetchProductsDataEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
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
              emit(ProductsLoaded(
                products: products,
                installments: installments,
              ));
            }
          },
        );
      },
    );
  }
}
