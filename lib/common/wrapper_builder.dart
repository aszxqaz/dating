import 'package:flutter/material.dart';

class WrapperBuilder extends StatelessWidget {
  const WrapperBuilder({
    super.key,
    required this.builder,
    this.appBar,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: builder(context, constraints),
            ),
          );
        },
      ),
    );
  }
}

class WrapperBuilder2 extends StatelessWidget {
  const WrapperBuilder2({
    super.key,
    required this.builder,
    this.appBar,
  });

  final Widget Function(BuildContext context, BoxConstraints constraints)
      builder;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.minWidth,
            ),
            child: builder(context, constraints),
          );
        },
      ),
    );
  }
}
