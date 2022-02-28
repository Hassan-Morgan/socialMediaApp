import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/signup_page/signup_cubit/states.dart';
import 'package:social_app/shared/cash_helper.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitialState());

  static SignUpCubit get(context) => BlocProvider.of(context);

  void signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    emit(SignUpLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUserFireStore(
        email: email,
        userName: name,
        phone: phone,
        uID: value.user!.uid,
      );
      CashHelper.putData(key: 'uID', value: value.user!.uid);
    }).catchError((error) {
      emit(SignUpErrorState(error.toString()));
    });
  }

  void createUserFireStore({
    required String email,
    required String userName,
    required String phone,
    required String uID,
  })async {
    var deviceToken = await FirebaseMessaging.instance.getToken();
    UserModel model = UserModel(
      name: userName,
      email: email,
      phone: phone,
      uID: uID,
      profileImage:
          'https://firebasestorage.googleapis.com/v0/b/social-app-f4842.appspot.com/o/users%2Fprofile_image%2Fdefault_user_image.jpg?alt=media&token=3361f812-0801-40e1-aa92-6886a5f62d19',
      bio: 'there is no bio please edit profile and add bio ',
      following: [],
      followers: [],
      devices: [deviceToken],
    );

    FirebaseFirestore.instance
        .collection('usersData')
        .doc(uID)
        .set(model.toJason())
        .then((value) {
      emit(SignUpSuccessState());
    }).catchError((error) {
      emit(SignUpErrorState(error));
    });
  }
}
