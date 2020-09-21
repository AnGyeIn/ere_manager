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
                  width: width * 0.25,
                  height: height * 0.034,
                  child: Text(
                    str.studentID,
                    style: TextStyle(color: ERE_YELLOW, fontSize: width * (str.lang == '한국어' ? 0.043 : 0.03)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: width * 0.4,
                  child: TextField(
                    cursorColor: ERE_YELLOW,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(border: InputBorder.none, hintText: 'XXXX-XXXXX', hintStyle: TextStyle(color: Color(0x88e4b92a))),
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
                  width: width * 0.25,
                  height: height * 0.034,
                  child: Text(
                    str.phoneNumber,
                    style: TextStyle(color: ERE_YELLOW, fontSize: width * (str.lang == '한국어' ? 0.043 : 0.03)),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: width * 0.4,
                  child: TextField(
                    cursorColor: ERE_YELLOW,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(border: InputBorder.none, hintText: 'XXX-XXXX-XXXX', hintStyle: TextStyle(color: Color(0x88e4b92a))),
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
              text: str.login,
              onPressed: () {
                ui.FirebaseAuthUi.instance().launchAuth([AuthProvider.email()]).then((_) async {
                  final user = FirebaseAuth.instance.currentUser;

                  try {
                    final reference = FirebaseDatabase.instance.reference().child('Student').child(user.uid);
                    reference..child('sNum').set(sNum)..child('pNum').set(pNum)..child('name').set(user.displayName);

                    prefs..setString('sNum', sNum)..setString('pNum', pNum);
                    EREToast(str.loginSuccess, context, false);
                    Navigator.pop(context, true);
                  } catch (e) {
                    EREToast(str.loginFail, context, true);
                    print(e);
                  }
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
