import 'package:flutter/material.dart';

class CertCard extends StatelessWidget {
  final String certName;
  final double passRate;     // 합격률 (%)
  final String difficulty;   // 난이도 (상/중/하)
  final double score;        // 추천 점수
  final VoidCallback? onTap;

  const CertCard({
    super.key,
    required this.certName,
    required this.passRate,
    required this.difficulty,
    required this.score,
    this.onTap,
  });

  Color _difficultyColor() {
    switch (difficulty) {
      case '상':
        return Colors.redAccent;
      case '중':
        return Colors.orange;
      case '하':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 자격증명
            Text(
              certName,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            /// 🔹 합격률 / 난이도
            Row(
              children: [
                _infoChip(
                  label: '합격률',
                  value: '${passRate.toStringAsFixed(1)}%',
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                _infoChip(
                  label: '난이도',
                  value: difficulty,
                  color: _difficultyColor(),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔹 추천 점수 바
            Row(
              children: [
                const Text(
                  '추천 점수',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (score / 100).clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  score.toStringAsFixed(0),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
