
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _cameraFile;                          // holds the captured photo
  final ImagePicker _picker = ImagePicker(); // reuse one picker instance

  // opens the camera and stores the captured photo
  Future<void> _selectFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,   // compress slightly to save memory
    );

    if (pickedFile != null) {
      setState(() {
        _cameraFile = File(pickedFile.path);
      });
    }
  }

  // opens the gallery instead of camera
  Future<void> _selectFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _cameraFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Access'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ── BUTTONS ──
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _selectFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _selectFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── IMAGE PREVIEW ──
            Container(
              height: 300.0,
              width: 300.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _cameraFile == null
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 60, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'No photo selected',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _cameraFile!,
                  fit: BoxFit.cover, // fills the container neatly
                ),
              ),
            ),

            // ── CLEAR BUTTON (only shows when a photo is selected) ──
            if (_cameraFile != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => setState(() => _cameraFile = null),
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Clear photo',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }
}