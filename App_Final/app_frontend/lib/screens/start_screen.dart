import 'package:flutter/material.dart';
import 'home_screen.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // 🌈 BACKGROUND
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // 🔥 GRADIENT TITLE (FIXED)
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [
                      Color(0xFF34D399),
                      Color(0xFF22D3EE),
                    ],
                  ).createShader(bounds),
                  child: const Text(
                    "GR-ID",
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // required
                      letterSpacing: 2,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "AI Rice Recognition System",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 50),

                // 🚀 BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.greenAccent,
                          Colors.tealAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Text(
                      "Start Recognition",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}