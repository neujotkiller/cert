class CommunityPost {
  final int id;
  final String userId;
  final String title;
  final String content;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}
