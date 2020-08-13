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
  String forLectureType = '전공';
  String forLectureName = '';

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double heigth = screenSize.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(width * 0.0075),
              child: Text(
                '1과목 이상의 전공을 포함해 3과목 이상 외국어진행강좌(대학영어 제외) 수강',
                style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.044),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(width * 0.0075),
                  child: Container(
                    width: width * 0.15,
                    height: heigth * 0.045,
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
                      items: ['전공', '교양']
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
                        hintText: '과목명을 입력하세요.',
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
                    height: heigth * 0.045,
                    child: EREButton(
                      text: '추가',
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
              height: heigth * 0.225,
              child: ListView.builder(
                itemCount: widget.forLectures.num,
                itemBuilder: (context, index) => Row(
                  children: [
                    Text(
                      '[${widget.forLectures.types[index]}]${widget.forLectures.names[index]}',
                      style:
                          TextStyle(color: ERE_YELLOW, fontSize: width * 0.043),
                    ),
                    Container(
                      width: width * 0.2,
                      height: heigth * 0.045,
                      child: EREButton(
                        text: '삭제',
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
              height: heigth * 0.045,
              child: EREButton(
                text: '닫기',
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
      EREToast('외국어진행강좌가 추가되었습니다.', context, false);
    } else
      EREToast('과목의 종류와 과목명을 입력해주세요.', context, false);
  }
}
