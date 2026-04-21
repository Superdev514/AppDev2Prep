import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'Dog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DogTable(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DogTable extends StatefulWidget {
  const DogTable({super.key});

  @override
  State<DogTable> createState() => _DogTableState();
}

class _DogTableState extends State<DogTable> {
  late Database database;

  final TextEditingController idController   = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController  = TextEditingController();

  List<Dog> dogList = [];

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    database = await openDatabase(
      path.join(await getDatabasesPath(), 'dogs_data.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
    readDogs(); // ✅ load existing dogs after DB is ready
  }

  Future<void> addDog() async {
    // ✅ validate fields before parsing
    if (idController.text.isEmpty ||
        nameController.text.isEmpty ||
        ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final dog = Dog(
      id:   int.parse(idController.text),
      name: nameController.text,
      age:  int.parse(ageController.text),
    );

    await database.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    clearFields();
    readDogs();
  }

  Future<void> readDogs() async {
    final List<Map<String, Object?>> maps = await database.query('dogs');
    setState(() {
      dogList = maps
          .map((map) => Dog(
        id:   map['id']   as int,
        name: map['name'] as String,
        age:  map['age']  as int,
      ))
          .toList();
    });
  }

  Future<void> updateDog() async {
    if (idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the ID of the dog to update')),
      );
      return;
    }

    final dog = Dog(
      id:   int.parse(idController.text),
      name: nameController.text,
      age:  int.parse(ageController.text),
    );

    await database.update(
      'dogs',
      dog.toMap(),
      where: 'id = ?',
      whereArgs: [dog.id],
    );

    clearFields();
    readDogs();
  }

  Future<void> deleteDog() async {
    if (idController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter the ID of the dog to delete')),
      );
      return;
    }

    int id = int.parse(idController.text);
    await database.delete('dogs', where: 'id = ?', whereArgs: [id]);

    clearFields();
    readDogs();
  }

  void clearFields() {
    idController.clear();
    nameController.clear();
    ageController.clear();
  }

  // ✅ tap a dog in the list to auto-fill the fields for editing
  void selectDog(Dog dog) {
    setState(() {
      idController.text   = dog.id.toString();
      nameController.text = dog.name;
      ageController.text  = dog.age.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog DB Demo'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── TEXT FIELDS ──
            TextField(
              controller: idController,
              keyboardType: TextInputType.number, // ✅ number keyboard for id
              decoration: const InputDecoration(labelText: 'Enter the ID'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Enter the name'),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number, // ✅ number keyboard for age
              decoration: const InputDecoration(labelText: 'Enter the age'),
            ),
            const SizedBox(height: 20),

            // ── CRUD BUTTONS ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: addDog,    child: const Text('Create')),
                ElevatedButton(onPressed: readDogs,  child: const Text('Display')),
                ElevatedButton(onPressed: updateDog, child: const Text('Update')),
                ElevatedButton(onPressed: deleteDog, child: const Text('Delete')),
              ],
            ),
            const SizedBox(height: 10),

            // ── DOG LIST ──
            Expanded(
              child: dogList.isEmpty
                  ? const Center(child: Text('No dogs yet. Add one!'))
                  : ListView(
                children: dogList.map((dog) {
                  return ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(dog.name),
                    subtitle: Text('Age: ${dog.age} | ID: ${dog.id}'),
                    trailing: const Icon(Icons.pets),
                    onTap: () => selectDog(dog), // ✅ tap to auto-fill fields
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}