part of '../chat_view.dart';

class _MainPanel extends StatefulWidget {
  @override
  State<_MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<_MainPanel> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  final photoMode = ValueNotifier(false);
  final isEmojiShown = ValueNotifier(false);
  final isSendHidden = ValueNotifier(false);
  final isRecording = ValueNotifier(false);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller.addListener(() {
      // isSendHidden.value = controller.text.trim().isEmpty;
    });
    super.initState();
  }

  Future<void> uploadPhotos(BuildContext context) async {
    final files = await tryPickMultiImage();

    if (files != null && files.isNotEmpty && context.mounted) {
      PhotoUploaderBloc.of(context).processFiles(files);
    }

    // await Future.wait(photoBytes
    //     .map((bytes) => precacheImage(MemoryImage(bytes), context)));
  }

  void sendMessage(List<PhotoUploaderItem>? items) {
    final text = controller.text.trim();

    if (text.isEmpty && items == null) return;

    widget.onMessageSendPressed(text, items);
    if (text.isNotEmpty) {
      controller.text = '';
      focusNode.requestFocus();
    }
  }

  void startRecording() {
    isRecording.value = true;
  }

  void excludePhoto(int index) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.primary,
      child: Row(
        children: [
          ValueListenableBuilder(
              valueListenable: isRecording,
              builder: (_, isRecording, __) {
                return _BottomControlsButton(
                  disabled: isRecording,
                  onPressed: () => isEmojiShown.value = !isEmojiShown.value,
                  icon: Ionicons.happy_outline,
                  size: 22,
                );
              }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _EmojiTextField(
                controller: controller,
                focusNode: focusNode,
              ),
            ),
          ),
          // ---
          // --- PICK PHOTOS BUTTON
          // ---
          ValueListenableBuilder(
              valueListenable: isRecording,
              builder: (_, isRecording, __) {
                return _BottomControlsButton(
                  disabled: isRecording,
                  onPressed: () => uploadPhotos(context),
                  icon: Ionicons.images_outline,
                  size: 22,
                );
              }),
          // ---
          // --- START RECORDING AUDIO
          // ---
          _BottomControlsButton(
            onPressed: startRecording,
            icon: Ionicons.mic_outline,
          ),
          // ---
          // --- SEND MESSAGE BUTTON
          // ---
          ValueListenableBuilder(
            valueListenable: isSendHidden,
            builder: (_, isSendHidden, __) {
              return Offstage(
                offstage: isSendHidden,
                child: ValueListenableBuilder(
                  valueListenable: isRecording,
                  builder: (_, isRecording, __) {
                    return BlocBuilder<PhotoUploaderBloc, PhotoUploaderState>(
                        // buildWhen: (previous, current) => previous.ready != current.ready ,
                        builder: (context, state) {
                      return _BottomControlsButton(
                        disabled: isRecording,
                        onPressed: () => sendMessage(state.items),
                        icon: Ionicons.send_outline,
                        offset: const Offset(2, 0),
                        size: 22,
                      );
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
