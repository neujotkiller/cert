class UserProfile {
  final String name;
  final String major;
  final int grade;
  final double employmentTotal;
  final double employmentMale;
  final double employmentFemale;
  final List<String> interestNcs;
  final String? imageUrl;

  UserProfile({
    required this.name,
    required this.major,
    required this.grade,
    required this.employmentTotal,
    required this.employmentMale,
    required this.employmentFemale,
    required this.interestNcs,
    this.imageUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      major: json['major'] ?? '',
      grade: (json['grade'] ?? 0) is int ? (json['grade'] ?? 0) : int.tryParse('${json['grade']}') ?? 0,
      employmentTotal: (json['employment_total'] ?? 0).toDouble(),
      employmentMale: (json['employment_male'] ?? 0).toDouble(),
      employmentFemale: (json['employment_female'] ?? 0).toDouble(),
      interestNcs: (json['interest_ncs'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "major": major,
      "grade": grade,
      "employment_total": employmentTotal,
      "employment_male": employmentMale,
      "employment_female": employmentFemale,
      "interest_ncs": interestNcs,
      "image_url": imageUrl,
    };
  }

  UserProfile copyWith({
    String? name,
    String? major,
    int? grade,
    double? employmentTotal,
    double? employmentMale,
    double? employmentFemale,
    List<String>? interestNcs,
    String? imageUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      major: major ?? this.major,
      grade: grade ?? this.grade,
      employmentTotal: employmentTotal ?? this.employmentTotal,
      employmentMale: employmentMale ?? this.employmentMale,
      employmentFemale: employmentFemale ?? this.employmentFemale,
      interestNcs: interestNcs ?? this.interestNcs,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
