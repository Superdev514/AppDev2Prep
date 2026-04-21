import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home:  MyApp()));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //set the initial value when launched
  int _value = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slider Demo'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.volume_up,
              size: 40,
            ),
            Expanded(
                child: Slider(
                  value: _value.toDouble(),
                  max: 10,
                  divisions: 10,
                  activeColor: Colors.green,
                  inactiveColor: Colors.redAccent,
                  label: 'set your volume',
                  onChanged: (double newValue) {
                    setState(() {
                      _value = newValue.round();
                    });
                  },
                )
            )
          ],
        ),
      ),
    );
  }
}
