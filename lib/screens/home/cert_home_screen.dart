import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cert_app/providers/auth_provider.dart';
import 'package:cert_app/services/api.dart';
import 'package:cert_app/screens/profile/profile_screen.dart';
import 'package:cert_app/screens/community/community_list.dart';

class CertHomeScreen extends StatefulWidget {
  const CertHomeScreen({super.key});

  @override
  State<CertHomeScreen> createState() => _CertHomeScreenState();
}

class _CertHomeScreenState extends State<CertHomeScreen> {
  List<dynamic> majorCerts = [];   // 학과 기반 추천
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommended();
  }

  Future<void> _loadRecommended() async {
    final auth = context.read<AuthProvider>();
    final token = auth.token;

    if (token == null) return;

    try {
      final data = await Api.instance.getMyRecommendedCertificates(token);
      setState(() {
        majorCerts = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C1D52),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            const SizedBox(height: 16),
            _title(),
            const SizedBox(height: 20),
            Expanded(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _certList(),
            ),
          ],
        ),
      ),
    );
  }

  // =============================
  // 상단 로고 + 아이콘 버튼
  // =============================
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "사용자 맞춤형 자격증 플랫폼",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          Row(
            children: [
              _iconButton(Icons.person, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              }),

              _iconButton(Icons.forum, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommunityListScreen()),
                );
              }),

              _iconButton(Icons.settings, () {}),
            ],
          )
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      iconSize: 28,
    );
  }

  // =============================
  // 메인 타이틀
  // =============================
  Widget _title() {
    return const Padding(
      padding: EdgeInsets.only(left: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "학과 기반 추천 자격증",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // =============================
  // 추천 카드 리스트
  // =============================
  Widget _certList() {
    if (majorCerts.isEmpty) {
      return const Center(
        child: Text(
          "추천 결과가 없습니다.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: majorCerts.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (_, i) {
        final item = majorCerts[i];
        return _certCard(item);
      },
    );
  }

  // =============================
  // 개별 자격증 카드 UI
  // =============================
  Widget _certCard(dynamic cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cert["name"] ?? "자격증명 없음",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "${cert["classification"] ?? "분류 없음"} / 검정 ${cert["exam_count"] ?? 0}회",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _rateBox("1차 합격률", cert["pass_rate_1st"]),
              _rateBox("2차 합격률", cert["pass_rate_2nd"]),
              _rateBox("3차 합격률", cert["pass_rate_3rd"]),
            ],
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              // TODO: 직무 상세 페이지로 이동
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("관련 직무 보기"),
          )
        ],
      ),
    );
  }

  Widget _rateBox(String label, dynamic val) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          val == null ? "-" : "${val.toStringAsFixed(1)}%",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
