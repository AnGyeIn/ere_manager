import 'dart:convert';

import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/lecturebook/model/LectureBook.dart';
import 'package:ere_manager/lecturebook/model/LectureBookRequest.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LectureBookRequestTileForReceiver extends StatefulWidget {
  int index;
  LectureBookRequest lectureBookRequest;
  double width;
  double height;
  Function refresh;

  LectureBookRequestTileForReceiver(
      {this.index,
      this.lectureBookRequest,
      this.width,
      this.height,
      this.refresh});

  _LectureBookRequestTileForReceiverState createState() =>
      _LectureBookRequestTileForReceiverState();
}

class _LectureBookRequestTileForReceiverState
    extends State<LectureBookRequestTileForReceiver> {
  final reference = FirebaseDatabase.instance.reference();

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
            '${widget.lectureBookRequest.ownerName}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
            textAlign: TextAlign.center,
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
                alignment: Alignment.center,
                width: widget.width * 0.24,
                height: tile_height,
                child: EREButton(
                  text: '승인 완료',
                  onPressed: () async {
                    final lectureBookStr = (await reference
                            .child('lecturebook')
                            .child('LectureBook')
                            .child(widget.lectureBookRequest.lecturebookID)
                            .once())
                        .value;
                    final lectureBook =
                        LectureBook.fromJson(jsonDecode(lectureBookStr));
                    final pNum = (await reference
                            .child('Student')
                            .child(lectureBook.ownerID)
                            .child('pNum')
                            .once())
                        .value;

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '제공자 : ${widget.lectureBookRequest.ownerName}\n'
                                      '연락처 : $pNum')
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text('문자 보내기'),
                                  onPressed: () async {
                                    final url = 'sms:$pNum';
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else
                                      throw 'Could not launch $url';
                                  },
                                ),
                                FlatButton(
                                  child: Text('닫기'),
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
            : !widget.lectureBookRequest.isRejected ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(tile_padding),
                width: widget.width * 0.2,
                height: tile_height,
                child: EREButton(
                  text: '취소',
                  onPressed: () {
                    reference
                        .child('lecturebook')
                        .child('LectureBookRequest')
                        .child(widget.lectureBookRequest.id)
                        .remove()
                        .whenComplete(() {
                      widget.refresh();
                    });
                  },
                  width: widget.width,
                ),
              ) : Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.24,
          height: tile_height,
          child: EREButton(
            text: '반려 대기',
            onPressed: () {
              showDialog(context: context,
              builder: (context) => AlertDialog(
                content: Text('동일 교재에 대해 다른 신청자가 승인되어 반려된 신청입니다. 확인을 누르면 목록에서 삭제됩니다.'),
                actions: [
                  FlatButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.pop(context);
                      reference.child('lecturebook').child('LectureBookRequest').child(widget.lectureBookRequest.id).remove();
                    },
                  )
                ],
              )
              );
            },
            width: widget.width,
          ),
        )
      ],
    );
  }
}
