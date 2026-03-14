import 'package:bnpl_app/core/routes/app_route_const.dart';
import 'package:bnpl_app/di/di.dart';
import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/presentation/order_flow/bloc/order_flow_bloc.dart';
import 'package:bnpl_app/presentation/order_flow/bloc/order_flow_event.dart';
import 'package:bnpl_app/presentation/order_flow/bloc/order_flow_state.dart';
import 'package:bnpl_app/presentation/orders/bloc/orders_bloc.dart';
import 'package:bnpl_app/presentation/widgets/repayment_schedule_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class OrderConfirmationView extends StatelessWidget {
  const OrderConfirmationView({
    required this.product,
    required this.selectedPlan,
    super.key,
  });

  final Product product;
  final AvailablePlan selectedPlan;

  Future<bool> _authenticate() async {
    final auth = LocalAuthentication();
    try {
      final isSupported = await auth.isDeviceSupported();
      final biometrics = await auth
          .getAvailableBiometrics();
      if (!isSupported && biometrics.isEmpty) {
        return true;
      }

      final hasFingerprint = biometrics.contains(
        BiometricType.fingerprint,
      );
      final hasFace = biometrics.contains(BiometricType.face);
      if (hasFingerprint || hasFace || isSupported) {
        return await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
        );
      }

      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final interestAmount = product.price * (selectedPlan.interestRate / 100);
    final totalPayable = product.price + interestAmount;
    final monthlyAmount = totalPayable / selectedPlan.durationMonths;

    return BlocProvider(
      create: (_) => sl<OrderFlowBloc>(),
      child: BlocConsumer<OrderFlowBloc, OrderFlowState>(
        listener: (context, state) {
          if (state is OrderCreatedSuccess) {
            context.goNamed(
              AppRouteConst.paymentName,
              pathParameters: {'id': product.id.toString()},
              extra: state.orderId,
            );
            Future.delayed(const Duration(milliseconds: 200), () {
              sl<OrdersBloc>().add(FetchOrdersEvent());
            });
          } else if (state is OrderFlowError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text('Confirm Order'),
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
                        Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1F2937),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Semantics(
                          label: 'Order Summary for ${product.name}, Price: ${product.price.toStringAsFixed(2)} dollars, Plan: ${selectedPlan.durationMonths} months at ${selectedPlan.interestRate} percent interest',
                          child: Container(
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
                                  product.name,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  semanticsLabel: '${product.price.toStringAsFixed(2)} dollars',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  child: const Divider(),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Plan Duration',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      '${selectedPlan.durationMonths} Months',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Interest Rate',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                    Text(
                                      '${selectedPlan.interestRate}%',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1F2937),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        RepaymentScheduleWidget(
                          durationMonths: selectedPlan.durationMonths,
                          monthlyAmount: monthlyAmount,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
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
                        onPressed: state is OrderFlowLoading
                            ? null
                            : () async {
                                final authSuccess = await _authenticate();
                                if (authSuccess && context.mounted) {
                                  context.read<OrderFlowBloc>().add(
                                    CreateOrderEvent(
                                      product.id,
                                      selectedPlan.id,
                                    ),
                                  );
                                } else if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Authentication failed.'),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                        ),
                        child: state is OrderFlowLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Confirm Order',
                                semanticsLabel: 'Confirm your order for ${product.name}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
