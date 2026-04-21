import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'photo.dart';

//write a function to read the cloud JSON
Future<List<Photo>> fetchPhoto() async {
  //use http to get the data from the restful server
  final response =
  await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  if (response.statusCode == 200) {
    //if the server did return a 200 OK response, then parse the JSON
    //jsoncode is to convert the data to dart map function
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((photo) => Photo.fromJson(photo)).toList();
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
  late Future<List<Photo>> futurePhoto;

  //call the initstate
  @override
  void initState() {
    // TODO: implement initState
    futurePhoto = fetchPhoto();
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
          child: FutureBuilder<List<Photo>>(
              future: futurePhoto,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                NetworkImage(snapshot.data![index].url),
                              ),
                              Column(
                                children: [
                                  Text(snapshot.data![index].title),
                                  Text('Album ID : ${snapshot.data![index].albumId}'),
                                  Text('ID : ${snapshot.data![index].id}'),
                                ],
                              ),
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data![index].thumbnailUrl),
                              )
                            ],
                          ),
                        );
                      }
                  );
                }
                return CircularProgressIndicator();
              })),
    );
  }
}
