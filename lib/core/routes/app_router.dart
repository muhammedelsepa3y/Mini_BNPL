import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_route_const.dart';
import '../../presentation/splash/splash_view.dart';
import '../../presentation/products/products_view.dart';

import '../../presentation/shell/main_shell_view.dart';
import '../../presentation/orders/orders_view.dart';
import '../../presentation/product_details/product_details_view.dart';
import '../../presentation/order_flow/views/plan_selection_view.dart';
import '../../presentation/order_flow/views/order_confirmation_view.dart';
import '../../presentation/order_flow/views/payment_view.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/available_plan.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter returnRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRouteConst.splash,
      errorPageBuilder: (context, state) {
        return const MaterialPage(
          child: Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRouteConst.splash,
          name: AppRouteConst.splashName,
          builder: (context, state) => const SplashView(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainShellView(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteConst.productsName,
                  path: AppRouteConst.products,
                  builder: (context, state) => const ProductsView(),
                  routes: [
                    GoRoute(
                      name: AppRouteConst.productDetailsName,
                      path: 'details/:id',
                      builder: (context, state) {
                        final id = state.pathParameters['id'] ?? '';
                        return ProductDetailsView(id: id);
                      },
                      routes: [
                        GoRoute(
                          name: AppRouteConst.planSelectionName,
                          path: AppRouteConst.planSelection,
                          builder: (context, state) {
                            final product = state.extra as Product;
                            return PlanSelectionView(product: product);
                          },
                        ),
                        GoRoute(
                          name: AppRouteConst.orderConfirmationName,
                          path: AppRouteConst.orderConfirmation,
                          builder: (context, state) {
                            final args = state.extra as Map<String, dynamic>;
                            return OrderConfirmationView(
                              product: args['product'] as Product,
                              selectedPlan: args['plan'] as AvailablePlan,
                            );
                          },
                        ),
                        GoRoute(
                          name: AppRouteConst.paymentName,
                          path: AppRouteConst.payment,
                          builder: (context, state) {
                            final orderId = state.extra as int;
                            return PaymentView(orderId: orderId);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: AppRouteConst.ordersName,
                  path: AppRouteConst.orders,
                  builder: (context, state) => const OrdersView(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
