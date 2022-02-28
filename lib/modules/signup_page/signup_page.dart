import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:social_app/app_layout/app_layout.dart';
import 'package:social_app/modules/edit_profile/edit_profile.dart';
import 'package:social_app/modules/login_page/login_page.dart';
import 'package:social_app/modules/signup_page/signup_cubit/signup_cubit.dart';
import 'package:social_app/modules/signup_page/signup_cubit/states.dart';
import 'package:social_app/shared/components/custom_material_button.dart';
import 'package:social_app/shared/components/custom_text_form_field.dart';
import 'package:social_app/shared/components/show_toast_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  bool isSecure = true;
  String passwordSuffix = 'view';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocConsumer<SignUpCubit, SignUpStates>(
      listener: (context, state) {
        if (state is SignUpErrorState) {
          showToastWidget(
            CustomToast(
              toastColor: Colors.red,
              message: state.error,
            ),
            context: context,
            isHideKeyboard: true,
          );
        }
        if (state is SignUpSuccessState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) =>  EditProfile()),
              (route) => false);
        }
      },
      builder: (context, state) => Scaffold(
        backgroundColor: Colors.blue,
        appBar: AppBar(
          backgroundColor: Colors.blue,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.blue,
            statusBarIconBrightness: Brightness.light,
          ),
          elevation: 0.0,
        ),
        body: Center(
          heightFactor: 1.2,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    state is SignUpLoadingState
                        ? const LinearProgressIndicator(
                            color: Colors.red,
                            backgroundColor: Colors.white,
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    const Text(
                      'signup to connect your friends',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomTextFormField(
                      inputType: TextInputType.name,
                      prefixIcon: const Icon(Icons.person),
                      hintText: 'enter your full name',
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'name cann\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomTextFormField(
                      inputType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email),
                      hintText: 'enter your email',
                      controller: emailController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'email cann\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomTextFormField(
                      inputType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'enter your password',
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'password cann\'t be empty';
                        }
                        return null;
                      },
                      controller: passwordController,
                      isSecure: isSecure,
                      suffix: Container(
                        margin: EdgeInsetsDirectional.only(end: width * 0.02),
                        child: TextButton(
                          onPressed: () {
                            if (isSecure == true) {
                              setState(() {
                                isSecure = false;
                                passwordSuffix = 'hide';
                              });
                            } else {
                              setState(() {
                                isSecure = true;
                                passwordSuffix = 'view';
                              });
                            }
                          },
                          child: Text(passwordSuffix),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    CustomTextFormField(
                      inputType: TextInputType.number,
                      prefixIcon: const Icon(Icons.phone_android),
                      hintText: 'enter your phone number',
                      controller: phoneController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'phone number cann\'t be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomMaterialButton(
                      onPress:() {
                        if (formKey.currentState!.validate()) {
                          SignUpCubit.get(context).signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              phone: phoneController.text);
                        }
                      },
                      buttonColor: Colors.red,
                      buttonName: state is SignUpLoadingState ? 'loading...' : 'SignUp',
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'already have account ? ',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LogIn()),
                                (route) => false);
                          },
                          child: const Text(
                            'login Now',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
