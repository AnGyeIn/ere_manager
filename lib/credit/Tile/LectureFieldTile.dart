import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class LectureFieldTile extends StatefulWidget {
  final CreditManager lectureField;
  final Function onPressed;
  final double width;

  LectureFieldTile({this.lectureField, this.onPressed, this.width});

  _LectureFieldTileState createState() => _LectureFieldTileState();
}

class _LectureFieldTileState extends State<LectureFieldTile> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FlatButton(
        child: Text(
          '  ${widget.lectureField.name} 학점 : ${widget.lectureField.credits}/${widget.lectureField.minCredits}',
          style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.05
              ),
        ),
        onPressed: () => widget.onPressed(),
      ),
    );
  }
}
