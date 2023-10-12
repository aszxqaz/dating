part of 'user_view.dart';

class UploadPhotoButton extends StatelessWidget {
  const UploadPhotoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 16,
      bottom: -16,
      child: FilledIconButton(
        onPressed: () {
          uploadPhoto(context);
        },
        icon: Ionicons.add,
        offset: const Offset(0, -2),
        padding: 16,
        size: 40,
      ),
    );
  }

  Future<void> uploadPhoto(BuildContext context) async {
    final picker = ImagePicker();
    final photo = await picker.pickImage(source: ImageSource.gallery);

    if (photo != null && photo.path.endsWith('.jpg') && context.mounted) {
      try {
        final bytes = defaultTargetPlatform != TargetPlatform.windows
            ? await FlutterImageCompress.compressWithFile(
                minWidth: 800,
                minHeight: 1200,
                photo.path,
                quality: 50,
              )
            : await photo.readAsBytes();

        if (bytes != null && context.mounted) {
          context.read<UserBloc>().uploadPhoto(bytes);
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}

class PhotoLikeButton extends StatelessWidget {
  const PhotoLikeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      left: 8,
      child: BlocSelector<UserBloc, UserState, Photo?>(
        selector: (state) => state.currentPhoto,
        builder: (context, photo) {
          return photo != null
              ? ShadowedLikesButton(
                  onPressed: () {},
                  count: photo.likes.length,
                  liked: photo.likes.contains(requireUser.id),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}
