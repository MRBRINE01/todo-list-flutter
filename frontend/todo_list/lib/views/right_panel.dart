import 'package:flutter/material.dart';

class RightPanel extends StatefulWidget {
  const RightPanel({super.key});

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  bool isChecked = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 10),
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromARGB(255, 43, 43, 43),
              ),
                
              height: 60,
              
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                        checkColor: Colors.white,
                        side: BorderSide(color: Colors.white, width: 1),

                        ),
                  ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text("Task name",style: TextStyle(color: Colors.white, 
                        fontSize: 20,
                        decoration: isChecked ? TextDecoration.lineThrough : TextDecoration.none,
                        decorationColor: Colors.white, 
                        decorationThickness: 2,
                          
                        ),
                        
                        ),
                      ),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromARGB(255, 43, 43, 43),
              ),
                
              height: 60,
              
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(Icons.wb_sunny_outlined, size: 25, color: Colors.white,),
                  ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("Add to my day",style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                ],
              ),
            ),
          ),



          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromARGB(255, 43, 43, 43),
              ),
                
              height: 130,
              
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.watch_later_outlined, color: Colors.white,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Remind Me", style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10,left: 10),
                    child: Divider(thickness: 1, color: const Color.fromARGB(255, 81, 81, 81)
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.calendar_month, color: Colors.white,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text("Add Due Date", style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                    
                      ],
                    ),
                  ),
                    ],
                  )
                ],
              ),

              
            ),
          ),

          Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: "Add Note",
              hintStyle: TextStyle(color: const Color.fromARGB(255, 149, 149, 149)
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 43, 43, 43), 
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none, 
              ),
            ),
            maxLines: 5, 
            keyboardType: TextInputType.multiline,
            style: TextStyle(fontSize: 16, color: Colors.white), 
          ),
          ),
        ],
      ),
    );
  }
}
