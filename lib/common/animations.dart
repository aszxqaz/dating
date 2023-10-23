import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisSwitcher extends StatelessWidget {
  const SharedAxisSwitcher({
    super.key,
    required this.child,
    required this.type,
    this.reverse = false,
  });

  final SharedAxisTransitionType type;
  final bool reverse;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      reverse: reverse,
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
      child: child,
    );
  }
}

class SharedAxisSwitcherBuilder extends StatelessWidget {
  const SharedAxisSwitcherBuilder({
    super.key,
    required this.builder,
    required this.type,
    this.reverse = false,
  });

  final SharedAxisTransitionType type;
  final bool reverse;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      reverse: reverse,
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: type,
          child: child,
        );
      },
      child: builder(context),
    );
  }
}

class FadeThroughSwitcher extends StatelessWidget {
  const FadeThroughSwitcher({
    super.key,
    required this.child,
    this.fillColor,
  });

  final Widget child;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: fillColor,
          child: child,
        );
      },
      child: child,
    );
  }
}

class FadeThroughSwitcherBuilder extends StatelessWidget {
  const FadeThroughSwitcherBuilder({
    super.key,
    required this.builder,
    this.fillColor,
  });

  final Widget Function(BuildContext context) builder;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      transitionBuilder: (
        Widget child,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: fillColor,
          child: child,
        );
      },
      child: builder(context),
    );
  }
}
