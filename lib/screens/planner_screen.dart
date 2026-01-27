import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ink_log/providers/session_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../models/session.dart';
import '../services/notification_service.dart';
import 'package:path_provider/path_provider.dart';

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
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = photo.name;
        final savedImage = await File(
          photo.path,
        ).copy('${appDir.path}/$fileName');

        setState(() {
          _image = savedImage;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cannot access camera')));
    }
  }

  Future<void> _saveSession() async {
    if (selectedDate == null) return;

    String? savedImagePath;
    if (_image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = _image!.path.split('/').last;
      final savedImage = await _image!.copy('${appDir.path}/$fileName');
      savedImagePath = savedImage.path;
    }

    final session = Session(
      date: selectedDate!.toLocal().toString().split(' ')[0],
      notes: notesController.text,
      imagePath: savedImagePath,
      title: '',
    );

    await Provider.of<SessionProvider>(context, listen: false)
        .addSession(session);

    NotificationService.showNotification();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Session saved')),
    );

    setState(() {
      _image = null;
      notesController.clear();
      selectedDate = null;
    });
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
        child: SingleChildScrollView(
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
      ),
    );
  }
}
