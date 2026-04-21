import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'Album.dart';


//write a functin to fetch a cloud json

Future<List<Album>> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/')
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List jsonResponse = jsonDecode(response.body);
    //always use map functin to convert any data to dart data
    return jsonResponse.map((album) => Album.fromJson(album)).toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
//check for the network status


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CloudJSON(),
    );
  }
}

class CloudJSON extends StatefulWidget {
  const CloudJSON({super.key});

  @override
  State<CloudJSON> createState() => _CloudJSONState();
}

class _CloudJSONState extends State<CloudJSON> {

  late Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Cloud JSON'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(
        child: FutureBuilder<List<Album>> (
          future: futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index].title),
                      subtitle: Text('User ID : ${snapshot.data![index]
                          .userId}'),
                    );
                  }
              );
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

