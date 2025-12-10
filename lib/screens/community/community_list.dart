import 'package:flutter/material.dart';
import '../../services/api.dart';
import '../../models/community_post.dart';
import 'community_write.dart';

class CommunityListScreen extends StatefulWidget {
  const CommunityListScreen({super.key});

  @override
  State<CommunityListScreen> createState() => _CommunityListScreenState();
}

class _CommunityListScreenState extends State<CommunityListScreen> {
  bool isLoading = true;
  bool tokenExpired = false;
  List<CommunityPost> posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final res = await ApiService.getCommunityPosts();
      setState(() {
        posts = res;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("COMMUNITY LIST ERROR: $e");
      if (e.toString().contains("401")) {
        setState(() {
          tokenExpired = true;
        });
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (tokenExpired) {
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, "/login");
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "커뮤니티",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CommunityWriteScreen()),
              ).then((_) => _loadPosts());
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPosts,
              child: ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return _buildPostCard(posts[index]);
                },
              ),
            ),
    );
  }

  // -------------------------
  // 게시글 카드 UI
  // -------------------------
  Widget _buildPostCard(CommunityPost post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                post.userId.substring(0, 6), // UUID 앞부분만 표시
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
