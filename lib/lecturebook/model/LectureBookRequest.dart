class LectureBookRequest {
  String id;
  String lecturebookID;
  String lecturebookTitle;
  String ownerID;
  String ownerName;
  String receiverID;
  String receiverName;
  String option;
  DateTime requestTime;
  bool isAccepted;
  bool isRejected;

  LectureBookRequest.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        lecturebookID = json['lecturebookID'],
        lecturebookTitle = json['lecturebookTitle'],
        ownerID = json['ownerID'],
        ownerName = json['ownerName'],
        receiverID = json['receiverID'],
        receiverName = json['receiverName'],
        option = json['option'],
        requestTime = DateTime.parse(json['requestTime']),
        isAccepted = json['isAccepted'] as bool,
        isRejected = json['isRejected'] as bool;

  Map<String, dynamic> toJson() => {
        'requestTime': requestTime.toString(),
        'id': id,
        'lecturebookID': lecturebookID,
        'lecturebookTitle': lecturebookTitle,
        'ownerID': ownerID,
        'ownerName': ownerName,
        'receiverID': receiverID,
        'receiverName': receiverName,
        'option': option,
        'isAccepted': isAccepted,
        'isRejected': isRejected
      };
}
