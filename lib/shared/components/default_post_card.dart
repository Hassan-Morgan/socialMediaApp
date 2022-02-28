import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/post_comment_screen/post_comment_screen.dart';
import 'package:social_app/modules/post_likes_screen/post_likes_screen.dart';
import 'package:social_app/shared/components/default_follow_button.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';

import '../constants.dart';

class DefaultPostViewer extends StatefulWidget {
  final dynamic post;
  final dynamic user;

  const DefaultPostViewer({Key? key, required this.post, required this.user})
      : super(
          key: key,
        );

  @override
  State<DefaultPostViewer> createState() => _DefaultPostViewerState();
}

class _DefaultPostViewerState extends State<DefaultPostViewer> {
  int currentIndex = 0;

  TextOverflow textOverFlow = TextOverflow.ellipsis;

  String showMoreText = 'show more';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(width * 0.02),
      color: Colors.white,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
            top: width * 0.03, start: width * 0.03, end: width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: width * 0.06,
                  backgroundImage: widget.user is UserModel
                      ? NetworkImage(widget.user!.profileImage)
                      : NetworkImage(widget.user['profileImage']),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          widget.user is UserModel
                              ? widget.user!.name
                              : widget.user['name'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: height * 0.005),
                      Text(widget.post['date'],
                          style: Theme.of(context).textTheme.caption),
                    ],
                  ),
                ),
                if (widget.post['uID'] != AppCubit.get(context).userModel!.uID)
                  DefaultFollowButton(followingUID: widget.post['uID']),
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.post['postText'],
                  overflow: textOverFlow,
                ),
                if (widget.post['postText'].length < 49)
                  SizedBox(
                    height: height * 0.02,
                  ),
                if (widget.post['postText'].length > 48)
                  TextButton(
                      onPressed: () {
                        if (textOverFlow == TextOverflow.ellipsis) {
                          setState(() {
                            textOverFlow = TextOverflow.visible;
                            showMoreText = 'show less';
                          });
                        } else {
                          setState(() {
                            textOverFlow = TextOverflow.ellipsis;
                            showMoreText = 'show more';
                          });
                        }
                      },
                      child: Text(showMoreText))
              ],
            ),
            if (widget.post['postImages'].isNotEmpty)
              _imagesViewer(images: widget.post['postImages']),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (widget.post['postLikes'].contains(
                              AppCubit.get(context).userModel!.uID)) {
                            AppCubit.get(context).unlikePost(
                              postId: widget.post.id,
                            );
                          } else {
                            AppCubit.get(context).likePost(
                              postId: widget.post.id,
                              postUID: widget.post['uID'],
                              postLikes: widget.post['postLikes'].length
                            );
                          }
                        },
                        icon: ConditionalBuilder(
                          condition: widget.post['postLikes']
                              .contains(AppCubit.get(context).userModel!.uID),
                          builder: (context) => const Icon(
                            CupertinoIcons.suit_heart_fill,
                            color: Colors.red,
                          ),
                          fallback: (context) =>
                              const Icon(CupertinoIcons.suit_heart),
                        )),
                    SizedBox(
                      width: width * 0.03,
                    ),
                    InkWell(
                        onTap: () {
                          showBottomSheet(
                            context: context,
                            builder: (context) => ViewPostLikes(
                                postLikes: widget.post['postLikes']),
                          );
                        },
                        child:
                            Text(widget.post['postLikes'].length.toString())),
                  ],
                ),
                InkWell(
                  onTap:  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostComments(
                              postUID: widget.post['uID'],
                              postId: widget.post.id,
                            )));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.captions_bubble),
                      SizedBox(
                        width: width * 0.03,
                      ),
                      Text(widget.post['comments'].length.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagesViewer({
    required List<dynamic> images,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CarouselSlider(
              items: images
                  .map(
                    (e) => Image(
                      image: NetworkImage(e),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() => currentIndex = index);
                },
                initialPage: 0,
                enableInfiniteScroll: false,
                aspectRatio: 1.2,
                viewportFraction: 1,
              ),
            ),
            if (images.length > 1)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: images.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.blue,
                    dotHeight: 12,
                    dotWidth: 12,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: height * 0.03),
      ],
    );
  }
}
