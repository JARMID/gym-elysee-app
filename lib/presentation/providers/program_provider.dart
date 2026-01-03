import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/program_model.dart';
import '../../data/repositories/supabase_core_repository.dart';
import 'branch_provider.dart'; // Pour utiliser supabaseCoreRepositoryProvider

// Provider pour charger tous les programmes (now uses Supabase)
final programsProvider = FutureProvider<List<ProgramModel>>((ref) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return await repository.getPrograms();
});

// Provider pour charger les programmes avec filtres
final programsFilteredProvider =
    FutureProvider.family<List<ProgramModel>, Map<String, dynamic>>((
      ref,
      filters,
    ) async {
      final repository = ref.watch(supabaseCoreRepositoryProvider);
      return await repository.getPrograms(
        branchId: filters['branch_id'] as int?,
        type: filters['type'] as String?,
        level: filters['level'] as String?,
      );
    });

// Provider pour charger un programme spécifique
final programProvider = FutureProvider.family<ProgramModel, int>((
  ref,
  programId,
) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return await repository.getProgramById(programId);
});

// Provider pour charger les programmes de l'utilisateur
final myProgramsProvider = FutureProvider<List<ProgramModel>>((ref) async {
  final repository = ref.watch(supabaseCoreRepositoryProvider);
  return await repository.getMyPrograms();
});

// Controller pour l'inscription
final enrollControllerProvider =
    StateNotifierProvider<EnrollController, AsyncValue<void>>((ref) {
      return EnrollController(ref.watch(supabaseCoreRepositoryProvider), ref);
    });

class EnrollController extends StateNotifier<AsyncValue<void>> {
  final SupabaseCoreRepository _repository;
  final Ref _ref;

  EnrollController(this._repository, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> enroll(int programId) async {
    state = const AsyncValue.loading();
    try {
      await _repository.enrollProgram(programId);
      state = const AsyncValue.data(null);
      // Rafraichir la liste des "Mes programmes"
      _ref.invalidate(myProgramsProvider);
      // Rafraichir le détail du programme (pour le compteur)
      _ref.invalidate(programProvider(programId));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
