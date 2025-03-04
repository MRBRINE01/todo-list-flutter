import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> selectedTasks =
      List.generate(5, (index) => false); // Track selection for each task

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "Tasks",
              style: TextStyle(
                fontSize: 40,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20), // Add spacing
            Expanded(
              child: ListView.builder(
                itemCount: 5, // 5 tasks
                itemBuilder: (context, index) {
                  return Card(
                    color: const Color.fromARGB(255, 99, 99, 99),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Image(image: )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
