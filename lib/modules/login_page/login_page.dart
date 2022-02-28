import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:social_app/app_layout/app_layout.dart';
import 'package:social_app/modules/login_page/login_cubit/login_cubit.dart';
import 'package:social_app/modules/signup_page/signup_page.dart';
import 'package:social_app/shared/components/custom_material_button.dart';
import 'package:social_app/shared/components/custom_text_form_field.dart';
import 'package:social_app/shared/components/show_toast_widget.dart';

import 'login_cubit/login_states.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  var formKey = GlobalKey<FormState>();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  bool isSecure = true;

  String passwordSuffix = 'view';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return BlocConsumer<LogInCubit, LogInStates>(
      listener: (context, state) {
        if (state is LogInErrorState) {
          showToastWidget(
            CustomToast(message: state.error, toastColor: Colors.red),
            context: context,
            isHideKeyboard: true,
          );
        }
        if (state is LogInSuccessState) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SocialAppLayout()),
                  (route) => false);
        }
      },
      builder: (context, state) =>
          Scaffold(
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
              heightFactor: 1.5,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state is LogInLoadingState
                            ? const LinearProgressIndicator(
                          color: Colors.red,
                          backgroundColor: Colors.white,
                        )
                            : const SizedBox(),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        const Text(
                          'Sign In',
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
                          'login to connect your friends',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
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
                            margin: EdgeInsetsDirectional.only(end: width *
                                0.02),
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
                        CustomMaterialButton(
                          onPress:() {
                            if (formKey.currentState!.validate()) {
                              LogInCubit.get(context).logIn(
                                  email: emailController.text,
                                  password: passwordController.text);
                            }
                          },
                          buttonColor: Colors.red,
                          buttonName: state is LogInLoadingState
                              ? 'loading...'
                              : 'logIn',
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'don\'t have account ? ',
                              style: TextStyle(color: Colors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()),
                                        (route) => false);
                              },
                              child: const Text(
                                'SignUp Now',
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
