part of 'hot_view.dart';

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
                                    child: CircularProgressIndicator(),
                                  ),
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
