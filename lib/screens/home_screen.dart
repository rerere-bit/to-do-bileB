import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do Mini'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => taskProvider.setFilter(value),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              const PopupMenuItem(value: 'Active', child: Text('Active')),
              const PopupMenuItem(value: 'Done', child: Text('Done')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Tambah tugas...',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.length < 3) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Judul minimal 3 karakter!')),
                      );
                      return;
                    }
                    taskProvider.addTask(text);
                    _controller.clear();
                  },
                ),
              ),
            ),
          ),

          // Jumlah aktif
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Jumlah tugas aktif: ${taskProvider.activeCount}"),
          ),

          // ListView Tugas
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.tasks.length,
              itemBuilder: (context, index) {
                final task = taskProvider.tasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (_) => taskProvider.toggleTask(task),
                  ),
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      taskProvider.removeTask(task);
                      // Snackbar + Undo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Item '${task.title}' dihapus"),
                          action: SnackBarAction(
                            label: "Undo",
                            onPressed: () {
                              taskProvider.addTask(task.title);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
