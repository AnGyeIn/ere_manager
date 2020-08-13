import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class LectureTile extends StatefulWidget {
  final CreditManager lecture;
  final double width;

  LectureTile({this.lecture, this.width});

  _LectureTileState createState() => _LectureTileState();
}

class _LectureTileState extends State<LectureTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '          ${widget.lecture.name}(${widget.lecture.credit}학점)',
          style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.04),
        ),
        Checkbox(
          value: widget.lecture.credits != 0,
          onChanged: (value) {
            setState(() {
              widget.lecture.credits =
                  widget.lecture.credit - widget.lecture.credits;
            });
          },
          checkColor: ERE_YELLOW,
          activeColor: ERE_BLACK,
        )
      ],
    );
  }
}
