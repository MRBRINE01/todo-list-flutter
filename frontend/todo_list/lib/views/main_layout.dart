import 'package:flutter/material.dart';
import 'package:todo_list/views/right_panel.dart';
import '../models/todo_list.dart';
import '../repositories/getlist_repo.dart';
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

  void onListSelected(TodoList list, String listName) {
    setState(() {
      selectedList = list;
      selectedListName = listName;
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
                      todoList: selectedList!, listName: selectedListName)
                  : CircularProgressIndicator()),
          Expanded(flex: 1, child: RightPanel()),
        ],
      ),
    );
  }
}
