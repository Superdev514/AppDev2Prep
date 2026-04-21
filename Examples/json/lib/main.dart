import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(home: LocalJSON()));
}

class LocalJSON extends StatefulWidget {
  const LocalJSON({super.key});

  @override
  State<LocalJSON> createState() => _LocalJSONState();
}

class _LocalJSONState extends State<LocalJSON> {
  //TODO: Create a list container
  List _items = [];

  //TODO: Create a fn to read the json data
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/sample.json');
    //json decode is the function that converts the stream cloud data to dart object
    final data = await json.decode(response);
    setState(() {
      _items = data["items"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('local Json'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.cyanAccent,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(onPressed: readJson, child: Text('Fetch Data')),
            SizedBox(height: 10),
            //Call the expanded widget to create the listview
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: Text(_items[index]["id"]),
                            title: Text(_items[index]["name"]),
                            subtitle: Text(_items[index]["description"]),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
