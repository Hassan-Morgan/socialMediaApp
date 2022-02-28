import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

class Notifications extends StatelessWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notifications')
          .doc(AppCubit.get(context).userModel!.uID)
          .collection('newNotifications')
          .orderBy('notificationDate')
          .snapshots(),
      builder: (context, notificationsSnapshot) {
        if (!notificationsSnapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (notificationsSnapshot.hasError) {
          return const Center(
            child: Text('Network Error'),
          );
        } else {
          List notifications = notificationsSnapshot.data!.docs;
          return Expanded(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(width * 0.05),
              child: ListView.separated(
                  itemBuilder: (context, i) {
                    int index = notifications.length - 1 - i;
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('usersData')
                            .doc(notifications[index]['senderId'])
                            .snapshots(),
                        builder: (context, usersSnapshot) {
                          if (!usersSnapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (usersSnapshot.hasError) {
                            return const Center(
                              child: Text('Network Error'),
                            );
                          } else {
                            dynamic user = usersSnapshot.data;
                            var date = DateTime.parse(notifications[index]
                                    ['notificationDate']
                                .toDate()
                                .toString());
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: width * 0.06,
                                  backgroundImage:
                                      NetworkImage(user['profileImage']),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          notifications[index]
                                              ['notificationText'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                      SizedBox(height: height * 0.005),
                                      Text(
                                          '${DateFormat.yMMMMd().format(date)}  ${DateFormat.Hm().format(date)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        });
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: height * 0.05,
                      ),
                  itemCount: notifications.length),
            ),
          );
        }
      },
    );
  }
}
