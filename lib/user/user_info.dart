part of 'user_view.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- NAME, AGE
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.name != c.profile.name ||
              p.profile.birthdate != c.profile.birthdate ||
              p.profile.gender != c.profile.gender,
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('User id: ${state.profile.userId}'),
                Align(
                    alignment: Alignment.centerLeft,
                    child: NameAgeInfo(state.profile)),
              ],
            );
          },
        ),
        const SizedBox(height: 4),
        // --- LOCATION
        BlocSelector<UserBloc, UserState, UserLocation>(
          selector: (state) => state.profile.location,
          builder: (context, location) {
            return LocationInfo(location: location);
          },
        ),
        const SizedBox(height: 24),

        // ---
        // --- QUOTE TEXT
        // ---
        BlocSelector<UserBloc, UserState, String>(
          selector: (state) => state.profile.quote,
          builder: (context, quote) {
            return EditableProfileQuote(
              text: quote,
              onSubmit: UserBloc.of(context).updateQuote,
            );
          },
        ),

        // ORIENTATION
        // Row(
        //   children: [
        //     const Icon(Ionicons.extension_puzzle_outline, size: 32),
        //     const SizedBox(width: 8),
        //     Text('Hetero', style: context.textTheme.bodyLarge),
        //   ],
        // ),
        // Row(
        //   children: [
        //     const Icon(Ionicons.calendar_clear_outline, size: 30),
        //     const SizedBox(width: 8),
        //     Text('18 - 35 y.o.', style: context.textTheme.bodyLarge),
        //   ],
        // ),
      ],
    );
  }
}
