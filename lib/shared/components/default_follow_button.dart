import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

import 'custom_material_button.dart';

class DefaultFollowButton extends StatelessWidget {
  DefaultFollowButton({Key? key, required this.followingUID}) : super(key: key);

  String followingUID;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('usersData')
            .doc(AppCubit.get(context).userModel!.uID)
            .snapshots(),
        builder: (context, snapshot) {
          dynamic user = snapshot.data;
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return ConditionalBuilder(
              condition: user['following'].contains(followingUID),
              builder: (context) => CustomMaterialButton(
                onPress: () {
                  AppCubit.get(context).unFollow(uID: followingUID);
                },
                buttonColor: Colors.grey,
                buttonName: 'unfollow',
                buttonWidth: 0.0,
              ),
              fallback: (context) => CustomMaterialButton(
                onPress: () {
                  AppCubit.get(context).follow(uID: followingUID);
                },
                buttonColor: Colors.blue,
                buttonName: 'follow',
                buttonWidth: 0.0,
              ),
            );
          }
        });
  }
}
