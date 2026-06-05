import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/result_card.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> result;

  const ResultScreen({
    required this.imagePath,
    required this.result,
  });

 @override
Widget build(BuildContext context) {
  final detections = result["detections"];

  if (detections == null || detections.isEmpty) {
    return Scaffold(
      body: Center(
        child: Text(
          "No rice detected",
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  final r = detections[0];

  final classIndex = r["class"];
  final rice = AppConstants.riceDetails[classIndex];

  return Scaffold(
    body: Stack(
      children: [

        // 🌈 SAME START SCREEN GRADIENT
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0B1220),
                Color(0xFF111827),
                Color(0xFF0F172A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // 🌟 TOP GLOW
        Positioned(
          top: -120,
          left: -100,
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.greenAccent.withOpacity(0.10),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.2),
                  blurRadius: 100,
                  spreadRadius: 50,
                )
              ],
            ),
          ),
        ),

        // 🌟 BOTTOM GLOW
        Positioned(
          bottom: -150,
          right: -120,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.tealAccent.withOpacity(0.08),
              boxShadow: [
                BoxShadow(
                  color: Colors.tealAccent.withOpacity(0.15),
                  blurRadius: 120,
                  spreadRadius: 60,
                )
              ],
            ),
          ),
        ),

        // 📱 CONTENT
        SafeArea(
          child: r == null
              ? const Center(
                  child: Text(
                    "No detection found",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      // 📷 IMAGE CARD (glass style)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white24),
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            File(imagePath),
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🧠 RESULT CARD
                      ResultCard(
                        rice: rice,
                        confidence: r['confidence'],
                      ),
                    ],
                  ),
                ),
        ),
      ],
    ),
  );
}
}