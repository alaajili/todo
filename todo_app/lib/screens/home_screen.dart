import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/task_service.dart';
import 'package:todo_app/widgets/todo_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ToDo> todosList = [];
  bool isLoading = true;
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Fetch tasks from the API when the screen initializes
  }

  // Fetch tasks from the API
  Future<void> _fetchTasks() async {
    try {
      TaskService taskService = TaskService();
      List<ToDo> tasks = await taskService.fetchTasks();
      setState(() {
        todosList = tasks;
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false if there's an error
      });
      print('Error fetching tasks: $e');
    }
  }

  Future<void> _addTask() async {
    try {
      TaskService taskService = TaskService();
      await taskService.addTask(_todoController.text);
      _fetchTasks();
      _todoController.clear();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> _deleteTask(String id) async {
    try {
      TaskService taskService = TaskService();
      await taskService.deleteTask(int.parse(id));
      _fetchTasks();
    } catch (e) {
      print('Error deleting task: $e');
    }
  }

  Future<void> _editTask(ToDo todo) async {
    try {
      TaskService taskService = TaskService();
      final id = int.parse(todo.id);
      await taskService.editTask(id, todo.completed == 1 ? 0 : 1);
      _fetchTasks();
      _todoController.clear();
    } catch (e) {
      print('Error editing task: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40, bottom: 20),
                        child: const Text(
                          'All Tasks',
                          style: TextStyle(
                            color: tdBlack,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      for (ToDo todo in todosList)
                        ToDoItem(
                          todo: todo,
                          onToDoChanged: _editTask,
                          onDeleteItem: _deleteTask,
                        ),
                      if (todosList.isEmpty)
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: tdGrey,
                                size: 50,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No tasks added yet!',
                                style: TextStyle(
                                  color: tdGrey,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 0.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      hintText: 'Add a new task item',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 20,
                  right: 20,
                ),
                child: ElevatedButton(
                  onPressed: _addTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdBlue,
                    minimumSize: const Size(50, 50),
                    elevation: 10,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }


  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            minHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );                
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(
          'Todo App',
          style: TextStyle(
            color: tdBlack,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          )
        ),
        Icon(
          Icons.logout,
          color: tdBlack,
          size: 30,
        ),
      ]),
    );
  }
}