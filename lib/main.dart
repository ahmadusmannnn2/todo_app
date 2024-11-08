import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Todo App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Map<String, dynamic>> tasks = [];
  bool isDarkMode = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    return MaterialApp(
      theme: currentTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Advanced Todo List'),
          actions: [
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari tugas...',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (searchQuery.isNotEmpty &&
                      !tasks[index]['title']
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase())) {
                    return Container(); // Skip items that don't match the search query
                  }
                  return ListTile(
                    title: Text(
                      tasks[index]['title'],
                      style: TextStyle(
                        color: tasks[index]['priority'] == 'Tinggi'
                            ? Colors.red
                            : tasks[index]['priority'] == 'Sedang'
                                ? Colors.orange
                                : Colors.green,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kategori: ${tasks[index]['category']}'),
                        if (tasks[index]['deadline'] != null)
                          Text(
                              'Deadline: ${tasks[index]['deadline'].day}/${tasks[index]['deadline'].month}/${tasks[index]['deadline'].year}'),
                        Text('Deskripsi: ${tasks[index]['description'] ?? ''}'),
                        Text(
                            'Berulang: ${tasks[index]['isRecurring'] ? "Ya" : "Tidak"}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTask(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _addTask() {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String selectedCategory = 'Pekerjaan';
    String selectedPriority = 'Tinggi';
    DateTime? selectedDate;
    bool isRecurring = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: 'Enter task title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(hintText: 'Enter task description'),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              items: ['Pekerjaan', 'Pribadi', 'Belanja'].map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedPriority,
              items: ['Tinggi', 'Sedang', 'Rendah'].map((String priority) {
                return DropdownMenuItem(value: priority, child: Text(priority));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),
            TextButton(
              child: Text(selectedDate == null
                  ? 'Select Deadline'
                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
            ),
            CheckboxListTile(
              title: Text('Penjadwalan Berulang'),
              value: isRecurring,
              onChanged: (bool? value) {
                setState(() {
                  isRecurring = value!;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Add'),
            onPressed: () {
              setState(() {
                tasks.add({
                  'title': titleController.text,
                  'completed': false,
                  'category': selectedCategory,
                  'priority': selectedPriority,
                  'deadline': selectedDate,
                  'isRecurring': isRecurring,
                  'description': descriptionController.text,
                });
                titleController.clear();
                descriptionController.clear();
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
