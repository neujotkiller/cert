import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cert_app/screens/recommend/cert_card.dart';

class MajorRecommendTab extends StatelessWidget {
  const MajorRecommendTab({super.key});

  // 🔹 학과 기반 추천 데이터 로드
  Future<List<Map<String, dynamic>>> _loadMajorCerts() async {
    final jsonString =
        await rootBundle.loadString('assets/data/major_cert_map.json');

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    // 예시: "화학공학과" 기준
    final List list = jsonMap['화학공학과'] ?? [];

    return list.cast<Map<String, dynamic>>();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadMajorCerts(),
      builder: (context, snapshot) {
        // ⏳ 로딩 중
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // ❌ 데이터 없음
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('추천 결과가 없습니다.'));
        }

        // ✅ 정상 렌더링
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return CertCard(cert: snapshot.data![index]);
          },
        );
      },
    );
  }
}
