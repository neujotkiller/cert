import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/api.dart';

class CommunityAPI {
  static Future<List<dynamic>> getMyPosts(String token) async {
    final url = Uri.parse('${Api.baseUrl}/community/mine');

    final res = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }

    return [];
  }
}
