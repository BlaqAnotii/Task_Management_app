import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'locator.dart';

final NavigationService navigationService =
    getIt<NavigationService>();

class AnimatedPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  AnimatedPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 800),
          reverseTransitionDuration:
              const Duration(milliseconds: 800),
          pageBuilder:
              (context, animation, secondaryAnimation) => page,
          transitionsBuilder:
              (context, animation, secondaryAnimation, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            final slide = Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            final scale = Tween<double>(
              begin: 0.97,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ));

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(
                  scale: scale,
                  child: child,
                ),
              ),
            );
          },
        );
}

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> snackBarKey =
      GlobalKey<ScaffoldMessengerState>();
  BuildContext? materialC;

  navigateTo(String routeName, {dynamic argument}) {
    return materialC!.push(routeName, extra: argument);
  }

  Future<dynamic> navigateToReplace(String routeName,
      {dynamic argument}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: argument);
  }

  Future<dynamic> navigateToAndRemoveUntil(String routeName,
      {dynamic argument}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Future<dynamic> pushToAndRemoveUntil(routeObject,
      {dynamic argument}) {
    return navigatorKey.currentState!.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => routeObject),
        (route) => false);
  }

  Future<dynamic> push(routeObject, {dynamic argument}) {
    return navigatorKey.currentState!
        .push(AnimatedPageRoute(page: routeObject));
  }

  Future<dynamic> pushAndReplace(routeObject,
      {dynamic argument}) {
    return navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => routeObject));
  }

  void goBack() {
    return navigatorKey.currentState!.pop();
  }

  void goBackWithResult(result) {
    return navigatorKey.currentState!.pop(result);
  }
}
