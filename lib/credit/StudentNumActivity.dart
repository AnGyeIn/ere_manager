import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class StudentNumActivity extends StatefulWidget {
  _StudentNumActivityState createState() => _StudentNumActivityState();
}

class _StudentNumActivityState extends State<StudentNumActivity> {
  String snStr;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  height: height * 0.034,
                  child: Center(
                    child: Text(
                      '${str.studentID} : ',
                      style: TextStyle(
                          color: ERE_YELLOW,
                          fontSize: width * (str.lang == '한국어' ? 0.043 : 0.04)),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.5,
                  child: TextField(
                    cursorColor: ERE_YELLOW,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: str.studentIDHint,
                        hintStyle: TextStyle(
                          color: Color(0x88e4b92a),
                          fontSize: width * (str.lang == '한국어' ? 0.043 : 0.04),
                        )),
                    style:
                        TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                    onChanged: (text) => snStr = text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.0075),
                  child: Container(
                    width: width * 0.2,
                    height: height * 0.034,
                    child: EREButton(
                      text: str.ok,
                      onPressed: () {
                        _studentNumSave(context);
                      },
                      width: width,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _studentNumSave(BuildContext context) {
    try {
      Navigator.pop(context, int.parse(snStr));
    } catch (e) {
      EREToast(str.studentIDError, context, false);
      print(e);
    }
  }
}
