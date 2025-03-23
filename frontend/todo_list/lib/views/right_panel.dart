import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/core/constants.dart';

class RightPanel extends StatefulWidget {
  final String? taskName;
  final bool? isCompleted;
  final VoidCallback? onToggleTask;

  const RightPanel({
    super.key,
    required this.taskName,
    required this.isCompleted,
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
  String? selectedDate;
  String? apiDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    isCompleted = widget.isCompleted!;
    taskNameController.text = widget.taskName!;
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
        selectedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        print("Selected Date: $selectedDate");
      });
    }
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
                        widget.onToggleTask!();
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
                                  selectedDate ?? "Add Due Date",
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
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "Created on ${DateFormat('dd-MM-yyyy').format(DateTime.now())}",
                  style: TextStyle(color: Constants.textColor)),
            ],
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}
