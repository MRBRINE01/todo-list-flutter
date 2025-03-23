import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';

class EditListRepo {
  Future<Map<String, dynamic>> editList(String listName, int listId) async {
    var responseData;
    var parsedResponse;
    final response = await http.put(
      Uri.parse("${Constants.baseUrl}/editList/$listId"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"listName": listName}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Error creating list: ${response.body}');
    }
  }
}
