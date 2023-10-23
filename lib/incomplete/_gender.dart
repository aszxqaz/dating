part of 'incomplete_page.dart';

class _Gender extends StatelessWidget {
  const _Gender();

  @override
  Widget build(BuildContext context) {
    final changeGender = IncompleteBloc.of(context).changeGender;

    return _Wrapper(
      title: 'What is your gender?',
      child: BlocSelector<IncompleteBloc, IncompleteState, Gender>(
        selector: (state) => state.gender,
        builder: (context, gender) {
          return Column(
            children: [
              Material(
                child: InkWell(
                  onTap: () => changeGender(Gender.male),
                  child: ListTile(
                    title: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Male'),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Ionicons.male,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: Radio<Gender>(
                      value: Gender.male,
                      groupValue: gender,
                      onChanged: changeGender,
                    ),
                  ),
                ),
              ),
              Material(
                child: InkWell(
                  onTap: () => changeGender(Gender.female),
                  child: ListTile(
                    title: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: 'Female'),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Ionicons.female,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    leading: Radio<Gender>(
                      value: Gender.female,
                      groupValue: gender,
                      onChanged: changeGender,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
