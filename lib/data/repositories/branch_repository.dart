import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/branch_model.dart';
import '../services/api_service.dart';

class BranchRepository {
  final ApiService _apiService;

  BranchRepository(this._apiService);

  /// Récupère toutes les branches
  Future<List<BranchModel>> getBranches() async {
    try {
      final response = await _apiService.get(ApiConstants.branches);

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final List<dynamic> data = responseData is List
            ? responseData
            : (responseData['data'] as List? ?? []);

        return data
            .map((json) {
              try {
                // Sanitize Laravel Map/List issues
                if (json['equipment'] is Map) {
                  json['equipment'] = (json['equipment'] as Map).values
                      .toList();
                }
                if (json['photos'] is Map) {
                  json['photos'] = (json['photos'] as Map).values.toList();
                }

                // Safety fix: Ensure opening_hours is Map<String, String>
                // The API may return {day: {open: time, close: time}} instead of {day: "time - time"}
                if (json['opening_hours'] is Map) {
                  final rawHours = json['opening_hours'] as Map;
                  final fixedHours = <String, String>{};
                  for (final entry in rawHours.entries) {
                    if (entry.value is String) {
                      fixedHours[entry.key.toString()] = entry.value as String;
                    } else if (entry.value is Map) {
                      // Convert {open: "08:00", close: "22:00"} to "08:00 - 22:00"
                      final nested = entry.value as Map;
                      final open = nested['open']?.toString() ?? '';
                      final close = nested['close']?.toString() ?? '';
                      fixedHours[entry.key.toString()] = '$open - $close';
                    } else {
                      fixedHours[entry.key.toString()] = entry.value.toString();
                    }
                  }
                  json['opening_hours'] = fixedHours;
                }

                return BranchModel.fromJson(json);
              } catch (e, stack) {
                // ignore: avoid_print
                print('Error parsing branch: $e');
                // ignore: avoid_print
                print(stack);
                return null;
              }
            })
            .whereType<BranchModel>()
            .toList();
      }

      throw const ServerException();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }

  /// Récupère une branche par ID
  Future<BranchModel> getBranchById(int id) async {
    try {
      final response = await _apiService.get(ApiConstants.branchDetail(id));

      if (response.statusCode == 200) {
        return BranchModel.fromJson(response.data);
      }

      throw const NotFoundException();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const NetworkException();
    }
  }
}
