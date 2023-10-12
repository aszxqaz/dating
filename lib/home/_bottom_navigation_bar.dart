part of 'home_page.dart';

class _HomeBottomNavigationBar extends StatelessWidget {
  const _HomeBottomNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onPrimaryContainer.withOpacity(0.2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BottomNavigationBarIconButton(
                  onPressed: () =>
                      context.read<HomeBloc>().setTab(HomeTabs.feed),
                  isActive: state.tab == HomeTabs.feed,
                  src: 'assets/icons/paper_plane.svg',
                ),

                /// --- NOTIFICATIONS
                BlocSelector<NotificationsBloc, NotificationsState, int>(
                  selector: (state) => state.unreadCount,
                  builder: (context, count) {
                    return Badge(
                      isLabelVisible: count > 0,
                      label: Text(count.toString()),
                      backgroundColor: Colors.green.shade600,
                      child: _BottomNavigationBarIconButton(
                        onPressed: () => context
                            .read<HomeBloc>()
                            .setTab(HomeTabs.notifications),
                        isActive: state.tab == HomeTabs.notifications,
                        src: 'assets/icons/bell.svg',
                      ),
                    );
                  },
                ),

                /// --- HOT SEARCH
                _BottomNavigationBarIconButton(
                  onPressed: () =>
                      context.read<HomeBloc>().setTab(HomeTabs.search),
                  isActive: state.tab == HomeTabs.search,
                  src: 'assets/icons/search.svg',
                ),

                /// --- HOT SLIDES
                _BottomNavigationBarIconButton(
                  onPressed: () =>
                      context.read<HomeBloc>().setTab(HomeTabs.slides),
                  isActive: state.tab == HomeTabs.slides,
                  src: 'assets/icons/hot.svg',
                ),

                /// --- CHAT MESSAGES
                BlocSelector<ChatsBloc, ChatsState, int>(
                  selector: (state) => state.unreadCount,
                  builder: (context, count) {
                    return Badge(
                      isLabelVisible: count > 0,
                      label: Text(count.toString()),
                      backgroundColor: Colors.green.shade600,
                      child: _BottomNavigationBarIconButton(
                        onPressed: () =>
                            context.read<HomeBloc>().setTab(HomeTabs.messages),
                        isActive: state.tab == HomeTabs.messages,
                        src: 'assets/icons/message.svg',
                      ),
                    );
                  },
                ),

                /// --- USER SETTINGS
                _BottomNavigationBarIconButton(
                  onPressed: () =>
                      context.read<HomeBloc>().setTab(HomeTabs.user),
                  isActive: state.tab == HomeTabs.user,
                  src: 'assets/icons/user.svg',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BottomNavigationBarIconButton extends StatelessWidget {
  const _BottomNavigationBarIconButton({
    required this.onPressed,
    required this.src,
    required this.isActive,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final String src;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: SizedBox(
        width: 20,
        height: 20,
        child: SvgPicture.asset(
          src,
          colorFilter: ColorFilter.mode(
            context.colorScheme.onPrimaryContainer
                .withOpacity(isActive ? 0.7 : 0.3),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
