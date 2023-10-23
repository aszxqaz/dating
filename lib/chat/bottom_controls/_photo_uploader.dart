part of '../chat_view.dart';

class _PhotoUploaderPanel extends StatelessWidget {
  const _PhotoUploaderPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoUploaderBloc, PhotoUploaderState>(
      builder: (context, state) {
        final items = state.items;

        // if (items.isEmpty) return const SizedBox.shrink();

        return Offstage(
          offstage: items.isEmpty,
          child: Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                // color: context.colorScheme.primary,
                // width: double.maxFinite,
                // height: 200,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        size: Size(constraints.maxWidth, 180),
                        painter: StripesBackground(
                          color: context.colorScheme.primary.darken(0.01),
                          strokeWidth: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 0, 16),
                          child: ListView(
                            clipBehavior: Clip.none,
                            scrollDirection: Axis.horizontal,
                            children: items
                                .mapIndexed(
                                  (index, item) =>
                                      _UploadPhotoItem(id: item.id),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  width: double.maxFinite,
                  height: 2,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.black12,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _UploadPhotoItem extends StatelessWidget {
  const _UploadPhotoItem({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhotoUploaderBloc, PhotoUploaderState>(
      buildWhen: (prev, curr) {
        final prevItem = prev.getItem(id);
        final currItem = curr.getItem(id);

        return prevItem?.status != currItem?.status;
      },
      builder: (context, state) {
        final item = state.getItem(id);

        return item == null
            ? const SizedBox.shrink()
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      right: 16.0,
                    ),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.white38,
                        ),
                      ),
                      child: Opacity(
                        opacity: item.status.isProcessing ? 0.5 : 1,
                        child: AspectRatio(
                          aspectRatio: 0.6,
                          child: Image.memory(
                            item.bytes,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: ShadowedIconButton(
                      onPressed: () =>
                          PhotoUploaderBloc.of(context).excludePhoto(id),
                      icon: Ionicons.close_outline,
                      size: 18,
                      padding: 4,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
