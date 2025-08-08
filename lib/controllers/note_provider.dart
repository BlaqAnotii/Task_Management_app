import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/model/note_model.dart';

class NoteProvider extends ChangeNotifier {
  List<Note> _notes = [];
  List<Note> get notes => _notes;

  NoteProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List list = jsonDecode(notesJson);
      _notes = list.map((e) => Note.fromJson(e)).toList();
      notifyListeners();
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = _notes.map((e) => e.toJson()).toList();
    await prefs.setString('notes', jsonEncode(jsonList));
  }

  void addNote(Note note) {
    _notes.add(note);
    saveNotes();
    notifyListeners();
  }

  void updateNote(int index, Note note) {
    _notes[index] = note;
    saveNotes();
    notifyListeners();
  }

  void deleteNote(Note note) {
    _notes.remove(note);
    saveNotes();
    notifyListeners();
  }
}
