import 'package:dating/app/app.dart';
import 'package:dating/home/home_page.dart';
import 'package:dating/signin/view/signin_view.dart';
import 'package:dating/signup/signup.dart';
import 'package:dating/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONKEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        fontFamily: 'Montserrat',
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => AppBloc(),
        child: BlocProvider(
          create: (_) => UserBloc(),
          child: BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              debugPrint('APP AUTH STATE BEFORE');
              if (state is AppAuthenticatedState) {
                debugPrint('LOGGED IN');
                context.read<UserBloc>().loadProfile();
              } else {
                debugPrint('LOGGED OUT');
              }
            },
            child: BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                switch (state) {
                  case AppAuthenticatedState _:
                    return const HomePage();
                  case AppUnauthenticatedState state:
                    switch (state.tab) {
                      case UnauthenticatedTabs.signin:
                        return const SignInPage();
                      case UnauthenticatedTabs.signup:
                        return const SignUpPage();
                    }
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
// kisP28HYDCJ1n709

// final supabase = Supabase.instance.client;
