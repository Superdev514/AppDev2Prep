import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;

  static final LatLng _center = const LatLng(45.5110537, -73.6322554);
  final Set<Marker> _markers = {};
  LatLng _currentMapLocation = _center;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Maps Controller")),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,

            initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 10.0
            ),
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                onPressed: _onAddMarkerButtonPressed,
                backgroundColor: Colors.purpleAccent,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                child: Icon(Icons.map, size: 30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    _currentMapLocation = position.target;
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker
        (markerId: MarkerId(_currentMapLocation.toString()),
          position: _currentMapLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
      ));
    });
  }
}

