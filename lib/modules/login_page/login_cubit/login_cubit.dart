import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login_page/login_cubit/login_states.dart';
import 'package:social_app/shared/cash_helper.dart';

class LogInCubit extends Cubit<LogInStates> {
  LogInCubit() : super(LogInInitialState());

  static LogInCubit get(context) => BlocProvider.of(context);

  void logIn({
    required String email,
    required String password,
  }) async {
    var deviceToken = await FirebaseMessaging.instance.getToken();
    emit(LogInLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      CashHelper.putData(key: 'uID', value: value.user!.uid);
      await FirebaseFirestore.instance
          .collection('usersData')
          .doc(value.user!.uid)
          .update({
        'devices': FieldValue.arrayUnion([deviceToken.toString()]),
      });
      emit(LogInSuccessState());
    }).catchError((error) {
      emit(LogInErrorState(error.toString()));
    });
  }
}
