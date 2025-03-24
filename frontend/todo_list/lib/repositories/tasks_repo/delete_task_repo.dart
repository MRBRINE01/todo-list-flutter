import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_list/models/task_model.dart';

import '../../core/constants.dart';

class DeleteTaskRepo {
  Future<TaskModel> deleteTask(int? listId, int? taskId) async {
    print(listId);
    print(taskId);

    final response = await http.delete(
      Uri.parse("${Constants.baseUrl}/deleteTask/$listId/$taskId"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      print("Task deleted sucessfully");
      return TaskModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Error creating list: ${response.body}');
    }
  }
}
