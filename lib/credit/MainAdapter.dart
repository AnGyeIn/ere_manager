import 'package:ere_manager/credit/CreditManager.dart';
import 'package:ere_manager/credit/Data.dart';
import 'package:flutter/material.dart';

import 'Tile/AddedLectureTile.dart';
import 'Tile/FreeLectureTile.dart';
import 'Tile/LectureFieldTile.dart';
import 'Tile/LectureGroupTile.dart';
import 'Tile/LectureTile.dart';
import 'Tile/LectureTypeTile.dart';
import 'Tile/LectureWorldTile.dart';

class MainAdapter {
  List<CreditManager> creditManagers = [];
  bool isEditable = false;

  int getSize() => creditManagers.length;

  Widget getTile(int idx, Function onPressed, double width, double height) {
    CreditManager creditManager = creditManagers[idx];
    int code = creditManager.code;

    Widget output;

    switch (code) {
      case LECTURE_TYPE:
        output = LectureTypeTile(
          lectureType: creditManager,
          onPressed: () {
            _tileFunc(idx);
            onPressed(() {});
          },
          width: width,
        );
        break;

      case LECTURE_FIELD:
        output = LectureFieldTile(
          lectureField: creditManager,
          onPressed: () {
            _tileFunc(idx);
            onPressed(() {});
          },
          width: width,
        );
        break;

      case LECTURE_GROUP:
        output = LectureGroupTile(
          lectureGroup: creditManager,
          onPressed: () {
            _tileFunc(idx);
            onPressed(() {});
          },
          width: width,
        );
        break;

      case LECTURE_WORLD:
        output = LectureWorldTile(
          lectureWorld: creditManager,
          onPressed: () {
            _tileFunc(idx);
            onPressed(() {});
          },
          width: width,
        );
        break;

      case LECTURE:
        output = LectureTile(
          lecture: creditManager,
          width: width,
          height: height,
        );
        break;

      case FREE_LECTURE:
        output = FreeLectureTile(
          freeLecture: creditManager,
          addFunc: (CreditManager creditManager) {
            _insertCreditManager(idx, creditManager);
            onPressed(() {});
          },
          onPressed: () {
            onPressed(() {});
          },
          adapter: this,
          width: width,
        );
        break;

      case ADDED_LECTURE:
        output = AddedLectureTile(
          addedLecture: creditManager,
          adapter: this,
          delFunc: () {
            _removeCreditManager(idx);
            onPressed(() {});
          },
          width: width,
          height: height,
        );
        break;
    }

    return output;
  }

  void _tileFunc(int idx) {
    if (creditManagers[idx].viewSwitch)
      while (true) {
        if (idx + 1 < getSize() && creditManagers[idx].code < creditManagers[idx + 1].code)
          _removeCreditManager(idx + 1);
        else {
          creditManagers[idx].viewSwitch = OFF;
          break;
        }
      }
    else {
      for (int k = 0, l = idx; k < creditManagers[idx].getSize(); k++, l++) creditManagers.insert(l + 1, creditManagers[idx].underManagers[k]);
      creditManagers[idx].viewSwitch = ON;
    }
  }

  void setCreditManager(CreditManager creditManager) {
    creditManagers.add(creditManager);
  }

  void _insertCreditManager(int idx, CreditManager creditManager) {
    creditManagers.insert(idx, creditManager);
  }

  void _removeCreditManager(int idx) {
    creditManagers.removeAt(idx);
  }

  void clear() {
    creditManagers.clear();
  }
}
