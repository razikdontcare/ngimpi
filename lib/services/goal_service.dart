import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/goal.dart';

class GoalService {
  static const String _key = 'goals';

  // Ambil semua goal
  Future<List<Goal>> getGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final List list = jsonDecode(data);
    return list.map((e) => Goal.fromMap(e)).toList();
  }

  // Simpan semua goal
  Future<void> saveGoals(List<Goal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(goals.map((e) => e.toMap()).toList());
    await prefs.setString(_key, data);
  }
}
