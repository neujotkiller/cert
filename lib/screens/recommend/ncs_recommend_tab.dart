import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cert_app/screens/recommend/cert_card.dart';

class NcsRecommendTab extends StatefulWidget {
  const NcsRecommendTab({super.key});

  @override
  State<NcsRecommendTab> createState() => _NcsRecommendTabState();
}

class _NcsRecommendTabState extends State<NcsRecommendTab> {
  List<Map<String, dynamic>> certs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNcsCerts();
  }

  /// 🔥 NCS 기반 자격증 로딩
  Future<void> _loadNcsCerts() async {
    try {
      // 1️⃣ 기본 자격증 데이터
      final certJson = await rootBundle.loadString(
        'assets/data/cert_basic.json',
      );
      final List<dynamic> certList = jsonDecode(certJson);

      // 2️⃣ NCS 점수 매핑 데이터
      final ncsJson = await rootBundle.loadString(
        'assets/data/ncs_map.json',
      );
      final Map<String, dynamic> ncsScoreMap = jsonDecode(ncsJson);

      // 3️⃣ 점수 계산 + 병합
      final List<Map<String, dynamic>> result = certList.map((e) {
        final cert = Map<String, dynamic>.from(e);

        final score = ncsScoreMap[cert['name']] ?? 0;

        cert['score'] = score;

        return cert;
      }).toList();

      // 4️⃣ 점수 높은 순 정렬
      result.sort(
        (a, b) => (b['score'] as int).compareTo(a['score'] as int),
      );

      setState(() {
        certs = result;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('NCS 추천 로딩 오류: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (certs.isEmpty) {
      return const Center(child: Text('추천 결과가 없습니다.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: certs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return CertCard(cert: certs[index]);
      },
    );
  }
}
