import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/components/custom_text_form_field.dart';
import 'package:social_app/shared/components/default_follow_button.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

class PostComments extends StatelessWidget {
  PostComments({Key? key, required this.postId, required this.postUID})
      : super(key: key);

  final String postId;
  final String postUID;
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            CustomTextFormField(
              prefixIcon: const Icon(Icons.comment),
              hintText: 'add your comment',
              validator: (value) {
                if (value.isEmpty) {
                  return 'add your comment first';
                }
                return null;
              },
              controller: commentController,
              inputType: TextInputType.text,
              suffix: IconButton(
                  onPressed: () {
                    AppCubit.get(context).addComment(
                      postId: postId,
                      commentText: commentController.text,
                      postUID: postUID,
                    );
                    commentController.text = '';
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  )),
            ),
            SizedBox(height: height * 0.02),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(postId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    dynamic post = snapshot.data;
                    List commentsList = post['comments'];
                    if (commentsList.isEmpty) {
                      return const Expanded(
                          child: Center(child: Text('no comments yet')));
                    } else {
                      return Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) => Container(
                                  margin: EdgeInsets.all(width * 0.02),
                                  padding: EdgeInsets.all(width * 0.02),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('usersData')
                                        .doc(commentsList[index]['uID'])
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.hasData) {
                                        dynamic user = userSnapshot.data;
                                        return Padding(
                                          padding: EdgeInsets.all(width * 0.01),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius: width * 0.06,
                                                    backgroundImage:
                                                        NetworkImage(user[
                                                            'profileImage']),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.03,
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(user['name'],
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6),
                                                        SizedBox(
                                                            height:
                                                                height * 0.005),
                                                        Text(user['email'],
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.05),
                                                child: Text(
                                                  commentsList[index]
                                                      ['comment'],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    },
                                  ),
                                ),
                            itemCount: commentsList.length),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('network error'),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
