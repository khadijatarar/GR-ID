import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        CircularProgressIndicator(),
        SizedBox(height: 10)
      ],
    );
  }
}