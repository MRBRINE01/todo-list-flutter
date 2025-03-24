import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/constants.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/repositories/tasks_repo/delete_task_repo.dart';
import 'package:todo_list/repositories/tasks_repo/edit_task_repo.dart';

class RightPanel extends StatefulWidget {
  final TaskModel? taskData;
  final VoidCallback? onToggleTask;
  final int? listId;

  const RightPanel({
    super.key,
    required this.listId,
    required this.taskData,
    required this.onToggleTask,
  });

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  late bool isCompleted;
  TextEditingController noteController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  String? dueData;

  @override
  void initState() {
    super.initState();
    setState(() {
      taskNameController.text = widget.taskData!.task;
      isCompleted = widget.taskData!.isCompleted;
      noteController.text = widget.taskData!.note;
    });
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget? child) {
          return Theme(
              data: ThemeData(
                  colorScheme: ColorScheme.dark(
                      primary: Constants.calender1Color,
                      onPrimary: Constants.calender1Color,
                      onSurface: Constants.calender1Color)),
              child: child!);
        });

    if (pickedDate != null) {
      setState(() {
        dueData = DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void taskEdit() {
    EditTaskRepo editTask = EditTaskRepo();
    editTask.editTask(widget.listId, widget.taskData!.taskId,
        taskNameController.text, isCompleted, dueData, noteController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Constants.infoContainerColor,
              ),
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCompleted = !isCompleted;
                        });
                        // widget.onToggleTask!();
                        taskEdit();
                      },
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Constants.textColor, width: 2),
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        cursorColor: Colors.white,
                        controller: taskNameController,
                        onSubmitted: (value) {
                          taskEdit();
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Constants.infoContainerColor,
              ),
              height: 60,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.wb_sunny_outlined,
                      size: 23,
                      color: Constants.textColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Add to my day",
                      style:
                          TextStyle(color: Constants.textColor, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Constants.infoContainerColor,
              ),
              height: 130,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.watch_later_outlined,
                            size: 23,
                            color: Constants.textColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Remind Me",
                            style: TextStyle(
                              color: Constants.textColor,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Divider(thickness: 1, color: Constants.dividerColor),
                  ),
                  GestureDetector(
                    onTap: () => selectDate(context),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Icon(
                                  Icons.calendar_month,
                                  size: 23,
                                  color: Constants.textColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  dueData ?? "Add Due Date",
                                  style: TextStyle(
                                      color: Constants.textColor, fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: noteController,
              cursorColor: Constants.textColor,
              decoration: InputDecoration(
                hintText: "Add Note",
                hintStyle: TextStyle(color: Constants.hintTextColor),
                filled: true,
                fillColor: Constants.infoContainerColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              style: TextStyle(fontSize: 16, color: Constants.textColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              taskEdit();
            },
            child: Text("Save Note"),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Created on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                  style: TextStyle(color: Constants.textColor)),
              Spacer(),
              IconButton(
                onPressed: () {
                  DeleteTaskRepo deletetask = DeleteTaskRepo();
                  deletetask.deleteTask(widget.listId, widget.taskData!.taskId);

                  setState(() {
      // You can remove the deleted task from the list if applicable
    });
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
