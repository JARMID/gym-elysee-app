import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository.dart';

// Dashboard Stats Provider
final adminStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getDashboardStats();
});

// Pending Payments Provider
final pendingPaymentsProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getPendingPayments();
});

// Pending Posts Provider
final pendingPostsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getPendingPosts();
    });

// All Members Provider
final adminMembersProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getAllMembers();
    });

// All Coaches Provider
final adminCoachesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getAllCoaches();
    });

// All Programs Provider
final adminProgramsProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getAllPrograms();
    });

// All Branches Provider
final adminBranchesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getAllBranches();
    });

// Payment History Provider
final adminPaymentHistoryProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final repository = ref.read(adminRepositoryProvider);
      return repository.getPaymentHistory();
    });

// Admin Controller for Actions
final adminControllerProvider =
    StateNotifierProvider<AdminController, AsyncValue<void>>((ref) {
      return AdminController(ref.read(adminRepositoryProvider));
    });

class AdminController extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repository;

  AdminController(this._repository) : super(const AsyncValue.data(null));

  Future<void> validatePayment(int paymentId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.validatePayment(paymentId),
    );
  }

  Future<void> addMember(Map<String, dynamic> memberData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.addMember(memberData));
  }

  Future<void> updateMember(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.updateMember(id, data));
  }

  Future<void> deleteMember(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteMember(id));
  }

  Future<void> createPost(Map<String, dynamic> postData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.createPost(postData));
  }

  Future<void> approvePost(int postId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.approvePost(postId));
  }

  Future<void> rejectPost(int postId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.rejectPost(postId));
  }

  Future<void> addCoach(Map<String, dynamic> coachData) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.addCoach(coachData));
  }

  Future<void> updateCoach(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.updateCoach(id, data));
  }

  Future<void> deleteCoach(int coachId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteCoach(coachId));
  }

  Future<void> deleteProgram(int programId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteProgram(programId));
  }

  Future<void> createProgram(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.createProgram(data));
  }

  Future<void> updateProgram(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.updateProgram(id, data));
  }

  Future<void> deleteBranch(int branchId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.deleteBranch(branchId));
  }

  Future<void> createBranch(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.createBranch(data));
  }

  Future<void> updateBranch(int id, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.updateBranch(id, data));
  }
}
