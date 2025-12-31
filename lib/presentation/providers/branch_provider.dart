import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/branch_model.dart';
import '../../data/repositories/branch_repository.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';

// Provider pour StorageService (doit être overridé dans main.dart)
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in main.dart');
});

// Provider pour ApiService
final apiServiceProvider = Provider<ApiService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiService(storageService);
});

// Provider pour BranchRepository
final branchRepositoryProvider = Provider<BranchRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return BranchRepository(apiService);
});

// Provider pour charger toutes les branches
final branchesProvider = FutureProvider<List<BranchModel>>((ref) async {
  final repository = ref.watch(branchRepositoryProvider);
  return await repository.getBranches();
});

// Provider pour charger une branche spécifique
final branchProvider = FutureProvider.family<BranchModel, int>((ref, branchId) async {
  final repository = ref.watch(branchRepositoryProvider);
  return await repository.getBranchById(branchId);
});
