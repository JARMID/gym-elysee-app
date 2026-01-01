import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'admin_provider.dart';

class GlobalSearchResults {
  final List<dynamic> members;
  final List<dynamic> coaches;
  final List<dynamic> programs;

  GlobalSearchResults({
    this.members = const [],
    this.coaches = const [],
    this.programs = const [],
  });

  bool get isEmpty => members.isEmpty && coaches.isEmpty && programs.isEmpty;
}

final globalSearchProvider = FutureProvider.family<GlobalSearchResults, String>(
  (ref, query) async {
    if (query.isEmpty) {
      return GlobalSearchResults();
    }

    final normalizedQuery = query.toLowerCase();

    // Fetch all data
    final members = await ref.watch(adminMembersProvider.future);
    final coaches = await ref.watch(adminCoachesProvider.future);
    final programs = await ref.watch(adminProgramsProvider.future);

    // Filter Members
    final filteredMembers = members.where((m) {
      final firstName = (m['first_name'] ?? '').toString().toLowerCase();
      final lastName = (m['last_name'] ?? '').toString().toLowerCase();
      final email = (m['email'] ?? '').toString().toLowerCase();
      return firstName.contains(normalizedQuery) ||
          lastName.contains(normalizedQuery) ||
          email.contains(normalizedQuery);
    }).toList();

    // Filter Coaches
    final filteredCoaches = coaches.where((c) {
      final name = (c['name'] ?? '').toString().toLowerCase();
      final specialty = (c['specialty'] ?? '').toString().toLowerCase();
      return name.contains(normalizedQuery) ||
          specialty.contains(normalizedQuery);
    }).toList();

    // Filter Programs
    final filteredPrograms = programs.where((p) {
      final title = (p['title'] ?? '').toString().toLowerCase();
      final description = (p['description'] ?? '').toString().toLowerCase();
      return title.contains(normalizedQuery) ||
          description.contains(normalizedQuery);
    }).toList();

    return GlobalSearchResults(
      members: filteredMembers,
      coaches: filteredCoaches,
      programs: filteredPrograms,
    );
  },
);
