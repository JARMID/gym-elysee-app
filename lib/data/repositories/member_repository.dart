import 'dart:io';
import 'package:dio/dio.dart';
import '../services/api_service.dart';

class MemberRepository {
  final ApiService _apiService;

  MemberRepository(this._apiService);

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiService.get('/member/dashboard');
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfile(
    int memberId,
    Map<String, dynamic> data,
    File? photo,
  ) async {
    FormData payload;

    if (photo != null) {
      payload = FormData.fromMap({
        ...data,
        'photo': await MultipartFile.fromFile(photo.path),
        '_method': 'POST', // Use POST for update profile logic
      });
      // The route will be /api/member/profile which is POST
      return (await _apiService.post(
        '/member/profile', // Using the self-update route
        data: payload,
      )).data;
    } else {
      // If no photo, just send data as JSON or FormData
      // Ideally reuse the same route /member/profile
      return (await _apiService.post('/member/profile', data: data)).data;
    }
  }
}
