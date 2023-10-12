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
