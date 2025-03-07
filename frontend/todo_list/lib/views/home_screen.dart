import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final TextEditingController taskController = TextEditingController();
 List<String> task = [];

 void addTask() {
      setState(() {
        task.add(taskController.text.trim()); 
        taskController.clear(); 
      });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  Text(
                    "Tasks",
                    style: TextStyle(
                      fontSize: 40,
                      color: const Color.fromARGB(255, 96, 69, 251)
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(), 
                      itemCount: task.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5), 
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                            //     Checkbox(
                            //   value: ,
                            //   onChanged: ;
                            //   },
                            // ),
                                Text(task[index], style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 80,)
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
                      child: Container(
                        margin: const EdgeInsets.only(
                          
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(5), 
                        ),
                        child: TextField(
                          controller: taskController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: ' + Add a task',
                            hintStyle: TextStyle(color: const Color.fromARGB(255, 96, 69, 251)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          onSubmitted: (value) => addTask()
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
}