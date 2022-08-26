import 'package:flutter/cupertino.dart';

class NavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  void pushReplacementNamed(String route) {
    navigatorKey.currentState?.pushReplacementNamed(route);
  }

  void pushNamed(String route) {
    navigatorKey.currentState?.pushNamed(route);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
