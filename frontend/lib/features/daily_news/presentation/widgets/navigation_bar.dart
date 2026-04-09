import 'package:flutter/material.dart';

class KineticNavigationBar extends StatelessWidget {
  final String currentRoute;
  const KineticNavigationBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      height: 85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE6EFFF).withOpacity(0.9),
            const Color(0xFFFFFFFF).withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D5AFF).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            context,
            icon: Icons.newspaper_rounded,
            label: "FEED",
            isSelected: currentRoute == '/',
            onTap: () {
              if (currentRoute != '/') {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.dashboard_customize_rounded,
            label: "MANAGE",
            isSelected: currentRoute == '/ManageArticle',
            onTap: () {
              if (currentRoute != '/ManageArticle') {
                Navigator.pushReplacementNamed(context, '/ManageArticle');
              }
            },
          ),
          _buildNavItem(
            context,
            icon: Icons.person_pin_rounded,
            label: "PROFILE",
            isSelected: currentRoute == '/Profile',
            onTap: () {
              if (currentRoute != '/Profile') {
                Navigator.pushReplacementNamed(context, '/Profile');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon,
      required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2D5AFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF1A1A40),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: isSelected ? Colors.white : const Color(0xFF1A1A40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
