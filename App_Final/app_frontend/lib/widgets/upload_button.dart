import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  final VoidCallback onTap;

  const UploadButton({required this.onTap});

  @override
  State<UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPressed
                ? [Colors.greenAccent.shade400, Colors.green]
                : [Colors.greenAccent, Colors.teal],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, color: Colors.black),
            SizedBox(width: 10),
            Text(
              "Upload / Capture Image",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}