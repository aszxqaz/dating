part of 'incomplete_page.dart';

class _Name extends StatelessWidget {
  const _Name();

  @override
  Widget build(BuildContext context) {
    return _Wrapper(
      title: 'What is your name?',
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: BlocSelector<IncompleteBloc, IncompleteState, String?>(
              selector: (state) => state.fieldErrors['name'],
              builder: (_, nameError) {
                return BaseTextField(
                  onChanged: IncompleteBloc.of(context).changeName,
                  autofocus: true,
                  labelText: 'Name',
                  errorText: nameError,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          const Text('You can use an alias name'),
        ],
      ),
    );
  }
}
