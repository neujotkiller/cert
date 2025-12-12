import 'package:flutter/material.dart';

class CertCard extends StatelessWidget {
  final String title;
  final String category;
  final int examCount;
  final String structure;
  final double pass1;
  final double pass2;
  final double pass3;
  final int avgApplicants;
  final String difficulty;
  final VoidCallback onRelatedJobs;

  const CertCard({
    super.key,
    required this.title,
    required this.category,
    required this.examCount,
    required this.structure,
    required this.pass1,
    required this.pass2,
    required this.pass3,
    required this.avgApplicants,
    required this.difficulty,
    required this.onRelatedJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text("$category  |  검정횟수: $examCount회  |  구조: $structure",
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _rateBox("1차 합격률", pass1),
            _rateBox("2차 합격률", pass2),
            _rateBox("3차 합격률", pass3),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("총 응시자 평균: $avgApplicants명",
                style: const TextStyle(fontSize: 13)),
            Text("난이도: $difficulty",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ],
        ),

        const SizedBox(height: 12),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onRelatedJobs,
            child: const Text("관련 직무 보기 →",
                style: TextStyle(color: Colors.deepPurple)),
          ),
        ),
      ]),
    );
  }

  Widget _rateBox(String title, double rate) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text("${rate.toStringAsFixed(1)}%",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
