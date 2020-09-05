import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class LectureTypeTile extends StatefulWidget {
  final CreditManager lectureType;
  final Function onPressed;
  final double width;

  LectureTypeTile({this.lectureType, this.onPressed, this.width});

  _LectureTypeTileState createState() => _LectureTypeTileState();
}

class _LectureTypeTileState extends State<LectureTypeTile> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FlatButton(
        child: Text(
          '${str.translate(widget.lectureType.name)} ${str.credits} : ${widget.lectureType.credits}/${widget.lectureType.minCredits}',
          style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.05),
        ),
        onPressed: () {
          widget.onPressed();
        },
      ),
    );
  }
}
