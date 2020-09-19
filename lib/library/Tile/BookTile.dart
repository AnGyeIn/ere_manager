import 'dart:convert';

import 'package:ere_manager/library/model/Book.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BookTile extends StatefulWidget {
  Book book;
  double width;
  double height;
  int index;
  String userID;
  String userName;
  Function refresh;
  bool isAdmin;

  BookTile(
      {this.book,
      this.width,
      this.height,
      this.index,
      this.userID,
      this.userName,
      this.refresh,
      this.isAdmin});

  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  final reference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    double tile_padding = widget.width * 0.0075;
    double tile_height = widget.height * 0.06;
    double fontsize = widget.width * 0.034;
    Color stateColor = widget.book.isAvailable ? ERE_GREY : ERE_BLACK;

    return RaisedButton(
      padding: EdgeInsets.zero,
      textColor: ERE_YELLOW,
      color: widget.isAdmin ? stateColor : ERE_GREY,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.1,
            height: tile_height,
            child: Text(
              '${widget.index}',
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.6,
            height: tile_height,
            child: Text(
              widget.book.title,
              style: TextStyle(fontSize: fontsize),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(tile_padding),
            width: widget.width * 0.3,
            height: tile_height,
            child: Text(
              widget.book.author,
              style: TextStyle(fontSize: fontsize),
            ),
          )
        ],
      ),
      onPressed: !widget.isAdmin && !widget.book.isAvailable
          ? null
          : () {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${str.bookTitle} : ${widget.book.title}'),
                            Padding(padding: EdgeInsets.all(tile_padding)),
                            Text('${str.author} : ${widget.book.author}'),
                            Padding(padding: EdgeInsets.all(tile_padding)),
                            Text(str.lang == '한국어'
                                ? '[대출] 버튼을 누르고 도서의 바코드를 스캔해주세요.'
                                : 'Press [Borrow] and scan the barcode of the book.')
                          ],
                        ),
                        actions: [
                          widget.isAdmin
                              ? FlatButton(
                                  child: Text(
                                    str.removeBook,
                                    style: TextStyle(color: Color(0xffff2424)),
                                  ),
                                  onPressed: () {
                                    if (widget.book.isAvailable) {
                                      Navigator.pop(context);
                                      reference
                                          .child('library')
                                          .child('Book')
                                          .child(widget.book.id)
                                          .remove()
                                          .whenComplete(() {
                                        widget.refresh();
                                      });
                                    } else
                                      EREToast(
                                          str.lang == '한국어'
                                              ? '도서가 반납된 상태일 때만 삭제할 수 있습니다.'
                                              : 'You can remove a book only when the book is returned.',
                                          context,
                                          true);
                                  },
                                )
                              : Container(),
                          FlatButton(
                            child: Text(str.borrow),
                            onPressed: () async {
                              final readIsbn =
                                  await FlutterBarcodeScanner.scanBarcode(
                                      '#ffe4b92a',
                                      str.cancel,
                                      true,
                                      ScanMode.BARCODE);
                              if (readIsbn == widget.book.isbn) {
                                Navigator.pop(context);
                                widget.book.isAvailable = false;
                                final borrowTransaction = await reference
                                    .child('library')
                                    .child('Book')
                                    .child(widget.book.id)
                                    .runTransaction((mutableData) async {
                                  mutableData.value =
                                      jsonEncode(widget.book.toJson());
                                  return mutableData;
                                });
                                final id = reference
                                    .child('library')
                                    .child('Rental')
                                    .push()
                                    .key;
                                DateTime dueDate = DateTime.now();
                                dueDate = dueDate.add(Duration(days: 14));

                                final num = ((await reference.child('Student').child(widget.userID).child('rentalIDs').once()).value as List<dynamic> ?? []).length;
                                reference.child('Student').child(widget.userID).child('rentalIDs').child('$num').set(id);

                                final addRentalTransaction = await reference
                                    .child('library')
                                    .child('Rental')
                                    .child(id)
                                    .runTransaction((mutableData) async {
                                  mutableData.value = jsonEncode({
                                    'id': id,
                                    'bookID': widget.book.id,
                                    'bookTitle': widget.book.title,
                                    'borrowerID': widget.userID,
                                    'borrowerName': widget.userName,
                                    'dueDate': dueDate.toString()
                                  });
                                  return mutableData;
                                });
                                final addPersonalRentalTransaction =
                                    await reference
                                        .child('Student')
                                        .child(widget.userID)
                                        .child('rentals')
                                        .child(id)
                                        .runTransaction((mutableData) async {
                                  mutableData.value = jsonEncode({
                                    'id': id,
                                    'bookID': widget.book.id,
                                    'bookTitle': widget.book.title,
                                    'borrowerID': widget.userID,
                                    'borrowerName': widget.userName,
                                    'dueDate': dueDate.toString()
                                  });
                                  return mutableData;
                                });

                                if (borrowTransaction.committed &&
                                    addRentalTransaction.committed &&
                                    addPersonalRentalTransaction.committed) {
                                  EREToast(
                                      str.lang == '한국어'
                                          ? '대출 처리가 완료되었습니다.'
                                          : 'Succeeded to borrow the book.',
                                      context,
                                      false);
                                  widget.refresh();
                                }
                              } else
                                EREToast(
                                    str.lang == '한국어'
                                        ? '해당 도서가 맞는지 확인한 후 다시 시도해 주세요.'
                                        : 'Please check the book is right and try again.',
                                    context,
                                    true);
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
    );
  }
}
