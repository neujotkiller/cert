class Certificate {
  final int id;
  final String name;
  final String description;

  Certificate({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
