import 'package:flutter/material.dart';

class SliderIndicator extends StatelessWidget {
  const SliderIndicator({
    super.key,
    required this.activeIndex,
    required this.count,
  });

  final int activeIndex;
  final int count;

  static double calcWidth(int count) => 24 + 6 * count + (count - 1) * 8;

  // static const opacities = [0.22, 0.17, 0.1, 0.05];
  // static const circleSize

  @override
  Widget build(BuildContext context) {
    return count > 1
        ? Material(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  count * 2 - 1,
                  (index) => index % 2 == 0
                      ? Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            // shape: BoxShape.circle,
                            color: index == activeIndex * 2
                                ? Colors.white.withOpacity(0.7)
                                : Colors.white.withOpacity(0.2),
                          ),
                        )
                      : const SizedBox(
                          width: 8,
                        ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
