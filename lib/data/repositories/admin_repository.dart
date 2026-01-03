import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';
import '../../presentation/providers/branch_provider.dart'; // For apiServiceProvider

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.read(apiServiceProvider));
});

class AdminRepository {
  final ApiService _apiService;

  AdminRepository(this._apiService);

  // --- DASHBOARD ---

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await _apiService.get(ApiConstants.adminDashboard);
      final data = response.data;
      // API returns {stats: {total_members: ..., today_bookings: ..., etc}}
      if (data is Map && data.containsKey('stats')) {
        return Map<String, dynamic>.from(data['stats']);
      }
      return data;
    } catch (e) {
      return {
        'total_members': 0,
        'today_bookings': 0,
        'pending_payments': 0,
        'active_subscriptions': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getPendingPayments() async {
    try {
      final response = await _apiService.get(ApiConstants.adminPaymentsPending);
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<void> validatePayment(int paymentId) async {
    await _apiService.post(ApiConstants.validatePayment(paymentId));
  }

  Future<void> rejectPayment(int paymentId) async {
    await _apiService.post(ApiConstants.rejectPayment(paymentId));
  }

  Future<void> addMember(Map<String, dynamic> memberData) async {
    await _apiService.post(ApiConstants.adminMembers, data: memberData);
  }

  Future<void> updateMember(int id, Map<String, dynamic> data) async {
    await _apiService.put('${ApiConstants.adminMembers}/$id', data: data);
  }

  Future<void> deleteMember(int id) async {
    await _apiService.delete('${ApiConstants.adminMembers}/$id');
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    await _apiService.post(ApiConstants.posts, data: postData);
  }

  Future<List<Map<String, dynamic>>> getPendingPosts() async {
    try {
      final response = await _apiService.get(ApiConstants.adminPostsPending);
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<void> approvePost(int postId) async {
    await _apiService.post(ApiConstants.approvePost(postId));
  }

  Future<void> rejectPost(int postId) async {
    await _apiService.post(ApiConstants.rejectPost(postId));
  }

  // Members
  Future<List<Map<String, dynamic>>> getAllMembers() async {
    try {
      final response = await _apiService.get(ApiConstants.adminMembers);
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  // Coaches
  Future<List<Map<String, dynamic>>> getAllCoaches() async {
    try {
      final response = await _apiService.get(ApiConstants.adminCoaches);
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<void> addCoach(Map<String, dynamic> coachData) async {
    await _apiService.post(ApiConstants.adminCoaches, data: coachData);
  }

  Future<void> deleteCoach(int coachId) async {
    await _apiService.delete('${ApiConstants.adminCoaches}/$coachId');
  }

  Future<void> updateCoach(int id, Map<String, dynamic> data) async {
    await _apiService.put('${ApiConstants.adminCoaches}/$id', data: data);
  }

  // Programs
  Future<List<Map<String, dynamic>>> getAllPrograms() async {
    try {
      final response = await _apiService.get(ApiConstants.adminPrograms);
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteProgram(int programId) async {
    await _apiService.delete('${ApiConstants.adminPrograms}/$programId');
  }

  Future<void> createProgram(Map<String, dynamic> data) async {
    await _apiService.post(ApiConstants.adminPrograms, data: data);
  }

  Future<void> updateProgram(int id, Map<String, dynamic> data) async {
    await _apiService.put('${ApiConstants.adminPrograms}/$id', data: data);
  }

  // Branches
  Future<List<Map<String, dynamic>>> getAllBranches() async {
    try {
      final response = await _apiService.get(ApiConstants.adminBranches);
      final data = response.data;
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteBranch(int branchId) async {
    await _apiService.delete('${ApiConstants.adminBranches}/$branchId');
  }

  Future<void> createBranch(Map<String, dynamic> data) async {
    await _apiService.post(ApiConstants.adminBranches, data: data);
  }

  Future<void> updateBranch(int id, Map<String, dynamic> data) async {
    await _apiService.put('${ApiConstants.adminBranches}/$id', data: data);
  }

  // Payments
  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    try {
      final response = await _apiService.get(ApiConstants.adminPaymentsHistory);
      final data = response.data;
      // Handle paginated response with 'data' key
      if (data is Map && data.containsKey('data')) {
        return List<Map<String, dynamic>>.from(data['data']);
      }
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      // Return empty list on error - UI will show "no payments"
      return [];
    }
  }
}
