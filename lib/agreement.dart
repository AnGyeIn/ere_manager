import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class AgreementActivity extends StatefulWidget {
  _AgreementActivityState createState() => _AgreementActivityState();
}

class _AgreementActivityState extends State<AgreementActivity> {
  bool doesAgree = false;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: ERE_GREY,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                '개인정보 수집 동의',
                style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.05),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.0036),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Text(
                '앱 기능을 위해 다음 각 항목의 개인정보를 수집합니다. 해당 기능 사용이 필요하지 않은 경우 학생회로 연락주시면 수집된 개인정보를 파기해드립니다.\n\n'
                '-성명 : 수업 교재 대여 목록에 회원 정보 게시를 위함.\n'
                '-학번 : 회원 정보 구분을 위함.\n'
                '-연락처 : 수업 교재 대여 승인 시 제공자와 신청자 연결을 위함.\n'
                '상기의 개인정보는 ERE 매니저 앱 기능 사용 외의 목적으로 사용되지 않을 것을 약속드립니다.\n' //todo: 앱 명 바뀌면 수정
                '개인정보 제공에 동의하신다면 계속 진행해주세요.',
                style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.04),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: doesAgree,
                  onChanged: (_) {
                    setState(() {
                      doesAgree = !doesAgree;
                    });
                  },
                  checkColor: ERE_YELLOW,
                  activeColor: ERE_BLACK,
                ),
                Expanded(
                  child: Text(
                    '상기 내용을 확인했으며 개인정보 제공에 동의합니다.',
                    style:
                        TextStyle(color: ERE_YELLOW, fontSize: width * 0.037),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EREButton(
                  text: '계속',
                  onPressed: doesAgree
                      ? () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('doesAgree', doesAgree);
                          Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute<bool>(
                                      builder: (context) => LoginActivity()))
                              .then((result) {
                            Navigator.pop(context, result);
                          });
                        }
                      : null,
                  width: width,
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.1),
                ),
                EREButton(
                  text: '취소',
                  onPressed: () => Navigator.pop(context),
                  width: width,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
