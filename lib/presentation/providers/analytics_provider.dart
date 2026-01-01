import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/analytics_repository.dart';

part 'analytics_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> revenueData(RevenueDataRef ref) {
  return ref.watch(analyticsRepositoryProvider).getRevenueData();
}

@riverpod
Future<Map<String, dynamic>> membershipGrowth(MembershipGrowthRef ref) {
  return ref.watch(analyticsRepositoryProvider).getMembershipGrowth();
}

@riverpod
Future<Map<String, dynamic>> attendancePatterns(AttendancePatternsRef ref) {
  return ref.watch(analyticsRepositoryProvider).getAttendancePatterns();
}
