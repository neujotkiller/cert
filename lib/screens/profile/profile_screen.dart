import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:cert_app/providers/profile_provider.dart';
import 'package:cert_app/screens/profile/profile_edit_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null && context.mounted) {
      context.read<ProfileProvider>().updateImage(file.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    // 프로필 없을 때 UI
    if (!provider.hasProfile || provider.profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("내 프로필"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
              );
            },
            child: const Text("프로필 작성"),
          ),
        ),
      );
    }

    final p = provider.profile!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("내 프로필"),
        // ProfileScreen을 push로 열면 자동 뒤로가기가 뜨지만,
        // pushReplacement로 열었을 가능성이 높아서 안전하게 직접 넣어둠
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _pickImage(context),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: (p.imageUrl != null && p.imageUrl!.isNotEmpty)
                        ? FileImage(File(p.imageUrl!))
                        : null,
                    child: (p.imageUrl == null || p.imageUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 48)
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
                    ),
                    child: const Icon(Icons.camera_alt, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(p.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text("${p.major} / ${p.grade}학년"),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditScreen()),
                  );
                },
                child: const Text("프로필 수정"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
