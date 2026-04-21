import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocalJson(),
        debugShowCheckedModeBanner: false,
    );
  }
}

class LocalJson extends StatefulWidget {
  const LocalJson({super.key});

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  //create a container to get the json objects
  List _items = [];

  //write a function to fecth the data from assets folder which is a json file

  Future<void> readJson() async {
    //there is a funcitn that access all the data from the assets
    final String response = await
    rootBundle.loadString("assets/sample.json");
    final realData = await json.decode(response);
    setState(() {
      _items = realData["items"];
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Local JSON'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.blueAccent,
        body: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: readJson,
                  child: Text("Fetch data")
              ),

              _items.isNotEmpty ?
                  Expanded(
                      child: ListView.builder(
                        //need the range/length of the list of items
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: EdgeInsets.all(16),
                            child: ListTile(
                              leading: Text(_items[index]["id"]),
                              title: Text(_items[index]["name"]),
                              subtitle: Text(_items[index]["description"]),
                            ),
                          );
                        },
                      )
                  )
              : Container()

            ],
          ),
        ),
    );
  }
}



