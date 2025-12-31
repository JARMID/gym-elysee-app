import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/api_constants.dart';
import '../services/api_service.dart';
import '../models/payment_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository(this._apiService);

  Future<PaymentModel> uploadPaymentProof({
    required XFile proofFile,
    required double amount,
    required String method,
    int? subscriptionId,
    Map<String, dynamic>? installmentPlan,
  }) async {
    final bytes = await proofFile.readAsBytes();
    final fileName = proofFile.name;
    final mimeType = lookupMimeType(fileName);

    final formData = FormData.fromMap({
      'amount': amount,
      'method': method,
      if (subscriptionId != null) 'subscription_id': subscriptionId,
      if (installmentPlan != null) 'installment_plan': installmentPlan,
      'proof_file': MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: mimeType != null ? MediaType.parse(mimeType) : null,
      ),
    });

    final response = await _apiService.post(
      ApiConstants.payments,
      data: formData,
    );

    return PaymentModel.fromJson(response.data);
  }

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final response = await _apiService.get(ApiConstants.paymentMethods);
    return List<Map<String, dynamic>>.from(response.data['methods']);
  }
}
