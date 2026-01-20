import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionProvider extends ChangeNotifier {
  List<Session> _sessions = [];

  SessionProvider() {
    _initialize();
  }

  List<Session> get sessions => _sessions;

  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('planned_sessions') ?? [];
    _sessions = stored.map((e) => Session.fromJson(jsonDecode(e))).toList();
    notifyListeners();
  }

  void addSession(Session session) {
    _sessions.add(session);
    _saveSessions();
    notifyListeners();
  }

  void removeSession(int index) {
    _sessions.removeAt(index);
    _saveSessions();
    notifyListeners();
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('planned_sessions', encoded);
  }
}
