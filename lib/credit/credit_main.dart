import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ere_manager/EREButton.dart';
import 'package:ere_manager/credit/Data.dart';
import 'package:ere_manager/credit/MainAdapter.dart';
import 'package:ere_manager/login.dart';
import 'package:ere_manager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../agreement.dart';
import 'CreditManager.dart';
import 'ForLectures/ForLecActivity.dart';
import 'ForLectures/ForLectures.dart';
import 'StudentNumActivity.dart';
import 'package:firebase_database/firebase_database.dart';

int totalCredits = 0;
int minTotalCredits = 0;

MainAdapter adapter = MainAdapter();

int studentNum = -1;

ForLectures forLectures = ForLectures();
String progressingMajor = EREOnly;
bool isLifeChecked = false;

class CreditStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/credit');
  }

  readData() async {
    try {
      final file = await _localFile;
      final data = await file.readAsString();
      final jsons = jsonDecode(data) as Map<String, dynamic>;

      culture = instantiation(jsons['culTot'] as Map<String, dynamic>);
      major = instantiation(jsons['majTot'] as Map<String, dynamic>);
      normal = instantiation(jsons['norTot'] as Map<String, dynamic>);

      forLectures = ForLectures.fromJson(jsonDecode(jsons['forLectures']) as Map<String, dynamic>);
      progressingMajor = jsons['progressingMajor'];
      isLifeChecked = jsons['isLifeChecked'] as bool;
      studentNum = jsons['studentNum'] as int;
    } catch (e) {
      print(e);
    }
  }

  Future<File> writeData(Map<String, dynamic> data) async {
    final file = await _localFile;
    return file.writeAsString(jsonEncode(data));
  }
}

class CreditMainActivity extends StatefulWidget {
  final CreditStorage storage;

  CreditMainActivity({this.storage});

  _CreditMainActivityState createState() => _CreditMainActivityState();
}

class _CreditMainActivityState extends State<CreditMainActivity> {
  User user;

  _downloadData() {
    try {
      FirebaseDatabase.instance.reference().child('credit').child('CreditData').child(user.uid).once().then((snapshot) {
        final jsons = jsonDecode(snapshot.value) as Map<String, dynamic>;
        setState(() {
          culture = instantiation(jsons['culTot'] as Map<String, dynamic>);
          major = instantiation(jsons['majTot'] as Map<String, dynamic>);
          normal = instantiation(jsons['norTot'] as Map<String, dynamic>);

          forLectures = ForLectures.fromJson(jsons['forLectures'] as Map<String, dynamic>);
          progressingMajor = jsons['progressingMajor'];
          isLifeChecked = jsons['isLifeChecked'] as bool;
          studentNum = jsons['studentNum'] as int;

          EREToast(str.downloadSuccess, context, false);
          _setting();
        });
      }).catchError((e) {
        print(e);
        EREToast(str.downloadFail, context, false);
      });
    } catch (e) {
      print(e);
      EREToast(str.downloadFail, context, false);
    }
  }

