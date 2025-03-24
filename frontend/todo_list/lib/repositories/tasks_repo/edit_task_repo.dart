import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_list/models/task_model.dart';

import '../../core/constants.dart';

class EditTaskRepo {
  Future<TaskModel> editTask(int? listId, int? taskId, String taskName,
      bool status, String? dueDate, String note) async {
    print(listId);
    print(taskId);

    final response = await http.put(
      Uri.parse("${Constants.baseUrl}/editTask/$listId/$taskId"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "task": taskName,
        "status": status.toString(),
        "dueDate": dueDate,
        "note": note,
      }),
    );

    if (response.statusCode == 200) {
      print("task edited sucessfully");
      return TaskModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Error creating list: ${response.body}');
    }
  }
}
