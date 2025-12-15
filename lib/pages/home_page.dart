import 'package:flutter/material.dart';
import 'package:studi_kasus_flutter_habit_tracker/db/app_database.dart';
import 'package:studi_kasus_flutter_habit_tracker/models/habit.dart';
import 'package:studi_kasus_flutter_habit_tracker/pages/habit_form_page.dart';
import 'package:studi_kasus_flutter_habit_tracker/pages/settings_page.dart';
import 'package:studi_kasus_flutter_habit_tracker/services/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Habit>> _habits;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _refreshHabits();
  }

  void _refreshHabits() {
    setState(() {
      _habits = AppDatabase.instance.getAllHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder<List<Habit>>(
        future: _habits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No habits yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final habit = snapshot.data![index];
                return ListTile(
                  title: Text(
                    habit.title,
                    style: TextStyle(
                      decoration: habit.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(habit.description),
                  leading: Checkbox(
                    value: habit.isCompleted,
                    onChanged: (value) async {
                      final updatedHabit = Habit(
                        id: habit.id,
                        title: habit.title,
                        description: habit.description,
                        scheduleTime: habit.scheduleTime,
                        isCompleted: value!,
                        createdAt: habit.createdAt,
                      );
                      await AppDatabase.instance.updateHabit(updatedHabit);
                      _refreshHabits();
                    },
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HabitFormPage(habit: habit),
                            ),
                          );
                          _refreshHabits();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await AppDatabase.instance.deleteHabit(habit.id!);
                          _notificationService.cancelNotification(habit.id!);
                          _refreshHabits();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HabitFormPage()),
          );
          _refreshHabits();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
