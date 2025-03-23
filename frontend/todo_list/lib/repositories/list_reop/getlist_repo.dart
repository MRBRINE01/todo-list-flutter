import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo_list/models/todo_list_model.dart';
import '../../core/constants.dart';

class ListData {
  Future<List<TodoList>> getListData() async {
    try {
      final response = await http.get(
        Uri.parse("${Constants.baseUrl}/lists"),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> listsJson = data['lists']?? [];

        return listsJson
            .map((listsJson) => TodoList.fromJson(listsJson))
            .toList();
      } else {
        throw Exception('Failed to load lists: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching lists: $error');
    }
  }
}
