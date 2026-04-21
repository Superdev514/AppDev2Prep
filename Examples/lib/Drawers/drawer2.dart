

import 'package:examappdev/Drawers/drawer1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FavouritesPage.dart';
import 'HomePage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyDrawer2(),
    );
  }
}

class MyDrawer2 extends StatelessWidget {
  const MyDrawer2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Drawer 2"), backgroundColor: Colors.blue,),
      drawer: NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget> [
                buildHeader(context),
                buildMenuItems(context),
              ],
            ),
          ),
  );

  Widget buildHeader(BuildContext context) => Container(
          color: Colors.blue,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXHQdmdraKMXD0hDkgFyqvsQCotMFkRQsLLw&s"),
              ),
              SizedBox(height: 12,),
              Text('Deven', style: TextStyle(fontSize: 28, color: Colors.white),),
              Text('devenshahphan@gmail.com'),
            ],
          ),
  );

  Widget buildMenuItems(BuildContext context) => Column(
          children: [
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text("Home"),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomePage(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite_border),
              title: Text("Favorites"),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FavouritesPage(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.workspaces_outlined),
              title: Text("Workflow"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text("Updates"),
              onTap: () {},
            ),

            Divider(color: Colors.black26,),

            ListTile(
              leading: Icon(Icons.account_tree_outlined),
              title: Text("Plugins"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.notification_add_outlined),
              title: Text("Notifications"),
              onTap: () {},
            ),
          ],
  );

}


