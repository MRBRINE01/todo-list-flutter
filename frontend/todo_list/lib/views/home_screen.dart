import 'package:flutter/material.dart';
import 'package:todo_list/core/constants.dart';

import 'left_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController taskController = TextEditingController();
  List<String> task = [];
  Color bgColor = Color.fromARGB(255, 43, 43, 43);
  List<bool> isChecked = [];
  int? hover;

  void addTask() {
    setState(() {
      task.add(taskController.text.trim());
      taskController.clear();
      isChecked.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 300,
            child: LeftPanel(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Text(
                        "Tasks",
                        style: TextStyle(fontSize: 40, color: Colors.blue),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: task.length,
                          itemBuilder: (context, index) {
                            return MouseRegion(
                              onEnter: (_) => setState(() => hover = index),
                              onExit: (_) => setState(() => hover = null),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: hover == index
                                    ? Constants.hoverColor
                                    : Constants.nonHoverColor,
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isChecked[index] =
                                                !isChecked[index];
                                          });
                                          print(isChecked[index]);
                                        },
                                        child: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                            color: isChecked[index]
                                                ? Colors.blue
                                                : Colors.transparent,
                                          ),
                                          child: isChecked[index]
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        task[index],
                                        style: TextStyle(
                                            color: Colors.white,
                                            decoration: isChecked[index]
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            decorationThickness: 3,
                                            decorationColor: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      if (isChecked.contains(true))
                        Padding(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 90, left: 0, right: 0),
                          child: Container(
                            height: 45,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Color.fromARGB(255, 43, 43, 43),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Icon(Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white),
                                  Text(
                                    "Completed",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 17),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: MouseRegion(
                              onEnter: (_) => setState(() =>
                                  bgColor = Color.fromARGB(255, 63, 63, 63)),
                              onExit: (_) => setState(() =>
                                  bgColor = Color.fromARGB(255, 43, 43, 43)),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 25,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        controller: taskController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          hintText: 'Add a task',
                                          hintStyle:
                                              TextStyle(color: Colors.blue),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10),
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
          ),
        ],
      ),
    );
  }
}
