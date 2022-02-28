import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Icon prefixIcon;
  final String hintText;
  final Widget? suffix;
  final bool? isSecure;
  final validator;
  final TextEditingController controller;
  final TextInputType inputType;

  const CustomTextFormField({
    Key? key,
    required this.prefixIcon,
    required this.hintText,
    this.suffix,
    this.isSecure,
    required this.validator,
    required this.controller,
    required this.inputType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: suffix,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        isDense: true,
      ),
      obscureText: isSecure ?? false,
      validator: validator,
      controller: controller,
      keyboardType: inputType,
    );
  }
}
