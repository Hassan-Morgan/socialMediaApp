import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/notification_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/cash_helper.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  List<PostModel> posts = [];

  XFile? profileImage;

  List<XFile> postImages = [];

  late String profileImageUrl;

  List<String> postImagesUrl = [];

  int navigationBarIndex = 0;

  void getUserData() {
    emit(GetUserDataLoadingState());
    FirebaseFirestore.instance
        .collection('usersData')
        .doc(CashHelper.getData(key: 'uID'))
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data());
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(GetUserDataErrorState());
    });
  }

  void changeNavigationBar({required int index}) {
    navigationBarIndex = index;
    emit(ChangeNavigationBarState());
    if (userModel == null) {
      getUserData();
    }
  }

  void pickImageProfile({
    required ImageSource source,
  }) {
    ImagePicker().pickImage(source: source).then((value) {
      profileImage = value;
      emit(PickProfileImageSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(PickProfileImageErrorState());
    });
  }

  Future<void> uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) async {
    emit(UpdateUserDataLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
            'users/profile_image/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(File(profileImage!.path))
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(name: name, phone: phone, bio: bio, profileImage: value);
      });
    }).catchError((error) {
      debugPrint(error.toString());
      emit(UpdateUserDataErrorState());
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    required String profileImage,
  }) {
    emit(UpdateUserDataLoadingState());
    UserModel model = UserModel(
      name: name,
      email: userModel!.email,
      phone: phone,
      uID: userModel!.uID,
      bio: bio,
      profileImage: profileImage,
      followers: userModel!.followers,
      following: userModel!.following,
      devices: userModel!.devices,
    );
    FirebaseFirestore.instance
        .collection('usersData')
        .doc(userModel!.uID)
        .update(model.toJason())
        .then((value) {
      emit(UpdateUserDataSuccessState());
      getUserData();
    }).catchError((error) {
      debugPrint(error.toString());
      emit(UpdateUserDataErrorState());
    });
  }

  void pickPostImages() {
    ImagePicker().pickMultiImage().then((value) {
      for (var element in value!) {
        postImages.add(element);
      }
      emit(PickPostImageSuccessState());
    }).catchError((error) {
      debugPrint(error.toString());
      emit(PickPostImageErrorState());
    });
  }

  Future<void> uploadPostImages() async {
    emit(AddPostLoadingState());
    for (var element in postImages) {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('postsImages/${Uri.file(element.path).pathSegments.last}')
          .putFile(File(element.path))
          .then((value) async {
        postImagesUrl.add(await value.ref.getDownloadURL());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(AddPostErrorState());
      });
    }
  }

  void addPost({
    required String date,
    required String postText,
  }) {
    emit(AddPostLoadingState());
    PostModel model = PostModel(
      uID: userModel!.uID,
      date: date,
      postText: postText,
      postImages: postImagesUrl,
      postLikes: [],
      comments: [],
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(
          model.toJson(),
        )
        .then((value) {
      postImages = [];
      postImagesUrl = [];
      emit(AddPostSuccessState());
    }).catchError((error) {
      postImages = [];
      postImagesUrl = [];
      debugPrint(error.toString());
      emit(AddPostErrorState());
    });
  }

  void likePost(
      {required String postId,
      required String postUID,
      required int postLikes}) {
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'postLikes': FieldValue.arrayUnion([userModel!.uID]),
    }).then((value) {
      if (postUID != userModel!.uID) {
        addNotification(
            receiverId: postUID,
            notificationText:
                '${userModel!.name} and $postLikes others liked your post');
      }
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  void unlikePost({required String postId}) {
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'postLikes': FieldValue.arrayRemove([userModel!.uID]),
    }).then((value) {
      emit(LikePostSuccessState());
    }).catchError((error) {
      emit(LikePostErrorState());
    });
  }

  void addComment(
      {required String postId,
      required String commentText,
      required String postUID}) {
    CommentModel model =
        CommentModel(uID: userModel!.uID, comment: commentText);
    FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'comments': FieldValue.arrayUnion([model.toJson()]),
    }).then((value) {
      if (postUID != userModel!.uID) {
        addNotification(
            receiverId: postUID,
            notificationText: '${userModel!.name} commented in your post');
      }
      emit(AddCommentSuccessState());
    }).catchError((error) {
      emit(AddCommentErrorState());
    });
  }

  void follow({
    required String uID,
  }) {
    FirebaseFirestore.instance
        .collection('usersData')
        .doc(userModel!.uID)
        .update({
      'following': FieldValue.arrayUnion([uID]),
    }).then((value) {
      FirebaseFirestore.instance.collection('usersData').doc(uID).update({
        'followers': FieldValue.arrayUnion([userModel!.uID]),
      }).then((value) {
        addNotification(
            receiverId: uID,
            notificationText: '${userModel!.name} started following you');
        emit(FollowSuccessState());
      }).catchError((error) {
        emit(FollowErrorState());
      });
    }).catchError((error) {
      emit(FollowErrorState());
    });
  }

  void unFollow({required String uID}) {
    FirebaseFirestore.instance
        .collection('usersData')
        .doc(userModel!.uID)
        .update({
      'following': FieldValue.arrayRemove([uID]),
    }).then((value) {
      FirebaseFirestore.instance.collection('usersData').doc(uID).update({
        'followers': FieldValue.arrayRemove([userModel!.uID]),
      }).then((value) {
        emit(FollowSuccessState());
      }).catchError((error) {
        emit(FollowErrorState());
      });
    }).catchError((error) {
      emit(FollowErrorState());
    });
  }

  void sendMessage({
    required String receiverUID,
    required String message,
    required DateTime date,
  }) {
    MessageModel model =
        MessageModel(userModel!.uID, receiverUID, message, date);
    FirebaseFirestore.instance
        .collection('chats')
        .doc(userModel!.uID)
        .collection(receiverUID)
        .add(model.toJason())
        .then((value) {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(receiverUID)
          .collection(userModel!.uID)
          .add(model.toJason())
          .then((value) {
        emit(SendMessageSuccessState());
      }).catchError((error) {
        debugPrint(error.toString());
        emit(SendMessageErrorState());
      });
    }).catchError((error) {
      debugPrint(error.toString());
      emit(SendMessageErrorState());
    });
  }

  void addNotification({
    required String receiverId,
    required String notificationText,
  }) {
    NotificationModel model = NotificationModel(
      notificationDate: DateTime.now(),
      notificationText: notificationText,
      receiverId: receiverId,
      senderId: userModel!.uID,
    );
    FirebaseFirestore.instance
        .collection('notifications')
        .doc(receiverId)
        .collection('newNotifications')
        .add(model.toJson())
        .then((value) {
      sendNotification(
        notificationTitle: 'New Notification',
        notificationBody: notificationText,
        receiverId: receiverId,
      );
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }

  void sendNotification({
    required String notificationTitle,
    required String notificationBody,
    required String receiverId,
  }) async {
    String serverToken =
        'AAAAqbNDFlw:APA91bH_LZF_vZfpzUElwT87KvT6Q7p4YKgF-gN0GZe8Sl6PYO4JVtFgeIJ9ks8Z3MFs3L32BzdGXnqXcwKdyHg-tbNqn2BRwz9pVw--9IYTjFdtcs8doXs8RgbB5UWNjUHfAafRVFr0';
    DocumentSnapshot<Map<String, dynamic>> receiverData =
        await FirebaseFirestore.instance
            .collection('usersData')
            .doc(receiverId)
            .get();
    List receiverDevices = receiverData.data()!['devices'];
    if(receiverDevices.isNotEmpty){
      for (var element in receiverDevices) {
        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverToken',
          },
          body: jsonEncode(
            {
              'notification': {
                'body': notificationBody,
                'title': notificationTitle,
              },
              'priority': 'high',
              'data': {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              },
              'to': element,
            },
          ),
        );
      }
    }
  }

  void logout() async {
    var deviceToken = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection('usersData')
        .doc(userModel!.uID)
        .update({
      'devices': FieldValue.arrayRemove([deviceToken]),
    });
    userModel = null;
    posts = [];
    navigationBarIndex = 0;
    CashHelper.removeData(key: 'uID');
  }
}
