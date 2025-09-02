import 'package:flutter/material.dart';

Widget infoRow(String label, String value, {bool isLast = false}) {
  return Padding(
    padding: const EdgeInsets.all(2),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        if (!isLast) ...[
          SizedBox(height: 4),
          Divider(thickness: 0.5, color: Colors.grey[200]),
        ]
      ],
    ),
  );
}