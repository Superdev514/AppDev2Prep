import 'dart:convert';
import 'user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//write a function to read the cloud JSON
Future<List<User>> fetchUser() async {
  //user http to get the data from the restful server
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    //if the server did return a 200 OK response, then parse the JSON
    //json code is to convert the data to dart map function
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((user) => User.fromJson(user)).toList();
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
      home: ReadCloudData(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ReadCloudData extends StatefulWidget {
  const ReadCloudData({super.key});

  @override
  State<ReadCloudData> createState() => _ReadCloudDataState();
}

class _ReadCloudDataState extends State<ReadCloudData> {
  //create an object that takes the user value
  late Future<List<User>> futureUser;

  //call the initstate
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureUser = fetchUser();
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
      body: FutureBuilder<List<User>>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(8.0), // Adds margin
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return Card(
                  child: ListTile(
                    title: Text(user.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${user.id}'),
                        Text('Email: ${user.email}'),
                        Text('Phone: ${user.phone}'),
                        Text('Company: ${user.company?.name ?? 'N/A'}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
