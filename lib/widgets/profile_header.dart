import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String major;
  final int grade;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.major,
    required this.grade,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[300],
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEdit,
                child: const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 18,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name.isEmpty ? "이름 없음" : name,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          major.isEmpty ? "학과 정보 없음 · -학년" : "$major · ${grade}학년",
          style: TextStyle(color: Colors.black54),
        ),
      ],
    );
  }
}
