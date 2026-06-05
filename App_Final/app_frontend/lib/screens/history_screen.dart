import 'package:flutter/material.dart';
import 'dart:io';
import '../services/db_service.dart';
import '../widgets/glass_container.dart';

class HistoryScreen extends StatefulWidget {
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> history = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    history = await DBService.getPredictions();
    setState(() {});
  }

  // 🗑️ Confirm Delete
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xFF1E293B),
        title: Text("Clear History", style: TextStyle(color: Colors.white)),
        content: Text(
          "Are you sure you want to delete all history?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              await DBService.clearHistory();
              Navigator.pop(context);
              loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget historyCard(Map<String, dynamic> item) {
    return GlassContainer(
      child: Row(
        children: [
          // 📸 IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(item["imagePath"]),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12),

          // 📊 INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["label"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  "Confidence: ${(item["confidence"] * 100).toStringAsFixed(2)}%",
                  style: TextStyle(color: Colors.greenAccent),
                ),

                SizedBox(height: 5),

                Text(
                  item["date"],
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌈 BACKGROUND
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF334155),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🔝 HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: confirmDelete,
                      )
                    ],
                  ),
                ),

                // 📜 CONTENT
                Expanded(
                  child: history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history,
                                  size: 80, color: Colors.white24),
                              SizedBox(height: 10),
                              Text(
                                "No History Yet",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final item = history[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: historyCard(item),
                            );
                          },
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