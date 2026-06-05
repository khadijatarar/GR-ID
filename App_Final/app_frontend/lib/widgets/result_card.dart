import 'dart:ui';
import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final Map<String, String>? rice;
  final double confidence;

  const ResultCard({
    required this.rice,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    if (rice == null) {
      return const Center(
        child: Text(
          "No data available",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // 🌾 NAME + CONFIDENCE + DESCRIPTION
        glassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rice!["name"] ?? "Unknown",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Confidence: ${(confidence * 100).toStringAsFixed(2)}%",
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                rice!["description"] ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // 🌱 AGRONOMY
        section("🌱 Agronomy", [
          info("Variety", rice!["variety"]),
          info("Season", rice!["season"]),
          info("Sowing", rice!["sowing"]),
          info("Harvest", rice!["harvest"]),
          info("Growth Duration", rice!["growth_duration"]),
          info("Region", rice!["region"]),
          info("Water Requirement", rice!["water_requirement"]),
          info("Yield", rice!["yield"]),
        ]),

        // 🍚 GRAIN PROPERTIES
        section("🍚 Grain Properties", [
          info("Type", rice!["grain_type"]),
          info("Milled Length", rice!["milled_length"]),
          info("Cooked Length", rice!["cooked_length"]),
          info("Color", rice!["color"]),
          info("Texture", rice!["texture"]),
          info("Breakage", rice!["breakage"]),
        ]),

        // 🌸 QUALITY
        section("🌸 Quality", [
          info("Aroma", rice!["aroma"]),
          info("Amylose", rice!["amylose"]),
          info("Aging", rice!["aging"]),
        ]),

        // ⚙️ PROCESSING
        section("⚙️ Processing", [
          info("Method", rice!["processing"]),
          info("Effect", rice!["effect"]),
        ]),

        // 📦 MARKET
        section("📦 Market", [
          info("Market", rice!["market"]),
          info("Demand", rice!["demand"]),
        ]),

        // 🍽️ USAGE
        section("🍽️ Usage", [
          info("Use", rice!["use"]),
        ]),
      ],
    );
  }

  // 🌟 GLASS CARD
  Widget glassCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // 🔹 SECTION
  Widget section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        glassCard(
          child: Column(children: children),
        ),
      ],
    );
  }

  // 🔹 INFO ROW
  Widget info(String title, String? value) {
    if (value == null) return const SizedBox(); // clean UI

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}