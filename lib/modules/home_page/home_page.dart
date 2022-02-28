import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/default_post_card.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';
import 'package:social_app/shared/cubit/app_states.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, postSnapshot) {
            if (!postSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (postSnapshot.hasError) {
              return const Center(
                child: Text(
                    'error happened please check your internet connection'),
              );
            } else {
              var posts = postSnapshot.data!.docs;
              return Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('usersData')
                              .doc(posts[index]['uID']).snapshots(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.hasData) {
                              return DefaultPostViewer(
                                  post: posts[index], user: userSnapshot.data);
                            } else {
                              return const SizedBox();
                            }
                          });
                    },
                    itemCount: posts.length,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
