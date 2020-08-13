import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class EREButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double width;

  const EREButton({this.onPressed, this.text, this.width});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: ERE_YELLOW,
      color: ERE_BLACK,
      onPressed: onPressed,
      child: Text(text,
      style: TextStyle(fontSize: width * 0.037),),
    );
  }
}
