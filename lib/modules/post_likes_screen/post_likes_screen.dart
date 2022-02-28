import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/components/default_follow_button.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

class ViewPostLikes extends StatelessWidget {
  const ViewPostLikes({Key? key, required this.postLikes}) : super(key: key);

  final List postLikes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.05),
      child: postLikes.isEmpty
          ? const Center(
              child: Text('no likes yet'),
            )
          : ListView.separated(
              itemBuilder: (context, index) => StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('usersData')
                      .doc(postLikes[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    dynamic user = snapshot.data;
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    } else {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: width * 0.06,
                            backgroundImage: NetworkImage(user['profileImage']),
                          ),
                          SizedBox(
                            width: width * 0.03,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                SizedBox(height: height * 0.005),
                                Text(user['email'],
                                    style: Theme.of(context).textTheme.caption),
                              ],
                            ),
                          ),
                          if (user['uID'] !=
                              AppCubit.get(context).userModel!.uID)
                            DefaultFollowButton(followingUID: user['uID']),
                        ],
                      );
                    }
                  }),
              separatorBuilder: (context, index) => SizedBox(
                    height: height * 0.04,
                  ),
              itemCount: postLikes.length),
    );
  }
}
