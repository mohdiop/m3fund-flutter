import 'package:flutter/material.dart';

class FadeSlideTransition extends PageTransitionsBuilder {
  const FadeSlideTransition();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const curve = Curves.easeOutQuad;

   final inAnim = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chain(CurveTween(curve: curve)).animate(animation);

    final outAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0.0),
    ).chain(CurveTween(curve: curve)).animate(secondaryAnimation);

    return SlideTransition(
      position: inAnim,
      child: SlideTransition(
        position: outAnim,
        child: child,
      ),
    );
  }
}
