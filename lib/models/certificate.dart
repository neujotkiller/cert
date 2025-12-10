class Certificate {
  final String licenseId;
  final String name;
  final String? classification;
  final double? diffLevel;
  final int? examCount;
  final bool? hasWritten;
  final bool? hasPractical;
  final bool? hasInterview;
  final double? passRate1st;
  final double? passRate2nd;
  final double? passRate3rd;
  final double? passRateOverall;
  final double? applicantsAvg;

  Certificate({
    required this.licenseId,
    required this.name,
    this.classification,
    this.diffLevel,
    this.examCount,
    this.hasWritten,
    this.hasPractical,
    this.hasInterview,
    this.passRate1st,
    this.passRate2nd,
    this.passRate3rd,
    this.passRateOverall,
    this.applicantsAvg,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      licenseId: json["license_id"],
      name: json["name"],
      classification: json["classification"],
      diffLevel: (json["diff_level"] as num?)?.toDouble(),
      examCount: json["exam_count"],
      hasWritten: json["has_written"],
      hasPractical: json["has_practical"],
      hasInterview: json["has_interview"],
      passRate1st: (json["pass_rate_1st"] as num?)?.toDouble(),
      passRate2nd: (json["pass_rate_2nd"] as num?)?.toDouble(),
      passRate3rd: (json["pass_rate_3rd"] as num?)?.toDouble(),
      passRateOverall: (json["pass_rate_overall"] as num?)?.toDouble(),
      applicantsAvg: (json["applicants_avg"] as num?)?.toDouble(),
    );
  }
}
