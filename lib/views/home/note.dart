import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:taskmanagementapp/resources/colors.dart';

import 'package:taskmanagementapp/services/model/note_model.dart';
import 'package:taskmanagementapp/views/home/category_list.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? note;
  final VoidCallback? onDelete;

  const NoteEditorScreen({super.key, this.note, this.onDelete});

  @override
  State<NoteEditorScreen> createState() =>
      _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();

  final _contentController = TextEditingController();
  String selectedCategory = 'Uncategorized';
  bool isPinned = false;
  DateTime? selectedDueDate;

  @override
  void initState() {
    super.initState();

    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      selectedPriority = widget.note!.priority;
      selectedDueDate = widget.note!.dueDate;
      selectedCategory = widget.note!.category;
      isPinned = widget.note!.isPinned; // initialize pin state
    }
  }

  String? selectedPriority;

  List<Map<String, dynamic>> priority = [
    {"id": "High", "name": "High"},
    {"id": "Medium", "name": "Medium"},
    {"id": "Low", "name": "Low"},
  ];

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final date = selectedDueDate;
    final priority = selectedPriority;

    if (title.isEmpty &&
        content.isEmpty &&
        date == null &&
        priority == null) {
      print('Empty note discarded');
      Navigator.pop(context);
      return;
    }

    final now = DateTime.now();

    final newNote = Note(
      title: title,
      content: content,
      category: selectedCategory,
      priority: priority,
      dueDate: date,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
      isPinned: isPinned, // save pinned state here
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved successfully'),
        backgroundColor: Color.fromARGB(255, 52, 59, 58),
        duration: Duration(seconds: 5),
      ),
    );

    print('Note saved: ${newNote.title}');
    Navigator.pop(context, newNote);
  }

  void _openCategorySelector() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CategorySelector(
          allCategories: const [
            "Important",
            "Lecture notes",
            "To-do lists",
            "Shopping list",
            "Diary",
            "Retrospective 2023",
          ],
          initiallySelected: selectedCategory == 'Uncategorized'
              ? []
              : selectedCategory.split(', '),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedCategory =
            result.isEmpty ? 'Uncategorized' : result.join(', ');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$selectedCategory selected'),
          backgroundColor: const Color.fromARGB(255, 52, 59, 58),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _applyFormatting(String type) {
    final selection = _contentController.selection;
    final text = _contentController.text;

    if (!selection.isValid || selection.isCollapsed) return;

    final selectedText = selection.textInside(text);
    String formatted = selectedText;

    switch (type) {
      case 'bold':
        formatted = '**$selectedText**';
        break;
      case 'italic':
        formatted = '*$selectedText*';
        break;
      case 'underline':
        formatted = '~~$selectedText~~';
        break;
      case 'clear':
        formatted =
            selectedText.replaceAll(RegExp(r'[*~_#<>/]+'), '');
        break;
      case 'title':
        formatted = '# $selectedText';
        break;
      case 'align_left':
        formatted = '<div align="left">$selectedText</div>';
        break;
      case 'align_center':
        formatted = '<div align="center">$selectedText</div>';
        break;
      case 'align_right':
        formatted = '<div align="right">$selectedText</div>';
        break;
    }

    final newText = selection.textBefore(text) +
        formatted +
        selection.textAfter(text);

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
          offset: selection.start + formatted.length),
    );
  }

  void _deleteNote() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text(
            'Are you sure you want to delete this note?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete')),
        ],
      ),
    );

    if (shouldDelete == true) {
      widget.onDelete?.call(); // delete from parent list
      Navigator.pop(
          context, 'deleted'); // pass 'deleted' result back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted'),
          backgroundColor: Color.fromARGB(255, 52, 59, 58),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  // Add this method to check if there are unsaved changes
  bool get _hasUnsavedChanges {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // If editing existing note: compare with original values
    if (widget.note != null) {
      return title != widget.note!.title ||
          content != widget.note!.content ||
          selectedCategory != widget.note!.category;
    } else {
      // If new note, check if anything typed
      return title.isNotEmpty ||
          content.isNotEmpty ||
          selectedCategory != 'Uncategorized';
    }
  }

  void _discardChanges() async {
    if (!_hasUnsavedChanges) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes'),
        content: const Text(
            'Are you sure you want to discard your changes?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard')),
        ],
      ),
    );

    if (shouldDiscard == true) {
      Navigator.pop(context);
    }
  }

  Future<void> _pickDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black87),
          onPressed: _discardChanges,
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.folder_add_outline),
            onPressed: _openCategorySelector,
          ),
          widget.note == null
              ? IconButton(
                  icon: Icon(
                    isPinned
                        ? Bootstrap.pin_angle_fill
                        : Bootstrap.pin_angle,
                    color: isPinned ? Colors.grey : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      isPinned = !isPinned;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isPinned
                            ? 'Note pinned'
                            : 'Note unpinned'),
                        backgroundColor: const Color.fromARGB(
                            255, 52, 59, 58),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  })
              : IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Colors.red),
                  onPressed: _deleteNote,
                ),
          IconButton(
            icon: const Icon(Iconsax.export_1_outline),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.darkGrey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                // Due Date Picker
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: AppColors.darkGrey),
                  ),
                  child: ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(
                      selectedDueDate != null
                          ? DateFormat.yMMMd()
                              .format(selectedDueDate!)
                          : 'Tap to Select date',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDueDate,
                  ),
                ),

                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: AppColors.darkGrey),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  value: selectedPriority,
                  hint: const Text(
                    "Select Priority",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xff161616),
                    ),
                  ),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                  items: priority.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['id'],
                      child: Text(
                        category['name']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xff161616),
                        ),
                      ),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TextField(
                    //toolbarOptions: ToolbarOptions(),
                    controller: _contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    //expands: true,
                    decoration: InputDecoration(
                      hintText: 'Start Writing....',
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: AppColors.darkGrey),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60,
            left: 16,
            right: 16,
            child: Card(
              elevation: 6,
              color: const Color(0xff182A88),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.format_bold,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('bold'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_italic,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('italic'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.format_underline,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('underline'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.title,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('title'),
                      ),
                      const VerticalDivider(
                          color: Colors.white60),
                      IconButton(
                        icon: const Icon(Icons.format_align_left,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('align_left'),
                      ),
                      IconButton(
                        icon: const Icon(
                            Icons.format_align_center,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('align_center'),
                      ),
                      IconButton(
                        icon: const Icon(
                            Icons.format_align_right,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('align_right'),
                      ),
                      const VerticalDivider(
                          color: Colors.white60),
                      IconButton(
                        icon: const Icon(Icons.format_clear,
                            color: Colors.white),
                        onPressed: () =>
                            _applyFormatting('clear'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
