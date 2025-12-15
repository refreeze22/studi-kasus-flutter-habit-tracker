class Habit {
  final int? id;
  final String title;
  final String description;
  final String scheduleTime;
  final bool isCompleted;
  final DateTime createdAt;

  Habit({
    this.id,
    required this.title,
    required this.description,
    required this.scheduleTime,
    this.isCompleted = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduleTime': scheduleTime,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      scheduleTime: map['scheduleTime'],
      isCompleted: map['isCompleted'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
