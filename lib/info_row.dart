import 'package:alkarim/theme/app_colors.dart';
import 'package:flutter/material.dart';

Widget infoRow(String label, String value, {bool isHighlighted = false, bool isLast = false}) {
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
        isHighlighted
        ? Container(
            decoration: BoxDecoration(
              color: value == 'Lulus' || value == 'Lanjut' || value == 'Tidak Lulus' || value == 'Ulang' ? _getLulusColor(value).withValues(alpha: 0.1) : _getPredikatColor(value).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: value == 'Lulus' || value == 'Lanjut' || value == 'Tidak lulus' || value == 'Ulang' ? _getLulusColor(value).withValues(alpha: 0.9) : _getPredikatColor(value).withValues(alpha: 0.9),
                )
              ),
            )
        )
        : Text(
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

Color _getPredikatColor(String value) {
  switch (value) {
    case 'Mumtaz':
      return Colors.purple;
    case 'Jayyid Jiddan':
      return Colors.green;
    case 'Jayyid':
      return AppColors.secondary;
    case 'Tidak Lulus':
      return Colors.red;
    default:
      return Colors.red;
  }
}

Color _getLulusColor(String value) {
  if (value == 'Lulus' || value == 'Lanjut') {
    return Colors.green;
  } else {
    return Colors.red;
  }
}