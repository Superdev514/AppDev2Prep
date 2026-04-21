import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp(MaterialApp(home: StudentTeacherScreen()));
}

class StudentTeacherScreen extends StatefulWidget {
  const StudentTeacherScreen({super.key});

  @override
  State<StudentTeacherScreen> createState() => _StudentTeacherScreenState();
}

class _StudentTeacherScreenState extends State<StudentTeacherScreen> {
  late Database database;

  // Controllers
  final teacherIdController = TextEditingController();
  final teacherNameController = TextEditingController();

  final studentIdController = TextEditingController();
  final studentNameController = TextEditingController();
  final studentAgeController = TextEditingController();
  final studentTeacherIdController = TextEditingController();

  List<Map<String, dynamic>> studentList = [];

  @override
  void initState() {
    super.initState();
    initDB();
  }

  Future<void> initDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), 'student_teacher.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE teachers(
            id INTEGER PRIMARY KEY,
            name TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE students(
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER,
            teacherId INTEGER,
            FOREIGN KEY(teacherId) REFERENCES teachers(id)
          )
        ''');
      },
      version: 1,
    );

    readStudents();
  }

  // ---------------- Teacher CRUD ----------------

  Future<void> insertTeacher() async {
    await database.insert('teachers', {
      'id': int.parse(teacherIdController.text),
      'name': teacherNameController.text,
    });

    teacherIdController.clear();
    teacherNameController.clear();
  }

  Future<void> deleteTeacher() async {
    await database.delete(
      'teachers',
      where: 'id = ?',
      whereArgs: [int.parse(teacherIdController.text)],
    );

    teacherIdController.clear();
  }

  // ---------------- Student CRUD ----------------

  Future<void> insertStudent() async {
    await database.insert('students', {
      'id': int.parse(studentIdController.text),
      'name': studentNameController.text,
      'age': int.parse(studentAgeController.text),
      'teacherId': int.parse(studentTeacherIdController.text),
    });

    clearStudentFields();
    readStudents();
  }

  Future<void> updateStudent() async {
    await database.update(
      'students',
      {
        'name': studentNameController.text,
        'age': int.parse(studentAgeController.text),
        'teacherId': int.parse(studentTeacherIdController.text),
      },
      where: 'id = ?',
      whereArgs: [int.parse(studentIdController.text)],
    );

    clearStudentFields();
    readStudents();
  }

  Future<void> deleteStudent() async {
    await database.delete(
      'students',
      where: 'id = ?',
      whereArgs: [int.parse(studentIdController.text)],
    );

    clearStudentFields();
    readStudents();
  }

  Future<void> readStudents() async {
    final List<Map<String, dynamic>> result = await database.rawQuery('''
    SELECT
      students.id AS studentId,
      students.name,
      students.age,
      teachers.id AS teacherId,
      teachers.name AS teacherName
    FROM students
    LEFT JOIN teachers
    ON students.teacherId = teachers.id
  ''');

    setState(() {
      studentList = result;
    });
  }

  // TODO: ---------------- FILTER OPERATIONS ----------------

  Future<void> filterByTeacher() async {
    final result = await database.rawQuery(
      '''
    SELECT
      students.id AS studentId,
      students.name,
      students.age,
      teachers.id AS teacherId,
      teachers.name AS teacherName
    FROM students
    LEFT JOIN teachers
    ON students.teacherId = teachers.id
    WHERE teachers.id = ?
  ''',
      [int.parse(studentTeacherIdController.text)],
    );

    setState(() {
      studentList = result;
    });
  }

  Future<void> filterByAge() async {
    final result = await database.query(
      'students',
      where: 'age > ?',
      whereArgs: [int.parse(studentAgeController.text)],
    );

    setState(() {
      studentList = result;
    });
  }

  void clearStudentFields() {
    studentIdController.clear();
    studentNameController.clear();
    studentAgeController.clear();
    studentTeacherIdController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Student & Teacher CRUD")),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              "Teacher Section",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: teacherIdController,
              decoration: InputDecoration(labelText: "Teacher ID"),
            ),
            TextField(
              controller: teacherNameController,
              decoration: InputDecoration(labelText: "Teacher Name"),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: insertTeacher,
                  child: Text("Add Teacher"),
                ),
                ElevatedButton(
                  onPressed: deleteTeacher,
                  child: Text("Delete Teacher"),
                ),
              ],
            ),
            Divider(),

            Text(
              "Student Section",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            TextField(
              controller: studentIdController,
              decoration: InputDecoration(labelText: "Student ID"),
            ),
            TextField(
              controller: studentNameController,
              decoration: InputDecoration(labelText: "Student Name"),
            ),
            TextField(
              controller: studentAgeController,
              decoration: InputDecoration(labelText: "Student Age"),
            ),
            TextField(
              controller: studentTeacherIdController,
              decoration: InputDecoration(labelText: "Teacher ID (FK)"),
            ),

            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(onPressed: insertStudent, child: Text("Create")),
                ElevatedButton(onPressed: readStudents, child: Text("Read")),
                ElevatedButton(onPressed: updateStudent, child: Text("Update")),
                ElevatedButton(onPressed: deleteStudent, child: Text("Delete")),
                ElevatedButton(onPressed: filterByTeacher, child: Text("Filter Teacher")),
                ElevatedButton(onPressed: filterByAge, child: Text("Age >")),
              ],
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: studentList.map((student) {
                  return ListTile(
                    title: Text(
                      "Student ID: ${student['studentId']} - ${student['name']}",
                    ),
                    subtitle: Text(
                      "Student Age: ${student['age']} | Teacher ID: ${student['teacherId']} | Teacher Name: ${student['teacherName']}",
                    ),
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
