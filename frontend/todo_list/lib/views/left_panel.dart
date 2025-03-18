import 'package:flutter/material.dart';
import 'package:todo_list/repositories/new_list_repo.dart';

import '../core/constants.dart';
import '../models/todo_list.dart';
import '../repositories/delete_list_repo.dart';
import '../repositories/edit_list_repo.dart';
import '../repositories/getlist_repo.dart';

class LeftPanel extends StatefulWidget {
  final Function(TodoList, String) onListSelected;

  const LeftPanel({super.key, required this.onListSelected});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  List<IconData> defaltIcon = [
    Icons.wb_sunny,
    Icons.star_border,
    Icons.menu_book,
    Icons.person_2_outlined,
    Icons.home_outlined
  ];

  List<String> defaultList = [
    "My day",
    "Important",
    "Planned",
    "Assigned to me",
    "Tasks"
  ];

  NewListRepo newListRepo = NewListRepo();

  List<String> addedNewList = [];
  bool isListAdd = false;
  int? _isHovered;
  int? _isHover;

  final TextEditingController newListController = TextEditingController();
  late List<TodoList> todoList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTodoList();
  }

  Future<void> loadTodoList() async {
    ListData listDataInstance = ListData();
    List<TodoList> fetchedList = await listDataInstance.getListData();
    setState(() {
      todoList = fetchedList;
      addedNewList = todoList.map((todo) => todo.listName).toList();
      widget.onListSelected(todoList[0], todoList[0].listName);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    newListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                //defaultlist
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: defaultList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isHovered = index),
                                onExit: (_) =>
                                    setState(() => _isHovered = null),
                                child: ColoredBox(
                                  color: _isHovered == index
                                      ? Constants.hoverColor
                                      : Constants.surfaceColor,
                                  child: ListTile(
                                    leading: Icon(
                                      defaltIcon[index],
                                      color: Colors.blue,
                                    ),
                                    title: Text(defaultList[index],
                                        style: TextStyle(color: Colors.white)),
                                    trailing: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.grey[800],
                                      child: Text(
                                        "3",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    // onTap: () {
                                    //   widget.onListSelected();
                                    // },
                                  ),
                                ),
                              );
                            }),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[600],
                        ),
                        //created list
                        ListView.builder(
                          itemCount: isListAdd
                              ? addedNewList.length + 1
                              : addedNewList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            if (isListAdd && index == addedNewList.length) {
                              return ListTile(
                                leading: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                title: TextField(
                                  autofocus: true,
                                  cursorColor: Colors.white,
                                  controller: newListController,
                                  onSubmitted: (value) {
                                    setState(() {
                                      addedNewList.add(value.trim());
                                      isListAdd = false;
                                      newListRepo.createNewList(value.trim());
                                      newListController.clear();
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Enter list name",
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return MouseRegion(
                                onEnter: (_) =>
                                    setState(() => _isHover = index),
                                onExit: (_) => setState(() => _isHover = null),
                                child: GestureDetector(
                                  onSecondaryTapUp: (details) {
                                    _showContextMenu(
                                        context,
                                        index,
                                        details.globalPosition,
                                        todoList[index].listId);
                                  },
                                  child: ColoredBox(
                                    color: _isHover == index
                                        ? Constants.hoverColor
                                        : Constants.surfaceColor,
                                    child: ListTile(
                                      leading: Icon(
                                        Icons.menu,
                                        color: Colors.blue,
                                      ),
                                      title: Text(
                                        addedNewList[index],
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      trailing: CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.grey[800],
                                        child: Text(
                                          "3",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      onTap: () {
                                        widget.onListSelected(todoList[index],
                                            addedNewList[index]);
                                      },
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                // newListRepo.createNewList("No work");
                setState(() {
                  isListAdd = true;
                });
              },
              child: Container(
                color: Colors.grey[800],
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 23,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "New List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(
      BuildContext context, int index, Offset position, int listId) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      color: Constants.surfaceColor,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          position,
          position,
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text('Edit', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _editList(index, listId);
      } else if (value == 'delete') {
        _deleteList(index, listId);
      }
    });
  }

  void _editList(int index, int listId) {
    // Set up the controller with the current list name
    TextEditingController editController =
        TextEditingController(text: addedNewList[index]);
    EditListRepo editList = EditListRepo();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.surfaceColor,
        title: Text('Edit List', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: editController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Save', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              setState(() {
                addedNewList[index] = editController.text.trim();
                editList.editList(editController.text.trim(), listId);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _deleteList(int index, int listId) {
    DeleteListRepo deleteList = DeleteListRepo();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.surfaceColor,
        title: Text('Delete List', style: TextStyle(color: Colors.white)),
        content: Text(
            'Are you sure you want to delete "${addedNewList[index]}"?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Delete', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                todoList.removeAt(index);
                addedNewList.removeAt(index);
                deleteList.deleteList(listId);
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
