import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/User_Interface/resetPassword_screen.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class FindAccountByPhone extends StatefulWidget {
  @override
  _FindAccountByPhoneState createState() => _FindAccountByPhoneState();
}

class _FindAccountByPhoneState extends State<FindAccountByPhone> {
  TextEditingController _phone = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _phone.dispose();
  }

  late AuthBloc authBloc;
  @override
  void initState() {
    super.initState();
    authBloc = BlocProvider.of<AuthBloc>(context);
  }

  final error = BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is FindByPhoneSucessState) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcom ${state.userName}, Continue to password reset',
            style: KErrorStyle,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            width: 190.0,
            height: 30.0,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: KPrimaryColor,
              ),
              borderRadius: BorderRadius.all(Radius.circular(35.0)),
            ),
            child: Center(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResetPassword(
                        userID: state.userID,
                      ),
                    ),
                  );
                },
                child: Text(
                  "Reset Password",
                  style: KSubPrimaryButtonsFontStyle,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (state is LodingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubPrimaryColor,
          color: KPrimaryColor,
          strokeWidth: 3.0,
        ),
      );
    } else if (state is ResetPasswordErrorState) {
      return Center(
        child: Text(
          state.message,
          style: KErrorStyle,
        ),
      );
    } else {
      return Container();
    }
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        backgroundColor: KSubPrimaryColor,
        title: Text(
          APPNAME,
          style: AppNameStyle,
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) => {},
        child: kIsWeb
            ? Center(
                child: Container(
                  width: 435.0,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        child: Text(
                          "Find account by phone",
                          style: KPrimaryFontStyle,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: basicTextField(_phone, "Phone"),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        width: 90.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: KPrimaryColor,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(35.0)),
                        ),
                        child: Center(
                          child: InkWell(
                            onTap: findUserByPhone,
                            child: Text(
                              "Find",
                              style: KSubPrimaryButtonsFontStyle,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      error,
                    ],
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "Find account by phone",
                        style: KPrimaryFontStyle,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      child: basicTextField(_phone, "Phone"),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      width: 90.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: KPrimaryColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: findUserByPhone,
                          child: Text(
                            "Find",
                            style: KSubPrimaryButtonsFontStyle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    error,
                  ],
                ),
              ),
      ),
    );
  }

  Future findUserByPhone() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_phone.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Phone field can't be empty !",
        message: 'Please enter your phone.',
        icons: Icons.warning,
      );
    } else {
      authBloc.add(FindByPhoneButtonPressed(phone: _phone.text));
    }
  }
}
