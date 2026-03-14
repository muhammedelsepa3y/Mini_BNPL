import 'package:bnpl_app/core/routes/app_route_const.dart';
import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/presentation/product_details/widgets/installment_plans_selector.dart';
import 'package:bnpl_app/presentation/product_details/widgets/payment_breakdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class PlanSelectionView extends StatefulWidget {
  const PlanSelectionView({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  State<PlanSelectionView> createState() => _PlanSelectionViewState();
}

class _PlanSelectionViewState extends State<PlanSelectionView> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Plan'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.product.availablePlans.isNotEmpty) ...[
                    InstallmentPlansSelector(
                      plans: widget.product.availablePlans,
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
                      price: widget.product.price,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, -4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54.h,
                child: ElevatedButton(
                  onPressed: selectedPlan == null
                      ? null
                      : () async {
                          await context.pushNamed(
                            AppRouteConst.orderConfirmationName,
                            pathParameters: {
                              'id': widget.product.id.toString(),
                            },
                            extra: {
                              'product': widget.product,
                              'plan': selectedPlan!,
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                  ),
                  child: Text(
                    'Proceed to Confirmation',
                    semanticsLabel:
                        'Proceed to order confirmation with selected plan',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: selectedPlan == null ? Colors.grey : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
