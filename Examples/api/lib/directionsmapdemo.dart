import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //create an object to connect the link from the google maps

  final String googleMapsURL = "https://www.google.com/maps/dir/?api=1&origin=45.5144626,-73.6755719&destination=45.501689,-73.567256";
  //write a function that launches this url
  Future<void> _openMaps() async{
    final Uri url = Uri.parse(googleMapsURL);
    //write a if condition to check the mode of the link
    if(!await launchUrl(url, mode: LaunchMode.externalApplication)){
      throw 'could not open google maps';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Directions demo"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _openMaps,
                child: Text('Click for Directions'))
          ],
        ),
      ),
    );
  }
}
