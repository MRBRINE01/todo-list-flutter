import 'package:flutter/material.dart';
import 'package:todo_list/views/right_panel.dart';
import '../models/todo_list_model.dart';
import '../repositories/list_reop/getlist_repo.dart';
import 'left_panel.dart';
import 'task_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  TodoList? selectedList;
  String? selectedListName;
  // int? selectedListId;

  void onListSelected(TodoList list, String listName) {
    setState(() {
      selectedList = list;
      selectedListName = listName;
      // selectedListId = listId;

      taskName = null;
      isComplete = null;
      onToggleTask = null;
    });
  }

  String? taskName;
  bool? isComplete;
  VoidCallback? onToggleTask;

  void onTaskSelected(
      String taskname, bool iscomplete, VoidCallback ontoggletask) {
    setState(() {
      taskName = taskname;
      isComplete = iscomplete;
      onToggleTask = ontoggletask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: LeftPanel(onListSelected: onListSelected),
          ),
          // Vertical divider
          Container(
            width: 1,
            color: Colors.grey[700],
          ),
          Expanded(
              flex: 4,
              child: selectedList != null
                  ? TaskScreen(
                      todoList: selectedList!,
                      listName: selectedListName,
                      onTaskSelected: onTaskSelected)
                  : CircularProgressIndicator()),
          taskName != null
              ? Expanded(
                  flex: 1,
                  child: RightPanel(
                    taskName: taskName,
                    isCompleted: isComplete,
                    onToggleTask: () {},
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
