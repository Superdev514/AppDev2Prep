import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

//create a function to initiate the phone dial pad
_makeCall() async{
  const url = 'tel: 4383992365';
  if(await launch(url)){
    await launch(url);
  } else {
    throw 'Could not call this number';
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _makeCall,
                child: Text("Call"))
          ],
        ),
      ),
    );
  }
}
