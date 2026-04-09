import 'package:flutter/material.dart';

class GrowthInsightCard extends StatelessWidget {
  final VoidCallback onPressed;

  const GrowthInsightCard({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.trending_up, color: Color(0xFF5C79FF)),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Growth Insight",
                    style: TextStyle(
                        fontWeight: FontWeight.w900, color: Color(0xFF1A1A40)),
                  ),
                  Text(
                    "+12% engagement this month",
                    style: TextStyle(color: Color(0xFF5D5D81), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.add, size: 18),
              label: const Text(
                "CREATE NEW STORY",
                style:
                    TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C79FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
