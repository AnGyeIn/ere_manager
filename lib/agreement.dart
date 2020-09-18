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
                str.agreementInfo,
                textAlign: TextAlign.center,
                style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.05),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.0036),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Text(
                str.lang == '한국어'
                    ? '앱 기능을 위해 다음 각 항목의 개인정보를 수집합니다. 해당 기능 사용이 필요하지 않은 경우 회원퇴를 통해 개인정보를 삭제할 수 있습니다.\n\n'
                        '-성명 : 수업 교재 대여 목록 및 에자공 도서관 도서 구비 신청 목록에 회원 정보 게시를 위함.\n'
                        '-학번 : 회원 정보 구분을 위함.\n'
                        '-연락처 : 수업 교재 대여 승인 시 제공자와 신청자 연결 및 에자공 도서관 연체 대출자에게 관리자가 연락을 취하기 위함.\n'
                        '상기의 개인정보는 ERE 매니저 앱 기능 사용 외의 목적으로 사용되지 않을 것을 약속드립니다.\n'
                        '개인정보 제공에 동의하신다면 계속 진행해주세요.'
                    : "We collect your personal information below to provide services of the application. If you don't need any more services, you can delete all of your personal information by signing out.\n\n"
                        '-Name : To post your name with the textbook you registered on the textbook loan list and the book request for ERE library\n'
                        '-Student ID : To identify users\n'
                        '-Phone number : To connect the owner and receiver in textbook loan and for the administrator of ERE library to get in contact with the borrower whose rental is overdue.\n'
                        'The information above will not used for any other purpose than providing the services of ERE manager application.\n'
                        'If you agree, please continue.',
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
                    str.agreementCheck,
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
                  text: str.continueStr,
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
                  text: str.cancel,
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
