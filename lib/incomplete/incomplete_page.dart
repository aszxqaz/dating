import 'package:animations/animations.dart';
import 'package:dating/common/animations.dart';
import 'package:dating/common/date_field.dart';
import 'package:dating/common/phone_field/phone_field.dart';
import 'package:dating/common/wrapper_builder.dart';
import 'package:flutter/material.dart';

part '_birthdate.dart';
part '_name.dart';

class IncompletePage extends StatefulWidget {
  const IncompletePage({super.key, this.countryCode});

  final String? countryCode;

  @override
  State<IncompletePage> createState() => _IncompletePageState();
}

class _IncompletePageState extends State<IncompletePage> {
  final stage = ValueNotifier<_Stage>(_Stage.name);
  late final PhoneFieldController controller;

  @override
  void didChangeDependencies() {
    controller = PhoneFieldController(countryCode: widget.countryCode);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    controller.dispose();
    stage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WrapperBuilder(
      builder: (context, constraints) {
        return ValueListenableBuilder(
          valueListenable: stage,
          builder: (_, stage, __) {
            return Column(
              children: [
                const Text('Step 1'),
                SharedAxisSwitcher(
                  type: SharedAxisTransitionType.horizontal,
                  child: routes[stage]!,
                ),
                PhoneField(controller: controller),
              ],
            );
          },
        );
      },
    );
  }
}

enum _Stage { name, birthdate }

const routes = {
  _Stage.name: _Name(),
  _Stage.birthdate: _Birthdate(),
};
