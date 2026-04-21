
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

  //create a default selected interface
  int _selectedIndex = 0;

  //create the list of routes so that each
  //bottom icon will correspond to that screen

  static List<Widget> _widgetOptions = <Widget> [
    Text('Home', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
    Text('Search', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
    Text('Profile', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Bar'),
      ),

      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.green
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: Colors.orange
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blueAccent
            ),
          ],

        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
        iconSize: 40,
        elevation: 5,
        onTap: _OnItemTapped,

      ),

    );
  }

  void _OnItemTapped(int value) {
    setState(() {
      _selectedIndex = value;
    });
  }

}



