import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String type; // 'session', 'event', 'workshop'
  final String? location;

  CalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.type,
    this.location,
  });
}

class CalendarNotifier extends StateNotifier<List<CalendarEvent>> {
  CalendarNotifier() : super([]) {
    _loadEvents();
  }

  void _loadEvents() {
    // Mock data - In real app, fetch from API
    state = [
      CalendarEvent(
        id: '1',
        title: 'CrossFit WOD',
        description: 'Séance intense du jour',
        dateTime: DateTime.now().add(const Duration(days: 1, hours: 10)),
        type: 'session',
        location: 'Branch 1',
      ),
      CalendarEvent(
        id: '2',
        title: 'Yoga Flow',
        description: 'Détente et souplesse',
        dateTime: DateTime.now().add(const Duration(days: 2, hours: 18)),
        type: 'workshop',
        location: 'Branch 2',
      ),
      CalendarEvent(
        id: '3',
        title: 'Compétition Inter-Gym',
        description: 'Grand événement mensuel',
        dateTime: DateTime.now().add(const Duration(days: 5, hours: 14)),
        type: 'event',
        location: 'Main Hall',
      ),
    ];
  }

  void addEvent(CalendarEvent event) {
    state = [...state, event];
  }

  void removeEvent(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final calendarProvider =
    StateNotifierProvider<CalendarNotifier, List<CalendarEvent>>((ref) {
      return CalendarNotifier();
    });
