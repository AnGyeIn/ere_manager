import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/credit/MainAdapter.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class AddedLectureTile extends StatefulWidget {
  final CreditManager addedLecture;
  final Function delFunc;
  final MainAdapter adapter;
  final double width;
  final double height;

  AddedLectureTile(
      {this.addedLecture, this.adapter, this.delFunc, this.width, this.height});

  _AddedLectureTileState createState() => _AddedLectureTileState();
}

class _AddedLectureTileState extends State<AddedLectureTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.05,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '          ${str.translate(widget.addedLecture.name)}(${widget.addedLecture.credit}${str.lang == '한국어' ? '학점' : ''})',
              style:
                  TextStyle(color: ERE_YELLOW, fontSize: widget.width * 0.04),
            ),
          ),
          Checkbox(
            value: widget.addedLecture.credits != 0,
            onChanged: (value) {
              setState(() {
                widget.addedLecture.credits =
                    widget.addedLecture.credit - widget.addedLecture.credits;
              });
            },
            checkColor: ERE_YELLOW,
            activeColor: ERE_BLACK,
          ),
          AnimatedOpacity(
            opacity: widget.adapter.isEditable ? 1 : 0,
            duration: Duration.zero,
            child: Container(
              width: widget.width * (str.lang == '한국어' ? 0.16 : 0.21),
              child: EREButton(
                text: str.delete,
                onPressed: widget.adapter.isEditable
                    ? () {
                        widget.addedLecture.removeThis();
                        EREToast(str.deleteAddedLectureSuccess, context, false);
                        widget.delFunc();
                      }
                    : null,
                width: widget.width,
              ),
            ),
          )
        ],
      ),
    );
  }
}
