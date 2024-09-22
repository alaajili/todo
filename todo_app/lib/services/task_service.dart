import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/todo.dart';

class TaskService {
  final String laravelApiUrl = 'http://10.0.2.2:8000/api';

  // Method to fetch tasks
  Future<List<ToDo>> fetchTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$laravelApiUrl/tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
      
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = jsonDecode(response.body)['data'];
      print(data);
      return data.map((task) => ToDo.fromJson(task as Map<String, dynamic>)).toList();
    } else {
      // print(response.body);
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<void> addTask(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$laravelApiUrl/tasks'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': title,
        'completed': false,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add task');
    }
  }

  Future<void> editTask(int id, int completed) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('$laravelApiUrl/tasks/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'completed': completed,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit task');
    }
  }

  Future<void> deleteTask(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$laravelApiUrl/tasks/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete task');
    }
  }
}

