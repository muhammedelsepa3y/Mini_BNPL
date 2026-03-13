import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../domain/entities/available_plan.dart';

class InstallmentPlansSelector extends StatelessWidget {
  final List<AvailablePlan> plans;
  final AvailablePlan? selectedPlan;
  final ValueChanged<AvailablePlan> onPlanSelected;

  const InstallmentPlansSelector({
    super.key,
    required this.plans,
    required this.selectedPlan,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (plans.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available BNPL Plans',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 48.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: plans.length,
            separatorBuilder: (context, index) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final plan = plans[index];
              final isSelected = selectedPlan?.id == plan.id;
              
              return GestureDetector(
                onTap: () => onPlanSelected(plan),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isSelected 
                        ? Theme.of(context).primaryColor 
                        : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    '${plan.durationMonths} Months',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
