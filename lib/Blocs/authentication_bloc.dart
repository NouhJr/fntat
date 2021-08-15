import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/Events/authentication_events.dart';
import 'package:fntat/Blocs/States/authentication_states.dart';
import 'package:fntat/Data/authentication_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthApi api;
  AuthBloc(AuthState initialState, this.api) : super(initialState);

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    var prefs = await SharedPreferences.getInstance();
    if (event is StartEvent) {
      yield InitialState();
    } else if (event is SignUpButtonPressed) {
      yield LodingState();
      var data = await api.signup(
        event.name,
        event.email,
        event.phone,
        event.password,
        event.passwordConfirmation,
        event.type,
        event.category,
        event.image,
      );
      if (data == 400) {
        yield AuthenticationErrorState("Registration failed");
      } else if (data['response_code'] == 400 &&
          data['message']['email']?[0] == "The email has already been taken.") {
        yield AuthenticationErrorState("The email has already been taken.");
      } else if (data['response_code'] == 400 &&
          data['message']['phone']?[0] == "The phone has already been taken.") {
        yield AuthenticationErrorState("The phone has already been taken.");
      } else {
        prefs.setString("TOKEN", data['data']['token']);
        prefs.setString("NAME", data['data']['user']['name']);
        prefs.setString("EMAIL", data['data']['user']['email']);
        prefs.setInt("USERID", data['data']['user']['id']);
        prefs.setInt("USERTYPE", event.type);
        prefs.setInt("USERSTATUS", data['data']['user']['status']);
        await api.getFirebaseToken(data['data']['user']['id']);
        yield SignUpsuccessState();
      }
    } else if (event is SignInButtonPressed) {
      yield LodingState();
      var data = await api.signin(event.phone, event.password);
      if (data == 400) {
        yield AuthenticationErrorState("Authentication failed");
      } else if (data['message'] == "User not exist" ||
          data['message'] == "wrong password") {
        yield AuthenticationErrorState(
            "Your phone number or password is incorrect");
      } else if (data['message'] == "login sucess") {
        prefs.setString("TOKEN", data['token']);
        prefs.setInt("USERID", data['user']);
        prefs.setInt("USERTYPE", data['type']);
        prefs.setInt("USERSTATUS", data['status']);
        await api.gettingUserFollowingIDs();
        await api.getFirebaseToken(data['user']);
        yield SignInSuccessState();
      }
    } else if (event is SignOutButtonPressed) {
      yield LodingState();
      await api.signout();
      yield SignOutSuccessState();
    } else if (event is ResetPasswordButtonPressed) {
      yield LodingState();
      var data = await api.resetpassword(
          event.newPassword, event.confirmPassword, event.userID);
      if (data == 400 || data['message'] == "validation error") {
        yield ResetPasswordErrorState(data['message']);
      } else if (data['message'] == "password updated successfully") {
        yield ResetPasswordSuccessState(data['message']);
      }
    } else if (event is FindByPhoneButtonPressed) {
      yield LodingState();
      var userData = await api.findUserByPhone(event.phone);
      yield FindByPhoneSucessState(
          userID: userData['data'][0]['id'],
          userName: userData['data'][0]['name']);
    }
  }
}