  _uploadData(Map<String, dynamic> data) async {
    try {
      final transactionResult =
          await FirebaseDatabase.instance.reference().child('credit').child('CreditData').child(user.uid).runTransaction((mutableData) async {
        mutableData.value = jsonEncode(data);
        return mutableData;
      });

      if (transactionResult.committed)
        EREToast(str.uploadSuccess, context, false);
      else {
        EREToast(str.uploadFail, context, false);
        if (transactionResult.error != null) print(transactionResult.error.message);
      }
    } catch (e) {
      EREToast(str.uploadFail, context, false);
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.storage.readData().then((_) {
      setState(() {
        if (studentNum == -1) {
          EREToast(str.loadFail, context, false);
          final year = DateTime.now().year % 100;
          studentNum = year;
          _changeMajorProcess();
          isLifeChecked = false;
        } else {
          EREToast(str.loadSuccess, context, false);
          _setting();
        }
      });
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
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      width: width * 0.21,
                      height: height * (str.lang == '한국어' ? 0.034 : 0.05),
                      child: EREButton(
                        text: str.lang == '한국어' ? '$studentNum학번' : '$studentNum',
                        onPressed: () async {
                          await _changeStudentNumClicked(context);
                          setState(() {});
                        },
                        width: width,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      width: width * 0.69,
                      height: height * (str.lang == '한국어' ? 0.034 : 0.05),
                      child: EREButton(
                        text: str.translate(progressingMajor),
                        onPressed: () async {
                          await _onMultiMajorButton(context);
                          setState(() {});
                        },
                        width: width,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Text(
                      '${str.totalCredits} : $totalCredits/$minTotalCredits',
                      style: TextStyle(color: ERE_YELLOW, fontSize: width * 0.037),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      width: width * 0.19,
                      height: height * 0.034,
                      child: EREButton(
                        text: str.apply,
                        onPressed: () {
                          _apply();
                          setState(() {});
                        },
                        width: width,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      width: width * 0.19,
                      height: height * 0.034,
                      child: EREButton(
                        text: str.save,
                        onPressed: () {
                          _save(context, widget.storage);
                        },
                        width: width,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      width: width * 0.19,
                      height: height * 0.034,
                      child: EREButton(
                        text: str.close,
                        onPressed: () {
                          _save(context, widget.storage);
                          Navigator.pop(context);
                        },
                        width: width,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      height: height * (str.lang == '한국어' ? 0.045 : 0.06),
                      child: EREButton(
                        text: str.foreignLectureCheck,
                        onPressed: () {
                          _openForLecLayout(context);
                        },
                        width: width,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.0075),
                    child: Container(
                      height: height * (str.lang == '한국어' ? 0.045 : 0.06),
                      child: EREButton(
                        text: str.serverBackup,
                        onPressed: () async {
                          user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text(str.serverBackupDetail),
                                      actions: [
                                        FlatButton(
                                          child: Text(str.uploadBackup),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            EREToast(str.duringUpload, context, true);

                                            final culTot = _totalization(culture);
                                            final majTot = _totalization(major);
                                            final norTot = _totalization(normal);

                                            final data = <String, dynamic>{
                                              'culTot': culTot,
                                              'majTot': majTot,
                                              'norTot': norTot,
                                              'forLectures': forLectures,
                                              'progressingMajor': progressingMajor,
                                              'isLifeChecked': isLifeChecked,
                                              'studentNum': studentNum
                                            };

                                            _uploadData(data);
                                          },
                                        ),
                                        FlatButton(
                                          child: Text(str.downloadBackup),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            EREToast(str.duringDownload, context, true);

                                            _downloadData();
                                          },
                                        )
                                      ],
                                    ));
                          } else {
                            final prefs = await SharedPreferences.getInstance();
                            if (prefs.getBool('doesAgree') != true)
                              return Navigator.push(context, MaterialPageRoute(builder: (context) => AgreementActivity()));
                            else
                              return Navigator.push(context, MaterialPageRoute(builder: (context) => LoginActivity()));
                          }
                        },
                        width: width,
                      ),
                    ),
                  )
                ],
              ),
              studentNum >= 16
                  ? Row(
                      children: [
                        Checkbox(
                          value: isLifeChecked,
                          onChanged: (_) {
                            setState(() {
                              isLifeChecked = !isLifeChecked;
                            });
                          },
                          checkColor: ERE_YELLOW,
                          activeColor: ERE_BLACK,
                        ),
                        Expanded(
                          child: Text(
                            str.life,
                            style: TextStyle(color: ERE_YELLOW, fontSize: width * (str.lang == '한국어' ? 0.037 : 0.033)),
                          ),
                        )
                      ],
                    )
                  : Container(),
              Expanded(
                child: ListView.builder(
                  itemCount: adapter.getSize(),
                  itemBuilder: (context, index) => adapter.getTile(index, setState, width, height),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: ERE_YELLOW,
                  ),
                  onPressed: () => _onAdviceButtonClicked(context),
                ),
              )
            ],
          )),
    );
  }
}

List<dynamic> parseCreditPiece(dynamic piece) {
  switch (piece.runtimeType) {
    case String:
      return jsonDecode(piece);

    case List:
      return piece;

    default:
      return piece;
  }
}

CreditManager instantiation(Map<String, dynamic> jsons) {
  final names = parseCreditPiece(jsons['names']).map((e) => e as String).toList();
  final creditss = parseCreditPiece(jsons['creditss']).map((e) => e as int).toList();
  final minCredits = parseCreditPiece(jsons['minCredits']).map((e) => e as int ?? null).toList();
  final codes = parseCreditPiece(jsons['codes']).map((e) => e as int).toList();
  final underManagers = parseCreditPiece(jsons['underManagers']).map((e) => parseCreditPiece(e).map((f) => f as int).toList()).toList();
  final credits = parseCreditPiece(jsons['credits']).map((e) => e as int ?? null).toList();
  final upperManagers = parseCreditPiece(jsons['upperManagers']).map((e) => e as int ?? null).toList();
  final nums = parseCreditPiece(jsons['nums']).map((e) => e as int ?? null).toList();

  final totNum = names.length;
  final tot = List<CreditManager>(totNum);
  for (int idx = 0; idx < totNum; idx++) {
    if (names[idx] != null && names[idx].contains('n ')) names[idx] = names[idx].replaceFirst('n ', '\n ');
    tot[idx] = CreditManager(codes[idx], names[idx], minCredits[idx], credits[idx], null, nums[idx])..credits = creditss[idx];
  }

  for (int idx = 0; idx < totNum; idx++) {
    final curManager = tot[idx];
    for (int jdx in underManagers[idx]) curManager.addUnderManager(tot[jdx]);
    final udx = upperManagers[idx];
    if (udx != null) curManager.upperManager = tot[udx];
  }

  return tot[0];
}

