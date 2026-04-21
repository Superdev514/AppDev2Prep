import 'dart:convert';
import 'album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//write a function to read the cloud JSON
Future<List<Album>> fetchAlbum() async {
  //use http to get the data from the restful server
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

  if (response.statusCode == 200) {
    //if the server did return a 200 OK response, then parse the JSON
    //jsoncode is to convert the data to dart map function
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((album) => Album.fromJson(album)).toList();
  } else {
    throw Exception('Failed to load the cloud data');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: readCloudData());
  }
}

class readCloudData extends StatefulWidget {
  const readCloudData({super.key});

  @override
  State<readCloudData> createState() => _readCloudDataState();
}

class _readCloudDataState extends State<readCloudData> {
  //create an object that takes the album value
  late Future<List<Album>> futureAlbum;

  //call the initstate
  @override
  void initState() {
    // TODO: implement initState
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Data'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: Center(
          child: FutureBuilder<List<Album>>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // return Column(
                  //   children: [
                  // Text('user ID : ${snapshot.data!.userId}'),
                  // Text('id : ${snapshot.data!.id}'),
                  // Text('Title : ${snapshot.data!.title}'),
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].title),
                          subtitle:
                          Text('User ID : ${snapshot.data![index].userId}'),
                        );
                      });
                  // ],
                  // );
                }
                return CircularProgressIndicator();
              })),
    );
  }
}
