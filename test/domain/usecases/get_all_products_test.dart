import 'package:bnpl_app/core/usecases/usecase.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/domain/repositiories/bnpl_repository.dart';
import 'package:bnpl_app/domain/usecases/get_all_products.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([BnplRepository])
import 'get_all_products_test.mocks.dart';

void main() {
  test('should get all products from repository', () async {
    final mockRepo = MockBnplRepository();
    final useCase = GetAllProducts(mockRepo);
    final tProducts = [
      const Product(
        id: 1,
        name: 'Test Product',
        description: 'Description',
        price: 100,
        imageUrl: 'image.jpg',
      )
    ];

    when(mockRepo.getAllProducts()).thenAnswer((_) async => Right(tProducts));

    final result = await useCase(NoParams());

    expect(result, Right<dynamic, List<Product>>(tProducts));
  });
}
