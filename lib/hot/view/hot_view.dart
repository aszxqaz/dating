import 'package:dating/assets/icons.dart';
import 'package:dating/features/profiles/profiles_bloc.dart';
import 'package:dating/hot/bloc/hot_bloc.dart';
import 'package:dating/hot/models/hot_card.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/svg.dart';

part 'hot_card.dart';

class HotPage extends StatelessWidget {
  const HotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HotPage();
  }
}

class _HotPage extends HookWidget {
  const _HotPage();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<HotBloc>().loadCards();
      return null;
    }, []);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
                minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: BlocBuilder<HotBloc, HotState>(
                buildWhen: (previous, current) =>
                    previous.profiles != current.profiles,
                builder: (context, state) {
                  return state.profiles.isNotEmpty
                      ? LayoutGrid(
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
                                        profile: profile,
                                      ),
                                    );
                                  },
                                  child: _HotCard(
                                    info: HotCard.fromProfile(profile),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- with PROFILES BLOC
class HotPageNew extends StatelessWidget {
  const HotPageNew({super.key});

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
                      return LayoutGrid(
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
                                      profile: profile,
                                    ),
                                  );
                                },
                                child: _HotCard(
                                  info: HotCard.fromProfile(profile),
                                ),
                              ),
                            )
                            .toList(),
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
