import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home:  MyApp()));
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Progress(),
//     );
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _ProgressState();
}

class _ProgressState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.redAccent,
              valueColor: AlwaysStoppedAnimation(Colors.green),
              strokeWidth: 10,
            ),

            LinearProgressIndicator(
              backgroundColor: Colors.redAccent,
              valueColor: AlwaysStoppedAnimation((Colors.green)),
              minHeight: 10,
            )
          ],
        ),
      ),

    );
  }
}


