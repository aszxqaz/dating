part of '../hot_swipe_view.dart';

class HotSwipeAnimationState {
  const HotSwipeAnimationState({
    required this.deltaX,
    required this.deltaY,
    required this.angle,
    required this.action,
    required this.highlight,
    required this.highlightOpacity,
  });

  static const initial = HotSwipeAnimationState(
    deltaX: 0.0,
    deltaY: 0.0,
    angle: 0.0,
    action: HotSwipeAction.none,
    highlight: HotSwipeAction.none,
    highlightOpacity: 0.0,
  );

  final double deltaX;
  final double deltaY;
  final double angle;
  final double highlightOpacity;

  final HotSwipeAction action;
  final HotSwipeAction highlight;

  HotSwipeAnimationState copyWith({
    double? deltaX,
    double? deltaY,
    double? angle,
    double? highlightOpacity,
    HotSwipeAction? action,
    HotSwipeAction? highlight,
  }) =>
      HotSwipeAnimationState(
        deltaX: deltaX ?? this.deltaX,
        deltaY: deltaY ?? this.deltaY,
        angle: angle ?? this.angle,
        action: action ?? this.action,
        highlight: highlight ?? this.highlight,
        highlightOpacity: highlightOpacity ?? this.highlightOpacity,
      );
}

class HotSwipeAnimationCubit extends Cubit<HotSwipeAnimationState> {
  HotSwipeAnimationCubit() : super(HotSwipeAnimationState.initial);

  static const double _actionThreshold = 175;
  static const double _highlightThreshold = 0;
  static const double _rotationThreshold = 400;

  static const double _maxRotation = pi / 12;

  static const double _horizontalMultiplier = 0.5;
  static const double _verticalMultiplier = 0.1;

  static const Curve _forwardRotationCurve = Curves.easeInSine;
  static const Curve _forwardHighlightOpacityCurve = Curves.easeIn;
  static const Curve _reverseCurve = Curves.easeOut;
  static const Curve _actionCurve = Curves.easeOut;

  static const double _targetDeltaXAbs = 300;
  static const double _targetDeltaYAbs = -300;
  static const double _targetAngleAbs = pi / 6;

  double _lastDeltaX = 0.0;
  double _lastDeltaY = 0.0;
  double _lastAngle = 0.0;

  void update(Offset delta) {
    double deltaX = state.deltaX;
    double deltaY = state.deltaY;
    double angle = state.angle;
    var action = HotSwipeAction.none;
    var highlight = HotSwipeAction.none;

    deltaX += delta.dx * _horizontalMultiplier;

    final deltaXreal = deltaX / _horizontalMultiplier;

    if (deltaXreal.abs() > _highlightThreshold) {
      highlight = deltaXreal > 0 ? HotSwipeAction.like : HotSwipeAction.dismiss;
    }

    if (deltaXreal.abs() > _actionThreshold) {
      action = deltaXreal > 0 ? HotSwipeAction.like : HotSwipeAction.dismiss;
    }

    final highlightOpacity = _forwardHighlightOpacityCurve
        .transform(clampDouble(deltaXreal.abs() / _actionThreshold, 0, 1));

    deltaY += delta.dy * _verticalMultiplier;

    final rotationValue = deltaXreal / _rotationThreshold;

    angle = _forwardRotationCurve
            .transform(clampDouble(rotationValue.abs(), 0, 1)) *
        _maxRotation *
        rotationValue.sign;

    _lastDeltaX = deltaX;
    _lastDeltaY = deltaY;
    _lastAngle = angle;

    emit(state.copyWith(
      action: action,
      highlight: highlight,
      angle: angle,
      deltaX: deltaX,
      deltaY: deltaY,
      highlightOpacity: highlightOpacity,
    ));
  }

  void animateReverse(double controllerValue) {
    final mult = _reverseCurve.transform(1 - controllerValue);

    final angle = mult * state.angle;
    final deltaX = mult * state.deltaX;
    final deltaY = mult * state.deltaY;
    final highlightOpacity = mult * state.highlightOpacity;

    emit(state.copyWith(
      deltaX: deltaX,
      deltaY: deltaY,
      angle: angle,
      highlightOpacity: highlightOpacity,
      action: HotSwipeAction.none,
      highlight: HotSwipeAction.none,
    ));
  }

  void animateAction(double controllerValue) {
    final mult = _actionCurve.transform(controllerValue);

    final deltaX = mult * _targetDeltaXAbs * _lastDeltaX.sign + _lastDeltaX;
    final deltaY = mult * _targetDeltaYAbs + _lastDeltaY;
    final angle = mult * _targetAngleAbs * _lastDeltaX.sign + _lastAngle;

    emit(state.copyWith(
      deltaX: deltaX,
      deltaY: deltaY,
      angle: angle,
    ));
  }

  void reset() {
    emit(HotSwipeAnimationState.initial);
  }
}
