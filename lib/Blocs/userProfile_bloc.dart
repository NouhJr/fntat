import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fntat/Blocs/States/userProfile_states.dart';
import 'package:fntat/Blocs/Events/userProfile_events.dart';
import 'package:fntat/Data/userProfile_data.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  UserProfileApi api;
  UserProfileBloc(UserProfileState initialState, this.api)
      : super(initialState);

  @override
  Stream<UserProfileState> mapEventToState(UserProfileEvent event) async* {
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
        yield UserProfileInitialState();
      } else if (addPostData['success'] == true) {
        yield AddPostSuccessState();
        yield UserProfileInitialState();
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
    } else if (event is FollowButtonPressed) {
      yield UserProfileLoadingState();
      var followUserData = await api.followUser(event.userID);
      if (followUserData == 400 || followUserData['success'] == false) {
        yield FollowUserErrorState(msg: "Failed to follow this user");
      } else if (followUserData['success'] == true) {
        yield FollowUserSuccessState();
      }
    } else if (event is UnFollowButtonPressed) {
      var unFollowUserData = await api.unFollowUser(event.userID);
      if (unFollowUserData == 400 || unFollowUserData['success'] == false) {
        yield UnFollowUserErrorState();
      } else if (unFollowUserData['success'] == true) {
        yield UnFollowUserSuccessState();
      }
    } else if (event is DeletePostButtonPressed) {
      var deletePostData = await api.deletePost(event.postID);
      if (deletePostData == 400 || deletePostData['success'] == false) {
        yield DeletePostErrorState();
        yield UserProfileInitialState();
      } else if (deletePostData['success'] == true) {
        yield DeletePostSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is EditPostButtonPressed) {
      yield UserProfileLoadingState();
      var editPostData = await api.editPost(event.post, event.postID);
      if (editPostData == 400 || editPostData['success'] == false) {
        yield EditPostErrorState();
        yield UserProfileInitialState();
      } else if (editPostData['success'] == true) {
        yield EditPostSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is EditPostWithImageButtonPressed) {
      yield UserProfileLoadingState();
      var editPostData = await api.editPostWithImage(
          event.post, event.postImage, event.postID);
      if (editPostData == 400 || editPostData['success'] == false) {
        yield EditPostErrorState();
        yield UserProfileInitialState();
      } else if (editPostData['success'] == true) {
        yield EditPostSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is SharePostButtonPressed) {
      yield UserProfileLoadingState();
      var sharePostData = await api.sharePost(event.post, event.postID);
      if (sharePostData == 400 || sharePostData['success'] == false) {
        yield SharePostErrorState();
        yield UserProfileInitialState();
      } else if (sharePostData['success'] == true) {
        yield SharePostSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is AddCommentButtonPressed) {
      yield UserProfileLoadingState();
      var addCommentData = await api.addComment(event.postID, event.comment);
      if (addCommentData == 400 || addCommentData["success"] == false) {
        yield AddCommentErrorState();
        yield UserProfileInitialState();
      } else if (addCommentData["success"] == true) {
        yield AddCommentSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is DeleteCommentButtonPressed) {
      yield UserProfileLoadingState();
      var deleteCommentData =
          await api.deleteComment(event.postID, event.commentID);
      if (deleteCommentData == 400 || deleteCommentData["success"] == false) {
        yield DeleteCommentErrorState();
        yield UserProfileInitialState();
      } else if (deleteCommentData["success"] == true) {
        yield DeleteCommentSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is EditCommentButtonPressed) {
      yield UserProfileLoadingState();
      var editComment = await api.editComment(event.comment, event.commentID);
      if (editComment == 400 || editComment["success"] == false) {
        yield EditCommentErrorState();
        yield UserProfileInitialState();
      } else if (editComment["success"] == true) {
        yield EditCommentSuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is AddReplyButtonPressed) {
      yield UserProfileLoadingState();
      var addReplyData =
          await api.addReply(event.postID, event.commentID, event.reply);
      if (addReplyData == 400 || addReplyData["success"] == false) {
        yield AddReplyErrorState();
        yield UserProfileInitialState();
      } else if (addReplyData["success"] == true) {
        yield AddReplySuccessState();
        yield UserProfileInitialState();
      }
    } else if (event is GettingHomePagePostsEvent) {
      var homePagePostsData = await api.gettingHomePagePosts();
      if (homePagePostsData == 400) {
        yield GettingHomePagePostsErrorState(error: "Error getting posts");
      } else if (homePagePostsData["success"] == true) {
        yield GettingHomePagePostsSuccessState(
            posts: homePagePostsData['data']['data']);
      }
    } else if (event is DeleteMessageButtonPressed) {
      yield UserProfileLoadingState();
      var deleteMessageData = await api.deleteMessage(event.messageID);
      if (deleteMessageData == 400 || deleteMessageData['success'] == false) {
        yield DeleteMessageErrorState();
      } else if (deleteMessageData['success'] == true) {
        yield DeleteMessageSuccessState();
      }
    }
  }
}
