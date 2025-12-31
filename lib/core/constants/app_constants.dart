class AppConstants {
  // App Info
  static const String appName = 'GYM ÉLYSÉE DZ';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String ramadanModeKey = 'ramadan_mode';
  static const String languageKey = 'app_language';
  static const String onboardingKey = 'onboarding_completed';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload Limits
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB
  
  // Validation Limits
  static const int minPasswordLength = 8;
  static const int maxBioLength = 500;
  static const int maxPostLength = 500;
  
  // QR Code Format
  static const String qrCodePrefix = 'ELYSEE';
  static const int qrCodeValidMinutes = 5; // QR code expires after 5 minutes
  
  // Booking Rules
  static const int maxBookingAdvanceDays = 30;
  static const int minCancelHours = 24; // Must cancel at least 24h before
  
  // Workout
  static const int defaultRestSeconds = 60;
  static const int minRestSeconds = 10;
  static const int maxRestSeconds = 300;
  
  // Stats
  static const int statsDaysToShow = 30;
  static const int attendanceGoalDays = 3; // Goal: 3 days per week
  
  // Subscription Types
  static const List<String> subscriptionTypes = [
    'monthly',
    'quarterly',
    'biannual',
    'annual',
  ];
  
  // Payment Methods
  static const List<String> paymentMethods = [
    'edahabia',
    'cib',
    'baridimob',
    'cash',
    'bank_transfer',
  ];
  
  // Branch Types
  static const List<String> branchTypes = [
    'flagship',
    'boxing',
    'mma',
    'grappling',
    'women',
    'performance',
  ];
  
  // Program Types
  static const List<String> programTypes = [
    'strength',
    'cardio',
    'boxing',
    'mma',
    'grappling',
    'hybrid',
  ];
  
  // User Levels
  static const List<String> userLevels = [
    'beginner',
    'intermediate',
    'advanced',
    'pro',
  ];
  
  // Booking Types
  static const List<String> bookingTypes = [
    'group_class',
    'private_session',
    'sparring',
    'assessment',
  ];
}

