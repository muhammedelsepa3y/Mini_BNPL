import 'dart:async';
import 'package:bnpl_app/core/routes/app_route_const.dart';
import 'package:bnpl_app/di/di.dart';
import 'package:bnpl_app/domain/entities/order.dart';
import 'package:bnpl_app/presentation/orders/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrdersBloc>()..add(FetchOrdersEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: AppBar(
          title: const Text('My Orders'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<OrdersBloc>().add(FetchOrdersEvent());
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<OrdersBloc, OrdersState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrdersError) {
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
                        context.read<OrdersBloc>().add(FetchOrdersEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64.w,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No orders found',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: state.orders.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _OrderCard(order: order);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final isPending = order.status.toLowerCase() == 'pending';
    final dateStr = DateFormat('MMM dd, yyyy HH:mm').format(order.createdAt);

    return Container(
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
                        _StatusBadge(status: order.status),
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
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              if (isPending)
                ElevatedButton(
                  onPressed: () {
                    unawaited(
                      context.pushNamed(
                        AppRouteConst.paymentName,
                        extra: order.id,
                      ),
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
                  child: const Text('Pay Now'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

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
