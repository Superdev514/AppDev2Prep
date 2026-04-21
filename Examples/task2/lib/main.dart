import 'dart:convert';
import 'jewelery.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Jewelery>> fetchJewelery() async {
  final response = await http
      .get(Uri.parse('https://fakestoreapi.com/products/category/jewelery'));

  if (response.statusCode == 200) {
    List jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((jewelery) => Jewelery.fromJson(jewelery)).toList();
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
        debugShowCheckedModeBanner: false, home: readJeweleryData());
  }
}

class readJeweleryData extends StatefulWidget {
  const readJeweleryData({super.key});

  @override
  State<readJeweleryData> createState() => _readJeweleryDataState();
}

class _readJeweleryDataState extends State<readJeweleryData> {
  late Future<List<Jewelery>> futureJewelery;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureJewelery = fetchJewelery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Wishlist',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: FutureBuilder<List<Jewelery>>(
                future: futureJewelery,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                        itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,         // Number of tiles per row
                        crossAxisSpacing: 10.0,    // Horizontal space between tiles
                        mainAxisSpacing: 10.0,     // Vertical space between rows
                        childAspectRatio: 1.0,
                      ),
                        itemBuilder: (context, index) {
                          return Card(
                            child: Column(
                              children: [
                                Text(snapshot.data![index].title),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(image: NetworkImage(snapshot.data![index].image,), height: 200,),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amberAccent,),
                                        Text('${snapshot.data![index].rating.rate} '),
                                        Text('(${snapshot.data![index].rating.count})'),
                                      ],
                                    ),

                                    Text(snapshot.data![index].description),
                                    Text('Category : ${snapshot.data![index].category}'),
                                    Text('\$${snapshot.data![index].price}'),
                                  ],
                                )
                              ],
                            ),
                              );
                        });
                  }
                  return CircularProgressIndicator();
                })));
  }
}
