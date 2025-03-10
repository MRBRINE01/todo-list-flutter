import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/constants.dart';

class NewListRepo {
  Future<Map<String, dynamic>> createNewList(String listName) async {
    var responseData;
    var parsedResponse;

    final response = await http.post(
      Uri.parse("${Constants.baseUrl}/newList"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"listName": listName}),
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
