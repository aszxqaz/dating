import 'dart:math';

final rows = [1, 2, 3, 2, 2, 3, 3, 3, 3];

class _PhotoMessageSizes {
  const _PhotoMessageSizes(this.rows, this.width, this.taken, this.left);
  final int rows;
  final double width;
  final int taken;
  final int left;
}

class _PhotoMessageSizeCalculator {
  const _PhotoMessageSizeCalculator({
    this.countScaleFactor = 0.15,
    this.maxWidthFactor = 0.9,
  });

  final double countScaleFactor;
  final double maxWidthFactor;

  int _getRows(int bounded) {
    return rows[bounded - 1];
  }

  double _getWidth(int rows, double maxWidth) {
    final factor = maxWidthFactor - (3 - rows) * countScaleFactor;

    final baseWidth = factor * (maxWidth - 2) / rows;

    final width = min(baseWidth, maxWidth);

    return width;
  }

  int _getBounded(int length) {
    return min(length, 9);
  }

  _PhotoMessageSizes calc(int length, double maxWidth) {
    final bounded = min(length, 9);
    final rows = _getRows(bounded);
    final taken = bounded - bounded % rows;
    final width = _getWidth(rows, maxWidth);
    final left = length - taken;
    return _PhotoMessageSizes(rows, width, taken, left);
  }
}

void main() {
  final lengths = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  final rows = [1, 2, 3, 2, 2, 3, 3, 3, 3];
  final taken = [1, 2, 3, 4, 4, 6, 6, 6, 9];

  final calculator = _PhotoMessageSizeCalculator();

  for (int i = 0; i < lengths.length; i++) {
    print('Length: ${lengths[i]}');
    print('Expected rows: ${rows[i]}');
    print('Expected taken: ${taken[i]}');

    final result = calculator.calc(lengths[i], 400);
    print(result.rows == rows[i]);
    print(result.taken == taken[i]);
    print('Got rows: ${result.rows}');
    print('Got taken: ${result.taken}');
  }
}
