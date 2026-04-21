import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home:  MyApp()));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //call the datetime class to capture the present time
  DateTime currentDate = DateTime.now();
  //build a context that creates the date picker and attach
  //to the buildcontext
  Future<void> _selectedDate (BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      initialDate: currentDate,
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
    );
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('date picker'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(currentDate.toString()),
            SizedBox(height: 10,),
            ElevatedButton(
                onPressed: () => _selectedDate(context),
                child: Text('Select a new Date')
            ),
          ],
        ),
      ),
    );
  }
}
