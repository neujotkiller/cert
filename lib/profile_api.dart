import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api.dart';
import '../models/user_profile.dart';

class ProfileAPI {
  static Future<UserProfile?> getProfile() async {
    final token = await Api.getToken();
    if (token == null) return null;

    final res = await http.get(
      Uri.parse('${Api.baseUrl}/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserProfile.fromJson(data);
    }

    return null;
  }

  static Future<bool> updateProfile(UserProfile profile) async {
    final token = await Api.getToken();
    if (token == null) return false;

    final res = await http.put(
      Uri.parse('${Api.baseUrl}/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(profile.toJson()),
    );

    return res.statusCode == 200;
  }
}
