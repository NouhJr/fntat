import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Data/userProfile_data.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileApi api;
  UserProfileBloc(UserProfileState initialState, this.api)
      : super(initialState);

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    //var prefs = await SharedPreferences.getInstance();
    if (event is StartEvent) {
      yield UserProfileInitialState();
    } else if (event is GettingFollowingAndFollowersCount) {
      yield UserProfileLoadingState();
      print("beforeData");
      var userData = await api.getUserFollowingFollowersCount(event.id);
      print("afterData");
      if (userData == null) {
        print("error");
        yield GettingFollowingAndFollowersCountErrorState();
      } else {
        print("here");
        yield GettingFollowingAndFollowersCountSuccessState(
            followingCount: userData['user_following'],
            followersCount: userData['user_followers']);
      }
    } else if (event is EditPhoneButtonPressed) {
      yield UserProfileLoadingState();
      var editPhoneData = await api.updateUserPhone(event.newPhone);
      if (editPhoneData == null || editPhoneData == 400) {
        yield UpdatePhoneErrorState(message: "Failed to update phone");
      } else if (editPhoneData['success'] == true) {
        yield UpdatePhoneSuccessState(message: "Phone updated successfully");
      }
    }
  }
}
