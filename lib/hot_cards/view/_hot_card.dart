part of 'hot_cards_view.dart';

class _HotCard extends StatelessWidget {
  const _HotCard({
    required this.profile,
  });

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile.avatarUrl;
    final isOnline = profile.isOnline;

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
            child: ProfilePhoto(avatarUrl),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${profile.name}, ${profile.age}',
                  style: context.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                if (profile.location.isNotEmpty)
                  BlocSelector<UserBloc, UserState, UserLocation>(
                    selector: (state) => state.profile!.location,
                    builder: (context, location) {
                      final distanceText = getLocationDistanceText(
                        location,
                        profile.location,
                        context,
                      );

                      if (distanceText == null) return const SizedBox.shrink();

                      return Text(
                        distanceText,
                        style: context.textTheme.bodySmall,
                      );
                    },
                  ),
                isOnline
                    ? const OnlineLabel()
                    : Text(
                        'was ${timeago.format(profile.lastSeen)}',
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
