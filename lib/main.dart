import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_app/app_layout/app_layout.dart';
import 'package:social_app/modules/login_page/login_cubit/login_cubit.dart';
import 'package:social_app/modules/login_page/login_page.dart';
import 'package:social_app/modules/signup_page/signup_cubit/signup_cubit.dart';
import 'package:social_app/shared/cash_helper.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';
import 'package:social_app/shared/cubit/bloc_observer.dart';
import 'package:social_app/shared/them/app_them.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CashHelper.init();
  BlocOverrides.runZoned(
    () {},
    blocObserver: MyBlocObserver(),
  );
  FirebaseMessaging.onMessage.listen((message) {
    showNotification(
      body: message.notification!.body!,
      title: message.notification!.title!,
    );
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpCubit()),
        BlocProvider(create: (context) => LogInCubit()),
        BlocProvider(create: (context) => AppCubit()..getUserData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightThem(),
        title: 'Social app',
        home: CashHelper.getData(key: 'uID') == null
            ? const LogIn()
            : SocialAppLayout(),
      ),
    );
  }
}

void showNotification({
  required String title,
  required String body,
}) async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  FlutterLocalNotificationsPlugin()
      .initialize(initializationSettings, onSelectNotification: (payload) {});
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_ID', 'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      playSound: true,
      showProgress: true,
      priority: Priority.high,
      ticker: 'test ticker');

  var iOSChannelSpecifics = const IOSNotificationDetails();
  NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
  await FlutterLocalNotificationsPlugin()
      .show(0, title, body, platformChannelSpecifics, payload: 'test');
}
