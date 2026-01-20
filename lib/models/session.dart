class Session {
  final String title;
  final String notes;
  final String date;
  final String? imagePath;

  Session({
    required this.title,
    required this.notes,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'notes': notes,
    'date': date,
    'imagePath': imagePath,
  };

  factory Session.fromJson(Map<String, dynamic> json) => Session(
    title: json['title'],
    notes: json['notes'],
    date: json['date'],
    imagePath: json['imagePath'],
  );
}
