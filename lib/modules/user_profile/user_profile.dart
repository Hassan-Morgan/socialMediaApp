import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/shared/components/custom_material_button.dart';
import 'package:social_app/shared/components/default_post_card.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';
import 'package:social_app/shared/cubit/app_states.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is GetUserDataLoadingState,
              builder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              fallback: (context) => ConditionalBuilder(
                  condition: state is GetUserDataErrorState,
                  builder: (context) =>
                      const Center(child: Text('Network Error')),
                  fallback: (context) => StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('usersData')
                          .doc(AppCubit.get(context).userModel!.uID)
                          .snapshots(),
                      builder: (context, snapshot) {
                        dynamic user = snapshot.data;
                        if (!snapshot.hasData) {
                          return const Expanded(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image(
                                        image:
                                            NetworkImage(user!['profileImage']),
                                        width: width,
                                        height: height * 0.5,
                                        fit: BoxFit.cover,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: height * 0.32,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: width * 0.45,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.01,
                                                      vertical: height * 0.001),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                              'followers'),
                                                          Text(
                                                              '${user['followers'].length}'),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: width * 0.03,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Text(
                                                              'following'),
                                                          Text(
                                                              '${user['following'].length}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                CustomMaterialButton(
                                                  buttonColor: Colors.blue,
                                                  buttonName: 'Edit Profile',
                                                  onPress: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditProfile()));
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height * 0.005),
                                          Card(
                                            elevation: 5,
                                            color: Colors.white,
                                            margin: const EdgeInsets.all(0.0),
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(50),
                                                    topRight:
                                                        Radius.circular(50))),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: width,
                                                  padding: EdgeInsets.all(
                                                      width * 0.06),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        user['name'],
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        user['email'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.02,
                                                      ),
                                                      Text(
                                                        user['bio'],
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption!
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width * 0.06),
                                                  child: const Text(
                                                    'Posts',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                StreamBuilder<QuerySnapshot>(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('posts')
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return const Center(
                                                        child: Text(
                                                            'error happened please check your internet connection'),
                                                      );
                                                    } else {
                                                      var posts = [];
                                                      for (var element
                                                          in snapshot
                                                              .data!.docs) {
                                                        if (element['uID'] ==
                                                            AppCubit.get(
                                                                    context)
                                                                .userModel!
                                                                .uID) {
                                                          posts.add(element);
                                                        }
                                                      }
                                                      if (posts.isEmpty) {
                                                        return Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          height *
                                                                              0.1),
                                                              child: const Center(
                                                                  child: Text(
                                                                      'no posts yet add posts to view')),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        return ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return DefaultPostViewer(
                                                              post:
                                                                  posts[index],
                                                              user: AppCubit.get(
                                                                      context)
                                                                  .userModel,
                                                            );
                                                          },
                                                          itemCount:
                                                              posts.length,
                                                        );
                                                      }
                                                    }
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      })));
        });
  }
}
