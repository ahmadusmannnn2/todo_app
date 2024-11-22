import 'package:flutter/material.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoIn App by:Usman👋',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black87,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
        ),
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

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
          title: const Text('ToDoIn App by: Ahmad Usman 👋'),
          actions: [
            IconButton(
              icon: Icon(
                isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: isDarkMode ? Colors.yellow : Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: const InputDecoration(
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
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: ListTile(
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
                          Text(
                              'Deskripsi: ${tasks[index]['description'] ?? ''}'),
                          Text(
                              'Berulang: ${tasks[index]['isRecurring'] ? "Ya" : "Tidak"}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle, color: Colors.green),
                            onPressed: () {
                              setState(() {
                                tasks[index]['completed'] = true;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _addTask(),
          child: const Icon(Icons.add),
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
        title: const Text('Tugas Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Judul tugas'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Deskripsi tugas'),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                items: ['Pekerjaan', 'Pribadi', 'Belanja']
                    .map((String category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category));
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
                  return DropdownMenuItem(
                      value: priority, child: Text(priority));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value!;
                  });
                },
              ),
              TextButton(
                child: Text(selectedDate == null
                    ? 'Pilih Deadline'
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
                title: const Text('Tugas Berulang'),
                value: isRecurring,
                onChanged: (bool? value) {
                  setState(() {
                    isRecurring = value!;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Tambah'),
            onPressed: () {
              if (titleController.text.isNotEmpty) {
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
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }
}
