import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/credit/ForLectures/ForLectures.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';

class ForLecActivity extends StatefulWidget {
  final ForLectures forLectures;

  ForLecActivity({this.forLectures});

  _ForLecActivityState createState() => _ForLecActivityState();
}

class _ForLecActivityState extends State<ForLecActivity> {
  String forLectureType = str.major;
  String forLectureName = '';

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
            Padding(
              padding: EdgeInsets.all(width * 0.0075),
              child: Text(
                str.foreignLectureRegulation,
                style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.044),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(width * 0.0075),
                  child: Container(
                    width: width * (str.lang == '한국어' ? 0.15 : 0.23),
                    height: height * 0.045,
                    color: ERE_BLACK,
                    alignment: Alignment(1, 0),
                    child: DropdownButton<String>(
                      value: forLectureType,
                      style:
                          TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                      dropdownColor: ERE_BLACK,
                      underline: Container(
                        color: ERE_BLACK,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          forLectureType = newValue;
                        });
                      },
                      items: [str.major, str.culture]
                          .map<DropdownMenuItem<String>>(
                              (value) => DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  ))
                          .toList(),
                    ),
                  ),
                ),
                Container(
                  width: width * 0.5,
                  child: TextField(
                    cursorColor: ERE_YELLOW,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: str.forLecNameHint,
                        hintStyle: TextStyle(
                            color: Color(0x88e4b92a), fontSize: width * 0.043)),
                    style: TextStyle(color: ERE_YELLOW),
                    onChanged: (text) => forLectureName = text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.0075),
                  child: Container(
                    width: width * 0.2,
                    height: height * 0.045,
                    child: EREButton(
                      text: str.add,
                      onPressed: () {
                        setState(() {
                          _addForLecture(context);
                        });
                      },
                      width: width,
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: height * 0.225,
              child: ListView.builder(
                itemCount: widget.forLectures.num,
                itemBuilder: (context, index) => Row(
                  children: [
                    Text(
                      '[${str.translate(widget.forLectures.types[index])}]${widget.forLectures.names[index]}',
                      style:
                          TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                    ),
                    Container(
                      width: width * (str.lang == '한국어' ? 0.16 : 0.21),
                      height: height * 0.045,
                      child: EREButton(
                        text: str.delete,
                        onPressed: () {
                          setState(() {
                            widget.forLectures.removeForLecture(index);
                          });
                        },
                        width: width,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: width * 0.2,
              height: height * 0.045,
              child: EREButton(
                text: str.close,
                onPressed: () => Navigator.pop(context, widget.forLectures),
                width: width,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addForLecture(BuildContext context) {
    if (forLectureType.isNotEmpty && forLectureName.isNotEmpty) {
      widget.forLectures.addForLecture(forLectureType, forLectureName);
      EREToast(str.addForLecSuccess, context, false);
    } else
      EREToast(str.addForLecFail, context, false);
  }
}
