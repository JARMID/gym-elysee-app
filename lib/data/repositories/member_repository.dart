import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../services/api_service.dart';

class MemberRepository {
  final ApiService _apiService;

  MemberRepository(this._apiService);

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _apiService.get('/member/dashboard');
    return response.data;
  }

  Future<Map<String, dynamic>> getSecureQRCode() async {
    try {
      final response = await _apiService.get('/member/qr-code');
      return response.data;
    } catch (e) {
      throw const ServerException();
    }
  }

  Future<Map<String, dynamic>> checkIn(String qrCode, int branchId) async {
    try {
      final response = await _apiService.post(
        '/member/check-in',
        data: {'qr_code': qrCode, 'branch_id': branchId},
      );
      return response.data;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 403) {
        throw e.response?.data['error'] ?? 'Check-in failed';
      }
      throw const ServerException();
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    int memberId,
    Map<String, dynamic> data,
    XFile? photo,
  ) async {
    FormData payload;

    if (photo != null) {
      final bytes = await photo.readAsBytes();
      final filename = photo.name;

      payload = FormData.fromMap({
        ...data,
        'photo': MultipartFile.fromBytes(bytes, filename: filename),
        '_method': 'POST',
      });

      return (await _apiService.post('/member/profile', data: payload)).data;
    } else {
      return (await _apiService.post('/member/profile', data: data)).data;
    }
  }
}
