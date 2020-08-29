import 'dart:ui';

import 'package:ere_manager/EREButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' as ui;
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'agreement.dart';
import 'credit/credit_main.dart';
import 'lecturebook/lecturebook_main.dart';
import 'login.dart';

const ERE_BLACK = Color(0xff080404);
const ERE_YELLOW = Color(0xffe4b92a);
const ERE_GREY = Color(0xff2f2f2f);

void main() => runApp(MaterialApp(home: MainActivity()));

class MainActivity extends StatefulWidget {
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  User user;
  bool loginCheck = false;
  bool isInitial = true;
  String sNum;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    if (isInitial) {
      isInitial = false;

      Firebase.initializeApp().then((_) {
        EREToast('자동로그인중...', context, false);

        user = FirebaseAuth.instance.currentUser;
        loginCheck = user != null;

        if (loginCheck)
          EREToast('로그인 성공', context, false);
        else
          EREToast('자동로그인 정보가 없습니다.', context, false);

        setState(() {});
      });
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                child: ButtonTheme(
                  minWidth: width * 0.8,
                  height: height * 0.05,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: EREButton(
                    text: '학점 체크리스트',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreditMainActivity(
                                  storage: CreditStorage())));
                    },
                    width: width,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(height * 0.08),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                child: ButtonTheme(
                  minWidth: width * 0.8,
                  height: height * 0.05,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: EREButton(
                    text: '수업 교재 대여',
                    onPressed: () async {
                      if (loginCheck) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LectureBookActivity()));
                      } else {
                        final prefs = await SharedPreferences.getInstance();
                        if (prefs.getBool('doesAgree') != true)
                          return Navigator.push<bool>(
                              context,
                              MaterialPageRoute<bool>(
                                  builder: (context) =>
                                      AgreementActivity())).then((result) {
                            setState(() {
                              loginCheck = result;
                              user = FirebaseAuth.instance.currentUser;
                            });
                          });
                        else
                          return Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute<bool>(
                                      builder: (context) => LoginActivity()))
                              .then((result) {
                            setState(() {
                              loginCheck = result;
                              user = FirebaseAuth.instance.currentUser;
                            });
                          });
                      }
                    },
                    width: width,
                  ),
                ),
              ),
            ),
            loginCheck
                ? Padding(
                    padding: EdgeInsets.all(height * 0.03),
                  )
                : Container(),
            loginCheck
                ? Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                            color: ERE_YELLOW, fontSize: width * 0.04),
                      ),
                      onPressed: () async {
                        await ui.FirebaseAuthUi.instance().logout();
                        setState(() {
                          loginCheck = false;
                          EREToast('로그아웃되었습니다.', context, false);
                        });
                      },
                    ),
                  )
                : Container(),
            loginCheck
                ? Padding(
                    padding: EdgeInsets.all(height * 0.01),
                  )
                : Container(),
            loginCheck
                ? Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text(
                        '개인정보 수정',
                        style: TextStyle(
                            color: ERE_YELLOW, fontSize: width * 0.04),
                      ),
                      onPressed: () async {
                        final reference = FirebaseDatabase.instance
                            .reference()
                            .child('Student')
                            .child(user.uid);
                        String curName =
                            (await reference.child('name').once()).value ?? '';
                        String curSNum =
                            (await reference.child('sNum').once()).value ?? '';
                        String curPNum =
                            (await reference.child('pNum').once()).value ?? '';

                        showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text(
                                    '개인정보 수정',
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('개인정보를 수정한 후 [수정] 버튼을 눌러주세요.'),
                                      Row(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: width * 0.2,
                                            height: height * 0.034,
                                            child: Text('이름 : '),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: width * 0.4,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                              ),
                                              controller: TextEditingController(
                                                  text: curName),
                                              onChanged: (text) =>
                                                  curName = text,
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
                                            child: Text('학번 : '),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: width * 0.4,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none),
                                              controller: TextEditingController(
                                                  text: curSNum),
                                              onChanged: (text) =>
                                                  curSNum = text,
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
                                            child: Text('연락처 : '),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: width * 0.4,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: InputBorder.none),
                                              controller: TextEditingController(
                                                  text: curPNum),
                                              onChanged: (text) =>
                                                  curPNum = text,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text('수정'),
                                      onPressed: () {
                                        reference
                                          ..child('name').set(curName)
                                          ..child('sNum').set(curSNum)
                                          ..child('pNum').set(curPNum);
                                        EREToast(
                                            '개인정보를 수정했습니다.', context, false);
                                        Navigator.pop(context);
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
                      },
                    ),
                  )
                : Container(),
            loginCheck
                ? Padding(
                    padding: EdgeInsets.all(height * 0.01),
                  )
                : Container(),
            loginCheck
                ? Align(
                    alignment: Alignment.center,
                    child: FlatButton(
                      child: Text(
                        '회원탈퇴',
                        style: TextStyle(
                            color: Color(0xaaff2424), fontSize: width * 0.04),
                      ),
                      onPressed: () async {
                        loginCheck = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                                  title: Text('회원탈퇴 안내'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          '탈퇴할 경우 회원가입 시 제공해주신 개인정보와 함께 학점 체크리스트 백업 데이터, 등록한 교재 정보, 교재 대여 신청 내역 등이 삭제됩니다. 탈퇴를 진행하시겠습니까?'),
                                      Row(
                                        children: [
                                          Container(
                                              alignment: Alignment.center,
                                              width: width * 0.2,
                                              height: height * 0.034,
                                              child: Text('학번 : ')),
                                          Container(
                                              alignment: Alignment.center,
                                              width: width * 0.4,
                                              child: TextField(
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        signed: true),
                                                decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: 'XXXX-XXXXX'),
                                                onChanged: (text) =>
                                                    sNum = text,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text('회원탈퇴'),
                                      textColor: Color(0xffff2424),
                                      onPressed: () async {
                                        if (sNum != null) {
                                          final reference = FirebaseDatabase
                                              .instance
                                              .reference();
                                          if (sNum ==
                                              (await reference
                                                      .child('Student')
                                                      .child(user.uid)
                                                      .child('sNum')
                                                      .once())
                                                  .value) {
                                            reference
                                                .child('Student')
                                                .child(user.uid)
                                                .remove();

                                            try {
                                              await ui.FirebaseAuthUi.instance()
                                                  .launchAuth(
                                                      [AuthProvider.email()]);
                                              user = FirebaseAuth
                                                  .instance.currentUser;
                                              await user.delete();
                                              EREToast('탈퇴처리가 완료되었습니다.',
                                                  context, true);
                                              Navigator.pop(context, false);
                                            } catch (e) {
                                              EREToast('탈퇴 실패', context, false);
                                              print(e);
                                            }
                                          } else
                                            EREToast('학번을 형식에 맞게 정확히 입력해주세요.',
                                                context, false);
                                        } else
                                          EREToast(
                                              '학번을 입력해주세요.', context, false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('취소'),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    )
                                  ],
                                ));
                        setState(() {});
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

void EREToast(String msg, BuildContext context, bool isLong) {
  Toast.show(msg, context,
      backgroundColor: ERE_BLACK,
      textColor: ERE_YELLOW,
      gravity: Toast.CENTER,
      duration: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);
}
