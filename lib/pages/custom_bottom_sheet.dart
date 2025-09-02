import 'package:flutter/material.dart';

import '../item_list.dart';

class CustomBottomSheet extends StatelessWidget {
  final DateTime selectedDay;
  final Map<String, WidgetBuilder> pages;

  const CustomBottomSheet({
    super.key,
    required this.selectedDay,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Tipe Input',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pilih tipe input yang ingin dimasukkan',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ...pages.entries.map((entry) {
            return ItemList(
              title: entry.key,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: entry.value),
                );
              },
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}