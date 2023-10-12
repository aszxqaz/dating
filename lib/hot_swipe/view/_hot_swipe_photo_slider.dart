part of 'hot_swipe_view.dart';

class _HotSwipePhotoSlider extends StatefulWidget {
  const _HotSwipePhotoSlider({
    required this.height,
    required this.current,
    required this.onLiked,
    required this.onDismissed,
    this.next,
  });

  final double height;
  final Profile? next;
  final Profile current;
  final VoidCallback onLiked;
  final VoidCallback onDismissed;

  @override
  State<_HotSwipePhotoSlider> createState() => _HotSwipePhotoSliderState();
}

class _HotSwipePhotoSliderState extends State<_HotSwipePhotoSlider>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  HotSwipeAction lastNotNoneHighlight = HotSwipeAction.dismiss;
  bool isPanEnd = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _HotSwipePhotoSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: widget.height,
      ),
      child: Stack(
        children: [
          if (widget.next != null)
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: 0.9,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color.fromRGBO(146, 216, 227, 1),
                  ),
                ),
                child: widget.next!.hasAvatar
                    ? Image.network(widget.next!.avatarUrl!)
                    : const AvatarPlaceholder(),
              ),
            ),
          BlocBuilder<HotSwipeAnimationCubit, HotSwipeAnimationState>(
            builder: (context, state) {
              final deltaX = state.deltaX;
              final deltaY = state.deltaY;
              final angle = state.angle;
              final action = state.action;
              final highlight = state.highlight;
              final highlightOpacity = state.highlightOpacity;

              return GestureDetector(
                onPanUpdate: (details) {
                  context.read<HotSwipeAnimationCubit>().update(details.delta);
                },
                onPanEnd: (details) {
                  // ignore: invalid_use_of_protected_member
                  _controller?.clearListeners();

                  if (!action.isNone) {
                    _controller!
                      ..addListener(() {
                        context
                            .read<HotSwipeAnimationCubit>()
                            .animateAction(_controller!.value);
                      })
                      ..reset()
                      ..animateTo(1,
                              duration: const Duration(milliseconds: 200))
                          .then((_) {
                        if (action.isLike) {
                          widget.onLiked();
                        } else {
                          widget.onDismissed();
                        }
                        context.read<HotSwipeAnimationCubit>().reset();
                      });
                  } else {
                    _controller!
                      ..addListener(() {
                        if (_controller != null) {
                          context
                              .read<HotSwipeAnimationCubit>()
                              .animateReverse(_controller!.value);
                        }
                      })
                      ..reset()
                      ..animateTo(1,
                          duration: const Duration(milliseconds: 300));
                  }
                },
                child: TweenAnimationBuilder(
                  key: ValueKey(widget.current.userId),
                  tween: Tween<double>(begin: 0.9, end: 1.0),
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 200),
                  builder: (context, scale, child) {
                    return Container(
                      transform: Matrix4.identity().scaled(scale),
                      transformAlignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color.fromRGBO(109, 216, 227, 1),
                      ),
                    ),
                    transformAlignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(deltaX, deltaY)
                      ..rotateZ(angle),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          widget.current.hasAvatar
                              ? PhotoSlider(
                                  // size: Size(300, sliderHeight),
                                  // controller: photoSliderController,
                                  photoUrls: widget.current.photoUrls,
                                  disableScroll: true,
                                )
                              : const AvatarPlaceholder(),
                          Align(
                            alignment: const Alignment(0, 0.2),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              opacity: highlight.isNone ? 0 : highlightOpacity,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red.shade400,
                                    width: 4,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Builder(
                                    builder: (context) {
                                      if (!highlight.isNone) {
                                        lastNotNoneHighlight = highlight;
                                      }

                                      return Icon(
                                        lastNotNoneHighlight.isLike
                                            ? Ionicons.heart
                                            : Ionicons.close,
                                        color: Colors.red.shade400,
                                        size: 96,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
