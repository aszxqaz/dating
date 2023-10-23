part of '../signin_screen.dart';

class _PhoneSignIn extends StatelessWidget {
  const _PhoneSignIn();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SignInBloc, SignInState, SignInStage>(
      selector: (state) => state.stage,
      builder: (_, stage) {
        return SharedAxisSwitcherBuilder(
          type: SharedAxisTransitionType.horizontal,
          builder: (_) {
            switch (stage) {
              case SignInStage.empty:
              case SignInStage.input:
                return const _PhoneSignInInput();
              case SignInStage.verify:
                return const _PhoneSignInVerify();
            }
          },
        );
      },
    );
  }
}