void _setting() {
  adapter.clear();
  switch (progressingMajor) {
    case EREOnly:
    case EREnOther:
      adapter..setCreditManager(culture)..setCreditManager(major)..setCreditManager(normal);
      minTotalCredits = 130;
      break;
    case OthernERE:
      adapter.setCreditManager(major);
      minTotalCredits = 39;
      break;
    case OthernSubERE:
      adapter.setCreditManager(major);
      minTotalCredits = 21;
      break;
  }

  _apply();
}

void _apply() {
  switch (progressingMajor) {
    case EREOnly:
    case EREnOther:
      culture.sumCredits();
      major.sumCredits();
      normal.sumCredits();
      var culCredits = max(culture.credits, culture.minCredits);
      var majCredits = max(major.credits, major.minCredits);
      var norCredits = minTotalCredits - culCredits - majCredits;
      normal.minCredits = max(norCredits, 0);
      totalCredits = culture.credits + major.credits + normal.credits;
      break;
    case OthernERE:
    case OthernSubERE:
      major.sumCredits();
      totalCredits = major.credits;
      break;
  }
}

void _changeMajorProcess() {
  _clearAll();
  _initialization(studentNum);

  if (studentNum <= 15) {
    //15학번 이전
    switch (progressingMajor) {
      case EREOnly:
        break;
      case EREnOther:
        major = CreditManager(LECTURE_TYPE, '전공', 42)..addUnderManagerAll([major_necessary, major_optOrNec, major_optNec, major_other]);

        major_optOrNec.addUnderManager(majorOptOrNecFree);

        if (studentNum <= 13) //13학번 이전
          normal.minCredits = 41;
        else if (studentNum <= 15) //14, 15학번
          normal.minCredits = 48;
        break;
      case OthernERE:
        major = CreditManager(LECTURE_TYPE, '전공', 39)..addUnderManagerAll([major_necessary, major_optOrNec, major_optNec]);

        major_optOrNec.addUnderManager(majorOptOrNecFree);

        culture = null;
        normal = null;
        break;
    }
  } else if (studentNum >= 16) {
    //16학번 이후
    switch (progressingMajor) {
      case EREOnly:
        break;
      case EREnOther:
        major = CreditManager(LECTURE_TYPE, '전공', 42)..addUnderManagerAll([major_necessary, major_optional, major_other]);

        major_optional.minCredits = 20;

        normal.minCredits = 48;
        break;
      case OthernERE:
        major = CreditManager(LECTURE_TYPE, '전공', 39)..addUnderManagerAll([major_necessary, major_optional]);

        major_optional.minCredits = 20;

        culture = null;
        normal = null;
        break;
      case OthernSubERE:
        major_necessary = CreditManager(LECTURE_FIELD, '전공필수', 15)..addUnderManagerAll([eneEcoTecAdm, earPhyEng, resProEng, stoDynExp, oilGasEngExp]);

        major = CreditManager(LECTURE_TYPE, '전공', 21)..addUnderManagerAll([major_necessary, major_optional]);

        major_optional.minCredits = 6;

        culture = null;
        normal = null;
        break;
    }
  }

  _setting();
}

