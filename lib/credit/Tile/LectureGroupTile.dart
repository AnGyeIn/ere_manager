import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class LectureGroupTile extends StatefulWidget {
  final CreditManager lectureGroup;
  final Function onPressed;
  final double width;

  LectureGroupTile({this.lectureGroup, this.onPressed, this.width});

  _LectureGroupTileState createState() => _LectureGroupTileState();
}

class _LectureGroupTileState extends State<LectureGroupTile> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FlatButton(
        child: Text(
          '    ${str.translate(widget.lectureGroup.name)} ${str.credits} : ${widget.lectureGroup.credits}/${widget.lectureGroup.minCredits}',
          style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.041),
        ),
        onPressed: () => widget.onPressed(),
      ),
    );
  }
}
