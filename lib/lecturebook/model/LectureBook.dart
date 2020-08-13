class LectureBook {
  String id;
  String title;
  String author;
  String lecture;
  String ownerName;
  String ownerID;
  String option;
  bool isAvailable;

  LectureBook.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
        lecture = json['lecture'],
        ownerName = json['ownerName'],
        ownerID = json['ownerID'],
        option = json['option'],
        isAvailable = json['isAvailable'] as bool;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'lecture': lecture,
        'ownerName': ownerName,
        'ownerID': ownerID,
        'option': option,
        'isAvailable': isAvailable
      };
}
