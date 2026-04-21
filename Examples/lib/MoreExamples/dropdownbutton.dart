
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var items = [
    'USA', 'Japan', 'Vietnam', 'Canada', 'China'
  ];

  //select an item by default to be shown which is index 0
  String dropdownValue = 'USA';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drop down menu'),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: dropdownValue,
              //make the object compatible
              items: items.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items)
                );
              }).toList(),

              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              }

            ),
          ],
        ),
      ),

    );
  }
}
