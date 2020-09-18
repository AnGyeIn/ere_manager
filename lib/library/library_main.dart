import 'dart:convert';

import 'package:ere_manager/library/Tile/BookRequestTile.dart';
import 'package:ere_manager/library/model/Book.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../EREButton.dart';
import 'Tile/BookTile.dart';
import 'Tile/BorrowedBookTile.dart';
import 'model/BookRequest.dart';
import 'model/Rental.dart';

class LibraryAcitivity extends StatefulWidget {
  _LibraryActivityState createState() => _LibraryActivityState();
}

enum TabState { bookList, myPage, admin }

class _LibraryActivityState extends State<LibraryAcitivity> {
  User user;
  DatabaseReference reference;
  FirebaseList bookList;
  FirebaseList personalRentalList;
  FirebaseList bookRequestList;
  FirebaseList candidateList;

  String userID;
  String userName;
  List<String> rawBooks = [];
  List<Book> books = [];
  List<String> rawPersonalRentals = [];
  List<Rental> personalRentals = [];
  List<String> rawBookRequests = [];
  List<BookRequest> bookRequests = [];
  List<String> rawCandidates = [];
  List<Map<String, dynamic>> candidates = [];

  TabState tab = TabState.bookList;
  bool isAdmin = false;
  bool isWaiting = true;
  bool isAdminChanging = false;
  bool selectAll = false;

  String requestTitle;
  String requestAuthor;
  String newTitle = '';
  String newAuthor = '';
  String newISBN = '';

  List<String> borrowers = ['test1', 'test2', 'test3'];

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.reference();
    reference.keepSynced(true);

    user = FirebaseAuth.instance.currentUser;
    userID = user.uid;

    reference.child('library').child('isAdminChanging').once().then((snapshot) {
      isAdminChanging = snapshot.value;
    });

    reference
        .child('Student')
        .child(userID)
        .child('name')
        .once()
        .then((snapshot) {
      userName = snapshot.value ?? user.displayName;
    });

    bookList = FirebaseList(
        query: reference.child('library').child('Book'),
        onChildAdded: (idx, snapshot) {
          rawBooks.insert(idx, snapshot.value);
        },
        onChildRemoved: (idx, snapshot) {
          rawBooks.removeAt(idx);
        },
        onChildChanged: (idx, snapshot) {
          rawBooks.removeAt(idx);
          rawBooks.insert(idx, snapshot.value);
        },
        onValue: (snapshot) {
          setState(() {
            books = rawBooks
                .map<Book>((str) => Book.fromJson(jsonDecode(str)))
                .toList();
            books.sort((a, b) => a.title.compareTo(b.title));
            isWaiting = false;
          });
        });
    personalRentalList = FirebaseList(
        query: reference.child('Student').child(userID).child('rentals'),
        onChildAdded: (idx, snapshot) {
          rawPersonalRentals.insert(idx, snapshot.value);
        },
        onChildRemoved: (idx, snapshot) {
          rawPersonalRentals.removeAt(idx);
        },
        onChildChanged: (idx, snapshot) {
          rawPersonalRentals.removeAt(idx);
          rawPersonalRentals.insert(idx, snapshot.value);
        },
        onValue: (snapshot) {
          setState(() {
            personalRentals = rawPersonalRentals
                .map<Rental>((str) => Rental.fromJson(jsonDecode(str)))
                .toList();
            personalRentals.sort((a, b) => a.bookTitle.compareTo(b.bookTitle));
          });
        });

