import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

class RiceClassifier {
  late Interpreter _interpreter;
  bool _isLoaded = false;

  final List<String> labels = [
    '1508',
    'Seela',
    'Sufaid',
    'ari',
    'kachi',
    'kachi_kainat',
    'super',
  ];

  bool get isLoaded => _isLoaded;

  /// Load TFLite model
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('rice_mobilenetv3.tflite');
      _isLoaded = true;
      print("✅ Rice model loaded");
    } catch (e) {
      print("❌ Failed to load model: $e");
      rethrow;
    }
  }

  /// Predict rice type from image bytes
  Future<Map<String, dynamic>> predict(Uint8List imageBytes) async {
    if (!_isLoaded) {
      throw Exception("Model not loaded yet");
    }

    // Decode image
    final image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Image decoding failed");
    }

    // Resize to 224x224
    final resized = img.copyResize(image, width: 224, height: 224);

    // Prepare input tensor [1, 224, 224, 3] with normalization [-1, 1]
   final input = List.generate(1, (_) => List.generate(
    224, (y) => List.generate(
      224, (x) {
        final pixel = resized.getPixel(x, y);
        return [
          (pixel.r / 127.5) - 1.0, // Red channel normalized [-1, 1]
          (pixel.g / 127.5) - 1.0, // Green channel normalized [-1, 1]
          (pixel.b / 127.5) - 1.0, // Blue channel normalized [-1, 1]
        ];
      }
    )
  ));

    // Prepare output tensor [1, 7]
    final output = List.generate(1, (_) => List.filled(labels.length, 0.0));

    // Run inference
    _interpreter.run(input, output);

    // Softmax
    final probs = _softmax(output[0]);

    // Find max probability index
    int maxIndex = 0;
    double maxValue = probs[0];
    for (int i = 1; i < probs.length; i++) {
      if (probs[i] > maxValue) {
        maxValue = probs[i];
        maxIndex = i;
      }
    }

    return {
      'label': labels[maxIndex],
      'confidence': maxValue * 100,
    };
  }

  /// Softmax function
  List<double> _softmax(List<double> logits) {
    final expValues = logits.map((e) => math.exp(e)).toList();
    final sum = expValues.reduce((a, b) => a + b);
    return expValues.map<double>((e) => e / sum).toList();
  }
}
