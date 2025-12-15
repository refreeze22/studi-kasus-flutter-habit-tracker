import 'package:flutter/material.dart';
import 'package:studi_kasus_flutter_habit_tracker/db/app_database.dart';
import 'package:studi_kasus_flutter_habit_tracker/models/habit.dart';
import 'package:studi_kasus_flutter_habit_tracker/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class HabitFormPage extends StatefulWidget {
  final Habit? habit;

  const HabitFormPage({super.key, this.habit});

  @override
  _HabitFormPageState createState() => _HabitFormPageState();
}

class _HabitFormPageState extends State<HabitFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TimeOfDay _scheduleTime;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _title = widget.habit?.title ?? '';
    _description = widget.habit?.description ?? '';
    if (widget.habit != null) {
      final timeParts = widget.habit!.scheduleTime.split(':');
      _scheduleTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    } else {
      _scheduleTime = TimeOfDay.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit == null ? 'New Habit' : 'Edit Habit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              TextFormField(
                initialValue: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Schedule Time'),
                subtitle: Text(DateFormat('HH:mm').format(DateTime(2023, 1, 1, _scheduleTime.hour, _scheduleTime.minute))),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _scheduleTime,
                  );
                  if (time != null) {
                    setState(() {
                      _scheduleTime = time;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final scheduleTime = DateFormat('HH:mm').format(DateTime(2023, 1, 1, _scheduleTime.hour, _scheduleTime.minute));
                    final now = tz.TZDateTime.now(tz.local);
                    final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, _scheduleTime.hour, _scheduleTime.minute);

                    if (widget.habit == null) {
                      final newHabit = Habit(
                        title: _title,
                        description: _description,
                        scheduleTime: scheduleTime,
                        createdAt: DateTime.now(),
                      );
                      final habit = await AppDatabase.instance.insertHabit(newHabit);
                      _notificationService.scheduleDailyNotification(
                        habit.id!,
                        'Habit Reminder',
                        'It\'s time for your habit: $_title',
                        scheduledTime,
                      );
                    } else {
                      final updatedHabit = Habit(
                        id: widget.habit!.id,
                        title: _title,
                        description: _description,
                        scheduleTime: scheduleTime,
                        createdAt: widget.habit!.createdAt,
                      );
                      await AppDatabase.instance.updateHabit(updatedHabit);
                      _notificationService.scheduleDailyNotification(
                        widget.habit!.id!,
                        'Habit Reminder',
                        'It\'s time for your habit: $_title',
                        scheduledTime,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
