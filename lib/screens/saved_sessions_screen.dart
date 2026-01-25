import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/session_provider.dart';

class SavedSessionsScreen extends StatelessWidget {
  const SavedSessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Sessions')),
      body: Consumer<SessionProvider>(
        builder: (context, sessionProvider, _) {
          if (sessionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = sessionProvider.sessions;

          if (sessions.isEmpty) {
            return const Center(child: Text('No saved sessions yet.'));
          }

          return ListView.builder(
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];

              return Dismissible(
                key: ValueKey('${session.date}-$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  sessionProvider.removeSession(index);
                },
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
          );
        },
      ),
    );
  }
}
