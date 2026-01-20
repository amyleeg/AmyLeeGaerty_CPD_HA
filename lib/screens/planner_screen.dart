import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/session.dart';
import '../services/notification_service.dart';
import 'saved_sessions_screen.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DateTime? selectedDate;
  final TextEditingController notesController = TextEditingController();

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  Future<void> _saveSession() async {
    if (selectedDate == null) return;

    final prefs = await SharedPreferences.getInstance();
    final List<String> stored = prefs.getStringList('planned_sessions') ?? [];

    final session = Session(
      date: selectedDate!.toLocal().toString().split(' ')[0],
      notes: notesController.text,
      imagePath: _image?.path,
      title: '',
    );

    stored.add(jsonEncode(session.toJson()));
    await prefs.setStringList('planned_sessions', stored);

    NotificationService.showNotification();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session saved and reminder set')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SavedSessionsScreen()),
    );
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session Planner')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Plan Your Tattoo Session',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(
                selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${selectedDate!.toLocal().toString().split(' ')[0]}',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Reference Photo'),
            ),
            const SizedBox(height: 12),
            if (_image != null)
              Image.file(_image!, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _saveSession,
                child: const Text('Save Session'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
