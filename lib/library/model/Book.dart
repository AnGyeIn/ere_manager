class Book {
  String id;
  String title;
  String author;
  String isbn;
  bool isAvailable;

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        author = json['author'],
        isbn = json['isbn'],
        isAvailable = json['isAvailable'] as bool;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'isbn': isbn,
        'isAvailable': isAvailable
      };
}
