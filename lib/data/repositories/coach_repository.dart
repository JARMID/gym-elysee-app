import '../services/api_service.dart';
import '../models/member_model.dart';
import '../models/program_model.dart';

class CoachRepository {
  final ApiService _apiService;

  CoachRepository(this._apiService);

  /// Get coach dashboard data
  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiService.get('/coach/dashboard');
    return response.data as Map<String, dynamic>;
  }

  /// Get coach's squad (students)
  Future<List<MemberModel>> getSquad() async {
    final response = await _apiService.get('/coach/squad');
    final data = response.data;
    if (data is List) {
      return data.map((e) => MemberModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Get coach's programs
  Future<List<ProgramModel>> getPrograms() async {
    final response = await _apiService.get('/coach/programs');
    final data = response.data;
    if (data is List) {
      return data.map((e) => ProgramModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Create a new program
  Future<ProgramModel> createProgram(Map<String, dynamic> programData) async {
    final response = await _apiService.post(
      '/coach/programs',
      data: programData,
    );
    return ProgramModel.fromJson(response.data);
  }

  /// Update an existing program
  Future<ProgramModel> updateProgram(
    int programId,
    Map<String, dynamic> programData,
  ) async {
    final response = await _apiService.put(
      '/coach/programs/$programId',
      data: programData,
    );
    return ProgramModel.fromJson(response.data);
  }

  /// Delete a program
  Future<void> deleteProgram(int programId) async {
    await _apiService.delete('/coach/programs/$programId');
  }

  /// Get coach's bookings with optional filters
  Future<Map<String, dynamic>> getBookings({
    String? status,
    String? from,
    String? to,
  }) async {
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;

    final response = await _apiService.get(
      '/coach/bookings',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }

  /// Update a booking status
  Future<Map<String, dynamic>> updateBooking(
    int bookingId, {
    required String status,
    String? notes,
  }) async {
    final response = await _apiService.put(
      '/coach/bookings/$bookingId',
      data: {'status': status, if (notes != null) 'notes': notes},
    );
    return response.data as Map<String, dynamic>;
  }

  /// Get coach's weekly schedule
  Future<Map<String, dynamic>> getSchedule({
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;

    final response = await _apiService.get(
      '/coach/schedule',
      queryParameters: queryParams,
    );
    return response.data as Map<String, dynamic>;
  }
}
