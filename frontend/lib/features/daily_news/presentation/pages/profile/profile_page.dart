import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/core/services/notification_service.dart';
import '../../widgets/navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "Julianne Vane");
  final TextEditingController _bioController = TextEditingController(
      text:
          "Digital curator and tech enthusiast exploring the boundaries of kinetic design and modern storytelling.");

  String? _imageUrl;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FF),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            GestureDetector(onTap: _pickImage, child: _buildAvatarSection()),
            const SizedBox(height: 24),
            _buildTitleSection(),
            const SizedBox(height: 48),
            _buildInputField(
              label: "FULL NAME",
              controller: _nameController,
            ),
            const SizedBox(height: 24),
            _buildInputField(
              label: "BIO",
              controller: _bioController,
              maxLines: 4,
            ),
            const SizedBox(height: 48),
            _buildSaveButton(),
            const SizedBox(height: 40),
            _buildDeleteAccount(),
            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomNavigationBar: const KineticNavigationBar(currentRoute: '/Profile'),
      extendBody: true,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A40)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "KINETIC",
        style: TextStyle(
          color: Color(0xFF2D5AFF),
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              image: _imageUrl != null
                  ? DecorationImage(
                      image: FileImage(File(_imageUrl!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _imageUrl != null
                ? CircleAvatar(
                    radius: 65,
                    backgroundImage: FileImage(File(_imageUrl!)),
                  )
                : const CircleAvatar(
                    radius: 65,
                    backgroundImage:
                        NetworkImage('https://i.pravatar.cc/300?u=julian'),
                  ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF5C79FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      children: [
        const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1A1A40),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "UPDATE YOUR EDITORIAL PRESENCE",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: const Color(0xFF1A1A40).withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: Color(0xFF7C3AED),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE0E3FF).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A40),
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D5AFF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 10,
          shadowColor: const Color(0xFF2D5AFF).withOpacity(0.4),
        ),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Changes saved correctly")),
          );
        },
        child: const Text(
          "SAVE CHANGES",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccount() {
    return Column(
      children: [
        TextButton(
          onPressed: () {},
          child: const Text(
            "DELETE ACCOUNT",
            style: TextStyle(
              color: Color(0xFFE11D48),
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            "Permanently remove your data and content from the Kinetic ecosystem.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFF1A1A40).withOpacity(0.4),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final String path = result.files.single.path!;

        if (await File(path).exists()) {
          setState(() {
            _imageUrl = path;
          });
        } else {
          NotificationService.show(
            context,
            title: "Error",
            message: "Selected file is not accessible",
            isError: true,
          );
        }
      }
    } catch (e) {
      NotificationService.show(
        context,
        title: "Error",
        message: "Could not open file picker",
        isError: true,
      );
    }
  }
}
