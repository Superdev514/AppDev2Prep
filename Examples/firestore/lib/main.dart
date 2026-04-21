import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Use API key to connect the platform to the cloud base
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBx2-KIgKKeN7EEl7B0e7AHcoV0wVJDllQ',
      appId: '994857903052',
      messagingSenderId: '1:994857903052:android:19ccec86f997be92a77369',
      projectId: 'test2practice-b1b34',
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
  CollectionReference users = FirebaseFirestore.instance.collection('user');

  String name = '';
  String password = '';

  // add the user instance to the cloud firestore
  Future<void> addUser() async {
    if (name.isNotEmpty && password.isNotEmpty) {
      await users.add({'name': name, 'password': password});
      setState(() {
        name = '';
        password = '';
      });
    }
  }

  // delete a user from firestore based
  Future<void> deleteUser(String id) async {
    await users.doc(id).delete();
  }

  // update a user
  Future<void> updateUser(String id) async {
    await users.doc(id).update({'name': name, 'password': password});
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
      backgroundColor: Colors.greenAccent,
      body: Column(
        children: [
          TextField(
            onChanged: (value) => name = value,
            decoration: InputDecoration(hintText: 'Enter the name'),
          ),
          SizedBox(height: 10),
          TextField(
            onChanged: (value) => password = value,
            decoration: InputDecoration(hintText: 'Enter the password'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: addUser, child: Text('Add User')),
            ],
          ),
          //Display the cloud data using StreamBuilder
          //we have to use the snapshot i.e., immutable db chunk so that
          //i can query for data manipulation
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: users.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Text('Loading ...');
                return ListView(
                  //Write the map function to convert the fs data to dart objects
                  children: snapshot.data!.docs.map((doc) {
                    return ListTile(
                      title: Text(doc['name']),
                      subtitle: Text('Password: ${doc['password']}'),
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
                                    title: Text('Update User'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Name'),
                                          TextField(
                                            onChanged: (value) => name = value,
                                            decoration: InputDecoration(
                                              hintText: 'Enter new Name',
                                            ),
                                          ),
                                          Text('Password'),
                                          TextField(
                                            onChanged: (value) =>
                                                password = value,
                                            decoration: InputDecoration(
                                              hintText: 'Enter new Password',
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              updateUser(doc.id);
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
