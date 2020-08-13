import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_ui/firebase_auth_ui.dart' as ui;
import 'package:firebase_auth_ui/providers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginActivity extends StatefulWidget {
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  String sNum;
  String pNum;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      prefs = value;
      sNum = prefs.getString('sNum') ?? '';
      pNum = prefs.getString('pNum') ?? '';
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: width * 0.15,
                  height: height * 0.034,
                  child: Text(
                    '학번',
                    style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: width * 0.4,
                  child: TextField(
                    cursorColor: ERE_YELLOW,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'XXXX-XXXXX',
                        hintStyle: TextStyle(color: Color(0x88e4b92a))),
                    style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                    controller: TextEditingController(text: sNum),
                    onChanged: (text) => sNum = text,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: width * 0.15,
                  height: height * 0.034,
                  child: Text(
                    '연락처',
                    style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: width * 0.4,
                  child: TextField(
                    cursorColor: ERE_YELLOW,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'XXX-XXXX-XXXX',
                        hintStyle: TextStyle(color: Color(0x88e4b92a))),
                    style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                    controller: TextEditingController(text: pNum),
                    onChanged: (text) => pNum = text,
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.15),
            ),
            EREButton(
              text: '로그인/회원가입',
              onPressed: () {
                ui.FirebaseAuthUi.instance()
                    .launchAuth([AuthProvider.email()]).then((_) async {
                  final user = await FirebaseAuth.instance.currentUser();

                  final signinTransaction = await FirebaseDatabase.instance.reference().child('Student').child(user.uid).runTransaction((mutableData) async {
                    mutableData.value = <String, dynamic>{
                      'sNum': sNum,
                      'pNum': pNum,
                      'name': user.displayName
                    };
                    return mutableData;
                  });

                  if(signinTransaction.committed) {
                    prefs..setString('sNum', sNum)
                        ..setString('pNum', pNum);
                    EREToast('로그인되었습니다.', context, false);
                    Navigator.pop(context, true);
                  } else
                    EREToast('로그인 실패: 입력 정보를 확인한 후 다시 시도해주세요.', context, true);
                });
              },
              width: width,
            )
          ],
        ),
      ),
    );
  }
}
