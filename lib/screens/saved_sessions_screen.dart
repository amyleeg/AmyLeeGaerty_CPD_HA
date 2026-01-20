import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedSessionsScreen extends StatefulWidget {
  const SavedSessionsScreen({super.key});

  @override
  State<SavedSessionsScreen> createState() => _SavedSessionsScreenState();
}

class _SavedSessionsScreenState extends State<SavedSessionsScreen> {
  List<String> savedSessions = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = prefs.getStringList('planned_sessions') ?? [];
    setState(() {
      savedSessions = sessions;
    });
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
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(title: Text(savedSessions[index])),
                );
              },
            ),
    );
  }
}
