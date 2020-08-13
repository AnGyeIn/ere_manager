import 'dart:convert';

import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/lecturebook/model/LectureBook.dart';
import 'package:ere_manager/lecturebook/model/LectureBookRequest.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LectureBookRequestTileForOwner extends StatefulWidget {
  int index;
  LectureBookRequest lectureBookRequest;
  double width;
  double height;
  Function refresh;

  LectureBookRequestTileForOwner(
      {this.index,
      this.lectureBookRequest,
      this.width,
      this.height,
      this.refresh});

  _LectureBookRequestTileForOwnerState createState() =>
      _LectureBookRequestTileForOwnerState();
}

class _LectureBookRequestTileForOwnerState
    extends State<LectureBookRequestTileForOwner> {
  final reference = FirebaseDatabase.instance.reference().child('lecturebook');

  @override
  Widget build(BuildContext context) {
    double tile_padding = widget.width * 0.0075;
    double tile_height = widget.height * 0.05;
    double fontsize = widget.width * 0.037;

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.15,
          height: tile_height,
          child: Text(
            '${widget.index}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.35,
          height: tile_height,
          child: Text(
            '${widget.lectureBookRequest.lecturebookTitle}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.15,
          height: tile_height,
          child: Text(
            '${widget.lectureBookRequest.receiverName}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.11,
          height: tile_height,
          child: Text(
            '${widget.lectureBookRequest.option}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        widget.lectureBookRequest.isAccepted
            ? Container(
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(tile_padding),
                  width: widget.width * 0.2,
                  height: tile_height,
                  child: Text(
                    '승인 완료',
                    style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                  ),
                ),
              )
            : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(tile_padding),
                width: widget.width * 0.2,
                height: tile_height,
                child: EREButton(
                  text: '승인',
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('승인하면 신청자에게 연락처가 전달됩니다. 계속하시겠습니까?')
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text('승인'),
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    final deactiveTransaction = await reference
                                        .child('LectureBook')
                                        .child(widget
                                            .lectureBookRequest.lecturebookID)
                                        .runTransaction((mutableData) async {
                                      final lectureBook = LectureBook.fromJson(
                                          jsonDecode(mutableData.value));
                                      lectureBook.isAvailable = false;
                                      mutableData.value =
                                          jsonEncode(lectureBook.toJson());
                                      return mutableData;
                                    });

                                    if (deactiveTransaction.committed) {
                                      widget.lectureBookRequest.isAccepted =
                                          true;
                                      final acceptTransaction = await reference
                                          .child('LectureBookRequest')
                                          .child(widget.lectureBookRequest.id)
                                          .runTransaction((mutableData) async {
                                        mutableData.value = jsonEncode(
                                            widget.lectureBookRequest.toJson());
                                        return mutableData;
                                      });

                                      if (acceptTransaction.committed) {
                                        EREToast('승인되었습니다.', context, false);
                                        widget.refresh();
                                      } else
                                        EREToast(
                                            '신청자가 취소한 신청입니다.', context, false);
                                    }
                                  },
                                ),
                                FlatButton(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                  },
                  width: widget.width,
                ),
              )
      ],
    );
  }
}
