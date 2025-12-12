import 'package:flutter/material.dart';
import 'package:flutter_radar_chart/flutter_radar_chart.dart';

class JobDetailScreen extends StatelessWidget {
  final Map<String, double> scores;

  const JobDetailScreen({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    final features = scores.keys.toList();
    final values = [scores.values.toList()];

    return Scaffold(
      appBar: AppBar(
        title: const Text("직업 상세 정보"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            RadarChart(
              features: features,
              data: values,
              ticks: const [20, 40, 60, 80, 100],
              featuresTextStyle: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 24),

            _infoBox("직업전망요약", "현직자의 평균 보상 수준은 낮으며..."),
            _infoBox("취업방법", "필기시험 + 면접시험 조합으로 진행..."),
            _infoBox("준비과정", "NCS 기반 문제 풀이가 필요함..."),
            _infoBox("적성", "정확성 · 침착성 필요"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoBox(String title, String body) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ]),
    );
  }
}
