import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/authentication_events.dart';
import 'package:fntat/Blocs/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Data/authentication_data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // late AuthBloc authBloc;
  // @override
  // void initState() {
  //   authBloc = BlocProvider.of<AuthBloc>(context);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(InitialState(), AuthApi()),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) => {
            if (state is SignOutSuccessState)
              {
                Navigator.pushNamed(context, '/'),
              }
          },
          child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is LodingState) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: KSubSecondryFontsColor,
                  color: KPrimaryColor,
                ),
              );
            } else {
              return Container();
            }
          }),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => {
        //     AuthBloc.add(SignOutButtonPressed()),
        //   },
        //   child: Text("LogOut"),
        // ),
      ),
    );
  }
}
