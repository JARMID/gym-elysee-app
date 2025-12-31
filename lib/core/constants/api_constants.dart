class ApiConstants {
  // Base URL - Local development
  // For iOS Simulator: use localhost
  // For Android Emulator: use 10.0.2.2 (Android emulator localhost)
  // For Physical Device: use your computer's IP (e.g., 192.168.1.100)
  //
  // IMPORTANT: Change this based on your setup:
  // - iOS Simulator: http://localhost:8000/api
  // - Android Emulator: http://10.0.2.2:8000/api
  // - Physical Device: http://YOUR_IP:8000/api (find IP with: ipconfig on Windows, ifconfig on Mac/Linux)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Alternative URLs (uncomment if needed):
  // static const String baseUrl = 'http://localhost:8000/api'; // iOS Simulator
  // static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
  // static const String baseUrl = 'http://192.168.1.100:8000/api'; // Physical device (replace with your IP)

  // Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Member endpoints
  static const String memberDashboard = '/member/dashboard';
  static const String memberQRCode = '/member/qr-code';
  static const String memberCheckIn = '/member/check-in';
  static const String memberStats = '/member/stats';
  static const String memberBookings = '/member/bookings';
  static const String memberPrograms = '/member/programs';
  static const String memberSubscription = '/member/subscription';

  // Programs endpoints
  static const String programs = '/programs';
  static String programDetail(int id) => '/programs/$id';
  static String enrollProgram(int id) => '/programs/$id/enroll';

  // Bookings endpoints
  static const String bookings = '/bookings';
  static const String availableBookings = '/bookings/available';
  static String cancelBooking(int id) => '/bookings/$id';

  // Social endpoints
  static const String feed = '/feed';
  static const String posts = '/posts';
  static String likePost(int id) => '/posts/$id/like';
  static String postComments(int id) => '/posts/$id/comments';
  static const String sparringPartners = '/sparring-partners';
  static const String sparringRequests = '/sparring-requests';

  // Messages endpoints
  static const String messages = '/messages';
  static String messageThread(int userId) => '/messages/$userId';

  // Payments endpoints
  static const String payments = '/payments';
  static const String paymentMethods = '/payment-methods';
  static String validatePayment(int id) => '/admin/payments/$id/validate';
  static String rejectPayment(int id) => '/admin/payments/$id/reject';

  // Branches endpoints
  static const String branches = '/branches';
  static String branchDetail(int id) => '/branches/$id';

  // Admin endpoints
  static const String adminDashboard = '/admin/dashboard';
  static const String adminMembers = '/admin/members';
  static const String adminCoaches = '/admin/coaches';
  static const String adminBranches = '/admin/branches';
  static const String adminPaymentsPending = '/admin/payments/pending';
  static const String adminPaymentsHistory = '/admin/payments/history';
  static const String adminPrograms = '/admin/programs';
  static const String adminPostsPending = '/admin/posts/pending';
  static String approvePost(int id) => '/admin/posts/$id/approve';
  static String rejectPost(int id) => '/admin/posts/$id/reject';

  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  static const String accept = 'Accept';
  static const String bearer = 'Bearer';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
