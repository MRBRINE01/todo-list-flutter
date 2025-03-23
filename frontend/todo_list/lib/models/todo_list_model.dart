class TodoList {
  final int listId;
  final String listName;
  final List<dynamic> tasks;

  TodoList({
    required this.listId,
    required this.listName,
    required this.tasks,
  });

  factory TodoList.fromJson(Map<String, dynamic> json) {
    return TodoList(
        listId: json['listId'] as int,
        listName: json['listName'] as String,
        tasks: json['tasks'] as List<dynamic>);
  }
}
