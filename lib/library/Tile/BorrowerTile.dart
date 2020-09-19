import 'package:ere_manager/library/model/Rental.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BorrowerTile extends StatefulWidget {
  int index;
  Rental rental;
  double width;
  double height;
  Function refresh;

  BorrowerTile(
      {this.index, this.rental, this.width, this.height, this.refresh});

  _BorrowerTileState createState() => _BorrowerTileState();
}

class _BorrowerTileState extends State<BorrowerTile> {
  final reference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    double tile_padding = widget.width * 0.0075;
    double tile_height = widget.height * 0.05;
    double fontsize = widget.width * 0.037;

    DateTime now = DateTime.now();
    bool isOverdue = widget.rental.dueDate.compareTo(now) < 0;

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.1,
          height: tile_height,
          child: Text(
            '${widget.index}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.3,
          height: tile_height,
          child: Text(
            widget.rental.bookTitle,
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.2,
          height: tile_height,
          child: Text(
            widget.rental.borrowerName,
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(tile_padding),
          width: widget.width * 0.3,
          height: tile_height,
          child: Text(
            str.lang == '한국어'
                ? '${widget.rental.dueDate.year}/${widget.rental.dueDate.month}/${widget.rental.dueDate.day}'
                : '${widget.rental.dueDate.day}.${widget.rental.dueDate.month}.${widget.rental.dueDate.year}',
            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: widget.width * 0.1,
          height: tile_height,
          child: IconButton(
            icon: Icon(
              Icons.error_outline,
              color: isOverdue ? ERE_YELLOW : ERE_BLACK,
            ),
            onPressed: isOverdue
                ? () async {
                    final pNum = (await reference
                            .child('Student')
                            .child(widget.rental.borrowerID)
                            .child('pNum')
                            .once())
                        .value;

                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Text(
                                  '${str.borrower} : ${widget.rental.borrowerName}\n'
                                          '${str.phoneNumber} : $pNum\n\n' +
                                      (str.lang == '한국어'
                                          ? '반납기한이 되면 기본적으로 대출자에게 푸시알림이 전달됩니다. 반납기한을 지나치게 초과한 경우 관리자 재량으로 문자로 안내를 보낼 수 있습니다.'
                                          : 'Basically, the borrowers are notified by push notification at the due date. The administrator can send a message to the borrower whose rental is too overdue by discretion.')),
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
                                  child: Text(str.cancel),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                  }
                : null,
          ),
        )
      ],
    );
  }
}
