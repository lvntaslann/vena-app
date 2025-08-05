import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final String baseUrl =
      '';
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId:
        '305112593740-b6fq7jijpqat0sjj1gh4gqa3r08shrtj.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await _saveUserLocally(data);
      return {'success': true, 'user': data};
    } else {
      return {'success': false, 'error': data['error'] ?? 'Giriş başarısız'};
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {'success': true};
    } else {
      return {'success': false, 'error': data['error'] ?? 'Kayıt başarısız'};
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'success': false, 'error': 'Google girişi iptal edildi'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return {'success': false, 'error': 'Google token alınamadı'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/google-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      final data = jsonDecode(response.body);
      debugPrint("Saving user locally: uid=${data['uid']}");
      debugPrint(data.toString());
      print("DATA UID ${data['uid']}");
      if (response.statusCode == 200) {
        await _saveUserLocally(data);
        return {'success': true, 'user': data};
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Google ile giriş başarısız'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Hata oluştu: ${e.toString()}'};
    }
  }

  Future<void> _saveUserLocally(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', data['uid']?.toString() ?? '');
    await prefs.setString('idToken', data['idToken']?.toString() ?? '');
    await prefs.setString(
        'refreshToken', data['refreshToken']?.toString() ?? '');
    await prefs.setString('userEmail', data['email']?.toString() ?? '');
    await prefs.setString('name', data['name']?.toString() ?? '');
  }
}
