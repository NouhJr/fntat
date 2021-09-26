import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  bool _obsecure = true;
  late AuthBloc authBloc;

  @override
  void dispose() {
    super.dispose();
    _phone.dispose();
    _password.dispose();
  }

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  final error = BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is AuthenticationErrorState) {
      return Text(
        state.message,
        style: KSubErrorStyle,
        textAlign: TextAlign.center,
      );
    } else if (state is LodingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 3.0,
        ),
      );
    } else {
      return Container();
    }
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => {
          if (state is SignInSuccessState)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/Home', (route) => false),
            }
        },
        child: kIsWeb
            ? Center(
                child: Container(
                    width: 435.0,
                    height: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          child: Image(
                            image: AssetImage("assets/images/10839772.jpg"),
                            fit: BoxFit.cover,
                            width:
                                // 1080.0,
                                double.infinity,
                            height:
                                // 2280.0,
                                double.infinity,
                          ),
                        ),
                        ListView(
                          children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: KPrimaryColor.withOpacity(0.5),
                              ),
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    child: Text(
                                      "Signin now and meet awesome people around the world",
                                      style: KSubPrimaryFontStyleLarge,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: basicTextField(_phone, "Phone"),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: passwordTextField(
                                      _password,
                                      "Password",
                                      _obsecure,
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obsecure = !_obsecure;
                                          });
                                        },
                                        icon: Icon(
                                          _obsecure
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 25.0,
                                        ),
                                        color: KPrimaryColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    child: Center(
                                      child: TextButton(
                                          onPressed: () => {
                                                Navigator.pushNamed(
                                                    context, '/FindAccount'),
                                              },
                                          child: Text(
                                            "Forgot password?",
                                            style: TextStyle(
                                              color: KPrimaryFontsColor,
                                              fontSize: 16.0,
                                            ),
                                          )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Center(
                                    child: Container(
                                      width: 120.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 3.0,
                                          color: KSubPrimaryColor,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      child: Center(
                                        child: InkWell(
                                          onTap: signIn,
                                          child: Text(
                                            "Sign in",
                                            style:
                                                KSubSubPrimaryButtonsFontStyle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  error,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      child: Image(
                        image: AssetImage("assets/images/10839772.jpg"),
                        fit: BoxFit.cover,
                        width:
                            // 1080.0,
                            double.infinity,
                        height:
                            // 2280.0,
                            double.infinity,
                      ),
                    ),
                    ListView(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: KPrimaryColor.withOpacity(0.5),
                          ),
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Signin now and meet awesome people around the world",
                                  style: KSubPrimaryFontStyleLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: basicTextField(_phone, "Phone"),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: double.infinity,
                                height: 50.0,
                                child: passwordTextField(
                                  _password,
                                  "Password",
                                  _obsecure,
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _obsecure = !_obsecure;
                                      });
                                    },
                                    icon: Icon(
                                      _obsecure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 25.0,
                                    ),
                                    color: KPrimaryColor,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                child: Center(
                                  child: TextButton(
                                      onPressed: () => {
                                            Navigator.pushNamed(
                                                context, '/FindAccount'),
                                          },
                                      child: Text(
                                        "Forgot password?",
                                        style: TextStyle(
                                          color: KPrimaryFontsColor,
                                          fontSize: 16.0,
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              Center(
                                child: Container(
                                  width: 120.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3.0,
                                      color: KSubPrimaryColor,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  child: Center(
                                    child: InkWell(
                                      onTap: signIn,
                                      child: Text(
                                        "Sign in",
                                        style: KSubSubPrimaryButtonsFontStyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              error,
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text(
      //     "Sign in",
      //     style: KPrimaryButtonsFontStyle,
      //   ),
      //   backgroundColor: KPrimaryColor,
      //   isExtended: true,
      //   onPressed: signIn,
      // ),
    );
  }

  Future signIn() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Please turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_phone.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Phone field can't be empty !",
        message: "Please enter your phone.",
        icons: Icons.warning,
      );
    } else if (_password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: "Please enter your password.",
        icons: Icons.warning,
      );
    } else {
      authBloc.add(
          SignInButtonPressed(phone: _phone.text, password: _password.text));
    }
  }
}
