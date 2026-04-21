import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// ── MODEL ──────────────────────────────────────────
class Post {
  final int id;
  final String title;
  final String body;

  Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id:    json['id'],
      title: json['title'],
      body:  json['body'],
    );
  }
}

// ── HOME PAGE ──────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> _posts  = [];
  bool _isLoading    = false;
  String _error      = '';

  // ── GET all posts ──
  Future<void> fetchPosts() async {
    setState(() { _isLoading = true; _error = ''; });

    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          _posts     = jsonList.map((j) => Post.fromJson(j)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error     = 'Error: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() { _error = 'Network error: $e'; _isLoading = false; });
    }
  }

  // ── POST a new post ──
  Future<void> createPost() async {
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': 'Test Post', 'body': 'Hello!', 'userId': 1}),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── BUTTONS ──
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: fetchPosts,
                    child: const Text('GET Posts'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: createPost,
                    child: const Text('POST'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── STATE DISPLAY ──
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_error.isNotEmpty)
              Text(_error, style: const TextStyle(color: Colors.red))
            else if (_posts.isEmpty)
                const Text('Press GET Posts to load data')
              else

              // ── POST LIST ──
                Expanded(
                  child: ListView.builder(
                    itemCount: _posts.length,
                    itemBuilder: (context, index) {
                      final post = _posts[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${post.id}')),
                          title: Text(post.title),
                          subtitle: Text(post.body, maxLines: 1,
                              overflow: TextOverflow.ellipsis),
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