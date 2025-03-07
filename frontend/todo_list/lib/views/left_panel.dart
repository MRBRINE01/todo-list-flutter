import 'package:flutter/material.dart';
import 'package:todo_list/repositories/new_list_repo.dart';

class LeftPanel extends StatefulWidget {
  const LeftPanel({super.key});

  @override
  State<LeftPanel> createState() => _LeftPanelState();
}

class _LeftPanelState extends State<LeftPanel> {
  List<String> defaultList = [
    "My day",
    "Important",
    "Planned",
    "Assigned to me",
    "Tasks"
  ];

  NewListRepo newListRepo = NewListRepo();

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
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: defaultList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(Icons.square),
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
                              );
                            }),
                        Divider(
                          thickness: 1,
                          color: Colors.grey[600],
                        ),
                        ListView.builder(
                            itemCount: 50,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Icon(
                                  Icons.menu,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  "Change me",
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.grey[800],
                                  child: Text(
                                    "3",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
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
                newListRepo.createNewList("No work");
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
}