void _clearAll() {
  //LectureType
  culture = CreditManager(LECTURE_TYPE, '교양', 40);
  major = CreditManager(LECTURE_TYPE, '전공', 62);
  normal = CreditManager(LECTURE_TYPE, '그 외', 28);

//LectureField
  culture_basic = CreditManager(LECTURE_FIELD, '학문의 기초', 34);
  keyCulture = CreditManager(LECTURE_FIELD, '핵심교양', 9);
  culture_world = CreditManager(LECTURE_FIELD, '학문의 세계(2개 영역 이상)', 6);
  culture_world_sin20 = CreditManager(LECTURE_FIELD, '학문의 세계(3개 영역 이상)', 12); //20학번 이후
  culture_engineering = CreditManager(LECTURE_FIELD, '공대 사회/창의성', 6);
  major_necessary = CreditManager(LECTURE_FIELD, '전공필수', 19);
  major_optNec = CreditManager(LECTURE_FIELD, '전공선택필수', 9);
  major_optional = CreditManager(LECTURE_FIELD, '전공선택', 40);
  major_optOrNec = CreditManager(LECTURE_FIELD, '전공선택, 전공선택필수', 3); //15학번 이전 복수/부전공을 위한 항목
  major_other = CreditManager(LECTURE_FIELD, '공대 타학과개론', 3);

//LectureGroup
  thiExp = CreditManager(LECTURE_GROUP, '사고와 표현', 3);
  foreign = CreditManager(LECTURE_GROUP, '외국어 2개 교과목\n    (TEPS 900점 이하 영어 1과목 필수)', 4);
  numAnaInf = CreditManager(LECTURE_GROUP, '수량적 분석과 추론', 12);
  sciThiExp = CreditManager(LECTURE_GROUP, '과학적 사고와 실험', 12);
  comInfApp = CreditManager(LECTURE_GROUP, '컴퓨터와 정보 활용', 3);
  society = CreditManager(LECTURE_GROUP, '사회성 교과목군 or 인간과 사회 영역', 3);
  creativity = CreditManager(LECTURE_GROUP, '창의성 교과목군 or 문화와 예술 영역', 3);

//LectureWorld
  litArt = CreditManager(LECTURE_WORLD, '문학과 예술');
  socIde = CreditManager(LECTURE_WORLD, '사회와 이념');
  lenLit = CreditManager(LECTURE_WORLD, '언어와 문학');
  culArt = CreditManager(LECTURE_WORLD, '문화와 예술');
  hisPhi = CreditManager(LECTURE_WORLD, '역사와 철학');
  polEco = CreditManager(LECTURE_WORLD, '정치와 경제');
  humSoc = CreditManager(LECTURE_WORLD, '인간과 사회');

//Lecture
  sciEngWri = CreditManager(LECTURE, '과학과 기술 글쓰기', null, 3);
  korean = CreditManager(LECTURE, '대학국어', null, 3);
  colWri1 = CreditManager(LECTURE, '대학 글쓰기 1', null, 2);
  colWri2 = CreditManager(LECTURE, '대학 글쓰기 2: 과학기술 글쓰기', null, 2);
  math1 = CreditManager(LECTURE, '(고급)수학 및 연습 1', null, 3);
  math2 = CreditManager(LECTURE, '(고급)수학 및 연습 2', null, 3);
  mathPra1 = CreditManager(LECTURE, '(고급)수학연습 1', null, 1);
  mathPra2 = CreditManager(LECTURE, '(고급)수학연습 2', null, 1);
  engMat1 = CreditManager(LECTURE, '공학수학 1', null, 3);
  engMat2 = CreditManager(LECTURE, '공학수학 2', null, 3);
  physics1 = CreditManager(LECTURE, '(고급)물리학 1(물리의 기본 1)', null, 3);
  phyExp1 = CreditManager(LECTURE, '물리학실험1', null, 1);
  physics2 = CreditManager(LECTURE, '(고급)물리학 2(물리의 기본 2)', null, 3);
  phyExp2 = CreditManager(LECTURE, '물리학실험 2', null, 1);
  physics = CreditManager(LECTURE, '물리학', null, 3);
  phyExp = CreditManager(LECTURE, '물리학실험', null, 1);
  chemistry1 = CreditManager(LECTURE, '화학 1', null, 3);
  cheExp1 = CreditManager(LECTURE, '화학실험 1', null, 1);
  chemistry2 = CreditManager(LECTURE, '화학 2', null, 3);
  cheExp2 = CreditManager(LECTURE, '화학실험 2', null, 1);
  chemistry = CreditManager(LECTURE, '화학', null, 3);
  cheExp = CreditManager(LECTURE, '화학실험', null, 1);
  biology1 = CreditManager(LECTURE, '생물학 1', null, 3);
  bioExp1 = CreditManager(LECTURE, '생물학실험 1', null, 1);
  biology2 = CreditManager(LECTURE, '생물학 2', null, 3);
  bioExp2 = CreditManager(LECTURE, '생물학실험 2', null, 1);
  biology = CreditManager(LECTURE, '생물학', null, 3);
  bioExp = CreditManager(LECTURE, '생물학실험', null, 1);
  statistics = CreditManager(LECTURE, '통계학', null, 3);
  staExp = CreditManager(LECTURE, '통계학실험', null, 1);
  earSysSci = CreditManager(LECTURE, '지구시스템과학', null, 3);
  earSysSciExp = CreditManager(LECTURE, '지구시스템과학실험', null, 1);
  computer = CreditManager(LECTURE, '컴퓨터의 개념 및 실습', null, 3);
  eneResFut = CreditManager(LECTURE, '에너지자원과미래', null, 2);
  eneUnd = CreditManager(LECTURE, '에너지자원공학의이해', null, 1);
  enePra = CreditManager(LECTURE, '에너지자원공학실습', null, 1);
  advResGeo = CreditManager(LECTURE, '응용자원지질', null, 3);
  eneResFigAna = CreditManager(LECTURE, '에너지자원수치해석', null, 3);
  driEng = CreditManager(LECTURE, '시추공학', null, 3);
  newRenEne = CreditManager(LECTURE, '신재생에너지', null, 3);
  advEarChe = CreditManager(LECTURE, '응용지구화학', null, 3);
  eneEcoEng = CreditManager(LECTURE, '에너지환경공학', null, 3);
  eneResDyn = CreditManager(LECTURE, '에너지자원역학', null, 3);
  eneMat = CreditManager(LECTURE, '에너지자원재료역학', null, 3);
  eneEcoTecAdm = CreditManager(LECTURE, '에너지환경기술경영', null, 3);
  earPhyEng = CreditManager(LECTURE, '지구물리공학', null, 3);
  eneThe = CreditManager(LECTURE, '에너지자원열역학', null, 3);
  eneFlu = CreditManager(LECTURE, '에너지자원유체역학', null, 3);
  eneEar = CreditManager(LECTURE, '에너지자원지구화학', null, 3);
  elaExp = CreditManager(LECTURE, '탄성파탐사', null, 3);
  stoDynExp = CreditManager(LECTURE, '암석역학및실험', null, 3);
  oilGasEngExp = CreditManager(LECTURE, '석유가스공학및실험', null, 3);
  resProEng = CreditManager(LECTURE, '자원처리공학', null, 3);
  resEngPra = CreditManager(LECTURE, '자원공학실습', null, 1);
  resEngDes = CreditManager(LECTURE, '자원공학설계', null, 1);

//FreeLecture
  foreignFree = CreditManager(FREE_LECTURE, null, null, 0, foreign, 0);
  litArtFree = CreditManager(FREE_LECTURE, null, null, 0, litArt, 0);
  socIdeFree = CreditManager(FREE_LECTURE, null, null, 0, socIde, 0);
  lenLitFree = CreditManager(FREE_LECTURE, null, null, 0, lenLit, 0);
  culArtFree = CreditManager(FREE_LECTURE, null, null, 0, culArt, 0);
  hisPhiFree = CreditManager(FREE_LECTURE, null, null, 0, hisPhi, 0);
  polEcoFree = CreditManager(FREE_LECTURE, null, null, 0, polEco, 0);
  humSocFree = CreditManager(FREE_LECTURE, null, null, 0, humSoc, 0);
  socFree = CreditManager(FREE_LECTURE, null, null, 0, society, 0);
  creFree = CreditManager(FREE_LECTURE, null, null, 0, creativity, 0);
  optFree = CreditManager(FREE_LECTURE, null, null, 0, major_optional, 0);
  othFree = CreditManager(FREE_LECTURE, null, null, 0, major_other, 0);
  norFree = CreditManager(FREE_LECTURE, null, null, 0, normal, 0);
  majorOptOrNecFree = CreditManager(FREE_LECTURE, null, null, 0, major_optOrNec, 0);
}

