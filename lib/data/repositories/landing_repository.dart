import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/branch_model.dart';

class LandingRepository {
  final Dio _dio;

  LandingRepository(this._dio);

  Future<List<BranchModel>> getBranches() async {
    try {
      debugPrint('[LandingRepository] Fetching branches from /branches...');
      final response = await _dio.get('/branches');
      debugPrint(
        '[LandingRepository] Response received: ${response.statusCode}',
      );

      if (response.data == null) {
        debugPrint('[LandingRepository] Response data is null');
        return [];
      }

      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['data'] as List? ?? []);

      debugPrint('[LandingRepository] Parsed ${data.length} branches');

      return data
          .map((json) {
            try {
              if (json is Map<String, dynamic>) {
                // Safety fix: Convert lat/long strings to doubles if needed
                if (json['latitude'] is String) {
                  json['latitude'] = double.tryParse(json['latitude']);
                }
                if (json['longitude'] is String) {
                  json['longitude'] = double.tryParse(json['longitude']);
                }

                // Safety fix: Ensure equipment is List<String>
                if (json['equipment'] is Map) {
                  json['equipment'] = (json['equipment'] as Map).values
                      .toList();
                } else if (json['equipment'] is List) {
                  json['equipment'] = (json['equipment'] as List)
                      .map((e) => e is String ? e : e.toString())
                      .toList();
                }

                // Safety fix: Ensure photos is List<String>
                if (json['photos'] is Map) {
                  json['photos'] = (json['photos'] as Map).values.toList();
                } else if (json['photos'] is List) {
                  json['photos'] = (json['photos'] as List)
                      .map((e) => e is String ? e : e.toString())
                      .toList();
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
              }
              return null;
            } catch (e) {
              debugPrint('[LandingRepository] Error parsing branch: $e');
              return null;
            }
          })
          .whereType<BranchModel>()
          .toList();
    } catch (e, stack) {
      debugPrint('[LandingRepository] ERROR fetching branches: $e');
      debugPrint('[LandingRepository] Stack: $stack');
      return [];
    }
  }

  Future<List<dynamic>> getFeaturedCoaches() async {
    try {
      final response = await _dio.get('/coaches/featured');
      return response.data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getMembershipPlans() async {
    try {
      final response = await _dio.get('/plans');
      return response.data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  Future<void> submitContact(Map<String, dynamic> data) async {
    try {
      await _dio.post('/contact', data: data);
    } catch (e) {
      throw Exception('Failed to submit contact form: $e');
    }
  }

  Future<void> requestVisit(Map<String, dynamic> data) async {
    try {
      await _dio.post('/visit-request', data: data);
    } catch (e) {
      throw Exception('Failed to request visit: $e');
    }
  }
}
