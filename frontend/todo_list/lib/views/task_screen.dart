import 'package:flutter/material.dart';
import 'package:todo_list/core/constants.dart';
import 'package:todo_list/models/todo_list.dart';

class TaskScreen extends StatefulWidget {
  final TodoList todoList;
  final String? listName;

  const TaskScreen({super.key, required this.todoList, required this.listName});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController taskController = TextEditingController();
  List<String> taskList = [];
  List<String> pendingTasks = [];
  List<String> completedTasks = [];
  Color bgColor = Constants.nonHoverColor;
  int? hover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  @override
  void didUpdateWidget(TaskScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todoList != oldWidget.todoList) {
      pendingTasks.clear();
      completedTasks.clear();
      setData();
    }
  }

  void setData() {
    setState(() {
      for (var taskItem in widget.todoList.tasks) {
        if (taskItem['status'] == false) {
          pendingTasks.add(taskItem['task']);
        } else {
          completedTasks.add(taskItem['task']);
        }
      }
    });
  }

  void addTask() {
    setState(() {
      String task = taskController.text
          .trim(); //removes the whitespace charaters so that empty tasks cant be added
      if (task.isNotEmpty) {
        pendingTasks.add(task);
      }
      taskController.clear();
    });
  }

  void toggleTask(String task, bool isCompleted) {
    //function to move tasks from pending to completed tasks and vice versa
    setState(() {
      if (isCompleted) {
        completedTasks.remove(task);
        pendingTasks.add(task);
      } else {
        pendingTasks.remove(task);
        completedTasks.add(task);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                //created a list view intead of list view builder beacause it allows to add tasks or items anywhere between the list
                physics: const BouncingScrollPhysics(),
                children: [
                  ...pendingTasks.map((task) => taskTile(task,
                      false)), //creates a list of task dynamically and places them inside the ListView.
                  //.map() goes through each task inside pending tasks and changes it into a task tile.
                  //... is a spread operator that breaks the list and adds each widget separately into list view.

                  if (completedTasks
                      .isNotEmpty) //will show only if task is checked
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        height: 50,
                        //width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Constants.nonHoverColor,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
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

                  ...completedTasks.map((task) => taskTile(
                      task, true)), //same logic for completed tasks like before
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
                                  style: TextStyle(color: Constants.textColor),
                                  decoration: InputDecoration(
                                    hintText: 'Add a task',
                                    hintStyle:
                                        TextStyle(color: Constants.checkColor),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  onSubmitted: (value) => addTask(),
                                ),
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

  Widget taskTile(String task, bool isCompleted) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover =
          task.hashCode), //hashcode used to identify on which task the mouse is
      onExit: (_) => setState(() => hover = null),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: hover == task.hashCode
            ? Constants.hoverColor
            : Constants.nonHoverColor,
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => toggleTask(task, isCompleted),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Constants.textColor, width: 2),
                    color:
                        isCompleted ? Constants.checkColor : Colors.transparent,
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
                task,
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
    );
  }
}
