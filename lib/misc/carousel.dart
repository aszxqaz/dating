import 'package:dating/assets/icons.dart';
import 'package:dating/misc/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhotoCarousel extends StatefulWidget {
  const PhotoCarousel({
    super.key,
    required this.images,
  });

  final List<String>? images;

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int activePage = 0;

  late Image errPlaceholder;
  late PageController pageController;

  @override
  void initState() {
    errPlaceholder = Image.asset(ImageAssets.errorImagePlaceholder);
    pageController = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(errPlaceholder.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final hasPhotos = widget.images != null && widget.images!.isNotEmpty;
    final twoAndMorePhotos = hasPhotos && widget.images!.length > 1;

    final widgets = hasPhotos
        ? widget.images!.map(wrapWithNetworkImage).toList()
        : [
            Container(
              color: context.colorScheme.primary.withOpacity(0.3),
              child: SvgPicture.asset(
                IconAssets.userPlaceholder,
                fit: BoxFit.contain,
              ),
            ),
          ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: PageView.builder(
                itemCount: widgets.length,
                onPageChanged: (page) {
                  setState(() {
                    activePage = page;
                  });
                },
                itemBuilder: (context, idx) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: widgets[idx]),
                  );
                },
              ),
            ),
            if (twoAndMorePhotos)
              Positioned(
                bottom: 8,
                left: 0,
                // 10 -
                //     (widget.images.length * 7 +
                //             (widget.images.length - 1) * 5 +
                //             20) /
                //         2,
                child: SizedBox(
                  width: constraints.constrainWidth(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SliderIndicator(
                        activeIndex: activePage,
                        count: widgets.length,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget wrapWithNetworkImage(String url) {
    return Image.network(
      url,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
              ? child
              : Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(238, 238, 238, 1),
                  ),
                  child: const Center(child: CircularProgressIndicator()),
                ),
    );
    // return CachedNetworkImage(
    //   fadeInDuration: const Duration(milliseconds: 0),
    //   fadeOutDuration: const Duration(milliseconds: 0),
    //   imageUrl: url,
    //   errorWidget: (_, __, ___) => errPlaceholder,
    //   placeholder: (_, __) => Container(
    //     clipBehavior: Clip.antiAlias,
    //     decoration: const BoxDecoration(
    //       color: Color.fromRGBO(238, 238, 238, 1),
    //     ),
    //     child: const Center(child: CircularProgressIndicator()),
    //   ),
    //   fit: BoxFit.cover,
    // );
  }
}

class _SliderIndicator extends StatelessWidget {
  const _SliderIndicator({
    required this.activeIndex,
    required this.count,
  });

  final int activeIndex;
  final int count;

  static const opacities = [0.22, 0.17, 0.1, 0.05];
  // static const circleSize

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        // width: 200,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            children: List.generate(
              count * 2 - 1,
              (index) => index % 2 == 0
                  ? Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == activeIndex * 2
                            ? Colors.black
                            : Color.fromRGBO(
                                0,
                                0,
                                0,
                                opacities[(((index - activeIndex).abs() / 2)
                                            .truncate() -
                                        1)
                                    .clamp(0, opacities.length - 1)],
                              ),
                      ),
                    )
                  : const SizedBox(
                      width: 5,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
