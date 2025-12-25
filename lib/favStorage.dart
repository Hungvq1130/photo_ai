import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteStorage {
  static const _key = 'favorite_preset_ids';

  static Future<Set<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return {};
    final List list = jsonDecode(raw);
    return list.map((e) => e.toString()).toSet();
  }

  static Future<void> save(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(ids.toList()));
  }
}

