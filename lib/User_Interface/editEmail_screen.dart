import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditEmail extends StatefulWidget {
  @override
  _EditEmailState createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  TextEditingController _newEmail = new TextEditingController();

  late UserProfileBloc userbloc;

  @override
  void initState() {
    userbloc = BlocProvider.of<UserProfileBloc>(context);
    super.initState();
  }

  final stateWidget =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is UpdateEmailErrorState) {
      return Text(
        state.message,
        style: KErrorStyle,
      );
    } else if (state is UserProfileLoadingState) {
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
      backgroundColor: KSubPrimaryColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: KSubPrimaryColor,
        title: Text(
          "Edit Email",
          style: KScreenTitlesStyle,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: KPrimaryColor,
          ),
          onPressed: () => {
            Navigator.pop(context),
          },
        ),
        actions: [
          Row(
            children: [
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
                    onTap: updateEmail,
                    child: Text(
                      "Save",
                      style: KSubPrimaryButtonsFontStyle,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ],
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UpdateEmailSuccessState) {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Update your email",
                  style: KPrimaryFontStyle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                child: basicTextField(_newEmail, "Update Email"),
              ),
              SizedBox(
                height: 20.0,
              ),
              stateWidget,
            ],
          ),
        ),
      ),
    );
  }

  updateEmail() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_newEmail.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
        icons: Icons.warning,
      );
    } else if (!_newEmail.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
    } else if (!_newEmail.text.contains('.com')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must end with '.com' ",
        icons: Icons.warning,
      );
    } else {
      userbloc.add(EditEmailButtonPressed(newEmail: _newEmail.text));
    }
  }
}
