import 'package:ere_manager/library/model/Book.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

import '../EREButton.dart';

class LibraryAcitivity extends StatefulWidget {
  _LibraryActivityState createState() => _LibraryActivityState();
}

enum TabState { bookList, myPage, admin }

class _LibraryActivityState extends State<LibraryAcitivity> {
  TabState tab = TabState.bookList;
  bool isAdmin = true; //todo:
  bool isWaiting = false; //todo:

  List<Book> books = [
    Book.fromJson({
      'id': 'test1',
      'title': 'test1',
      'author': 'test1',
      'isbn': 'test1',
      'isAvailable': true
    }),
    Book.fromJson({
      'id': 'test2',
      'title': 'test2',
      'author': 'test2',
      'isbn': 'test2',
      'isAvailable': true
    }),
    Book.fromJson({
      'id': 'test3',
      'title': 'test3',
      'author': 'test3',
      'isbn': 'test3',
      'isAvailable': true
    }),
  ];
  List<String> borrowedBooks = ['test1', 'test2', 'test3'];
  List<String> bookRequests = ['test1', 'test2', 'test3'];
  List<String> borrowers = ['test1', 'test2', 'test3'];

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;
    double tile_height = height * 0.05;
    double fontsize = width * 0.034;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: ERE_BLACK,
                    child: Text(
                      str.bookList,
                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                    ),
                    onPressed: tab != TabState.bookList
                        ? () {
                            setState(() {
                              tab = TabState.bookList;
                            });
                          }
                        : null,
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    color: ERE_BLACK,
                    child: Text(
                      str.myPage,
                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                    ),
                    onPressed: tab != TabState.myPage
                        ? () {
                            setState(() {
                              tab = TabState.myPage;
                            });
                          }
                        : null,
                  ),
                ),
                isAdmin
                    ? Expanded(
                        child: FlatButton(
                          color: ERE_BLACK,
                          child: Text(
                            str.admin,
                            style: TextStyle(
                                color: ERE_YELLOW, fontSize: fontsize),
                          ),
                          onPressed: tab != TabState.admin
                              ? () {
                                  setState(() {
                                    tab = TabState.admin;
                                  });
                                }
                              : null,
                        ),
                      )
                    : Container()
              ],
            ),
            tab == TabState.bookList
                ? Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.2,
                        height: tile_height,
                        child: Text(
                          str.number,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.5,
                        height: tile_height,
                        child: Text(
                          str.bookTitle,
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.3,
                        height: tile_height,
                        child: Text(
                          str.author,
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      )
                    ],
                  )
                : Container(),
            tab == TabState.bookList
                ? (isWaiting
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(ERE_YELLOW),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                            //todo: .builder 붙이고 시작
                            // itemCount: books.length,
                            // itemBuilder: (context, index) => BookTile(
                            //   refresh: () {
                            //     setState(() {});
                            //   },
                            // ),
                            ),
                      ))
                : (tab == TabState.myPage
                    ? Expanded(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(width * 0.015),
                              height: tile_height,
                              color: ERE_BLACK,
                              child: Text(
                                str.borrowedBooks,
                                style: TextStyle(
                                    color: ERE_YELLOW, fontSize: fontsize),
                              ),
                            ),
                            borrowedBooks.length > 0
                                ? Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(width * 0.0075),
                                        width: width * 0.4,
                                        height: tile_height,
                                        child: Text(
                                          str.bookTitle,
                                          style: TextStyle(
                                              color: ERE_YELLOW,
                                              fontSize: fontsize),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: width * 0.3,
                                        height: tile_height,
                                        child: Text(
                                          str.dueDate,
                                          style: TextStyle(
                                              color: ERE_YELLOW,
                                              fontSize: fontsize),
                                        ),
                                      )
                                    ],
                                  )
                                : Container(),
                            borrowedBooks.length > 0
                                ? Expanded(
                                    child: ListView(
                                        //todo: .builder 붙이고 시작
                                        // itemCount: borrowedBooks.length,
                                        // itemBuilder: (context, index) =>
                                        //     BorrowedBookTile(
                                        //   refresh: () {
                                        //     setState(() {});
                                        //   },
                                        // ),
                                        ),
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.015),
                                    height: tile_height,
                                    child: Text(
                                      str.noBorrowedBook,
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                            //todo: 관리자 모집 중일 때 ui - 지원자용
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView(children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(width * 0.015),
                            height: tile_height,
                            color: ERE_BLACK,
                            child: Text(
                              str.bookRequestList,
                              style: TextStyle(
                                  color: ERE_YELLOW, fontSize: fontsize),
                            ),
                          ),
                          Row(
                            children: [
                              //todo: 전체 선택용 체크박스 추가
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(width * 0.0075),
                                height: tile_height,
                                color: ERE_BLACK,
                                child: Text(
                                  str.all,
                                  style: TextStyle(
                                      color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: width * 0.2, //todo: 체크박스용 공간
                                height: tile_height,
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(width * 0.0075),
                                width: width * 0.4,
                                height: tile_height,
                                child: Text(
                                  str.bookTitle,
                                  style: TextStyle(
                                      color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(width * 0.0075),
                                width: width * 0.3,
                                height: tile_height,
                                child: Text(
                                  str.author,
                                  style: TextStyle(
                                      color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(width * 0.0075),
                                width: width * 0.3,
                                height: tile_height,
                                child: Text(
                                  str.requester,
                                  style: TextStyle(
                                      color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              )
                            ],
                          ),
                          bookRequests.length > 0
                              ? Expanded(
                                  child: ListView(
                                      //todo: .builder 붙이고 시작
                                      ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(width * 0.015),
                                  height: tile_height,
                                  child: Text(
                                    str.noBookRequest,
                                    style: TextStyle(
                                        color: ERE_YELLOW, fontSize: fontsize),
                                  ),
                                ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(width * 0.015),
                            height: tile_height,
                            color: ERE_BLACK,
                            child: Text(
                              str.borrowerList,
                              style: TextStyle(
                                  color: ERE_YELLOW, fontSize: fontsize),
                            ),
                          ),
                          borrowers.length > 0
                              ? Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(width * 0.0075),
                                      width: width * 0.4,
                                      height: tile_height,
                                      child: Text(
                                        str.bookTitle,
                                        style: TextStyle(
                                            color: ERE_YELLOW,
                                            fontSize: fontsize),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(width * 0.0075),
                                      width: width * 0.2,
                                      height: tile_height,
                                      child: Text(
                                        str.borrower,
                                        style: TextStyle(
                                            color: ERE_YELLOW,
                                            fontSize: fontsize),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(width * 0.0075),
                                      width: width * 0.3,
                                      height: tile_height,
                                      child: Text(
                                        str.dueDate,
                                        style: TextStyle(
                                            color: ERE_YELLOW,
                                            fontSize: fontsize),
                                      ),
                                    )
                                  ],
                                )
                              : Container(),
                          borrowers.length > 0
                              ? Expanded(
                                  child: ListView(
                                      //todo: .builder 붙이고 시작
                                      ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(width * 0.015),
                                  height: tile_height,
                                  child: Text(
                                    str.noBorrower,
                                    style: TextStyle(
                                        color: ERE_YELLOW, fontSize: fontsize),
                                  ),
                                ),
                        ]),
                      )),
            tab == TabState.bookList
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EREButton(
                        text: str.bookRequest,
                        onPressed: () {
                          //todo:
                        },
                        width: width,
                      ),
                      isAdmin
                          ? Padding(padding: EdgeInsets.all(width * 0.01))
                          : Container(),
                      isAdmin
                          ? EREButton(
                              text: str.addBook,
                              onPressed: () {
                                //todo:
                              },
                              width: width,
                            )
                          : Container()
                    ],
                  )
                : (tab == TabState.admin
                    ? EREButton(
                        text: str.text,
                        onPressed: () {
                          //todo:
                        },
                        width: width,
                      )
                    : Container())
          ],
        ),
      ),
    );
  }
}
