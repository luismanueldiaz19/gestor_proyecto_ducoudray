import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'splash_screen.dart';

class Routes {
  static const String splashScreen = '/splash_screen';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String project = '/project';
  // static const String add_ground = '/add_ground';

  // SplashScreen
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case project:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      // case profile:
      //   return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
