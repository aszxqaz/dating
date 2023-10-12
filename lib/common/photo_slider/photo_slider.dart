import 'package:dating/common/photo_slider/slider_indicator.dart';
import 'package:dating/common/profile_photo.dart';
import 'package:flutter/material.dart';

class PhotoSlider extends StatefulWidget {
  const PhotoSlider({
    super.key,
    required this.photoUrls,
    this.controller,
    this.initialPage = 0,
    this.size,
    this.onPageChanged,
    this.disableScroll = false,
    this.showIndicator = true,
  });

  final Size? size;
  final PageController? controller;
  final bool disableScroll;
  final Iterable<String> photoUrls;
  final ValueChanged<int>? onPageChanged;
  final int initialPage;
  final bool showIndicator;

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  late final PageController controller;
  late final ValueNotifier<int> notifier;

  static const duration = Duration(milliseconds: 300);
  static const curve = Curves.easeOutCubic;

  @override
  void initState() {
    controller =
        widget.controller ?? PageController(initialPage: widget.initialPage);
    notifier = ValueNotifier(widget.initialPage);
    super.initState();
  }

  @override
  dispose() {
    controller.dispose();
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.disableScroll
            ? LayoutBuilder(
                builder: (_, constraints) {
                  return GestureDetector(
                    onTapUp: (details) {
                      final width = constraints.maxWidth;
                      final dx = details.globalPosition.dx;

                      if (dx < width / 2) {
                        // if (notifier.value > 0) {
                        controller.previousPage(
                          duration: duration,
                          curve: curve,
                        );
                        // }
                      } else {
                        controller.nextPage(
                          duration: duration,
                          curve: curve,
                        );
                      }
                    },
                    child: _buildGalleryNew(),
                  );
                },
              )
            : _buildGalleryNew(),
        if (widget.showIndicator)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ValueListenableBuilder(
                valueListenable: notifier,
                builder: (_, value, __) {
                  return SliderIndicator(
                    activeIndex: value,
                    count: widget.photoUrls.length,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  _buildGalleryNew() {
    return PageView(
      controller: controller,
      onPageChanged: (page) {
        notifier.value = page;
        widget.onPageChanged?.call(page);
      },
      physics: widget.disableScroll
          ? const NeverScrollableScrollPhysics()
          : const ClampingScrollPhysics(),
      children: widget.photoUrls.map((url) => ProfilePhoto(url)).toList(),
    );
  }
}
