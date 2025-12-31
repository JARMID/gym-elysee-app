import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/program_model.dart';
import '../services/api_service.dart';

class ProgramRepository {
  final ApiService _apiService;

  ProgramRepository(this._apiService);

  /// Récupère tous les programmes (avec filtres optionnels)
  Future<List<ProgramModel>> getPrograms({
    int? branchId,
    String? type,
    String? level,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (branchId != null) queryParams['branch_id'] = branchId;
      if (type != null) queryParams['type'] = type;
      if (level != null) queryParams['level'] = level;

      final response = await _apiService.get(
        ApiConstants.programs,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        // Handle Laravel pagination response (data is wrapped in 'data' key)
        final dynamic responseData = response.data;
        final List<dynamic> data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          // Paginated response: {data: [...], per_page: 20, total: X, ...}
          data = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          // Direct list response
          data = responseData;
        } else {
          data = [];
        }

        return data.map((json) => ProgramModel.fromJson(json)).toList();
      }

      throw const ServerException();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }

  /// Récupère un programme par ID
  Future<ProgramModel> getProgramById(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.programDetail(id));

      if (response.statusCode == 200) {
        return ProgramModel.fromJson(response.data);
      }

      throw const NotFoundException();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }

  /// S'inscrire à un programme
  Future<void> enrollProgram(int programId) async {
    try {
      final response = await _apiService.post(
        ApiConstants.enrollProgram(programId),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw const ServerException();
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }

  /// Récupère les programmes de l'utilisateur connecté
  Future<List<ProgramModel>> getMyPrograms() async {
    try {
      final response = await _apiService.get(ApiConstants.memberPrograms);

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final List<dynamic> data;

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data')) {
          data = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          data = responseData;
        } else {
          data = [];
        }

        return data.map((json) => ProgramModel.fromJson(json)).toList();
      }

      throw const ServerException();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }
}
