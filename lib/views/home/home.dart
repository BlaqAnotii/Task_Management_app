import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanagementapp/resources/colors.dart';
import 'package:taskmanagementapp/services/model/note_model.dart';
import 'package:taskmanagementapp/views/home/note.dart';
import 'package:taskmanagementapp/views/home/view_note.dart';

import '../../controllers/home.vm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];
  List<Note> filteredNotes = [];
  TextEditingController searchController =
      TextEditingController();

  final List<String> cat = [
    'All',
    'Important',
    'Lecture Notes',
    'To-do lists',
    'Shopping lists',
    'Diary',
  ];

  final List<DateTime> dates = List.generate(
    14,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  String selectedCat = 'All';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    loadNotes();
    selectedDate = dates[0];
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notesJson = prefs.getString('notes');
    if (notesJson != null) {
      final List list = jsonDecode(notesJson);
      notes = list.map((e) => Note.fromJson(e)).toList();
      print('Notes loaded: ${notes.length} items');
      applyFilters();
    } else {
      print('No notes found in storage');
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((e) => e.toJson()).toList();
    await prefs.setString('notes', jsonEncode(jsonList));
    print('Notes saved: ${notes.length} items');
  }

  void deleteNote(int index) async {
    print('Deleting note: ${notes[index].title}');
    notes.removeAt(index);
    applyFilters();
    await saveNotes();
  }

  void applyFilters() {
    final query = searchController.text.trim().toLowerCase();
    filteredNotes = notes.where((note) {
      final matchQuery =
          note.title.toLowerCase().contains(query) ||
              note.content.toLowerCase().contains(query) ||
              note.category.toLowerCase().contains(query);

      final matchCat =
          selectedCat == 'All' || note.category == selectedCat;

      final matchDate = selectedDate == null ||
          (note.updatedAt.year == selectedDate!.year &&
              note.updatedAt.month == selectedDate!.month &&
              note.updatedAt.day == selectedDate!.day);

      return matchQuery && matchCat && matchDate;
    }).toList();

    print(
        'Filtered notes: ${filteredNotes.length} match(es) for query "$query"');
    setState(() {});
  }

  void filterNotes(String query) {
    applyFilters();
  }

  void addOrEditNote({Note? note, int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NoteEditorScreen(
          note: note,
          onDelete: () {
            if (index != null) deleteNote(index);
          },
        ),
      ),
    );

    if (result == 'deleted') {
      // Note was deleted, refresh UI if needed
      applyFilters();
      await saveNotes();
      return;
    }

    if (result != null && result is Note) {
      if (index != null) {
        notes[index] = result;
      } else {
        notes.add(result);
      }
      applyFilters();
      await saveNotes();
    }
  }

// Show the bottom modal sheet with options View, Edit, Delete
  void showNoteActions(int index) {
    final note = filteredNotes[index];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.remove_red_eye),
                title: const Text('View'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NoteViewScreen(
                        note: note,
                        onDelete: () async {
                          setState(() {
                            notes.remove(note);
                          });
                          await saveNotes();
                          applyFilters();
                        },
                        onEdit: (updatedNote) async {
                          setState(() {
                            final index = notes.indexOf(note);
                            if (index != -1) {
                              notes[index] = updatedNote;
                            }
                          });
                          await saveNotes();
                          applyFilters();
                        },
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  int fullIndex = notes.indexOf(note);
                  addOrEditNote(note: note, index: fullIndex);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void onMenuTap(String cat) {
    setState(() {
      selectedCat = cat;
    });
    applyFilters();
  }

  Widget buildMenuItem(String title, BuildContext context) {
    bool isSelected = selectedCat == title;
    return GestureDetector(
      onTap: () => onMenuTap(title),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff182A88)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey,
            width: 0.3,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? Colors.white : Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  final List<Color> noteColors = [
    const Color(0xFFC2DCFD), // Soft Blue
    const Color(0xFFFFD8F4), // Light Pink
    const Color(0xFFFBF6AA), // Pale Yellow
    const Color(0xFFB0E9CA), // Mint Green
    const Color(0xFFFCFAD9), // Light Cream
    const Color(0xFFF1DBF5), // Lavender Pink
    const Color(0xFFD9E8FC), // Ice Blue
    const Color(0xFFFFDBE3), // Soft Peach
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      appBar: AppBar(
        leadingWidth: 100,
        backgroundColor: AppColors.white,
        toolbarHeight: 50,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Netspin',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '${DateTime.now().year} ', // Year
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              TextSpan(
                text: DateFormat('MMMM')
                    .format(DateTime.now()), // Full Month name
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: Icon(Icons.more_vert),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 7),
            child: TextFormField(
              controller: searchController,
              onChanged: filterNotes,
              decoration: InputDecoration(
                fillColor: const Color(0xffFFFFFF),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: AppColors.darkGrey),
                  borderRadius: BorderRadius.circular(15),
                ),
                hintText: 'Search for notes',
                hintStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey),
                prefixIcon: const Icon(
                    Iconsax.search_normal_1_outline,
                    color: AppColors.grey),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 13, right: 13),
          child: Column(
            children: [
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final isSelected =
                        date.day == selectedDate?.day &&
                            date.month == selectedDate?.month &&
                            date.year == selectedDate?.year;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                        applyFilters();
                      },
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 16),
                        decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xff182A88)
                                : Colors.white,
                            borderRadius:
                                BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey,
                              width: 0.3,
                            )),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E().format(date),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[800],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 23),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: cat
                      .map((cats) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6),
                            child: buildMenuItem(cats, context),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 23),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6),
                  child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: filteredNotes.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio:
                          0.85, // Adjusted for card height
                    ),
                    itemBuilder: (_, index) {
                      final note = filteredNotes[index];
                      final backgroundColor =
                          noteColors[index % noteColors.length];

                      return GestureDetector(
                        onTap: () => showNoteActions(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      note.title,
                                      maxLines: 3,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: const Icon(
                                        Bootstrap.pin_angle_fill,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Note pinned'),
                                            backgroundColor:
                                                Color.fromARGB(
                                                    255,
                                                    52,
                                                    59,
                                                    58),
                                            duration: Duration(
                                                seconds: 2),
                                          ),
                                        );
                                      })
                                ],
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  note.content.length > 60
                                      ? '${note.content.substring(0, 60)}...'
                                      : note.content,
                                  maxLines: 3,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 13),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  '${note.updatedAt.day}/${note.updatedAt.month}/${note.updatedAt.year}',
                                  style: const TextStyle(
                                    color: Colors.black38,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(side: BorderSide.none),
        onPressed: () => addOrEditNote(),
        backgroundColor: const Color(0xff182A88),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
