import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';

class QRCodeGenerator {
  static const _uuid = Uuid();
  
  /// Génère un QR code unique pour un membre
  /// Format: ELYSEE-{memberId}-{hash}-{timestamp}
  static String generateMemberQRCode(int memberId) {
    final hash = _uuid.v4().replaceAll('-', '').substring(0, 16);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${AppConstants.qrCodePrefix}-$memberId-$hash-$timestamp';
  }
  
  /// Valide le format d'un QR code
  static bool isValidQRCode(String qrCode) {
    if (!qrCode.startsWith(AppConstants.qrCodePrefix)) {
      return false;
    }
    
    final parts = qrCode.split('-');
    if (parts.length < 4) {
      return false;
    }
    
    // Vérifier que le memberId est un nombre
    final memberId = int.tryParse(parts[1]);
    if (memberId == null) {
      return false;
    }
    
    return true;
  }
  
  /// Extrait le memberId d'un QR code
  static int? extractMemberId(String qrCode) {
    if (!isValidQRCode(qrCode)) {
      return null;
    }
    
    final parts = qrCode.split('-');
    return int.tryParse(parts[1]);
  }
  
  /// Vérifie si un QR code est expiré (basé sur le timestamp)
  static bool isExpired(String qrCode, {int validMinutes = 5}) {
    final parts = qrCode.split('-');
    if (parts.length < 4) {
      return true;
    }
    
    final timestamp = int.tryParse(parts[3]);
    if (timestamp == null) {
      return true;
    }
    
    final qrDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final expiryDate = qrDate.add(Duration(minutes: validMinutes));
    
    return DateTime.now().isAfter(expiryDate);
  }
}

