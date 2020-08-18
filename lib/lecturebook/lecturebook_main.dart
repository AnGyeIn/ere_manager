import 'dart:convert';

import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_list.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'Tile/LectureBookRequestTileForOwner.dart';
import 'Tile/LectureBookRequestTileForReceiver.dart';
import 'Tile/LectureBookTile.dart';
import 'model/LectureBook.dart';
import 'model/LectureBookRequest.dart';
import 'package:http/http.dart' as http;

class LectureBookActivity extends StatefulWidget {
  _LectureBookActivityState createState() => _LectureBookActivityState();
}

class _LectureBookActivityState extends State<LectureBookActivity> {
  FirebaseUser user;
  DatabaseReference reference;
  FirebaseList lecturebookList;
  FirebaseList requestList;

  String userID;
  List<String> rawLecturebooks = [];
  List<LectureBook> lecturebooks = [];
  List<String> rawRequests = [];
  List<LectureBookRequest> requests = [];
  List<LectureBookRequest> requestListForOwner = [];
  List<LectureBookRequest> requestListForReceiver = [];

  bool isLectureBookList = true;
  String newTitle = '';
  String newAuthor = '';
  String newLecture = '';
  String newOption = '';

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.reference();
    reference.keepSynced(true);

    FirebaseAuth.instance.currentUser().then((curUser) {
      user = curUser;
      userID = user.uid;

      lecturebookList = FirebaseList(
          query: reference.child('lecturebook').child('LectureBook'),
          onChildAdded: (idx, snapshot) {
            rawLecturebooks.insert(idx, snapshot.value);
          },
          onChildRemoved: (idx, snapshot) {
            rawLecturebooks.removeAt(idx);
          },
          onChildChanged: (idx, snapshot) {
            rawLecturebooks.removeAt(idx);
            rawLecturebooks.insert(idx, snapshot.value);
          },
          onValue: (snapshot) {
            setState(() {
              lecturebooks = rawLecturebooks
                  .map<LectureBook>(
                      (str) => LectureBook.fromJson(jsonDecode(str)))
                  .toList();
              lecturebooks.sort((a, b) => a.title.compareTo(b.title));
            });
          });

      requestList = FirebaseList(
          query: reference.child('lecturebook').child('LectureBookRequest'),
          onChildAdded: (idx, snapshot) {
            rawRequests.insert(idx, snapshot.value);
          },
          onChildRemoved: (idx, snapshot) {
            rawRequests.removeAt(idx);
          },
          onChildChanged: (idx, snapshot) {
            rawRequests.removeAt(idx);
            rawRequests.insert(idx, snapshot.value);
          },
          onValue: (snapshot) {
            setState(() {
              requestListForOwner.clear();
              requestListForReceiver.clear();
              requests = rawRequests
                  .map<LectureBookRequest>(
                      (str) => LectureBookRequest.fromJson(jsonDecode(str)))
                  .toList();
              requests.sort((a, b) => a.requestTime.compareTo(b.requestTime));
              for (var request in requests) {
                if (request.ownerID == userID) requestListForOwner.add(request);
                if (request.receiverID == userID)
                  requestListForReceiver.add(request);
              }
            });
          });

      final firebaseMessaging = FirebaseMessaging();
      firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
            EREToast('교재 신청 내역에 변동이 생겼습니다.', context, true);
          },
          onLaunch: (Map<String, dynamic> message) async {
            setState(() {
              isLectureBookList = false;
            });
          },
          onResume: (Map<String, dynamic> message) async {
            setState(() {
              isLectureBookList = false;
            });
          }
      );
      firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
      firebaseMessaging.getToken().then((token) async {
        assert(token != null);

        if (token != (await reference.child('Student').child(userID).child('NT').once()).value)
          reference.child('Student').child(userID).child('NT').set(token);
      });
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
                      '수업 교재 목록',
                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                    ),
                    onPressed: !isLectureBookList
                        ? () {
                            setState(() {
                              isLectureBookList = true;
                            });
                          }
                        : null,
                  ),
                ),
                Expanded(
                  child: FlatButton(
                    color: ERE_BLACK,
                    child: Text(
                      '마이페이지',
                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                    ),
                    onPressed: isLectureBookList
                        ? () {
                            setState(() {
                              isLectureBookList = false;
                            });
                          }
                        : null,
                  ),
                )
              ],
            ),
            isLectureBookList
                ? Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.084,
                        height: tile_height,
                        child: Text(
                          '번호',
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.285,
                        height: tile_height,
                        child: Text(
                          '교재명',
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.185,
                        height: tile_height,
                        child: Text(
                          '저자',
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.185,
                        height: tile_height,
                        child: Text(
                          '과목',
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.15,
                        height: tile_height,
                        child: Text(
                          '제공자',
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.11,
                        height: tile_height,
                        child: Text(
                          '방식',
                          style:
                              TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      )
                    ],
                  )
                : Container(),
            isLectureBookList
                ? Expanded(
                    child: ListView.builder(
                      itemCount: lecturebooks.length,
                      itemBuilder: (context, index) => LectureBookTile(
                        lectureBook: lecturebooks[index],
                        width: width,
                        height: height,
                        index: index + 1,
                        userID: userID,
                        userName: user.displayName,
                        requestListForReceiver: requestListForReceiver,
                        refresh: () {
                          setState(() {});
                        },
                      ),
                    ),
                  )
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(width * 0.015),
                          height: tile_height,
                          color: ERE_BLACK,
                          child: Text(
                            '나에게 온 신청',
                            style: TextStyle(
                                color: ERE_YELLOW, fontSize: fontsize),
                          ),
                        ),
                        requestListForOwner.length > 0
                            ? Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.15,
                                    height: tile_height,
                                    child: Text(
                                      '순번',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.35,
                                    height: tile_height,
                                    child: Text(
                                      '교재명',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.15,
                                    height: tile_height,
                                    child: Text(
                                      '신청자',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.11,
                                    height: tile_height,
                                    child: Text(
                                      '방식',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        requestListForOwner.length > 0
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: requestListForOwner.length,
                                  itemBuilder: (context, index) =>
                                      LectureBookRequestTileForOwner(
                                    index: index + 1,
                                    lectureBookRequest:
                                        requestListForOwner[index],
                                    requestListForOwner: requestListForOwner,
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
                                  '받은 신청이 없습니다.',
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
                            '내가 보낸 신청',
                            style: TextStyle(
                                color: ERE_YELLOW, fontSize: fontsize),
                          ),
                        ),
                        requestListForReceiver.length > 0
                            ? Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.15,
                                    height: tile_height,
                                    child: Text(
                                      '순번',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.35,
                                    height: tile_height,
                                    child: Text(
                                      '교재명',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.15,
                                    height: tile_height,
                                    child: Text(
                                      '제공자',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.11,
                                    height: tile_height,
                                    child: Text(
                                      '방식',
                                      style: TextStyle(
                                          color: ERE_YELLOW,
                                          fontSize: fontsize),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        requestListForReceiver.length > 0
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: requestListForReceiver.length,
                                  itemBuilder: (context, index) =>
                                      LectureBookRequestTileForReceiver(
                                    index: index + 1,
                                    lectureBookRequest:
                                        requestListForReceiver[index],
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
                                  '보낸 신청이 없습니다.',
                                  style: TextStyle(
                                      color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              )
                      ],
                    ),
                  ),
            EREButton(
              text: '교재 등록',
              onPressed: () {
                newTitle = '';
                newAuthor = '';
                newLecture = null;
                newOption = null;
                _registerLectureBook(context, width, height);
              },
              width: width,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    reference.keepSynced(false);
    lecturebookList.clear();
    requestList.clear();
  }

  _registerLectureBook(BuildContext context, double width, double height) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.15,
                        height: height * 0.034,
                        child: Text('교재명'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.5,
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
                        width: width * 0.15,
                        height: height * 0.034,
                        child: Text('저자'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.5,
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
                        width: width * 0.15,
                        height: height * 0.034,
                        child: Text('과목'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.5,
                        child: TextField(
                          onChanged: (text) => newLecture = text,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.15,
                        height: height * 0.034,
                        child: Text('방식'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.5,
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: "'대여' 또는 '양도' 입력"),
                          onChanged: (text) => newOption = text,
                        ),
                      )
                    ],
                  )
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () async {
                    Navigator.pop(context);

                    final isbn = await FlutterBarcodeScanner.scanBarcode(
                        '#ffe4b92a', '취소', true, ScanMode.BARCODE);

                    if (isbn == '-1') {
                      _registerLectureBook(context, width, height);
                      return;
                    }

                    final response = await http.get(
                        'https://www.nl.go.kr/NL/search/openApi/search.do?key=7a027ec35475c09ee0104e636268c75db442c45337caf1d246edc6ea2c5f4fa7&detailSearch=true&isbnOp=isbn&isbnCode=$isbn');
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
                      EREToast(
                          '국립중앙도서관에 등록정보가 없습니다. 양식을 직접 입력해주세요.', context, true);
                      newTitle = '';
                      newAuthor = '';
                    }

                    _registerLectureBook(context, width, height);
                  },
                ),
                FlatButton(
                  child: Text('등록'),
                  onPressed: () async {
                    if (newTitle == null ||
                        newAuthor == null ||
                        newLecture == null ||
                        newOption == null)
                      EREToast('빈칸을 모두 입력해주세요.', context, false);
                    else {
                      Navigator.pop(context);

                      final id = reference
                          .child('lecturebook')
                          .child('LectureBook')
                          .push()
                          .key;

                      reference
                          .root()
                          .child('Student')
                          .child(user.uid)
                          .child('lecturebooks')
                          .once()
                          .then((snapshot) {
                        final num =
                            (snapshot.value as List<dynamic> ?? []).length;
                        reference
                            .root()
                            .child('Student')
                            .child(user.uid)
                            .child('lecturebooks')
                            .child('$num')
                            .set(id);
                      });

                      final registerTransaction = await reference
                          .child('lecturebook')
                          .child('LectureBook')
                          .child(id)
                          .runTransaction((mutableData) async {
                        mutableData.value = jsonEncode({
                          'id': id,
                          'title': newTitle,
                          'author': newAuthor,
                          'lecture': newLecture,
                          'ownerName': user.displayName,
                          'ownerID': user.uid,
                          'option': newOption,
                          'isAvailable': true
                        });
                        return mutableData;
                      });

                      if (registerTransaction.committed) {
                        EREToast('교재가 등록되었습니다.', context, false);
                        setState(() {});
                      }
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
  }
}
