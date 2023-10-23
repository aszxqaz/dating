part of '../chat_view.dart';

const _maxWidth = 400.0;
const _uploadingMultiplier = 1.0;
const _countScaleFactor = 0.15;
const _maxWidthFactor = 0.9;
const _aspectRatio = 1.5;

const _rows = [1, 2, 3, 2, 2, 3, 3, 3, 3];

class _PhotoMessage extends StatelessWidget {
  const _PhotoMessage({
    required this.message,
    required this.bgColor,
    required this.constraintsWidth,
  });

  final ChatMessage message;
  final Color bgColor;
  final double constraintsWidth;

  Size _getItemSize(int crossAxisCount) {
    final factor = _maxWidthFactor - (3 - crossAxisCount) * _countScaleFactor;
    final baseWidth = factor * (constraintsWidth - 2) / crossAxisCount;
    final width = min(baseWidth, _maxWidth);
    return Size(width, width * _aspectRatio);
  }

  int _getCount(int rowNum, int colNum) {
    return (rowNum + 1) * (colNum + 1);
  }

  @override
  Widget build(BuildContext context) {
    final photos = message.photos!;
    final bounded = min(photos.length, 9);
    final rowSize = _rows[bounded - 1];
    final taken = bounded - bounded % rowSize;

    final isUploadingAny = photos.any((photo) => photo.isUploading);

    final itemSize =
        _getItemSize(rowSize) * (isUploadingAny ? _uploadingMultiplier : 1);

    final leftCount = photos.length - taken;

    return Stack(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, //New
                  blurRadius: 3.0,
                  offset: Offset(1, 2))
            ],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: context.colorScheme.primary.withAlpha(50),
              // color: Colors.black,
              width: 1,
            ),
          ),
          // color: const Color.fromRGBO(182, 244, 255, 1),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Column(
              children: photos
                  .take(taken)
                  .slices(rowSize)
                  .mapIndexed((colNum, photos) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: photos.mapIndexed((rowNum, photo) {
                    return Stack(
                      children: [
                        SizedBox(
                          width: itemSize.width,
                          height: itemSize.height,
                          child: Builder(
                            builder: (_) {
                              switch (photo.uploading) {
                                case UploadingStatus.none:
                                  return BlurHashFadeInImage(photo: photo);
                                case UploadingStatus.waiting:
                                case UploadingStatus.done:
                                  return _UploadingPhoto(photo: photo);
                              }
                            },
                          ),
                        ),
                        if (_getCount(rowNum, colNum) == taken &&
                            leftCount > 0 &&
                            !isUploadingAny)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withAlpha(150),
                              child: Center(
                                child: Text(
                                  '+ $leftCount',
                                  style: context.textTheme.displaySmall!
                                      .copyWith(color: Colors.white70),
                                ),
                              ),
                            ),
                          ),
                        if (photo.isUploading)
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(150),
                              ),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        if (photo.isUploading)
                          const Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: syncAnimatedIconLarge,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        ),
        // if (hasPhoto)
        if (!isUploadingAny)
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(150),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: _MessageMetaInfo(message: message),
              ),
            ),
          )
      ],
    );
  }
}

class _UploadingPhoto extends StatelessWidget {
  const _UploadingPhoto({super.key, required this.photo});

  final ChatMessagePhoto photo;

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      photo.bytes!,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
  }
}

class BlurHashFadeInImage extends StatelessWidget {
  final ChatMessagePhoto photo;

  const BlurHashFadeInImage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        flutterBlurHash.BlurHash(hash: photo.blurHash),
        FadeInImage.memoryNetwork(
          // key: ValueKey(photo.id),
          placeholder: kTransparentImage,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeInCurve: Curves.easeIn,
          image: photo.url!,
          fit: BoxFit.cover,
          // width: double.maxFinite,
        ),
      ],
    );
  }
}
