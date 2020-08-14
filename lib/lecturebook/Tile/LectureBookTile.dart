import 'dart:convert';

import 'package:ere_manager/lecturebook/model/LectureBook.dart';
import 'package:ere_manager/lecturebook/model/LectureBookRequest.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LectureBookTile extends StatefulWidget {
  LectureBook lectureBook;
  double width;
  double height;
  int index;
  String userID;
  String userName;
  List<LectureBookRequest> requestListForReceiver;
  Function refresh;

  LectureBookTile(
      {this.lectureBook,
      this.width,
      this.height,
      this.index,
      this.userID,
      this.userName,
      this.requestListForReceiver,
      this.refresh});

  _LectureBookTileState createState() => _LectureBookTileState();
}

class _LectureBookTileState extends State<LectureBookTile> {
  final reference = FirebaseDatabase.instance.reference().child('lecturebook');

  @override
  Widget build(BuildContext context) {
    double tile_padding = widget.width * 0.0075;
    double tile_height = widget.height * 0.06;
    double fontsize = widget.width * 0.034;
    final isOwner = widget.userID == widget.lectureBook.ownerID;
    Color stateColor = widget.lectureBook.isAvailable ? ERE_GREY : ERE_BLACK;

    return RaisedButton(
      padding: EdgeInsets.zero,
      textColor: ERE_YELLOW,
      color: isOwner ? stateColor : ERE_GREY,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.084,
            height: tile_height,
            child: Text(
              '${widget.index}',
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.285,
            height: tile_height,
            child: Text(
              '${widget.lectureBook.title}',
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.185,
            height: tile_height,
            child: Text(
              '${widget.lectureBook.author}',
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.185,
            height: tile_height,
            child: Text(
              '${widget.lectureBook.lecture}',
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.15,
            height: tile_height,
            child: Text(
              '${widget.lectureBook.ownerName}',
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.11,
            height: tile_height,
            child: Text(
              '${widget.lectureBook.option}',
              style: TextStyle(fontSize: fontsize),
            ),
          )
        ],
      ),
      onPressed: isOwner
          ? () async {
              widget.lectureBook.isAvailable = !widget.lectureBook.isAvailable;
              final activeTransaction = await reference
                  .child('LectureBook')
                  .child('${widget.lectureBook.id}')
                  .runTransaction((mutableData) async {
                mutableData.value = jsonEncode(widget.lectureBook.toJson());
                return mutableData;
              });

              if (activeTransaction.committed) widget.refresh();
            }
          : widget.lectureBook.isAvailable
              ? () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('교재명 : ${widget.lectureBook.title}'),
                                Padding(
                                  padding: EdgeInsets.all(tile_padding),
                                ),
                                Text('저자 : ${widget.lectureBook.author}'),
                                Padding(
                                  padding: EdgeInsets.all(tile_padding),
                                ),
                                Text('과목 : ${widget.lectureBook.lecture}'),
                                Padding(
                                  padding: EdgeInsets.all(tile_padding),
                                ),
                                Text(
                                    '빌려주는 사람 : ${widget.lectureBook.ownerName}'),
                                Padding(
                                  padding: EdgeInsets.all(tile_padding),
                                ),
                                Text('방식 : ${widget.lectureBook.option}'),
                                Padding(
                                  padding: EdgeInsets.all(tile_padding),
                                )
                              ],
                            ),
                            actions: [
                              FlatButton(
                                child: Text('신청'),
                                onPressed: () async {
                                  Navigator.pop(context);

                                  for (var request
                                      in widget.requestListForReceiver)
                                    if (request.lecturebookID ==
                                        widget.lectureBook.id) {
                                      EREToast('이미 신청한 교재입니다.', context, false);
                                      return;
                                    }

                                  final openTime = DateTime.parse(
                                      (await reference.child('openTime').once())
                                          .value);
                                  final now = DateTime.now();
                                  if (widget.lectureBook.ownerName == '학생회' &&
                                      now.compareTo(openTime) < 0) {
                                    EREToast(
                                        '학생회 소유 교재는 개시 시각 이후에 신청해주세요.\n'
                                        '개시 시각: ${openTime.year}년 ${openTime.month}월 ${openTime.day}일 ${openTime.hour}시 ${openTime.minute}분',
                                        context,
                                        true);
                                    return;
                                  }

                                  final id = reference
                                      .child('LectureBookRequest')
                                      .push()
                                      .key;

                                  final addTransaction = await reference
                                      .child('LectureBookRequest')
                                      .child(id)
                                      .runTransaction((mutableData) async {
                                    mutableData.value = jsonEncode({
                                      'requestTime': now.toString(),
                                      'id': id,
                                      'lecturebookID': widget.lectureBook.id,
                                      'lecturebookTitle':
                                          widget.lectureBook.title,
                                      'ownerID': widget.lectureBook.ownerID,
                                      'ownerName': widget.lectureBook.ownerName,
                                      'receiverID': widget.userID,
                                      'receiverName': widget.userName,
                                      'option': widget.lectureBook.option,
                                      'isAccepted': false,
                                      'isRejected': false
                                    });
                                    return mutableData;
                                  });
                                  if (addTransaction.committed) {
                                    EREToast(
                                        '${widget.lectureBook.option} 신청이 접수되었습니다.',
                                        context,
                                        false);
                                    widget.refresh();
                                  } else
                                    EREToast(
                                        '신청이 비활성화된 교재입니다.', context, false);
                                },
                              ),
                              FlatButton(
                                child: Text('닫기'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ));
                }
              : null,
    );
  }
}
