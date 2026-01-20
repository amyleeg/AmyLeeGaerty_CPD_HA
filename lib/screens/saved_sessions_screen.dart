import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/session.dart';

class SavedSessionsScreen extends StatefulWidget {
  const SavedSessionsScreen({super.key});

  @override
  State<SavedSessionsScreen> createState() => _SavedSessionsScreenState();
}

class _SavedSessionsScreenState extends State<SavedSessionsScreen> {
  List<Session> savedSessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('planned_sessions') ?? [];
    setState(() {
      savedSessions = stored
          .map((e) => Session.fromJson(jsonDecode(e)))
          .toList();
    });
  }

  Future<void> _deleteSession(int index) async {
    final prefs = await SharedPreferences.getInstance();
    savedSessions.removeAt(index);
    final encoded = savedSessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('planned_sessions', encoded);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Sessions')),
      body: savedSessions.isEmpty
          ? const Center(child: Text('No saved sessions yet.'))
          : ListView.builder(
              itemCount: savedSessions.length,
              itemBuilder: (context, index) {
                final session = savedSessions[index];
                return Dismissible(
                  key: Key(session.date + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) => _deleteSession(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: session.imagePath != null
                          ? Image.file(
                              File(session.imagePath!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(session.date),
                      subtitle: Text(session.notes),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
