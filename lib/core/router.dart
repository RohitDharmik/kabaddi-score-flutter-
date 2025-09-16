import 'package:flutter/material.dart';
import '../modules/home/home_view.dart';
import '../modules/config/config_view.dart';
import '../modules/dashboard/dashboard_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/config':
        return MaterialPageRoute(builder: (_) => const ConfigView());
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const DashboardView());
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text("Page not found")),
                ));
    }
  }
}