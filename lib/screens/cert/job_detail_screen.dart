import 'package:flutter/material.dart';
import 'package:cert_app/services/api.dart';
import 'package:fl_chart/fl_chart.dart';

class JobDetailScreen extends StatefulWidget {
  final int jobSeq;
  final String jobName;

  const JobDetailScreen({
    super.key,
    required this.jobSeq,
    required this.jobName,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  // 점수 데이터 (영문 변수명)
  double salary = 0;
  double stability = 0;
  double growth = 0;
  double work = 0;
  double professional = 0;
  double fairness = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadJobDetail();
  }

  // -----------------------------------------
  // API 호출
  // -----------------------------------------
  Future<void> loadJobDetail() async {
    try {
      final result = await Api.instance.getJobDetail(widget.jobSeq);

      setState(() {
        salary = (result["salary"] ?? 0).toDouble();
        stability = (result["stability"] ?? 0).toDouble();
        growth = (result["growth"] ?? 0).toDouble();
        work = (result["work"] ?? 0).toDouble();
        professional = (result["professional"] ?? 0).toDouble();
        fairness = (result["fairness"] ?? 0).toDouble();

        loading = false;
      });
    } catch (e) {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.jobName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _radarChart(),
            const SizedBox(height: 20),
            Text(
              "보상: $salary / 고용안정: $stability / 발전: $growth",
              style: const TextStyle(color: Colors.black87),
            ),
            Text(
              "근무여건: $work / 전문성: $professional / 고용평등: $fairness",
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 플러터 RadarChart (fl_chart 0.69.0 기준)
  // ==========================================
  Widget _radarChart() {
    final labels = [
      "보상",
      "고용안정",
      "발전가능성",
      "근무여건",
      "전문성",
      "고용평등"
    ];

    return SizedBox(
      height: 350,
      child: RadarChart(
        RadarChartData(
          radarShape: RadarShape.circle,

          // 눈금 개수
          tickCount: 5,
          ticksTextStyle: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),

          // 라벨 스타일
          titleTextStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),

          // ❗ fl_chart 최신 문법 — 라벨 지정 방식
          getTitle: (index, angle) {
            return RadarChartTitle(
              text: labels[index],
            );
          },

          // 데이터셋
          dataSets: [
            RadarDataSet(
              fillColor: Colors.deepPurple.withOpacity(0.4),
              borderColor: Colors.deepPurple,
              entryRadius: 3,
              borderWidth: 2,
              dataEntries: [
                RadarEntry(value: salary),
                RadarEntry(value: stability),
                RadarEntry(value: growth),
                RadarEntry(value: work),
                RadarEntry(value: professional),
                RadarEntry(value: fairness),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
