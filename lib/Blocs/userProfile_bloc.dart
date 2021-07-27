import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Data/userProfile_data.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileApi api;
  UserProfileBloc(UserProfileState initialState, this.api)
      : super(initialState);

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
    var setPrefrs = await SharedPreferences.getInstance();
    if (event is StartEvent) {
      yield UserProfileInitialState();
    } else if (event is GettingFollowingAndFollowersAndPostsCount) {
      yield UserProfileLoadingState();
      var countData = await api.getUserFollowingFollowersCount();
      yield GettingFollowingAndFollowersCountSuccessState(
        followingCount: countData['user_following'],
        followersCount: countData['user_followers'],
        postsCount: countData['no_of_posts'],
      );
    } else if (event is GettingOtherUsersFollowingAndFollowersAndPostsCount) {
      yield UserProfileLoadingState();
      var otherUserCountData =
          await api.getOtherUsersFollowingFollowersCount(event.userID);
      yield GettingOtherFollowingAndFollowersCountSuccessState(
        followingCount: otherUserCountData['user_following'],
        followersCount: otherUserCountData['user_followers'],
        postsCount: otherUserCountData['no_of_posts'],
      );
    } else if (event is GettingUserProfileData) {
      yield UserProfileLoadingState();
      var userData = await api.gettingUserProfileData();
      if (userData['data'] == null) {
        yield GettingUserProfileDataErrorState(
            msg: "Error Loading Profile Data");
      } else {
        yield GettingUserProfileDataSuccessState(
            name: userData['data']['name'],
            email: userData['data']['email'],
            phone: userData['data']['phone'],
            image: userData['data']['image']);
      }
    } else if (event is GettingOtherUsersProfileData) {
      yield UserProfileLoadingState();
      var otherUserData = await api.gettingOtherUsersProfileData(event.userID);
      if (otherUserData['data'] == null) {
        yield GettingOtherUserProfileDataErrorState(
            msg: "Error Loading Profile Data");
      } else {
        yield GettingOtherUserProfileDataSuccessState(
            name: otherUserData['data']['name'],
            email: otherUserData['data']['email'],
            phone: otherUserData['data']['phone'],
            image: otherUserData['data']['image']);
      }
    } else if (event is EditPhoneButtonPressed) {
      yield UserProfileLoadingState();
      var editPhoneData = await api.updateUserPhone(event.newPhone);
      if (editPhoneData['success'] == false || editPhoneData == 400) {
        yield UpdatePhoneErrorState(message: "Failed to update phone");
      } else if (editPhoneData['success'] == true) {
        yield UpdatePhoneSuccessState(message: "Phone updated successfully");
      }
    } else if (event is EditNameButtonPressed) {
      yield UserProfileLoadingState();
      var editPhoneData = await api.updateUserName(event.newName);
      if (editPhoneData == 400) {
        yield UpdateNameErrorState(message: "Failed to update name");
      } else if (editPhoneData['success'] == true) {
        yield UpdateNameSuccessState(message: "Name updated successfully");
      }
    } else if (event is EditEmailButtonPressed) {
      yield UserProfileLoadingState();
      var editPhoneData = await api.updateUserEmail(event.newEmail);
      if (editPhoneData == 400) {
        yield UpdateEmailErrorState(message: "Failed to update email");
      } else if (editPhoneData['success'] == true) {
        yield UpdateEmailSuccessState(message: "Email updated successfully");
      }
    } else if (event is ChangePasswordButtonPressed) {
      yield UserProfileLoadingState();
      var changePasswordData = await api.changePassword(
        event.oldPassword,
        event.newPassword,
        event.confirmNewPassword,
      );
      if (changePasswordData == 400 || changePasswordData['success'] == false) {
        yield ChangePasswordErrorState(message: "Failed to change password");
      } else {
        yield ChangePasswordSuccessState(
            message: "Password updated successfully");
      }
    } else if (event is EditPictureButtonPressed) {
      yield UserProfileLoadingState();
      var editPictureData = await api.updateUserPicture(event.newPicture);
      if (editPictureData['success'] == false || editPictureData == 400) {
        yield UpdatePictureErrorState(message: "Failed to update picture");
      } else if (editPictureData['success'] == true) {
        yield UpdatePictureSuccessState(
            message: "Picture updated successfully");
      }
    } else if (event is AddNewPostButtonPressed) {
      yield UserProfileLoadingState();
      var addPostData = await api.addPost(event.post);
      if (addPostData == 400 || addPostData['success'] == false) {
        yield AddPostErrorState();
      } else if (addPostData['success'] == true) {
        yield AddPostSuccessState();
      }
    } else if (event is AddNewPostWithImageFired) {
      yield UserProfileLoadingState();
      var addPostWithImageData =
          await api.addPostWithImage(event.post, event.image);
      if (addPostWithImageData == 400 ||
          addPostWithImageData['success'] == false) {
        yield AddPostErrorState();
      } else if (addPostWithImageData['success'] == true) {
        yield AddPostSuccessState();
      }
    }
  }
}
