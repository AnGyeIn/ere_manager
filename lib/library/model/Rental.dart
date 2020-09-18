class Rental {
  String id;
  String bookID;
  String bookTitle;
  String borrowerID;
  String borrowerName;
  DateTime dueDate;

  Rental.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookID = json['bookID'],
        bookTitle = json['bookTitle'],
        borrowerID = json['borrowerID'],
        borrowerName = json['borrowerName'],
        dueDate = DateTime.parse(json['dueDate']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookID': bookID,
        'bookTitle': bookTitle,
        'borrowerID': borrowerID,
        'borrowerName': borrowerName,
        'dueDate': dueDate.toString()
      };
}
