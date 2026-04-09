import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app_clean_architecture/core/services/profile_service.dart';

class KineticDrawer extends StatelessWidget {
  const KineticDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: (MediaQuery.of(context).size.width * 0.85).clamp(280.0, 350.0),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    FutureBuilder<Map<String, String?>>(
                      future: ProfileService.getProfile(),
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        return _buildUserProfile(
                          name: data?['name'] ?? "Julian Vance",
                          imageUrl: data?['imageUrl'] ??
                              'https://i.pravatar.cc/150?u=julian',
                        );
                      },
                    ),
                    const SizedBox(height: 48),
                    _buildSectionHeader("EDITORIAL DESK"),
                    _buildDrawerItem(Icons.trending_up, "Technology",
                        trailingIcon: Icons.auto_graph_outlined),
                    _buildDrawerItem(Icons.public, "Politics",
                        trailingIcon: Icons.public_outlined),
                    _buildDrawerItem(Icons.palette_outlined, "Culture",
                        trailingIcon: Icons.stars_outlined),
                    _buildDrawerItem(Icons.eco_outlined, "Environment",
                        trailingIcon: Icons.water_drop_outlined),
                    _buildDrawerItem(Icons.payments_outlined, "Finance",
                        trailingIcon: Icons.show_chart_outlined),
                    const SizedBox(height: 40),
                    _buildSectionHeader("WORKSPACE"),
                    _buildDrawerItem(Icons.bookmark, "Saved Articles",
                        color: const Color(0xFF2D5AFF)),
                    _buildDrawerItem(Icons.settings, "Settings",
                        color: const Color(0xFF2D5AFF)),
                  ],
                ),
              ),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF1A1A40)),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            "THE KINETIC",
            style: TextStyle(
              color: Color(0xFF2D5AFF),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile({required String name, required String imageUrl}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE0E3FF), width: 2),
          ),
          child: CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(imageUrl),
            backgroundColor: const Color(0xFFE8E8F3),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1A1A40),
              ),
            ),
            const Text(
              "Premium Status",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1A1A40).withOpacity(0.5),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title,
      {IconData? trailingIcon, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: color ?? const Color(0xFF1A1A40), size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A40),
              ),
            ),
          ),
          if (trailingIcon != null)
            Icon(trailingIcon,
                color: const Color(0xFF1A1A40).withOpacity(0.2), size: 16),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFF),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                if (kIsWeb) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                } else {
                  SystemNavigator.pop();
                }
              },
              icon:
                  const Icon(Icons.logout, color: Color(0xFFE11D48), size: 18),
              label: const Text(
                "LOGOUT",
                style: TextStyle(
                  color: Color(0xFFE11D48),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "V2.4.0",
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.withOpacity(0.6)),
              ),
              const SizedBox(width: 12),
              const Text("•", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 12),
              Text(
                "PRIVACY POLICY",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
