import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../core/constants.dart';

class DeleteListRepo {
  Future<Map<String, dynamic>> deleteList(int listId) async {
    var responseData;
    var parsedResponse;

    final response = await http.delete(
      Uri.parse("${Constants.baseUrl}/deleteList/$listId"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("List deleted sucessfully");
      }
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Error creating list: ${response.body}');
    }
  }
}
