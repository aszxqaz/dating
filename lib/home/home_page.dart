import 'package:dating/app/app.dart';
import 'package:dating/assets/icons.dart';
import 'package:dating/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dating/extensions.dart';
import 'package:dating/home/bloc/home_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(state.tab.text),
            actions: [
              IconButton(
                onPressed: context.read<AppBloc>().signOut,
                icon: SvgPicture.asset(
                  IconAssets.exit,
                  colorFilter: ColorFilter.mode(
                    context.colorScheme.onPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const _HomeBottomNavigationBar(),
          body: Builder(
            builder: (context) {
              switch (state.tab) {
                case HomeTabs.feed:
                  return const Text('Feed');
                case HomeTabs.notifications:
                  return const Text('Notifications');
                case HomeTabs.slides:
                  return const Text('Slides');
                case HomeTabs.messages:
                  return const Text('Messages');
                case HomeTabs.user:
                  return UserView();
              }
            },
          ),
        );
      },
    );
  }
}

class _HomeBottomNavigationBar extends StatelessWidget {
  const _HomeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.onPrimaryContainer.withOpacity(0.2),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BottomNavigationBarIconButton(
                onPressed: () => context.read<HomeBloc>().setTab(HomeTabs.feed),
                isActive: state.tab == HomeTabs.feed,
                src: 'assets/icons/paper_plane.svg',
              ),
              _BottomNavigationBarIconButton(
                onPressed: () =>
                    context.read<HomeBloc>().setTab(HomeTabs.notifications),
                isActive: state.tab == HomeTabs.notifications,
                src: 'assets/icons/bell.svg',
              ),
              _BottomNavigationBarIconButton(
                onPressed: () =>
                    context.read<HomeBloc>().setTab(HomeTabs.slides),
                isActive: state.tab == HomeTabs.slides,
                src: 'assets/icons/hot.svg',
              ),
              _BottomNavigationBarIconButton(
                onPressed: () =>
                    context.read<HomeBloc>().setTab(HomeTabs.messages),
                isActive: state.tab == HomeTabs.messages,
                src: 'assets/icons/message.svg',
              ),
              _BottomNavigationBarIconButton(
                onPressed: () => context.read<HomeBloc>().setTab(HomeTabs.user),
                isActive: state.tab == HomeTabs.user,
                src: 'assets/icons/user.svg',
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _BottomNavigationBarIconButton extends StatelessWidget {
  const _BottomNavigationBarIconButton({
    super.key,
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
      icon: SvgPicture.asset(
        src,
        colorFilter: ColorFilter.mode(
          context.colorScheme.onPrimaryContainer
              .withOpacity(isActive ? 1 : 0.7),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
