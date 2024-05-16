import 'package:calorie_intake_repository/calorie_intake_repository.dart';
import 'package:kaloriabarat/pages/authenticaiton/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:kaloriabarat/pages/home/blocs/get_meals_bloc/get_meals_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'pages/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaloriabarat/pages/authenticaiton/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:kaloriabarat/pages/authenticaiton/views/authenticaion_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase Auth',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
          background: Color.fromRGBO(235, 250, 244, 1),
          onBackground: Colors.black,
          primary: Color.fromRGBO(128, 128, 128, 1),
          onPrimary: Color.fromRGBO(255, 255, 255, 1),
          secondary: Color.fromRGBO(111, 190, 170, 1),
          onSecondary: Color.fromARGB(255, 0, 0, 0),
          tertiary: Color.fromRGBO(168, 213, 202, 1),
          onTertiary: Colors.black,
          error: Color.fromARGB(255, 228, 61, 49),
          outline: Color(0xFF424242),
          surface: Color.fromRGBO(73, 230, 190, 1),
          onSurface: Colors.black,
        )),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              String? email = state.user!.email ?? '';
              MyUser user = state.myUser!;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetMealsBloc(FirebaseCalorieIntakeRepo(), user)
                          ..add(GetMeals()),
                  ),
                ],
                child: HomeScreen(userEmail: email),
              );
            } else {
              return const AuthenticationScreen();
            }
          },
        ));
  }
}
