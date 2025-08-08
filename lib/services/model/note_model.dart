class Note {
  final String title;
  final String content;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final String? priority; // new
  final DateTime? dueDate; // new

  Note({
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinned,
    this.priority,
    this.dueDate,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      content: json['content'],
      category: json['category'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isPinned: json['isPinned'] ?? false,
      priority: json['priority'],
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
    };
  }
}
