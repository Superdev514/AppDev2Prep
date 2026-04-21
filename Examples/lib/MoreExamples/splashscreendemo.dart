import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

//code for splash scree
void main() {
  runApp(const MaterialApp(home:  MyApp()));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 4,
        navigateAfterSeconds: Mymainclass(),
        title: Text(
          'Welcome to my app',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        image: Image.network('https://cdn.fufu.gg/uploads/mblpysrg6eq4t.jpg'),
        photoSize: 100,
        loaderColor: Colors.blueAccent,
        backgroundColor: Colors.grey,
        styleTextUnderTheLoader: TextStyle(),
        loadingText: Text('Prepare your experience...', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
        loadingTextPadding: EdgeInsets.only(top: 20),
        useLoader: true
    );

  }
}

class Mymainclass extends StatelessWidget {
  const Mymainclass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('landing page'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('my home page')
          ],
        ),
      ),
    );
  }
}





