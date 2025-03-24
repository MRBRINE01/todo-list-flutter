import 'package:flutter/material.dart';
import 'package:todo_list/core/constants.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/models/todo_list_model.dart';

import '../repositories/tasks_repo/add_task_repo.dart';

class TaskScreen extends StatefulWidget {
  final Function(TaskModel, bool, VoidCallback) onTaskSelected;
  final TodoListModel todoList;
  final String? listName;

  const TaskScreen(
      {super.key,
      required this.todoList,
      required this.listName,
      required this.onTaskSelected});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController taskController = TextEditingController();
  List<TaskModel> pendingTaskModels = [];
  List<TaskModel> completedTaskModels = [];
  Color bgColor = Constants.nonHoverColor;
  int? hover;

  AddTaskRepo addtask = AddTaskRepo();

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todoList != oldWidget.todoList) {
      setData();
    }
  }

  void setData() {
    setState(() {
      pendingTaskModels.clear();
      completedTaskModels.clear();

      for (var taskItem in widget.todoList.tasks) {
        // Convert each task item to a TaskModel
        Map<String, dynamic> taskJson = {
          'taskId': taskItem['taskId'] ?? 0,
          'task': taskItem['task'] as String,
          'isCompleted': taskItem['status'] as bool,
          'dueDate': taskItem['dueDate'] ?? '',
          'note': taskItem['note'] ?? '',
        };

        TaskModel taskModel = TaskModel.fromJson(taskJson);

        // Add to appropriate lists based on completion status
        if (!taskModel.isCompleted) {
          pendingTaskModels.add(taskModel);
        } else {
          completedTaskModels.add(taskModel);
        }
      }
    });
  }

  void addTask() {
    setState(() {
      String taskText = taskController.text.trim();
      if (taskText.isNotEmpty) {
        // Create a new TaskModel for the task
        TaskModel newTask = TaskModel(
          
          task: taskText,
          isCompleted: false,
          note: '', 
        );
        pendingTaskModels.add(newTask);
      }
      taskController.clear();
    });
  }

  void toggleTask(TaskModel taskModel, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        // Task is currently completed, move to pending
        completedTaskModels
            .removeWhere((task) => task.taskId == taskModel.taskId);

        // Create a new TaskModel with updated isCompleted status
        TaskModel updatedTask = TaskModel(
          taskId: taskModel.taskId,
          task: taskModel.task,
          isCompleted: false,
          dueDate: taskModel.dueDate,
          note: taskModel.note,
        );
        pendingTaskModels.add(updatedTask);
      } else {
        // Task is currently pending, move to completed
        pendingTaskModels
            .removeWhere((task) => task.taskId == taskModel.taskId);

        // Create a new TaskModel with updated isCompleted status
        TaskModel updatedTask = TaskModel(
          taskId: taskModel.taskId,
          task: taskModel.task,
          isCompleted: true,
          dueDate: taskModel.dueDate,
          note: taskModel.note,
        );
        completedTaskModels.add(updatedTask);
      }
    });
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.listName ?? "",
              style: TextStyle(fontSize: 40, color: Constants.checkColor),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  ...pendingTaskModels
                      .map((taskModel) => taskTile(taskModel, false)),
                  if (completedTaskModels.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Constants.nonHoverColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Row(
                            children: [
                              Icon(Icons.keyboard_arrow_down_rounded,
                                  color: Constants.textColor),
                              Text(
                                "Completed",
                                style: TextStyle(
                                    color: Constants.textColor, fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ...completedTaskModels
                      .map((taskModel) => taskTile(taskModel, true)),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: MouseRegion(
                        onEnter: (_) =>
                            setState(() => bgColor = Constants.hoverColor),
                        onExit: (_) =>
                            setState(() => bgColor = Constants.nonHoverColor),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Icon(
                                Icons.add,
                                color: Constants.checkColor,
                                size: 25,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                    controller: taskController,
                                    cursorColor: Constants.textColor,
                                    style:
                                        TextStyle(color: Constants.textColor),
                                    decoration: InputDecoration(
                                      hintText: 'Add a task',
                                      hintStyle: TextStyle(
                                          color: Constants.checkColor),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                    onSubmitted: (value) {
                                      addTask();
                                      addtask.addTask(
                                          value, widget.todoList.listId);
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskTile(TaskModel taskModel, bool isCompleted) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = taskModel.taskId),
      onExit: (_) => setState(() => hover = null),
      child: GestureDetector(
        onTap: () {
          widget.onTaskSelected(
              taskModel, isCompleted, () => toggleTask(taskModel, isCompleted));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          color: hover == taskModel.taskId
              ? Constants.hoverColor
              : Constants.nonHoverColor,
          margin: const EdgeInsets.symmetric(vertical: 3),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => toggleTask(taskModel, isCompleted),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Constants.textColor, width: 2),
                      color: isCompleted
                          ? Constants.checkColor
                          : Colors.transparent,
                    ),
                    child: isCompleted
                        ? Icon(
                            Icons.check,
                            color: Constants.textColor,
                            size: 16,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  taskModel.task,
                  style: TextStyle(
                    color: Constants.textColor,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    decorationThickness: 3,
                    decorationColor: Constants.textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
