import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class LectureWorldTile extends StatefulWidget {
  final CreditManager lectureWorld;
  final Function onPressed;
  final double width;

  LectureWorldTile({this.lectureWorld, this.onPressed, this.width});

  _LectureWorldTileState createState() => _LectureWorldTileState();
}

class _LectureWorldTileState extends State<LectureWorldTile> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FlatButton(
        child: Text(
          '    ${str.translate(widget.lectureWorld.name)}',
          style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.044),
        ),
        onPressed: () => widget.onPressed(),
      ),
    );
  }
}
