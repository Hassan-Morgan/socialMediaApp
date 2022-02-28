import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/add_post/add_post.dart';
import 'package:social_app/modules/chat/chat_home.dart';
import 'package:social_app/modules/home_page/home_page.dart';
import 'package:social_app/modules/login_page/login_page.dart';
import 'package:social_app/modules/notifications_page/notifications.dart';
import 'package:social_app/modules/user_profile/user_profile.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';
import 'package:social_app/shared/cubit/app_states.dart';

class SocialAppLayout extends StatefulWidget {
  SocialAppLayout({Key? key}) : super(key: key);

  @override
  State<SocialAppLayout> createState() => _SocialAppLayoutState();
}

class _SocialAppLayoutState extends State<SocialAppLayout> {
  bool isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  List<String> pageTitle = [
    'Home',
    'Profile',
    '',
    'Notifications',
    'Chats',
  ];

  List<Widget> pages = [
    HomePage(),
    UserProfile(),
    SizedBox(),
    Notifications(),
    ChatsHome(),
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AppCubit()..getUserData(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is GetUserDataLoadingState ||
                  state is GetPostsLoadingState,
              builder: (context) => const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              fallback: (context) => ConditionalBuilder(
                  condition: state is GetUserDataErrorState ||
                      state is GetPostsErrorState,
                  builder: (context) => const Scaffold(
                        body: Center(
                          child: Text('network error'),
                        ),
                      ),
                  fallback: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(pageTitle[
                              AppCubit.get(context).navigationBarIndex]),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LogIn()),
                                  (route) => false,
                                );
                                AppCubit.get(context).logout();
                              },
                              icon: const Icon(
                                Icons.logout,
                              ),
                            ),
                          ],
                        ),
                        body: Column(
                          children: [
                            pages[AppCubit.get(context).navigationBarIndex],
                          ],
                        ),
                        bottomNavigationBar: BottomNavigationBar(
                          currentIndex:
                              AppCubit.get(context).navigationBarIndex,
                          items: [
                            const BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.home), label: 'Home'),
                            BottomNavigationBarItem(
                                icon: CircleAvatar(
                                  radius: width * 0.04,
                                  backgroundImage: NetworkImage(
                                    AppCubit.get(context)
                                        .userModel!
                                        .profileImage,
                                  ),
                                ),
                                label: 'Profile'),
                            BottomNavigationBarItem(
                                icon: FloatingActionButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AddPost()));
                                  },
                                  child: const Icon(Icons.add,
                                      color: Colors.white),
                                ),
                                label: 'Personal Page'),
                            const BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.bell_fill),
                                label: 'Notification'),
                            const BottomNavigationBarItem(
                                icon: Icon(CupertinoIcons.chat_bubble_fill),
                                label: 'Chats'),
                          ],
                          type: BottomNavigationBarType.fixed,
                          showUnselectedLabels: false,
                          onTap: (index) {
                            AppCubit.get(context)
                                .changeNavigationBar(index: index);
                          },
                        ),
                      )));
        },
      ),
    );
  }
}
