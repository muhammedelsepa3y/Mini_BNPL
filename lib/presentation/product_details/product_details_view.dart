import 'package:bnpl_app/di/di.dart';
import 'package:bnpl_app/presentation/product_details/bloc/product_details_bloc.dart';
import 'package:bnpl_app/presentation/product_details/widgets/product_details_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    required this.id,
    super.key,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ProductDetailsBloc>()
            ..add(FetchProductDetailsEvent(int.parse(id))),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Product Details'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<ProductDetailsBloc>().add(
                    FetchProductDetailsEvent(int.parse(id)),
                  );
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailsBloc, ProductDetailsState>(
          builder: (context, state) {
            if (state is ProductDetailsLoading ||
                state is ProductDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductDetailsBloc>().add(
                          FetchProductDetailsEvent(int.parse(id)),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is ProductDetailsLoaded) {
              return ProductDetailsContent(
                product: state.product,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
