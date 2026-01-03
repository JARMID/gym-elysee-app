import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/branch_model.dart';
import '../../data/repositories/supabase_core_repository.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';

// Provider pour StorageService (doit être overridé dans main.dart)
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in main.dart');
});

// LEGACY: Provider pour ApiService (still used by some old repositories)
// TODO: Migrate remaining providers to Supabase and remove this
final apiServiceProvider = Provider<ApiService>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return ApiService(storageService);
});

// Provider pour SupabaseCoreRepository (new Supabase-based repos)
final supabaseCoreRepositoryProvider = Provider<SupabaseCoreRepository>((ref) {
  return SupabaseCoreRepository(Supabase.instance.client);
});

// Provider pour charger toutes les branches (now uses Supabase)
final branchesProvider = FutureProvider<List<BranchModel>>((ref) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return await repository.getBranches();
});

// Provider pour charger une branche spécifique
final branchProvider = FutureProvider.family<BranchModel, int>((
  ref,
  branchId,
) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return await repository.getBranchById(branchId);
});