void _initialization(int studentNum) {
  if (studentNum <= 13) {
    //13학번 이전
    culture
      ..minCredits = 47
      ..addUnderManagerAll([culture_basic, keyCulture, culture_engineering]);

    culture_basic
      ..minCredits = 38
      ..addUnderManagerAll([thiExp, foreign, numAnaInf, sciThiExp, comInfApp]);

    thiExp.addUnderManager(korean);

    foreign
      ..name = '대학영어 또는 고급영어'
      ..minCredits = 2
      ..addUnderManager(foreignFree);

    numAnaInf.addUnderManagerAll([math1, math2, engMat1, engMat2]);

    sciThiExp
      ..minCredits = 16
      ..addUnderManagerAll([
        physics1,
        phyExp1,
        physics2,
        phyExp2,
        physics,
        phyExp,
        chemistry1,
        cheExp1,
        chemistry2,
        cheExp2,
        chemistry,
        cheExp,
        biology1,
        bioExp1,
        biology2,
        bioExp2,
        biology,
        bioExp,
        statistics,
        staExp,
        earSysSci,
        earSysSciExp
      ]);

    chemistry1.name = '화학1(화학의 기본1)';
    chemistry2.name = '화학2(화학의 기본2)';

    comInfApp.addUnderManager(computer);

    keyCulture.addUnderManagerAll([litArt, hisPhi, socIde]);

    litArt.addUnderManager(litArtFree);

    hisPhi.addUnderManager(hisPhiFree);

    socIde.addUnderManager(socIdeFree);

    culture_engineering.addUnderManagerAll([society, creativity]);

    society.addUnderManager(socFree);

    creativity.addUnderManager(creFree);

    major.addUnderManagerAll([major_necessary, major_optNec, major_optional, major_other]);

    major_necessary
      ..minCredits = 27
      ..addUnderManagerAll([eneResFut, eneResDyn, advResGeo, eneEcoTecAdm, earPhyEng, stoDynExp, oilGasEngExp, resEngPra, resProEng, eneResFigAna]);

    major_optNec.addUnderManagerAll([driEng, newRenEne, advEarChe, eneEcoEng]);

    major_optional
      ..minCredits = 23
      ..addUnderManager(optFree);

    major_other.addUnderManager(othFree);

    normal
      ..minCredits = 21
      ..addUnderManager(norFree);
  } else if (studentNum <= 15) {
    //14, 15학번
    culture.addUnderManagerAll([culture_basic, culture_world, culture_engineering]);

    culture_basic.addUnderManagerAll([thiExp, foreign, numAnaInf, sciThiExp, comInfApp]);

    thiExp.addUnderManager(sciEngWri);

    foreign.addUnderManager(foreignFree);

    numAnaInf.addUnderManagerAll([math1, math2, engMat1, engMat2]);

    sciThiExp.addUnderManagerAll(
        [physics1, phyExp1, physics2, phyExp2, physics, phyExp, chemistry1, cheExp1, chemistry2, cheExp2, chemistry, cheExp, earSysSci, earSysSci]);

    comInfApp.addUnderManager(computer);

    culture_world.addUnderManagerAll([lenLit, culArt, hisPhi, polEco, humSoc]);

    lenLit.addUnderManager(lenLitFree);

    culArt.addUnderManager(culArtFree);

    hisPhi.addUnderManager(hisPhiFree);

    polEco.addUnderManager(polEcoFree);

    humSoc.addUnderManager(humSocFree);

    culture_engineering.addUnderManagerAll([society, creativity]);

    society.addUnderManager(socFree);

    creativity.addUnderManager(creFree);

    major.addUnderManagerAll([major_necessary, major_optNec, major_optional, major_other]);

    major_necessary
      ..minCredits = 27
      ..addUnderManagerAll([eneResFut, eneResDyn, advResGeo, eneEcoTecAdm, earPhyEng, stoDynExp, oilGasEngExp, resEngPra, resProEng, eneResFigAna]);

    major_optNec.addUnderManagerAll([driEng, newRenEne, advEarChe, eneEcoEng]);

    major_optional
      ..minCredits = 23
      ..addUnderManager(optFree);

    major_other.addUnderManager(othFree);

    normal.addUnderManager(norFree);
  } else if (studentNum <= 17) {
    //16, 17학번
    culture.addUnderManagerAll([culture_basic, culture_world, culture_engineering]);

    culture_basic.addUnderManagerAll([thiExp, foreign, numAnaInf, sciThiExp, comInfApp]);

    thiExp.addUnderManager(sciEngWri);

    foreign.addUnderManager(foreignFree);

    numAnaInf.addUnderManagerAll([math1, math2, engMat1, engMat2]);

    sciThiExp.addUnderManagerAll(
        [physics1, phyExp1, physics2, phyExp2, physics, phyExp, chemistry1, cheExp1, chemistry2, cheExp2, chemistry, cheExp, earSysSci, earSysSciExp]);

    comInfApp.addUnderManager(computer);

    culture_world.addUnderManagerAll([lenLit, culArt, hisPhi, polEco, humSoc]);

    lenLit.addUnderManager(lenLitFree);

    culArt.addUnderManager(culArtFree);

    hisPhi.addUnderManager(hisPhiFree);

    polEco.addUnderManager(polEcoFree);

    humSoc.addUnderManager(humSocFree);

    culture_engineering.addUnderManagerAll([society, creativity]);

    society.addUnderManager(socFree);

    creativity.addUnderManager(creFree);

    major.addUnderManagerAll([major_necessary, major_optional, major_other]);

    major_necessary.addUnderManagerAll([eneResDyn, eneEcoTecAdm, earPhyEng, stoDynExp, oilGasEngExp, resProEng, resEngPra]);

    major_optional.addUnderManager(optFree);

    major_other.addUnderManager(othFree);

    normal.addUnderManager(norFree);
  } else if (studentNum == 18) {
    //18학번
    culture.addUnderManagerAll([culture_basic, culture_world, culture_engineering]);

    culture_basic.addUnderManagerAll([thiExp, foreign, numAnaInf, sciThiExp, comInfApp]);

    thiExp.addUnderManager(sciEngWri);

    foreign.addUnderManager(foreignFree);

    numAnaInf.addUnderManagerAll([math1, math2, engMat1, engMat2]);

    sciThiExp.addUnderManagerAll(
        [physics1, phyExp1, physics2, phyExp2, physics, phyExp, chemistry1, cheExp1, chemistry2, cheExp2, chemistry, cheExp, earSysSci, earSysSciExp]);

    comInfApp.addUnderManager(computer);

    culture_world.addUnderManagerAll([lenLit, culArt, hisPhi, polEco, humSoc]);

    lenLit.addUnderManager(lenLitFree);

    culArt.addUnderManager(culArtFree);

    hisPhi.addUnderManager(hisPhiFree);

    polEco.addUnderManager(polEcoFree);

    humSoc.addUnderManager(humSocFree);

    culture_engineering.addUnderManagerAll([society, creativity]);

    society.addUnderManager(socFree);

    creativity.addUnderManager(creFree);

    major.addUnderManagerAll([major_necessary, major_optional, major_other]);

    major_necessary.addUnderManagerAll([eneResDyn, eneEcoTecAdm, earPhyEng, stoDynExp, oilGasEngExp, resProEng, resEngPra]);

    major_optional.addUnderManager(optFree);

    major_other.addUnderManager(othFree);

    normal.addUnderManager(norFree);
  } else if (studentNum == 19) {
    //19학번
    culture
      ..minCredits = 41
      ..addUnderManagerAll([culture_basic, culture_world, culture_engineering]);

    culture_basic
      ..minCredits = 35
      ..addUnderManagerAll([thiExp, foreign, numAnaInf, sciThiExp, comInfApp]);

    thiExp
      ..minCredits = 4
      ..addUnderManagerAll([colWri1, colWri2]);

    foreign
      ..name = '외국어 2개 교과목\n    (TEPS 900점(New TEPS 525점) 이하 영어 1과목 필수)'
      ..addUnderManager(foreignFree);

    numAnaInf.addUnderManagerAll([math1, mathPra1, math2, mathPra2, engMat1, engMat2]);

    math1
      ..name = '(고급)수학 1'
      ..credit = 2;
    math2
      ..name = '(고급)수학 2'
      ..credit = 2;

    sciThiExp.addUnderManagerAll(
        [physics1, phyExp1, physics2, phyExp2, physics, phyExp, chemistry1, cheExp1, chemistry2, cheExp2, chemistry, cheExp, earSysSci, earSysSciExp]);

    comInfApp.addUnderManager(computer);

    culture_world.addUnderManagerAll([lenLit, culArt, hisPhi, polEco, humSoc]);

    lenLit.addUnderManager(lenLitFree);

    culArt.addUnderManager(culArtFree);

    hisPhi.addUnderManager(hisPhiFree);

    polEco.addUnderManager(polEcoFree);

    humSoc.addUnderManager(humSocFree);

    culture_engineering.addUnderManagerAll([society, creativity]);

    society.addUnderManager(socFree);

    creativity.addUnderManager(creFree);

    major.addUnderManagerAll([major_necessary, major_optional, major_other]);

    major_necessary
      ..minCredits = 21
      ..addUnderManagerAll([eneUnd, enePra, eneResDyn, eneEcoTecAdm, earPhyEng, stoDynExp, oilGasEngExp, resProEng, resEngDes]);

    major_optional
      ..minCredits = 38
      ..addUnderManager(optFree);

    normal
      ..minCredits = 27
      ..addUnderManager(norFree);
  } else if (studentNum >= 20) {
    //20학번 이후
    culture
      ..minCredits = 47
      ..addUnderManagerAll([culture_basic, culture_world_sin20]);

    culture_basic
      ..minCredits = 35
      ..addUnderManagerAll([thiExp, foreign, numAnaInf, sciThiExp, comInfApp]);

    thiExp
      ..minCredits = 4
      ..addUnderManagerAll([colWri1, colWri2]);

    foreign
      ..name = '외국어 2개 교과목\n    (TEPS 900점(New TEPS 525점) 이하 영어 1과목 필수)'
      ..addUnderManager(foreignFree);

    numAnaInf.addUnderManagerAll([math1, mathPra1, math2, mathPra2, engMat1, engMat2]);

    math1
      ..name = '(고급)수학 1'
      ..credit = 2;
    math2
      ..name = '(고급)수학 2'
      ..credit = 2;

    sciThiExp.addUnderManagerAll(
        [physics1, phyExp1, physics2, phyExp2, physics, phyExp, chemistry1, cheExp1, chemistry2, cheExp2, chemistry, cheExp, earSysSci, earSysSciExp]);

    comInfApp.addUnderManager(computer);

    culture_world_sin20.addUnderManagerAll([lenLit, culArt, hisPhi, polEco, humSoc]);

    lenLit.addUnderManager(lenLitFree);

    culArt.addUnderManager(culArtFree);

    hisPhi.addUnderManager(hisPhiFree);

    polEco.addUnderManager(polEcoFree);

    humSoc.addUnderManager(humSocFree);

    major.addUnderManagerAll([major_necessary, major_optional, major_other]);

    major_necessary
      ..minCredits = 30
      ..addUnderManagerAll([eneUnd, enePra, eneMat, eneThe, eneEcoTecAdm, eneFlu, eneEar, stoDynExp, oilGasEngExp, elaExp, resProEng, resEngDes]);

    major_optional
      ..minCredits = 29
      ..addUnderManager(optFree);

    major_other.addUnderManager(othFree);

    normal
      ..minCredits = 21
      ..addUnderManager(norFree);
  }
}

