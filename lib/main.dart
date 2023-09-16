// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dating/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dating/app/app.dart';
import 'package:dating/body.dart';
import 'package:dating/home/home_page.dart';
import 'package:dating/phone_input.dart';
import 'package:dating/pin_input.dart';
import 'package:dating/signin/phone/view/phone_view.dart';
import 'package:dating/signin/view/signin_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANONKEY']!,
  );

  runApp(
    MyApp(
      supabaseClient: Supabase.instance.client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.supabaseClient});

  final SupabaseClient supabaseClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dating App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: RepositoryProvider<SupabaseClient>.value(
        value: supabaseClient,
        child: RepositoryProvider(
          create: (context) => AuthRepository(
            supabaseClient: RepositoryProvider.of<SupabaseClient>(context),
          ),
          child: BlocProvider<AppBloc>(
            create: (context) => AppBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            ),
            child: BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                switch (state) {
                  case AppAuthenticatedState _:
                    return HomePage();
                  case AppUnauthenticatedState state:
                    switch (state.tab) {
                      case UnauthenticatedTabs.signin:
                        return SignInPage();
                      case UnauthenticatedTabs.signup:
                        return SignUpPage();
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
