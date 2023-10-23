part of 'user_view.dart';

class PrefsChipsWrapList extends StatelessWidget {
  const PrefsChipsWrapList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.lookingFor != c.profile.prefs.lookingFor,
          builder: (context, state) {
            return _LookingForChipsWrap(
              groupValue: state.profile.prefs.lookingFor,
              onSelected: (index) {
                UserBloc.of(context).changePref('looking_for', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('looking_for', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.lovelang != c.profile.prefs.lovelang,
          builder: (context, state) {
            return _LoveLanguageChipsWrap(
              groupValue: state.profile.prefs.lovelang,
              onSelected: (index) {
                UserBloc.of(context).changePref('love_lang', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('love_lang', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.nutrition != c.profile.prefs.nutrition,
          builder: (context, state) {
            return _NutritionChipsWrap(
              groupValue: state.profile.prefs.nutrition,
              onSelected: (index) {
                UserBloc.of(context).changePref('nutrition', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('nutrition', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) => p.profile.prefs.pets != c.profile.prefs.pets,
          builder: (context, state) {
            return _PetsChipsWrap(
              groupValue: state.profile.prefs.pets,
              onSelected: (index) {
                UserBloc.of(context).changePref('pets', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('pets', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.alcohol != c.profile.prefs.alcohol,
          builder: (context, state) {
            return _AlcoholChipsWrap(
              groupValue: state.profile.prefs.alcohol,
              onSelected: (index) {
                UserBloc.of(context).changePref('alcohol', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('alcohol', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.smoking != c.profile.prefs.smoking,
          builder: (context, state) {
            return _SmokingChipsWrap(
              groupValue: state.profile.prefs.smoking,
              onSelected: (index) {
                UserBloc.of(context).changePref('smoking', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('smoking', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.education != c.profile.prefs.education,
          builder: (context, state) {
            return _EducationChipsWrap(
              groupValue: state.profile.prefs.education,
              onSelected: (index) {
                UserBloc.of(context).changePref('education', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('education', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.children != c.profile.prefs.children,
          builder: (context, state) {
            return _ChildrenChipsWrap(
              groupValue: state.profile.prefs.children,
              onSelected: (index) {
                UserBloc.of(context).changePref('children', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('children', 0);
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (p, c) =>
              p.profile.prefs.workout != c.profile.prefs.workout,
          builder: (context, state) {
            return _WorkoutChipsWrap(
              groupValue: state.profile.prefs.workout,
              onSelected: (index) {
                UserBloc.of(context).changePref('workout', index);
              },
              onDeselected: () {
                UserBloc.of(context).changePref('workout', 0);
              },
            );
          },
        ),
      ],
    );
  }
}
