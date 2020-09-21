import 'Data.dart';

class CreditManager {
  String name;
  int credits = 0;
  int minCredits;
  List<CreditManager> underManagers = [];
  bool viewSwitch = OFF;
  int code;
  int credit;

  CreditManager upperManager;
  int num;

  CreditManager([this.code, this.name, this.minCredits, this.credit, this.upperManager, this.num]);

  void addUnderManager(CreditManager creditManager) {
    underManagers.add(creditManager);
  }

  void addUnderManagerAll(List<CreditManager> creditManagers) {
    underManagers.addAll(creditManagers);
  }

  void insertUnderManager(int i, CreditManager creditManager) {
    underManagers.insert(i, creditManager);
  }

  void removeUnderManager(CreditManager creditManager) {
    underManagers.remove(creditManager);
  }

  int getSize() => underManagers.length;

  void sumCredits() {
    switch (code) {
      case LECTURE_TYPE:
        credits = 0;
        for (var underManager in underManagers) {
          if (underManager.code == LECTURE_FIELD) underManager.sumCredits();
          credits += underManager.credits;
        }
        break;

      case LECTURE_FIELD:
        credits = 0;
        for (var underManager in underManagers) {
          if (underManager.code == LECTURE_GROUP || underManager.code == LECTURE_WORLD) underManager.sumCredits();
          credits += underManager.credits;
        }
        break;

      case LECTURE_GROUP:
      case LECTURE_WORLD:
        credits = 0;
        for (var underManager in underManagers) credits += underManager.credits;
        break;
    }
  }

  void incNum() {
    num++;
  }

  void decNum() {
    num--;
  }

  void removeThis() {
    upperManager.removeUnderManager(this);
    int freeLectureIdx = upperManager.getSize() - 1;
    CreditManager freeLecture = upperManager.underManagers[freeLectureIdx];
    freeLecture.decNum();
  }
}
