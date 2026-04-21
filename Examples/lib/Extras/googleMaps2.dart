
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Google Maps directions URL
  // origin    = starting point (lat, lng)
  // destination = end point (lat, lng)
  static const String _googleMapsUrl =
      'https://www.google.com/maps/dir/?api=1'
      '&origin=45.5144626,-73.6755719'
      '&destination=45.501689,-73.567256';

  Future<void> _openMap() async {
    final Uri url = Uri.parse(_googleMapsUrl);

    // launchUrl opens the URL in an external app (Google Maps or browser)
    final bool launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      throw Exception('Could not open Google Maps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Simple Directions'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ElevatedButton.icon(
            onPressed: _openMap,
            icon: const Icon(Icons.directions),
            label: const Text('Open Directions in Google Maps'),
          ),
        ),
      ),
    );
  }
}