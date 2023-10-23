part of 'incomplete_page.dart';

class _Wrapper extends StatelessWidget {
  const _Wrapper({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 96),
        Text(
          title,
          textAlign: TextAlign.center,
          style: context.textTheme.headlineSmall,
        ),
        const SizedBox(height: 48),
        child,
        const Spacer(),
        BlocSelector<IncompleteBloc, IncompleteState, String?>(
          selector: (state) => state.error,
          builder: (context, error) {
            return error != null
                ? ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      error,
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: context.colorScheme.error),
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
        const Spacer(),
        BlocBuilder<IncompleteBloc, IncompleteState>(
          buildWhen: (prev, curr) =>
              prev.loading != curr.loading || prev.stage != curr.stage,
          builder: (context, state) {
            return SubmitButton(
              submitting: state.loading,
              onPressed: IncompleteBloc.of(context).next,
              label: state.stage.isLast ? 'Finish' : 'Next',
            );
          },
        ),
        const SizedBox(height: 48),
      ],
    );
  }
}
