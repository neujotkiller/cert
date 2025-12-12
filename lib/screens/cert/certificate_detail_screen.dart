import 'package:flutter/material.dart';
import 'package:cert_app/services/api.dart';

class CertificateDetailScreen extends StatefulWidget {
  final int licenseId;
  final String licenseName;

  const CertificateDetailScreen({
    super.key,
    required this.licenseId,
    required this.licenseName,
  });

  @override
  State<CertificateDetailScreen> createState() =>
      _CertificateDetailScreenState();
}

class _CertificateDetailScreenState extends State<CertificateDetailScreen> {
  bool loading = true;
  List<dynamic> relatedJobs = [];

  @override
  void initState() {
    super.initState();
    loadRelatedJobs();
  }

  Future<void> loadRelatedJobs() async {
    try {
      final jobs = await Api.instance.getRelatedJobs(widget.licenseId);

      setState(() {
        relatedJobs = jobs;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.licenseName),
        backgroundColor: Colors.deepPurple,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : relatedJobs.isEmpty
              ? const Center(
                  child: Text("관련 직업 정보가 없습니다."),
                )
              : ListView.builder(
                  itemCount: relatedJobs.length,
                  itemBuilder: (context, index) {
                    final job = relatedJobs[index];
                    return ListTile(
                      title: Text(job["jobName"]),
                      subtitle: Text("직업번호: ${job["jobSeq"]}"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/jobDetail",
                          arguments: {
                            "jobSeq": job["jobSeq"],
                            "jobName": job["jobName"],
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
