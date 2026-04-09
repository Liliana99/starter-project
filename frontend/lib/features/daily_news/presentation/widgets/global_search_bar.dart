import 'package:flutter/material.dart';

class GlobalSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const GlobalSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: "Search in your 'Perfect Archive'...",
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF5C79FF)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF5C79FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tune_rounded,
                size: 20, color: Color(0xFF5C79FF)),
          ),
        ),
      ),
    );
  }
}
