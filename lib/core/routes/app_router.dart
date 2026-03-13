import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_route_const.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter returnRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppRouteConst.products,
      errorPageBuilder: (context, state) {
        return const MaterialPage(
          child: Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
      routes: <RouteBase>[

      ],
    );
  }
}