_changeStudentNumClicked(BuildContext context) async {
  final doChange = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(str.changeSNumInfo),
            content: Text(str.changeSNumDetail),
            actions: [
              FlatButton(
                child: Text(str.ok),
                onPressed: () {
                  _clearAll();
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text(str.cancel),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ],
          ));

  if (doChange == true) {
    final sn = await Navigator.push(context, MaterialPageRoute(builder: (context) => StudentNumActivity()));

    if (sn != null) {
      studentNum = sn;
      _changeMajorProcess();
    }
  }
}

_onMultiMajorButton(BuildContext context) async {
  final preMajor = progressingMajor;
  await showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
            title: Text(str.changeMajorInfo),
            content: Text(
              str.changeMajorDetail,
              textAlign: TextAlign.left,
            ),
            actions: [
              FlatButton(
                child: Text(
                  str.translate(EREOnly),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  progressingMajor = EREOnly;
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  str.translate(EREnOther),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  progressingMajor = EREnOther;
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  str.translate(OthernERE),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  progressingMajor = OthernERE;
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  str.translate(OthernSubERE),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  progressingMajor = OthernSubERE;
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  str.cancel,
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ));

  if (progressingMajor != preMajor) {
    _changeMajorProcess();
    EREToast(str.lang == '한국어' ? '$progressingMajor을 선택하셨습니다.' : 'Selected ${str.translate(progressingMajor)}.', context, false);
  }
}

void _save(BuildContext context, CreditStorage storage) async {
  try {
    final culTot = _totalization(culture);
    final majTot = _totalization(major);
    final norTot = _totalization(normal);

    await storage.writeData(<String, dynamic>{
      'culTot': culTot,
      'majTot': majTot,
      'norTot': norTot,
      'forLectures': jsonEncode(forLectures),
      'progressingMajor': progressingMajor,
      'isLifeChecked': isLifeChecked,
      'studentNum': studentNum
    });

    EREToast(str.saveSuccess, context, false);
  } catch (e) {
    EREToast(str.saveFail, context, false);
    print(e);
  }
}

Map<String, dynamic> _totalization(CreditManager creditManager) {
  List<CreditManager> tot = [];
  tot.add(creditManager);
  for (int idx = 0; idx < tot.length; idx++) {
    final curManager = tot[idx];
    if (curManager.getSize() > 0) tot.insertAll(idx + 1, curManager.underManagers);
  }

  List<String> names = [];
  List<int> creditss = [];
  List<int> minCredits = [];
  List<int> codes = [];
  List<List<int>> underManagers = [];
  List<int> credits = [];
  List<int> upperManagers = [];
  List<int> nums = [];

  for (int idx = 0; idx < tot.length; idx++) {
    CreditManager curManager = tot[idx];
    names.add(curManager.name);
    creditss.add(curManager.credits);
    minCredits.add(curManager.minCredits);
    codes.add(curManager.code);
    underManagers.add(curManager.underManagers.map<int>((underManager) => tot.indexOf(underManager)).toList());
    credits.add(curManager.credit);
    upperManagers.add(curManager.upperManager != null ? tot.indexOf(curManager.upperManager) : null);
    nums.add(curManager.num);
  }

  return <String, dynamic>{
    'names': names,
    'creditss': creditss,
    'minCredits': minCredits,
    'codes': codes,
    'underManagers': underManagers,
    'credits': credits,
    'upperManagers': upperManagers,
    'nums': nums
  };
}

void _openForLecLayout(BuildContext context) async {
  forLectures = await Navigator.push(context, MaterialPageRoute(builder: (context) => ForLecActivity(forLectures: forLectures))) as ForLectures;
}

void _onAdviceButtonClicked(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(str.info),
            content: Text(
              str.infoDetail,
              textAlign: TextAlign.left,
            ),
            actions: [
              FlatButton(
                child: Text(str.ereLink),
                onPressed: () async {
                  const url = 'http://ere.snu.ac.kr/ko/node/26';
                  if (await canLaunch(url))
                    await launch(url);
                  else
                    throw 'Could not launch $url';
                },
              ),
              FlatButton(
                child: Text(str.ok),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}
