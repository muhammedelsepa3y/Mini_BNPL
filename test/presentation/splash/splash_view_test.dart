import 'package:bnpl_app/presentation/products/bloc/products_bloc.dart';
import 'package:bnpl_app/presentation/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([ProductsBloc])
import 'splash_view_test.mocks.dart';

void main() {
  testWidgets('should show app name and loading indicator', (tester) async {
    final mockBloc = MockProductsBloc();
    when(mockBloc.state).thenReturn(const ProductsInitial());
    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, _) => MaterialApp(
          home: BlocProvider<ProductsBloc>(
            create: (_) => mockBloc,
            child: const SplashView(),
          ),
        ),
      ),
    );

    expect(find.text('BNPL App'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
