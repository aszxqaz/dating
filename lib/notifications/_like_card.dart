part of 'notifications_screen.dart';

class _LikeNotificationCard extends StatelessWidget {
  const _LikeNotificationCard({
    required this.profile,
    required this.photo,
    required this.like,
  });

  final Profile profile;
  final Photo photo;
  final LikeNotification like;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      margin: const EdgeInsets.only(bottom: 8),
      height: 80,
      decoration: BoxDecoration(
        color: like.read ? Colors.white : Colors.lightBlue.shade200,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            spreadRadius: 0,
            blurRadius: 1,
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            ProfilePage.route(
              context: context,
              profileId: profile.userId,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ProfilePhoto(
                  profile.avatarUrl,
                  size: const Size.square(56),
                  circle: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        profile.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      const Text('Liked your photo'),
                    ],
                  ),
                ),
                Material(
                  elevation: 2,
                  child: ProfilePhoto(
                    photo.url,
                    size: const Size.square(42),
                  ),
                ),
                const SizedBox(width: 12),
                Text(like.createdAt.shortStringDateTime),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
