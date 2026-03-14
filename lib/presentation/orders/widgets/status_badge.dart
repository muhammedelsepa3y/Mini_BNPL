import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'approved':
      case 'success':
        color = Colors.green.shade700;
        bgColor = Colors.green.shade50;
      case 'pending':
        color = Colors.orange.shade700;
        bgColor = Colors.orange.shade50;
      case 'failed':
      case 'rejected':
        color = Colors.red.shade700;
        bgColor = Colors.red.shade50;
      default:
        color = Colors.grey.shade700;
        bgColor = Colors.grey.shade50;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
