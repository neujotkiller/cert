class Certificate {
  final String name;
  final String category;
  final int difficulty;       // 1~5
  final double passRate;      // %
  final int applicants;       // 명

  Certificate({
    required this.name,
    required this.category,
    required this.difficulty,
    required this.passRate,
    required this.applicants,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      name: json['name'],
      category: json['category'],
      difficulty: json['difficulty'],
      passRate: (json['pass_rate'] as num).toDouble(),
      applicants: json['applicants'],
    );
  }
}
