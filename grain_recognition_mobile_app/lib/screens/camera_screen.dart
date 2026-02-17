import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../ml/rice_classifier.dart';
import 'result_screen.dart';
import 'package:flutter/services.dart'; // needed for rootBundle


class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  bool _isLoading = false; // For classification
  bool _modelLoaded = false; // For model readiness

  final ImagePicker _picker = ImagePicker();
  final RiceClassifier classifier = RiceClassifier();

  @override
  void initState() {
    super.initState();
    _loadModel();
    testModelAsset(); 
  }

  Future<void> testModelAsset() async {
    try {
      final byteData = await rootBundle.load('assets/rice_mobilenetv3.tflite');
      print('✅ Model loaded! Length: ${byteData.lengthInBytes} bytes');
    } catch (e) {
      print('❌ Failed to load model asset: $e');
    }
  }


  // Load model asynchronously
  Future<void> _loadModel() async {
    try {
      print("Loading model...");
      await classifier.loadModel();
      setState(() {
        _modelLoaded = true;
      });
      print("✅ Model loaded!");
    } catch (e) {
      print("❌ Failed to load model: $e");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _classifyImage() async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      print("CLASSIFY BUTTON PRESSED");
      print("Reading image bytes...");

      final bytes = await _image!.readAsBytes();
      print("Image bytes length: ${bytes.length}");

      final result = await classifier.predict(bytes);
      print("Result: $result");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            image: _image!,
            label: result['label'],
            confidence: result['confidence'],
          ),
        ),
      );
    } catch (e, stack) {
      print("❌ CLASSIFICATION FAILED");
      print(e);
      print(stack);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to classify image")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EC),
      appBar: AppBar(
        title: const Text('Rice Classification'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.agriculture,
              size: 40,
              color: Color(0xFFFF9800),
            ),
            const SizedBox(height: 10),


            const Text(
              "Grain Recognition",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Capture or select a grain image to classify",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30),
              // image preview 

            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _image!,
                          width: 230,
                          height: 230,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 230,
                        height: 230,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE0B2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 80,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 40),


            // Camera & Gallery buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white, 
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white, 
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Text(
              "Supported formats: JPG, PNG",
              style: TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
            ),


            const SizedBox(height: 30),

            // Classify button
            ElevatedButton(
              onPressed: (_modelLoaded && !_isLoading) ? _classifyImage : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9800), // orange
                disabledBackgroundColor: const Color(0xFFFFE0B2),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      "Classify Image",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

