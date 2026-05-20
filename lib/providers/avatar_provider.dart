import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AvatarProvider extends ChangeNotifier {
  static const _avatarKey = 'profile_avatar_b64';
  String? _avatarBase64;

  String? get avatarBase64 => _avatarBase64;

  AvatarProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _avatarBase64 = prefs.getString(_avatarKey);
    notifyListeners();
  }

  Future<void> update(String? base64) async {
    _avatarBase64 = base64;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (base64 != null) {
      await prefs.setString(_avatarKey, base64);
    } else {
      await prefs.remove(_avatarKey);
    }
  }
}