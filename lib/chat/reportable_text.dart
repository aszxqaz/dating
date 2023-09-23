import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportableText extends StatefulWidget {
  const ReportableText({
    super.key,
    required this.text,
    required this.onSizeChanged,
  });

  final String text;
  final ValueChanged<Size> onSizeChanged;

  @override
  State<ReportableText> createState() => _ReportableTextState();
}

class _ReportableTextState extends State<ReportableText> {
  late GlobalKey textKey;

  @override
  void initState() {
    textKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      child: BlocProvider<ReportableCubit>(
        create: (_) => ReportableCubit(widget.text),
        child: BlocBuilder<ReportableCubit, ReportableState>(
          buildWhen: (previous, current) => previous.text != current.text,
          builder: (context, state) => InvisibleText(
            text: state.text,
            onChanged: () {
              debugPrint('calculated');

              final ctx = textKey.currentContext;
              if (ctx != null) {
                final size = ctx.size;
                if (size != null) {
                  context.read<ReportableCubit>().setSize(size);
                  widget.onSizeChanged(size);
                }
              }
            },
            textKey: textKey,
          ),
        ),
      ),
    );
  }
}

class ReportableState {
  const ReportableState({required this.text, this.size});
  final String text;
  final Size? size;
}

class ReportableCubit extends Cubit<ReportableState> {
  ReportableCubit(String text) : super(ReportableState(text: text));

  void setText(String text) {
    emit(ReportableState(text: text, size: state.size));
  }

  void setSize(Size? size) {
    emit(ReportableState(text: state.text, size: size));
  }
}

class InvisibleText extends StatefulWidget {
  const InvisibleText({
    super.key,
    required this.text,
    required this.onChanged,
    required this.textKey,
  });

  final String text;
  final VoidCallback onChanged;
  final Key textKey;

  @override
  State<InvisibleText> createState() => _InvisibleTextState();
}

class _InvisibleTextState extends State<InvisibleText> {
  @override
  void didUpdateWidget(covariant InvisibleText oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onChanged();
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      key: widget.textKey,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }

  Size? getSize(GlobalKey key) {
    return key.currentContext?.size;
  }
}
