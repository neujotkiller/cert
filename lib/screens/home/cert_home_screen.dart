import 'package:flutter/material.dart';
import '../../services/api.dart';
import '../../models/user_profile.dart';
import '../../models/certificate.dart';

class CertHomeScreen extends StatefulWidget {
  const CertHomeScreen({super.key});

  @override
  State<CertHomeScreen> createState() => _CertHomeScreenState();
}

class _CertHomeScreenState extends State<CertHomeScreen> {
  UserProfile? profile;
  List<CertificateModel> recommended = [];
  bool isLoading = true;
  bool tokenExpired = false;

  @override
  void initState() {
    super.initState();
    _loadEverything();
  }

  Future<void> _loadEverything() async {
    try {
      final res = await Future.wait([
        ApiService.getMyProfile(),
        ApiService.getRecommendedCertificates(),
      ]);

      setState(() {
        profile = res[0] as UserProfile;
        recommended = res[1] as List<CertificateModel>;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("HOME ERROR: $e");
      if (e.toString().contains("401")) {
        setState(() {
          tokenExpired = true;
        });
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tokenExpired) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, "/login");
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "맞춤 자격증 추천",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _loadEverything,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileCard(),
          const SizedBox(height: 20),
          const Text(
            "추천 자격증",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...recommended.map((c) => _buildCertCard(c)).toList(),
        ],
      ),
    );
  }

  // -------------------------
  // 1) 프로필 카드 UI
  // -------------------------
  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile?.name != null ? "${profile!.name} 님" : "사용자",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            profile?.department ?? "학과 정보 없음",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            profile?.gradeYear != null
                ? "${profile!.gradeYear}학년"
                : "학년 정보 없음",
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // 2) 자격증 카드 UI
  // -------------------------
  Widget _buildCertCard(CertificateModel cert) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cert.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            cert.classification ?? "",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("난이도: ${cert.diffLevel ?? '-'}"),
              const SizedBox(width: 12),
              Text("검정 횟수: ${cert.examCount ?? '-'}"),
            ],
          ),
          const SizedBox(height: 6),
          Text("전체 합격률: ${cert.passRateOverall?.toStringAsFixed(1) ?? '-'}%"),
        ],
      ),
    );
  }
}
