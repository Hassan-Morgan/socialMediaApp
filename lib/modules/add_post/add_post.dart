import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/components/custom_material_button.dart';
import 'package:social_app/shared/components/show_toast_widget.dart';
import 'package:social_app/shared/constants.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';
import 'package:social_app/shared/cubit/app_states.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  var postTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AddPostSuccessState) {
          Navigator.pop(context);
        }
        if (state is AddPostErrorState) {
          showToastWidget(
            const CustomToast(
                message: 'error happened please check your internet',
                toastColor: Colors.red),
            context: context,
          );
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: const Text('add post'),
            ),
            body: ConditionalBuilder(
              condition: state is AddPostLoadingState,
              builder: (context) =>
              const Center(
                child: CircularProgressIndicator(),
              ),
              fallback: (context) =>
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.all(width * 0.02),
                          child: Padding(
                            padding: EdgeInsetsDirectional.all(width * 0.03),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: width * 0.06,
                                      backgroundImage: NetworkImage(
                                        AppCubit
                                            .get(context)
                                            .userModel!
                                            .profileImage,
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Expanded(
                                      child: Text(
                                          AppCubit
                                              .get(context)
                                              .userModel!
                                              .name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'whats in your mind ? ',
                                  ),
                                  maxLines: 3,
                                  controller: postTextController,
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                if (AppCubit
                                    .get(context)
                                    .postImages
                                    .isNotEmpty)
                                  for (var element
                                  in AppCubit
                                      .get(context)
                                      .postImages)
                                    postImagesView(
                                        image: element, context: context),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                          onPressed: () {
                                            AppCubit.get(context)
                                                .pickPostImages();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.image),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              const Text('Add Image')
                                            ],
                                          )),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.tag),
                                              SizedBox(
                                                width: width * 0.01,
                                              ),
                                              const Text('Add Tags')
                                            ],
                                          )),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomMaterialButton(
                            onPress: () {
                              if (AppCubit
                                  .get(context)
                                  .postImages
                                  .isEmpty) {
                                if (postTextController.text == '') {
                                  showToastWidget(
                                    const CustomToast(
                                        message: 'add data first to post',
                                        toastColor: Colors.red),
                                    context: context,
                                  );
                                } else {
                                  AppCubit.get(context).addPost(
                                      date: DateFormat.yMEd()
                                          .add_Hm()
                                          .format(DateTime.now()),
                                      postText: postTextController.text);
                                }
                              } else {
                                AppCubit.get(context).uploadPostImages().then((
                                    value) {
                                  AppCubit.get(context).addPost(
                                      date: DateFormat.yMEd().add_Hm().format(
                                          DateTime.now()), postText:postTextController.text );
                                });
                              }
                            },
                            buttonColor: Colors.blue,
                            buttonName: 'Post'),
                      ],
                    ),
                  ),
            ));
      },
    );
  }

  Widget postImagesView({
    required XFile image,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Image.file(
            File(image.path),
            width: double.infinity,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.black.withOpacity(0.7),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    AppCubit
                        .get(context)
                        .postImages
                        .remove(image);
                  });
                },
                icon: const Icon(Icons.highlight_remove),
                color: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
