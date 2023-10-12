part of 'incomplete_page.dart';

class _Name extends StatefulWidget {
  const _Name();

  @override
  State<_Name> createState() => _NameState();
}

class _NameState extends State<_Name> {
  final DateFieldController controller = DateFieldController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Please enter you name'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: DateField(controller: controller),
        ),
      ],
    );
  }
}
