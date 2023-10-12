part of 'incomplete_page.dart';

class _Birthdate extends StatefulWidget {
  const _Birthdate();

  @override
  State<_Birthdate> createState() => _BirthdateState();
}

class _BirthdateState extends State<_Birthdate> {
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
        const Text('Please enter you birth date'),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 240),
          child: DateField(controller: controller),
        ),
        const Text('Your profile shows your age, not your birth date'),
      ],
    );
  }
}
