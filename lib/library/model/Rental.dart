class Rental {
  String id;
  String bookID;
  String borrowerID;
  DateTime dueDate;

  Rental.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookID = json['bookID'],
        borrowerID = json['borrowerID'],
        dueDate = DateTime.parse(json['dueDate']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'bookID': bookID,
        'borrowerID': borrowerID,
        'dueDate': dueDate.toString()
      };
}
