import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:intl/intl.dart';

import 'package:taskmanagementapp/services/model/note_model.dart';
import 'package:taskmanagementapp/views/home/note.dart';

class NoteViewScreen extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final ValueChanged<Note> onEdit;

  const NoteViewScreen({
    super.key,
    required this.note,
    required this.onDelete,
    required this.onEdit,
  });

  void _exportOrShareNote(BuildContext context) async {
    // For simplicity, share note content as plain text.
    // You can extend this to create a PDF file and share it.

    final shareText = '''
${note.title}

${note.content}

Category: ${note.category}
Created: ${DateFormat.yMMMd().add_jm().format(note.createdAt)}
Last Modified: ${DateFormat.yMMMd().add_jm().format(note.updatedAt)}
''';

    try {
      await Share.share(shareText, subject: note.title);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing note: $e')),
      );
    }
  }

  void _deleteNote(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text(
            "Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete",
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      onDelete(); // <-- this only calls the callback
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted'),
          backgroundColor: Color.fromARGB(255, 52, 59, 58),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _editNote(BuildContext context) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(note: note),
      ),
    );

    if (updatedNote != null && updatedNote is Note) {
      onEdit(updatedNote);
      Navigator.pop(context); // Close view screen after editing
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.yMMMd().add_jm();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _exportOrShareNote(context),
            tooltip: 'Share Note',
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _editNote(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: Colors.red),
            onPressed: () => _deleteNote(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                note.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              /// Category
              Chip(
                label: Text(note.category),
                backgroundColor: Colors.grey.shade200,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 12),

              /// Content
              Text(
                note.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32),

              /// Dates
              Text(
                'Created: ${formatter.format(note.createdAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Last Modified: ${formatter.format(note.updatedAt)}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Priority: ${note.priority}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                'Due Date: ${note.dueDate}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
