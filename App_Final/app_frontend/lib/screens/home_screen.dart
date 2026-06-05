import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../widgets/upload_button.dart';
import '../widgets/loading_widget.dart';
import '../widgets/glass_container.dart';
import 'result_screen.dart';
import '../services/db_service.dart';
import 'history_screen.dart';
import '../utils/constants.dart';
import 'start_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final picker = ImagePicker();
  bool isLoading = false;

  Future<void> pickImage(ImageSource source) async {
    final picked = await picker.pickImage(source: source);
    if (picked == null) return;

    setState(() => isLoading = true);

    try {
      var result = await ApiService.predictImage(picked.path);

      if (result == null ||
          result["detections"] == null ||
          result["detections"].isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No rice detected")),
        );
        setState(() => isLoading = false);
        return;
      }

      final detections = result["detections"];
      final first = detections[0];

      final classIndex = first["class"];

      final label =
          AppConstants.riceDetails[classIndex]?["name"] ?? "Unknown";

      final confidence = (first["confidence"] as num).toDouble();

      await DBService.insertPrediction({
        "imagePath": picked.path,
        "label": label,
        "confidence": confidence,
        "date": DateFormat('dd MMM yyyy • hh:mm a').format(DateTime.now())
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            imagePath: picked.path,
            result: result,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  void showPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return GlassContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text("Camera",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image, color: Colors.white),
                title: const Text("Gallery",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget featureCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => StartScreen()),
          (route) => false,
        );
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0F172A),
                    Color(0xFF1E293B),
                    Color(0xFF0B1220),
                  ],
                ),
              ),
            ),

            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent.withOpacity(0.08),
                ),
              ),
            ),

            Positioned(
              bottom: -100,
              right: -80,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.tealAccent.withOpacity(0.06),
                ),
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Image.asset(
                          "assets/images/logo.png",
                          height: 75,
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "GR-ID",
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 6),

                      const Text(
                        "AI-powered Rice Classification System",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: const Text(
                          "GR-ID uses deep learning (YOLO-based model) to detect and classify rice varieties with high accuracy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ FIXED GRID (ALL SAME SIZE)
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.2,
                        children: [
                          featureCard(
                            icon: Icons.bolt,
                            title: "Fast Detection",
                            desc: "Instant AI prediction",
                          ),
                          featureCard(
                            icon: Icons.grain,
                            title: "5 Rice Types",
                            desc: "Multiple varieties supported",
                          ),
                          featureCard(
                            icon: Icons.memory,
                            title: "AI Model",
                            desc: "YOLO deep learning",
                          ),
                          featureCard(
                            icon: Icons.verified,
                            title: "High Accuracy",
                            desc: "Trained dataset model",
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      UploadButton(onTap: showPicker),

                      const SizedBox(height: 15),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.08),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => HistoryScreen()),
                          );
                        },
                        icon: const Icon(Icons.history),
                        label: const Text("View Prediction History"),
                      ),

                      const SizedBox(height: 20),

                      if (isLoading)
                        Column(
                          children: [
                            LoadingWidget(),
                            const SizedBox(height: 10),
                            const Text(
                              "Analyzing Rice Image...",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}