import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cert_app/services/api.dart';
import 'package:cert_app/models/user_profile.dart';

class ProfileAPI {
  static Future<UserProfile?> getProfile() async {
    try {
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
        return UserProfile.fromJson(jsonDecode(res.body));
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
