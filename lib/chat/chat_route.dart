part of 'chat_view.dart';

Route createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var scaleTween = Tween<double>(begin: 0.5, end: 1)
          .chain(CurveTween(curve: Curves.easeOutExpo));

      var opacityTween = Tween<double>(begin: 0.5, end: 1)
          .chain(CurveTween(curve: Curves.easeOutExpo));

      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (BuildContext context, Widget? child) => Transform.scale(
          scale: scaleTween.transform(animation.value),
          child: Opacity(
            opacity: opacityTween.transform(animation.value),
            child: child,
          ),
        ),
      );
    },
  );
}

Route createRightBottomFadeScaleRoute(Widget page) {
  return PageRouteBuilder(
    reverseTransitionDuration: const Duration(milliseconds: 150),
    // transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final scaleTween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn));
      final fadeTween =
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut));

      return ScaleTransition(
        scale: animation.drive(scaleTween),
        alignment: const Alignment(0.8, 0.8),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}
