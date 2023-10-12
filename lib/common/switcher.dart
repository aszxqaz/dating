import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconSwitcher extends StatelessWidget {
  const IconSwitcher({
    super.key,
    required this.notifier,
  });

  final IconSwitcherChangeNotifier notifier;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 200);

    final bgColorTween = ColorTween(
      begin: const Color.fromRGBO(151, 240, 255, 1),
      end: const Color.fromRGBO(45, 93, 101, 1),
    );

    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, value, child) {
        return Material(
          clipBehavior: Clip.antiAlias,
          // color: bgColorTween.transform(1)!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          elevation: 5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: bgColorTween.transform(value ? 1 : 0),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: InkWell(
                  onTap: () => notifier.setValue(true),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/icons/hot.svg',
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(105, 177, 189, 1),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: bgColorTween.transform(value ? 0 : 1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: InkWell(
                  onTap: () => notifier.setValue(false),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(32, 12, 32, 12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/icons/search.svg',
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(105, 177, 189, 1),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class IconSwitcherChangeNotifier extends ValueNotifier<bool> {
  IconSwitcherChangeNotifier([bool? initial]) : super(initial ?? true);

  setValue(bool val) {
    value = val;
  }

  toggle() {
    value = !value;
  }
}
