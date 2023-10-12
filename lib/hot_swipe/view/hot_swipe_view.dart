import 'dart:math';
import 'dart:ui';

import 'package:dating/common/common.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/hot_swipe/hot_swipe.dart';
import 'package:dating/supabase/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

part '_hot_swipe_photo_slider.dart';
part 'animation/animation_cubit.dart';

class HotSwipeScreen extends StatelessWidget {
  const HotSwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesBloc, ProfilesState>(
      builder: (context, profilesState) {
        switch (profilesState.loading) {
          case LoadingStatus.loaded:
            return BlocProvider<HotSwipeBloc>(
              create: (_) => HotSwipeBloc(profiles: profilesState.profiles),
              child: BlocProvider<HotSwipeAnimationCubit>(
                create: (_) => HotSwipeAnimationCubit(),
                child: const _HotSwipeView(),
              ),
            );

          default:
            return const Center(
              child: CircularProgressIndicator(),
            );
        }
      },
    );
  }
}

class _HotSwipeView extends StatelessWidget {
  const _HotSwipeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotSwipeBloc, HotSwipeState>(
      builder: (context, state) {
        final current = state.current;
        final next = state.next;

        if (current == null) {
          return const Center(child: Text('No profile'));
        }

        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HotSwipePhotoSlider(
                        height: constraints.maxHeight * 0.8,
                        current: current.profile,
                        next: next?.profile,
                        onLiked: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.red.shade400,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              duration: const Duration(milliseconds: 500),
                              width: 100,
                              padding:
                                  const EdgeInsets.fromLTRB(16, 12, 16, 14),
                              content: const Text(
                                'Liked!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                          context.read<HotSwipeBloc>().like();
                        },
                        onDismissed: context.read<HotSwipeBloc>().dismiss,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ProfileInfo(profile: current.profile),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
