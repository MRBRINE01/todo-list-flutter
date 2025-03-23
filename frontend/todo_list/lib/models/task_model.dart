class TaskModel {
  final int taskId;
  final String task;
  final bool isCompleted;
  final DateTime dueDate;
  final String note;

  TaskModel({
    required this.taskId,
    required this.task,
    required this.isCompleted,
    required this.dueDate,
    required this.note,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'] as int,
      task: json['task'] as String,
      isCompleted: json['isCompleted'] as bool,
      dueDate: DateTime.parse(json['dueDate'] as String),
      note: json['note'] as String,
    );
  }
}
