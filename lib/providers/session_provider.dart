import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SessionProvider extends ChangeNotifier {
  List<Session> _sessions = [];
  bool _isLoading = true;

  List<Session> get sessions => _sessions;
  bool get isLoading => _isLoading;

  SessionProvider() {
    _init();
  }

  Future<void> _init() async {
    await _loadSessions();
  }

  Future<void> addSession(Session session) async {
    _sessions.add(session);
    await _saveSessions();
    notifyListeners();
  }

  Future<void> removeSession(int index) async {
    _sessions.removeAt(index);
    await _saveSessions();
    notifyListeners();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('planned_sessions') ?? [];
    _sessions = stored.map((e) => Session.fromJson(jsonDecode(e))).toList();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('planned_sessions', encoded);
  }
}
