import 'package:bnpl_app/di/di.dart';
import 'package:bnpl_app/presentation/orders/bloc/orders_bloc.dart';
import 'package:bnpl_app/presentation/orders/widgets/order_card.dart';
import 'package:bnpl_app/presentation/orders/widgets/orders_empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              return OrdersErrorWidget(message: state.message);
            } else if (state is OrdersLoaded) {
              if (state.orders.isEmpty) {
                return const OrdersEmptyWidget();
              }

              return ListView.separated(
                padding: EdgeInsets.all(16.w),
                itemCount: state.orders.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(order: order);
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
