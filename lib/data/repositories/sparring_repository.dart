import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';
import '../models/member_model.dart';
import '../models/sparring_request_model.dart';

class SparringRepository {
  final ApiService _apiService;

  SparringRepository(this._apiService);

  Future<List<MemberModel>> findPartners({
    int? branchId,
    String? discipline,
    String? level,
  }) async {
    final response = await _apiService.get(
      ApiConstants.sparringPartners,
      queryParameters: {
        if (branchId != null) 'branch_id': branchId,
        if (discipline != null) 'discipline': discipline,
        if (level != null) 'level': level,
      },
    );

    return (response.data['data'] as List)
        .map((e) => MemberModel.fromJson(e))
        .toList();
  }

  Future<SparringRequestModel> createRequest({
    required int requestedId,
    required int branchId,
    String? discipline,
    DateTime? proposedTime,
    String? message,
  }) async {
    final response = await _apiService.post(
      ApiConstants.sparringRequests,
      data: {
        'requested_id': requestedId,
        'branch_id': branchId,
        if (discipline != null) 'discipline': discipline,
        if (proposedTime != null)
          'proposed_time': proposedTime.toIso8601String(),
        if (message != null) 'message': message,
      },
    );

    return SparringRequestModel.fromJson(response.data);
  }

  Future<SparringRequestModel> respondToRequest(
    int requestId,
    String action,
  ) async {
    // action should be 'accept' or 'reject'
    final response = await _apiService.post(
      '${ApiConstants.sparringRequests}/$requestId/respond',
      data: {'action': action},
    );
    return SparringRequestModel.fromJson(response.data['request']);
  }

  Future<List<SparringRequestModel>> getMyRequests() async {
    // This endpoint may not exist yet in backend, but structure for future
    final response = await _apiService.get(
      '${ApiConstants.sparringRequests}/my',
    );
    return (response.data['data'] as List)
        .map((e) => SparringRequestModel.fromJson(e))
        .toList();
  }
}
