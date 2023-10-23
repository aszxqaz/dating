import 'package:dating/misc/validators.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'incomplete_event.dart';
part 'incomplete_state.dart';

class IncompleteBloc extends Bloc<_IncompleteEvent, IncompleteState> {
  IncompleteBloc() : super(const IncompleteState()) {
    on<_Submit>(_onSubmit);
    on<_ToStage>(_onToStage);
    on<_ValueChanged>(_onValueChanged);
  }

  static IncompleteBloc of(BuildContext context) =>
      context.read<IncompleteBloc>();

  // ---
  // --- VALUE CHANGE
  // ---
  void _onValueChanged(_ValueChanged event, Emitter<IncompleteState> emit) {
    switch (event.stage) {
      case IncompleteStage.birthdate:
        emit(state.withBirthdate(event.birthdate));
      case IncompleteStage.gender:
        emit(state.copyWith(gender: event.gender));
      case IncompleteStage.name:
        emit(state.copyWith(name: event.name, fieldErrors: {
          ...state.fieldErrors,
          'name': null,
        }));
    }
  }

  // ---
  // --- SUBMIT DATA
  // ---
  void _onSubmit(_Submit event, Emitter<IncompleteState> emit) async {
    emit(state.copyWith(loading: true));

    final error = validateUsername(state.name);

    if (error != null) {
      emit(state.withFieldErrors({
        'name': error,
      }));
      return;
    }

    final profile = await supabaseService.createProfile(
      state.birthdate!,
      state.gender,
      state.name,
    );

    if (profile != null) {
      emit(state.copyWith(profile: profile));
    } else {
      emit(state.withError('Server error occured. Restart the application.'));
    }
  }

  // ---
  // --- TO STAGE
  // ---
  void _onToStage(_ToStage event, Emitter<IncompleteState> emit) {
    switch (event.stage) {
      case IncompleteStage.gender:
        final error = validateBirthdate(state.birthdate);
        if (error != null) {
          emit(state.withFieldErrors({
            'birthdate': error,
          }));
        } else {
          emit(state.copyWith(stage: IncompleteStage.gender));
        }
        emit(state.copyWith(stage: IncompleteStage.gender));

      case IncompleteStage.name:
        emit(state.copyWith(stage: IncompleteStage.name));
      case IncompleteStage.birthdate:
    }
  }

  // ---
  // --- PUBLIC API
  // ---
  void next() {
    switch (state.stage) {
      case IncompleteStage.name:
        add(const _Submit());
      case IncompleteStage.gender:
        add(const _ToStage(stage: IncompleteStage.name));
      case IncompleteStage.birthdate:
        add(const _ToStage(stage: IncompleteStage.gender));
    }
  }

  void changeBirthdate(DateTime? birthdate) {
    add(_ValueChanged(stage: IncompleteStage.birthdate, birthdate: birthdate));
  }

  void changeGender(Gender? gender) {
    if (gender == null) return;
    add(_ValueChanged(stage: IncompleteStage.gender, gender: gender));
  }

  void changeName(String name) {
    add(_ValueChanged(stage: IncompleteStage.name, name: name));
  }
}
