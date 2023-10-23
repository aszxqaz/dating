part of 'incomplete_page.dart';

class _Birthdate extends StatelessWidget {
  const _Birthdate();

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      title: 'What is your birthdate?',
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 240),
            child: DateField(
              onChanged: IncompleteBloc.of(context).changeBirthdate,
              autofocus: true,
            ),
          ),
          const SizedBox(height: 24),
          const Text('Your profile shows your age, not your birth date'),
        ],
      ),
    );
  }
}
