import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_list/models/task_model.dart';

import '../../core/constants.dart';

class AddTaskRepo {
  Future<TaskModel> addTask(String taskName, int listId) async {
    var responseData;
    var parsedResponse;

    final response = await http.post(
      Uri.parse("${Constants.baseUrl}/newTask/$listId"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"task": taskName}),
    );

    if (response.statusCode == 201) {
      print("List created sucessfully");
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Error creating list: ${response.body}');
    }
  }
}
