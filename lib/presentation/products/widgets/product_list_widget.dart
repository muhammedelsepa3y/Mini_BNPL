import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../domain/entities/product.dart';
import '../../../data/models/available_plan_model.dart';
import 'info_item.dart';
import 'product_card.dart';

class ProductListWidget extends StatelessWidget {
  final List<Product> products;
  final List<AvailablePlanModel> installments;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.installments,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products available.',
          style: TextStyle(fontSize: 16.sp),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        if (installments.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Text(
                'Available Plans',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: CarouselSlider.builder(
              itemCount: installments.length,
              options: CarouselOptions(
                height: 140.h,
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                viewportFraction: 0.85,
              ),
              itemBuilder: (context, index, realIndex) {
                final plan = installments[index];
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.12),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "${plan.durationMonths} Months",
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF1F2937),
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Text(
                              '${plan.interestRate}%',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InfoItem(
                                title: 'Duration',
                                value: '${plan.durationMonths} Months',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 34.h,
                              color: Colors.grey.shade300,
                            ),
                            Expanded(
                              child: InfoItem(
                                title: 'Interest Rate',
                                value: '${plan.interestRate}%',
                              ),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),
                 ),
                );
              },
            ),
          ),

        ],
        SliverPadding(
          padding: EdgeInsets.all(16.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: 0.7,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  installments: installments,
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}

