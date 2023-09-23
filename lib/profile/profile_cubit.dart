part of 'profile_view.dart';

class _State {
  const _State({required this.heroEnabled, required this.photoIndex});

  static const initial = _State(heroEnabled: false, photoIndex: 0);

  final bool heroEnabled;
  final int photoIndex;
}

class _Cubit extends Cubit<_State> {
  _Cubit() : super(_State.initial);

  void setIndex(int index) {
    emit(_State(heroEnabled: state.heroEnabled, photoIndex: index));
  }

  void enableHero() {
    emit(_State(heroEnabled: true, photoIndex: state.photoIndex));
  }
}
