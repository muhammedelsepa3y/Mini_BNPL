import 'package:bnpl_app/core/routes/app_route_const.dart';
import 'package:bnpl_app/domain/entities/available_plan.dart';
import 'package:bnpl_app/domain/entities/product.dart';
import 'package:bnpl_app/presentation/order_flow/views/order_confirmation_view.dart';
import 'package:bnpl_app/presentation/order_flow/views/payment_view.dart';
import 'package:bnpl_app/presentation/order_flow/views/plan_selection_view.dart';
import 'package:bnpl_app/presentation/orders/orders_view.dart';
import 'package:bnpl_app/presentation/product_details/product_details_view.dart';
import 'package:bnpl_app/presentation/products/products_view.dart';
import 'package:bnpl_app/presentation/shell/main_shell_view.dart';
import 'package:bnpl_app/presentation/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static GoRouter returnRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRouteConst.splash,
      observers: [routeObserver],
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
