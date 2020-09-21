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

  LectureBookRequestTileForReceiver({this.index, this.lectureBookRequest, this.width, this.height, this.refresh});

  _LectureBookRequestTileForReceiverState createState() => _LectureBookRequestTileForReceiverState();
}

class _LectureBookRequestTileForReceiverState extends State<LectureBookRequestTileForReceiver> {
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
          width: widget.width * 0.11,
          height: tile_height,
          child: Text(
            '${str.translate(widget.lectureBookRequest.option)}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize * (str.lang == '한국어' ? 1 : 0.7)),
          ),
        ),
        widget.lectureBookRequest.isAccepted
            ? Container(
                alignment: Alignment.center,
                width: widget.width * 0.24,
                height: tile_height,
                child: EREButton(
                  text: str.accepted,
                  onPressed: () async {
                    final pNum = (await reference.child('Student').child(widget.lectureBookRequest.ownerID).child('pNum').once()).value;

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${str.owner} : ${widget.lectureBookRequest.ownerName}\n'
                                      '${str.phoneNumber} : $pNum')
                                ],
                              ),
                              actions: [
                                FlatButton(
                                  child: Text(str.message),
                                  onPressed: () async {
                                    final url = 'sms:$pNum';
                                    if (await canLaunch(url))
                                      await launch(url);
                                    else
                                      throw 'Could not launch $url';
                                  },
                                ),
                                FlatButton(
                                  child: Text(str.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                  },
                  width: widget.width * (str.lang == '한국어' ? 1 : 0.9),
                ),
              )
            : !widget.lectureBookRequest.isRejected
                ? Container(
                    alignment: Alignment.center,
                    width: widget.width * 0.21,
                    height: tile_height,
                    child: EREButton(
                      text: str.cancel,
                      onPressed: () {
                        reference.child('Student')
                          ..child(widget.lectureBookRequest.receiverID).child('LectureBookRequest').child(widget.lectureBookRequest.id).remove()
                          ..child(widget.lectureBookRequest.ownerID).child('LectureBookRequest').child(widget.lectureBookRequest.id).remove();
                      },
                      width: widget.width,
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    width: widget.width * 0.24,
                    height: tile_height,
                    child: EREButton(
                      text: str.rejected2,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text(str.rejectedDetail),
                                  actions: [
                                    FlatButton(
                                      child: Text(str.ok),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        reference.child('Student')
                                          ..child(widget.lectureBookRequest.receiverID).child('LectureBookRequest').child(widget.lectureBookRequest.id).remove()
                                          ..child(widget.lectureBookRequest.ownerID).child('LectureBookRequest').child(widget.lectureBookRequest.id).remove();
                                      },
                                    )
                                  ],
                                ));
                      },
                      width: widget.width * (str.lang == '한국어' ? 1 : 0.9),
                    ),
                  )
      ],
    );
  }
}
