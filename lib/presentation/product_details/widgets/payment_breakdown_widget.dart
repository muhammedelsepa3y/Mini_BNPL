import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:bnpl_app/presentation/widgets/repayment_schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentBreakdownWidget extends StatelessWidget {
  const PaymentBreakdownWidget({
    required this.selectedPlan,
    required this.price,
    this.repaymentScheduleWidget = true,
    super.key,
  });

  final AvailablePlan selectedPlan;
  final double price;
  final bool repaymentScheduleWidget;

  @override
  Widget build(BuildContext context) {
    final interestRate = selectedPlan.interestRate;
    final interestAmount = price * (interestRate / 100);
    final totalPayable = price + interestAmount;
    final monthlyInstallment = totalPayable / selectedPlan.durationMonths;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 16.h),
              _buildBreakdownRow(
                'Product Price',
                '\$${price.toStringAsFixed(2)}',
              ),
              SizedBox(height: 8.h),
              _buildBreakdownRow(
                'Interest (${selectedPlan.interestRate}%)',
                '+\$${interestAmount.toStringAsFixed(2)}',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const Divider(),
              ),
              _buildBreakdownRow(
                'Total Payable',
                '\$${totalPayable.toStringAsFixed(2)}',
                isBold: true,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Semantics(
                  label: 'Monthly Payment: \$${monthlyInstallment.toStringAsFixed(2)} per month',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly Payment',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        '\$${monthlyInstallment.toStringAsFixed(2)}/mo',
                        semanticsLabel: '${monthlyInstallment.toStringAsFixed(2)} dollars per month',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (repaymentScheduleWidget) ...[
          SizedBox(height: 24.h),
          RepaymentScheduleWidget(
            durationMonths: selectedPlan.durationMonths,
            monthlyAmount: monthlyInstallment,
          ),
        ],
      ],
    );
  }

  Widget _buildBreakdownRow(String title, String value, {bool isBold = false}) {
    // Determine a semantic label for the value if it's a price
    String? semanticsLabel;
    if (value.startsWith('\$') || value.startsWith('+\$')) {
      final numericPart = value.replaceAll(RegExp(r'[^\d.]'), '');
      semanticsLabel = '$numericPart dollars';
    }

    return Semantics(
      label: '$title: $value',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: isBold ? const Color(0xFF1F2937) : const Color(0xFF6B7280),
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            semanticsLabel: semanticsLabel,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF1F2937),
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
