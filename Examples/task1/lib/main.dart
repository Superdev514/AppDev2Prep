import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Use API key to connect the platform to the cloud base
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBBZDnIZDSJqXGg71anDhoSxSv1M6jusAY',
      appId: '1083191189494',
      messagingSenderId: '1:1083191189494:android:a6ebe72af30944e03f71d7',
      projectId: 'test2-61d2a',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirestoreExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirestoreExample extends StatefulWidget {
  const FirestoreExample({super.key});

  @override
  State<FirestoreExample> createState() => _FirestoreExampleState();
}

class _FirestoreExampleState extends State<FirestoreExample> {
  //TODO: Create a cloud database using CollectionReference
  CollectionReference tasks = FirebaseFirestore.instance.collection('task');

  String task = '';
  String time = '';

  // add the user instance to the cloud firestore
  Future<void> addTask() async {
    if (task.isNotEmpty) {
      await tasks.add({'task': task, 'time': FieldValue.serverTimestamp()});
      setState(() {
        task = '';
        time = '';
      });
    }
  }

  // delete a user from firestore based
  Future<void> deleteUser(String task) async {
    await tasks.doc(task).delete();
  }

  // update a user
  Future<void> updateTask(String id) async {
    await tasks.doc(id).update({'task': task, 'time': FieldValue.serverTimestamp()});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' User management using Fire Store'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 60,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => task = value,
                  decoration: InputDecoration(hintText: 'Task name'),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: addTask,
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          //Display the cloud data using StreamBuilder
          //we have to use the snapshot i.e., immutable db chunk so that
          //i can query for data manipulation
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: tasks.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('Loading ...');
                return ListView(
                  //Write the map function to convert the fs data to dart objects
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['task']),
                      subtitle: Text('Time: ${doc['time']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                //user must tap button
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Update Task'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Task'),
                                          TextField(
                                            onChanged: (value) => task = value,
                                            decoration: InputDecoration(
                                              hintText: 'Enter new Task',
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              updateTask(doc.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Update User'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () => deleteUser(doc.id),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
