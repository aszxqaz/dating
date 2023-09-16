import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<HomeTabChanged>((event, emit) {
      emit(HomeState(tab: event.tab));
    });
  }

  void setTab(HomeTabs tab) {
    add(HomeTabChanged(tab: tab));
  }
}
