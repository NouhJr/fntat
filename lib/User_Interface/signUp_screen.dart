import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/authentication_bloc.dart';
import 'package:fntat/Blocs/authentication_events.dart';
import 'package:fntat/Blocs/authentication_states.dart';
import 'package:fntat/Components/constants.dart';
import 'package:fntat/Components/flushbar.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _phone = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmPassword = new TextEditingController();

  bool _obsecurePassword = true;
  bool _obsecureConfirmPassword = true;

  List<String> _types = [
    'Type',
    'admin',
    'هاوي',
    'محترف',
    'وكيل',
    'اكاديميه',
    'نادي'
  ];
  String _selectedType = "Type";

  List<String> _category = ['Category', 'كره القدم', 'كره السله'];
  String _selectedCategory = "Category";

  int type = 0;
  int category = 0;

  late AuthBloc authBloc;

  @override
  void initState() {
    authBloc = BlocProvider.of<AuthBloc>(context);
    super.initState();
  }

  final error = BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
    if (state is AuthenticationErrorState) {
      return Text(
        state.message,
        style: KErrorStyle,
      );
    } else if (state is LodingState) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: KSubSecondryFontsColor,
          color: KPrimaryColor,
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
        listener: (context, state) => {
          if (state is SignUpsuccessState)
            {
              Navigator.pushNamed(context, '/Home'),
            }
        },
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Create your account",
                      style: KPrimaryFontStyleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: basicTextField(_name, "Name"),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: basicTextField(_email, "Email"),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: basicTextField(_phone, "Phone"),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: passwordTextField(
                      _password,
                      "Password",
                      _obsecurePassword,
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecurePassword = !_obsecurePassword;
                          });
                        },
                        icon: Icon(_obsecurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: passwordTextField(
                      _confirmPassword,
                      "confirm Password",
                      _obsecureConfirmPassword,
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _obsecureConfirmPassword =
                                !_obsecureConfirmPassword;
                          });
                        },
                        icon: Icon(_obsecureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButton(
                        style: KDropdownButtonStyle,
                        underline: Container(
                          width: 0.0,
                        ),
                        isExpanded: false,
                        hint: Text('Type'),
                        value: _selectedType,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedType = newValue.toString();
                          });
                        },
                        items: _types.map((type) {
                          return DropdownMenuItem(
                            child: Text(type),
                            value: type,
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        width: 40.0,
                      ),
                      DropdownButton(
                        style: KDropdownButtonStyle,
                        underline: Container(
                          width: 0.0,
                        ),
                        isExpanded: false,
                        hint: Text('Category'),
                        value: _selectedCategory,
                        onChanged: (newValuex) {
                          setState(() {
                            _selectedCategory = newValuex.toString();
                          });
                        },
                        items: _category.map((category) {
                          return DropdownMenuItem(
                            child: Text(category),
                            value: category,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    width: 150.0,
                    child: ButtonTheme(
                      minWidth: double.infinity,
                      height: 70.0,
                      buttonColor: KPrimaryColor,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(
                            1.0,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "Next",
                          style: KPrimaryButtonsFontStyle,
                        ),
                        onPressed: next,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  error
                ],
              ),
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Future next() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(
        context,
        title: "No internet connection !",
        message: "Pleas turn on wifi or mobile data",
        icons: Icons.signal_wifi_off,
      );
    } else if (_name.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Name field can't be empty !",
        message: 'Please enter your name.',
        icons: Icons.warning,
      );
    } else if (_email.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
        icons: Icons.warning,
      );
    } else if (!_email.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
    } else if (!_email.text.contains('.com')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must end with '.com' ",
        icons: Icons.warning,
      );
    } else if (_phone.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Phone field can't be empty !",
        message: 'Please enter your phone.',
        icons: Icons.warning,
      );
    } else if (_password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: 'Please enter your password.',
        icons: Icons.warning,
      );
    } else if (_confirmPassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "ConfirmPassword field can't be empty !",
        message: 'Please confirm your password.',
        icons: Icons.warning,
      );
    } else if (_password.text != _confirmPassword.text) {
      Warning().errorMessage(
        context,
        title: "Password values doesn't match !",
        message: 'Please confirm your password.',
        icons: Icons.warning,
      );
    } else if (_selectedType == "Type") {
      Warning().errorMessage(
        context,
        title: "Type can't be empty !",
        message: 'Please choose a type.',
        icons: Icons.warning,
      );
    } else if (_selectedCategory == "Category") {
      Warning().errorMessage(
        context,
        title: "Category can't be empty !",
        message: 'Please choose a category.',
        icons: Icons.warning,
      );
    } else {
      if (_selectedType == 'admin') {
        setState(() {
          type = 1;
        });
      } else if (_selectedType == 'هاوي') {
        setState(() {
          type = 2;
        });
      } else if (_selectedType == 'محترف') {
        setState(() {
          type = 3;
        });
      } else if (_selectedType == 'وكيل') {
        setState(() {
          type = 4;
        });
      } else if (_selectedType == 'اكاديميه') {
        setState(() {
          type = 5;
        });
      } else if (_selectedType == 'نادي') {
        setState(() {
          type = 6;
        });
      } else if (_selectedCategory == 'كره السله') {
        setState(() {
          category = 2;
        });
      } else if (_selectedCategory == 'كره القدم') {
        setState(() {
          category = 1;
        });
      }

      authBloc.add(SignUpButtonPressed(
          name: _name.text,
          email: _email.text,
          phone: _phone.text,
          password: _password.text,
          passwordConfirmation: _confirmPassword.text,
          type: type,
          category: category));
    }
  }
}
