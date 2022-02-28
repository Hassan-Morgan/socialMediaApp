import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/app_layout/app_layout.dart';
import 'package:social_app/shared/components/custom_material_button.dart';
import 'package:social_app/shared/components/custom_text_form_field.dart';
import 'package:social_app/shared/components/show_toast_widget.dart';
import 'package:social_app/shared/cubit/app_cubit.dart';
import 'package:social_app/shared/cubit/app_states.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var userNameController = TextEditingController();
  var phoneController = TextEditingController();
  var bioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (context) => AppCubit()..getUserData(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is UpdateUserDataSuccessState ||
              state is GetUserDataErrorState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SocialAppLayout()),
                (route) => false);
            AppCubit.get(context).getUserData();
          }
          if (state is UpdateUserDataErrorState) {
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
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text('Edit profile'),
            ),
            body: ConditionalBuilder(
                condition: state is UpdateUserDataLoadingState ||
                    AppCubit.get(context).userModel == null,
                builder: (context) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                fallback: (context) {
                  userNameController.text = userNameController.text.isEmpty
                      ? AppCubit.get(context).userModel!.name
                      : userNameController.text;
                  phoneController.text = phoneController.text.isEmpty
                      ? AppCubit.get(context).userModel!.phone
                      : phoneController.text;
                  bioController.text = bioController.text.isEmpty
                      ? AppCubit.get(context).userModel!.bio
                      : bioController.text;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ConditionalBuilder(
                              condition:
                                  AppCubit.get(context).profileImage == null,
                              builder: (context) => Image.network(
                                AppCubit.get(context).userModel!.profileImage,
                                width: width,
                                height: height * 0.4,
                                fit: BoxFit.cover,
                              ),
                              fallback: (context) => Image.file(
                                File(AppCubit.get(context).profileImage!.path),
                                width: width,
                                height: height * 0.4,
                                fit: BoxFit.cover,
                              ),
                            ),
                            CustomMaterialButton(
                              buttonColor: Colors.blue,
                              buttonName: 'Change Image',
                              onPress: () {
                                scaffoldKey.currentState!
                                    .showBottomSheet((context) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          AppCubit.get(context).pickImageProfile(
                                              source: ImageSource.camera);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(width * 0.03),
                                          padding: EdgeInsets.all(width * 0.03),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text('open camera'),
                                              Icon(Icons.arrow_forward_ios),
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          AppCubit.get(context).pickImageProfile(
                                              source: ImageSource.gallery);
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(width * 0.03),
                                          padding: EdgeInsets.all(width * 0.03),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text('open gallery'),
                                              Icon(Icons.arrow_forward_ios),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                        Card(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Change User Name'),
                                SizedBox(height: height * 0.01),
                                CustomTextFormField(
                                  inputType: TextInputType.name,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'user name can\'t be empty';
                                    }
                                    return null;
                                  },
                                  controller: userNameController,
                                  hintText: 'user name',
                                  prefixIcon: const Icon(Icons.person),
                                  isSecure: false,
                                ),
                                SizedBox(height: height * 0.02),
                                const Text('Change phone number'),
                                SizedBox(height: height * 0.01),
                                CustomTextFormField(
                                  inputType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'phone number can\'t be empty';
                                    }
                                    return null;
                                  },
                                  controller: phoneController,
                                  hintText: 'phone number',
                                  prefixIcon: const Icon(Icons.phone_android),
                                  isSecure: false,
                                ),
                                SizedBox(height: height * 0.02),
                                const Text('Change bio'),
                                SizedBox(height: height * 0.01),
                                CustomTextFormField(
                                  inputType: TextInputType.text,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'bio can\'t be empty';
                                    }
                                    return null;
                                  },
                                  controller: bioController,
                                  hintText: 'user bio',
                                  prefixIcon: const Icon(Icons.format_bold),
                                  isSecure: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomMaterialButton(
                                onPress: () {
                                  Navigator.pop(context);
                                },
                                buttonColor: Colors.red,
                                buttonName: 'Cancel',
                                buttonWidth: width * 0.4,
                              ),
                              CustomMaterialButton(
                                onPress: () {
                                  if (AppCubit.get(context).profileImage ==
                                      null) {
                                    AppCubit.get(context).updateUserData(
                                        name: userNameController.text,
                                        phone: phoneController.text,
                                        bio: bioController.text,
                                        profileImage: AppCubit.get(context)
                                            .userModel!
                                            .profileImage);
                                  } else {
                                    AppCubit.get(context).uploadProfileImage(
                                      name: userNameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  }
                                },
                                buttonColor: Colors.blue,
                                buttonName: 'Update',
                                buttonWidth: width * 0.4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
