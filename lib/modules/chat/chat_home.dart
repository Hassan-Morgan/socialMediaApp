import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/modules/chat/chat_messages.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

class ChatsHome extends StatelessWidget {
   ChatsHome({Key? key}) : super(key: key);

  List allUsers = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('usersData').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Network Error'),
          );
        } else {
          allUsers = snapshot.data!.docs;
          return Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) =>
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: allUsers[index]['uID'] != AppCubit
                          .get(context)
                          .userModel!
                          .uID ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChatMessages(
                                        user: allUsers[index],
                                      )));
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: width * 0.06,
                              backgroundImage:
                              NetworkImage(allUsers[index]['profileImage']),
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(allUsers[index]['name'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6),
                                  SizedBox(height: height * 0.005),
                                  Text(allUsers[index]['email'],
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .caption),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ):const SizedBox(),
                    ),
                itemCount: allUsers.length),
          );
        }
      },
    );
  }
}
