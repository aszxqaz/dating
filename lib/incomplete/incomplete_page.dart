import 'package:animations/animations.dart';
import 'package:dating/app/app.dart';
import 'package:dating/common/animations.dart';
import 'package:dating/common/date_field.dart';
import 'package:dating/common/password_field.dart';
import 'package:dating/common/wrapper_builder.dart';
import 'package:dating/incomplete/bloc/incomplete_bloc.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/misc/submit_button.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

part '_birthdate.dart';
part '_name.dart';
part '_gender.dart';
part '_wrapper.dart';

class IncompletePage extends StatelessWidget {
  const IncompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IncompleteBloc>(
      create: (_) => IncompleteBloc(),
      child: BlocListener<IncompleteBloc, IncompleteState>(
        listenWhen: (previous, current) => previous.profile != current.profile,
        listener: (context, state) {
          if (state.profile != null) {
            AppBloc.of(context).authenticate(state.profile);
          }
        },
        child: WrapperBuilder(
          builder: (_, __) {
            return IntrinsicHeight(
              child: BlocSelector<IncompleteBloc, IncompleteState,
                  IncompleteStage>(
                selector: (state) => state.stage,
                builder: (_, stage) {
                  return SharedAxisSwitcherBuilder(
                    type: SharedAxisTransitionType.horizontal,
                    builder: (_) {
                      switch (stage) {
                        case IncompleteStage.birthdate:
                          return const _Birthdate();
                        case IncompleteStage.gender:
                          return const _Gender();
                        case IncompleteStage.name:
                          return const _Name();
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
