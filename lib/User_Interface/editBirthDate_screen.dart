import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/userProfile_bloc.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class EditBirthDate extends StatefulWidget {
  @override
  _EditBirthDateState createState() => _EditBirthDateState();
}

class _EditBirthDateState extends State<EditBirthDate> {
  late UserProfileBloc userbloc;
  var birthDate;

  @override
  void initState() {
    userbloc = BlocProvider.of<UserProfileBloc>(context);
    super.initState();
  }

  final stateWidget =
      BlocBuilder<UserProfileBloc, UserProfileState>(builder: (context, state) {
    if (state is UpdateBirthDateErrorState) {
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
                    onTap: () {
                      updateBirthDate();
                    },
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
          if (state is UpdateBirthDateSuccessState) {
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
                  "Update your Birthdate",
                  style: KPrimaryFontStyle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Select Birthdate:",
                    style: KTextFieldStyle,
                  ),
                  SizedBox(
                    width: 15.0,
                  ),
                  IconButton(
                    onPressed: () {
                      selectDate(context);
                    },
                    icon: Icon(
                      Icons.date_range,
                      color: KPrimaryColor,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
              birthDate != null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'New BirthDate: $birthDate',
                          style: KTextFieldStyle,
                        ),
                      ],
                    )
                  : Container(),
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

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime(2021),
      firstDate: DateTime(1980),
      lastDate: DateTime(2080),
      helpText: "Select your birth date",
    );
    if (selected != null)
      setState(() {
        birthDate = '${selected.year}-${selected.month}-${selected.day}';
      });
  }

  updateBirthDate() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (birthDate == null) {
      Warning().errorMessage(
        context,
        title: "Birthdate field can't be empty !",
        message: 'Please select your birth date.',
        icons: Icons.warning,
      );
    } else {
      userbloc.add(EditBirthDateButtonPressed(birthDate: birthDate));
    }
  }
}
