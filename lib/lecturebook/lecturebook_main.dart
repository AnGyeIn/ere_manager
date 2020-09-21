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
  User user;
  DatabaseReference reference;
  FirebaseList lecturebookList;
  FirebaseList requestList;

  String userID;
  String userName;
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

  bool isWaiting = true;

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.reference();
    reference.keepSynced(true);

    user = FirebaseAuth.instance.currentUser;
    userID = user.uid;

    reference.child('Student').child(userID).child('name').once().then((snapshot) {
      userName = snapshot.value ?? user.displayName;
    });

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
            lecturebooks = rawLecturebooks.map<LectureBook>((str) => LectureBook.fromJson(jsonDecode(str))).toList();
            lecturebooks.sort((a, b) => a.title.compareTo(b.title));
            isWaiting = false;
          });
        });

    requestList = FirebaseList(
        query: reference.child('Student').child(userID).child('LectureBookRequest'),
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
            requests = rawRequests.map<LectureBookRequest>((str) => LectureBookRequest.fromJson(jsonDecode(str))).toList();
            requests.sort((a, b) => a.requestTime.compareTo(b.requestTime));
            for (var request in requests) {
              if (request.ownerID == userID) requestListForOwner.add(request);
              if (request.receiverID == userID) requestListForReceiver.add(request);
            }
          });
        });

    reference.child('Student').child(userID).child('lang').once().then((snapshot) {
      if (snapshot.value == null || snapshot.value != str.lang) reference.child('Student').child(userID).child('lang').set(str.lang);
    });

    final firebaseMessaging = FirebaseMessaging();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
      EREToast('${message['notification']['title']}: ${message['notification']['body']}', context, true);
    });
    firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    firebaseMessaging.getToken().then((token) async {
      assert(token != null);

      if (token != (await reference.child('Student').child(userID).child('NT').once()).value) reference.child('Student').child(userID).child('NT').set(token);
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
                      str.lectureBookList,
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
                      str.myPage,
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
                          str.number,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.285,
                        height: tile_height,
                        child: Text(
                          str.lectureBookTitle,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.185,
                        height: tile_height,
                        child: Text(
                          str.author,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.185,
                        height: tile_height,
                        child: Text(
                          str.lecture,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(width * 0.0075),
                        width: width * 0.15,
                        height: tile_height,
                        child: Text(
                          str.owner,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.11,
                        height: tile_height,
                        child: Text(
                          str.option,
                          style: TextStyle(color: ERE_YELLOW, fontSize: fontsize * (str.lang == '한국어' ? 1 : 0.9)),
                        ),
                      )
                    ],
                  )
                : Container(),
            isLectureBookList
                ? (isWaiting
                    ? Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ERE_YELLOW),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: lecturebooks.length,
                          itemBuilder: (context, index) => LectureBookTile(
                            lectureBook: lecturebooks[index],
                            width: width,
                            height: height,
                            index: index + 1,
                            userID: userID,
                            userName: userName,
                            requestListForReceiver: requestListForReceiver,
                            refresh: () {
                              setState(() {});
                            },
                          ),
                        ),
                      ))
                : Expanded(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(width * 0.015),
                          height: tile_height,
                          color: ERE_BLACK,
                          child: Text(
                            str.lectureBookRequestToMe,
                            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
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
                                      str.number,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.35,
                                    height: tile_height,
                                    child: Text(
                                      str.lectureBookTitle,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 0.15,
                                    height: tile_height,
                                    child: Text(
                                      str.receiver,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 0.12,
                                    height: tile_height,
                                    child: Text(
                                      str.option,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        requestListForOwner.length > 0
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: requestListForOwner.length,
                                  itemBuilder: (context, index) => LectureBookRequestTileForOwner(
                                    index: index + 1,
                                    lectureBookRequest: requestListForOwner[index],
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
                                  str.noLectureBookRequestToMe,
                                  style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.all(width * 0.015),
                          height: tile_height,
                          color: ERE_BLACK,
                          child: Text(
                            str.lectureBookRequestFromMe,
                            style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
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
                                      str.number,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.35,
                                    height: tile_height,
                                    child: Text(
                                      str.lectureBookTitle,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(width * 0.0075),
                                    width: width * 0.15,
                                    height: tile_height,
                                    child: Text(
                                      str.owner,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 0.12,
                                    height: tile_height,
                                    child: Text(
                                      str.option,
                                      style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                    ),
                                  )
                                ],
                              )
                            : Container(),
                        requestListForReceiver.length > 0
                            ? Expanded(
                                child: ListView.builder(
                                  itemCount: requestListForReceiver.length,
                                  itemBuilder: (context, index) => LectureBookRequestTileForReceiver(
                                    index: index + 1,
                                    lectureBookRequest: requestListForReceiver[index],
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
                                  str.noLectureBookRequestFromMe,
                                  style: TextStyle(color: ERE_YELLOW, fontSize: fontsize),
                                ),
                              )
                      ],
                    ),
                  ),
            EREButton(
              text: str.lectureBookRegister,
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
                        width: width * 0.16,
                        height: height * 0.034,
                        child: Text(str.lectureBookTitle),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.49,
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
                        width: width * 0.16,
                        height: height * 0.034,
                        child: Text(str.author),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.49,
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
                        width: width * 0.16,
                        height: height * 0.034,
                        child: Text(str.lecture),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.49,
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
                        width: width * 0.16,
                        height: height * 0.034,
                        child: Text(str.option),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: width * 0.49,
                        child: TextField(
                          decoration: InputDecoration(hintText: str.lectureBookOptionHint),
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

                    final isbn = await FlutterBarcodeScanner.scanBarcode('#ffe4b92a', str.cancel, true, ScanMode.BARCODE);

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
                        newAuthor = newAuthor.substring(colonIdx + 2, semicolonIdx - 1);
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

                    _registerLectureBook(context, width, height);
                  },
                ),
                FlatButton(
                  child: Text(str.register),
                  onPressed: () async {
                    if (newTitle.isEmpty || newAuthor.isEmpty || newLecture.isEmpty || newOption.isEmpty)
                      EREToast(str.blankError, context, false);
                    else {
                      Navigator.pop(context);

                      final id = reference.child('lecturebook').child('LectureBook').push().key;

                      reference.root().child('Student').child(user.uid).child('lecturebookIDs').once().then((snapshot) {
                        final num = (snapshot.value as List<dynamic> ?? []).length;
                        reference.root().child('Student').child(user.uid).child('lecturebookIDs').child('$num').set(id);
                      });

                      final registerTransaction = await reference.child('lecturebook').child('LectureBook').child(id).runTransaction((mutableData) async {
                        mutableData.value = jsonEncode({
                          'id': id,
                          'title': newTitle,
                          'author': newAuthor,
                          'lecture': newLecture,
                          'ownerName': userName,
                          'ownerID': user.uid,
                          'option': newOption,
                          'isAvailable': true
                        });
                        return mutableData;
                      });

                      if (registerTransaction.committed) EREToast(str.lectureBookRegisterSuccess, context, false);
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
