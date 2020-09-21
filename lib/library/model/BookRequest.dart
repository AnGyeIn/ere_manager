class BookRequest {
  String id;
  String title;
  String author;
  String requesterID;
  String requesterName;
  bool isChecked;

  BookRequest.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
        requesterID = json['requesterID'],
        requesterName = json['requesterName'],
        isChecked = false;

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'author': author, 'requesterID': requesterID, 'requesterName': requesterName};
}
