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
  List<LectureBookRequest> requestListForOwner;
  double width;
  double height;
  Function refresh;

  LectureBookRequestTileForOwner(
      {this.index,
      this.lectureBookRequest,
      this.requestListForOwner,
      this.width,
      this.height,
      this.refresh});

  _LectureBookRequestTileForOwnerState createState() =>
      _LectureBookRequestTileForOwnerState();
}

class _LectureBookRequestTileForOwnerState
    extends State<LectureBookRequestTileForOwner> {
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
            '${widget.lectureBookRequest.receiverName}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: widget.width * 0.11,
          height: tile_height,
          child: Text(
            '${str.translate(widget.lectureBookRequest.option)}',
            style: TextStyle(
                color: ERE_YELLOW,
                fontSize: fontsize * (str.lang == '한국어' ? 1 : 0.7)),
          ),
        ),
        widget.lectureBookRequest.isAccepted
            ? Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(tile_padding),
                width: widget.width * 0.2,
                height: tile_height,
                child: Text(
                  str.accepted,
                  style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                ),
              )
            : !widget.lectureBookRequest.isRejected
                ? Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.all(tile_padding),
                    width: widget.width * 0.2,
                    height: tile_height,
                    child: EREButton(
                      text: str.accept,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(str.lectureBookRequestAcceptDetail)
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text(str.accept),
                                      onPressed: () async {
                                        Navigator.pop(context);

                                        final deactiveTransaction =
                                            await reference
                                                .child('lecturebook')
                                                .child('LectureBook')
                                                .child(widget.lectureBookRequest
                                                    .lecturebookID)
                                                .runTransaction(
                                                    (mutableData) async {
                                          final lectureBook =
                                              LectureBook.fromJson(jsonDecode(
                                                  mutableData.value));
                                          lectureBook.isAvailable = false;
                                          mutableData.value =
                                              jsonEncode(lectureBook.toJson());
                                          return mutableData;
                                        });

                                        if (deactiveTransaction.committed) {
                                          final List<LectureBookRequest>
                                              equivList = [];

                                          for (var request
                                              in widget.requestListForOwner) {
                                            if (request.id ==
                                                widget.lectureBookRequest.id) {
                                              request.isAccepted = true;
                                              equivList.add(request);
                                            } else if (request.lecturebookID ==
                                                widget.lectureBookRequest
                                                    .lecturebookID) {
                                              request.isRejected = true;
                                              equivList.add(request);
                                            }
                                          }

                                          try {
                                            for (var request in equivList) {
                                              await reference
                                                  .child('Student')
                                                  .child(request.ownerID)
                                                  .child('LectureBookRequest')
                                                  .child(request.id)
                                                  .set(jsonEncode(
                                                      request.toJson()));

                                              await reference
                                                  .child('Student')
                                                  .child(request.receiverID)
                                                  .child('LectureBookRequest')
                                                  .child(request.id)
                                                  .set(jsonEncode(
                                                      request.toJson()));
                                            }
                                            EREToast(str.acceptSuccess, context,
                                                false);
                                          } catch (e) {
                                            print(e);
                                          }
                                        }
                                      },
                                    ),
                                    FlatButton(
                                      child: Text(str.cancel),
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
                : Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(tile_padding),
                    width: widget.width * 0.2,
                    height: tile_height,
                    child: Text(
                      str.rejected,
                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                    ),
                  )
      ],
    );
  }
}
