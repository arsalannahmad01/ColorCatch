// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ColorCard extends StatelessWidget {
  final Color color;
  final String colorCode;
  const ColorCard({super.key, required this.color, required this.colorCode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 105,
            height: 75,
            color: color,
          ),
          SizedBox(height: 6),
          Text(
            colorCode,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