    reference.child('library').child('admin').once().then((snapshot) {
      isAdmin = userID == snapshot.value;
      if (isAdmin) {
        bookRequestList = FirebaseList(
            query: reference.child('library').child('BookRequest'),
            onChildAdded: (idx, snapshot) {
              rawBookRequests.insert(idx, snapshot.value);
            },
            onChildRemoved: (idx, snapshot) {
              rawBookRequests.removeAt(idx);
            },
            onChildChanged: (idx, snapshot) {
              rawBookRequests.removeAt(idx);
              rawBookRequests.insert(idx, snapshot.value);
            },
            onValue: (snapshot) {
              setState(() {
                bookRequests = rawBookRequests
                    .map<BookRequest>(
                        (str) => BookRequest.fromJson(jsonDecode(str)))
                    .toList();
                bookRequests.sort((a, b) => a.title.compareTo(b.title));
              });
            });
        candidateList = FirebaseList(
            query: reference.child('library').child('adminCandidates'),
            onChildAdded: (idx, snapshot) {
              rawCandidates.insert(idx, snapshot.value);
            },
            onChildRemoved: (idx, snapshot) {
              rawCandidates.removeAt(idx);
            },
            onChildChanged: (idx, snapshot) {
              rawCandidates.removeAt(idx);
              rawCandidates.insert(idx, snapshot.value);
            },
            onValue: (snapshot) {
              setState(() {
                candidates = rawCandidates.map<Map<String, dynamic>>((str) => jsonDecode(str)).toList();
              });
            }
        );
      }
    });
  }

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
                        width: width * 0.1,
                        height: tile_height,
                        child: Text(
                          str.number,
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.6,
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
                ? isWaiting
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
                        child: ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) => BookTile(
                            book: books[index],
                            width: width,
                            height: height,
                            index: index + 1,
                            userID: userID,
                            userName: userName,
                            refresh: () {
                              setState(() {});
                            },
                            isAdmin: isAdmin,
                          ),
                        ),
                      )
                : tab == TabState.myPage
                    ? Expanded(
                        child: Column(
                          children: [
                            isAdminChanging
                                ? EREButton(
                                    text: str.candidacyAdmin,
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                title: Text(
                                                    str.candidacyAdminInfo),
                                                content: Text(str.lang == '한국어'
                                                    ? '관리자 선정은 에자공 학생회에 의해 이루어지며 본 과정은 앱에서의 권한 이전을 위한 형식적인 절차입니다. 관리자 지원 후 전임 관리자의 승인 시점부터 에자공 도서관 관리자로서의 책임과 권한이 부여됩니다.\n지원 신청을 위해 [신청] 버튼을 눌러주세요.'
                                                    : 'ERE student council nominates the administrator and this process is just formal step to transfer the authority on application system. As you apply as a candidate and the former administrator approve your application, you get the responsibility and authority as ERE library administrator.\nPress [Apply] for candidacy'),
                                                actions: [
                                                  FlatButton(
                                                    child: Text(str.apply2),
                                                    onPressed: () async {
                                                      final alreadyApply =
                                                          (await reference
                                                                      .child(
                                                                          'library')
                                                                      .child(
                                                                          'adminCandidates')
                                                                      .child(
                                                                          userID)
                                                                      .once())
                                                                  .value !=
                                                              null;
                                                      if (alreadyApply) {
                                                        EREToast(
                                                            str.lang == '한국어'
                                                                ? '이미 지원하셨습니다.'
                                                                : 'You are already in the candidates.',
                                                            context,
                                                            false);
                                                        Navigator.pop(context);
                                                      } else {
                                                        final sNum = (await reference.child('Student').child(userID).child('sNum').once()).value;
                                                        final candidacyTransaction =
                                                            await reference
                                                                .child(
                                                                    'library')
                                                                .child(
                                                                    'adminCandidates')
                                                                .child(userID)
                                                                .runTransaction(
                                                                    (mutableData) async {
                                                          mutableData.value = jsonEncode({
                                                            'id': userID,
                                                            'name': userName,
                                                            'sNum': sNum,
                                                          });
                                                          return mutableData;
                                                        });

                                                        if (candidacyTransaction
                                                            .committed) {
                                                          EREToast(
                                                              str.lang == '한국어'
                                                                  ? '지원이 접수되었습니다.'
                                                                  : 'Succeeded to apply as a candidate.',
                                                              context,
                                                              false);
                                                          Navigator.pop(
                                                              context);
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
                                    width: width,
                                  )
                                : Container(),
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
                            personalRentals.length > 0
                                ? Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(width * 0.0075),
                                        width: width * 0.1,
                                        height: tile_height,
                                        child: Text(
                                          str.number,
                                          style: TextStyle(
                                              color: ERE_YELLOW,
                                              fontSize: fontsize),
                                        ),
                                      ),
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
                            personalRentals.length > 0
                                ? Expanded(
                                    child: ListView.builder(
                                      itemCount: personalRentals.length,
                                      itemBuilder: (context, index) =>
                                          BorrowedBookTile(
                                        index: index + 1,
                                        rental: personalRentals[index],
                                        width: width,
                                        height: height,
                                        refresh: () {
                                          setState(() {});
                                        },
                                      ),
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
                          ],
                        ),
                      )
                    : Expanded(
                        //tab == TabState.admin
                        child: Column(children: [
                          !isAdminChanging ? EREButton(
                            text: str.recruitAdmin,
                            onPressed: () async {
                              isAdminChanging = true;
                              await reference.child('library').child('isAdminChanging').set(true);
                              setState(() {});
                            },
                            width: width,
                          ) : EREButton(
                            text: str.cancelRecruitAdmin,
                            onPressed: () async {
                              isAdminChanging = false;
                              await reference.child('library').child('isAdminChanging').set(false);
                              setState(() {});
                            },
                            width: width,
                          ),
                          isAdminChanging ? Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(width * 0.015),
                            height: tile_height,
                            color: ERE_BLACK,
                            child: Text(
                              str.candidate,
                              style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                            ),
                          ) : Container(),
                          isAdminChanging ?
                          candidates.length > 0 ?
                          Expanded(
                            child: ListView.builder(
                              itemCount: candidates.length,
                              itemBuilder: (context, index) => Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.2,
                                    height: tile_height,
                                    child: Text(candidates[index]['name'], style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.3,
                                    height: tile_height,
                                    child: Text(candidates[index]['sNum'], style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 0.2,
                                    height: tile_height,
                                    child: EREButton(
                                      text: str.approve,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(str.approveERELibraryAdminInfo),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('${str.lang == '한국어' ? '관리자 선정을 승인하면 즉시 관리자로서의 책임과 권한이 인계됩니다.\n지원자를 승인하시겠습니까?' :
                                                'As you approve the candidate, the responsibility and the authority as the administrator are transferred to the candidate.\nWould you approve the candidate?'}\n\n'
                                                    '${str.name} : ${candidates[index]['name']}, ${str.studentID} : ${candidates[index]['sNum']}'),
                                              ],
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(str.approve),
                                                onPressed: () {
                                                  reference.child('library')..child('admin').set(candidates[index]['id'])
                                                  ..child('adminCandidates').remove()
                                                  ..child('isAdminChanging').set(false);
                                                  EREToast(str.lang == '한국어' ? '새로운 관리자가 선정되었습니다.' : 'Succeeded to nominate new administrator.', context, false);
                                                  Navigator.pop(context);
                                                  setState(() async {
                                                    isAdminChanging = false;
                                                    isAdmin = userID == (await reference.child('library').child('admin').once()).value;
                                                  });
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(str.cancel),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              )
                                            ],
                                          )
                                        );
                                      },
                                      width: width,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ) : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(width * 0.015),
                            height: tile_height,
                            child: Text(
                              str.noCandidate,
                              style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                            ),
                          ) : Container(),
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
                              Checkbox(
                                value: selectAll,
                                onChanged: (_) {
                                  setState(() {
                                    selectAll = !selectAll;
                                    for (var bookRequest in bookRequests)
                                      bookRequest.isChecked = selectAll;
                                  });
                                },
                                checkColor: ERE_YELLOW,
                                activeColor: ERE_BLACK,
                              ),
                              Container(
                                alignment: Alignment.center,
                                // padding: EdgeInsets.all(width * 0.0075),
                                width: width * 0.07,
                                height: tile_height,
                                child: Text(
                                  str.number,
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
                                width: width * 0.2,
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
                                  child: ListView.builder(
                                    itemCount: bookRequests.length,
                                    itemBuilder: (context, index) =>
                                        BookRequestTile(
                                      index: index + 1,
                                      bookRequest: bookRequests[index],
                                      width: width,
                                      height: height,
                                      refresh: () {
                                        setState(() {});
                                      },
                                    ),
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
                          bookRequests.length > 0
                              ? EREButton(
                                  text: str.text,
                                  onPressed: () {
                                    String selectedRequests = '';
                                    String selectedRequestsForEmail = '';
                                    int i = 1;
                                    for (var bookRequest in bookRequests)
                                      if (bookRequest.isChecked) {
                                        selectedRequests +=
                                            '${i}/${bookRequest.title}/${bookRequest.author}/${bookRequest.requesterName}\n';
                                        selectedRequestsForEmail +=
                                            '${i++}\t${bookRequest.title}\t${bookRequest.author}\t${bookRequest.requesterName}\n';
                                      }

                                    if (i < 2)
                                      EREToast(
                                          str.lang == '한국어'
                                              ? '선택된 신청 목록이 없습니다.'
                                              : "you don't select any request in the list.",
                                          context,
                                          false);
                                    else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text((str.lang == '한국어'
                                                            ? '다음 신청 목록을 이메일로 전송할 수 있습니다.\n\n'
                                                                '순번/도서명/저자/신청자\n'
                                                            : 'You can send request list below by email.\n\n'
                                                                'No./Book title/Author/Requester\n') +
                                                        selectedRequests),
                                                  ],
                                                ),
                                                actions: [
                                                  FlatButton(
                                                    child: Text(str.email),
                                                    onPressed: () async {
                                                      final uri = Uri(
                                                          scheme: 'mailto',
                                                          path: user.email,
                                                          queryParameters: {
                                                            'subject': str
                                                                        .lang ==
                                                                    '한국어'
                                                                ? '에자공_도서관_도서_구비_신청_목록'
                                                                : 'ERE library requests to furnish books',
                                                            'body':
                                                                selectedRequestsForEmail
                                                          });
                                                      if (await canLaunch(
                                                          uri.toString())) {
                                                        await launch(
                                                            uri.toString());
                                                        Navigator.pop(context);

                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (_) =>
                                                                    AlertDialog(
                                                                      content: Text(str.lang ==
                                                                              '한국어'
                                                                          ? '이메일로 전송한 목록들을 서버에서 삭제하고 신청자들에게 푸시 알림을 보낼 수 있습니다. 목록을 삭제하시겠습니까?'
                                                                          : 'You can remove the requests you sent by email from the server and notify the requesters by push notification. Would you remove the requests?'),
                                                                      actions: [
                                                                        FlatButton(
                                                                          child:
                                                                              Text(
                                                                            str.remove,
                                                                            style:
                                                                                TextStyle(color: Color(0xffff4242)),
                                                                          ),
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            for (var bookRequest
                                                                                in bookRequests)
                                                                              if (bookRequest.isChecked)
                                                                                await reference.child('library').child('BookRequest').child(bookRequest.id).remove();
                                                                          },
                                                                        ),
                                                                        FlatButton(
                                                                          child:
                                                                              Text(str.cancel),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        )
                                                                      ],
                                                                    ));
                                                      } else
                                                        throw 'Could not launch ${uri.toString()}';
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
                                  },
                                  width: width,
                                )
                              : Container()
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   padding: EdgeInsets.all(width * 0.015),
                          //   height: tile_height,
                          //   color: ERE_BLACK,
                          //   child: Text(
                          //     str.borrowerList,
                          //     style: TextStyle(
                          //         color: ERE_YELLOW, fontSize: fontsize),
                          //   ),
                          // ),
                          // borrowers.length > 0
                          //     ? Row(
                          //         children: [
                          //           Container(
                          //             alignment: Alignment.center,
                          //             padding: EdgeInsets.all(width * 0.0075),
                          //             width: width * 0.4,
                          //             height: tile_height,
                          //             child: Text(
                          //               str.bookTitle,
                          //               style: TextStyle(
                          //                   color: ERE_YELLOW,
                          //                   fontSize: fontsize),
                          //             ),
                          //           ),
                          //           Container(
                          //             alignment: Alignment.center,
                          //             padding: EdgeInsets.all(width * 0.0075),
                          //             width: width * 0.2,
                          //             height: tile_height,
                          //             child: Text(
                          //               str.borrower,
                          //               style: TextStyle(
                          //                   color: ERE_YELLOW,
                          //                   fontSize: fontsize),
                          //             ),
                          //           ),
                          //           Container(
                          //             alignment: Alignment.center,
                          //             padding: EdgeInsets.all(width * 0.0075),
                          //             width: width * 0.3,
                          //             height: tile_height,
                          //             child: Text(
                          //               str.dueDate,
                          //               style: TextStyle(
                          //                   color: ERE_YELLOW,
                          //                   fontSize: fontsize),
                          //             ),
                          //           )
                          //         ],
                          //       )
                          //     : Container(),
                          // borrowers.length > 0
                          //     ? Expanded(
                          //         child: ListView(
                          //             //todo: .builder 붙이고 시작
                          //             ),
                          //       )
                          //     : Container(
                          //         alignment: Alignment.center,
                          //         padding: EdgeInsets.all(width * 0.015),
                          //         height: tile_height,
                          //         child: Text(
                          //           str.noBorrower,
                          //           style: TextStyle(
                          //               color: ERE_YELLOW, fontSize: fontsize),
                          //         ),
                          //        ),
                        ]),
                      ),
            tab == TabState.bookList
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      EREButton(
                        text: str.bookRequest,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text(str.bookFurnishingRequest),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(str.lang == '한국어'
                                            ? '도서명과 저자를 입력한 뒤 [신청]을 누르면 구비 신청이 접수됩니다. 구비 신청은 관리자가 수합하여 에자공 학과사무실로 전달하며, 신청이 수합되면 푸시 알림으로 알려드립니다.'
                                            : 'Type in the title and the author of the book and press [Request], then your request to furnish the book is received. The requests are delivered to the office of ERE by the administrator. When your request is delivered, we notice you by push notification.'),
                                        Row(
                                          children: [
                                            Container(
                                                alignment: Alignment.center,
                                                width: width * 0.2,
                                                height: height * 0.034,
                                                child: Text(str.bookTitle)),
                                            Container(
                                              alignment: Alignment.center,
                                              width: width * 0.4,
                                              child: TextField(
                                                onChanged: (text) =>
                                                    requestTitle = text,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              width: width * 0.2,
                                              height: height * 0.034,
                                              child: Text(str.author),
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              width: width * 0.4,
                                              child: TextField(
                                                onChanged: (text) =>
                                                    requestAuthor = text,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text(str.request),
                                        onPressed: () async {
                                          if (requestTitle.isEmpty ||
                                              requestAuthor.isEmpty)
                                            EREToast(
                                                str.lang == '한국어'
                                                    ? '도서명과 저자를 입력해주세요.'
                                                    : 'Please type in the title and the author of the book.',
                                                context,
                                                false);
                                          else {
                                            final id = reference
                                                .child('library')
                                                .child('BookRequest')
                                                .push()
                                                .key;
                                            final bookRequestTransaction =
                                                await reference
                                                    .child('library')
                                                    .child('BookRequest')
                                                    .child(id)
                                                    .runTransaction(
                                                        (mutableData) async {
                                              mutableData.value = jsonEncode({
                                                'id': id,
                                                'title': requestTitle,
                                                'author': requestAuthor,
                                                'requesterID': userID,
                                                'requesterName': userName
                                              });
                                              return mutableData;
                                            });
                                            final personalBookRequestTransaction =
                                                await reference
                                                    .child('Student')
                                                    .child(userID)
                                                    .child('bookRequests')
                                                    .child(id)
                                                    .runTransaction(
                                                        (mutableData) async {
                                              mutableData.value = jsonEncode({
                                                'id': id,
                                                'title': requestTitle,
                                                'author': requestAuthor,
                                                'requesterID': userID,
                                                'requesterName': userName
                                              });
                                              return mutableData;
                                            });

                                            if (bookRequestTransaction
                                                    .committed &&
                                                personalBookRequestTransaction
                                                    .committed)
                                              EREToast(
                                                  str.lang == '한국어'
                                                      ? '도서 구비 신청이 접수되었습니다.'
                                                      : 'Succeeded to request to furnish the book.',
                                                  context,
                                                  false);
                                            else
                                              EREToast(
                                                  str.lang == '한국어'
                                                      ? '도서 구비 신청이 실패했습니다.'
                                                      : 'Failed to request to furnish the book.',
                                                  context,
                                                  false);
                                            Navigator.pop(context);
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
                        width: width,
                      ),
                      isAdmin
                          ? Padding(padding: EdgeInsets.all(width * 0.01))
                          : Container(),
                      isAdmin
                          ? EREButton(
                              text: str.addBook,
                              onPressed: () {
                                newTitle = '';
                                newAuthor = '';
                                newISBN = '';
                                _registerBook(context, width, height);
                              },
                              width: width,
                            )
                          : Container()
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    reference.keepSynced(false);
    bookList.clear();
    personalRentalList.clear();
    if (bookRequestList != null) bookRequestList.clear();
    if (candidateList != null) candidateList.clear();
  }

  _registerBook(BuildContext context, double width, double height) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.2,
                        height: height * 0.034,
                        child: Text(str.bookTitle),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.4,
                        child: TextField(
                          onChanged: (text) => newTitle = text,
                          controller: TextEditingController(text: newTitle),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.2,
                        height: height * 0.034,
                        child: Text(str.author),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.4,
                        child: TextField(
                          onChanged: (text) => newAuthor = text,
                          controller: TextEditingController(text: newAuthor),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.2,
                        height: height * 0.034,
                        child: Text('ISBN'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.4,
                        child: TextField(
                          onChanged: (text) => newISBN = text,
                          controller: TextEditingController(text: newISBN),
                        ),
                      )
                    ],
                  ),
                  Text(str.lang == '한국어'
                      ? '도서명, 저자, ISBN 정보를 확인 후 [추가]를 눌러주세요.'
                      : 'Check the title, the author, and the ISBN of the book and press [Add]')
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    Navigator.pop(context);

                    newISBN = await FlutterBarcodeScanner.scanBarcode(
                        '#ffe4b92a', str.cancel, true, ScanMode.BARCODE);

                    if (newISBN == '-1') {
                      _registerBook(context, width, height);
                      return;
                    }

                    final response = await http.get(
                        'https://www.nl.go.kr/NL/search/openApi/search.do?key=7a027ec35475c09ee0104e636268c75db442c45337caf1d246edc6ea2c5f4fa7&detailSearch=true&isbnOp=isbn&isbnCode=$newISBN');
                    try {
                      final list = response.body.split('\n');

                      newTitle = list[11].trim();

                      final titleLength = newTitle.length;
                      newTitle = newTitle.substring(21, titleLength - 16);

                      newAuthor = list[14].trim();
                      final authorLength = newAuthor.length;
                      if (newAuthor.contains(':')) {
                        final colonIdx = newAuthor.indexOf(':');
                        final semicolonIdx = newAuthor.indexOf(';');
                        newAuthor =
                            newAuthor.substring(colonIdx + 2, semicolonIdx - 1);
                      } else if (newAuthor.contains(';')) {
                        final semicolonIdx2 = newAuthor.indexOf(';');
                        newAuthor = newAuthor.substring(22, semicolonIdx2 - 1);
                      } else
                        newAuthor = newAuthor.substring(22, authorLength - 17);
                    } catch (e) {
                      EREToast(str.barcodeScanError, context, true);
                      newTitle = '';
                      newAuthor = '';
                    }

                    _registerBook(context, width, height);
                  },
                ),
                FlatButton(
                  child: Text(str.add),
                  onPressed: () async {
                    if (newTitle.isEmpty ||
                        newAuthor.isEmpty ||
                        newISBN.isEmpty)
                      EREToast(str.blankError, context, false);
                    else {
                      Navigator.pop(context);

                      final id =
                          reference.child('library').child('Book').push().key;
                      final addBookTransaction = await reference
                          .child('library')
                          .child('Book')
                          .child(id)
                          .runTransaction((mutableData) async {
                        mutableData.value = jsonEncode({
                          'id': id,
                          'title': newTitle,
                          'author': newAuthor,
                          'isbn': newISBN,
                          'isAvailable': true
                        });
                        return mutableData;
                      });

                      if (addBookTransaction.committed)
                        EREToast(
                            str.lang == '한국어'
                                ? '도서가 추가되었습니다.'
                                : 'Succeeded to add the book.',
                            context,
                            false);
                      //todo: if문 안에 setState() 필요?
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
  }
}
