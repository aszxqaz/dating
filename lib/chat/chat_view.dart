// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dating/chat/chat_message.dart';
import 'package:dating/chat/chat_message/split_into_chunks.dart';
import 'package:dating/chat/chat_message_widget.dart';
import 'package:dating/chat/reportable_text.dart';
import 'package:dating/misc/extensions.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  static get route => MaterialPageRoute(builder: (_) => const Chat());

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String text = '';
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                'https://irjjsabacwnigkefmlpz.supabase.co/storage/v1/object/public/photos/09a3d2cc-36b5-4693-b406-0d3d53845ab6/6af093a3-763f-4a3c-80e3-f274d75aa925.jpg',
                // alignment: Alignment.topCenter,
              ),
              radius: 20,
            ),
            const SizedBox(width: 10),
            const Text('Anastasia'),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 50,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ChatMessageWidget(
                            message: ChatMessage.fromJson(
                              {
                                'text': 'Hello\nWorld\n',
                                'emojis': [
                                  {
                                    "pos": 7,
                                    "kind": 1,
                                  }
                                ]
                              },
                            ),
                          ),
                          const Text('Example: '),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary.lighten(0.1),
                    boxShadow: [
                      BoxShadow(blurRadius: 5, color: Colors.black38),
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        offset: const Offset(0, 0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocProvider<TextEditCubit>(
                      create: (context) => TextEditCubit(),
                      child: Row(
                        children: [
                          Builder(builder: (context) {
                            return IconButton(
                              onPressed: () {
                                context
                                    .read<TextEditCubit>()
                                    .insertEmoji(controller.selection.start);
                              },
                              icon: Icon(
                                Icons.emoji_emotions,
                                size: 24,
                                color: Colors.white70,
                              ),
                            );
                          }),
                          Expanded(
                            child: BlocBuilder<TextEditCubit, TextEditState>(
                              builder: (context, state) {
                                return Stack(
                                  children: [
                                    BlocListener<TextEditCubit, TextEditState>(
                                      listenWhen: (previous, current) =>
                                          previous.chunks != current.chunks,
                                      listener: (context, state) {
                                        controller.text = state.chunks
                                            .map((chunk) => chunk.value)
                                            .join('   ');
                                      },
                                      child: TextField(
                                        controller: controller,
                                        onChanged: (value) => context
                                            .read<TextEditCubit>()
                                            .processText(
                                              value,
                                              controller.selection.start,
                                            ),
                                        maxLines: 5,
                                        minLines: 1,
                                        decoration:
                                            InputDecoration(isDense: true),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    ...state.chunks.mapIndexed(
                                      (index, chunk) => Positioned(
                                        child: ReportableText(
                                          text: chunk.value,
                                          onSizeChanged: (size) => context
                                              .read<TextEditCubit>()
                                              .setChunkSize(index, size),
                                        ),
                                      ),
                                    ),
                                    ...state.emojis.map(
                                      (emoji) => Positioned(
                                        left: emoji.left,
                                        bottom: 3,
                                        child: SvgPicture.asset(
                                          'assets/emoji/noto/noto1.svg',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class TextEditState {
  const TextEditState({
    required this.chunks,
    required this.emojis,
  });

  static const initial = TextEditState(
    chunks: [
      ChunkInfo(
        value: '',
        start: 0,
        end: 0,
        width: 0,
      )
    ],
    emojis: [],
  );

  final List<ChunkInfo> chunks;
  final List<EmojiInfo> emojis;

  TextEditState copyWith({
    List<ChunkInfo>? chunks,
    List<EmojiInfo>? emojis,
  }) =>
      TextEditState(
        chunks: chunks ?? this.chunks,
        emojis: emojis ?? this.emojis,
      );
}

class TextEditCubit extends Cubit<TextEditState> {
  TextEditCubit()
      : super(TextEditState(
          chunks: [],
          emojis: [],
        ));

  void processText(String text, int selection) {
    final chunks = text
        .splitIntoChunks(state.emojis.map((emoji) => emoji.pos).toList())
        .map(
          (chunk) => ChunkInfo(
            value: chunk.text,
            start: chunk.start,
            end: chunk.end,
          ),
        )
        .toList();

    emit(state.copyWith(chunks: chunks));
  }

  void insertEmoji(int selection) {
    final emoji = EmojiInfo(left: 0, bottom: 0, pos: selection);
    final emojis = [...state.emojis, emoji];

    final chunks = text
        .splitIntoChunks(emojis.map((emoji) => emoji.pos).toList())
        .map(
          (chunk) => ChunkInfo(
            value: chunk.text,
            start: chunk.start,
            end: chunk.end,
          ),
        )
        .toList();

    emit(state.copyWith(chunks: chunks));
  }

  void setChunkSize(int index, Size size) {
    final target = state.chunks[index];
    final chunks = state.chunks.slice(0, index) +
        <ChunkInfo>[target.copyWith(width: size.width)] +
        state.chunks.slice(index + 1);
    emit(state.copyWith(chunks: chunks));
  }
}

class ChunkInfo {
  const ChunkInfo({
    required this.value,
    required this.start,
    required this.end,
    this.width,
  });

  final String value;
  final int start;
  final int end;
  final double? width;

  ChunkInfo copyWith({
    String? value,
    int? start,
    int? end,
    double? width,
  }) =>
      ChunkInfo(
        value: value ?? this.value,
        start: start ?? this.start,
        end: end ?? this.end,
        width: width ?? this.width,
      );
}

class EmojiInfo {
  const EmojiInfo({
    required this.left,
    required this.bottom,
    required this.pos,
  });

  final double left;
  final double bottom;
  final int pos;

  EmojiInfo copyWith(
    double? left,
    double? bottom,
    int? pos,
  ) =>
      EmojiInfo(
        left: left ?? this.left,
        bottom: bottom ?? this.bottom,
        pos: pos ?? this.pos,
      );
}

extension IndexOf<T> on List<T> {
  int? indexFirstOrNull(bool Function(T) predicate) {
    for (int i = 0; i < length; i++) {
      if (predicate(this[i])) {
        return i;
      }
    }
    return null;
  }
}
