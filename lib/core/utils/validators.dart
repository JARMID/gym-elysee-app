class Validators {
  // Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email est requis';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }
  
  // Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mot de passe requis';
    }
    if (value.length < 8) {
      return 'Le mot de passe doit contenir au moins 8 caractères';
    }
    return null;
  }
  
  // Phone validation (Algerian format)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numéro de téléphone requis';
    }
    // Remove spaces and dashes
    final cleaned = value.replaceAll(RegExp(r'[\s-]'), '');
    // Algerian phone: +213 or 0 followed by 9 digits
    final phoneRegex = RegExp(r'^(\+213|0)[567]\d{8}$');
    if (!phoneRegex.hasMatch(cleaned)) {
      return 'Numéro de téléphone algérien invalide';
    }
    return null;
  }
  
  // Required field
  static String? required(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }
  
  // Name validation
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Le nom est requis';
    }
    if (value.trim().length < 2) {
      return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
  }
  
  // Date validation (must be at least 16 years old)
  static String? birthDate(DateTime? value) {
    if (value == null) {
      return 'Date de naissance requise';
    }
    final age = DateTime.now().difference(value).inDays ~/ 365;
    if (age < 16) {
      return 'Vous devez avoir au moins 16 ans';
    }
    if (age > 100) {
      return 'Date de naissance invalide';
    }
    return null;
  }
  
  // OTP validation (6 digits)
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Code OTP requis';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Code OTP invalide (6 chiffres)';
    }
    return null;
  }
  
  // Positive number validation
  static String? positiveNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) {
      return 'Doit être un nombre positif';
    }
    return null;
  }
}

