import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class TextChunk {
  TextChunk({
    required this.index,
    required this.text,
    required this.start,
    required this.end,
    this.lineBreak = false,
  });

  final String text;
  final int index;
  int start;
  int end;
  final bool lineBreak;

  static const lineSplitter = LineSplitter();

  @override
  toString() {
    return 'TextChunk (index: $index, text: "$text", start: $start, end: $end)';
  }
}

extension SplitIntoChunks on String {
  List<TextChunk> splitIntoChunks(List<int> indeces) {
    int start = 0;
    int end = 0;
    int index = 0;

    final chunks = TextChunk.lineSplitter.convert(this).fold(
      <TextChunk>[],
      (list, line) {
        debugPrint('indeces: ${indeces.toString()}');
        debugPrint('start: $start');
        debugPrint('end: ${start + line.length}');

        final splits = line.splitMultiple(indeces
            .where((i) => i > start && i < start + line.length)
            .map((i) => i - start)
            .toList());

        debugPrint('splits: ${splits.toString()}');

        if (splits.length > 1) {
          return [
            ...list,
            ...splits.map(
              (s) => TextChunk(
                index: index++,
                text: s,
                start: start,
                end: start += s.length,
              ),
            ),
            TextChunk(
              index: index++,
              text: '',
              start: start,
              end: start += 1,
              lineBreak: true,
            ),
          ];
        }

        return [
          ...list,
          TextChunk(
            index: index++,
            text: line,
            start: start,
            end: start += line.length,
          ),
          TextChunk(
            index: index++,
            text: '',
            start: start,
            end: start += 1,
            lineBreak: true,
          ),
        ];
      },
    );

    for (final chunk in chunks) {
      debugPrint(chunk.toString());
    }

    return chunks.last.lineBreak ? chunks.slice(0, chunks.length - 1) : chunks;
  }
}

extension on String {
  List<String> splitMultiple(List<int> indeces) {
    final res = <String>[];
    int curIndex = 0;

    for (final index in indeces) {
      if (index > curIndex && index <= length) {
        res.add(substring(curIndex, index));
        curIndex = index;
      }
    }

    res.add(substring(curIndex));

    return res;
  }
}
