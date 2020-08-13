import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/credit/Data.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

import '../MainAdapter.dart';

class FreeLectureTile extends StatefulWidget {
  final CreditManager freeLecture;
  final Function addFunc;
  final Function onPressed;
  final MainAdapter adapter;
  final double width;

  FreeLectureTile(
      {this.freeLecture,
      this.adapter,
      this.addFunc,
      this.onPressed,
      this.width});

  _FreeLectureTileState createState() => _FreeLectureTileState();
}

class _FreeLectureTileState extends State<FreeLectureTile> {
  String addLecName;
  int addLecCredit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: widget.width * 0.11,
        ),
        Container(
          width: widget.width * 0.3,
          child: TextField(
            cursorColor: ERE_YELLOW,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '과목명 입력',
                hintStyle: TextStyle(color: Color(0x88e4b92a))),
            style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.04),
            onChanged: (text) => addLecName = text,
          ),
        ),
        Container(
          width: widget.width * 0.2,
          child: TextField(
            cursorColor: ERE_YELLOW,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '학점 입력',
                hintStyle: TextStyle(color: Color(0x88e4b92a))),
            style: TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.04),
            onChanged: (text) => addLecCredit = int.parse(text),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.width * 0.0075),
          child: Container(
            width: widget.width * 0.16,
            child: EREButton(
              text: '추가',
              onPressed: () {
                if (addLecCredit != null) {
                  final addLecture = CreditManager(ADDED_LECTURE, addLecName,
                      null, addLecCredit, widget.freeLecture.upperManager);
                  widget.freeLecture.upperManager
                      .insertUnderManager(widget.freeLecture.num, addLecture);
                  widget.freeLecture.incNum();
                  EREToast('과목이 추가되었습니다.', context, false);
                  widget.addFunc(addLecture);
                } else
                  EREToast('학점을 반드시 입력해주세요.', context, false);
              },
              width: widget.width,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(widget.width * 0.0075),
          child: Container(
            width: widget.width * 0.16,
            child: EREButton(
              text: widget.adapter.isEditable ? '확인' : '편집',
              onPressed: () {
                widget.adapter.isEditable = !widget.adapter.isEditable;
                widget.onPressed();
              },
              width: widget.width,
            ),
          ),
        )
      ],
    );
  }
}
