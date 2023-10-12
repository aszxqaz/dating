part of 'profile_view.dart';

class _FavouriteMessageRow extends StatelessWidget {
  const _FavouriteMessageRow({
    required this.sliderHeight,
    required this.favouriteSize,
    required this.messageSize,
    required this.partnerId,
  });

  final double sliderHeight;
  final double favouriteSize;
  final double messageSize;
  final String partnerId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FilledIconButton(
          onPressed: () {
            // bController.previous();
          },
          icon: Ionicons.bookmark,
          offset: const Offset(0, 0),
          padding: favouriteSize / 2,
          size: favouriteSize,
          bgColor: Colors.green,
        ),
        const SizedBox(width: 16),
        FilledIconButton(
          onPressed: () {
            Navigator.of(context).push(
              ChatView.route(
                context: context,
                partnerId: partnerId,
              ),
            );
          },
          icon: Icons.message,
          offset: const Offset(0, 2),
          padding: messageSize / 1.8,
          size: messageSize,
        ),
      ],
    );
  }
}
