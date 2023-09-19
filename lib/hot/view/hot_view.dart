import 'package:dating/assets/icons.dart';
import 'package:dating/hot/bloc/hot_bloc.dart';
import 'package:dating/hot/models/hot_card.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/profile/fullscreen_carousel.dart';
import 'package:dating/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/svg.dart';

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
                                      ProfilePage.route(profile),
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

class _HotCard extends StatelessWidget {
  const _HotCard({
    required this.info,
  });

  final HotCard info;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: context.colorScheme.primary.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(10)),
      // child: const Text('asdas'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 0.8,
            child: info.photo != null
                ? Hero(
                    tag: info.photo!.id,
                    child: Image.network(
                      info.photo!.url,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(238, 238, 238, 1),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                    ),
                  )
                : Container(
                    color:
                        context.colorScheme.primaryContainer.withOpacity(0.7),
                    child: SvgPicture.asset(
                      IconAssets.userPlaceholder,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.primary.withOpacity(0.2),
                        BlendMode.srcIn,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${info.name}, ${info.age}',
                    style: context.textTheme.bodyLarge),
                const SizedBox(height: 4),
                Text(
                  'from ${info.from}, ${info.distance}',
                  style: context.textTheme.bodySmall,
                ),
                Text(
                  'was ${info.lastSeen} ago',
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
