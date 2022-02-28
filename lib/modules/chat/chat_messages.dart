import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/shared/components/custom_text_form_field.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

class ChatMessages extends StatelessWidget {
  dynamic user;
  var messageController = TextEditingController();

  ChatMessages({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
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
                      style: Theme.of(context).textTheme.headline6),
                  SizedBox(height: height * 0.005),
                  Text(user['email'],
                      style: Theme.of(context).textTheme.caption),
                ],
              ),
            ),
          ],
        ),
      ),
      body: AppCubit.get(context).userModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .doc(AppCubit.get(context).userModel!.uID)
                        .collection(user['uID'])
                        .orderBy('date')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        dynamic messages = snapshot.data!.docs;
                        if (messages.isEmpty) {
                          return const Center(
                            child: Text('no messages'),
                          );
                        } else {
                          return ListView.builder(
                            reverse: true,
                            itemBuilder: (context, i) {
                              int index = messages.length - 1 - i;
                              if (messages[index]['senderUID'] ==
                                  AppCubit.get(context).userModel!.uID) {
                                return sentMessage(
                                    message: messages[index]['message']);
                              } else {
                                return receivedMessage(
                                    message: messages[index]['message']);
                              }
                            },
                            itemCount: messages.length,
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
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFormField(
                    prefixIcon: const Icon(CupertinoIcons.text_cursor),
                    hintText: 'enter message',
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'please enter your message';
                      }
                      return null;
                    },
                    controller: messageController,
                    inputType: TextInputType.text,
                    suffix: IconButton(
                        onPressed: () {
                          AppCubit.get(context).sendMessage(
                              receiverUID: user['uID'],
                              message: messageController.text,
                              date: DateTime.now());
                          messageController.text = '';
                        },
                        icon: const Icon(
                          CupertinoIcons.arrowshape_turn_up_right_fill,
                          color: Colors.blue,
                        )),
                  ),
                ),
              ],
            ),
    );
  }

  Widget receivedMessage({required message}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.07, vertical: width * 0.02),
          margin: EdgeInsets.only(
            left: width * 0.03,
            right: width * 0.25,
            top: width * 0.02,
            bottom: width * 0.02,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.black54,
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget sentMessage({required message}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.07, vertical: width * 0.02),
          margin: EdgeInsets.only(
            right: width * 0.03,
            left: width * 0.25,
            top: width * 0.02,
            bottom: width * 0.02,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.blue,
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
