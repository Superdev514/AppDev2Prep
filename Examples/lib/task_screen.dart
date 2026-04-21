import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _tasks =
  FirebaseFirestore.instance.collection('Tasks');

  // ── CREATE ──────────────────────────────────────────────
  Future<void> _addTask() async {
    if (_controller.text.trim().isEmpty) return;
    await _tasks.add({
      'title': _controller.text.trim(),
      'created': Timestamp.now(),
    });
    _controller.clear();
  }

  // ── UPDATE ──────────────────────────────────────────────
  Future<void> _updateTask(DocumentSnapshot doc) async {
    final editController = TextEditingController(text: doc['title']);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Task'),
        content: TextField(controller: editController),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _tasks.doc(doc.id).update({'title': editController.text.trim()});
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // ── DELETE ──────────────────────────────────────────────
  Future<void> _deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }

  // ── UI ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CloudFirestoreExample'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          // Task List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _tasks.orderBy('created').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return ListTile(
                      title: Text(doc['title']),
                      subtitle: Text(doc['created'].toDate().toString()),
                      onTap: () => _updateTask(doc),   // tap to update
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTask(doc.id), // bin to delete
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Add Task Bar (bottom)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Task name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _addTask,
                  child: const Text('ADD'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}