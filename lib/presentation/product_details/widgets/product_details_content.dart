import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/presentation/product_details/widgets/buy_now_bottom_bar_widget.dart';
import 'package:bnpl_app/presentation/product_details/widgets/installment_plans_selector.dart';
import 'package:bnpl_app/presentation/product_details/widgets/payment_breakdown_widget.dart';
import 'package:bnpl_app/presentation/product_details/widgets/product_image_widget.dart';
import 'package:bnpl_app/presentation/product_details/widgets/product_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailsContent extends StatefulWidget {
  const ProductDetailsContent({
    required this.product,
    super.key,
  });

  final Product product;

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
                ProductImageWidget(
                  imageUrl: product.imageUrl,
                  productName: product.name,
                ),
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
