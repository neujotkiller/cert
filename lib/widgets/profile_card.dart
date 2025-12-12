import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cert_app/providers/profile_provider.dart';
import 'package:cert_app/screens/profile/profile_screen.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EEFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: provider.profile == null ? _empty(context) : _filled(context, provider),
    );
  }

  Widget _filled(BuildContext context, ProfileProvider provider) {
    final p = provider.profile!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("내 프로필", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: p.imageUrl != null ? FileImage(File(p.imageUrl!)) : null,
              child: p.imageUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text("${p.major} / ${p.grade}학년"),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            },
            icon: const Icon(Icons.edit),
            label: const Text("프로필 수정"),
          ),
        ),
      ],
    );
  }

  Widget _empty(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("내 프로필", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text("프로필이 없습니다.\n버튼을 눌러 작성해주세요."),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          },
          child: const Text("프로필 작성"),
        ),
      ],
    );
  }
}
