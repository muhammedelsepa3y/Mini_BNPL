import 'package:bnpl_app/core/routes/app_route_const.dart';
import 'package:bnpl_app/domain/entities/order.dart';
import 'package:bnpl_app/presentation/orders/widgets/status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final isPending = order.status.toLowerCase() == 'pending';
    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt);

    return Semantics(
      label: 'Order for ${order.product.name}, Status: ${order.status}, Price: ${order.product.price.toStringAsFixed(2)} dollars',
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    order.product.imageUrl,
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.cover,
                    semanticLabel: 'Product image for ${order.product.name}',
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60.w,
                      height: 60.w,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 20),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              order.product.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1F2937),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          StatusBadge(status: order.status),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Plan: ${order.installmentPlan.durationMonths} Months',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${order.product.price.toStringAsFixed(2)}',
                  semanticsLabel: '${order.product.price.toStringAsFixed(2)} dollars',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (isPending)
                  ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        AppRouteConst.paymentName,
                        pathParameters: {'id': order.product.id.toString()},
                        extra: order.id,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text(
                      'Pay Now',
                      semanticsLabel: 'Pay for order now',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
