class ToDo {
  String id;
  String title;
  int completed;

  ToDo({
    required this.id,
    required this.title,
    this.completed = 0,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    return ToDo(
      id: json['id'].toString(),
      title: json['title'],
      completed: json['completed'],
    );
  }
}
