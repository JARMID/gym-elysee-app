import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsRepository {
  Future<Map<String, dynamic>> getRevenueData() async {
    // Mock 6-month revenue data
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'data': [
        {'month': 'Jan', 'amount': 12000.0},
        {'month': 'Feb', 'amount': 14500.0},
        {'month': 'Mar', 'amount': 13800.0},
        {'month': 'Apr', 'amount': 16000.0},
        {'month': 'May', 'amount': 18500.0},
        {'month': 'Jun', 'amount': 22000.0},
      ],
    };
  }

  Future<Map<String, dynamic>> getMembershipGrowth() async {
    // Mock new vs cancelled
    await Future.delayed(const Duration(milliseconds: 600));
    return {
      'data': [
        {'month': 'Jan', 'new': 45, 'cancelled': 5},
        {'month': 'Feb', 'new': 52, 'cancelled': 8},
        {'month': 'Mar', 'new': 38, 'cancelled': 4},
        {'month': 'Apr', 'new': 60, 'cancelled': 10},
        {'month': 'May', 'new': 75, 'cancelled': 6},
        {'month': 'Jun', 'new': 90, 'cancelled': 12},
      ],
    };
  }

  Future<Map<String, dynamic>> getAttendancePatterns() async {
    // Mock weekly peak hours or daily visits
    await Future.delayed(const Duration(milliseconds: 400));
    return {
      'data': [
        {'day': 'Mon', 'visits': 145},
        {'day': 'Tue', 'visits': 132},
        {'day': 'Wed', 'visits': 150},
        {'day': 'Thu', 'visits': 128},
        {'day': 'Fri', 'visits': 160},
        {'day': 'Sat', 'visits': 190},
        {'day': 'Sun', 'visits': 85},
      ],
    };
  }
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});
