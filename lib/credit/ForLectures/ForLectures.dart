import '../credit_main.dart';

class ForLectures {
  List<String> types = [];
  List<String> names = [];
  int num = 0;

  ForLectures();

  ForLectures.fromJson(Map<String, dynamic> json)
      : types =
            parseCreditPiece(json['types'])?.map((e) => e as String)?.toList(),
        names =
            parseCreditPiece(json['names'])?.map((e) => e as String)?.toList(),
        num = json['num'] as int;

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'types': types, 'names': names, 'num': num};

  void addForLecture(String type, String name) {
    types.add(type);
    names.add(name);
    num++;
  }

  void removeForLecture(int idx) {
    types.removeAt(idx);
    names.removeAt(idx);
    num--;
  }
}
