class TodoListModel {
  final int listId;
  final String listName;
  final List<dynamic> tasks;

  TodoListModel({
    required this.listId,
    required this.listName,
    required this.tasks,
  });

  factory TodoListModel.fromJson(Map<String, dynamic> json) {
    return TodoListModel(
        listId: json['listId'] as int,
        listName: json['listName'] as String,
        tasks: json['tasks'] as List<dynamic>);
  }
}
