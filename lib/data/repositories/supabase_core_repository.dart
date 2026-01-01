import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../core/errors/exceptions.dart';
import '../models/branch_model.dart';
import '../models/program_model.dart';
import '../models/membership_plan_model.dart';

/// Supabase-based repository for core data (Branches, Programs, Plans)
/// This can coexist with Laravel-based repositories during migration
class SupabaseCoreRepository {
  final sb.SupabaseClient _client;

  SupabaseCoreRepository(this._client);

  // ============ BRANCHES ============

  /// Get all branches from Supabase
  Future<List<BranchModel>> getBranches() async {
    try {
      final response = await _client.from('branches').select('''
        *,
        manager:profiles!manager_id(first_name, last_name)
      ''');

      return (response as List)
          .map((json) => _parseBranchFromSupabase(json))
          .toList();
    } catch (e) {
      throw const ServerException();
    }
  }

  /// Get branch by ID from Supabase
  Future<BranchModel> getBranchById(int id) async {
    try {
      final response = await _client
          .from('branches')
          .select('''
        *,
        manager:profiles!manager_id(first_name, last_name),
        programs(*)
      ''')
          .eq('id', id)
          .single();

      return _parseBranchFromSupabase(response);
    } catch (e) {
      throw const NotFoundException();
    }
  }

  // ============ PROGRAMS ============

  /// Get all programs with optional filters
  Future<List<ProgramModel>> getPrograms({
    int? branchId,
    String? type,
    String? level,
  }) async {
    try {
      var query = _client.from('programs').select('''
        *,
        coach:profiles!coach_id(first_name, last_name, avatar_url),
        branch:branches!branch_id(name)
      ''');

      if (branchId != null) query = query.eq('branch_id', branchId);
      if (type != null) query = query.eq('type', type);
      if (level != null) query = query.eq('level', level);

      final response = await query;

      return (response as List)
          .map((json) => _parseProgramFromSupabase(json))
          .toList();
    } catch (e) {
      throw const ServerException();
    }
  }

  /// Get program by ID
  Future<ProgramModel> getProgramById(int id) async {
    try {
      final response = await _client
          .from('programs')
          .select('''
        *,
        coach:profiles!coach_id(first_name, last_name, avatar_url),
        branch:branches!branch_id(name)
      ''')
          .eq('id', id)
          .single();

      return _parseProgramFromSupabase(response);
    } catch (e) {
      throw const NotFoundException();
    }
  }

  /// Enroll user in a program (creates booking)
  Future<void> enrollProgram(int programId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthException();

    try {
      await _client.from('bookings').insert({
        'user_id': userId,
        'program_id': programId,
        'booking_date': DateTime.now().toIso8601String(),
        'status': 'confirmed',
      });
    } catch (e) {
      throw const ServerException();
    }
  }

  /// Get programs the current user is enrolled in
  Future<List<ProgramModel>> getMyPrograms() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw const AuthException();

    try {
      final response = await _client
          .from('bookings')
          .select('''
        program:programs!program_id(
          *,
          coach:profiles!coach_id(first_name, last_name, avatar_url),
          branch:branches!branch_id(name)
        )
      ''')
          .eq('user_id', userId);

      return (response as List)
          .map((booking) => _parseProgramFromSupabase(booking['program']))
          .toList();
    } catch (e) {
      throw const ServerException();
    }
  }

  // ============ MEMBERSHIP PLANS ============

  /// Get all membership plans
  Future<List<MembershipPlanModel>> getMembershipPlans() async {
    try {
      final response = await _client
          .from('membership_plans')
          .select()
          .order('price');

      return (response as List)
          .map((json) => MembershipPlanModel.fromJson(json))
          .toList();
    } catch (e) {
      throw const ServerException();
    }
  }

  /// Get membership plan by ID
  Future<MembershipPlanModel> getMembershipPlanById(int id) async {
    try {
      final response = await _client
          .from('membership_plans')
          .select()
          .eq('id', id)
          .single();

      return MembershipPlanModel.fromJson(response);
    } catch (e) {
      throw const NotFoundException();
    }
  }

  // ============ HELPER PARSERS ============

  /// Parse Branch data from Supabase (map PostgreSQL schema to BranchModel)
  BranchModel _parseBranchFromSupabase(Map<String, dynamic> json) {
    // Convert Supabase format to BranchModel expected format
    return BranchModel(
      id: json['id'],
      name: json['name'],
      type: 'flagship', // Default for now, or map from a column
      description: json['description'] ?? '',
      address: json['location'] ?? '',
      city: json['location'] ?? '',
      wilaya: json['location'] ?? '',
      latitude: null,
      longitude: null,
      phone: '023 XX XX XX', // Default, update schema if needed
      openingHours: _parseOpeningHours(json['opening_hours']),
      ramadanHours: null,
      capacity: 100, // Default
      equipment: (json['facilities'] as List?)?.cast<String>() ?? [],
      photos: json['image_url'] != null ? [json['image_url']] : [],
      isActive: true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.now(),
      tags: null,
      coaches: null,
      programs: null,
    );
  }

  /// Parse Program data from Supabase
  ProgramModel _parseProgramFromSupabase(Map<String, dynamic> json) {
    final coach = json['coach'] as Map<String, dynamic>?;
    final branch = json['branch'] as Map<String, dynamic>?;

    return ProgramModel(
      id: json['id'],
      name: json['title'] ?? '',
      description: json['description'] ?? '',
      coachId: json['coach_id'],
      coachName: coach != null
          ? '${coach['first_name']} ${coach['last_name']}'
          : 'Unknown',
      coachPhoto: coach?['avatar_url'],
      branchId: json['branch_id'],
      branchName: branch?['name'] ?? 'Unknown',
      type: 'fitness', // Default
      level: json['level'] ?? 'beginner',
      durationWeeks: 12, // Default
      sessionsPerWeek: 3, // Default
      coverImage: json['image_url'],
      rating: 4.5, // Default
      enrolledCount: 0,
      isPublic: true,
      price: 0.0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.now(),
    );
  }

  /// Parse opening hours from JSONB
  Map<String, String> _parseOpeningHours(dynamic hoursJson) {
    if (hoursJson == null) return {};
    if (hoursJson is Map) {
      return (hoursJson as Map<String, dynamic>).map(
        (k, v) => MapEntry(k, v.toString()),
      );
    }
    return {};
  }
}
