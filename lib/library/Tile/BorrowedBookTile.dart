import 'dart:convert';

import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/library/model/Book.dart';
import 'package:ere_manager/library/model/Rental.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BorrowedBookTile extends StatefulWidget {
  int index;
  Rental rental;
  double width;
  double height;
  Function refresh;

  BorrowedBookTile({this.index, this.rental, this.width, this.height, this.refresh});

  _BorrowedBookTileState createState() => _BorrowedBookTileState();
}

class _BorrowedBookTileState extends State<BorrowedBookTile> {
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
          width: widget.width * 0.4,
          height: tile_height,
          child: Text(
            widget.rental.bookTitle,
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
          width: widget.width * 0.2,
          height: tile_height,
          child: EREButton(
            text: str.returnStr,
            onPressed: () async {
              EREToast(str.lang == '한국어' ? '반납 처리 중' : 'Processing to return the book', context, false);
              var book = Book.fromJson(jsonDecode((await reference.child('library').child('Book').child(widget.rental.bookID).once()).value));
              book.isAvailable = true;
              final activateBookTransaction = await reference.child('library').child('Book').child(book.id).runTransaction((mutableData) async {
                mutableData.value = jsonEncode(book.toJson());
                return mutableData;
              });
              await reference.child('library').child('Rental').child(widget.rental.id).remove();
              await reference.child('Student').child(widget.rental.borrowerID).child('Rental').child(widget.rental.id).remove();

              if (activateBookTransaction.committed) {
                widget.refresh();
              }
            },
            width: widget.width * (str.lang == '한국어' ? 1 : 0.9),
          ),
        )
      ],
    );
  }
}
