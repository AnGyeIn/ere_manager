import 'dart:ui';

import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/library/library_main.dart';
import 'package:ere_manager/string_values.dart';
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

Str str;

void main() => runApp(MaterialApp(home: MainActivity()));

class MainActivity extends StatefulWidget {
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  User user;
  bool loginCheck = false;
  bool isInitial = true;
  String sNum;
  String lang = '한국어';

  _move(StatefulWidget activity) async {
    if (loginCheck) {
      return Navigator.push(context, MaterialPageRoute(builder: (context) => activity));
    } else {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('doesAgree') != true)
        Navigator.push<bool>(context, MaterialPageRoute<bool>(builder: (context) => AgreementActivity())).then((result) {
          setState(() {
            loginCheck = result ?? false;
            user = FirebaseAuth.instance.currentUser;
          });
        });
      else
        Navigator.push<bool>(context, MaterialPageRoute<bool>(builder: (context) => LoginActivity())).then((result) {
          setState(() {
            loginCheck = result ?? false;
            user = FirebaseAuth.instance.currentUser;
          });
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    if (isInitial) {
      isInitial = false;

      str = Str();

      Firebase.initializeApp().then((_) {
        EREToast(str.duringAutoLogin, context, false);

        user = FirebaseAuth.instance.currentUser;
        loginCheck = user != null;

        if (loginCheck)
          EREToast(str.loginSuccess, context, false);
        else
          EREToast(str.autoLoginError, context, false);

        SharedPreferences.getInstance().then((pref) {
          lang = pref.getString('lang') ?? '한국어';
        });

        setState(() {});
      });
    }

    str.lang = lang;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                child: DropdownButton<String>(
                  value: lang,
                  style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.04),
                  dropdownColor: ERE_GREY,
                  underline: Container(
                    color: ERE_GREY,
                  ),
                  onChanged: (newValue) {
                    SharedPreferences.getInstance().then((pref) {
                      pref.setString('lang', newValue);
                    });
                    setState(() {
                      lang = newValue;
                    });
                  },
                  items: ['한국어', 'English']
                      .map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(height * 0.04),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: ButtonTheme(
                      minWidth: width * 0.8,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: EREButton(
                        text: str.creditsChecklist,
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CreditMainActivity(storage: CreditStorage())));
                        },
                        width: width,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(height * 0.04),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: ButtonTheme(
                      minWidth: width * 0.8,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: EREButton(
                        text: str.lectureBookLoan,
                        onPressed: () {
                          _move(LectureBookActivity());
                        },
                        width: width,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(height * 0.04),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: ButtonTheme(
                      minWidth: width * 0.8,
                      height: height * 0.05,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: EREButton(
                        text: str.ERELibrary,
                        onPressed: () {
                          _move(LibraryActivity());
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
                        child: Text(
                          "${str.loginEmail} : ${user.email}",
                          style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.04),
                        ),
                      )
                    : Container(),
                loginCheck
                    ? Padding(
                        padding: EdgeInsets.all(height * 0.02),
                      )
                    : Container(),
                loginCheck
                    ? Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          child: Text(
                            str.logout,
                            style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.04),
                          ),
                          onPressed: () async {
                            await ui.FirebaseAuthUi.instance().logout();
                            setState(() {
                              loginCheck = false;
                              EREToast(str.logoutSuccess, context, false);
                            });
                          },
                        ),
                      )
                    : Container(),
                loginCheck
                    ? Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          child: Text(
                            str.editPersonalData,
                            style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.04),
                          ),
                          onPressed: () async {
                            final reference = FirebaseDatabase.instance.reference().child('Student').child(user.uid);
                            String curName = (await reference.child('name').once()).value ?? '';
                            String curSNum = (await reference.child('sNum').once()).value ?? '';
                            String curPNum = (await reference.child('pNum').once()).value ?? '';

                            showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                      title: Text(
                                        str.editPersonalData,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(str.editPersonalDataDetail),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: width * 0.25,
                                                height: height * 0.034,
                                                child: Text(
                                                  str.name,
                                                  style: TextStyle(fontSize: width * 0.04),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: width * 0.4,
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                  controller: TextEditingController(text: curName),
                                                  onChanged: (text) => curName = text,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: width * 0.25,
                                                height: height * 0.034,
                                                child: Text(
                                                  str.studentID,
                                                  style: TextStyle(fontSize: width * 0.04),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: width * 0.4,
                                                child: TextField(
                                                  keyboardType: TextInputType.numberWithOptions(signed: true),
                                                  decoration: InputDecoration(border: InputBorder.none),
                                                  controller: TextEditingController(text: curSNum),
                                                  onChanged: (text) => curSNum = text,
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: width * 0.25,
                                                height: height * 0.034,
                                                child: Text(
                                                  str.phoneNumber,
                                                  style: TextStyle(fontSize: width * (str.lang == '한국어' ? 0.04 : 0.03)),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: width * 0.4,
                                                child: TextField(
                                                  keyboardType: TextInputType.numberWithOptions(signed: true),
                                                  decoration: InputDecoration(border: InputBorder.none),
                                                  controller: TextEditingController(text: curPNum),
                                                  onChanged: (text) => curPNum = text,
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      actions: [
                                        FlatButton(
                                          child: Text(str.edit),
                                          onPressed: () {
                                            reference..child('name').set(curName)..child('sNum').set(curSNum)..child('pNum').set(curPNum);
                                            EREToast(str.editSuccess, context, false);
                                            Navigator.pop(context);
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
                        ),
                      )
                    : Container(),
                loginCheck
                    ? Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                          child: Text(
                            str.signOut,
                            style: TextStyle(color: Color(0xaaff2424), fontSize: width * 0.04),
                          ),
                          onPressed: () async {
                            final reference = FirebaseDatabase.instance.reference();
                            final notReturnedBook = (await reference.child('Student').child(user.uid).child('Rental').once()).value != null;

                            if (notReturnedBook)
                              EREToast(
                                  str.lang == '한국어'
                                      ? '에자공 도서관에서 대출 후 미반납 도서가 있습니다. 모든 도서의 반납 절차 후 탈퇴해주세요.'
                                      : 'There are some books not returned to ERE library. Please return all the books and then sign out.',
                                  context,
                                  true);
                            else {
                              loginCheck = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text(str.signOutInfo),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(str.signOutDetail),
                                                Row(
                                                  children: [
                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: width * 0.2,
                                                        height: height * 0.034,
                                                        child: Text('${str.studentID} : ')),
                                                    Container(
                                                        alignment: Alignment.center,
                                                        width: width * 0.4,
                                                        child: TextField(
                                                          keyboardType: TextInputType.numberWithOptions(signed: true),
                                                          decoration: InputDecoration(border: InputBorder.none, hintText: 'XXXX-XXXXX'),
                                                          onChanged: (text) => sNum = text,
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text(str.signOut),
                                                textColor: Color(0xffff2424),
                                                onPressed: () async {
                                                  if (sNum != null) {
                                                    final reference = FirebaseDatabase.instance.reference();
                                                    if (sNum == (await reference.child('Student').child(user.uid).child('sNum').once()).value) {
                                                      reference.child('Student').child(user.uid).remove();

                                                      try {
                                                        await ui.FirebaseAuthUi.instance().launchAuth([AuthProvider.email()]);
                                                        user = FirebaseAuth.instance.currentUser;
                                                        await user.delete();
                                                        EREToast(str.signOutSuccess, context, true);
                                                        Navigator.pop(context, false);
                                                      } catch (e) {
                                                        EREToast(str.signOutFail, context, false);
                                                        print(e);
                                                      }
                                                    } else
                                                      EREToast(str.sNumMatchError, context, false);
                                                  } else
                                                    EREToast(str.sNumMissError, context, false);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text(str.cancel),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              )
                                            ],
                                          )) ??
                                  false;
                              setState(() {});
                            }
                          },
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void EREToast(String msg, BuildContext context, bool isLong) {
  Toast.show(msg, context, backgroundColor: ERE_BLACK, textColor: ERE_YELLOW, gravity: Toast.CENTER, duration: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT);
}
