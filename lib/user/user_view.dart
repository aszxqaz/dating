import 'package:collection/collection.dart';
import 'package:dating/common/common.dart';
import 'package:dating/common/profile_info/quote.dart';
import 'package:dating/helpers/pick_photo.dart';
import 'package:dating/misc/extensions.dart';
import 'package:dating/preferences/preferences.dart';
import 'package:dating/supabase/client.dart';
import 'package:dating/supabase/service.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

part '_chips_wrap.dart';
part '_pref_chip.dart';
part '_wrap_items.dart';
part '_wrap_list.dart';
part 'buttons.dart';
part 'user_info.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        final sliderHeight = maxHeight * 0.5;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: sliderHeight,
                      width: maxWidth,
                      decoration: BoxDecoration(
                        boxShadow: [
                          const BoxShadow(blurRadius: 3),
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            offset: const Offset(0, -3),
                          ),
                        ],
                        color: context.colorScheme.primaryContainer
                            .withOpacity(0.7),
                      ),
                      child:
                          BlocSelector<UserBloc, UserState, Iterable<String>>(
                        selector: (state) => state.profile.photoUrls,
                        builder: (context, photoUrls) {
                          return photoUrls.isNotEmpty
                              ? PhotoSlider(
                                  // controller: sliderController,
                                  photoUrls: photoUrls,
                                )
                              : const AvatarPlaceholder();
                        },
                      ),
                    ),

                    const PhotoLikeButton(),
                    const UploadPhotoButton(),

                    // --- DELETE PHOTO BUTTON
                    BlocSelector<UserBloc, UserState, bool>(
                      selector: (state) => state.profile.hasPhotos,
                      builder: (context, hasPhotos) {
                        return hasPhotos
                            ? Positioned(
                                right: 23,
                                bottom: 80,
                                child: FilledIconButton(
                                  onPressed: () async {
                                    final ok = await showGenericDialog(
                                      context: context,
                                      title: 'Delete photo',
                                      content: 'Are you sure?',
                                      actions: {'OK': true, 'Cancel': false},
                                    );
                                    if (ok == true && context.mounted) {
                                      context.read<UserBloc>().deletePhoto();
                                    }
                                  },
                                  icon: Ionicons.trash,
                                  offset: const Offset(0, -2),
                                  padding: 15,
                                  size: 28,
                                  bgColor: Colors.red.shade300,
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      UserInfo(),
                      SizedBox(height: 24),
                      PrefsChipsWrapList(),
                      SizedBox(height: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
