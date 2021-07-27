import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Data/authentication_data.dart';
import 'package:fntat/User_Interface/suggestions_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'User_Interface/home_screen.dart';
import 'User_Interface/landing_screen.dart';
import 'User_Interface/resetPassword_screen.dart';
import 'User_Interface/signIn_screen.dart';
import 'User_Interface/signUp_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString("TOKEN");
  runApp(MaterialApp(
    title: "Fntat",
    theme: ThemeData(
      primaryColor: KPrimaryColor,
      primarySwatch: Colors.green,
    ),
    home: AnimatedSplashScreen(
        duration: 3000,
        splash: Container(child: Image.asset("assets/images/fntat.png")),
        nextScreen: token == null ? Initial() : Home(),
        splashTransition: SplashTransition.sizeTransition,
        backgroundColor: KSubPrimaryColor),
  ));
}

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(InitialState(), AuthApi())),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Landing(),
          '/SignIn': (context) => SignIn(),
          '/SignUp': (context) => SignUp(),
          '/Suggestions': (context) => Suggestions(),
          '/Home': (context) => Home(),
          '/ResetPassword': (context) => ResetPassword(),
        },
      ),
    );
  }
}
