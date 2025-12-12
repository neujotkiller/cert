import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cert_app/providers/auth_provider.dart';
import 'package:cert_app/services/api.dart';

class JobRecommendScreen extends StatefulWidget {
  const JobRecommendScreen({super.key});

  @override
  State<JobRecommendScreen> createState() => _JobRecommendScreenState();
}

class _JobRecommendScreenState extends State<JobRecommendScreen> {
  List<dynamic> jobCerts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadJobCerts();
  }

  Future<void> _loadJobCerts() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;

    try {
      final data = await Api.instance.getCertificatesByNcs(token);
      setState(() {
        jobCerts = data;
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
      appBar: AppBar(
        title: const Text("직무 기반 추천", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2C1D52),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : jobCerts.isEmpty
              ? const Center(
                  child: Text(
                    "추천할 직무가 없습니다.\nNCS 관심직무를 먼저 선택하세요.",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobCerts.length,
                  itemBuilder: (_, i) => _certCard(jobCerts[i]),
                ),
    );
  }

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
            "${cert["classification"] ?? "분류 없음"} • 검정 ${cert["exam_count"] ?? 0}회",
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _rate("1차", cert["pass_rate_1st"]),
              _rate("2차", cert["pass_rate_2nd"]),
              _rate("3차", cert["pass_rate_3rd"]),
            ],
          ),

          const SizedBox(height: 14),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
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

  Widget _rate(String label, dynamic v) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 3),
        Text(
          v == null ? "-" : "${v.toStringAsFixed(1)}%",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
