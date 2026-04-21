import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Student.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentTable(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class StudentTable extends StatefulWidget {
  const StudentTable({super.key});

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {

  //TODO: Create an instance for the database
  late Database database;

  //TODO: Create the textcontrollers in order to input
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  //TODO: In order to create multiple instance of an object, you would need a container
  //List of students
  List<Student> studentList = [];

  //TODO: Create a method that will be executed upon app startup
  //Create a method to create the database and tables to manipulated
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TODO: Create the initDB();
    initDB();
  }

  //TODO: Create the database
  Future<void> initDB() async{
    database =
      await openDatabase(join(await getDatabasesPath(), 'students_data.path'),
        onCreate: (db, version){
          return db.execute(
            'create table students (id integer primary key, name text, age integer)'
          );
        }, version: 1
      );
  }
  //TODO: ---------------- STUDENT CRUD ----------------
  //TODO: CREATE
  Future<void> addStudent() async {
    final student = Student(
        id: int.parse(idController.text),
        name: nameController.text,
        age: int.parse(ageController.text));
    await database.insert('students', student.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    clearFields();
    readStudents();
  }

  //TODO: READ
  Future<void> readStudents() async {
    //the object maps contain the entire dogs table content
    final List<Map<String, Object?>> maps = await database.query('students');
    //setstate is called here to display the table dynamically
    //this doglist contain extract the db project to dart object
    //map fn is to transform and Map is to access the key, value pair
    setState(() {
      studentList = maps
          .map((map) => Student(
          id: map['id'] as int,
          name: map['name'] as String,
          age: map['age'] as int))
          .toList();
    });
  }

  //TODO: UPDATE
  Future<void> updateStudent() async {
    final student = Student(
        id: int.parse(idController.text),
        name: nameController.text,
        age: int.parse(ageController.text)
    );
    await database
        .update('students', student.toMap(), where: 'id = ?', whereArgs: [student.id]);

    clearFields();
    readStudents();
  }

  //TODO: DELETE
  Future<void> deleteStudent() async {
    int id = int.parse(idController.text);
    await database.delete('students', where: 'id = ?', whereArgs: [id]);
    clearFields();
    readStudents();
  }

  //TODO: Method to delete contents inside the text controllers
  clearFields() {
    idController.clear();
    nameController.clear();
    ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQL CRUD Example'),
        centerTitle: true,
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Enter Student ID'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Enter Student Name'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Enter Student Age'),
            ),
            SizedBox(
              height: 10,
            ),
            // CRUD buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: addStudent, child: Text('Create')),
                ElevatedButton(onPressed: readStudents, child: Text('Display')),
                ElevatedButton(onPressed: updateStudent, child: Text('Update')),
                ElevatedButton(onPressed: deleteStudent, child: Text('Delete')),
              ],
            ),
            SizedBox(
              height: 10,
            ),

            //Use Expanded to avoid the animation conflict
            Expanded(
              //listview will be used to display all the student instances
              child: ListView(
                children: studentList.map((student) {
                  return ListTile(
                    title: Text(student.name),
                    subtitle: Text("Age : ${student.age} | ID: ${student.id}"),
                  );
                }).toList(),
              )),
          ],
        ),
      ),
    );
  }
}

