import 'package:flutter/material.dart';

class CustomMaterialButton extends StatelessWidget {
  final onPress;
  final Color buttonColor;
  final String buttonName;
  final double? buttonWidth;

  const CustomMaterialButton({
    Key? key,
    required this.onPress,
    required this.buttonColor,
    required this.buttonName,
    this.buttonWidth,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return MaterialButton(
      minWidth: buttonWidth ?? width*0.45,
      onPressed: onPress,
      color: buttonColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Text(
        buttonName,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}
