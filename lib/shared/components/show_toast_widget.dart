import 'package:flutter/material.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color toastColor;

  const CustomToast({
    Key? key,
    required this.message,
    required this.toastColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin:  const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: toastColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
