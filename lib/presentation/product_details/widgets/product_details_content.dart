import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../domain/entities/available_plan.dart';
import '../../../../domain/entities/product.dart';
import 'buy_now_bottom_bar_widget.dart';
import 'installment_plans_selector.dart';
import 'payment_breakdown_widget.dart';
import 'product_image_widget.dart';
import 'product_info_widget.dart';

class ProductDetailsContent extends StatefulWidget {
  final Product product;

  const ProductDetailsContent({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsContent> createState() => _ProductDetailsContentState();
}

class _ProductDetailsContentState extends State<ProductDetailsContent> {
  AvailablePlan? selectedPlan;

  @override
  void initState() {
    super.initState();
    if (widget.product.availablePlans.isNotEmpty) {
      selectedPlan = widget.product.availablePlans.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductImageWidget(imageUrl: product.imageUrl),
                SizedBox(height: 24.h),
                
                ProductInfoWidget(
                  name: product.name,
                  price: product.price,
                  description: product.description,
                ),
                SizedBox(height: 24.h),

                if (product.availablePlans.isNotEmpty) ...[
                  InstallmentPlansSelector(
                    plans: product.availablePlans,
                    selectedPlan: selectedPlan,
                    onPlanSelected: (plan) {
                      setState(() {
                        selectedPlan = plan;
                      });
                    },
                  ),
                  SizedBox(height: 24.h),
                ],

                if (selectedPlan != null) ...[
                  PaymentBreakdownWidget(
                    selectedPlan: selectedPlan!,
                    price: product.price,
                    repaymentScheduleWidget: false,
                  ),
                ],
              ],
            ),
          ),
        ),

        BuyNowBottomBarWidget(product: product),
      ],
    );
  }
}

