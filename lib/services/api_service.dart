
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String baseUrl = 'http://127.0.0.1:5000/questions';

  static Future<List<dynamic>> fetchQuestions() async {
 return [
    {"title": "Question 1", "description": "Description 1"},
    {"title": "Question 2", "description": "Description 2"}
  ];

    final response = await http.get(Uri.parse(baseUrl));
    return jsonDecode(response.body);
  }

  static Future<void> submitQuestion(String title, String description) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'description': description}),
    );
  }
}
