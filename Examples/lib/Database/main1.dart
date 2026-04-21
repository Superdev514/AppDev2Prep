
import 'package:flutter/material.dart';
import 'package:examappdev/DatabaseHelper.dart';
import 'package:examappdev/User.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Controllers for the text fields
  final _nameController  = TextEditingController();
  final _emailController = TextEditingController();

  List<User> _users = [];       // holds all users shown in the list
  User? _selectedUser;          // holds the user being edited (null = add mode)

  @override
  void initState() {
    super.initState();
    _loadUsers(); // load users when screen opens
  }

  // ── READ ──────────────────────────────────────────
  Future<void> _loadUsers() async {
    final users = await DatabaseHelper.getAllUsers();
    setState(() => _users = users);
  }

  // ── INSERT / UPDATE ───────────────────────────────
  Future<void> _saveUser() async {
    final name  = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      _showSnack('Please fill in both fields');
      return;
    }

    if (_selectedUser == null) {
      // INSERT mode
      await DatabaseHelper.insertUser(User(name: name, email: email));
      _showSnack('User added!');
    } else {
      // UPDATE mode
      await DatabaseHelper.updateUser(
        User(id: _selectedUser!.id, name: name, email: email),
      );
      _showSnack('User updated!');
    }

    _clearForm();
    _loadUsers();
  }

  // ── DELETE ────────────────────────────────────────
  Future<void> _deleteUser(int id) async {
    await DatabaseHelper.deleteUser(id);
    _showSnack('User deleted');
    _clearForm();
    _loadUsers();
  }

  // ── HELPERS ───────────────────────────────────────
  void _selectForEdit(User user) {
    setState(() {
      _selectedUser          = user;
      _nameController.text   = user.name;
      _emailController.text  = user.email;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    setState(() => _selectedUser = null);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ── UI ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SQLite CRUD Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ── FORM ──
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _selectedUser == null ? 'Add User' : 'Edit User #${_selectedUser!.id}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveUser,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                            child: Text(
                              _selectedUser == null ? 'Insert' : 'Update',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        if (_selectedUser != null) ...[
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _clearForm,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                        ]
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── USER LIST ──
            Expanded(
              child: _users.isEmpty
                  ? const Center(child: Text('No users yet. Add one above!'))
                  : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // EDIT button
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _selectForEdit(user),
                          ),
                          // DELETE button
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user.id!),
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
      ),
    );
  }
}