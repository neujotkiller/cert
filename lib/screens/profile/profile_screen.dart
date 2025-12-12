import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';
import '../../models/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final UserProfile? p = provider.profile;

    if (p == null) {
      return const Scaffold(
        body: Center(child: Text("프로필 정보가 없습니다.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("내 프로필")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ============================
            // 프로필 이미지 (Web-safe)
            // ============================
            CircleAvatar(
              radius: 55,
              child: const Icon(Icons.person, size: 55),
            ),

            const SizedBox(height: 20),

            // ============================
            // 기본 정보
            // ============================
            Text(
              p.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("${p.major} / ${p.grade}학년"),

            const SizedBox(height: 30),

            // ============================
            // 취업률 카드
            // ============================
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("취업률", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text("전체: ${p.employmentTotal}%"),
                    Text("남자: ${p.employmentMale}%"),
                    Text("여자: ${p.employmentFemale}%"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ============================
            // 관심 NCS
            // ============================
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "관심 NCS 대직무",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: p.interestNcs
                  .map((e) => Chip(label: Text(e)))
                  .toList(),
            ),

            const SizedBox(height: 30),

            // ============================
            // 커뮤니티 버튼
            // ============================
            ElevatedButton(onPressed: () {}, child: const Text("내가 쓴 글")),
            ElevatedButton(onPressed: () {}, child: const Text("좋아요 한 글")),
            ElevatedButton(onPressed: () {}, child: const Text("북마크한 글")),
          ],
        ),
      ),
    );
  }
}
