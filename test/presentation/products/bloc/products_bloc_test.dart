import 'package:bnpl_app/domain/usecases/get_all_installments.dart';
import 'package:bnpl_app/domain/usecases/get_all_products.dart';
import 'package:bnpl_app/presentation/products/bloc/products_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([GetAllProducts, GetAllInstallments])
import 'products_bloc_test.mocks.dart';

void main() {
  test('should emit [Loading, Loaded] when data is fetched', () async {
    final mockProducts = MockGetAllProducts();
    final mockInstallments = MockGetAllInstallments();
    final bloc = ProductsBloc(
      getAllProducts: mockProducts,
      getAllInstallments: mockInstallments,
    );

    when(mockProducts(any)).thenAnswer((_) async => const Right([]));
    when(mockInstallments(any)).thenAnswer((_) async => const Right([]));

    await expectLater(
      bloc.stream,
      emitsInOrder([
        const ProductsLoading(),
        const ProductsLoaded(products: [], installments: []),
      ]),
    );

    bloc.add(FetchProductsDataEvent());
  });
}
