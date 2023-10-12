import 'package:dating/common/online_label.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/misc/distance.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:dating/profile/profile_view.dart';
import 'package:dating/supabase/models/models.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:timeago/timeago.dart' as timeago;

part '_hot_card.dart';

class HotCardsScreen extends StatelessWidget {
  const HotCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: BlocBuilder<ProfilesBloc, ProfilesState>(
                buildWhen: (prev, cur) => prev.loading != cur.loading,
                builder: (context, state) {
                  switch (state.loading) {
                    case LoadingStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case LoadingStatus.failure:
                      return const Center(
                        child: Text('Error occured'),
                      );

                    case LoadingStatus.loaded:
                      if (state.profiles.isEmpty) {
                        return const Center(
                          child: Text('No profiles'),
                        );
                      }

                      return SafeArea(
                        child: LayoutGrid(
                          columnSizes: [1.fr, 1.fr],
                          rowSizes: List.generate(
                              state.profiles.length, (index) => auto),
                          rowGap: 0,
                          columnGap: 0,
                          // gridFit: GridFit.loose,
                          children: state.profiles
                              .map(
                                (profile) => InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      ProfilePage.route(
                                        context: context,
                                        profileId: profile.userId,
                                      ),
                                    );
                                  },
                                  child: _HotCard(profile: profile),
                                ),
                              )
                              .toList(),
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
